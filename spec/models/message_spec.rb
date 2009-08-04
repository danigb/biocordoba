require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do

  before do
    @message = Message.make
  end

  # it "A message with 2 users should be valid" do
  #   @message.should be_valid
  # end

  # it "A message requires 2 diferent users" do
  #   @user = User.make
  #   @message = Message.make_unsaved(:sender => @user, :receiver => @user)
  #   @message.should_not be_valid
  # end

  # it "New message state is unread" do
  #   @message.unread?.should be_true
  # end
  

end
