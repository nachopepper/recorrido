require 'rails_helper'

RSpec.describe "Assignations", type: :request do
  describe "GET /assignations" do

    before(:each) do
      @start_week = Date.today.at_beginning_of_week.strftime(DATE_FORMAT)
      @end_week = Date.today.at_end_of_week.strftime(DATE_FORMAT)
      @user1 = User.create(name: "User 1")
      @user2 = User.create(name: "User 2")
      @assignation1 = Assignation.create(date: @start_week, start_time: "09:00", end_time: "10:00", user: @user1)
      @assignation2 = Assignation.create(date: @start_week, start_time: "10:00", end_time: "11:00", user: @user2)
      @assignation3 = Assignation.create(date: @start_week, start_time: "11:00", end_time: "12:00", user: nil)
    end

    context "when valid date range is provided" do
      it "returns the correct data and status" do
        get "/assignations?start_week=#{@start_week}&end_week=#{@end_week}"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["total_hours"]).to eq(3)
        expect(json_response["hours_assigned"]).to eq(2)
        expect(json_response["hours_available"]).to eq(1)

        expect(json_response["hours_per_user"]).to contain_exactly(
          { "id" => @user1.id, "name" => @user1.name, "hours_assigned" => 1 },
          { "id" => @user2.id, "name" => @user2.name, "hours_assigned" => 1 }
        )
      end
    end

    context "when no date range is provided" do
      it "returns an empty result" do
        get "/assignations"

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Falta fecha de inicio y termino")
      end
    end

    context "when an unexpected error occurs" do
      it "returns an internal server error response" do
        allow(Assignation).to receive(:where).and_raise(StandardError, "Unexpected error")
  
        get "/assignations?start_week=#{@start_week}&end_week=#{@end_week}"
  
        expect(response).to have_http_status(:internal_server_error)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Internal server error AssignationsController#index")
      end
    end
  end

  describe "PUT /assignations/:id" do
    before(:each) do
      @user = User.create(name: "User 1")
      @assignation = Assignation.create(
        date: Date.today,
        start_time: "09:00",
        end_time: "10:00",
        user: @user
      )
    end
    context "when the assignation exists" do
      it "updates the assignation and returns a successful response" do
        new_user = User.create(name: "User 2")
        
        put "/assignations/#{@assignation.id}", params: { assignation: { user_id: new_user.id } }, as: :json
        
        @assignation.reload
        expect(@assignation.user_id).to eq(new_user.id)  # Verifica que el user_id se haya actualizado
        expect(response).to have_http_status(:ok)  # Verifica que la respuesta HTTP es exitosa (200 OK)
        
        json_response = JSON.parse(response.body)
        expect(json_response['user_id']).to eq(new_user.id)  # Verifica que el JSON devuelto contiene el user_id actualizado
      end
    end

    context "when the assignation does not exist" do
      it "returns an error message and a not found response" do
        put "/assignations/-1", params: { assignation: { user_id: @user.id } }, as: :json

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Asignación no encontrada")
      end
    end

    context "when an unexpected error occurs" do
      it "returns an internal server error response" do
        allow_any_instance_of(Assignation).to receive(:update).and_raise(StandardError, "Unexpected error")
        put "/assignations/#{@assignation.id}", params: { assignation: { user_id: @user.id } }, as: :json
        expect(response).to have_http_status(:internal_server_error)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Internal server error AssignationsController#update")
      end
    end

  end
end