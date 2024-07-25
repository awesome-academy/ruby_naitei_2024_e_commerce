class Bill < ApplicationRecord
  PERMITTED_ATTRIBUTES = %i(user_id address phone_number note_content
                                                              status).freeze

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
end
