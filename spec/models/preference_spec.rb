require File.dirname(__FILE__) + '/../spec_helper'

describe Preference do
  it "It must exists a master configuration" do
    Preference.count.should == 1
  end

  it "should set preference 1 if remove a personal preference"do
    user = User.make(:preference => (prefs = Preference.make))
    prefs.destroy
    user.reload
    user.preference_id.should == 1
  end
end
