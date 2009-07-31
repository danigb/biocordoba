require 'fastercsv'

desc "Importación de los expositores" 
task :load_exhibitors => :environment do
  file = File.join(RAILS_ROOT, "resources", "exhibitors.csv")
  FasterCSV.read(file).each do |row|
    name, image = row
  end
end
