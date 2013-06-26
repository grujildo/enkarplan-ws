var map;

var infowindow = new google.maps.InfoWindow({ 
  size: new google.maps.Size(150,50)
});

function createMarker(event) {

  var marker = new google.maps.Marker({
      position: new google.maps.LatLng(event.latitude, event.longitude),
      map: map,
      icon: poi_types[event.poi_type_id] ? poi_types[event.poi_type_id].image_urls['small'] : null
  });
  
  var html = '<a href="/events/'+event.slug+'"><b>'+event.title+'</b></a><p>'+event.description+'</p>'
  
  google.maps.event.addListener(marker, 'click', function() {
      infowindow.setContent(html); 
      infowindow.open(map,marker);
  });   
  return marker;
}

function initialize() {
  var options = {
    scrollwheel: false,
    zoom: 11,
    draggableCursor: 'Enkarterri',
    center: new google.maps.LatLng(43.213,-3.13),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), options);

  $.each(events, function(index, event) {
    createMarker(event);
  });
}
google.maps.event.addDomListener(window, 'load', initialize);