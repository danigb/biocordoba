begin
  raw_config = File.read(RAILS_ROOT + "/config/config.yml")
rescue Errno::ENOENT
  puts "Error! You MUST configure config/config.yml file"
  exit
end

CONFIG = YAML.load(raw_config)[RAILS_ENV]

puts "config file loaded"
