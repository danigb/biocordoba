require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do

  before do
    @exhibitor = User.make
    @exhibitor.role_id = Role.find_by_title("exhibitor").id
    @exhibitor.save

    @buyer = User.make
    @buyer.role_id = Role.find_by_title('national_buyer').id
    @buyer.save

    @meeting = Meeting.make(:host => @exhibitor, :guest => @buyer)
  end

  it "A meeting should be between two users" do
    @meeting.host.class.should == User
    @meeting.guest.class.should == User
  end

  it "A exhibitor as host and a buyer as guest should be valid" do
    @meeting.should be_valid
  end

  it "A exhibitor as buyer and a buyer as host should not be valid" do
    @buyer.is_exhibitor?.should be_false
    @meeting.host = @buyer
    @meeting.should_not be_valid
  end

  it "A exhibitor new meeting with national buyer should have acepted state" do
    @meeting.acepted?.should be_true 
  end

  it "A exhibitor new meeting with international buyer should have pending state" do
    @buyer = User.make
    @buyer.role = Role.find_by_title('buyer')
    @buyer.location_id = 2
    @buyer.save
    @meeting = Meeting.make(:host => @exhibitor, :guest => @buyer)

    @meeting.pending?.should be_true
  end

end
