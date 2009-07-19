require File.dirname(__FILE__) + '/../spec_helper'

describe Preference do
  it "should be valid" do
    Preference.new.should be_valid
  end
end
