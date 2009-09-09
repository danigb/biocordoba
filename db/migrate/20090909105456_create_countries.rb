class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name, :code
    end
    add_column :profiles, :country_id, :integer, :default => 23
    add_column :profiles, :languages, :string
    Country.delete_all
    res = YAML.load_file(File.join(RAILS_ROOT, "lib", "countries.yml"))
    res.each do |e|
      Country.create(:name => e[0], :code => e[1])
    end
    [1,51,66, 16, 19, 22].each do |n|
      Country.find(n).destroy
    end
    Country.find(17).update_attribute(:name, "Alemania")
  end

  def self.down
    drop_table :countries
    remove_column :profiles, :country_id
    remove_column :profiles, :languages
  end
end
