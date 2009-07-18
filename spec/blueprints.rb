require 'sham'
require 'faker'
require 'machinist/active_record'

User.blueprint do
  login Sham.word
  password 'secret'
  password_confirmation 'secret'
  email { Sham.email }
end

Meeting.blueprint do
  host User.make
  guest User.make
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


