$( document ).ready(function() {

  pickup_not_fixed();
  drop_not_fixed();

  $.each($("input[type=checkbox]:checked"), function(){            
      $(this).closest('.row').find('.timings').show();
  });
});

$(document).on('turbolinks:load', function() {

  pickup_not_fixed();
  drop_not_fixed();

});

function pickup_not_fixed() {
  $(document).on('change', '.pickup_not_fixed', function () {
    if (this.checked) {
      $(this).closest('.pickup_attributes').find('.pickup').attr('disabled', true)
    }
    else{
      $(this).closest('.pickup_attributes').find('.pickup').attr('disabled', false)
      
    }
  })
}


function drop_not_fixed() {
  $(document).on('change', '.drop_not_fixed', function () {
    if (this.checked) {
      $(this).closest('.drop_attributes').find('.drop').attr('disabled', true)
    }
    else{
      $(this).closest('.drop_attributes').find('.drop').attr('disabled', false)
      
    }
  })
}