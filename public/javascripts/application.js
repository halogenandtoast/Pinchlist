
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

function is_upcoming(form) {
  return form.parent('li').attr('id').split('_')[0] == "upcoming";
}

function update_list_position(list, position) {
  var list_id = list.attr('id').split('_')[1];
  $.post(
    '/lists/'+list_id,
    {'_method':'PUT', 'list': {'position': position}},
    function(data) {},
    "json"
  );
}

function update_task_position(task, position) {
  var task_id = task.attr('id').split('_')[1];
  $.post(
    '/tasks/'+task_id,
    {'_method':'PUT', 'task': {'position': position}},
    function(data) {},
    "json"
  );
}

function list_edit(list_title) {
  var list = list_title.parents(".list");
  list.find('.color_picker').hide();
  var list_title_text = list_title.html();
  var form = $('<form id="new_list_title" />');
  form.append("<input type='text' name='list[title]' id='list_title' value='"+list_title_text+"' />");
  form.bind('submit', function(e) {
    var list_id = $(this).parents('.list').attr('id').split('_')[1];
    $.post(
      '/lists/'+list_id,
      {'_method':'PUT', 'list': {'title': $(this).children('#list_title').val()}},
      function(data) {
        $('#list_'+data.list.id+' .list_title form').replaceWith('<h3>'+data.list.title+'</h3>');
        $('#list_'+data.list.id+' .color_picker').show();
      },
      "json"
    );
    return false;
  });
  list_title.replaceWith(form);
}

function task_edit(task, task_id, prefix) {
  var self = task;
  var task_title = $(self).children("span.task_title").text();
  var task_due_date = $(self).children("span.date").text();
  var title_field = (task_due_date != "") ? "@" + task_due_date + " " + task_title : task_title;
  var form = $('<form id="new_task_title" />');
  $(self).unbind('click');
  form.append("<input type='text' name='task[title]' id='task_title' value='"+title_field+"' />");
  $(form).children('input').bind('keyup',{task_title:task_title,task_due_date:task_due_date,element:self,prefix:prefix}, function(e) {
    if(e.keyCode == 27) {
      $(this).unbind('keyup');
      $(this).unbind('blur');
      $(this).parent('form').replaceWith('<span class="task_title">'+task_title+'</span>');
      setup_single_and_double_click($(e.data.element), e.data.prefix);
    }
  });
  $(form).children('input').bind('blur',
    {task_title:task_title,task_id:task_id,element:self,prefix:prefix}, function(e) {
      set_task_title_and_date.call($(this).parent('form'), e)
    }
  );
  form.bind('submit',{task_id:task_id,element:self,prefix:prefix}, set_task_title_and_date);
  $(self).html(form);
  form.children('input').focus();
}

function set_task_title_and_date(e) {
  var task_id = e.data.task_id;
  $.post(
    '/tasks/'+task_id,
    {'_method':'PUT', 'task': {'title': $(this).children('#task_title').val()}},
    function(data) {
      var form = $('#new_task_title');
      var upcoming = is_upcoming(form);
      var due_date = null;
      var li = $(form).parent('li');
      if(data.task.due_date != null) {
        split_date = data.task.due_date.split('-');
        due_date= split_date[1]+'/'+split_date[2];
      }
      if(upcoming) {
        var task_id = li.attr('id').split('_')[2];
        $('#task_'+task_id+' .task_title').html(data.task.title);
        if(due_date != null) {
          $('#task_'+task_id+' .date').html(due_date);
        }
      } else {
        var task_id = li.attr('id').split('_')[1];
        $('#upcoming_task_'+task_id+' .task_title').html(data.task.title);
        if(due_date != null) {
          $('#upcoming_task_'+task_id+' .date').html(due_date);
        }
      }
      span_html = '<span class="task_title">'+data.task.title+'</span>';
      if(due_date != null) {
        span_html = '<span class="date">'+due_date+'</span>'+"\n" + span_html;
      }

      form.replaceWith(span_html);
      setup_single_and_double_click(li, upcoming ? "upcoming" : "");
      $(".list:not(.upcoming) ul span").disableSelection();
    },
    "json"
  );
  return false;
}

