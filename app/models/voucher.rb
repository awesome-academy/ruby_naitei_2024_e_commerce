class Voucher < ApplicationRecord
  has_many :bills, dependent: :destroy
  PERMITTED_ATTRIBUTES = %i(discount started_at ended_at condition).freeze

  validates :discount, presence: true,
                       numericality: {
                         greater_than: Settings.digit_0,
                         less_than_or_equal_to: Settings.digit_100
                       }
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :condition, presence: true,
                        numericality: {
                          greater_than_or_equal_to: Settings.digit_0
                        }
  validate :validate_date_order
  scope :recent, ->{order(created_at: :desc)}
  scope :active, (lambda do
    where("started_at <= ? AND ended_at >= ?", Time.zone.now, Time.zone.now)
  end)
  scope :recent, ->{order created_at: :desc}

  private

  def validate_date_order
    if started_at.present? && ended_at.present? && started_at > ended_at
      errors.add(:started_at, "must be before the end date")
    end
  end
end
