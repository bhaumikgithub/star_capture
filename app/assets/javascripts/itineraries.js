$( document ).ready(function() {
  pickup_not_fixed();
  drop_not_fixed();
});

$(document).on('turbolinks:load', function() {
  pickup_not_fixed();
  drop_not_fixed();

});

function pickup_not_fixed() {
  $(document).on('change', '.pickup_not_fixed', function () {
    if (this.checked) {
      $(this).closest('.pickup_attributes').find('.pickup').attr('disabled', true).val('');
    }
    else{
      $(this).closest('.pickup_attributes').find('.pickup').attr('disabled', false)
    }
  })
}


function drop_not_fixed() {
  $(document).on('change', '.drop_not_fixed', function () {
    if (this.checked) {
      $(this).closest('.drop_attributes').find('.drop').attr('disabled', true).val('');
    }
    else{
      $(this).closest('.drop_attributes').find('.drop').attr('disabled', false)
      
    }
  })
}