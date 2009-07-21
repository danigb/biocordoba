class MessagesController < ApplicationController

  def index
    redirect_to received_messages_path
  end

  def received
    @messages = current_user.messages_received
    render :action => 'index'
  end

  def sent
    @messages = current_user.messages_sent
    render :action => 'index'
  end
  
  def show
    begin
      @message = eval("current_user.messages_#{params[:type]}.find(params[:id])")
    rescue NoMethodError
      redirect_to messages_path
    end
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = current_user.messages_sent.build(params[:message])
    if @message.save
      flash[:notice] = "Successfully created messages."
      redirect_to messages_path
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
