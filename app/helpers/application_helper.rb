# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_url(params={})
    url_for :only_path=>false, :overwrite_params=>params
  end

  def hide_preferences
    (@user.preference_id == 1 || @user.new_record?) && @user.preference.errors.blank?
  end

  # Mostramos el usuario emisor o receptor según el tipo de mensajes que estemos viendo
  def link_message_user(message, type)
    user = {:received => 'sender', :sent => 'receiver'}
    eval("link_to(message.#{user[type.to_sym]}.login, profile_path(message.#{user[type.to_sym]}))") 
  end

  # Link de acceso a recibidos y enviados
  def message_link(type, msg)
    params[:action] == type ? msg : eval("link_to('#{msg}', #{type}_messages_path)")
  end
end
