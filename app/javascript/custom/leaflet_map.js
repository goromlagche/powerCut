module.exports = function(imagePath){
  $(document).on('turbolinks:load', function() {
    var mapId =  document.getElementById('map');
    if (mapId == undefined || mapId === null){
      return;
    }
    var map = L.map('map', { preferCanvas: true })

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    const url = $("#map").data("url");

    var customIcon = L.icon({
      iconRetinaUrl: imagePath('./marker-icon-2x.png'),
      iconUrl: imagePath('./marker-icon.png'),
      shadowUrl: imagePath('./marker-shadow.png'),
    });


    fetch(url)
      .then(response=>response.json())
      .then(data => {
        for (let location of data["locations"]) {
          L
            .marker([location.latitude, location.longitude], { icon: customIcon })
            .addTo(map)
            .bindPopup('<p>'+ location.address + '<br />' + location.restore_at +'.</p>').openPopup();
        }
        map.setView([12.972442, 77.580643], 12);
      });
  });
}
