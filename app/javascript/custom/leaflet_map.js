$(document).ready(function(){
  var map = L.map('map', { preferCanvas: true }).setView([12.972442, 77.580643], 12);

  L.Icon.Default.mergeOptions({
    iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
    iconUrl: require('leaflet/dist/images/marker-icon.png'),
    shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
  });

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

  var myStyle = {
     "color": "#ff7800",
     "weight": 5,
     "opacity": 0.65
  };

  const url = $("#map").data("url");

  fetch(url)
    .then(response=>response.json())
    .then(data => {
      for (let geoJson of data["geo_data"]) {
        L.geoJSON(geoJson, {
          onEachFeature: function (feature, layer) {
            layer.bindPopup('<h1>'+feature.properties.display_name+'</h1>');
          }
        , style: myStyle }).addTo(map);
      }
    });
});
