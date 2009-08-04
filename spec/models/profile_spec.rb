require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Profile do
  before(:each) do
    @valid_attributes = {
      :company_name => "value for company_name",
      :address => "value for address",
      :zip_code => 1,
      :town_id => 1,
      :province_id => 1,
      :products => "value for products",
      :packages => "value for packages",
      :commercial_profile => "value for commercial_profile"
    }
  end

  it "should create a new instance given valid attributes" do
    Profile.create!(@valid_attributes)
  end
end
