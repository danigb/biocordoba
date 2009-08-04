require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do
  describe "basic" do
    before do
      @exhibitor = User.make(:exhibitor)
      @buyer = User.make(:national_buyer)
      @meeting = Meeting.make(:host => @exhibitor, :guest => @buyer)
    end

    it "should be between two users" do
      @meeting.host.class.should == User
      @meeting.guest.class.should == User
    end

    it "should be between a exhibitor and a buyer" do
      @meeting.should be_valid
    end

    it "should not be valid between a exhibitor as buyer and a buyer as host" do
      @buyer.is_exhibitor?.should be_false
      @meeting.host = @buyer
      @meeting.should_not be_valid
    end

    it "should have acepted state" do
      @meeting.should be_accepted
    end

    it "should have pending state with a international buyer" do
      @buyer = User.make(:international_buyer)
      @meeting = Meeting.make(:guest => @buyer)
      @meeting.should be_pending
    end
  end

  describe "named_scope" do
    before do
      5.times do
        meeting = Meeting.make
      end

      5.times do
        Meeting.make(:guest => User.make(:international_buyer))
      end
    end
    
    it "'with_type' should return meetings for a specific type of users" do
      Meeting.count.should == 10
      Meeting.with_type('exhibitor').length.should == 10
      Meeting.with_type('national_buyer').length.should == 5
      Meeting.with_type('international_buyer').length.should == 5
    end
    
    it "'with_state' should return meetings for a specific state" do
      Meeting.with_state("accepted").length.should == 5
      Meeting.with_state("pending").length.should == 5
      Meeting.with_state("canceled").length.should == 0
    end

    it "'in' should return meetings for a specific date" do
      Meeting.in(PREFS[:event_start_day]).length.should == 10
      Meeting.in(Time.now).length.should == 0
    end
  end

  describe "validate" do
    it "should have a exhibitor user for host"
    it "should have a buyer user for guest"
    it "should not have two meetings with same guest"
    it "should not have a meeting out of event"
    it "should not have two meetings in same date"
  end


  describe "functions" do
    it "should return my name in a meeting" do
      meeting = Meeting.make
      host = meeting.host
      guest = meeting.guest
      
      meeting.name(host).should == host.profile.company_name
      meeting.name(host, false).should == guest.profile.company_name
      
      meeting.name(guest).should == guest.profile.company_name
      meeting.name(guest, false).should == host.profile.company_name
    end

    it "should return 'Busy' for another user" do
      meeting = Meeting.make
      user = User.make

      meeting.name(user, false).should == "Ocupado"  
    end

    it "should return meeting between a host and a guest user"
  end
end

