# == Schema Information
#
# Table name: recipes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string(255)
#  ingredients :text
#  directions  :text
#  photo_url   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Recipe do
	let(:user) { FactoryGirl.create(:user) }

	before do
		@recipe = user.recipes.build(
			title: "Onion Quiche", 
			directions: "1. Draw two cicles\n2. Now draw the rest of the owl", 
			ingredients: "1. Brains", 
			photo_url: "http://i.istockimg.com/file_thumbview_approve/17798895/2/stock-photo-17798895-crab-quiche.jpg"
			)
	end

	subject { @recipe }

	it { should respond_to(:user_id) }
	it { should respond_to(:title) }
	it { should respond_to(:ingredients) }
	it { should respond_to(:directions) }
	it { should respond_to(:photo_url) }
	its(:user) { should == user }

	it { should be_valid }

	describe "validations" do
		describe "accessible attributes" do
			it "should not allow access to user_id" do
				expect do
					Recipe.new(user_id: user.id)
				end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
			end    
		end

		describe "when user_id is not present" do
			before { @recipe.user_id = nil }
			it { should_not be_valid }
		end

		describe "with blank title" do
			before { @recipe.title = " " }
			it { should_not be_valid }
		end

		describe "with blank directions" do
			before { @recipe.directions = " " }
			it { should_not be_valid }
		end

		describe "with blank photo_url" do
			before { @recipe.photo_url = " " }
			it { should_not be_valid }
		end

		describe "with bad photo url" do
			before { @recipe.photo_url = "www.google" }
			it { should_not be_valid }
		end
	end

end
