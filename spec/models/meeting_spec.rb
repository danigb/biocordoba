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

    it "duration should be 15 minutes by default" do
      @meeting.ends_at.should == @meeting.starts_at + 15.minutes
      @meeting.duration.should == 15
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
    before do
      @meeting = Meeting.make
      @host = @meeting.host
      @guest = @meeting.guest
    end

    it "should have a exhibitor user for host" do
      @host.should be_is_exhibitor
    end

    it "should have a buyer user for guest" do
      @guest.should be_is_buyer
    end

    it "should not have two meetings with same guest" do
      meeting =  Meeting.make_unsaved(:host => @host, :guest => @guest)
      meeting.should have(1).errors_on(:guest_id)
    end

    it "should not have a meeting out of event" do
      meeting =  Meeting.make_unsaved(:starts_at => Time.now)
      meeting.should have(1).errors_on(:starts_at)     
      meeting.errors.on(:starts_at).should == "La cita debe estar dentro de las jornadas del evento"
    end

    it "valid_date behaviour" do
      meeting = Meeting.make_unsaved(:host => User.make, :guest => @guest, :starts_at => @meeting.starts_at)
      Meeting.valid_date?(meeting.host, meeting.guest, meeting.starts_at, meeting.ends_at).should == false
      meeting = Meeting.make_unsaved(:host => User.make, :guest => @guest, :starts_at => @meeting.starts_at + 1.hour)
      Meeting.valid_date?(meeting.host, meeting.guest, meeting.starts_at, meeting.ends_at).should == true
    end

    it "should not have two meetings in same date" do
      # meeting = Meeting.make(:host => User.make, :guest => @guest, :starts_at => @meeting.starts_at)
      # meeting.should_not be_valid
      # meeting.should have(1).errors_on(:starts_at)     
    end
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

    it "should validate a date belongs to event" do
      success_date = DateTime.parse "#{PREFS[:event_start_day]} #{PREFS[:event_day_start_at]}:00"
      wrong_date = DateTime.parse("#{PREFS[:event_start_day]} #{PREFS[:event_day_start_at]}:00") - 1.hour

      Meeting.valid_event_date?(success_date).should be_true
      Meeting.valid_event_date?(wrong_date).should be_false
    end
  end
end

