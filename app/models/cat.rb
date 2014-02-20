# == Schema Information
#
# Table name: cats
#
#  id         :integer          not null, primary key
#  age        :integer          not null
#  birth_date :string(255)      not null
#  color      :string(255)      not null
#  name       :string(255)      not null
#  sex        :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Cat < ActiveRecord::Base
  COLORS = ["black", "white", "tortoise shell", "calico", "grey", "orange"]
  validate :color_included, :valid_sex
  validates :age, :birth_date, :color, :name, :sex, presence: true
  validates :age, numericality: { only_integer: true }

  has_many :cat_rental_requests, dependent: :destroy

  def valid_sex
    errors[:sex] << "Must choose either M or F for sex" unless ['M', 'F'].include?(self.sex)
  end

  def color_included
    errors[:color] << "Must choose a valid color" unless COLORS.include?(self.color)
  end

  def numericality
    errors[:num] << "Age must be a number" unless (self.age.to_s =~ /[0-9]+/) == 0
  end
end
