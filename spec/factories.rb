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

	factory :recipe do
		title "French Toast"
		directions "Lorem ipsum"
		ingredients "e pluribus unum"
		photo_url "http://i.istockimg.com/file_thumbview_approve/157077/2/stock-photo-157077-e-pluribus-unum.jpg"
	end
end