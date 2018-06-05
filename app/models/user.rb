class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :rememberable, :trackable, :validatable
  # Email validation
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      geo
    end
  end
  def is_admin?
    return true if self.role == 'admin'
  end

end
