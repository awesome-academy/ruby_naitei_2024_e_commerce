class User < ApplicationRecord
  PERMITTED_ATTRIBUTES = [:name, :email, :password,
                          :password_confirmation, :gender].freeze
  has_secure_password
  before_save :downcase_email
  before_create :create_activation_digest

  attr_accessor :activation_token, :remember_token

  enum gender: {
    female: 0,
    male: 1,
    other: 2
  }

  validates :name, presence: true,
                   length: {maximum: Settings.maximum_name_length}

  validates :email, presence: true, uniqueness: true,
                    length: {maximum: Settings.maximum_email_length},
                    format: {with: Regexp.new(Settings.email_regex)}

  validates :password, presence: true,
                       length: {minimum: Settings.min_password_length},
                       allow_nil: true

  before_save{self.email = email.downcase}

  has_many :bills, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wishlist_products, through: :wishlists, source: :product

  has_many :sender_relationship, class_name: Chat.name,
                                 foreign_key: :sender_id,
                                 dependent: :destroy
  has_many :receiver_relationship, class_name: Chat.name,
                                   foreign_key: :receiver_id,
                                   dependent: :destroy
  has_many :senders, through: :sender_relationship, source: :sender
  has_many :receivers, through: :receiver_relationship, source: :receiver

  has_one_attached :avatar

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = public_send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def admin?
    admin
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
