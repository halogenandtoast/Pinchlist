class Task extends Backbone.Model
class Share extends Backbone.Model
  urlRoot: "api/shares"
class TaskList extends Backbone.Collection
  model: Task
  initialize: ->
    @bind "complete", @resetList

  resetList: =>
    @fetch()

  comparator: (task) ->
    task.get("position")

class List extends Backbone.Model
  urlRoot: "api/lists"
  initialize: (attributes) ->
    @tasks = new TaskList(attributes['tasks'])

class @Lists extends Backbone.Collection
  model: List
  url: "api/lists"
  comparator: (list) ->
    list.get("position")

class ListShareView extends Backbone.View
  events:
    "submit .share_form" : "share"

  template: _.template($("#share_template").html())

  render: =>
    @$el.html(@template(@model.toJSON()))
    this

  share: =>
    email = @$(".share_email").val()
    share = new Share(email: email, list_id: @model.get("id"))
    share.save()

class TaskView extends Backbone.View
  tagName: "li"
  className: "task"
  events:
    "dropTask" : "updatePosition"
    "click .checkbox" : "toggleCompleted"
    "click .text" : "editTask"
    "submit #edit_task" : "updateTask"

  template: _.template($("#task_template").html())

  initialize: ->
    @model.on "sync", @render

  render: =>
    @$el.html(@template(@model.toJSON()))
    if @model.get("completed")
      @$el.addClass("completed")
    this

  updatePosition: (event, position) =>
    @model.save(new_position: position + 1)

  toggleCompleted: (event) =>
    @$el.toggleClass("completed")
    @model.save(
      {completed: @$el.hasClass("completed")}
      {success: ((model, response) -> model.trigger "complete") }
    )

  editTask: (event) =>
    old_html = @$el.html()
    input = $("<input type='text' id='task_title' value='#{@model.get("title")}' />")
    input.bind "keyup", (event) =>
      if event.keyCode == 27
        @$el.html(old_html)
    input.bind "blur", (event) =>
      @$el.html(old_html)
    form = $("<form id='edit_task'></form")
    form.append(input)
    @$el.html(form)
    input.focus()

  updateTask: (event) =>
    title = $("#task_title").val()
    @model.save(title: title)
    false

class ListView extends Backbone.View
  tagName: "td"
  className: "list"
  events:
    "submit .newtask" : "createTask"
    "dropList" : "updatePosition"
    "click .list_actions_link" : "toggleListActions"
    "click .share_link" : "toggleSharing"
    "click .delete a" : "deleteList"
    "click .list_title h3" : "editTitle"
    "submit #new_list_title" : "updateListTitle"
    "colorchange .color_picker" : "changeColor"

  template: _.template($("#list_template").html())

  initialize: ->
    @model.on "sync", @render
    @model.tasks.on "add", @waitForTask
    @model.tasks.on "reset", @render
    @model.tasks.url = "/api/lists/#{@model.get("id")}/tasks"
    @share_view = new ListShareView(model: @model)

  render: =>
    @$el.html(@template(@model.toJSON()))
    @model.tasks.each (task) =>
      @addTask(task)
    @$(".tasks").sortable(
      connectWith: ".tasks"
      helper: 'clone'
      items: "li"
      distance: 6
      opacity: .93
      update: @taskPositionChanged
    )
    @$(".list_title").css("background-color", '#'+@model.get("color"))
    @$(".list_actions_link").bind "clickoutside", (event) =>
      @$(".list_actions").hide()
    @$(".share_link").bind "clickoutside", (event) =>
      @$(".share").hide()

    @$(".share").append(@share_view.render().el)
    @setupColorPicker()
    @focus()
    this

  setupColorPicker: =>
    @$(".picker").colorPicker()

  focus: ->
    @$("[name='task[title]']").focus()

  waitForTask: (task) =>
    task.on "sync", @addTask

  addTask: (task) =>
    task.off "sync", @addTask
    view = new TaskView(model: task)
    @$(".tasks").append(view.render().el)

  addAll: =>
    @tasks.each(@add_task)

  createTask: =>
    @model.tasks.create(title: @$("[name='task[title]']").val())
    @$("[name='task[title]']").val("")
    false

  updatePosition: (event, position) =>
    @model.save(new_position: position + 1)

  taskPositionChanged: (event, ui) =>
    ui.item.trigger("dropTask", ui.item.index())

  changeColor: (event, color) =>
    @model.save(color: color.substring(1))

  toggleListActions: =>
    @$(".list_actions").toggle()

  hideListActions: =>
    @$(".list_actions").hide()

  toggleSharing: =>
    @$(".share").toggle()
    @$(".share input[type=text]").focus()

  deleteList: =>
    if confirm @$(".delete a").data("confirm")
      @model.destroy
        success: => @remove()
    false

  editTitle: =>
    form = $("<form id='new_list_title' class='list_title_form'></form")
    input = $("<input type='text' name='list[title]' id='list_title' value='#{@model.get('title')}' />")
    input.bind "keyup", (event) =>
      if event.keyCode == 27
        @$(".list_title_form").replaceWith("<h3>#{@model.get('title')}</h3>")
    form.append(input)
    @$(".list_title h3").replaceWith(form)
    input.focus()

  updateListTitle: =>
    title = @$("#list_title").val()
    @model.save(title: title)
    false

class @DashboardView extends Backbone.View
  el: "#listwerk"
  events:
    "submit #new_list" : "createList"

  initialize: ->
    @table = @$("#container > table")
    @collection.on "add", @waitForList
    @render()

  render: ->
    @drawLists()
    @$("tr").sortable(
      axis: "xy"
      items: ".list"
      handle: ".list_title"
      opacity: .95
      update: @listPositionChanged
    )
    @$("#list_title").focus()

  listPositionChanged: (event, ui) =>
    ui.item.trigger("dropList", ui.item.index())

  drawLists: =>
    @$el.find("tr").html("")
    @collection.each(@addList)

  waitForList: (list) =>
    list.on "sync", @addList

  addList: (list) =>
    list.off "sync", @addList
    view = new ListView(model: list)
    @table.find("tr").append(view.render().el)

  createList: (event) ->
    @collection.create(title: @$("#list_title").val())
    @$("#new_list input").val("")
    false
