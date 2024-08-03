require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(name: "Test User")
  end

  describe "validations" do
    it "is valid with a name" do
      expect(@user).to be_valid
    end

    it "is not valid without a name" do
      @user.name = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "has many assignations" do
      association = User.reflect_on_association(:assignations)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe "instance methods" do
    it "returns the correct name" do
      expect(@user.name).to eq("Test User")
    end
  end

end
