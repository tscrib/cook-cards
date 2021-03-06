require 'spec_helper'

describe "Authentication" do

	subject { page }

	# local variables
	let(:user) { FactoryGirl.create(:user) }
	let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
	let(:non_admin) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }
	let(:recipe) { FactoryGirl.create(:recipe) }
	@search_recipe = Recipe.new(title: "Smoothies", 
						ingredients: "lots of fruits",
						directions: "mix and blend and enjoy",
						photo_url: "http://www.google.com/logos/2012/startrek12-hp.jpg")
					@search_recipe.save!

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector('h1',    text: 'Sign in') }
		it { should have_selector('title', text: 'Sign in') }

		describe "not signed in" do
			it { should_not have_link('Profile', href: user_path(user)) }
			it { should_not have_link('Settings', href: edit_user_path(user)) }
		end

		describe "signin" do

			describe "with invalid information" do
				before { click_button "Sign in" }

				it { should have_selector('title', text: 'Sign in') }
				it { should have_error_message('Invalid') }
			end

			describe "after visiting another page" do
				before { click_link "My Recipes" }
				it { should_not have_error_message('') }
			end
		end

		describe "with valid information" do
			
			before { sign_in( user ) }

			it { should have_selector('title', text: user.name) }
			it { should have_link('Users',    href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_selector('title', text: 'Sign in') }
					it { should_not have_button('Add new Recipe') }
				end
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					sign_in( user )
				end

				describe "after signing in" do

					it "should render the desired protected page" do
						page.should have_selector('title', text: 'Edit user')
					end
				end

				describe "when signing in again" do
					before do
						visit signin_path
						sign_in( user )
					end

					it "should render the default (profile) page" do
						page.should have_selector('title', text: user.name) 
					end
				end

			end

			# describe "in the Microposts controller" do

			# 	describe "submitting to the create action" do
			# 		before { post microposts_path }
			# 		specify { response.should redirect_to(signin_path) }
			# 	end

			# 	describe "submitting to the destroy action" do
			# 		before { delete micropost_path(FactoryGirl.create(:micropost)) }
			# 		specify { response.should redirect_to(signin_path) }
			# 	end

			# 	describe "delete links do not appear for other users" do
			# 		before do
			# 			FactoryGirl.create(:micropost, user: wrong_user, content: "Foo")
			# 		 	sign_in user
			# 			visit edit_user_path(wrong_user)
			# 		end

			# 		it { should_not have_link('delete', href: micropost_path(wrong_user)) }
			# 	end
			# end

			describe "in the Recipes controller" do

				describe "visit recipe index" do
					before { visit recipes_path }
					it { should have_selector('title', text: "All Recipes") }
					it { should_not have_link( "icon-remove" ) }
					it { should_not have_button( "Add to my Recipes" ) }
					it { should_not have_link( "icon-pencil" ) }

				end

				describe "visit specific recipe" do
					before { visit recipe_path(recipe) }
					it { should have_selector('title', text: recipe.title) }
				end

				describe "visit recipe new" do
					before { visit new_recipe_path }
					it { should have_selector('title', text: "Sign in") }
				end

			end
		end

		describe "as wrong user" do
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Edit user')) }
			end

			describe "visiting Recipes#edit page" do
				before { visit edit_recipe_path(user) }
				it { should_not have_selector('title', text: full_title('Edit Recipe')) }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end

			describe "submitting a PUT request to the Recipes#update action" do
				before { put recipe_path(user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			before { sign_in non_admin }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }        
			end

			describe "submitting a DELETE request to the Recipes#destroy action" do
				before { delete recipe_path(recipe) }
				specify { response.should redirect_to(root_path) }        
			end
		end

		describe "as admin" do
			before { sign_in admin}

			describe "submit a DELETE request to destroy yourself" do
				before { delete user_path(admin) }
				specify { response.should redirect_to(root_path) }        
			end

			describe "visit recipe index" do
				before { visit recipes_path }

				it { should have_link( "icon-remove" ) }
				it { should have_button( "Add to my Recipes" ) }
				it { should have_link( "icon-pencil" ) }

				describe "edit button goes to edit page" do
					before { click_link "icon-pencil" }
					it { should have_selector('title', text: "Edit Recipe") }
				end
			end
		end
	end
end
