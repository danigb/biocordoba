require File.dirname(__FILE__) + '/../spec_helper'

describe Preference do
  it "It must exists 3 master configurations" do
    Preference.count.should == 3
  end

  it "should set preference 1 if remove a personal preference"do
    user = User.make(:preference => (prefs = Preference.make))
    prefs.destroy
    user.reload
    user.preference_id.should == 1
  end
end

# == Schema Information
#
# Table name: preferences
#
#  id                 :integer(4)      not null, primary key
#  meetings_number    :integer(4)
#  meetings_duration  :integer(4)
#  event_start_day    :date
#  event_end_day      :date
#  event_day_start_at :time
#  event_day_end_at   :time
#  created_at         :datetime
#  updated_at         :datetime
#

