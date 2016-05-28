var vehiclesGeoJSON = function(callback) {
  var url = "https://api.digitransit.fi/realtime/vehicle-positions/v1/hfp/journey/tram/";

  $.getJSON(url, function(data, status, xhr) {
    var geoJSON = {
        "type": "geojson",
        "data": {
            "type": "FeatureCollection",
            "features": []
        }
    }

    Object.keys(data).forEach(function(id){
      var vehicle = data[id].VP;

      geoJSON.data.features.push({
        "type": "Feature",
        "geometry": {
            "type": "Point",
            "coordinates": [vehicle.long, vehicle.lat]
        },
        "properties": {
            "title": vehicle.line.replace(/^10+/, ""),
            "marker-symbol": "marker",
            "vehicle-id": vehicle.veh
        }
      });
    });

    callback(geoJSON)
  });
}


var uuid = function() {
  var uuid = "", i, random;
  for (i = 0; i < 32; i++) {
    random = Math.random() * 16 | 0;

    if (i == 8 || i == 12 || i == 16 || i == 20) {
      uuid += "-"
    }
    uuid += (i == 12 ? 4 : (i == 16 ? (random & 3 | 8) : random)).toString(16);
  }
  return uuid;
}

$(document).on("turbolinks:load", function() {
  if ($("[data-role~=map]").length) {
    $("[data-role~=map]").each(function(i, el) {
      $el = $(el)

      mapboxgl.accessToken = "pk.eyJ1IjoibWF0aWFza29yaG9uZW4iLCJhIjoiRkNzbl9vRSJ9.K7DdroE6DQ58YUxCMJv4Lg";
      var map = new mapboxgl.Map({
        container: el,
        style: ($el.data("style") ? $el.data("style") : "mapbox://styles/mapbox/streets-v8"),
        center: [24.9384, 60.1800],
        zoom: 11,
        interactive: ($el.data("disable-interaction") ? false : true),
        pitch: ($el.data("pitch") ? $el.data("pitch") : 0),
        bearing: 0,
      });

      if ($el.data("animator") && $el.data("animator") == "rotator") {
        function rotator(){
          map.easeTo({bearing:60, duration:16000, pitch:55, zoom:14});
          window.setTimeout(function(){
            map.easeTo({bearing:180, duration:18000, pitch:0, zoom:10});
            window.setTimeout(function(){
              map.easeTo({bearing:220, duration:14000, pitch:70, zoom:11});
              window.setTimeout(function(){
                rotator()
              }, 7000)
            }, 10000)
          }, 9000)
        }
        map.on("load", function(){
          rotator()
        })
      }

      if ($el.data("realtime")) {
        map.on("load", function () {
          vehiclesGeoJSON(function(geoJSON) {
            map.addSource("vehicle-markers", geoJSON);
            map.addLayer({
              "id": "vehicle-markers",
              "type": "symbol",
              "source": "vehicle-markers",
              "layout": {
                "icon-image": "{marker-symbol}-11",
                "text-field": "{title}",
                "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
                "text-offset": [0, 0.6],
                "text-anchor": "top"
              }
            });
          });

          setInterval(function() {
            vehiclesGeoJSON(function(newJSON) {
              map.getSource("vehicle-markers").setData(newJSON.data);
            })
          }, 1000)
        })
      }

      if ($el.data("routes")) {
        map.on("load", function () {
          var url = "/routes"
          $.getJSON(url, function(urls) {
            $.each(urls, function(i, routeURL) {
              $.getJSON(routeURL, function(json, status, xhr) {
                var id = "route-" + uuid();
                console.log(id)
                debugger
                map.addSource(id, {
                  "type": "geojson",
                  "data": json
                });

                map.addLayer({
                  "id": id,
                  "type": "line",
                  "source": id,
                  "layout": {
                    "line-join": "round",
                    "line-cap": "round"
                  },
                  "paint": {
                    "line-color": "#888",
                    "line-width": 2
                  }
                });
              });
            });
          })
        })
      }

    })
  }
});
