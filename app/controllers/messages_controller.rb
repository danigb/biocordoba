class MessagesController < ApplicationController
  def index
    @messages = current_user.messages_received
  end
  
  def show
    @message = current_user.messages_received.find(params[:id])
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = current_user.messages_sent.build(params[:messages])
    if @message.save
      flash[:notice] = "Successfully created messages."
      redirect_to @message
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @messages = current_user.messages_received.find(params[:id])
    @messages.destroy
    flash[:notice] = "Successfully destroyed messages."
    redirect_to messages_url
  end
end
