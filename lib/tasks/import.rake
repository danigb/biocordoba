require 'fastercsv'

desc "Importación de los expositores" 
task :load_exhibitors => :environment do
  #Relación id del csv ids almacenados en nuestra base de datos {ID_CSV => ID_DB}
  SECTORES = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 7, 6 => 6, 7 => 5, 8 => 11, 9 => 12, 10 => 13, 11 => 15,
              12 => 16, 13 => 14, 14 => 10, 15 => 8, 16 => 9}
  file = File.join(RAILS_ROOT, "resources", "expositores-ES.csv")
  FasterCSV.read(file)[1..-1].each do |row|
    id, sector_id, company_name, address, zip_code, city, province, phone, fax, email, url, stand = row

    puts company_name.normalize
    user = User.new(:login => company_name.normalize[0..20], :password => Haddock::Password.generate(10), :email => email, :preference_id => 1)
    user.roles << Role.find_by_title('exhibitor')
    if user.save!
      Profile.create!(:sector_id => SECTORES[sector_id.to_i], :company_name => company_name, :address => address, :zip_code => zip_code,
        :phone => phone, :fax => fax, :website => url.blank? ? "" : "http://#{url}", :stand => stand, :user_id => user.id)
      puts "[#{Time.now.to_s(:short)}] Expositor creado, #{company_name}"
    end
  end
end
