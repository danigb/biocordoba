begin
  raw_config = File.read(RAILS_ROOT + "/config/config.yml")
rescue Errno::ENOENT
  puts "Error! You MUST configure config/config.yml file"
  exit
end

CONFIG = YAML.load(raw_config)[RAILS_ENV]

# unless User.authenticate(CONFIG[:admin][:login], CONFIG[:admin][:password])
#   user = User.find_by_login(CONFIG[:admin][:login])
#   user.update_attributes(:password => CONFIG[:admin][:password])
# end

