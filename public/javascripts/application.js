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
  });


  //Nuevo mensaje, selector de receptores
  $("#receivers input").click(function(e){
    $("#message_receiver_id").val(" ");
    $("#receivers input").each(function(i){
      if(this.checked==true){
        $("#message_receiver_id").val(
          $("#message_receiver_id").val() + this.value + ", "
        );
      }
    });
    $("#message_receiver_id").effect("highlight"); 
  });


});


