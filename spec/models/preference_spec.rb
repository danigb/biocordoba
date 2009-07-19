require File.dirname(__FILE__) + '/../spec_helper'

describe Preference do
  it "It must exists a master configuration" do
    Preference.count.should == 1
  end
end
