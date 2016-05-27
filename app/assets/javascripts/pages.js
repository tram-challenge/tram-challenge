$(document).on("turbolinks:load", function() {
  if ($("#map")) {
    mapboxgl.accessToken = "pk.eyJ1IjoibWF0aWFza29yaG9uZW4iLCJhIjoiRkNzbl9vRSJ9.K7DdroE6DQ58YUxCMJv4Lg";
    var map = new mapboxgl.Map({
      container: "map",
      style: "mapbox://styles/mapbox/streets-v8",
      center: [24.9384, 60.1699],
      zoom: 15
    });

    // // https://www.mapbox.com/mapbox-gl-js/example/third-party/
    // map.on("load", function () {
    //   map.addSource("hsl-stop-map", {
    //     type: "vector",
    //     url: "http://api.digitransit.fi/hsl-stop-map/{z}/{x}/{y}.pbf"
    //   });
    //   map.addLayer({
    //     "id": "hsl-stop-map",
    //     "type": "symbol",
    //     "source": "hsl-stop-map",
    //     "source-layer": "contour",
    //     // "layout": {
    //     //   "line-join": "round",
    //     //   "line-cap": "round"
    //     // },
    //     // "paint": {
    //     //   "line-color": "#ff69b4",
    //     //   "line-width": 1
    //     // }
    //   });
    // });
  }
});
