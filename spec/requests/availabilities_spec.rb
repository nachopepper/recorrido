require 'rails_helper'

RSpec.describe "Availabilities", type: :request do
  describe "GET /availabilities" do
    before(:each) do
      @start_week = Date.today.beginning_of_week.strftime(DATE_FORMAT)
      @end_week = Date.today.end_of_week.strftime(DATE_FORMAT)
  
      @user1 = User.create(name: "User 1")
      @user2 = User.create(name: "User 2")
      @assignation1 = Assignation.create(date: @start_week, start_time: "09:00", end_time: "10:00")
      @assignation2 = Assignation.create(date: @start_week, start_time: "10:00", end_time: "11:00")
  
      @availability1 = Availability.create(assignation: @assignation1, user: @user1, enabled: true)
      @availability2 = Availability.create(assignation: @assignation1, user: @user2, enabled: false)
      @availability3 = Availability.create(assignation: @assignation2, user: @user1, enabled: true)
    end
    context "when valid date range is provided" do
      it "returns the correct data and status" do
        get "/availabilities?start_week=#{@start_week}&end_week=#{@end_week}"
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
      end
    end

    context "when no date range is provided" do
      it "returns an error message" do
        get "/availabilities"

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Falta fecha de inicio y termino")
      end
    end

    context "when an unexpected error occurs" do
      it "returns an internal server error response" do
        allow(Availability).to receive(:includes).and_raise(StandardError, "Unexpected error")
  
        get "/availabilities?start_week=#{@start_week}&end_week=#{@end_week}"
  
        expect(response).to have_http_status(:internal_server_error)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Internal server error AssignationsController#index")
      end
    end
  end
end
