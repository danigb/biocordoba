class AddIndirectReceiverId < ActiveRecord::Migration
  def self.up
    add_column :user_messages, :indirect_receiver_id, :integer
  end

  def self.down
    remove_column :user_messages, :indirect_receiver_id
  end
end
