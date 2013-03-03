class Registration < ActiveRecord::Base
  attr_accessible :date, :fee_paid, :final_standing, :section_id, :student_id
	
	belongs_to :student
	belongs_to :section
	
	validates :student_id, :presence => true
	validates :section_id, :presence => true
	validates :date, :presence => true
	validates :final_standing, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }, :allow_blank => true	
	validates_date :date, :on_or_before => Date.today
	validate :valid_registration
	
	scope :for_section, lambda {|id| where('section_id = ?', id)}
	scope :for_student, lambda {|id| where('student_id = ?', id)}
	scope :by_student, joins(:student).order('last_name, first_name')
	scope :by_date, order('date')
	scope :by_event_name, joins(:section).joins(:event).order('name')
	
	
	# student must have appropriate rank/age to be registered
	def valid_registration
		valid = true
		if (student.age > max_age || student.age < min_age) then 
			valid = false
		end
		if (student.rank > max_rank || student.rank < min_rank) then 
			valid = false
		end
		return valid
	end
end