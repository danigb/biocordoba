class AddIndexes < ActiveRecord::Migration
  def self.up
    sql = "CREATE INDEX `user_messages_state_receiver` ON user_messages (`state`(4), `receiver_id`)"
    ActiveRecord::Base.connection.execute(sql) 
    sql = "CREATE INDEX `user_messages_receiver_state` ON user_messages (`receiver_id`, `state`(4))"
    ActiveRecord::Base.connection.execute(sql) 
    add_index :roles_users, :user_id
    add_index :profiles, :user_id
    add_index :messages, :sender_id
    add_index :user_messages, :message_id
    sql = "CREATE INDEX `roles_title` ON roles (`title`(4))"
    ActiveRecord::Base.connection.execute(sql) 
    sql = "CREATE INDEX `profiles_company_name` ON profiles (`company_name`(4))"
    ActiveRecord::Base.connection.execute(sql) 
    add_index :roles_users, :role_id
  end

  def self.down
    remove_index :user_messages, :name => "user_messages_state_receiver"
    remove_index :user_messages, :name => "user_messages_receiver_state"
    remove_index :roles_users, :user_id
    remove_index :profiles, :user_id
    remove_index :messages, :sender_id
    remove_index :user_messages, :message_id
    remove_index :roles, :name => 'roles_title'
    remove_index :profiles, :name => 'profiles_company_name'
    remove_index :roles_users, :role_id
  end
end
