require 'sham'
require 'faker'
require 'machinist/active_record'

User.blueprint do
  login Sham.word
  password 'secret'
  email { Sham.email }
  role_id Role.first
end

Meeting.blueprint do
  host User.make(:role_id => "5")
  guest User.make(:role_id => "4")
  starts_at DateTime.parse(PREFS[:event_start_day]) + 2.hours
end

Role.blueprint do
  title {Sham.word}
end

Sector.blueprint do
  name {Faker::Lorem.sentence(1)}
end

Message.blueprint do
  sender User.make
  receiver User.make
  message {Faker::Lorem.sentence}
end

Sham.define do
  email { Faker::Internet.email }
  word { Faker::Name::first_name }
end


