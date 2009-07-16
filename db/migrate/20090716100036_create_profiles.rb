class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :name
      t.integer :sector_id
      t.string :company_name
      t.string :address
      t.integer :zip_code
      t.integer :locality_id
      t.integer :province_id
      t.string :products
      t.string :packages
      t.string :commercial_profile
      t.integer :user_id

      t.timestamps
    end


  end

  def self.down
    drop_table :profiles
  end
end
