raw_config = File.read(RAILS_ROOT + "/config/config.yml")
CONFIG = YAML.load(raw_config)[RAILS_ENV]

puts "config file loaded"
