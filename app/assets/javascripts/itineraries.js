$( document ).ready(function() {
  pickup_not_fixed();
  drop_not_fixed();
  member_not_fixed();
  start_date_not_fixed();
});

$(document).on('turbolinks:load', function() {
  pickup_not_fixed();
  drop_not_fixed();
  member_not_fixed();
  start_date_not_fixed();

});

function pickup_not_fixed() {
  $(document).on('change', '.pickup_not_fixed', function () {
    if (this.checked) {
      $(this).closest('.pickup_attributes').find('.pickup').attr('readonly', true).val('');
    }
    else{
      $(this).closest('.pickup_attributes').find('.pickup').attr('readonly', false)
    }
  })
}


function drop_not_fixed() {
  $(document).on('change', '.drop_not_fixed', function () {
    if (this.checked) {
      $(this).closest('.drop_attributes').find('.drop').attr('readonly', true).val('');
    }
    else{
      $(this).closest('.drop_attributes').find('.drop').attr('readonly', false)
      
    }
  })
}

function member_not_fixed() {
  $(document).on('change', '#itinerary_member_not_fixed', function () {
    if (this.checked)
      $(this).closest('.members_attributes').find('.members').val(' ').prop('readonly', true)
    else
      $(this).closest('.members_attributes').find('.members').prop('readonly', false)
  })
}

function start_date_not_fixed(){
  $(document).on('change', '.not_fixed_checckbox', function(){
    if(this.checked == true)
      $('.start_date').attr('readonly', true).val(' ');
    else{
      var date = new Date();
      date = date.getFullYear() + '-0' + (date.getMonth()+1) + '-' + date.getDate();
      $('.start_date').attr('readonly', false).val(date);
    }
  })
}