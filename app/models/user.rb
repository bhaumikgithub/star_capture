class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :rememberable, :trackable, :validatable
  # Email validation
  has_many :product_comments
  ratyrate_rater
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  acts_as_voter
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      geo
    end
  end

  ['admin', 'user'].each do |user_role|
    define_method "#{user_role}?" do
      self.role == user_role
    end
  end

end
