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
    2.times do
      @profile = Profile.new(@valid_attributes)
      @profile.sectors << Sector.make
      @profile.should be_valid
    end
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id                 :integer(4)      not null, primary key
#  company_name       :string(255)
#  address            :string(255)
#  zip_code           :integer(4)
#  province_id        :integer(4)
#  products           :string(255)
#  packages           :string(255)
#  commercial_profile :string(255)
#  user_id            :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  town_id            :integer(4)
#  phone              :integer(4)
#  fax                :integer(4)
#  website            :string(255)
#  stand              :string(255)
#  country_id         :integer(4)      default(23)
#  languages          :string(255)
#  contact_person     :string(255)
#  mobile_phone       :string(255)
#

