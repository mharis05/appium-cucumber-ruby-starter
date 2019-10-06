def load_platform_modules
  platform_name = ENV['PLATFORM_NAME'].downcase
  case platform_name
  when 'android'
    load_files('./features/screens/android/*.rb')
    $ENV = Android
  when 'ios'
    load_files('./features/screens/dax/ios/*.rb')
    $ENV = Ios
  else
    raise("Un-supported platform #{ENV['PLATFORM_NAME']}")
  end
end

def load_caps_from_file(platform_name)
  YAML.load_file("./config/caps/#{platform_name}/caps.yml")
end

def init_driver(caps)
  byebug
  Appium::Driver.new(caps, true)
  Appium.promote_appium_methods Object
end

# Load platform modules i.e. iOS or Android (one at a time)
def load_modules
  if ENV['PLATFORM_NAME'].nil?
    raise 'Please define the PLATFORM_NAME environment variable like: PLATFORM_NAME=' 'android'
  else
    load_platform_modules
  end
end