// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() { 

  $("#orderable").tablesorter(); 

  //Rol, formulario nuevo usuario
  $("select#user_role_id").bind("change", function(e){

    for(i in a = ['buyer', 'exhibitor']){
      $("#"+a[i]).hide();
    }

    var value = $("select#user_role_id").val();
    if(value == 3 || value == 4){
      $("#buyer").show();
    }else if(value == 5 ){
      $("#exhibitor").show();
    }
    if(value == 1 || value == 2){
      $("#new-user-profile").hide();
    }else{
      $("#new-user-profile").show();
    }
  });


  //Nuevo mensaje, selector de receptores
  $("#receivers select").change(function(e){
    var text_field = $("#message_receivers_string");
    if(this.value != ''){
      text_field.val(
        text_field.val() + this.value + ", "
      );
      $("#receivers span").text("Destinatario añadido").show().effect("highlight",null, 2000).fadeOut(1000)
      text_field.effect("highlight", null, 2000); 
    }
  });

  //Seleccionar todos
  $("#message_send_all").click(function(e){
    if(this.checked == true){
      $("#receivers").slideUp();
    }else{
      $("#receivers").slideDown();
    } 
  })

 //Message Autocomplete
  if($("input#message_receivers_string").length > 0){
    $("input#message_receivers_string").autocomplete("auto_complete_for_profile_company_name", 
      {multiple:true});
  }


  //Profile dialog
  $(".profile-link").click(function(e){
    $('<div />').appendTo('body').append("<img src='/images/loader.gif'/> Cargando...").dialog({modal:true, position: ['center', 50]}).load("/perfiles/" + this.id);
    e.preventDefault();
  });


  //Meeting show
  /* $("#guest-info, #host-info").hide(); */
  $("#guest-info-mini a, #host-info-mini a").click(function(e){ 
    $(this).parent().parent().next().toggle("slow");
    e.preventDefault();
  })

  $("#guest-info-mini a, #host-info-mini a").toggle(function(){ $(this).text("Menos información") }, function(){ $(this).text("Más información") });

  //Meeting Show Ajax
  $(".meeting-link").unbind();
  $(".meeting-link").click(function(e){
    $('<div />').appendTo('body').append("<img src='/images/loader.gif'/> Cargando...").dialog({modal:true, position: ['center', 50], width:450}).load("/citas/" + this.id);
    e.preventDefault();
  });


});

function load_town(province_id, f){
  $.get('/ajax/towns', {'province_id': province_id, 'f': f}, null, "script" ); return false;
}

function load_buyers(sector_id){
  $.get('/ajax/buyers', {'sector_id': sector_id}, null, "script" ); return false;
}

// All ajax requests will trigger the format.xml block
// of +respond_to do |format|+ declarations
$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});
