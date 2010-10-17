
// Author:  Jacek Becela
// Source:  http://gist.github.com/399624
// License: MIT
jQuery.fn.single_double_click = function(single_click_callback, double_click_callback, timeout) {
  return this.each(function(){
    var clicks = 0, self = this;
    jQuery(this).click(function(event){
      clicks++;
      if (clicks == 1) {
        setTimeout(function(){
          if(clicks == 1) {
            single_click_callback.call(self, event);
          } else {
            double_click_callback.call(self, event);
          }
          clicks = 0;
        }, timeout || 250);
      }
    });
  });
}

$(document).ready(function(){
//   var maxWidth = 300;    
//   if ( $('.list').width() > maxWidth ) $('.list').width(maxWidth);

  $('.picker').colorPicker();
  $("#upcoming_tasks li").single_double_click(function () {
      var task_id = $(this).attr('id').split('_')[2];
      $(this).toggleClass('completed');
      // $('task_'+task_id).toggleClass('completed');
      $.post('/tasks/'+task_id, {'_method':'PUT', 'task': {'completed': $(this).hasClass('completed')}}, function(data){});
    }, function () {
      // $(this).html($(this).html() + "EDTED");
    })
});
