namespace :stops do
  desc "Fetch the tram stops from the HSL data"
  task fetch: :environment do
    query = %(
    {
      routes(modes: "TRAM") {
        id
        agency {
          id
        }
        shortName
        longName
        desc
        stops {
          id
          gtfsId
          name
          code
          lat
          lon
        }
      }
    }
    )


    resp = HTTP.post("https://api.digitransit.fi/routing/v1/routers/finland/index/graphql", body: query)

    data = JSON.load(resp.body.to_s)

    # Delete the #5 tram since it doesn't exist yet
    # FIXME: reinstate it in the future
    data["data"]["routes"].delete_if { |r| r["shortName"] == "5" }

    data.dig("data", "routes").each do |route|
      route["stops"].each do |stop_data|
        stop_data["route"] = route["shortName"]
      end
    end

    stop_data = data.dig("data", "routes").
      map { |r| r["stops"] }.flatten.
      group_by { |s| s["name"] }

    Stop.transaction do
      stops = stop_data.map do |name, data|
        print "Creating #{name}"

        points = data.map {|s| [s["lat"], s["lon"]] }
        centre = Geocoder::Calculations.geographic_center points
        print "."

        stop = Stop.find_or_initialize_by(name: name)
        print "."
        stop.latitude, stop.longitude = centre
        print "."
        stop.hsl_ids = data.map {|s| Base64.decode64(s["id"]) }.uniq
        print "."
        stop.stop_numbers = data.map {|s| s["code"] }.uniq
        print "."
        stop.routes = data.map {|s| s["route"] }.uniq

        stop.active = true

        stop.save!
        puts " done"

        stop
      end

      print "Removing old stops... "
      Stop.where.not(id: stops.map(&:id)).update_all(active: false)
      puts "Done"
    end

    puts "Known stops: #{Stop.count}"
  end
end
