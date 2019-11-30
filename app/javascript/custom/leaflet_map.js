module.exports = function(imagePath){
  $(document).ready(function(){
    var map = L.map('map', { preferCanvas: true }).setView([12.972442, 77.580643], 12);

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
        for (let location of data["location_data"]) {
          L
            .marker([location.latitude, location.longitude], { icon: customIcon })
            .addTo(map)
            .bindPopup('<p>'+ location.address + '<br />' + location.restore_at +'.</p>').openPopup();
        }
      });
  });
}
