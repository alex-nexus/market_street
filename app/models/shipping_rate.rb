# == Schema Information
#
# Table name: shipping_rates
#
#  id                    :integer(4)      not null, primary key
#  shipping_method_id    :integer(4)      not null
#  rate                  :decimal(8, 2)   default(0.0), not null
#  shipping_rate_type    :string
#  minimum_charge        :decimal(8, 2)   default(0.0), not null
#  position              :integer(4)
#  active                :boolean(1)      default(TRUE)
#  created_at            :datetime
#  updated_at            :datetime
#

class ShippingRate < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  SHIPPING_RATE_TYPES = %w(INDIVIDUAL ORDER)
  
  belongs_to :shipping_method
  has_many   :products

  validates  :rate,                   :presence => true, :numericality => true
  validates  :shipping_method_id,     :presence => true
  validates  :shipping_rate_type,     :inclusion => SHIPPING_RATE_TYPES

  scope :with_these_shipping_methods, lambda { |shipping_method_ids|
          where("shipping_rates.shipping_method_id IN (?)", shipping_method_ids)
        }

  MONTHLY_BILLING_RATE_ID = 1

  # determines if the shippng rate should be calculated individually
  #
  # @param [none]
  # @return [ Boolean ]
  def individual?
    shipping_rate_type == 'INDIVIDUAL'
  end

  # the shipping method name, shipping zone and sub_name
  # ex. '3 to 5 day UPS, International, Individual - 5.50'
  #
  # @param [none]
  # @return [ String ]
  def name
    [shipping_method.name, sub_name].join(', ')
  end

  def sub_name
    '(' + [shipping_rate_type, rate ].join(' - ') + ')'
  end

  # the shipping method name, and $$$ rate
  # ex. '3 to 5 day UPS - $5.50'
  #
  # @param [none]
  # @return [ String ]
  def name_rate_min
    [name_with_rate, "(min order => #{minimum_charge})" ].join(' ')
  end

  # the shipping method name, and $$$ rate
  # ex. '3 to 5 day UPS - $5.50'
  #
  # @param [none]
  # @return [ String ]
  def name_with_rate
    [shipping_method.name, charge_amount].compact.join(' - ')
  end

  private
    def charge_amount
      number_to_currency(rate) + per_item_verbage
    end

    def per_item_verbage
      individual? ? ' / item' : ''
    end
end
