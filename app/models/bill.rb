class Bill < ApplicationRecord
  before_save :calculate_total_after_discount
  PERMITTED_ATTRIBUTES = %i(user_id address phone_number note_content voucher_id
                                                            total status).freeze

  enum status: {
    wait_for_pay: 0,
    wait_for_prepare: 1,
    wait_for_delivery: 2,
    completed: 3,
    cancelled: 4
  }
  belongs_to :user
  belongs_to :voucher, optional: true
  has_many :bill_details, dependent: :destroy
  has_many :products, through: :bill_details
  delegate :name, to: :user, prefix: true
  delegate :discount, to: :voucher, prefix: true, allow_nil: true

  private

  def calculate_total_after_discount
    self.total_after_discount =
      voucher.nil? ? total : (total - voucher.discount * total)
  end
end
