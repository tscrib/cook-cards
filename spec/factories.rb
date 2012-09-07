FactoryGirl.define do
	# factory now uses a sequence of users instead of 
	# a single hard-coded user
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@donotreply.com"}   
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	# factory :micropost do
	# 	content "Lorem ipsum"
	# 	user
	# end
end