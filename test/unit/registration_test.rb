require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
	# test relationships
	should belong_to(:student)
	should belong_to(:section)
	should have_one(:event).through(:section)
	
	# test basic validations
	should validate_presence_of(:student_id)
	should validate_presence_of(:section_id)
	should validate_presence_of(:date)
	
	# tests for final_standing
	should allow_value(1).for(:final_standing)
	should allow_value(10).for(:final_standing)
	should_not allow_value(0).for(:final_standing)
	should_not allow_value(-1).for(:final_standing)
	should_not allow_value("five").for(:final_standing)
	should allow_value(nil).for(:final_standing)
	
	# tests for date
	should allow_value(Date.today).for(:date)
	should allow_value(5.weeks.ago.to_date).for(:date)
	should_not allow_value(1.week.from_now.to_date).for(:date)
	should_not allow_value(Date.tomorrow).for(:date)
	should_not allow_value(nil).for(:date)
	
	context "Creating seven different registration" do
		setup do
			@kenneth = FactoryGirl.create(:student)
			@kim = FactoryGirl.create(:student, :first_name => "Kim", :last_name => "Park", :date_of_birth => 14.years.ago.to_date, :rank => 1, :waiver_signed => false)
			@peter = FactoryGirl.create(:student, :first_name => "Peter", :last_name => "Xiao", :date_of_birth => 12.years.ago.to_date, :active => false, :rank => 5)
			
			@breaking = FactoryGirl.create(:event)
			@reading = FactoryGirl.create(:event, :name => "Reading", :active => true)
			@dancing = FactoryGirl.create(:event, :name => "Dancing", :active => true)
			
			@sec1 = FactoryGirl.create(:section, :event => @breaking, :min_age => 10, :max_age => 30, :min_rank => 1, :max_rank => 9)
			@sec2 = FactoryGirl.create(:section, :event => @reading, :min_age => 13, :max_age => 25, :min_rank => 1, :max_rank => 50)
			@sec3 = FactoryGirl.create(:section, :event => @dancing, :min_age => 6, :max_age => 50, :min_rank => 1, :max_rank  => 49)
		
			@reg_ken2 = FactoryGirl.create(:registration, :section => @sec2, :student => @kenneth, :date => Date.today.weeks_ago(4), :fee_paid => true, :final_standing => 3)
			@reg_ken3 = FactoryGirl.create(:registration, :section => @sec3, :student => @kenneth, :date => Date.today.weeks_ago(2), :fee_paid => true, :final_standing => 5)
			@reg_kim1 = FactoryGirl.create(:registration, :section => @sec1, :student => @kim, :date => Date.today.weeks_ago(2), :fee_paid => false, :final_standing => 9)
			@reg_kim3 = FactoryGirl.create(:registration, :section => @sec3, :student => @kim, :date => Date.today.weeks_ago(8), :fee_paid => true, :final_standing => 3)
			@reg_pete1 = FactoryGirl.create(:registration, :section => @sec1, :student => @peter, :date => Date.today.weeks_ago(5), :fee_paid => true, :final_standing => 11)
			@reg_pete3 = FactoryGirl.create(:registration, :section => @sec3, :student => @peter, :date => Date.today.weeks_ago(3), :fee_paid => false, :final_standing => 20)
			@reg_kim2 = FactoryGirl.create(:registration, :section => @sec2, :student => @kim, :date => Date.today.weeks_ago(15), :fee_paid => true, :final_standing => 1)

		end
		
		teardown do
			@kenneth.destroy
			@kim.destroy
			@peter.destroy
			@breaking.destroy
			@reading.destroy
			@dancing.destroy
			@sec1.destroy
			@sec2.destroy
			@sec3.destroy
		end
	
		# test valid_age validation
		should "shows that valid_age works" do
			bad_reg = FactoryGirl.build(:registration, :section => @sec2, :student => @peter)
			deny bad_reg.valid?
		end
		
		# test valid_rank validation
		should "shows that valid_rank works" do
			bad_reg = FactoryGirl.build(:registration, :section => @sec1, :student => @kenneth)
			deny bad_reg.valid?	
		end
		
		# test scope for_section
		should "shows the correct number of registrations of a particular section" do
			assert_equal 2, Registration.for_section(@sec2.id).size
		end
	
		# test scope for_student
		should "shows that Kim has 3 registrations" do
			assert_equal 3, Registration.for_student(@kim.id).size
		end
		
		# test scope by_student
		should "order the registrations by student's last name, first name" do
			assert_equal ["Kenneth", "Kenneth", "Kim", "Kim", "Kim", "Peter", "Peter"], Registration.by_student.map{|r| r.student.first_name}
		end
		
		# test scope by_date
		should "order the registrations by date" do
			assert_equal ["Kim", "Kim", "Peter", "Kenneth", "Peter", "Kenneth", "Kim"], Registration.by_date.map{|r| r.student.first_name}
		end
		
		# test scope by_event_name
		should "order the registrations by event" do
			assert_equal ["Breaking", "Breaking", "Dancing", "Dancing", "Dancing", "Reading", "Reading"], Registration.by_event_name.map{|r| r.section.event.name}
		end
	end
	
end
