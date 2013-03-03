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
	
	# test for round_time
	should allow_value(Time.now).for(:round_time)
	should allow_value(Time.local(2012, 1, 1, 1, 1, 1)).for(:round_time)
	should_not allow_value("12:30").for(:round_time)
	should_not allow_value(4).for(:round_time)
	
end
