class AddEnglishNameToSectors < ActiveRecord::Migration
  def self.up
    add_column :sectors, :english_name, :string
    sectors = ["OILS", "SEASONINGS AND OLIVES", "FROZEN FOOD", "PRE-COOKED FOOD", "NON-ALCOHOLIC DRINKS, HOT DRINKS, OTHER DRINKS",
    "CANNED FOOD, JAMS, HONEY", "FRUITS, VEGETABLES AND NUTS", "AUXILIARY INDUSTRIES, RESTAURANT AND CATERING SERV...",
    "INSTITUTIONS AND OTHER AGENCIES", "OTHER AGRIFOOD PRODUCTS", "BREAD, CONFECTIONERY, PASTRIES, DESSERTS AND SWEET...",
    "FISH AND SEAFOOD", "MEAT PRODUCTS", "ORGANIC PRODUCTS", "DAIRY PRODUCTS", "WINES, VINAGERS AND SPIRITS"]
    Sector.all.each_with_index do |s, index|
      s.update_attribute(:english_name, sectors[index].capitalize)
    end
  end

  def self.down
    remove_column :sectors, :english_name
  end
end
