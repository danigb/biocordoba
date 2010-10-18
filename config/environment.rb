# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'Madrid'
  config.gem "rubyist-aasm", :lib => "aasm", :source => 'http://gems.github.com'
  config.gem "binarylogic-searchlogic", :lib => "searchlogic", :source => 'http://gems.github.com'
  config.gem "haml", :version => ">=3.0.21" #">=2.2.2"
  config.gem "haddock"
  config.gem 'mislav-will_paginate', :lib => "will_paginate", :source => 'http://gems.github.com'

  config.i18n.default_locale = :es 
  config.active_record.observers = :meeting_observer

  config.autoload_paths += %W( #{RAILS_ROOT}/app/sweepers )
  config.action_controller.resources_path_names = { :new => 'nuevo', :edit => 'editar' }

end

Haddock::Password.diction = File.join(Rails.root, "config", "dictionary.txt")
WillPaginate::ViewHelpers.pagination_options[:prev_label] = 'Anterior'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Siguiente'
#Consulta de nuevos trabajos cada 15 segundos [Default = 5]
# Delayed::Worker::SLEEP = 15

ActionController::Base.cache_store = :mem_cache_store
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:hour_only => "%H:%M")
