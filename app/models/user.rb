require 'bcrypt'

class User < ApplicationRecord
  default_scope { order(updated_at: :desc) }
  include BCrypt

  has_many :card_collections, class_name: 'CardCollection', dependent: :restrict_with_error, foreign_key: :user_id, primary_key: :id
  has_many :cards, class_name: 'Card', dependent: :restrict_with_error, foreign_key: :user_id, primary_key: :id



  # # validation
  # validates :password, presence: true,
  #           confirmation: true,
  #           length: { within: 8..40 },
  #           on: :create
  # validates :password, confirmation: true,
  #           length: { within: 8..40 },
  #           allow_blank: true,
  #           on: :update

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validate :validate_username
  # validates :email, uniqueness: true, if: :should_validate_email?
  validates :username, uniqueness: true, if: :should_validate_username?
  # validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, if: :should_validate_email?

  def password
    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

  private

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def should_validate_email?
    !email.blank?
  end

  def should_validate_username?
    !username.blank?
  end


end
