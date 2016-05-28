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
        pitch: ($el.data("pitch") ? $el.data("pitch") : 0)
      });
    })
  }
});
