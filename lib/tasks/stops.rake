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

    # Delete the old 4T if it's present
    data["data"]["routes"].delete_if { |r| r["shortName"] == "4T" }

    # Get the route with the most trips, that's likely to be the “main” route
    # for that tram line.
    data["data"]["routes"].each do |route|
      route["patterns"].sort_by! {|p| p["trips"].length }.reverse!
      route["stops"] = route["patterns"][0]["stops"]
      if route["shortName"] == "6T" || route["shortName"] == "6"
        extra_stops = route["patterns"][1]["stops"].select {|stop| stop["name"] == "Hietalahdenkatu" || stop["name"] == "Kalevankatu"}
        insert_index = route["stops"].index {|stop| stop["name"] == "Hietalahdentori"}
        if extra_stops.size == 2 && insert_index
          route["stops"].insert(insert_index, extra_stops[1])
          route["stops"].insert(insert_index, extra_stops[0])
        end
      end

      if (route["shortName"] == "9" || route["shortName"] == "6T") && !route["stops"].detect {|stop| stop["name"] == "Bunkkeri"}
        extra_stops = route["patterns"][1]["stops"].select {|stop| stop["name"] == "Bunkkeri"}
        insert_index = route["stops"].index {|stop| stop["name"] == "Huutokonttori"}
        if extra_stops.size == 1 && insert_index
          route["stops"].insert(insert_index, extra_stops[0])
        end
      end
      if route["shortName"] == "5"
        extra_stops = route["patterns"][1]["stops"].select {|stop| stop["name"] == "Ylioppilastalo"}
        insert_index = route["stops"].index {|stop| stop["name"] == "Mikonkatu"}
        if extra_stops.size == 1 && insert_index
          route["stops"].insert(insert_index, extra_stops[0])
        end
      end
    end

    # fix line 8, add the first stops in 8H to route 8
    route8 = data["data"]["routes"].detect {|route| route["shortName"] == "8"}
    route8H = data["data"]["routes"].detect {|route| route["shortName"] == "8H"}
    last_8_stop_name = route8["stops"].last["name"]
    index_in_8H = route8H["stops"].find_index {|stop| stop["name"] == last_8_stop_name}
    (index_in_8H - 1).downto(0) do |i|
      route8["stops"] << route8H["stops"][i]
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
