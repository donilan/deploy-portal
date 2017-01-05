Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gitlab, Setting.gitlab_app_id, Setting.gitlab_secret,
           client_options: {
             site: Setting.gitlab_site,
             authorize_url: '/oauth/authorize',
             token_url: '/oauth/token'
           }
end
OmniAuth.config.logger = Rails.logger
