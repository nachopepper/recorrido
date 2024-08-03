require 'rails_helper'

RSpec.describe Availability, type: :model do
  before(:each) do
    @user = User.create(name: "Test User")
    @assignation = Assignation.create(date: Date.today, start_time: "19:00", end_time: "20:00")
    @availability = Availability.new(
      assignation: @assignation,
      user: @user,
      enabled: true
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(@availability).to be_valid
    end

    it "is valid without an assignation" do
      @availability.assignation = nil
      expect(@availability).to be_valid
    end

    it "is valid without a user" do
      @availability.user = nil
      expect(@availability).to be_valid
    end
  end

  describe "associations" do
    it "belongs to an assignation" do
      association = Availability.reflect_on_association(:assignation)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a user" do
      association = Availability.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "instance methods" do
    it "returns the correct enabled status" do
      expect(@availability.enabled).to be true
    end
  end
end
