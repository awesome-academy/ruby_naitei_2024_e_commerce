class Address < ApplicationRecord
  belongs_to :bill
  PERMITTED_ATTRIBUTES = %i(city country state details).freeze

  validates :country, presence: true
  validates :state, inclusion: {in: ->(record){record.states.keys},
                                allow_blank: true}
  validates :state, presence: {if: ->(record){record.states.present?}}
  validates :city, inclusion: {in: lambda {|record|
                                     record.cities.call
                                   }, allow_blank: true}
  validates :city, presence: {if: ->(record){record.cities.present?}}
  validates :details, presence: true

  before_save :convert_country_and_state

  def countries
    CS.countries.with_indifferent_access
  end

  def states
    CS.states(country).with_indifferent_access
  end

  def cities
    CS.cities(state, country) || []
  end

  private

  def convert_country_and_state
    country_id = country.to_sym
    self.country = CS.countries[country_id] || country
    return if state.blank?

    self.state = CS.states(country_id)[state.to_sym] || state
  end
end
