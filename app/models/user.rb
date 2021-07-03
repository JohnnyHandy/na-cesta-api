# frozen_string_literal: true

class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User

  has_many :addresses
  has_many :orders
  accepts_nested_attributes_for :addresses
  validates_uniqueness_of :document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable,
          :confirmable,       
          :registerable,
          :recoverable,
          :rememberable,
          :validatable
  before_validation :set_uid

  def token_validation_response                                                                                                                                         
    self.as_json(include: [:addresses, :orders => {include: [:order_items, :address]}])
  end

  private

  def set_uid
    self[:uid] = self[:email] if self[:uid].blank? && self[:email].present?
  end
end
