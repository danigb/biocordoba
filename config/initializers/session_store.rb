# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eventos86_session',
  :secret      => 'd539a77d2bc735d3a3508b2d8efc8c6cd7019816b6985bbcdeb4f72a5ecd5eeb02db9ad56fff70fa20951765d54c4f9908b9c03731baa74e1a5233911b392932'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
