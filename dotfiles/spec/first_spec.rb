# spec/first_spec.rb
require 'spec_helper'

describe package('vim') do
    it { should be_installed }
end
