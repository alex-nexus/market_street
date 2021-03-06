# States are "states, territories and provinces" of a country. This table is seeded from
#   the db/seeds.rb file.  The seed data is supplied by db/seed/international_states/*.yml files.
#
#  If you need to seed a state other than a state in the United states You should watch the following video:
#

class State < ActiveRecord::Base
  has_many   :addresses
  has_many   :tax_rates
  belongs_to :shipping_zone

  validates :name,              :presence => true,       :length => { :maximum => 150 }
  validates :abbreviation,      :presence => true,       :length => { :maximum => 12 }
  validates :country_code,      :presence => true
  validates :shipping_zone_id,  :presence => true

  def abbreviation_name(append_name = "")
    ([abbreviation, name].join(" - ") + " #{append_name}").strip
  end

  def self.form_selector
    order('country_code ASC, abbreviation ASC').collect { |state| [state.abbreviation_name, state.id] }
  end

  def self.all_with_country_code(country_code)
    where(country_code: country_code)
  end

  def self.create_all
    file_to_load  = Rails.root + 'db/seed/states.yml'
    states_list   = YAML::load( File.open( file_to_load ) )
    states_list.each_pair do |key, hash|
      find_or_create_by(hash['attributes'])
    end
  end
end
