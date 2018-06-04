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

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  }
}
function showPosition(position) {
  lat = position.coords.latitude
  lang = position.coords.longitude
  initMap();
}
function updatePosition(lat, long){
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
  });
}

function initMap() {
  var current_pos = {lat: lat, lng: lang};
  // The map, centered at location
  var map = new google.maps.Map(document.getElementById('map'), {zoom: 19, center: current_pos});
  // The marker, positioned at current position
  var marker = new google.maps.Marker({position: current_pos, map: map});
  updatePosition(lat, lang);
}