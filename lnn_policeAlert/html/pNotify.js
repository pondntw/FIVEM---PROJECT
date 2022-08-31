$(function(){
    window.addEventListener("message", function(event){   
		
        if(event.data.options){
          var options = event.data.options;
          new Noty(options).show();
		      
			  //var div = document.createElement('div');
			  //div.id = options.id;
			  //div.innerHTML = '';
			  //$(options.id).append('<div class="noty_body"></div><div class="noty_progressbar"> </div>');
		  
		  $("#"+options.id).css("backgroundColor", options.color);
        }else{
          Noty.setMaxVisible(10, "police_alert");
        };
    });
});
