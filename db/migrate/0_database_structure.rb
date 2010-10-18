class DatabaseStructure < ActiveRecord::Migration
  def self.up

    create_table "assistances", :force => true do |t|
      t.date     "day"
      t.time     "arrive"
      t.time     "leave"
      t.integer  "preference_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "countries", :force => true do |t|
      t.string  "name"
      t.string  "code"
      t.integer "profiles_count", :default => 0
    end

    create_table "delayed_jobs", :force => true do |t|
      t.integer  "priority",   :default => 0
      t.integer  "attempts",   :default => 0
      t.text     "handler"
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "meetings", :force => true do |t|
      t.integer  "host_id"
      t.integer  "guest_id"
      t.string   "state"
      t.text     "note_host"
      t.text     "note_guest"
      t.text     "cancel_reason"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "starts_at"
      t.datetime "ends_at"
    end

    add_index "meetings", ["guest_id"], :name => "index_meetings_on_guest_id"
    add_index "meetings", ["host_id"], :name => "index_meetings_on_host_id"
    add_index "meetings", ["state"], :name => "meetings_state", :length => {"state"=>"4"}

    create_table "messages", :force => true do |t|
      t.integer  "sender_id"
      t.text     "message"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "subject"
    end

    add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

    create_table "preferences", :force => true do |t|
      t.integer  "meetings_number"
      t.integer  "meetings_duration"
      t.date     "event_start_day"
      t.date     "event_end_day"
      t.time     "event_day_start_at"
      t.time     "event_day_end_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "profiles", :force => true do |t|
      t.string   "company_name"
      t.string   "address"
      t.integer  "zip_code"
      t.integer  "province_id"
      t.string   "products"
      t.string   "packages"
      t.string   "commercial_profile"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "town_id"
      t.integer  "phone"
      t.integer  "fax"
      t.string   "website"
      t.string   "stand"
      t.integer  "country_id",         :default => 23
      t.string   "languages"
      t.string   "contact_person"
      t.string   "mobile_phone"
    end

    add_index "profiles", ["company_name"], :name => "profiles_company_name", :length => {"company_name"=>"4"}
    add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

    create_table "profiles_sectors", :id => false, :force => true do |t|
      t.integer "profile_id"
      t.integer "sector_id"
    end

    create_table "provinces", :id => false, :force => true do |t|
      t.integer "id"
      t.string  "name"
    end

    create_table "roles", :force => true do |t|
      t.string "title"
    end

    add_index "roles", ["title"], :name => "roles_title", :length => {"title"=>"4"}

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "user_id"
    end

    add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id"
    add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
    add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"
    add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

    create_table "sectors", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "english_name"
    end

    create_table "timeline_events", :force => true do |t|
      t.string   "event_type"
      t.string   "subject_type"
      t.string   "actor_type"
      t.string   "secondary_subject_type"
      t.integer  "subject_id"
      t.integer  "actor_id"
      t.integer  "secondary_subject_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "timeline_events", ["actor_type", "actor_id"], :name => "timeline_events_actor_type_id", :length => {"actor_id"=>nil, "actor_type"=>"4"}

    create_table "towns", :id => false, :force => true do |t|
      t.integer "id"
      t.string  "name"
      t.integer "province_id"
    end

    create_table "user_messages", :force => true do |t|
      t.integer "receiver_id",          :null => false
      t.integer "message_id",           :null => false
      t.string  "state"
      t.integer "indirect_receiver_id"
    end

    add_index "user_messages", ["message_id"], :name => "index_user_messages_on_message_id"
    add_index "user_messages", ["receiver_id", "state"], :name => "user_messages_receiver_state", :length => {"receiver_id"=>nil, "state"=>"4"}
    add_index "user_messages", ["state", "receiver_id"], :name => "user_messages_state_receiver", :length => {"receiver_id"=>nil, "state"=>"4"}

    create_table "users", :force => true do |t|
      t.string   "login",                     :limit => 40
      t.string   "email",                     :limit => 100
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "remember_token",            :limit => 40
      t.datetime "remember_token_expires_at"
      t.integer  "preference_id"
      t.string   "password",                  :limit => 40
      t.string   "state"
      t.boolean  "external",                                 :default => false
      t.boolean  "show_in_website",                          :default => true
    end

    add_index "users", ["login"], :name => "users_login", :length => {"login"=>"4"}
  end

  def self.down
  end
end