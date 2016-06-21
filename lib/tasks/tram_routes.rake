ROUTE_COLORS = {
  "1" => "#83BEDF",
  "1A" => "#83BEDF",
  "2" => "#1CA363",
  "3" => "#8DC798",
  "4" => "#C82152",
  "4T" => "#C82152",
  "5" => "#c780a5",
  "6" => "#944A95",
  "6T" => "#944A95",
  "7A" => "#F7AE3D",
  "7B" => "#F7AE3D",
  "8" => "#C97932",
  "9" => "#CC2287",
  "10" => "#C4BB3E"
}

namespace :tram_routes do
  desc "Convert the text files into valid GeoJSON"
  task :geojson, [:base_path] => :environment do |_, args|
    args.with_defaults(base_path: File.expand_path("../../../tram-challenge-ios/TramChallenge/Data", __dir__))

    base_path = File.expand_path(args[:base_path])
    puts "Trying with data in #{base_path}"

    if File.directory?(base_path)
      glob = Pathname.new(base_path).join("*.txt")

      geojson = {
        "type" => "FeatureCollection",
        "features" => []
      }

      Dir[glob.to_s].each_with_index do |path|
        puts "Reading #{path}"

        data = File.read(path)
        data.gsub!(/\],\n\]$/, "]]")

        begin
          coordinates = JSON.parse(data)
        rescue JSON::ParserError
          puts data
          raise
        end

        route_name = File.basename(path).split(".").first

        feature = {
          "type" => "Feature",
          "properties" => {
            "route" => route_name,
            "route-color" => ROUTE_COLORS[route_name] || "#444",
          },
          "geometry" => {
            "type" => "LineString",
            "coordinates" => coordinates.fetch("line").map {|c| [c[1], c[0]]}
          }
        }

        geojson["features"] << feature
      end

      geojson_path = Rails.root.join("public", "geojson/routes.json")
      File.open(geojson_path, "wb") do |f|
        f.write(JSON.dump(geojson))
      end
      puts "Created #{geojson_path}"
    else
      abort "Not a directory"
    end
  end

  desc "Clobber existing GeoJSON files"
  task clobber: :environment do
    glob = Rails.root.join("public", "geojson/*.json")
    Dir[glob].each do |path|
      FileUtils.remove_entry_secure(path)
    end
    puts "Removed existing GeoJSON files"
  end

end
