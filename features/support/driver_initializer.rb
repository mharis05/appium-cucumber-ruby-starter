def load_platform_modules
  platform_name = ENV['PLATFORM_NAME'].downcase
  case platform_name
  when 'android'
    load_module('./features/pages/dax/android/*.rb')
    $ENV = Android
  when 'ios'
    load_module('./features/pages/dax/ios/*.rb')
    $ENV = Ios
  else
    raise("Un-supported platform #{ENV['PLATFORM_NAME']}")
  end
end

def load_caps_from_file(platform_name)
  YAML.load_file("./config/caps/#{platform_name}/caps.yml")[ENV['DEVICE']]
end

def init_driver(caps)
  Appium::Driver.new(caps, false)
  Appium.promote_appium_methods World
end

# Load platform modules i.e. Android or iOS
def load_module(path)
  Dir[path].each {|file| require file}
end