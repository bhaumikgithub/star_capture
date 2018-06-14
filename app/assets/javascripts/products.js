var product_id;
var lat = '';
var lang = '';
var role = '';
var products_array = '';
var geocoder;
var map;
var flag = true;

$( document ).ready(function() {
  if (flag == false) {
    initialize();
    $('.optional_checkbox').attr('disabled', true)
      $.each($("input[type=checkbox]:checked"), function(){            
          $(this).attr('disabled', false)
      });
  }
  $(document).on('change', '.day', function () {
    $(this).closest('.row').find('.timings').toggle();
  })

  $.each($("input[type=checkbox]:checked"), function(){            
      $(this).closest('.row').find('.timings').show();
  });
});

$(document).on('turbolinks:load', function() {
  if (typeof google != 'undefined') {
    $('.optional_checkbox').attr('disabled', true)
      $.each($("input[type=checkbox]:checked"), function(){            
          $(this).attr('disabled', false)
      });
    initialize();
  }

  $(document).on('change', '.day', function () {
    $(this).closest('.row').find('.timings').toggle();
  })

  $.each($("input[type=checkbox]:checked"), function(){            
      $(this).closest('.row').find('.timings').show();
  });
});

function initialize(){
  product_id = $('#product').data('product-id');
  lat = parseFloat($('#product').data('latitude'));
  lang = parseFloat($('#product').data('longitude'));
  products_array = $('#product').data('array');
  product_categories= $('#product').data('categories');
  role = $('#product').data('role');
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
  var map_div = document.getElementById('map')
  if(map_div != null)
  {

    var myStyles =[
      {
        featureType: "poi",
        elementType: "labels",
        stylers: [ { visibility: "off" }]
      }
    ];

    map = new google.maps.Map(map_div, {zoom: 15, center: current_pos,styles: myStyles });

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
 
    // multiple marker
    if(typeof products_array !== 'undefined' && products_array.length > 0){
      geocoder = new google.maps.Geocoder();
      var timeout = 0;

      products_array.forEach(function(element) {
        timeout = timeout+1000;
        setTimeout(function () {
          geocodeAddress(element);
        }, timeout);
      });
     }


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
        map.setZoom(15);
      }
      marker.setPosition(place.geometry.location);
      marker.setVisible(true);

      lat = JSON.parse(JSON.stringify(place.geometry.location)).lat;
      lang = JSON.parse(JSON.stringify(place.geometry.location)).lng;
      updatePosition(lat, lang);
      update_user_location(lat, lang);

    });

    google.maps.event.addListener(marker, 'dragend', function (event) {
      current_pos = {lat: event.latLng.lat(), lng: event.latLng.lng()};
      updatePosition(event.latLng.lat(), event.latLng.lng());
      update_user_location(event.latLng.lat(), event.latLng.lng());

    });

    updatePosition(lat, lang);
    update_user_location(lat, lang);
  }

}

function updatePosition(lat, lang){
  if (role != 'user') {
    update_product_location(lat, lang);
  }

}

function update_product_location(lat, lang){
  $.ajax({
    url: window.location.origin+'/products/'+product_id+'/update_location/',
    type: 'PATCH',
    data: {latitude: lat, longitude: lang},
    dataType: 'JSON'
  }).done(function(data){
    $('#product_country').val(data.product.country);
    $('#product_state').val(data.product.state);
    $('#product_city').val(data.product.city);
    $('#product_pincode').val(data.product.pincode);
    $('#product_address').val(data.product.address);
  });
}


function geocodeAddress(locations) {
  var bounds = new google.maps.LatLngBounds();
  var latlng = {lat: parseFloat(locations[0]), lng: parseFloat(locations[1])};

  geocoder.geocode(
  {'location': latlng},
  function (results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var marker = new google.maps.Marker({
          icon: 'http://maps.google.com/mapfiles/ms/icons/blue.png',
          map: map,
          position: results[0].geometry.location,
          setMap: map
      })
      infoWindow(marker, map, locations[3], locations[4], window.location.origin+'/products/'+locations[2], locations[2]);
      bounds.extend(marker.getPosition());
      // map.fitBounds(bounds);
    }
  });
}

function infoWindow(marker, map, title, price, url,categories) {
  google.maps.event.addListener(marker, 'click', function () {
    var html = "<p><b> Name:</b> " + title + "</p><p><b>Price:  </b> $" + price + "</p><p><b>Categories:</b> "+ product_categories[categories] +"</p><a href='" + url + "'>View Product</a>";
    iw = new google.maps.InfoWindow({
        content: html,
        maxWidth: 350
    });
    iw.open(map, marker);
  });
}




function update_user_location(lat, lang){
  if (role == 'user' ){
    $.ajax({
      url: window.location.origin+'/products/update_user_location',
      type: 'PATCH',
      data: {latitude: lat, longitude: lang},
      dataType: 'JSON'
    }).done(function(data){
      $('#product_country').val(data.country)
      $('#product_state').val(data.state)
      $('#product_city').val(data.city)
      $('#product_pincode').val(data.pincode)
      $('#product_address').val(data.address)
      if(data.is_updated){
        window.location.reload(true)
      }
    });
  }
}

function imageWarning() {
  alert("You can not delete because product must have 1 image");
}

$(document).on('change', '.required_checkbox', function () {
  if (this.checked) {
    $(this).closest('tr').find('.optional_checkbox:checkbox').attr('disabled', false)
  }
  else{
    $(this).closest('tr').find('.optional_checkbox:checkbox').attr('disabled', true)
  }
})