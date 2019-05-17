if (typeof jQuery === 'undefined') {
    throw new Error('PassRequirements requires jQuery')
}

+(function ($) {
	
	$.fn.PassRequirements = function (options) {
		
		/*
			* TODO
			* ====
			* 
			* store regexes in variables so they can be used by users through string 
			* specifications,ex 'number', 'special', etc
			* 
		*/
		
		var defaults = {
			//            defaults: true
		};
		
		if(
		!options ||                     //if no options are passed                                  /*
		options.defaults == true ||     //if default option is passed with defaults set to true      * Extend options with default ones
		options.defaults == undefined   //if options are passed but defaults is not passed           */
		){
			if(!options){                   //if no options are passed, 
				options = {};               //create an options object
			}
			defaults.rules = $.extend({
				minlength: {
					text: "Tener al menos ocho caracteres",
					minLength: 8,
				},
				/*containSpecialChars: {
					text: "Tener al menos un carácter especial (Ej: !,%,&,@,#,$,^,*,?,_,.,+,=,-,~)",
					minLength: 1,
					regex: new RegExp('([^!,%,&,@,#,$,^,*,?,_,.,+,=,-,~])', 'g')
				},*/
				containLowercase: {
					text: "Tener al menos una letra minúscula",
					minLength: 1,
					regex: new RegExp('[^a-z]', 'g')
				},
				containUppercase: {
					text: "Tener al menos una letra mayúscula",
					minLength: 1,
					regex: new RegExp('[^A-Z]', 'g')
				},
				/*containNumbers: {
					text: "Tener al menos un número",
					minLength: 1,
					regex: new RegExp('[^0-9]', 'g')
				}*/
			}, options.rules);
		} else {
			defaults = options;     //if options are passed with defaults === false
		}
		
		
		
        var i = 0;
        var aux_contador = 0;
		return this.each(function () {
			
			if(!defaults.defaults && !defaults.rules){
				console.error('You must pass in your rules if defaults is set to false. Skipping this input with id:[' + this.id + '] with class:[' + this.classList + ']');
				return false;
			}
			
			var requirementList = "";
			$(this).data('pass-req-id', i++);
			
			$(this).on("keyup",function () {
				var this_ = $(this);
				
				Object.getOwnPropertyNames(defaults.rules).forEach(function (val, idx, array) {
					idPopover = this_.attr('aria-describedby');
					if (this_.val().replace(defaults.rules[val].regex, "").length > defaults.rules[val].minLength - 1) {
                        $('#'+idPopover).find('#' + val).css('color','#00cc06');        
					} else {
                        $('#'+idPopover).find('#' + val).css('color','');         
                    }
                    
                    aux_contador = 0;

                    $("#ul_list>li").each(function(){
                         if($(this).attr('style')){                            
                            aux_contador++;
                         }else{
                            aux_contador--;
                         }
                    });                   

                    if(aux_contador == 3){ // si se adiciona mas condiciones se debe aumentar el contador
                        this_.attr( "validaPassword", "1");
                    } else {
                        this_.attr( "validaPassword", "0");
                    }
					
				})
			});
			
			Object.getOwnPropertyNames(defaults.rules).forEach(function (val, idx, array) {
				requirementList += (("<li id='" + val + "'>" + defaults.rules[val].text).replace("minLength", defaults.rules[val].minLength));
			})
			try{
				$(this).popover({
					title: 'Condiciones de la contraseña',
					trigger: options.trigger ? options.trigger : 'focus',
					html: true,
					placement: options.popoverPlacement ? options.popoverPlacement : 'bottom',
					content: 'Su contraseña debe:<ul id="ul_list">' + requirementList + '</ul>'
					//                        '<p>The confirm field is actived only if all criteria are met</p>'
				});
			} catch(e) {
				throw new Error('PassRequirements requiere Bootstraps Popover plugin');
			}
			$(this).focus(function () {
				$(this).keyup();
			});
        });
       
	};
	
}(jQuery));
