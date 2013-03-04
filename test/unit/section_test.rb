require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # test relationships
	should have_many(:registrations)
	should have_many(:students).through(:registrations)
	should belong_to(:event)
	
	
	# test for min_age
	should allow_value(7).for(:min_age)
	should allow_value(5).for(:min_age)
	should allow_value(25).for(:min_age)
	should_not allow_value(4).for(:min_age)
	should_not allow_value(nil).for(:min_age)
	should_not allow_value("nine").for(:min_age)
	
	# test for max_age
	should allow_value(5).for(:max_age)
	should allow_value(99).for(:max_age)
	should allow_value(nil).for(:max_age)
	should_not allow_value(4).for(:max_age)
	should_not allow_value("nine").for(:max_age)
	
	# test for min_rank
	should allow_value(10).for(:min_rank)
	should allow_value(1).for(:min_rank)
	should_not allow_value(0).for(:min_rank)
	should_not allow_value(-2).for(:min_rank)
	should_not allow_value(nil).for(:min_rank)
	should_not allow_value("ten").for(:max_rank)
	
	# test for max_rank
	should allow_value(10).for(:max_rank)
	should allow_value(1).for(:max_rank)
	should allow_value(nil).for(:max_rank)
	should_not allow_value(0).for(:max_rank)
	should_not allow_value(-2).for(:max_rank)
	should_not allow_value("ten").for(:max_rank)
	
	context "Creating some sections" do
		setup do
			@breaking = FactoryGirl.create(:event)
			@eating = FactoryGirl.create(:event, :name => "Eating", :active => true)
			@dancing = FactoryGirl.create(:event, :name => "Dancing", :active => true)
			@running = FactoryGirl.create(:event, :name => "Running", :active => false)
			@lifting = FactoryGirl.create(:event, :name => "Lifting", :active => true)
			@sec1 = FactoryGirl.create(:section, :event => @breaking, :min_age => 6, :max_age => 20, :min_rank => 1, :max_rank => 10, :active => true)
			@sec2 = FactoryGirl.create(:section, :event => @dancing, :min_age => 12, :max_age => 15, :min_rank => 3, :max_rank => 5, :active => true)
			@sec3 = FactoryGirl.create(:section, :event => @eating, :min_age => 6, :max_age => 20, :min_rank => 1, :max_rank => 10, :active => false)
			@sec4 = FactoryGirl.create(:section, :event => @lifting, :min_age => 18, :max_age => 25, :min_rank => 10, :max_rank => 14, :active => true)
			@sec4 = FactoryGirl.create(:section, :event => @lifting, :min_age => 15, :max_age => 18, :min_rank => 10, :max_rank => 14, :active => true)
		end
		
		teardown do
			@breaking.destroy
			@eating.destroy
			@dancing.destroy
			@running.destroy
			@lifting.destroy
		end
		
		# test scope active
		should "shows that there are 3 actives" do
			assert_equal 4, Section.active.size
		end
		
		# test scope inactive
		should "shows that there is 1 inactive" do
			assert_equal 1, Section.inactive.size
		end
		
		# test scope alphabetical
		should "shows the sections alphabeticalized by event name" do
			assert_equal ["Breaking", "Dancing", "Eating", "Lifting", "Lifting"], Section.alphabetical.map{|s| s.event.name}
		end
		
		# test scope for_event
		should "shows the correct number of sections for_event" do
			assert_equal 2, Section.for_event(@lifting.id).size
			assert_equal 1, Section.for_event(@eating.id).size
			assert_equal 0, Section.for_event(@running.id).size
		end
		
		# test scope for_rank
		should "shows the correct number of sections for_rank" do
			assert_equal 3, Section.for_rank(4).size
			assert_equal 0, Section.for_rank(99).size
			assert_equal 4, Section.for_rank(10).size
		end
		
		# test scope for_age
		should "shows the correct number of sections for_age" do
			assert_equal 2, Section.for_age(10).size
			assert_equal 4, Section.for_age(15).size
			assert_equal 0, Section.for_age(50).size
		end

		# test min_max_age validation
		should "shows that a section with a smaller max_age than min_age can not be created" do
			bad_section = FactoryGirl.build(:section, :event => @running, :min_age => 20, :max_age => 18)
			deny bad_section.valid?
		end
		
		# test min_max_rank validation
		should "shows that a section with a smaller max_rank than min_rank can not be created" do
			bad_section = FactoryGirl.build(:section, :event => @running, :min_rank => 20, :max_rank => 18)
			deny bad_section.valid?
		end
		
		# test event_active validation
		should "shows that there cannot be a section created with an inactive event" do
			bad_section = FactoryGirl.build(:section, :event => @running)
			deny bad_section.valid?
		end
		
		# test uniqueness validation
		should "shows that there cannot be duplicate section" do
			bad_section = FactoryGirl.build(:section, :event => @breaking, :min_age => 6, :max_age => 20, :min_rank => 1, :max_rank => 10, :active => true)
			deny bad_section.valid?
		end
	end
end
