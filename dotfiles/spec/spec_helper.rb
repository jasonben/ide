require "rspec"
require "serverspec"

RSpec.configure do |config|
  config.order = "random"
  config.profile_examples = 3
end
