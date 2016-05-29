json.type "FeatureCollection"
json.features @stops do |stop|
  json.type "Feature"
  json.geometry do
    json.type "Point"
    json.coordinates [stop.longitude, stop.latitude]
  end
  json.properties do
    json.title stop.name
    json.set! "marker-symbol", "monument"
  end
end
