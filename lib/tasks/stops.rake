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
        patterns {
          code
          trips {
            serviceId
          }
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
    }
    )

    endpoint_url = "https://api.digitransit.fi/routing/v1/routers/finland/index/graphql"

    resp = HTTP.headers("Content-Type": "application/graphql").
      post(endpoint_url, body: query)

    data = JSON.load(resp.body.to_s)

    # Delete the #5 tram since it doesn't exist yet
    # FIXME: reinstate it in the future
    data["data"]["routes"].delete_if { |r| r["shortName"] == "5" }

    # Get the route with the most trips, that's likely to be the “main” route
    # for that tram line.
    data["data"]["routes"].each do |route|
      route["patterns"].sort_by! {|p| p["trips"].length }.reverse!
      if route["shortName"] == "6T"
        route["stops"] = route["patterns"][1]["stops"]
      else
        route["stops"] = route["patterns"][0]["stops"]
      end
    end

    stops = {}

    data.dig("data", "routes").each do |route|
      route["stops"].each_with_index do |s, index|
        stops[s["name"]] ||= {
          coordinates: [],
          hsl_ids: [],
          stop_numbers: [],
          routes: [],
          stop_positions: {},
          active: true
        }
        stops[s["name"]][:coordinates] << [s["lat"], s["lon"]]
        stops[s["name"]][:hsl_ids] << Base64.decode64(s["id"])
        stops[s["name"]][:stop_numbers] << s["code"]
        stops[s["name"]][:routes] << route["shortName"]
        stops[s["name"]][:stop_positions][route["shortName"]] = index

        stops[s["name"]].each do |k, v|
          v.uniq! if v.respond_to?(:uniq!)
        end
      end
    end

    Stop.transaction do
      records = stops.map do |name, data|
        print "Creating #{name}"

        stop = Stop.find_or_initialize_by(name: name)
        print "."

        centre = Geocoder::Calculations.geographic_center data.delete(:coordinates)
        stop.latitude, stop.longitude = centre
        print "."

        stop.assign_attributes(data)

        stop.save!
        puts ". done"

        stop
      end

      print "Removing old stops"
      Stop.where.not(id: records.map(&:id)).update_all(active: false)
      puts "... done"

    end

    puts "Known stops: #{Stop.count}"
    puts "Active stops: #{Stop.active.count}"
  end
end
