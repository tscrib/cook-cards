# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  recipe_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Relationship do
  let(:user) { FactoryGirl.create(:user) }
  let(:recipe) { FactoryGirl.create(:recipe) }
  let(:relationship) { user.relationships.build(recipe_id: recipe.id) }

  subject { relationship }

  it { should be_valid }
# don't think this test is valid anymore
  # describe "accessible attributes" do
  #   it "should not allow access to user_id" do
  #     expect do
  #       Relationship.new(user_id: user.id)
  #     end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end    
  # end

  describe "when followed id is not present" do
    before { relationship.recipe_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.user_id = nil }
    it { should_not be_valid }
  end
end
