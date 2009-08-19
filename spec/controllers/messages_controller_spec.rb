require File.dirname(__FILE__) + '/../spec_helper'
describe MessagesController do
  fixtures :all
  
  before do
    rescue_action_in_public!
    @message = Message.make_unsaved()
    @message.receivers << (@user = User.make)
    @message.save
    # @sender = User.make
    # @message = mock_model(Message, Message.make_unsaved.attributes)
    # @message.stub!(:sender).and_return(@sender)
  end

  it "should not access unless logged_in" do
    get :show, :id => @message.id, :type => 'received'
    response.should redirect_to login_path
  end

  it "Logged_in can't access changing type param" do
    controller.stub!(:current_user).and_return(@message.sender)
    get :show, :id => @message.id
    response.should redirect_to(messages_path)
    flash[:error].should == "Acceso denegado"
  end

  it "the message sender should access to his message" do
    controller.stub!(:current_user).and_return(@message.sender)
    get :show, :id => @message.id, :type => 'sent'
    response.should be_success
  end

  it "a sender shouldnt access like receiver" do
    controller.stub!(:current_user).and_return(@message.sender)
    get :show, :id => @message.id, :type => 'receiver'
    response.should redirect_to messages_path
  end

  it "a receiver should't access as sender" do
    controller.stub!(:current_user).and_return(@message.receivers.first)
    get :show, :id => @message.id, :type => 'sent'
    response.should redirect_to messages_path
  end

  it "the message receiver should access to his message" do
    controller.stub!(:current_user).and_return(@message.receivers.first)
    get :show, :id => @message.id, :type => 'received'
    response.should be_success
  end

  it "another user shouldn't access to a message" do
    @user = User.make
    controller.stub!(:current_user).and_return(@user)
    get :show, :id => @message.id
    response.should redirect_to(messages_path)
    flash[:error].should == "Acceso denegado"
  end
end
