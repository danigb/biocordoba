require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do

  before do
    @exhibitor_role = Role.make(:title => 'exhibitor')
    @buyer_role = Role.make(:title => 'buyer')
    @meeting = Meeting.make
  end

  it "A meeting should be between two users" do
    @meeting.host.class.should == User
    @meeting.guest.class.should == User
  end

  it "A exhibitor as host and a buyer as guest should be valid" do
    # @meeting = Meeting.make(:host => User.make(:exhibitor), :guest => User.make(:buyer))
    @meeting.should be_valid
  end

  it "A exhibitor as buyer and a buyer as host should not be valid" do
    # @meeting = Meeting.make(:host => User.make(:buyer), :guest => User.make(:host))
    @meeting.should_not be_valid
  end


  it "A exhibitor new meeting with national buyer should have acepted state"
  it "A exhibitor new meeting with international buyer should have pending state"
  it "A exhibitor can create a meeting with a buyer"
  it "A exhibitor can cancel a meeting, si cancel state"
  it "A buyer can cancel a meeting, so cancel state"
end
