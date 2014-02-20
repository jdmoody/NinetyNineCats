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
  before_validation(on: :create) do
    self.status ||= "PENDING"
  end

  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED), message: "%{value} is not a valid status" }
  validate :no_overlapping_requests

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

  def pending?
    self.status == "PENDING"
  end

  private
  def no_overlapping_requests
    unless overlapping_approved_requests.empty? ||
      (overlapping_approved_requests.include?(self) && overlapping_approved_requests.length == 1)
        errors[:overlapping_request] << "Cannot overlap an already approved request!"
    end
  end

  def overlapping_requests
    condition = "cat_id = #{self.cat_id} AND
      ((DATE '#{self.start_date}', DATE '#{self.end_date}') OVERLAPS
      (cat_rental_requests.start_date, cat_rental_requests.end_date))"

    CatRentalRequest.where(condition)
  end

  def overlapping_approved_requests
    overlapping_requests.where(:status => "APPROVED")
  end

end
