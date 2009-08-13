class MeetingSweeper < ActionController::Caching::Sweeper
  observe Meeting

  def after_create(record)
    expire_cache_for(record)
  end

  #Cambiamos su estado
  def after_update(record)
    expire_cache_for(record)
  end

  private
  def expire_cache_for(record)
    #Borramos el panel lateral de todos los usuarios extenda al cambiar su estado al cambiar su estado
    if record.guest.is_international_buyer?
      User.extendas.each do |e|
        expire_fragment("#{e.login}-left-column")
      end
    end
  end
end
