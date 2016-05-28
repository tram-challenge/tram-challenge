namespace :tram_routes do
  desc "Convert the text files into valid GeoJSON"
  task :geojson, [:base_path] => :environment do |_, args|
    args.with_defaults(base_path: File.expand_path("../../../tram-challenge-ios/TramChallenge/Data", __dir__))

    base_path = File.expand_path(args[:base_path])
    puts "Trying with data in #{base_path}"

    if File.directory?(base_path)
      glob = Pathname.new(base_path).join("*.txt")

      Dir[glob.to_s].each do |path|
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

        geojson = {
          "type" => "Feature",
          "properties" => {},
          "geometry" => {
            "type" => "LineString",
            "coordinates" => coordinates.fetch("line").map {|c| [c[1], c[0]]}
          }
        }

        geojson_path = Rails.root.join("public", "geojson/#{route_name}.json")
        File.open(geojson_path, "wb") do |f|
          f.write(JSON.dump(geojson))
        end
        puts "Created #{geojson_path}"
      end
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
