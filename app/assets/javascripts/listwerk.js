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
    '/lists/'+list_id+'/proxy',
    {'_method':'PUT', 'list_proxy': {'new_position': position}},
    function(data) {},
    "json"
  );
}

function update_task_position(task, position) {
  var task_id = task.attr('id').split('_')[1];
  var options = {'new_position': position, 'list_id': task.parent('ul').attr('data-id')};
  $.post(
    '/tasks/'+task_id,
    {'_method':'PUT', 'task': options},
    function(data) {},
    "json"
  );
}

function list_edit(list_title) {
  var list = list_title.parents(".list");
  list.find('.color_picker').remove();
  var list_title_text = list_title.html();
  var form = $('<form id="new_list_title" />');
  form.append("<input type='text' name='list[title]' id='list_title' value=\""+list_title_text.replace(/"/g, '&quot;')+"\" />");
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
        $('#list_'+data.id+' .list_title form').replaceWith('<h3>'+data.title+'</h3>');
        // $('#list_'+data.list.id+' .color_picker').show();
        new_picker = $("<div class='.picker'>pick color</div>");
        $('#list_'+data.id+' .delete').before(new_picker);
        new_picker.colorPicker();
      },
      "json"
    );
    return false;
  });
  list_title.replaceWith(form);
  form.children('input:first').focus();
}

