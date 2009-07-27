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
      link_to(message.sender.profile.company_name, profile_path(message.sender))
    else
      message.receiver
    end
  end

  # Link de acceso a recibidos y enviados
  def message_link(type, msg)
    params[:action] == type ? msg : eval("link_to('#{msg}', #{type}_messages_path)")
  end
end
