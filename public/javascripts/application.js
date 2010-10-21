
// Author:  Jacek Becela
// Source:  http://gist.github.com/399624
// License: MIT
jQuery.fn.single_double_click = function(single_click_callback, double_click_callback, timeout, event_data) {
  return this.each(function(){
    var clicks = 0, self = this;
    jQuery(this).bind('click', event_data, function(event){
      clicks++;
      if (clicks == 1) {
        setTimeout(function(){
          if(clicks == 1) {
            single_click_callback.call(self, event);
          } else {
            double_click_callback.call(self, event);
          }
          clicks = 0;
        }, timeout || 225);
      }
    });
  });
}

function task_edit(task, task_id, prefix) {
  var self = task;
  var task_title = $(self).children("span.task_title").text();
  var form = $('<form>');
  $(self).unbind('click');
  form.append("<input type='text' name='task[title]' id='task_title' value='"+task_title+"' />");
  form.bind('submit',{task_id:task_id,element:self,prefix:prefix}, function(e) {
    $.post('/tasks/'+e.data.task_id, {'_method':'PUT', 'task': {'title': $(this).children('#task_title').val()}}, function(data){});
    if(prefix == "upcoming") {
      $('#task_'+e.data.task_id+' .task_title').html($(this).children('#task_title').val());
      $(this).replaceWith('<span class="task_title">'+$(this).children('#task_title').val()+'</span>');
    } else {
      $('#upcoming_task_'+e.data.task_id+' .task_title').html($(this).children('#task_title').val());
      $(this).replaceWith('<span class="task_title">'+$(this).children('#task_title').val()+'</span>');
    }
    setup_single_and_double_click($(e.data.element), e.data.prefix);
    $(".list:not(.upcoming) ul span").disableSelection();
    return false;
  });
  $(self).children("span.task_title").replaceWith(form);
}

function setup_single_and_double_click(element, prefix) {
  element.single_double_click(function() {
      var task_id = $(this).attr('id').split('_')[(prefix == "" ? 1 : 2)];
      $("#upcoming_task_"+task_id).toggleClass('completed');
      $("#task_"+task_id).toggleClass('completed');
      $.post('/tasks/'+task_id, {'_method':'PUT', 'task': {'completed': $(this).hasClass('completed')}}, function(data){});
    }, function() {
      var task_id = $(this).attr('id').split('_')[(prefix == "" ? 1 : 2)];
      task_edit(this, task_id, prefix);
    }, 225, {prefix:prefix});
}
// Note that I took the event string to bind to out of the jQuery.ui.js file.

$(document).ready(function(){
//   var maxWidth = 300;
//   if ( $('.list').width() > maxWidth ) $('.list').width(maxWidth);

  $('.picker').colorPicker();
  // mark upcoming tasks completed
  setup_single_and_double_click($("#upcoming_tasks li"), "upcoming");

  // mark normal tasks completed
  setup_single_and_double_click($(".list:not(.upcoming) li"), "");

  // drag and drop tasks
  $(".list:not(.upcoming) ul").sortable({
      // containment: 'parent',
      axis: 'y',
      placeholder: 'ui-placeholder-highlight',
      helper: 'clone',
      forceHelperSize: true,
      forcePlaceholderSize: true,
      tolerance: 'pointer',
      cursor: 'move',
      distance: 6,
      opacity: .93,
    //   sort: function(e,ui) {
    //     ui.placeholder
    //     .width(ui.helper.width())
    //     .height(ui.helper.height()); // maintain size of placeholder when ui.item is repositioned
    // }
  })
  $(".list:not(.upcoming) ul span").disableSelection();

  // drag and drop lists
    // var fixHelper = function(e, ui) {
    //  ui.children().each(function() {
    //    $(this).width($(this).width());
    //  });
    //  return ui;
    // };


  $("tr").sortable({
      axis: "x",
      placeholder: 'ui-placeholder-highlight',
      items: '.list:not(.upcoming)',
      handle: '.list_title',
      cursor: 'move',
      opacity: .93,
      forceHelperSize: true,
      sort: function(e,ui) {
         $('.ui-placeholder-highlight').css("width", $('.ui-sortable-helper').outerWidth());
     }
  });
  // $("tr").data("sortable").floating = true;

});
