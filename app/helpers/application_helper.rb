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
      truncate(message.receiver, :length => 40)
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
    text = ""
    case(event.event_type)
    when("new_received_message")
      text += "<b>Mensaje</b> recibido:<hr/><p>Asunto: #{link_to event.subject.subject, message_path(:id => event.subject, :type => 'received')}</p><p>
        Remitente: #{link_to_profile(event.secondary_subject)}</p>"
    when("new_user_created")
      text += "<b>#{ROLES[event.secondary_subject.title.to_sym]}</b> registrado<hr/>
        <p>Empresa: #{link_to_profile(event.subject.profile)}</p>"
    end
    text += "<p>Fecha/Hora: #{event.created_at.to_s(:short)}</p>"
  end

  def profile_value(value)
    value.blank? ? "No definido" : value
  end

  def link_to_profile(profile, message = profile.company_name)
    link_to message, profile_path(profile), :class => "profile-link", :id => profile.id
  end

  #Usado en los breadcrumbs
  def current_user_is_admin?
    current_user.is_admin?
  end

  #Devuelve las opciones necesarias para el select de selección de destinatarios
  def select_options_buyers_exhibitors
    html = "<option></option>"
    User.no_admins.group_by{|e| e.role.title}.each do |role, users|
      html += "<optgroup label='#{ROLES[role.to_sym]}'>"
      for user in users
        html += "<option>#{user.profile.company_name}</option>"
      end
      html += "</optgroup>"
    end
    html
  end

  #Muestra el enlace de solicitar cita en el caso de ser necesario
  def link_to_meeting(user, msg = "Solicitar cita")
    if @current_user.is_exhibitor? && user.is_buyer? && !@current_user.meeting_with(user)
      link_to "Solicitar cita", meeting_into_and_path(current_user, user)
    end
  end
end
