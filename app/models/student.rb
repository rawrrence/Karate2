class Student < ActiveRecord::Base
	before_save :reformat_phone
  attr_accessible :active, :date_of_birth, :first_name, :last_name, :phone, :rank, :waiver_signed
	
	has_many :registrations
	has_many :sections, :through => :registrations
	
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :date_of_birth, :presence => true
	validates :rank, :presence => true
	validates_format_of :phone, :with => /^(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => true
	validates_date :date_of_birth, :on_or_before => lambda {5.years.ago}, :on_or_before_message => "Must be at least 5 years old."
	
	scope :juniors, where('date_of_birth > ?', 18.years.ago.to_date)
	scope :seniors, where('date_of_birth <= ?', 18.years.ago.to_date)
	scope :active, where('active = ?', true)
	scope :inactive, where('active = ?', false)
	scope :gups, where('rank <= 10')
	scope :dans, where('rank >= 11')
	scope :has_waiver, where('waiver_signed = ?', true)
	scope :needs_waiver, where('waiver_signed =?', false)
	scope :alphabetical, order('last_name, first_name')
	scope :by_rank, order('rank desc, last_name, first_name')
	scope :ranks_between, lambda {|low_rank, high_rank| where('rank >= ? and rank <= ?', low_rank, high_rank)}
	scope :ages_between, lambda {|low_age, high_age| where('date_of_birth <= ? and date_of_birth > ?', Date.today.years_ago(low_age), Date.today.years_ago(high_age+1))}
	
	
	def name
		return last_name + ", " + first_name
	end
	
	def proper_name
		return first_name + " " + last_name
	end
	
	def over_18?
		return date_of_birth <= 18.years.ago.to_date
	end
	
	def age
		now = Time.now.utc.to_date
		now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
	end
	
	def registered_for_section(id)
		sections = registrations.all.map{|r| r.section_id == id}
		return sections.map{|s| s.student_id}
	end

	private
  # We need to strip non-digits before saving to db
	def reformat_phone
		 phone = self.phone.to_s  # change to string in case input as all numbers 
		 phone.gsub!(/[^0-9]/,"") # strip all non-digits
		 self.phone = phone       # reset self.phone to new string
  end
	
end
