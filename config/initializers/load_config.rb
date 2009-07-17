REST_AUTH_SITE_KEY         = 'd2ddac55144210d406b404c1da889f3a7b30df2b'
REST_AUTH_DIGEST_STRETCHES = 10

begin
  raw_config = File.read(RAILS_ROOT + "/config/config.yml")
rescue Errno::ENOENT
  puts "Error! You MUST configure config/config.yml file"
  exit
end

CONFIG = YAML.load(raw_config)[RAILS_ENV]

# Create defaults roles unless exists?
def from_yml_to_db_for(model, key, field)
  db_objects = model.all
  yml_objects = CONFIG[key]

  new_objects = yml_objects - db_objects.map(&:"#{field}")
  old_objects = db_objects.map(&:"#{field}") - yml_objects 

  for object in new_objects
    model.create(field => object)
  end

  for object in old_objects
    model.send("find_by_#{field}", object).destroy
  end
end

def from_yml_to_db_user
  user = User.first
  
  info = {:login => CONFIG[:admin][:login], :password => CONFIG[:admin][:password], 
     :password_confirmation => CONFIG[:admin][:password], :email => CONFIG[:admin][:email]}

  if user.nil?
    user = User.create(info) 
    user.roles << Role.find_by_title('admin')
  else
    if user.login != CONFIG[:admin][:login] || user.email != CONFIG[:admin][:email] || !user.authenticate?(CONFIG[:admin][:password])
      user.update_attributes(info)
    end
  end
end

begin
  from_yml_to_db_for(Role, :roles, :title)
  from_yml_to_db_for(Sector, :sectors, :name)
  from_yml_to_db_user
rescue 
  # No existen aún las tablas
end
