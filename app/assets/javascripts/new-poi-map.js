var map = null;
var marker = null;

var infowindow = new google.maps.InfoWindow({ 
  size: new google.maps.Size(150,50)
});

// A function to create the marker and set up the event window function 
function createMarker(latlng, name, html) {
  var contentString = html;
  var marker = new google.maps.Marker({
      position: latlng,
      map: map,
      zIndex: Math.round(latlng.lat()*-100000)<<5
  });

  google.maps.event.addListener(marker, 'click', function() {
      infowindow.setContent(contentString); 
      infowindow.open(map,marker);
  });
  google.maps.event.trigger(marker, 'click');    
  return marker;
}

// create the map
var options = {
  zoom: 13,
  center: new google.maps.LatLng(43.213,-3.13),
  mapTypeControl: true,
  mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
  navigationControl: true,
  mapTypeId: google.maps.MapTypeId.ROADMAP
}
map = new google.maps.Map(document.getElementById("map-canvas"), options);

// 
// Map coordinates
//
var coordinates = [];
var path;
var routePointIndex = 0;

google.maps.event.addListener(map, 'click', function(event) {
  if (infowindow)
    infowindow.close();
  
  if (routePointIndex == 0) {
    $('#poi-latitude').val(event.latLng.lat());
    $('#poi-longitude').val(event.latLng.lng());
    
    // Create marker
    if (marker) {
      marker.setMap(null);
      marker = null;
    }
    var markerTitle = $('input#poi_title').val();
    
    marker = createMarker(event.latLng, "name", 
      '<img src="'+poiType.image_urls.med+'" style="display: inline;"/>'+
      '<div style="display: inline;"><b>'+markerTitle+'</b></div>');
  }
  
  if (poiType.is_route) {
    if (path)
      path.setMap(null);
    
    coordinates.push(event.latLng);
    path = new google.maps.Polyline({
      path: coordinates,
      strokeColor: "#FF0000",
      strokeOpacity: 0.45,
      strokeWeight: 3
    });
    
    path.setMap(map);
    
    $('#route-points').append(
      '<input type="hidden" name="poi[route_points_list]['+routePointIndex+'][index]" value="'+routePointIndex+'">');
    $('#route-points').append(
      '<input type="hidden" name="poi[route_points_list]['+routePointIndex+'][latitude]" value="'+event.latLng.lat()+'">');
    $('#route-points').append(
      '<input type="hidden" name="poi[route_points_list]['+routePointIndex+'][longitude]" value="'+event.latLng.lng()+'">');
      
    routePointIndex++;
  }
});

function poiTypeChanged(){
  if (path)
    path.setMap(null);
  if (marker)
    marker.setMap(null);
  coordinates = [];
  routePointIndex = 0;
}
