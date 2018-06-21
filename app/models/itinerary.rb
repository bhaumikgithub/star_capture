class Itinerary < ApplicationRecord
  belongs_to :transport_type
  has_many :itinerary_schedules, dependent: :destroy
  belongs_to :client, foreign_key: :client_id, class_name: 'User', optional: true
  belongs_to :user, foreign_key: :user_id, class_name: 'User', optional: true

  validates :name, :duration, presence: true

  after_create :update_date

  def update_date
    if self.start_date && self.duration_type == "Days"
      self.end_date = self.start_date.to_date+self.duration.to_i
      self.not_fixed = false
    else
      self.not_fixed = true
    end
    self.save
  end

end
