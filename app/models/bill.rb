class Bill < ApplicationRecord
  before_save :calculate_total_after_discount, :set_expired_at
  PERMITTED_ATTRIBUTES = %i(user_id phone_number note_content voucher_id
                              total).freeze

  enum status: {
    wait_for_pay: 0,
    wait_for_prepare: 1,
    wait_for_delivery: 2,
    completed: 3,
    cancelled: 4
  }, _default: :wait_for_pay

  enum cancellation_reason: {
    out_of_stock: 0,
    wrong_quantity: 1,
    wrong_product: 2
  }

  belongs_to :user
  belongs_to :voucher, optional: true
  has_many :bill_details, dependent: :destroy
  has_many :products, through: :bill_details
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
  validates :status, inclusion: {in: statuses.keys}
  validates :phone_number, presence: true,
            format: {with: Settings.phone_regex}
  validates :total, presence: true
  delegate :name, :email, to: :user, prefix: true
  delegate :discount, :name, to: :voucher, prefix: true, allow_nil: true

  scope :newest, ->{order(created_at: :desc)}
  scope :search_by_attributes, lambda {|search|
    return if search.blank?

    ransack(user_name_or_phone_number_or_address_cont: search).result
  }

  scope :filter_by_status, lambda {|statuses|
    return if statuses.blank?

    ransack(status_in: statuses).result
  }

  scope :filter_by_voucher, lambda {|vouchers|
    return if vouchers.blank?

    ransack(voucher_id_in: vouchers).result
  }

  scope :filter_by_total_after_discount, lambda {|from, to|
    return if from.blank? && to.blank?

    ransack(total_after_discount_gteq: from).result
                                            .ransack(
                                              total_after_discount_lteq: to
                                            )
                                            .result
  }

  scope :status_bills, lambda {|date_from, date_to|
    where(created_at: date_from..date_to)
      .group(:status)
      .count
  }

  scope :incomes, lambda {|date_from, date_to|
    where(status: :completed)
      .group_by_day(:created_at,
                    range: date_from..date_to,
                    format: Settings.dd_mm_yyyy_fm)
      .sum(:total_after_discount)
  }

  scope :monthly_incomes_report, lambda {|date_from, date_to|
    where(status: :completed,
          created_at: date_from..date_to)
      .sum(:total_after_discount)
  }

  def self.ransackable_attributes _auth_object = nil
    %w(user_id address phone_number voucher_id status
    total expired_at created_at updated_at total_after_discount)
  end

  def calculate_subtotal
    self.total =
      bill_details.sum{|detail| detail.product.price * detail.quantity}
  end

  def calculate_total_after_discount
    self.total_after_discount =
      voucher.nil? ? total : (total - voucher.discount * total)
  end

  private

  def set_expired_at
    self.expired_at = 24.hours.from_now
  end
end
