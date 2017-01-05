class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable, :omniauth_providers => [:gitlab]
  has_many :tasks
  has_many :jobs

  def refresh_api_token
    raw, enc = Devise.token_generator.generate(self.class, :api_token)
    self.api_token = enc
    save(validate: false)
  end

  def self.from_omniauth(auth)
    info = auth.extra.raw_info
    User.find_or_create_by(email: info.email) do |user|
      user.admin = info.is_admin
      user.avatar_url = info.avatar_url
      user.username = info.username
      user.name = info.name
      user.skip_confirmation!
    end
  end
end
