require 'sham'
require 'faker'
require 'machinist/active_record'

User.blueprint do
  login { Sham.word }
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

Sham.email { Faker::Internet.email }
Sham.word { Faker::Name::first_name }


