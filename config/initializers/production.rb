class << Rails.application
  def domain
    ENV["APP_DOMAIN"]
  end

  def name
    ENV["APP_NAME"]
  end
end

Rails.application.routes.default_url_options[:host] = Rails.application.domain

# Specifies the header that your server uses for sending files.
# config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
# config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX
Rails.application.config.action_dispatch.x_sendfile_header = ENV["X_SENDFILE_HEADER"]

Rails.application.config.force_ssl = false
