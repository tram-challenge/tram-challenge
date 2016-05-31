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

$(document).on("turbolinks:load", function() {
  if ($("[data-role~=map]").length) {
    $("[data-role~=map]").each(function(i, el) {
      $el = $(el)

      mapboxgl.accessToken = "pk.eyJ1IjoibWF0aWFza29yaG9uZW4iLCJhIjoiRkNzbl9vRSJ9.K7DdroE6DQ58YUxCMJv4Lg";

      var routeBounds = [
        [
          24.858627319335938,
          60.14526490373431
        ], // Southwest coordinates
        [
          24.991493225097656,
          60.21952545753577
        ]  // Northeast coordinates
      ]

      var map = new mapboxgl.Map({
        container: el,
        style: ($el.data("style") ? $el.data("style") : "mapbox://styles/mapbox/streets-v8"),
        center: [24.9384, 60.1800],
        zoom: 11,
        interactive: ($el.data("disable-interaction") ? false : true),
        pitch: ($el.data("pitch") ? $el.data("pitch") : 0),
        bearing: 0,
        minZoom: 5,
        maxZoom: 20
      });

      map.addControl(new mapboxgl.Navigation());

      map.fitBounds(routeBounds);

      map.on("load", function () {
        var url = "/routes"
        $.getJSON(url, function(json) {

          $.each(json["features"], function(i, feature) {
            var id = "tram-route-" + feature["properties"]["route"];
            map.addSource(id, {
              "type": "geojson",
              "data": {
                "type": "FeatureCollection",
                "features": [feature]
              }
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
                "line-color": feature["properties"]["route-color"],
                "line-width": 2,
                "line-opacity": 0.9
              }
            }, "vehicle-markers");
          });
        });

        $.getJSON("/stops.json", function(geoJSON) {
          map.addSource("stop-markers", {
            "type": "geojson",
            "data": geoJSON
          });

          map.addLayer({
            "id": "stop-markers",
            "type": "circle",
            "source": "stop-markers",
            "paint": {
              "circle-radius": 3,
              "circle-color": "#626262",
              "circle-opacity": 0.8
            }
          }, "vehicle-markers");
        });
      })

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

        if ("geolocation" in navigator) {
          var geolocation = new mapboxgl.Geolocate({position: "top-left"});
          map.addControl(geolocation);

          map.addSource("current-location", {
            "type": "geojson",
            "data": {
              "type": "FeatureCollection",
              "features": []
            }
          });

          map.addLayer({
            "id": "current-location",
            "type": "circle",
            "source": "current-location",
            "paint": {
              "circle-radius": 5,
              "circle-color": "#007AC9",
              "circle-opacity": 0.9
            }
          }, "vehicle-markers");

          $(geolocation._geolocateButton).on("click", function() {
            navigator.geolocation.watchPosition(function(position) {
              var data = {
                "type": "FeatureCollection",
                "features": [
                  {
                    "type": "Feature",
                    "geometry": {
                      "type": "Point",
                      "coordinates": [position.coords.longitude, position.coords.latitude]
                    }
                  }
                ]
              }

              map.getSource("current-location").setData(data);
            });
          });
        }
      })
    })
  }
});
