require 'rails_helper'

RSpec.describe Api::StopsController, type: :controller do
  let(:stop) {
    Stop.create(
      name: "Fake stop #1",
      longitude: 0,
      latitude: 0,
      active: true
    )
  }
  let(:stops) {
    [
      Stop.create(
        name: "Fake stop #2",
        longitude: 5,
        latitude: 4,
        active: true
      ),
      stop
    ]
  }

  describe "GET index" do
    it "returns a list of stops" do
      stops

      get :index
      expect(response.status).to eq(200)

      resp_stops = JSON.parse(response.body)
      expect(resp_stops.size).to eq(2)

      expect(resp_stops.map {|s| s["id"]}).to match_array(stops.map(&:id))
    end
  end

  describe "GET show" do
    it "returns the current player's information" do
      get :show, params: { id: stop.id }
      expect(response.status).to eq(200)

      resp_stop = JSON.parse(response.body)
      expect(resp_stop.fetch("id")).to eq(stop.id)
      expect(resp_stop.fetch("name")).to eq(stop.name)
    end
  end
end
