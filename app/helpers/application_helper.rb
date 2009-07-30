# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def span(label)
    "<span class='#{label}'>#{label}</span>"
  end

  def back_link(date)
    if date > Date.parse(CONFIG[:admin][:preferences][:event_start_day])
      link_to "«", "?date=#{@date - 1.day}"
    else
      "«"
    end
  end

  def foward_link(date)
    if date < Date.parse(CONFIG[:admin][:preferences][:event_end_day])
      link_to "»", "?date=#{@date + 1.day}"
    else
      "»"
    end
  end

  def current_url(params={})
    url_for :only_path=>false, :overwrite_params=>params
  end

  def hide_preferences
    (@user.preference_id == 1 || @user.new_record?) && @user.preference.errors.blank?
  end

  # Mostramos el usuario emisor o receptor según el tipo de mensajes que estemos viendo
  def link_message_user(message, type)
    user = {:received => 'sender', :sent => 'receiver'}
    if type == "received"
      link_to_profile(message.sender.profile)
    else
      message.receiver
    end
  end

  # Link de acceso a recibidos y enviados
  def message_link(type, msg)
    params[:action] == type ? msg : eval("link_to('#{msg}', #{type}_messages_path)")
  end

  def message_class(message, type)
    if(type == "received")
      message.user_messages.find_by_receiver_id(current_user.id).state
    end
  end

  def print_event(event)
    text = "[#{event.created_at.to_s(:short)}] "
    case(event.event_type)
    when("new_received_message")
      text += "#{link_to '<b>Mensaje', message_path(:id => event.subject, :type => 'received')} recibido</b> de 
      #{link_to_profile(event.secondary_subject)}"
    when("new_user_created")
      text += "Nuevo <b>#{ROLES[event.secondary_subject.title.to_sym]}</b> registrado,
      #{link_to_profile(event.subject.profile)}"
    end
    text
  end

  def profile_value(value)
    value.blank? ? "No definido" : value
  end

  def link_to_profile(profile, message = profile.company_name)
    link_to message, profile_path(profile), :class => 'profile-link', :id => profile.id
  end
end
