//= require browserMqtt

var vehiclesGeoJSON = function(data) {
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
        "title": vehicle.desi,
        "marker-symbol": "marker",
        "vehicle-id": vehicle.veh
      }
    });
  });

  return geoJSON;
}

$(document).on("turbolinks:load", function() {
  // Disconnect from the vehicle location websocket when the page changes
  if (typeof(vehiclesClient) == "object") {
    window.vehiclesClient.end(true);
  }

  if ($("#full-map").length) {
    mapboxgl.accessToken = "pk.eyJ1IjoibWF0aWFza29yaG9uZW4iLCJhIjoiRkNzbl9vRSJ9.K7DdroE6DQ58YUxCMJv4Lg";
    var map = new mapboxgl.Map({
      container: "full-map",
      style: "mapbox://styles/mapbox/streets-v8",
      center: [24.9384, 60.1800],
      zoom: 11,
      minZoom: 5,
      maxZoom: 20
    });

    map.addControl(new mapboxgl.Navigation());

    map.fitBounds([
      [
        24.858627319335938,
        60.14526490373431
      ], // Southwest coordinates
      [
        24.991493225097656,
        60.21952545753577
      ]  // Northeast coordinates
    ]);

    map.on("load", function () {

      // Load the tram routes
      var routes = JSON.parse($("script[data-contents='tram-routes']").html());

      $.each(routes["features"], function(i, feature) {
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

      // Load the tram stops
      var stopsJSON = JSON.parse($("script[data-contents='stops']").html());

      map.addSource("stop-markers", {
        "type": "geojson",
        "data": stopsJSON
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


      // Initialize the vehicles data source and layer
      window.vehiclesCache = {};
      var vehiclesJSON = {
        "type": "geojson",
        "data": {
          "type": "FeatureCollection",
          "features": []
        }
      }
      map.addSource("vehicle-markers", vehiclesJSON);
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

      // Subscribe to the vehicles MQTT topic
      window.vehiclesClient = mqtt.connect("wss://dev.hsl.fi/mqtt-proxy");
      vehiclesClient.on("connect", function() {
        vehiclesClient.subscribe("/hfp/journey/tram/#");
      });
      vehiclesClient.on("message", function (topic, message) {
        var data = JSON.parse(message.toString());
        var veh = data.VP.veh;
        var cached = window.vehiclesCache[data.VP.veh];

        if (typeof(cached) === "undefined" || data.VP.tsi > cached.VP.tsi) {
          window.vehiclesCache[data.VP.veh] = data;

          var geoJSON = vehiclesGeoJSON(window.vehiclesCache);
          map.getSource("vehicle-markers").setData(geoJSON.data);
        }
      });

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
  }
});
