class AddStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string
    User.update_all(:state => 'enabled')
  end

  def self.down
    remove_column :users, :state
  end
end
