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
          lat
          lon
        }
      }
    }
    )


    resp = HTTP.post("https://api.digitransit.fi/routing/v1/routers/finland/index/graphql", body: query)

    data = JSON.load(resp.body.to_s)

    stops = data.dig("data", "routes").map {|r| r["stops"] }.flatten.uniq {|s| s["name"]}
    stops.each {|s| s["id"] = Base64.decode64(s["id"]) }

    pp stops
    puts "\nUnique stops: #{stops.size}"
  end
end
