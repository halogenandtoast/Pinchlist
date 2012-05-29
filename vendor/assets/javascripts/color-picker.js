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

    selector.css({
      top: $(selectorOwner).offset().top + 24,
      left: $(selectorOwner).offset().left - $('#color_selector').width() + 22
    });
    hexColor = $(selectorOwner).prev("input").val();
    $("input#color_value").val(hexColor);
    selector.show();

    //bind close event handler
    $(document).bind("mousedown", checkMouse);
    selectorShowing = true
   }

  toggleSelector = function(event){
    selectorOwner = event.target;
    selectorShowing ? hideSelector() : showSelector();
  }

  changeColor = function(value){
    if(selectedValue = toHex(value)){
      $(selectorOwner).closest('.list_title').css("background-color", selectedValue);
      $(selectorOwner).prev("input").val(selectedValue).change();

      //close the selector
      $(selectorOwner).trigger("colorchange", selectedValue)
      hideSelector();
    }
  };

  $.changeColor = changeColor;

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
	[ '4D3404', '6E5123', '8E6316', 'A67D37', 'C5A368', 'BE0000', 'E10000', 'FF0000', 'FF5A5B', 'FF8F8D', 'BE0067', 'E10071', 'FF0080', 'FF4A9E', 'FF85BC', '8B0069', 'A8007F', 'C10098', 'CF4DAA', 'DB77BE', '2F006A', '4C0082', '601C9A', '7D4FAD', 'A282C7', '003982', '004C9E', '0061BF', '007CD5', '609FDB', '005C60', '00747A', '008C92', '00B8C1', '87D5DC', '006F4F', '008A5E', '00AE77', '00C687', '85DEB5', '008632', '00A133', '00BB2C', '6ECA5C', 'B3DF99', 'F3BD00', 'FFD100', 'FFEA00', 'FFF44D', 'FFF99E', 'CA4C00', 'ED5000', 'FF7E25', 'FFA770', 'FFC591', '222222', '555555', '888888', 'aaaaaa', 'cccccc'];

})(jQuery);
