require 'fastercsv'

desc "Importación de los expositores" 
task :load_exhibitors => :environment do
  #Relación id del csv ids almacenados en nuestra base de datos {ID_CSV => ID_DB}
  SECTORES = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 7, 6 => 6, 7 => 5, 8 => 11, 9 => 12, 10 => 13, 11 => 15,
              12 => 16, 13 => 14, 14 => 10, 15 => 8, 16 => 9}
  PROVINCIAS = {'Ja' => 'Jaén', 'M' => 'Málaga', 'Ca' => 'Cádiz', 'Co' => 'Córdoba'} #FIX de la chapuza que tienen ellos montado

  file = File.join(RAILS_ROOT, "resources", "expositores-ES.csv")
  FasterCSV.read(file)[1..-1].each do |row|
    id, sector_id, company_name, address, zip_code, city, province, phone, fax, email, url, stand = row
    #FIXES
    sector = Sector.find(SECTORES[sector_id.to_i])
    province = PROVINCIAS[province] if PROVINCIAS.keys.include?(province)
    province = Province.find_by_name(province)

    #Comprobamos si existe un usuario con ese mismo nombre
    #Si existe, el csv nos está diciendo que tiene otro sector
    if(u = User.find_by_login(company_name.normalize))
      u.profile.sectors << sector
    else
      user = User.new(:login => company_name.normalize, :password => Haddock::Password.generate(10), :email => email, :preference_id => 1)
      user.roles << Role.find_by_title('exhibitor')

      if user.save!
        town = province.towns.find_by_name(city)
        profile = Profile.new(:company_name => company_name, :address => address, :zip_code => zip_code,
          :phone => phone, :fax => fax, :website => url.blank? ? "" : "http://#{url}", :stand => stand, :user_id => user.id,
          :province => province, :town => town)
        sleep 0.2
        profile.sectors << sector
        profile.save!
        puts "[#{Time.now.to_s(:short)}] Expositor creado, #{company_name}"
      end
    end
    
  end
end


desc "Importación de compradores internacionales" 
task :load_international_buyers => :environment do

  file = File.join(RAILS_ROOT, "resources", "internacional.csv")
  FasterCSV.read(file).each do |row|
    country_code, company_name, website, email, contact_person, languages, phone, commercial_profile = row

    user = User.new(:login => company_name.normalize, :password => Haddock::Password.generate(10), :email => email, :preference_id => 3)
    user.roles << Role.find_by_title('international_buyer')

    if user.save!
      country = Country.find_by_code(country_code)
      profile = Profile.new(:company_name => company_name, :phone => phone, :website => website.blank? ? "" : "http://#{website}", :user_id => user.id,
        :country => country, :contact_person => contact_person, :languages => languages, :commercial_profile => commercial_profile)
      sleep 0.2
      profile.sectors << Sector.first
      profile.save!
      puts "[#{Time.now.to_s(:short)}] Comprador internacional creado, #{company_name}"
    end
    
  end
end
