var map, coordinates, path;
function initialize() {
  var myOptions = {
    zoom: 15,
    draggableCursor: poi.title,
    center: new google.maps.LatLng(poi.latitude, poi.longitude),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), myOptions);
  
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(poi.latitude, poi.longitude),
    map: map,
    icon: poi.poi_type.image_urls['med']
  });
  
  if (poi.poi_type.is_route){
    coordinates = [];
    for (var index in poi.route_points) {
      coordinates.push(new google.maps.LatLng(poi.route_points[index].latitude, 
        poi.route_points[index].longitude));
    }
    
    path = new google.maps.Polyline({
      path: coordinates,
      strokeColor: "#FF0000",
      strokeOpacity: 0.45,
      strokeWeight: 3
    });
    path.setMap(map);
  }
}
google.maps.event.addDomListener(window, 'load', initialize);