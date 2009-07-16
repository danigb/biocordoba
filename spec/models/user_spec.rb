require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = User.make
  end

  it "Should create a profile after create" do
    @user.should be_valid
  end


end
