require 'fastercsv'

desc "Importación de los expositores" 
task :load_exhibitors => :environment do
  #Relación id del csv ids almacenados en nuestra base de datos {ID_CSV => ID_DB}
  SECTORES = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 7, 6 => 6, 7 => 5, 8 => 11, 9 => 12, 10 => 13, 11 => 15,
              12 => 16, 13 => 14, 14 => 10, 15 => 8, 16 => 9}
  file = File.join(RAILS_ROOT, "resources", "exhibitors.csv")
  FasterCSV.read(file).each do |row|
  end
end
