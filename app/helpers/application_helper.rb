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


  def day_link(date)
    link_to_if((date != @date), I18n.localize(date, :format => '%A %d'), "?date=#{date}")
  end 

  def current_url(params={})
    url_for :only_path=>false, :overwrite_params=>params
  end

  def hide_preferences
    (@user.new_record? || @user.preference_id <= 3) && @user.preference.errors.blank?
  end

  # Mostramos el usuario emisor o receptor según el tipo de mensajes que estemos viendo
  def link_message_user(message, type)
    user = {:received => 'sender', :sent => 'receiver'}
    if type == "received"
      link_to_profile(message.sender.profile)
    else
      truncate(message.receiver(false), :length => 40)
    end
  end

  # Link de acceso a recibidos y enviados
  def message_link(type, msg)
    params[:action] == type ? msg : eval("link_to('#{msg}', #{type}_messages_path)")
  end

  def message_class(message, type)
    message.state if(type == "received")
  end

  def print_event(event)
    text = ""
    case(event.event_type)
    when("new_received_message")
      text += "<span>Asunto:</span><p> #{link_to event.subject.subject, message_path(:id => event.subject, :type => 'received')}</p>
        <span>Remitente:</span><p> #{link_to_profile(event.secondary_subject)}</p>"
    when("new_user_created")
      text += "<b>#{ROLES[event.secondary_subject.title.to_sym]}</b> registrado<hr/>
        <p>Empresa: #{link_to_profile(event.subject.profile)}</p>"
    end
    text += "<span>Fecha/Hora:</span><p> #{event.created_at.to_s(:short)}</p>"
  end

  def profile_value(value)
    value.blank? ? "No definido" : value
  end

  def link_to_profile(profile, message = profile.company_name.capitalize)
    link_to message, profile_path(profile), :class => "profile-link", :id => profile.id
  end


  #Link para popup de cita
  def link_to_meeting_show(meeting, message = 'cita')
    link_to message, meeting_path(meeting), :class => 'meeting-link', :id => meeting.id, :title => 'Ver cita'
  end

  #Usado en los breadcrumbs
  def current_user_is_admin?
    current_user.is_admin?
  end

  #Devuelve las opciones necesarias para el select de selección de destinatarios
  def select_options_buyers_exhibitors
    html = "<option></option>"
    User.find(:all, :include => [:profile, :roles], :conditions => {:state => "enabled"}, :order => 'profiles.company_name').group_by{|e| e.role.title}.each do |role, users|
      html += "<optgroup label='#{ROLES[role.to_sym]}'>"
      for user in users
        html += "<option>#{user.profile.company_name}</option>" if user.profile
      end
      html += "</optgroup>"
    end
    html
  end

  #Muestra el enlace de solicitar cita en el caso de ser necesario
  def link_to_meeting(user, msg = "Solicitar cita")
    if @current_user.is_exhibitor? && user.is_buyer?
      if (meeting = Meeting.between(@current_user, user)).new_record?
        res = "<span class='button violet'>"
        res += link_to "SOLICITAR CITA", meeting_into_and_path(current_user, user), :title => 'Solicitar cita'
        res += "</span>"
      else
        res = "<div id='flash_notice'>Ya tienes una cita con este comprador, " 
        res += link_to_meeting_show meeting, "ver cita"
        res += "</div>"
      end
    end
  end

  #Asunto del mensaje autogenerado
  def define_subject(subject)
    if subject =~ /^Re: /
      subject
    else
      "Re: #{subject}"
    end
  end

  def link_to_create_external_meeting(msg="aquí")
    link_to msg, new_external_profiles_path, :class => 'new-external-link'
  end

  #Creación de cabeceras que permitan ordenar
  #sorter_header <caption> <sort_field> <default active>
  def sorter_header(caption, sort_field, default = false)
    order = (params[:sort].present? && params[:sort].split(' ').last == 'desc' ? 'asc' : 'desc')

    if (default && !params[:sort].present?) || (params[:sort].present? && params[:sort].split(' ').first == sort_field)
      klass = order == "desc" ? "headerSortDown" : "headerSortUp" 
    end
    
    res = "<th class='header #{klass}'>"
    res +=  link_to caption, {:sort => "#{sort_field} #{order}"}
    res += "</th>"
  end

  # def estancia_info(user)
  #   if(eval("@guest.preference.day_#{@date.day}_arrival.hour") == 0 && eval("@guest.preference.day_#{@date.day}_leave.hour") == 0)
  #     res = "#{user.profile.company_name} no asistirá a la feria en todo el día."
  #   else
  #     res = "#{user.profile.company_name} asistirá este día de "
  #     res += eval("@guest.preference.day_#{@date.day}_arrival.to_formatted_s(:hour_only)")
  #     res += " h. a "
  #     res += eval("@guest.preference.day_#{@date.day}_leave.to_formatted_s(:hour_only)")
  #     res += " h."
  #   end
  #   res
  # end
end
