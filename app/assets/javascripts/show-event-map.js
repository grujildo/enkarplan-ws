var map, coordinates, path;
function initialize() {
  var myOptions = {
    zoom: 15,
    draggableCursor: event.title,
    center: new google.maps.LatLng(event.latitude, event.longitude),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), myOptions);
  
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(event.latitude, event.longitude),
    map: map,
    icon: event.poi_type.image_urls['med']
  });
  
}
google.maps.event.addDomListener(window, 'load', initialize);