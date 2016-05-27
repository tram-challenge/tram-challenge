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

    pp data
  end
end
