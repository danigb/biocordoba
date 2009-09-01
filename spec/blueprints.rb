require 'sham'
require 'faker'
require 'machinist/active_record'

User.blueprint do
  login Sham.word
  password 'secret'
  email { Sham.email }
  role_id Role.find_by_title("exhibitor") # Exhibitor by default

  profile Profile.make
  preference Preference.make
end

Role.all.each do |role|
  User.blueprint(role.title.to_sym) do
    role_id role.id
  end
end

Profile.blueprint do
  company_name { Sham.word }
  sectors << Sector.first
  address {Sham.word}
  commercial_profile { Sham.sentence }
  products { Sham.sentence }
  packages { Sham.sentence }
  fax { 944944944 }
  phone { 945555555 }
  stand { rand(1000) }
  website "http://mydomain.com"
  zip_code 41012
  province_id { Province.first.id }
  town_id { Town.last.id }
end

Sector.blueprint do
  name Sham.word
end


Preference.blueprint do
  meetings_duration 15
  event_start_day "2009-09-22"
  event_end_day "2009-09-24"
  event_day_start_at 10
  event_day_end_at 19
  meetings_number 4
end

Meeting.blueprint do
  host User.make(:exhibitor)
  guest User.make(:national_buyer)
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
  subject {Sham.sentence}
  message {Sham.sentence}
end

Sham.define do
  email { Faker::Internet.email }
  word { Faker::Name::first_name }
  sentence { Faker::Lorem.sentence }
  phone {	Faker::PhoneNumber.phone_number}
end


