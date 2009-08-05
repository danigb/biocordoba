# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090805083459) do

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

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
  end

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
  end

  create_table "profiles_sectors", :id => false, :force => true do |t|
    t.integer "profile_id"
    t.integer "sector_id"
  end

  create_table "provinces", :force => true do |t|
    t.string "name"
  end

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sectors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "towns", :force => true do |t|
    t.string  "name"
    t.integer "province_id"
  end

  create_table "user_messages", :force => true do |t|
    t.integer "receiver_id", :null => false
    t.integer "message_id",  :null => false
    t.string  "state"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "preference_id"
    t.string   "password",                  :limit => 40
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
