
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

function show_upcoming_list() {
  if($('td.upcoming').length == 0) {
    var d = new Date();
    var upcoming_list = $('<td class="list upcoming"></td>');
    upcoming_list.append('<div class="list_title"><h3>Upcoming</h3><div class="today">'+(d.getMonth() + 1)+'/'+(d.getDate())+'</div></div>');
    upcoming_list.append('<ul id="upcoming_tasks"></ul>');
    $('table tr').prepend(upcoming_list);
  }
}

function remove_upcoming_list() {
  if($('#upcoming_tasks li').length == 0) {
    $('td.upcoming').remove();
  }
}

function is_upcoming(form) {
  return form.parent('li').attr('id').split('_')[0] == "upcoming";
}

function update_list_position(list, position) {
  var list_id = list.attr('id').split('_')[1];
  $.post(
    '/lists/'+list_id,
    {'_method':'PUT', 'list': {'new_position': position}},
    function(data) {},
    "json"
  );
}

function update_task_position(task, position) {
  var task_id = task.attr('id').split('_')[1];
  $.post(
    '/tasks/'+task_id,
    {'_method':'PUT', 'task': {'new_position': position}},
    function(data) {},
    "json"
  );
}

function list_edit(list_title) {
  var list = list_title.parents(".list");
  list.find('.color_picker').remove();
  var list_title_text = list_title.html();
  var form = $('<form id="new_list_title" />');
  form.append("<input type='text' name='list[title]' id='list_title' value='"+list_title_text+"' />");
  $(form).children('input').bind('keyup',{list_title:list_title_text}, function(e) {
    if(e.keyCode == 27) {
      $(this).unbind('keyup');
      $(this).unbind('blur');
      $(this).parent('form').replaceWith('<h3>'+e.data.list_title+'</h3>');
    }
  });
  $(form).children('input').bind('blur',function() {
    $(this).parent('form').submit();
  });
  form.bind('submit', function(e) {
    var list_id = $(this).parents('.list').attr('id').split('_')[1];
    $.post(
      '/lists/'+list_id,
      {'_method':'PUT', 'list': {'title': $(this).children('#list_title').val()}},
      function(data) {
        $('#list_'+data.list.id+' .list_title form').replaceWith('<h3>'+data.list.title+'</h3>');
        // $('#list_'+data.list.id+' .color_picker').show();
        new_picker = $("<div class='.picker'>pick color</div>");
        $('#list_'+data.list.id+' .delete').before(new_picker);
        new_picker.colorPicker();
      },
      "json"
    );
    return false;
  });
  list_title.replaceWith(form);
  form.children('input:first').focus();
}

var clearing = false;
function task_edit(task, task_id, prefix) {
  if($('#new_task_title').length != 0) {
    if(!clearing) {
      clearing = true
      clear_task_title_form();
    }
    setTimeout(function(){task_edit(task, task_id, prefix)}, 50);
    return;
  }
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
      setup_single_and_double_click($(e.data.element).parents('li').first().children('.task_title'), e.data.prefix);
      setup_single_and_double_click($(e.data.element).parents('li').first().children('.date'), e.data.prefix);
    }
  });
  $(form).children('input').bind('blur', function() {
    $(this).parent('form').submit();
  });
  form.bind('submit',{task_id:task_id,element:self,prefix:prefix}, set_task_title_and_date);
  $(self).html(form);
  form.children('input').focus();
}

function add_task_to_upcoming(task) {
  show_upcoming_list();
  if($('#upcoming_task_'+task.id).length == 0) {
    var li_html = '<li class="upcoming_task" id="upcoming_task_'+task.id+'">' +
    '<span class="date">'+task.due_date+'</span>' + "\n" +
    '<span class="task_title">'+task.title+'</span>' +
    '</li>';
    $('#upcoming_tasks').append(li_html);
    setup_single_and_double_click($('#upcoming_task_'+task.id+' span.task_title, #upcoming_task_'+task.id+' span.task_title'), "upcoming");
  }
}

