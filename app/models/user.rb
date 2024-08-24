class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  before_save :downcase_email

  has_one :cart, dependent: :destroy

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

  has_one :cart, dependent: :destroy
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
  scope :all_users, ->{all}

  scope :users_signup, lambda {|date_from, date_to|
    group_by_day(:created_at,
                 range: date_from..date_to)
      .count
  }

  ransacker :email_or_name do |parent|
    Arel::Nodes::NamedFunction.new(
      "concat",
      [
        Arel::Nodes::NamedFunction.new("LOWER", [parent.table[:email]]),
        Arel::Nodes::NamedFunction.new("LOWER",
                                       [Arel::Nodes::SqlLiteral.new("' '")]),
        Arel::Nodes::NamedFunction.new("LOWER", [parent.table[:name]])
      ]
    )
  end

  ransacker :created_at do
    Arel.sql("DATE(created_at)")
  end

  ransacker :gender do
    Arel::Nodes::SqlLiteral.new("CASE WHEN gender = 0 THEN 'female' " \
                                "WHEN gender = 1 THEN 'male' " \
                                "WHEN gender = 2 THEN 'other' " \
                                "END")
  end

  def self.from_omniauth access_token
    data = access_token.info
    User.where(email: data["email"]).first_or_create do |user|
      user.name = data["name"]
      user.password = Devise.friendly_token[0, 20]
      user.uid = access_token[:uid]
      user.provider = access_token[:provider]
    end
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_bill_info bill
    BillMailer.bill_info(self, bill).deliver
  end

  def admin?
    admin
  end

  def like product
    wishlist_products << product
  end

  def unlike product
    wishlist_products.delete product
  end

  def like? product
    wishlist_products.include? product
  end

  private

  def downcase_email
    email.downcase!
  end
end
