class AddMobilePhoneToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :mobile_phone, :string
  end

  def self.down
    remove_column :profiles, :mobile_phone
  end
end
