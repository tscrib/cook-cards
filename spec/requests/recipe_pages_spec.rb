require 'spec_helper'

describe "RecipePages" do

	subject { page }

	# define local variables
	let(:user) { FactoryGirl.create(:user) }
	let(:recipe) { FactoryGirl.create(:recipe) }

	describe "index" do
		before do
			sign_in user
			visit recipes_path
		end

		it { should have_selector('title', text: 'All Recipes') }
		it { should have_selector('h1',    text: 'All Recipes') }

		describe "pagination" do

			before(:all) { 40.times { FactoryGirl.create(:recipe) } }
			after(:all)  { Recipe.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each recipe" do
				Recipe.paginate(page: 1).each do |recipe|
					page.should have_selector('li', text: recipe.title)
				end
			end
		end

	end

	describe "new" do

		
	end

	describe "create" do
		
	end

	describe "show" do
		before do
			sign_in user
			visit recipe_path(recipe)
		end

		it { should have_selector('title', text: recipe.title) }
		it { should have_selector('text', text: recipe.ingredients) }
		it { should have_selector('text', text: recipe.directions) }
		it { should have_link('Click for larger photo', href: recipe.photo_url) }

	end


	describe "edit" do
		
	end


	describe "update" do
		
	end

	describe "destroy" do
		
	end


end
