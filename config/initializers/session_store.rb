# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_stack24_session',
  :secret      => 'ce528c9f20f212ffbc0cfd81d0867a35c49fab17e94280588f2ea2300377c01fd196069333dd7fd25f9dbe976a2fc691851bfd565257d1439dd7b157b93d67c0'
}



# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
