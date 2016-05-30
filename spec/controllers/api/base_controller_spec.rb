require 'rails_helper'

RSpec.describe Api::BaseController, type: :controller do
  controller(Api::BaseController) do
    def index
      render json: {}, status: :ok
    end
  end

  context "the `icloud_user_id` parameter is present" do
    describe "GET index" do
      it "returns a 200 OK" do
         get :index, params: { icloud_user_id: SecureRandom.uuid }
         expect(response.status).to eq(200)
      end
    end
  end

  context "the `icloud_user_id` parameter is absent" do
    describe "GET index" do
      it "returns a 401 unauthorized" do
         get :index
         expect(response.status).to eq(401)
      end

      it "renders an error message" do
        get :index
        expect(response.body).to match(/"error"/)
      end
    end
  end
end
