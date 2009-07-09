# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'Madrid'
  config.gem "grosser-fast_gettext", :lib => 'fast_gettext', :version => '~>0.4.9', :source=>"http://gems.github.com/"
  #only used for mo/po file generation in development, !do not load(:lib=>false)! since it will only eat 7mb ram
  config.gem "gettext", :lib => false, :version => '>=1.9.3'
end
