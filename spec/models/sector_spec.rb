require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sector do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :profiles_count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Sector.create!(@valid_attributes)
  end
end
