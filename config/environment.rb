# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'Madrid'
  config.gem "rubyist-aasm", :lib => "aasm", :source => 'http://gems.github.com'
  config.gem "binarylogic-searchlogic", :lib => "searchlogic", :source => 'http://gems.github.com'
  config.gem "haml", :version => ">=2.2.2"
  config.gem "haddock"
  config.gem 'mislav-will_paginate', :lib => "will_paginate"

  config.i18n.default_locale = :es 
end

Haddock::Password.diction = File.join(Rails.root, "config", "dictionary.txt")
WillPaginate::ViewHelpers.pagination_options[:prev_label] = 'Anterior'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Siguiente'
