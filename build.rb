#!/usr/bin/env ruby

module Docker
  class Build
    def initialize
      load_env
      check_vars('IDE_DOCKER_IMAGE')
      create_builder
      build
    end

    def load_env
      unless File.exist?(".env")
        puts "Error: .env file not found. Fix by copying .env.sample to .env"
        exit 1
      end

      File.readlines(".env").each do |line|
        next if line.strip.empty? || line.start_with?("#")
        key, value = line.split("=", 2).map(&:strip)
        ENV[key] = value
      end
    end

    def check_vars(*var_names)
      var_names.each do |var_name|
        if ENV[var_name].to_s.empty?
          puts "#{var_name} is unset. Fix by copying .env.sample to .env"
          exit 1
        end
      end
    end

    def create_builder
      system("docker", "buildx", "create", "--name", "localbuilder", err: File::NULL)
      system("docker", "buildx", "use", "localbuilder")
    end

    def build
      tag = "#{ENV['REPO']}#{ENV['IDE_DOCKER_IMAGE']}"
      ok = system("docker", "buildx", "build", "--load", "--pull=false", "-t", tag, ".")
      exit(1) unless ok
    end
  end
end