function setup_single_and_double_click(element, prefix) {
  element.single_double_click(function() {
      var task_id = $(this).attr('id').split('_')[(prefix == "" ? 1 : 2)];
      var task = $('#task_'+task_id);
      $("#upcoming_task_"+task_id).toggleClass('completed');
      if(task.siblings('.completed').length > 0) {
        task.insertBefore(task.siblings('.completed:first'));
      } else {
        task.parent('ul').append(task)
      }
      task.toggleClass('completed');
      $.post('/tasks/'+task_id, {'_method':'PUT', 'task': {'completed': $(this).hasClass('completed')}}, function(data){}, "json");
    }, function() {
      var task_id = $(this).attr('id').split('_')[(prefix == "" ? 1 : 2)];
      task_edit(this, task_id, prefix);
    }, 225, {prefix:prefix});
}

$(document).ready(function(){
  $('.picker').colorPicker();
  //
  // mark normal and upcoming tasks completed
  setup_single_and_double_click($("#upcoming_tasks li"), "upcoming");
  setup_single_and_double_click($(".list:not(.upcoming) li"), "");

  $(".list_title h3").live('dblclick', function() {
      list_edit($(this));
  });

  // drag and drop tasks
  $(".list:not(.upcoming) ul").sortable({
      // containment: 'parent',
      axis: 'y',
      placeholder: 'ui-placeholder-highlight',
      helper: 'clone',
      forceHelperSize: true,
      forcePlaceholderSize: true,
      tolerance: 'pointer',
      cursor: 'url(https://mail.google.com/mail/images/2/closedhand.cur), move !important',
      distance: 6,
      opacity: .93,
      items: "li:not(.completed)",
      update: function(e, ui) {
        var position = ui.item.parent().children('li').index(ui.item[0]) + 1;
        update_task_position(ui.item, position);
      }
    //   sort: function(e,ui) {
    //     ui.placeholder
    //     .width(ui.helper.width())
    //     .height(ui.helper.height()); // maintain size of placeholder when ui.item is repositioned
    // }
  })
  // this.onselectstart = function () { return false; };
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
      cursor: 'url(https://mail.google.com/mail/images/2/closedhand.cur), move !important',
      opacity: .95,
      tolerance: 'pointer',
      forceHelperSize: true,
      sort: function(e,ui) {
        $('.ui-placeholder-highlight').css("width", $('.ui-sortable-helper').outerWidth());
      },
      update: function(e,ui) {
        var position = $('.list:not(.upcoming)').index(ui.item[0]) + 1;
        update_list_position(ui.item, position);
      }

  });
  // $("tr").data("sortable").floating = true;
  
  //toggle demo video
  //$("#demo").click(function () {
  //  $('#demo').text($('#demo').text() == 'Pause the demo' ? 'Play the demo' : 'Pause the demo');
  //  $("video")[0].player.play();
  //}, function() {
  //  $("video")[0].player.pause();
  //});
  
  //show sign in form
  $("#sign_in a").click(function () {
    
    $("#login, #sign_in").toggle();
    $('#user_email').focus();
    return false;
  });
  
  //load video.js
  $("video").VideoJS({
    controlsHiding: false,      
  });
  
  // scroll left/right
  $(document).keydown(function(evt){
    if(!$(evt.target).is("input")){
      if (evt.keyCode == 75) { 
          evt.preventDefault(); 
          $.scrollTo( '+=603px', '100', { axis:'x' } ); 
      } else if (evt.keyCode == 74) { 
         evt.preventDefault();
         $.scrollTo( '-=603px', '100', { axis:'x' } );
      }
    }
  })
  
});


