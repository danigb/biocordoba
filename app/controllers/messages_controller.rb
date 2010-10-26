class MessagesController < ApplicationController

  cache_sweeper :user_message_sweeper, :only => [:create, :show, :destroy]

  before_filter :load_message, :only => [:show, :destroy]
  before_filter :mark_as_read, :only => :show

  #Atención modificado en el plugin
  auto_complete_for :profile, :company_name, :limit => 15

  def index
    redirect_to received_messages_path
  end

  def received
    waps = params[:sort] ? params[:sort].split(" ") : ["sender.profile.company_name", "asc"]
    @messages = current_user.messages_received.find(:all,
      :select => "messages.id, messages.subject, sender_id, messages.created_at, user_messages.state as state", 
      # :conditions => ["user_messages.state != 'deleted'"], :include => {:sender => :profile}).sort_by{|m| eval("m.#{waps.first}")}
      :conditions => ["user_messages.state != 'deleted'"], :include => {:sender => :profile})
    
    # @messages.reverse! if waps.last == "desc"
    @messages = @messages.paginate(:per_page => 40, :page => params[:page])
    render :action => 'index', :layout => 'admin'
  end

  def sent
    @messages = current_user.messages_sent.paginate(:per_page => 40, :page => params[:page],
      :include => {:receivers => :profile})
    render :action => 'index', :layout => 'admin'
  end
  
  def new
    logger.debug "********** CREAR!"
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
    rescue NoMethodError, ActiveRecord::RecordNotFound # Comprobamos que no han alterado el parámetro
      flash[:error] = "Acceso denegado"
      redirect_to messages_path
    end
  end

  #TODO, A background
  def mark_as_read

    #Si el usuario es extenda, ponemos como leido a todos los usuarios
    if current_user.is_extenda?
      @message.user_messages.each do |um|
        um.mark_as_read! if !um.indirect_receiver.nil? && um.unread?
      end
    else
      @message_user = @message.user_messages.find_by_receiver_id(current_user.id)
      @message_user.mark_as_read! if @message_user && @message_user.unread?
    end
  end

end
