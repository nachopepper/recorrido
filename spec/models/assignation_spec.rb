require 'rails_helper'

RSpec.describe Assignation, type: :model do
  before(:each) do
    @user = User.create(name: "Test User")
    @assignation = Assignation.create(date: Date.today, start_time: "19:00", end_time: "20:00")
  end

  describe "valid edit user" do
    it "adds user to assignation" do
      @assignation.update(user_id: @user.id)
      expect(@assignation.user_id).to eq(@user.id)
    end
  end

  describe "valid edit user null" do
    it "adds user null to assignation" do
      @assignation.update(user_id: nil)
      expect(@assignation.user_id).to eq(nil)
    end
  end

  describe "invalid assignation" do
    it "is not valid without a date" do
      invalid_assignation = Assignation.new(start_time: "19:00", end_time: "20:00")
      expect(invalid_assignation).not_to be_valid
      expect(invalid_assignation.errors[:date]).to include("can't be blank")
    end

    it "is not valid without a start_time" do
      invalid_assignation = Assignation.new(date: Date.today, end_time: "20:00")
      expect(invalid_assignation).not_to be_valid
      expect(invalid_assignation.errors[:start_time]).to include("can't be blank")
    end

    it "is not valid without an end_time" do
      invalid_assignation = Assignation.new(date: Date.today, start_time: "19:00")
      expect(invalid_assignation).not_to be_valid
      expect(invalid_assignation.errors[:end_time]).to include("can't be blank")
    end
  end

end