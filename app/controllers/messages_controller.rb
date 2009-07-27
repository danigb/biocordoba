class MessagesController < ApplicationController

  before_filter :load_message, :only => [:show, :destroy]
  before_filter :mark_as_read, :only => :show

  auto_complete_for :profile, :company_name, :limit => 15

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
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = current_user.messages_sent.build(params[:message])
    if @message.save
      flash[:notice] = "¡ Mensaje enviado !"
      redirect_to message_path(:id => @message.id, :type => 'sent')
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @message.destroy
    flash[:notice] = "Mensaje eliminado"
    redirect_to eval("#{params[:type]}_messages_path")
  end

  private
  #Cargamos el mensaje 
  def load_message
    begin
      @message = eval("current_user.messages_#{params[:type]}.find(params[:id])")
    rescue NoMethodError # Comprobamos que no han alterado el parámetro
      flash[:error] = "Acceso denegado"
      redirect_to messages_path
    end
  end

  def mark_as_read
    @message_user = @message.user_messages.find_by_receiver_id(current_user.id)
    @message_user.mark_as_read! if @message_user.unread?
  end
end
