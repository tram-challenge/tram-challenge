require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #home" do
    it "renders the home page" do
      get :home
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:home)
    end
  end

  describe "GET #map" do
    it "renders the map page" do
      get :map
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:map)
    end
  end

  describe "GET #about" do
    it "renders the about page" do
      get :about
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:about)
    end
  end

  describe "GET #rules" do
    it "renders the rules page" do
      get :rules
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:rules)
    end
  end

end