function set_task_title_and_date(e) {
  var task_id = e.data.task_id;
  if($(this).children('#task_title').val() == "") {
    $('#task_'+task_id).remove();
    if($('#upcoming_task_'+task_id).length > 0) {
      $('#upcoming_task_'+task_id).remove();
      remove_upcoming_list();
    }
  }
  $.post(
    '/tasks/'+task_id,
    {'_method':'PUT', 'task': {'title': $(this).children('#task_title').val()}},
    function(data) {
      var task = data.task;
      if(task.title == '') {
        return;
      }
      var form = $('#new_task_title');
      var upcoming = is_upcoming(form);
      var li = $(form).parent('li');
      if(task.due_date != null) {
        show_upcoming_list();
      }
      if(upcoming) {
        var task_id = li.attr('id').split('_')[2];
        $('#task_'+task_id+' .task_title').html(task.title);
        if(task.due_date != null) {
          $('#task_'+task_id+' .date').html(task.due_date);
        } else {
          $('#task_'+task_id+' .date').remove();
          $('#upcoming_task_'+task_id).remove();
          remove_upcoming_list();
        }
      } else {
        var task_id = li.attr('id').split('_')[1];
        if(task.due_date != null) {
          add_task_to_upcoming(task);
          $('#upcoming_task_'+task_id+' .task_title').html(task.title);
          $('#upcoming_task_'+task_id+' .date').html(task.due_date);
        } else {
          if($('#upcoming_task_'+task_id).length > 0) {
            $('#upcoming_task_'+task_id).remove();
            remove_upcoming_list();
          }
        }
      }
      span_html = '<span class="task_title">'+data.task.title+'</span>';
      if(task.due_date != null) {
        span_html = '<span class="date">'+task.due_date+'</span>'+"\n" + span_html;
      }

      form.replaceWith(span_html);
      setup_single_and_double_click(li.children('span.task_title'), upcoming ? "upcoming" : "");
      setup_single_and_double_click(li.children('span.date'), upcoming ? "upcoming" : "");
      $(".list:not(.upcoming) ul li").disableSelection();
      clearing = false;
    },
    "json"
  );
  return false;
}

function clear_task_title_form() {
  if($('form#new_task_title')) {
    $('form#new_task_title').submit();
  }
}

function setup_single_and_double_click(element, prefix) {
  element.single_double_click(function() {
      clear_task_title_form();
      var task = prefix == "" ? $(this).parents('.task').first() : $(this).parents('.upcoming_task').first();
      var task_id = task.attr('id').split('_')[(prefix == "" ? 1 : 2)];
      $("#upcoming_task_"+task_id).toggleClass('completed');
      $("#task_"+task_id).toggleClass("completed");
      if(task.siblings('.completed').length > 0) {
        task.insertBefore(task.siblings('.completed:first'));
      } else {
        task.parent('ul').append(task)
      }
      $.post('/tasks/'+task_id, {'_method':'PUT', 'task': {'completed': task.hasClass('completed')}}, function(data){}, "json");
    }, function() {
      var task = prefix == "" ? $(this).parents('.task').first() : $(this).parents('.upcoming_task').first();
      var task_id = task.attr('id').split('_')[(prefix == "" ? 1 : 2)];
      task_edit(task, task_id, prefix);
    }, 225, {prefix:prefix});
}

function enable_task_sorting() {
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
  $(".list:not(.upcoming) ul li").disableSelection();
}

function setup_color_pickers() {
  $('.picker').colorPicker({
    onColorChange: function(color) {
      var list = $(this).parents('.list').first();
      var list_id = list.attr('id').split('_')[1];

      $.post(
        '/lists/'+list_id,
        {'_method':'PUT', 'list': {'color': color.substring(1)}},
        function(data) {},
        "json"
      );
    }
  });
}

$(document).ready(function(){
  setup_color_pickers();
  //
  // mark normal and upcoming tasks completed
  setup_single_and_double_click($("#upcoming_tasks li span.task_title, #upcoming_tasks li span.date"), "upcoming");
  setup_single_and_double_click($(".list:not(.upcoming) li span.task_title, .list:not(.upcoming) li span.date"), "");

  $(".list_title h3").live('dblclick', function() {
      list_edit($(this));
  });

  // drag and drop tasks

  // drag and drop lists
    // var fixHelper = function(e, ui) {
    //  ui.children().each(function() {
    //    $(this).width($(this).width());
    //  });
    //  return ui;
    // };


  enable_task_sorting();
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

  setTimeout(function() { $('#flash').fadeOut(800); }, 3000);

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


