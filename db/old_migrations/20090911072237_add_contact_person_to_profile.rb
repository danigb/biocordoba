class AddContactPersonToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :contact_person, :string
  end

  def self.down
    remove_column :profiles, :contact_person
  end
end
