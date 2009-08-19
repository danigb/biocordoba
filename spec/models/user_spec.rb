require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = User.make
    @date = Date.parse(PREFS[:event_start_day])
  end

  it "Should create a profile after create" do
    @user.should be_valid
  end

  it "should be national" do
    @user.role = Role.find_by_title("national_buyer")
    @user.should be_is_national_buyer
    @user.should_not be_is_international_buyer
  end

  it "should be international" do
    @user.role = Role.find_by_title("international_buyer")
    @user.should_not be_is_national_buyer
    @user.should be_is_international_buyer
  end

  it "should return false without location_id" do
    @user.should_not be_is_national_buyer
    @user.should_not be_is_international_buyer
  end

  it "should have two meetings" do
    2.times do
      meeting = Meeting.make
      meeting.host = @user
      meeting.save!
    end

    @user.meetings(@date).length.should equal(2)
  end

  it "should be authenticate" do
    user = User.make

    User.authenticate(user.login, user.password).should be_true
    User.authenticate(user.login, "wrong_pass").should be_nil
  end

end

describe "user deactivation" do
  before do
    @meeting = Meeting.make
    @host = @meeting.host
    @guest = @meeting.guest
  end

  it "the system should cancel 2 meetings with user when disable it" do
    @meeting_2 = Meeting.make(:host => @host, :starts_at => @meeting.starts_at + 20.minutes)
    @host.should have(2).meetings(Event.start_day, Event.duration)
    @guest.should have(1).meetings(Event.start_day, Event.duration)
    @host.disable!
    @host.should have(0).meetings(Event.start_day, Event.duration)
    @guest.should have(0).meetings(Event.start_day, Event.duration)
  end

end

describe "user preferences" do
  before do
    @preference = Preference.make
    @preference2 = Preference.make
    @user = User.make(:preference => @preference)
  end

  it "should have preference number 1" do
    @user.preference.id.should eql(@preference.id)
  end

  it "can assign another preference file" do
    @user.preference = @preference2
    @user.preference.should eql(@preference2)
  end
end

describe "login generation" do
  before do
    @user = User.make(:login => "mylogin")
  end

  it "should create the first user" do
    @user.login.should == "mylogin"
  end

  it "we can create users with same login, the system should set autoincremental login" do
    5.times do |i|
      @user = User.make(:login => "mylogin")
      @user.login.should == "mylogin#{i+1}"
    end
  end
end

