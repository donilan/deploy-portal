class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable, :omniauthable, :omniauth_providers => [:gitlab]
  has_many :tasks
  has_many :jobs

  def refresh_api_token
    raw, enc = Devise.token_generator.generate(self.class, :api_token)
    self.api_token = enc
    save(validate: false)
  end

  def self.from_omniauth(auth)
    info = auth.extra.raw_info
    u = User.find_by(email: info.email)
    return u if u
    User.create!(
      email: info.email,
      password: SecureRandom.hex,
      admin: info.is_admin,
      avatar_url: info.avatar_url,
      confirmed_at: Time.now,
      username: info.username,
      name: info.name
    )
  end

  def display
    self.name || self.email
  end
end
