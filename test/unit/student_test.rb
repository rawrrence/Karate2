require 'test_helper'

class StudentTest < ActiveSupport::TestCase
	# test relationships
	should have_many(:registrations)
	should have_many(:sections).through(:registrations)
	
	# test basic validations
	should validate_presence_of(:first_name)
	should validate_presence_of(:last_name)
	should validate_presence_of(:date_of_birth)
	should validate_presence_of(:rank)
	
	# tests for phone
	should allow_value("1111111111").for(:phone)
	should allow_value("222-222-1234").for(:phone)
	should allow_value("(123) 456-1231").for(:phone)
	should allow_value("111.123.9191").for(:phone)
	should allow_value("777.124-1231").for(:phone)
	should allow_value(nil).for(:phone)
	should_not allow_value("9992344").for(:phone)
	should_not allow_value("14129991234").for(:phone)
	should_not allow_value("441-1233-121").for(:phone)
	should_not allow_value("(718)1231231").for(:phone)
	should_not allow_value("111_111_1113").for(:phone)
	should_not allow_value("800-THE-SALT").for(:phone)
	should_not allow_value("111/321/1999").for(:phone)

	# tests for date_of_birth
	should allow_value(121.years.ago.to_date).for(:date_of_birth)
	should allow_value(18.years.ago.to_date).for(:date_of_birth)
	should allow_value(6.years.ago.to_date).for(:date_of_birth)
	should allow_value(5.years.ago.to_date).for(:date_of_birth)
	should_not allow_value(nil).for(:date_of_birth)
	should_not allow_value(18).for(:date_of_birth)
	should_not allow_value(4.years.ago.to_date).for(:date_of_birth)
	should_not allow_value(Date.today).for(:date_of_birth)
	
	context "Creating 11 different students" do
		setup do
			@kenneth = FactoryGirl.create(:student)
			@kim = FactoryGirl.create(:student, :first_name => "Kim", :last_name => "Park", :date_of_birth => Date.today.years_ago(14), :rank => 1, :waiver_signed => false)
			@peter = FactoryGirl.create(:student, :first_name => "Peter", :last_name => "Xiao", :date_of_birth => Date.today.years_ago(12), :active => false, :rank => 5)
			@jeff = FactoryGirl.create(:student, :first_name => "Jeff", :last_name => "Yan", :date_of_birth => Date.today.years_ago(11), :active => false, :rank => 1)
			@andrew = FactoryGirl.create(:student, :first_name => "Andrew", :last_name => "Lee", :date_of_birth => Date.today.years_ago(10), :rank => 10)
			@brandon = FactoryGirl.create(:student, :first_name => "Brandon", :last_name => "Chung", :date_of_birth => Date.today.years_ago(9), :rank => 90, :phone => "(718) 482-9291")
			@vince = FactoryGirl.create(:student ,:first_name => "Vince", :last_name => "Chung", :date_of_birth => Date.today.years_ago(9), :rank => 22)
			@ray = FactoryGirl.create(:student, :first_name => "Ray", :last_name => "Yu", :date_of_birth => Date.today.years_ago(8), :rank => 11, :waiver_signed => false)
			@cindy = FactoryGirl.create(:student, :first_name => "Cindy", :last_name => "Zhang", :date_of_birth => Date.today.years_ago(20), :rank => 8)
			@chris = FactoryGirl.create(:student, :first_name => "Chris", :last_name => "Zhu", :date_of_birth => Date.today.years_ago(130), :active => false, :rank => 1)
			@sharon = FactoryGirl.create(:student, :first_name => "Sharon", :last_name => "Chang", :date_of_birth => Date.today.years_ago(18), :rank => 3)	

			@breaking = FactoryGirl.create(:event)
			@sec = FactoryGirl.create(:section, :event => @breaking, :min_age => 10, :max_age => 20, :min_rank => 1, :max_rank => 5)
			@regkim = FactoryGirl.create(:registration, :section => @sec, :student => @kim, :date => Date.today.weeks_ago(2), :fee_paid => true, :final_standing => 2)
			@regpeter = FactoryGirl.create(:registration, :section => @sec, :student => @peter, :date => Date.today.weeks_ago(2), :fee_paid => true, :final_standing => 6)
			@regsharon = FactoryGirl.create(:registration, :section => @sec, :student => @sharon, :date => Date.today.weeks_ago(2), :fee_paid => true, :final_standing => 4)

		end
		
		teardown do
			@kenneth.destroy
			@kim.destroy
			@peter.destroy
			@jeff.destroy
			@andrew.destroy
			@brandon.destroy
			@vince.destroy
			@ray.destroy
			@cindy.destroy
			@chris.destroy
			@sharon.destroy
			@breaking.destroy
			@sec.destroy
			@regkim.destroy
			@regpeter.destroy
			@regsharon.destroy
		end
		
		# test scope alphabetical
		should "show the student's names in alphabetical order (according to last name, first name)" do
			assert_equal ["Sharon", "Kenneth", "Brandon", "Vince", "Andrew", "Kim", "Peter", "Jeff", "Ray", "Cindy", "Chris"], Student.alphabetical.map{|s| s.first_name}
		end
		
		# test scope juniors
		should "shows that there are 4 juniors" do
			assert_equal 7, Student.juniors.size
			assert_equal ["Brandon", "Vince", "Andrew", "Kim", "Peter", "Jeff", "Ray"], Student.juniors.alphabetical.map{|s| s.first_name}
		end	
	
		# test scope seniors
		should "shows that there are 4 seniors" do
			assert_equal 4, Student.seniors.size
			assert_equal ["Sharon", "Kenneth", "Cindy", "Chris"], Student.seniors.alphabetical.map{|s| s.first_name}
		end
		
		# test scope active
		should "shows that there are 8 actives" do
			assert_equal 8, Student.active.size
			assert_equal ["Sharon", "Kenneth", "Brandon", "Vince", "Andrew", "Kim", "Ray", "Cindy"], Student.active.alphabetical.map{|s| s.first_name}
		end
		
		#test scope inactive
		should "shows that there are 3 inactives" do
			assert_equal 3, Student.inactive.size
			assert_equal ["Peter", "Jeff", "Chris"], Student.inactive.alphabetical.map{|s| s.first_name}
		end
		
		#test scope gups
		should "shows that there are 8 gups" do
			assert_equal 8, Student.gups.size
			assert_equal ["Sharon", "Kenneth", "Andrew", "Kim", "Peter", "Jeff", "Cindy", "Chris"], Student.gups.alphabetical.map{|s| s.first_name}
		end
	
		#test scope dans
		should "shows that there are 3 dans" do
			assert_equal 3, Student.dans.size
			assert_equal ["Brandon", "Vince", "Ray"], Student.dans.alphabetical.map{|s| s.first_name}
		end
	
		# test scope has_waiver
		should "shows that there are 9 students that have their waivers signed" do
			assert_equal 2, Student.needs_waiver.size
			assert_equal ["Sharon", "Kenneth", "Brandon", "Vince", "Andrew", "Peter", "Jeff", "Cindy", "Chris"], Student.has_waiver.alphabetical.map{|s| s.first_name}
		end
		
		# test scope needs_waiver
		should "shows that there are 2 students that need their waivers signed" do
			assert_equal ["Kim", "Ray"], Student.needs_waiver.alphabetical.map{|s| s.first_name}
		end
		
		# test scope by_rank
		should "shows the students by rank in descending order" do
			assert_equal ["Brandon", "Vince", "Ray", "Kenneth", "Andrew", "Cindy", "Peter", "Sharon", "Kim", "Jeff", "Chris"], Student.by_rank.map{|s| s.first_name}
		end
		
		# test scope ranks_between
		should "shows that there are 4 students between ranks 4 and 10, inclusive" do
			assert_equal 4, Student.ranks_between(4, 10).size
			assert_equal ["Kenneth", "Andrew", "Peter", "Cindy"], Student.ranks_between(4, 10).alphabetical.map{|s| s.first_name}
		end
		
		should "shows that there are 6 students between ranks 8 and 100, inclusive" do
			assert_equal 6, Student.ranks_between(8, 100).size
			assert_equal ["Kenneth", "Brandon", "Vince", "Andrew", "Ray", "Cindy"], Student.ranks_between(8, 100).alphabetical.map{|s| s.first_name}
		end
		
		# test scope ages_between
		should "shows that there are 0 students between the ages of 6 and 7, inclusive" do
			assert_equal 0, Student.ages_between(6, 7).size
		end
		
		should "shows that there are 4 students between the ages of 10 and 14, inclusive" do
			assert_equal 4, Student.ages_between(10, 14).size
			assert_equal ["Andrew", "Kim", "Peter", "Jeff"], Student.ages_between(10, 14).alphabetical.map{|s| s.first_name}
		end
		
		# test the method name
		should "shows name as last name, first name" do
			assert_equal "Park, Kim", @kim.name
		end
		
		# test the method proper_name
		should "shows name as the proper name" do
			assert_equal "Brandon Chung", @brandon.proper_name
		end
		
		# test the method over_18?
		should "shows whether the student is over 18 or not" do
			assert @sharon.over_18?
			assert @kenneth.over_18?
			assert @chris.over_18?
			deny @vince.over_18?
		end
		
		# test the method age
		should "shows the method returns the correct age" do
			assert_equal 18, @sharon.age
			assert_equal 20, @cindy.age
			assert_equal 8, @ray.age
		end
		
		# test the registered_for_section method
		should "shows 3 students registered for section 1" do
			assert_equal 3, Student.registered_for_section(1).size
			assert_equal ["Sharon", "Kim", "Peter"], Student.registered_for_section(1).alphabetical.map{|s| s.first_name}
		end
		
		# test the callback reformat_phone
		should "shows the stripped phone number" do
			assert_equal "7184829291", @brandon.phone
		end
		
	end
	
end