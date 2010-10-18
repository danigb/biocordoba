class AddShowInWebsite < ActiveRecord::Migration
  def self.up
    add_column :users, :show_in_website, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_in_website
  end
end
