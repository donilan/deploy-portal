Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'],
           client_options: {
             site: 'https://gitlab.YOURDOMAIN.com',
             authorize_url: '/oauth/authorize',
             token_url: '/oauth/token'
           }
end
OmniAuth.config.logger = Rails.logger
