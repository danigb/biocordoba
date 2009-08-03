# Estas variables estaban en site_keys.rb pero necesitamos que se carguen
# en este preciso instante :-)
REST_AUTH_SITE_KEY         = 'd2ddac55144210d406b404c1da889f3a7b30df2b'
REST_AUTH_DIGEST_STRETCHES = 10

begin
  raw_config = File.read(RAILS_ROOT + "/config/config.yml")
rescue Errno::ENOENT
  puts "Error! You MUST configure config/config.yml file"
  exit
end

CONFIG = YAML.load(raw_config)[RAILS_ENV]
PREFS =  CONFIG[:admin][:preferences]
puts "Configuration loaded in CONFIG and PREFS."

# Método que se encarga de actualizar la base de datos con
# el contenido de una +key+ en el fichero de configuración.
# Interactua con un +model+ sobre un +field+ concreto.

# Example: from_yml_to_db_user(Role, :roles, :name)
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

# Método que se encarga de mantener actualizado el primer
# usuario admin. Si no existe lo creará y si los datos han
# cambiado lo actualizará.
def from_yml_to_db_user
  user = User.first
  
  info = {:login => CONFIG[:admin][:login], :password => CONFIG[:admin][:password], 
     :email => CONFIG[:admin][:email], :preference_id => 1}

  if user.nil?
    user = User.new(info) 
    user.roles << Role.find_by_title('admin')
    user.save!
    profile = Profile.create!(:company_name => "Andalucía Sabor", :user_id => user.id)
    profile.sectors << Sector.first
  else
    if user.login != CONFIG[:admin][:login] || user.email != CONFIG[:admin][:email] || !user.authenticated?(CONFIG[:admin][:password])
      user.update_attributes(info)
    end
  end
end


begin
  from_yml_to_db_for(Role, :roles, :title)
  from_yml_to_db_for(Sector, :sectors, :name) if Sector.count == 0
  from_yml_to_db_user
  
  # Creamos la configuración maestra en el caso de que no exista
  Preference.create(CONFIG[:admin][:preferences]) if Preference.first.nil?

rescue ActiveRecord::StatementInvalid
  # No existen aún las tablas
end

puts "Configuration loaded in BD."
