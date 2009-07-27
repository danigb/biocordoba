class ChangeMessagesHabtm < ActiveRecord::Migration
  def self.up
    create_table :user_messages do |t|
      t.integer :receiver_id, :message_id, :null => false
      t.string :state
    end
    remove_column :messages, :receiver_id, :state
  end

  def self.down
    drop_table :user_messages
    add_column :messages, :receiver_id, :integer
    add_column :messages, :state, :string
  end
end
