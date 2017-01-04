class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable
  has_many :tasks
  has_many :jobs

  def refresh_api_token
    raw, enc = Devise.token_generator.generate(self.class, :api_token)
    self.api_token = enc
    save(validate: false)
  end
end
