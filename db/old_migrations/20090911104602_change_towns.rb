class ChangeTowns < ActiveRecord::Migration
  def self.up
    Town.find(3306).update_attribute(:name, "Alcalá de Guadaira")
    Town.find(983).update_attribute(:name, "Jeréz de la Frontera")
    Town.find(1632).update_attribute(:name, "Lanjarón")
    Town.find(974).update_attribute(:name, "Cádiz")
    Town.find(2522).update_attribute(:name, "Málaga")
    Town.find(244).update_attribute(:name, "Serón")
    Town.find(1936).update_attribute(:name, "Bailén")
    Town.find(255).update_attribute(:name, "Gádor")
    Town.find(3398).update_attribute(:name, "San Juán de Aznalfarache")
    Town.find(1251).update_attribute(:name, "Villanueva de Córdoba")
    Town.find(1621).update_attribute(:name, "Huétor - Tajar")
    Town.find(209).update_attribute(:name, "Almería")
    Town.find(1987).update_attribute(:name, "Pozo Alcón")
    Town.find(1926).update_attribute(:name, "Alcalá la Real")
    Town.find(1953).update_attribute(:name, "Chilluévar")
    Town.find(1946).update_attribute(:name, "La Carolina")
    Town.find(235000047).update_attribute(:name, "Huevar de Aljarafe")
    Town.find(255).update_attribute(:name, "Viator")
    Town.find(244).update_attribute(:name, "Serón")
    Town.find(2426).update_attribute(:name, "El Molar - Cazorla")
  end

  def self.down
  end
end
