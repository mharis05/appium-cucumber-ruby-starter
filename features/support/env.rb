require 'appium_lib'
require 'pry'
require 'rspec'
require 'cucumber'
require 'httparty'
require 'byebug'
require 'time'
require 'google/apis'

include RSpec::Matchers

CAPS = load_caps_from_file(ENV['PLATFORM_NAME'].downcase)
ENVIRONMENT = YAML.load_file('./config/environment.yml')
DATA = (YAML.load_file('./features/fixtures/data.yml'))[ENV['ENV']]

$driver = init_driver(CAPS).start_driver