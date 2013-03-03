require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test relationships
	should have_many(:sections)
	
	# test basic validations
	should validate_uniqueness_of(:name)
	
	context "Creating five different events" do
		setup do
			@breaking = FactoryGirl.create(:event)
			@eating = FactoryGirl.create(:event, :name => "Eating", :active => false)
			@reading = FactoryGirl.create(:event, :name => "Reading", :active => false)
			@dancing = FactoryGirl.create(:event, :name => "Dancing", :active => true)
			@tackling = FactoryGirl.create(:event, :name => "Tackling", :active => true)
		end
		
		teardown do
			@breaking.destroy
			@eating.destroy
			@reading.destroy
			@dancing.destroy
			@tackling.destroy
		end
		# test scope alphabetical
		should "shows the events in alphabetical order" do
			assert_equal ["Breaking", "Dancing", "Eating", "Reading", "Tackling"], Event.alphabetical.map{|e| e.name}
		end
		
		# test scope active
		should "shows that there are three active events" do
			assert_equal 3, Event.active.size
			assert_equal ["Breaking", "Dancing", "Tackling"], Event.active.alphabetical.map{|e| e.name}
		end
		
		should "shows that there are two inactive events" do
			assert_equal 2, Event.inactive.size
			assert_equal ["Eating", "Reading"], Event.inactive.alphabetical.map{|e| e.name}
		end
	end
end