require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do

  before do

    @exhibitor = User.make
    @exhibitor.roles << Role.find_by_title("exhibitor")
    @exhibitor.save

    @buyer = User.make
    @buyer.roles << Role.find_by_title('buyer')
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


  it "A exhibitor new meeting with national buyer should have acepted state"
  it "A exhibitor new meeting with international buyer should have pending state"
  it "A exhibitor can create a meeting with a buyer"
  it "A exhibitor can cancel a meeting, si cancel state"
  it "A buyer can cancel a meeting, so cancel state"
end
