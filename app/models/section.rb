class Section < ActiveRecord::Base
		attr_accessible :active, :event_id, :location, :max_age, :max_rank, :min_age, :min_rank
	
	has_many :registrations
	has_many :students, :through => :registrations
	belongs_to :event

	validates :max_age, :numericality => { :greater_than_or_equal_to => 5, :only_integer => true }, :allow_blank => true
	validates :max_rank, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }, :allow_blank => true
	validates :min_age, :numericality => { :greater_than_or_equal_to => 5, :only_integer => true }
	validates :min_rank, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }
	validates_uniqueness_of :event_id, :scope => [:min_age, :min_rank]
	validate :event_active
	validate :min_max_age
	validate :min_max_rank
	
	scope :active, where('active = ?', true)
	scope :inactive, where('active = ?', false)
	scope :alphabetical, joins(:event).order('name, min_rank, min_age')
	scope :for_event, lambda {|event_id| where('event_id = ?', event_id)}
	scope :for_rank, lambda {|rank| where('min_rank <= ? and max_rank >= ?', rank, rank)}
	scope :for_age, lambda {|age| where('min_age <= ? and max_age >= ?', age, age)}
	
	
	def min_max_age
		return true if min_age == nil || max_age == nil
		unless min_age <= max_age
			errors.add(:section, "min_age should be smaller or equal to than max_age")
		end
	end
	
	def min_max_rank
	return true if min_rank == nil || max_rank == nil
		unless min_rank <= max_rank
			errors.add(:section, "min_rank should be smaller or equal to than max_rank")
		end
	end
	
	def event_active
		active_events = Event.active.all.map{|e| e.id}
    unless active_events.include?(self.event_id)
			errors.add(:event, "is not an active event")
		end
	end
end
