#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  # https://github.com/piotrmurach/tty-prompt
  gem "tty-prompt"
  # https://github.com/piotrmurach/tty-command
  gem "tty-command", github: "justingaylor/tty-command",
    branch: "fixDoubleSplatRuby3"
  # https://github.com/piotrmurach/tty-file
  gem "tty-file"
  gem "tty-table"
  gem "pry"
end

module Github
  class Client
    def initialize
      #   @prompt = TTY::Prompt.new
      @cmd = TTY::Command.new
      @username = ENV["GITHUB_USERNAME"]

      @cmd.run!("gh config set git_protocol ssh")
    end

    def repos
      out, err = @cmd.run!("gh repo list #{@username} --limit 1000")
      login if err[/authenticate/]
      out.split("\n").map { |r| r.split("\t") }.map { |attr|
        repo = {}
        repo[:name] = attr[0]
        repo[:type] = attr[2]
        repo[:last_updated] = attr[3]
        repo
      }
    end

    def clone_all
      repos.map! { |r| Repo.new(**r) }.map!(&:clone)
    end

    def login
      @cmd.run!("gh auth login")
    end

    def table
      header = %w[Name Type Last_Updated]
      rows = repos.map(&:values).sort_by { |r| r.last }
      table = TTY::Table.new(header: header, rows: rows)
      table.render(:ascii)
    end
  end

  class Repo
    def initialize(name:, type:, last_updated:)
      @name = name
      @type = type
      @last_updated = last_updated
      @cmd = TTY::Command.new
    end

    def clone
      out, err = @cmd.run!("gh repo clone #{@name} #{@name}")
      err[/exists/] ? fetch_all : out
    end

    def fetch_all
      @cmd.run!("cd #{@name} && git fetch --all")
    end
  end
end

Github::Client.new.clone_all
# puts Github::Client.new.table

