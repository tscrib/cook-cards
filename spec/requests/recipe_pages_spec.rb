require 'spec_helper'

describe "RecipePages" do

	subject { page }

	# define local variables
	let(:user) { FactoryGirl.create(:user) }
	let(:recipe) { FactoryGirl.create(:recipe) }
	let(:admin) { FactoryGirl.create(:admin) }

	describe "index" do
		before do
			sign_in user
			visit recipes_path
		end

		it { should have_selector('title', text: 'All Recipes') }
		it { should have_selector('h1',    text: 'All Recipes') }
		it { should have_button('Add new Recipe') }


		describe "pagination" do

			before(:all) { 40.times { FactoryGirl.create(:recipe) } }
			after(:all)  { Recipe.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each recipe" do
				Recipe.paginate(page: 1).each do |recipe|
					page.should have_selector('li', text: recipe.title)
					page.should have_button( "Add to my Recipes" )
				end
			end
		end


		describe "search" do
			it { should have_button( "icon-search" ) }
			it { should have_field('search_field', type: 'text') }

			before do
				@search_recipe = Recipe.new(title: "Smoothies", 
					ingredients: "lots of fruits",
					directions: "mix and blend and enjoy",
					photo_url: "http://www.google.com/logos/2012/startrek12-hp.jpg")
				@search_recipe.save!
				fill_in "search_field", with: "oo"
				click_button "icon-search"
			end

			it { should have_link(@search_recipe.title) }
			it { should_not have_link(recipe.title) }

		end

		describe "add by url" do
			it { should have_button( "icon-plus" ) }
			it { should have_field( 'add_by_url_field', type: 'text') }

			describe "with bad data" do
				it "should not create a recipe" do
					expect { click_button "icon-plus" }.not_to change(Recipe, :count)
				end
			end

			describe "with empty field" do
				before do
					fill_in "add_by_url_field", with: ""
				end

				it "should not create a recipe" do
					expect { click_button "icon-plus" }.not_to change(Recipe, :count)
				end
			end
			
			describe "with correct link" do
				before do
					fill_in "add_by_url_field", with: "http://allrecipes.com/recipe/peach-a-berry-pie/detail.aspx"
				end

				it "should create a recipe" do
					expect { click_button "icon-plus" }.to change(Recipe, :count)
				end
			end
		end
	end

	describe "new" do
		before do
			sign_in user
			visit recipes_path
			click_button "Add new Recipe"
		end

		it { should have_selector('h1', text: 'New Recipe') }
		it { should have_selector('label', text: 'Title') }
		it { should have_selector('label', text: 'Ingredients') }
		it { should have_selector('textarea', id: 'recipe_ingredients') }
		it { should have_selector('label', text: 'Directions') }
		it { should have_selector('textarea', id: 'recipe_directions') }
		it { should have_selector('label', text: 'Photo URL') }
		it { should have_selector('textarea', id: 'recipe_photo_url') }
		it { should have_button('Create Recipe') }
		
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
