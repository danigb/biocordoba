require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do

  before do
    @message = Message.make_unsaved
    @message.receivers << (@user = User.make)
    @message.save
  end

  it "should be valid with 2 users" do
    @message.should be_valid
  end

  it "should not be valid without receivers" do
    message = Message.make_unsaved
    message.should_not be_valid
    message.should have(1).errors_on(:sender_id)
  end

  it "should have many receivers" do
    @message.receiver.should =~ /#{@user.profile.company_name}/
    @message.receiver.should_not =~ /#{"foo"}/  
  end

  it "should send to all user" do
    user_count = User.no_admins.count
    message = Message.make(:send_all => "1")
    message.receivers.count.should == user_count
  end

  it "should be accept a receivers' string" do
    message = Message.make(:receivers_string => "#{@user.profile.company_name}, foobar")
    message.receivers.count.should == 1
  end

  it "should be unread" do
    @user.user_messages.first.should be_unread
    @user.unread_messages_count.should > 0
  end
end

describe "Messages to international buyer" do
  before do
    2.times do |i|
      eval("@extenda_#{i+1} = User.make(:extenda)")
    end
    @international = User.make(:international_buyer)
    @message = Message.make(:receivers_string => "#{@international.profile.company_name}")
  end

  it "the message should be sent to the extenda users insteed" do
    @extenda_1.should have(1).messages_received
    @extenda_2.should have(1).messages_received
    @international.should have(1).messages_received
  end

  it "the message should reference to @international" do
    @extenda_1.user_messages.first.indirect_receiver.should == @international
  end
end
