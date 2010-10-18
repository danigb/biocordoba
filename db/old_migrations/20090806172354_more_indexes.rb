class MoreIndexes < ActiveRecord::Migration
  def self.up
    sql = "CREATE INDEX `timeline_events_actor_type_id` ON timeline_events (`actor_type`(4), `actor_id`)"
    ActiveRecord::Base.connection.execute(sql) 
    add_index :meetings, :guest_id
    add_index :meetings, :host_id
    sql = "CREATE INDEX `meetings_state` ON meetings (`state`(4))"
    ActiveRecord::Base.connection.execute(sql) 
    add_index :roles_users, [:role_id, :user_id]
    add_index :roles_users, [:user_id, :role_id]
    remove_index :users, :login
    sql = "CREATE INDEX `users_login` ON users (`login`(4))"
    ActiveRecord::Base.connection.execute(sql) 
  end

  def self.down
    remove_index :timeline_events, :name => 'timeline_events_actor_type_id'
    remove_index :meetings, :guest_id
    remove_index :meetings, :host_id
    remove_index :meetings, :name => 'meetings_state'
    remove_index :roles_users, [:role_id, :user_id]
    remove_index :roles_users, [:user_id, :role_id]
    remove_index :users, :login
  end
end
