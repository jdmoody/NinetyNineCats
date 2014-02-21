# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, presence: true
  before_validation(on: :create) do
    self.status ||= "PENDING"
  end

  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED),
                                  message: "%{value} is not a valid status" }
  validate :no_overlapping_approved_requests

  belongs_to :cat

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      overlapping_requests.each do |request|
        request.status = "DENIED"
        request.save!
      end
      self.save!
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def denied?
    self.status == "DENIED"
  end

  def pending?
    self.status == "PENDING"
  end

  private
  def no_overlapping_approved_requests
    return if self.denied?
    return if [start_date, end_date].any?(&:blank?)

    unless overlapping_approved_requests.empty?
        errors[:overlapping_request] << "Cannot overlap an already approved request!"
    end
  end

  def overlapping_requests
    condition = "cat_id = :cat_id AND
      ((DATE :start_date, DATE :end_date) OVERLAPS
      (cat_rental_requests.start_date, cat_rental_requests.end_date))"

    overlapping_requests = CatRentalRequest.where(condition, {
      cat_id: self.cat_id,
      start_date: self.start_date,
      end_date: self.end_date
    })

    if self.id.nil?
      overlapping_requests
    else
      overlapping_requests.where("id != ?", self.id)
    end
  end

  def overlapping_approved_requests
    overlapping_requests.where(:status => "APPROVED")
  end

end
