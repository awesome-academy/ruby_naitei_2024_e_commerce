class Bill < ApplicationRecord
  before_save :calculate_total_after_discount, :set_expired_at
  PERMITTED_ATTRIBUTES = %i(user_id address phone_number note_content voucher_id
                                                            total status).freeze

  enum status: {
    wait_for_pay: 0,
    wait_for_prepare: 1,
    wait_for_delivery: 2,
    completed: 3,
    cancelled: 4
  }
  STATUSES = statuses.keys.map do |status|
    [I18n.t("admin.view.statuses.#{status}"),
   status]
  end

  enum cancellation_reason: {
    out_of_stock: 0,
    wrong_quantity: 1,
    wrong_product: 2
  }
  belongs_to :user
  belongs_to :voucher, optional: true
  has_many :bill_details, dependent: :destroy
  has_many :products, through: :bill_details

  validates :status, inclusion: {in: statuses.keys}
  validates :phone_number, presence: true,
            format: {with: Settings.phone_regex}
  delegate :name, :email, to: :user, prefix: true
  delegate :discount, to: :voucher, prefix: true, allow_nil: true

  scope :newest, ->{order(created_at: :desc)}

  private

  def calculate_total_after_discount
    self.total_after_discount =
      voucher.nil? ? total : (total - voucher.discount * total)
  end

  def set_expired_at
    self.expired_at = 24.hours.from_now
  end
end
