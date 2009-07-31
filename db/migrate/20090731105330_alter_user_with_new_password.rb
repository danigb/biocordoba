class AlterUserWithNewPassword < ActiveRecord::Migration
  def self.up
    remove_column :users, :crypted_password
    remove_column :users, :salt
    remove_column :users, :name

    add_column :users, :password, :string, :limit => 40
  end

  def self.down
    remove_column :users, :password
    add_column :users, :crypted_password, :string, :limit => 40
    add_column :users, :salt, :string, :limit => 40
    add_column :users, :name, :string, :limit => 100, :default => '', :null => true
  end
end
