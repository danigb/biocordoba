class AddCountriesData < ActiveRecord::Migration
  def self.up
    Country.delete_all
    res = YAML.load_file(File.join(RAILS_ROOT, "lib", "countries.yml"))
    res.each do |e|
      Country.create(:name => e[0], :code => e[1])
    end
    [1,51,66, 16, 19, 22].each do |n|
      Country.find(n).destroy
    end
    Country.find(17).update_attribute(:name, "Alemania")
    [["Mexico", "MX"],["Panamá", "PA"],["Chile", "CL"], ["Emiratos Árabes Unidos","AE"]].each do |e|
      Country.create(:name => e[0], :code => e[1])
    end
  end

  def self.down
    Country.delete_all
  end
end
