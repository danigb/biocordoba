require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = User.make
  end

  it "Should create a profile after create" do
    @user.should be_valid
  end

  it "should be national" do
    @user.location_id = 1
    @user.should be_is_national
    @user.should_not be_is_international
  end

  it "should be international" do
    @user.location_id = 2
    @user.should_not be_is_national
    @user.should be_is_international
  end

  it "should return false without location_id" do
    @user.should_not be_is_national
    @user.should_not be_is_international
  end

end
