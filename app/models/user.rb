# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :addresses
  accepts_nested_attributes_for :addresses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable,
          :confirmable,       
          :registerable,
          :recoverable,
          :rememberable,
          :validatable
  include DeviseTokenAuth::Concerns::User
  before_validation :set_uid
  private
  def set_uid
    self[:uid] = self[:email] if self[:uid].blank? && self[:email].present?
  end
end
