class Voucher < ApplicationRecord
  has_many :bills, dependent: :destroy
  scope :active, (lambda do
    where("started_at <= ? AND ended_at >= ?", Time.zone.now, Time.zone.now)
  end)
  scope :recent, ->{order created_at: :desc}
end
