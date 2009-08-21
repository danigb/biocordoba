// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() { 

  $("#orderable").tablesorter(); 

  //Rol, formulario nuevo usuario
  $("select#user_role_id").bind("change", function(){
    showRegisterExtraInfo();
  });
  //Ejecutamos al cargar, por si entramos en una sección concreta
  showRegisterExtraInfo();


  //Nuevo mensaje, selector de receptores
  $("#receivers select").change(function(e){
    var text_field = $("#message_receivers_string");
    if($(this).val() != ''){
      text_field.val(
        text_field.val() + $(this).val() + ", "
      );
      /* $("#receivers span").text("Destinatario añadido").show().effect("highlight",null, 2000).fadeOut(1000) */
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

  $(".profile-link").live("click", function(e){
    //Vble used for new meeting button hide  
    var hide = false;
    if($(this).hasClass("hide-meeting-button")){
      hide = true;
    }

    $(".query_review_parent, .ui-dialog, #profile").remove();
    $('<div />').appendTo('body').append("<img src='/images/loader-1.gif'/> Cargando...").dialog(
      {resizable: false, modal:true, position: ['center', 50], bgiframe: true}).load("/perfiles/" + this.id + ".js?hide="+hide);
    e.preventDefault();
  });

  //Meeting show
  /* $("#guest-info, #host-info").hide(); */
  $("#guest-info-mini a, #host-info-mini a").live("click", function(e){ 
    $(this).parent().parent().next().toggle("slow");
    e.preventDefault();
  })

  $("#guest-info-mini a, #host-info-mini a").live("click", function(){
      if($(this).html() == "Más información"){
        $(this).text("Menos información");
      }else{
        $(this).text("Más información");
      }
      /* this.toggle(function(){ $(this).text("Menos información") }, function(){ $(this).text("Más información") }) 
       * Deprecated, ahora usamos live*/
      });

  //Meeting Show Ajax
  /* $(".meeting-link").unbind(); */
  $(".meeting-link").live("click", function(e){
    $(".query_review_parent, .ui-dialog, #meeting").remove();
    $('<div><div />').appendTo('body').append("<img src='/images/loader-1.gif'/> Cargando...").dialog({resizable: false, modal:true, position: ['center', 50], width:450, bgiframe: true}).load("/citas/" + this.id + ".js");
    e.preventDefault();
  });

  ///profiles/new-external popup
  $(".new-external-link").click(function(e){
    $(".query_review_parent, .ui-dialog, #external").remove();
    $('<div><div />').appendTo('body').append("<img src='/images/loader-1.gif'/> Cargando...").dialog({resizable: false, modal:true, position: ['center', 50], width:450, bgiframe: true}).load("/perfiles/new_external.js");
    e.preventDefault();
  });

  //meetings/type form
  $("form#select-schedule select").change(function(){
      if(this.value != "")
        $(this).parent().parent().submit();
  })

  //Dynamic flash messages
  setTimeout("$('.flash-message').slideUp('slow')", 7000);

  //Cancel form
  $(".cancel-meeting-link").live("click", function(e){
      var id = this.id;
      $("#cancel-form-"+id).toggle("slow");
      e.preventDefault();
  })

  //Meetings show cancel button
  $("#cancel-button").live("click", function(){$(this).hide()});
  
  // /citas selector de empresa, mostramos su perfil comercial
  $("#guest_id:select").live("change", function(e){
    $("#commercial-profile").load('/profiles/commercial_profile/'+this.value)
    // $.get('/profiles/commercial_profile/'+this.value, {}, 
    //   function(data){
    //     $("#commercial-profile").html(data);
    //   }, "text" ); 
  });

  //Ajax global options
  $("#loading").bind("ajaxSend", function(){
     $(this).show();
  }).bind("ajaxComplete", function(){
     $(this).hide();
  });


});

function load_town(province_id, f){
  $.get('/ajax/towns', {'province_id': province_id, 'f': f}, null, "script" ); return false;
}

function load_buyers(sector_id){
  $.get('/ajax/buyers', {'sector_id': sector_id}, null, "script" ); return false;
}

function getMeetings(host_id, guest, date){
    var elem = $("#meetings-"+host_id);
    if(elem.html() == ""){
      $.get('/ajax/meetings', 
          {'host_id':host_id, 'guest':guest, 'date':date}, null, "script" ); 
    }else{
      elem.slideUp().html("");
    }
}

// All ajax requests will trigger the format.xml block
// of +respond_to do |format|+ declarations
$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});


jQuery.fn.log = function (msg) {
  console.log("%s: %o", msg, this);
  return this;
};


function showRegisterExtraInfo(){
  for(i in a = ['buyer', 'exhibitor']){
    $("#"+a[i]).hide();
  }

  var value = $("select#user_role_id").val();
  if(value == 3 || value == 4){
    $("#buyer").show();
  }else if(value == 5 ){
    $("#exhibitor").show();
  }
}
