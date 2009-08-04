require 'sham'
require 'faker'
require 'machinist/active_record'

User.blueprint do
  login Sham.word
  password 'secret'
  email { Sham.email }
  role_id Role.find_by_title("exhibitor").id
end

Meeting.blueprint do
  host User.make(:role_id => Role.find_by_title("exhibitor").id)
  guest User.make(:role_id => Role.find_by_title("national_buyer").id)
  starts_at DateTime.parse(PREFS[:event_start_day] + " 10:00") 
end

Role.blueprint do
  title {Sham.word}
end

Sector.blueprint do
  name {Faker::Lorem.sentence(1)}
end

Message.blueprint do
  sender User.make
  subject {Faker::Lorem.sentence}
  message {Faker::Lorem.sentence}
end

Sham.define do
  email { Faker::Internet.email }
  word { Faker::Name::first_name }
end


