require 'devise/jwt'

# frozen_string_literal: true

Devise.setup do |config|
  # Other Devise configuration settings

  # Use JWT authentication
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}],
      ['POST', %r{^/users$}]
    ]
    jwt.revocation_requests = [['DELETE', %r{^/logout$}]]
  end

  # Ensure JwtDenylist is loaded before being referenced
  Rails.application.config.to_prepare do
    # config.jwt.revocation_strategy = JwtDenylist
  end

  config.skip_session_storage = [:http_auth, :authenticatable]

  config.parent_controller = 'DeviseController'
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'

  config.authentication_keys = [:email]
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  # Hotwire/Turbo configuration
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end