class UserMessageSweeper < ActionController::Caching::Sweeper
  observe UserMessage

  def after_create(record)
    expire_cache_for(record)
  end

  #Marcamos el mensaje como leido
  def after_update(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end
  
  private
  def expire_cache_for(record)
    expire_fragment("#{record.receiver.login}-left-column")
    expire_fragment("#{record.receiver.login}-timeline")
  end
end
