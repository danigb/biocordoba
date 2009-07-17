class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :sector, :counter_cache => true
end
