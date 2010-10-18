class AddFieldsToProfile < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.integer :phone, :fax
      t.string :website, :stand
    end
    remove_column :profiles, :name
  end

  def self.down
    add_column :profiles, :name, :string
    remove_column :profiles, :phone, :fax, :website, :stand
  end
end
