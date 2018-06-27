class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :rememberable, :trackable, :validatable
  # Email validation
  has_many :product_comments
  has_many :itineraries, foreign_key: :user_id
  has_one :itinerary, foreign_key: :client_id
  belongs_to :operator, :class_name => "User", :foreign_key => "operator_id"
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

  def get_password
    self.name.split('@')[1]
  end

  def self.get_clients
    User.where(role: 'client')
  end

  def get_client_name
    self.name.split('@').first
  end

end