function title_for_display(title) {
  return title.replace(/^!/, '');
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
  var task_due_date = $(self).find("span.date").detach().text().replace(/^\s+|\s+$/g, '');
  var task_title = String($(self).data("edit-title")).replace(/^\s+|\s+$/g, '');
  var title_field = (task_due_date != "") ? "@" + task_due_date + " " + task_title : task_title;
  var form = $('<form id="new_task_title" />');
  $(self).unbind('click');
  form.append("<input type='text' name='task[title]' id='task_title' value=\""+title_field.replace(/"/g, "&quot;")+"\" />");
  $(form).children('input').bind('keyup',{task_title:task_title,task_due_date:task_due_date,element:self,prefix:prefix}, function(e) {
    if(e.keyCode == 27) {
      $(this).unbind('keyup');
      $(this).unbind('blur');

      span_html = '<span class="task_title"><div class="checkbox">check</div>';
      if(task_due_date != null) {
        span_html += '<span class="date">'+task_due_date+'</span>'+"\n";
      }
      span_html += '<span class="text">'+title_for_display(task_title)+'</span></span>';
      $(this).parent('form').replaceWith(span_html);

      setup_single_and_double_click($(e.data.element).find('span.task_title'), e.data.prefix);
      setup_single_and_double_click($(e.data.element).find('span.date'), e.data.prefix);
      $(e.data.element).disableSelection();
    }
  });
  $(form).children('input').bind('blur', function() {
    $(this).parent('form').submit();
  });
  form.bind('submit',{task_id:task_id,element:self,prefix:prefix}, set_task_title_and_date);
  $(self).html(form);
  form.children('input').focus();
  $(self).enableSelection();
}

function add_task_to_upcoming(task) {
  show_upcoming_list();
  if($('#upcoming_task_'+task.id).length == 0) {
    var li_html = '<li class="upcoming_task" id="upcoming_task_'+task.id+'" data-edit-title="'+task.title+'" data-list="'+task.list_id+'">' +
    '<span class="task_title"><div class="checkbox">check</div>' +
    '<span class="date" data-full-date="'+task.full_date+'" style="color: #'+task.list_color+'">'+task.due_date+'</span>' + "\n" +
    "<span class='text'>"+task.title+'</span></span>' +
    '</li>';
    var li_elem = $(li_html)
    $('#upcoming_tasks').append(li_elem);
    li_elem.effect('highlight', {color: "#ACF4C8"}, 1000);
  }
  sort_list('#upcoming_tasks');
}

function sort_list(list) {
  var lis = $(list).children('li').get();
  lis.sort(function(a,b) {
      if(!$(a).hasClass('completed') || !$(b).hasClass('completed')) {
        if ($(a).hasClass('completed')) {
          return 1;
        } else if ($(b).hasClass('completed')) {
          return -1;
        }
      }
      var compA = $(a).find('span.date').attr('data-full-date')
      var compB = $(b).find('span.date').attr('data-full-date')
      return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
  });
  $.each(lis, function(idx, item) { $('#upcoming_tasks').append(item); });
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
      li.data('edit-title', task.title);
      if(task.due_date != null) {
        show_upcoming_list();
      }
      if(upcoming) {
        var task_id = li.attr('id').split('_')[2];
        $('#task_'+task_id+' .task_title').html("<span class='text'>"+task.display_title+"</span>");
        if(task.due_date != null) {
          $('#task_'+task_id+' .task_title').prepend("<span class='date'>"+task.due_date+"</span>\n");
        } else {
          $('#task_'+task_id+' .date').remove();
          $('#upcoming_task_'+task_id).remove();
          remove_upcoming_list();
        }
        $('#task_'+task_id+' .task_title').prepend("<div class='checkbox'>check</div>");
        $('#task_'+task_id).data('edit-title', task.title);
      } else {
        var task_id = li.attr('id').split('_')[1];
        if(task.due_date != null) {
          add_task_to_upcoming(task);
          upcoming_html = '<span class="date" style="color: #'+task.list_color+'">'+task.due_date+'</span><div class="checkbox">check</div>'+"\n<span class='text'>"+task.display_title+"</span>";
          $('#upcoming_task_'+task_id+' .task_title').html(upcoming_html);
          $('#upcoming_task_'+task_id).data('edit-title', task.title);
        } else {
          if($('#upcoming_task_'+task_id).length > 0) {
            $('#upcoming_task_'+task_id).remove();
            remove_upcoming_list();
          }
        }
      }
      span_html = '<span class="task_title"><div class="checkbox">check</div>'
      if(task.due_date != null) {
        if(upcoming) {
          span_html += '<span class="date" style="color: #'+task.list_color+'">'+task.due_date+'</span>'+"\n";
        } else {
          span_html += '<span class="date">'+task.due_date+'</span>'+"\n";
        }
      }
      span_html += '<span class="text">'+data.task.display_title+'</span></span>';

      form.replaceWith(span_html);
      if(upcoming || task.due_date != null) {
        setup_single_and_double_click($("#upcoming_task_"+task.id+ " .task_title"), "upcoming");
        setup_single_and_double_click($("#upcoming_task_"+task.id+ " .date"), "upcoming");
      }
      setup_single_and_double_click($("#task_"+task.id+" .task_title"), "");
      setup_single_and_double_click($("#task_"+task.id+" .date"), "");
      $(".list:not(.upcoming,.locked) ul li").disableSelection();
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

function toggle_completed(task, task_id, prefix) {
  var upcoming_task_elem = $("#upcoming_task_"+task_id);
  var task_elem = $("#task_"+task_id);
  upcoming_task_elem.toggleClass('completed');
  task_elem.toggleClass("completed");
  if(task_elem.siblings('.completed').length > 0) {
    task_elem.insertBefore(task_elem.siblings('.completed:first'));
  } else {
    task_elem.parent('ul').append(task_elem)
  }
  if(upcoming_task_elem) {
    if(upcoming_task_elem.siblings('.completed').length > 0) {
      upcoming_task_elem.insertBefore(upcoming_task_elem.siblings('.completed:first'));
    } else {
      upcoming_task_elem.parent('ul').append(upcoming_task_elem)
    }
    sort_list('#upcoming_tasks');
  }
  task_elem.effect('highlight', {color: "#ACF4C8"}, 1000);
  upcoming_task_elem.effect('highlight', {color: "#ACF4C8"}, 1000);
  $.post('/tasks/'+task_id, {'_method':'PUT', 'task': {'completed': task.hasClass('completed')}}, function(data){}, "json");
  $(".list:not(.upcoming,.locked) ul").sortable('destroy');
  enable_task_sorting();
}

function setup_single_and_double_click(element, prefix) {
  element.find(".text").click(function() {
    var task = prefix == "" ? $(this).parents('.task').first() : $(this).parents('.upcoming_task').first();
    var task_id = task.attr('id').split('_')[(prefix == "" ? 1 : 2)];
    task_edit(task, task_id, prefix);
  });

  element.find(".checkbox").click(function() {
    clear_task_title_form();
    var task = prefix == "" ? $(this).parents('.task').first() : $(this).parents('.upcoming_task').first();
    var task_id = task.attr('id').split('_')[(prefix == "" ? 1 : 2)];
    toggle_completed(task, task_id, prefix);
  });
}

function enable_task_sorting() {
  $(".list:not(.upcoming,.locked) ul.tasks").sortable({
      // containment: 'parent',
      // axis: 'y',
      connectWith: ".tasks",
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
        if(this === ui.item.parent()[0]) {
          var position = ui.item.parent().children('li').index(ui.item[0]) + 1;
          update_task_position(ui.item, position);
        }
      }
  })
  // this.onselectstart = function () { return false; };
  $(".list:not(.upcoming,.locked) ul li").disableSelection();
}

function setup_color_pickers() {
  $('.picker').colorPicker({
    onColorChange: function(color) {
      var list = $(this).parents('.list').first();
      var list_id = list.attr('id').split('_')[1];
      $('li[data-list="'+list_id+'"] .date').css('color', color);
      $('#list_'+list_id+' .icons').css('background-color', color);

      $.post(
        '/lists/'+list_id+'/proxy',
        {'_method':'PUT', 'list_proxy': {'color': color.substring(1)}},
        function(data) {},
        "json"
      );
    }
  });
}

function setup_sharing() {
  $(".share_link").click(function(e) {
      $(this).next(".share").toggle();
      if($(this).next("share:visible")) {
        $(".share input").focus();
      }
    });
  $(".share").focusout(function(e) {
    $(this).hide();
  });
}

function preventFurtherSubmissions(e) {
  if($(this).data('disabled') == 'true') {
    $(e.target).trigger('ujs:everythingStopped');
    e.stopImmediatePropagation();
    return false;
  } else {
    $(this).data('disabled', 'true');
  }
}

$(document).ready(function(){
  setup_color_pickers();
  setup_single_and_double_click($("#upcoming_tasks li span.task_title, #upcoming_tasks li span.date"), "upcoming");
  setup_single_and_double_click($(".list:not(.upcoming,.locked) li span.task_title, .list:not(.upcoming,.locked) li span.date"), "");

  $(".list:not(.upcoming,.locked) .list_title h3").live('click', function() {
      list_edit($(this));
  });

  var redirect_to_list = false;
  $(".public_link_toggle").live('ajax:success', function(event) {
    $(this).toggleClass("locked")
    $(this).toggleClass("unlocked")
    $(this).siblings(".public_link").toggleClass("locked")
    $(this).siblings(".public_link").toggleClass("unlocked")
    if(redirect_to_list) {
      window.location = $(this).siblings(".public_link").attr("href")
    }
  })

  $(".public_link.locked").live('click', function() {
    var self = this;
    if(confirm("Do you want to make this list public?")) {
      redirect_to_list = true;
      $(this).siblings(".public_link_toggle").click();
    }
    return false;
  })

  enable_task_sorting();
  $("tr").sortable({
      axis: "xy",
      placeholder: 'ui-placeholder-highlight',
      items: '.list:not(.upcoming,.locked)',
      handle: '.list_title',
      cursor: 'url(https://mail.google.com/mail/images/2/closedhand.cur), move !important',
      opacity: .95,
      tolerance: 'pointer',
      forceHelperSize: true,
      sort: function(e,ui) {
        $('.ui-placeholder-highlight').css("width", $('.ui-sortable-helper').outerWidth());
      },
      update: function(e,ui) {
        var position = $('.list:not(.upcoming,.locked)').index(ui.item[0]) + 1;
        update_list_position(ui.item, position);
      }

  });

  $("form[data-remote]").bind("submit", preventFurtherSubmissions);
  $("form[data-remote]").live("ajax:success", function() {
    $(this).removeData('disabled');
  });

  //toggle demo video
  $("#demo").click(function() {
    $("#demo_video").show();
    $("#demo").hide();
  });

  $(".stop").click(function() {
    $(this).hide();
    $(".play").show();
  });
  $(".play").click(function() {
    $(this).hide();
    $(".stop").show();
  });
  //show sign in form
  $("#sign_in a").click(function() {

    $("#login, #sign_in").toggle();
    $('#user_email').focus();
    return false;
  });

  //show sharing modal

  setup_sharing();

  //load video.js
  $("video").VideoJS({
    controlsHiding: false,
  });

  setTimeout(function() { $('#flash').fadeOut(800); }, 6000);

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
