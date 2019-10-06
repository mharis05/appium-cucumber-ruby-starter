require 'appium_lib'
require 'pry'
require 'rspec'
require 'cucumber'
require 'httparty'
require 'byebug'
require 'time'
require 'google/apis'
require_relative './helpers.rb'
require_relative 'driver_initializer'
include RSpec::Matchers
include AppiumHelper
CAPS = load_caps_from_file(ENV['PLATFORM_NAME'].downcase)
ENVIRONMENT = YAML.load_file('./config/environment.yml')
DATA = (YAML.load_file('./features/fixtures/data.yml'))

$driver = init_driver(CAPS).start_driver

# Load and require files
def load_files(path)
  Dir[path].each {|file| require file}
end

load_modules