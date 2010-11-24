/**
 * Really Simple Color Picker in jQuery
 * 
 * Copyright (c) 2008 Lakshan Perera (www.laktek.com)
 * Licensed under the MIT (MIT-LICENSE.txt)  licenses.
 * 
 */

(function($){
  $.fn.colorPicker = function(options){    
    var defaults = {
      onColorChange: function(){}
    };
    settings = $.extend({}, defaults, options);
    if(this.length > 0) buildSelector();
    return this.each(function(i) { 
      buildPicker(this)}); 
  };
  
  var selectorOwner;
  var selectorShowing = false;
  
  buildPicker = function(element){
    //build color picker
    control = $("<div class='color_picker'>&nbsp;</div>")
    control.css('background-color', $(element).val());
    
    //bind click event to color picker
    control.bind("click", toggleSelector);
    
    //add the color picker section
    $(element).after(control);

    //add even listener to input box
    $(element).bind("change", function() {
      selectedValue = toHex($(element).val());
      $(element).next(".color_picker").css("background-color", selectedValue);
    });
    
    //hide the input box
    $(element).hide();

  };
  
  buildSelector = function(){
    selector = $("<div id='color_selector'></div>");

     //add color pallete
     $.each($.fn.colorPicker.defaultColors, function(i){
      swatch = $("<div class='color_swatch'>&nbsp;</div>")
      swatch.css("background-color", "#" + this);
      swatch.css("border-color", "#" + this);
      swatch.bind("click", function(e){ changeColor($(this).css("background-color")) });
      swatch.bind("mouseover", function(e){ 
        // $(this).css("border-color", "#598FEF"); 
        $("input#color_value").val(toHex($(this).css("background-color")));    
        }); 
      swatch.bind("mouseout", function(e){ 
        // $(this).css("border-color", "#000");
        $("input#color_value").val(toHex($(selectorOwner).css("background-color")));
        });
      
     swatch.appendTo(selector);
     });
  
     //add HEX value field
     hex_field = $("<input type='text' size='8' id='color_value'/>");
     hex_field.bind("keydown", function(event){
      if(event.keyCode == 13) {changeColor($(this).val());}
      if(event.keyCode == 27) {toggleSelector()}
     });
     
     $("<div id='color_custom'></div>").append(hex_field).appendTo(selector);

     $("body").append(selector); 
     selector.hide();
  };
  
  checkMouse = function(event){
    //check the click was on selector itself or on selectorOwner
    var selector = "div#color_selector";
    var selectorParent = $(event.target).parents(selector).length;
    if(event.target == $(selector)[0] || event.target == selectorOwner || selectorParent > 0) return
    
    hideSelector();   
  }
  
  hideSelector = function(){
    var selector = $("div#color_selector");
    
    $(document).unbind("mousedown", checkMouse);
    selector.hide();
    selectorShowing = false
  }
  
  showSelector = function(){
    var selector = $("div#color_selector");
    
    //alert($(selectorOwner).offset().top);
    
    selector.css({
      top: $(selectorOwner).offset().top - 2,
      left: $(selectorOwner).offset().left - $('#color_selector').width() - 1
    }); 
    hexColor = $(selectorOwner).prev("input").val();
    $("input#color_value").val(hexColor);
    selector.show();
    
    //bind close event handler
    $(document).bind("mousedown", checkMouse);
    selectorShowing = true 
   }
  
  toggleSelector = function(event){
    selectorOwner = this; 
    selectorShowing ? hideSelector() : showSelector();
  }
  
  changeColor = function(value){
    if(selectedValue = toHex(value)){
      $(selectorOwner).closest('.list_title').css("background-color", selectedValue);
      $(selectorOwner).prev("input").val(selectedValue).change();
    
      //close the selector
      settings.onColorChange.call(selectorOwner, selectedValue);
      hideSelector();    
    }
  };
  
  //converts RGB string to HEX - inspired by http://code.google.com/p/jquery-color-utils
  toHex = function(color){
    //valid HEX code is entered
    if(color.match(/[0-9a-fA-F]{3}$/) || color.match(/[0-9a-fA-F]{6}$/)){
      color = (color.charAt(0) == "#") ? color : ("#" + color);
    }
    //rgb color value is entered (by selecting a swatch)
    else if(color.match(/^rgb\(([0-9]|[1-9][0-9]|[1][0-9]{2}|[2][0-4][0-9]|[2][5][0-5]),[ ]{0,1}([0-9]|[1-9][0-9]|[1][0-9]{2}|[2][0-4][0-9]|[2][5][0-5]),[ ]{0,1}([0-9]|[1-9][0-9]|[1][0-9]{2}|[2][0-4][0-9]|[2][5][0-5])\)$/)){
      var c = ([parseInt(RegExp.$1),parseInt(RegExp.$2),parseInt(RegExp.$3)]);
      
      var pad = function(str){
            if(str.length < 2){
              for(var i = 0,len = 2 - str.length ; i<len ; i++){
                str = '0'+str;
              }
            }
            return str;
      }

      if(c.length == 3){
        var r = pad(c[0].toString(16)),g = pad(c[1].toString(16)),b= pad(c[2].toString(16));
        color = '#' + r + g + b;
      }
    }
    else color = "";
    
    return color
  }

  
  //public methods
  $.fn.colorPicker.addColors = function(colorArray){
    $.fn.colorPicker.defaultColors = $.fn.colorPicker.defaultColors.concat(colorArray);
  };
  
  $.fn.colorPicker.defaultColors = 
	[ 'ebd616', 'FF9E00', 'A55100', '43270F', 'F15600', 'FF8300', 'FF595A', 'DC5E7C', 'C83674', '5B1229', '71284F', '6D3587', '4A0F60', '311532', '4D3887', '4E51AF', '478aee', '1155AB', '0A2356', '388EC1', '8ACFDB', '238FA5', '227F81', '85E4D1', '00AA92', '004F46', '009F65', '008834', '214C1E', '59B129', '5D7322', '43411A', '96974B', 'BBBBBB', '1D1C1B', '6C6663'];
  
})(jQuery);


