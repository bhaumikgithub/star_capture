var product_id;
var lat = '';
var lang = '';
$( document ).ready(function() {
  initialize();
});

$(document).on('turbolinks:load', function() {
  if (typeof google != 'undefined') {
    initialize();
  }
});

function initialize(){
  product_id = $('#product').data('product-id');
  lat = parseFloat($('#product').data('latitude'));
  lang = parseFloat($('#product').data('longitude'));
  if ((lat == '' && lang == '') || (isNaN(lat) && isNaN(lang)) ) {
    getLocation();
  }
  else{  
    initMap();
  }
}

// get current location
function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  }
}

// get lang and latitude
function showPosition(position) {
  lat = position.coords.latitude
  lang = position.coords.longitude
  initMap();
}


function initMap() {
  var current_pos = {lat: lat, lng: lang};
  // The map, centered at location
  var map = new google.maps.Map(document.getElementById('map'), {zoom: 17, center: current_pos});

  var input = document.getElementById('product_address');

  var autocomplete = new google.maps.places.Autocomplete(input);

  var infowindow = new google.maps.InfoWindow();
  var infowindowContent = document.getElementById('infowindow-content');

  // Bind the map's bounds (viewport) property to the autocomplete object,
  // so that the autocomplete requests use the current map bounds for the
  // bounds option in the request.
  autocomplete.bindTo('bounds', map);

  infowindow.setContent(infowindowContent);

  marker = new google.maps.Marker({
    draggable:true,
    position: current_pos,
    map: map,
    title:"Drag me!"
  });

  autocomplete.addListener('place_changed', function() {
    infowindow.close();
    marker.setVisible(false);
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      // User entered the name of a Place that was not suggested and
      // pressed the Enter key, or the Place Details request failed.
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }

    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(17);
    }
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);

    lat = JSON.parse(JSON.stringify(place.geometry.location)).lat;
    lang = JSON.parse(JSON.stringify(place.geometry.location)).lng;
    updatePosition(lat, lang);
  });

  google.maps.event.addListener(marker, 'dragend', function (event) {
    current_pos = {lat: event.latLng.lat(), lng: event.latLng.lng()};
    updatePosition(event.latLng.lat(), event.latLng.lng());
  });

  updatePosition(lat, lang);
}

function updatePosition(lat, lang){
  $.ajax({
    url: window.location.origin+'/products/'+product_id+'/update_location/',
    type: 'PATCH',
    data: {latitude: lat, longitude: lang},
    dataType: 'JSON'
  }).done(function(data){
    $('#product_country').val(data.product.country)
    $('#product_state').val(data.product.state)
    $('#product_city').val(data.product.city)
    $('#product_pincode').val(data.product.pincode)
    $('#product_address').val(data.product.address)
  });
}