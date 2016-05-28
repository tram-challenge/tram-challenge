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

    })
  }
});
