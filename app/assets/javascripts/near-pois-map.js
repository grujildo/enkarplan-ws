var map;

var infowindow = new google.maps.InfoWindow({ 
  size: new google.maps.Size(150,50)
});

function createMarker(poi) {

  var marker = new google.maps.Marker({
      position: new google.maps.LatLng(poi.latitude, poi.longitude),
      map: map,
      icon: poi_types[poi.poi_type_id] ? poi_types[poi.poi_type_id].image_urls['small'] : null
  });
  
  var html = '<a href="/pois/'+poi.slug+'"><b>'+poi.title+'</b></a><p>'+poi.description+'</p>'
  
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

  $.each(pois, function(index, poi) {
    createMarker(poi);
  });
}
google.maps.event.addDomListener(window, 'load', initialize);