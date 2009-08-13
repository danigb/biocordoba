class MessagesController < ApplicationController

  cache_sweeper :user_message_sweeper, :only => [:create, :show, :destroy]

  before_filter :load_message, :only => [:show, :destroy]
  before_filter :mark_as_read, :only => :show

  auto_complete_for :profile, :company_name, :limit => 15

  def index
    redirect_to received_messages_path
  end

  def received
    @messages = current_user.messages_received.find(:all,
      :select => "messages.id, messages.subject, sender_id, messages.created_at, user_messages.state as state", 
      :conditions => ["user_messages.state != 'deleted'"], :include => {:sender => :profile}).paginate(:per_page => 10, :page => params[:page])
    render :action => 'index'
  end

  def sent
    @messages = current_user.messages_sent.paginate(:per_page => 10, :page => params[:page],
      :include => {:receivers => :profile})
    render :action => 'index'
  end
  
  def new
    @message = Message.new
  end
  
  def create
    params[:message][:receivers_string] = "" if params[:message][:send_all] == '1'
    @message = current_user.messages_sent.build(params[:message])
    if @message.save
      flash[:notice] = "¡ Mensaje enviado !"
      redirect_to message_path(:id => @message.id, :type => 'sent')
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @message.user_messages.find(:first, :conditions => {:receiver_id => current_user.id}).delete_message!
    flash[:notice] = "Mensaje eliminado"
    redirect_to eval("#{params[:type]}_messages_path")
  end

  private
  #Cargamos el mensaje 
  def load_message
    begin
      @message = eval("current_user.messages_#{params[:type]}.find(params[:id])")
      #Cargamos el receptor indirecto si extenda está viendo los mensajes
      if current_user.is_extenda? && params[:type] == "received"
        user_message = @message.user_messages.find(:first, :conditions => ["indirect_receiver_id IS NOT NULL"],
          :include => {:indirect_receiver => :profile})
        @indirect_receiver = user_message.indirect_receiver
      end
    rescue NoMethodError # Comprobamos que no han alterado el parámetro
      flash[:error] = "Acceso denegado"
      redirect_to messages_path
    end
  end

  #TODO, A background
  def mark_as_read
    @message_user = @message.user_messages.find_by_receiver_id(current_user.id)
    @message_user.mark_as_read! if @message_user && @message_user.unread?
  end

end
