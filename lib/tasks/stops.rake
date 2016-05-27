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

    stop_data = data.dig("data", "routes").map {|r| r["stops"] }.flatten.group_by {|s| s["name"]}

    Stop.transaction do
      stop_data.each do |name, data|
        print "Creating #{name}"

        points = data.map {|s| [s["lat"], s["lon"]] }
        centre = Geocoder::Calculations.geographic_center points
        print "."

        stop = Stop.find_or_initialize_by(name: name)
        print "."
        stop.latitude, stop.longitude = centre
        print "."
        stop.hsl_ids = data.map {|s| Base64.decode64(s["id"]) }
        print "."
        stop.stop_numbers = data.map {|s| s["code"] }

        stop.save!
        puts " done"
      end
    end

    puts "Known stops: #{Stop.count}"
  end
end
