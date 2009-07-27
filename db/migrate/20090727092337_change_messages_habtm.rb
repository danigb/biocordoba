class ChangeMessagesHabtm < ActiveRecord::Migration
  def self.up
    create_table :messages_users, :id => false do |t|
      t.integer :receiver_id, :message_id, :null => false
    end
    remove_column :messages, :receiver_id
  end

  def self.down
    drop_table :messages_users
    add_column :messages, :receiver_id, :integer
  end
end
