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


end