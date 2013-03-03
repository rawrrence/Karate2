class Event < ActiveRecord::Base
  attr_accessible :active, :name
	
	validates_uniqueness_of :name
	
	has_many :sections
	
	scope :active, where('active = ?', true)
	scope :inactive, where('active = ?', false)
	scope :alphabetical, order('name')
end
