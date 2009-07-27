class MessagesController < ApplicationController

  before_filter :load_message, :only => :show

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
      redirect_to sent_messages_path
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

  private
  #Cargamos el mensaje y lo marcamos como leido
  def load_message
    begin
      @message = eval("current_user.messages_#{params[:type]}.find(params[:id])")
      @message.mark_as_read! if @message.unread?
    rescue NoMethodError # Comprobamos que no han alterado el parámetro
      flash[:error] = "Acceso denegado"
      redirect_to messages_path
    end
  end
end
