class TimelineEvent < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
end

# == Schema Information
#
# Table name: timeline_events
#
#  id                     :integer(4)      not null, primary key
#  event_type             :string(255)
#  subject_type           :string(255)
#  actor_type             :string(255)
#  secondary_subject_type :string(255)
#  subject_id             :integer(4)
#  actor_id               :integer(4)
#  secondary_subject_id   :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

