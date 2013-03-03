FactoryGirl.define do
	factory :student do
		first_name "Kenneth"
		last_name "Chen"
		date_of_birth Date.today.years_ago(19)
		phone "1234567890"
		rank 10
		waiver_signed true
		active true
	end
	
	factory :section do
		association :event
		min_age 6
		max_age 10
		min_rank 5
		max_rank 7
		active true
	end
	
	factory :registration do
		association :section
		association :student
		date 1.month.ago.to_date
		fee_paid true
		final_standing 3
	end
	
	factory :event do
		name "Breaking"
		active true
	end
	
	factory :tournament do
		name "Iron Fist"
		date 1.month.from_now.to_date
		min_rank 1
		max_rank 20
		active true
	end
end