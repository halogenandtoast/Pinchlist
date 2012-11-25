class Task extends Backbone.Model
  editable_text: =>
    if @has?("due_date")
      "@#{@get('due_date')} #{@get('title')}"
    else
      @get('title')

class Share extends Backbone.Model
  urlRoot: "api/shares"
class ShareList extends Backbone.Collection
  model: Share
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
    @shares = new ShareList(attributes['shares'])

class @Lists extends Backbone.Collection
  model: List
  url: "api/lists"
  comparator: (list) ->
    list.get("position")

class UpcomingTaskList extends Backbone.Collection
  model: Task
  initialize: ->
    @bind "complete", @resetList

  resetList: =>
    @remove(@where(completed: true))

  comparator: (task) ->
    task.get("due_date")

  add_with_color: (task, color) ->
    task.color = color
    @add(task)

class ShareView extends Backbone.View
  events:
    "click .remove" : "deleteShare"
  tagName: 'li'
  template: _.template($("#share_template").html())
  render: =>
    @$el.html(@template(_.extend(@model.toJSON(), @options)))
    this
  deleteShare: =>
    @model.destroy()
    @remove()
    @trigger "unshared"
    false

class ListSharesView extends Backbone.View
  events:
    "submit .share_form" : "share"

  template: _.template($("#share_list_template").html())

  render: =>
    @$el.html(@template(@model.toJSON()))
    @model.shares.each @renderShare
    this

  renderShare: (share) =>
    view = new ShareView(model: share, is_owner: @model.get("is_owner"))
    view.on "unshared", @checkForShares
    @$(".shared_users").append(view.render().el)

  share: =>
    email = @$(".share_email").val()
    @$(".share_email").val("")
    share = new Share(email: email, list_id: @model.get("id"))
    share.save {},
      success: =>
        @renderShare(share)
        @trigger "shared"
    false

  checkForShares: =>
    if @model.shares.isEmpty
      @trigger "unshared"


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
    @$el.html(@template(_.extend(@model.toJSON(), @options)))
    @$el.id = "task_#{@model.id}"
    if @model.get("completed")
      @$el.addClass("completed")
    if @model.get("archived")
      @$el.addClass("archived")
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
    input = $("<input type='text' id='task_title' value='#{@model.editable_text()}' />")
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
    if title == ""
      @model.destroy()
    else
      @model.unset("due_date", silent: true)
      @model.save(title: title)
    false

class UpcomingListView extends Backbone.View
  tagName: "td"
  className: "upcoming list"
  template: _.template($("#upcoming_list_template").html())

  initialize: =>
    @collection.on "add", @render
    @collection.on "change", @render
    @collection.on "remove", @render

  render: =>
    @$el.html(@template())
    @renderCollection()
    this

  renderCollection: =>
    @$(".tasks").html("")
    if @collection.isEmpty()
      @$el.hide()
    else
      @$el.show()
      @addTask(task) for task in @collection.models

  addTask: (task) =>
    view = new TaskView(model: task, id: "upcoming_task_#{task.id}", color: task.color)
    @$(".tasks").append(view.render().el)

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
    "click .archive_link" : "showListArchive"
    "click .return" : "hideListArchive"
    "sortupdate .tasks" : "taskPositionChanged"

  template: _.template($("#list_template").html())

  initialize: ->
    @model.on "sync", @render
    @model.tasks.on "add", @waitForTask
    @model.tasks.on "reset", @render
    @model.tasks.on "destroy", @render
    @model.tasks.url = "/api/lists/#{@model.get("id")}/tasks"
    @share_view = new ListSharesView(model: @model)
    @share_view.on "shared", @shareList
    @share_view.on "unshared", @unshareList

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
    )
    @$(".tasks").on "sortupdate", @taskPositionChanged
    @$(".list_title").css("background-color", '#'+@model.get("color"))
    @$(".list_actions_link").bind "clickoutside", (event) =>
      @$(".list_actions").hide()
    if @model.get("shared")
      @shareList()
    @$(".share_link").bind "clickoutside", (event) =>
      @$(".share").hide()

    @$(".share").append(@share_view.render().el)
    @setupColorPicker()
    @focus()
    @hideListArchive()
    this

  shareList: =>
    @$el.addClass("shared_list")

  unshareList: =>
    @$el.removeClass("shared_list")

  setupColorPicker: =>
    @$(".picker").colorPicker()

  focus: ->
    @$("[name='task[title]']").focus()

  waitForTask: (task) =>
    task.on "sync", @addTask

  addTask: (task) =>
    task.off "sync", @addTask
    view = new TaskView(model: task, id: "task_#{task.id}")
    if @$(".tasks .completed").length > 0
      @$(".tasks .completed:first").before(view.render().el)
    else
      @$(".tasks").append(view.render().el)

  addAll: =>
    @tasks.each(@add_task)

  createTask: =>
    @model.tasks.create(title: @$("[name='task[title]']").val())
    @$("[name='task[title]']").val("")
    false

  updatePosition: (event, position) =>
    @model.save({new_position: position}, {silent: true})

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

  showListArchive: =>
    @$el.siblings(".list").hide()
    @$(".archived").show()
    @$(".return").show()

  hideListArchive: =>
    if @$el[0].parentNode != null
      @$el.siblings(".list:not(.upcoming)").show()
    @$(".archived").hide()
    @$(".return").hide()

class @DashboardView extends Backbone.View
  el: "#listwerk"
  events:
    "submit #new_list" : "createList"
    "sortupdate tr": "listPositionChanged"

  initialize: ->
    @table = @$("#container > table")
    @upcoming = new UpcomingTaskList
    @upcoming_view = new UpcomingListView(collection: @upcoming)
    @setupUpcoming()
    @collection.on "add", @waitForList
    @collection.on "change", @setupUpcoming
    @render()

  setupUpcoming: (list) =>
    @trackTasks(list.tasks) for list in @collection.models
    @drawUpcoming()

  drawUpcoming: =>
    @upcoming.reset([])
    @visitTasks(list.tasks, list.get("color")) for list in @collection.models

  trackTasks: (tasks) =>
    tasks.on "change", @drawUpcoming

  visitTasks: (tasks, color) =>
    @upcoming.add_with_color(task, color) for task in tasks.models when task.has("due_date") && !task.get("completed")

  render: ->
    @drawLists()
    @$("tr").sortable(
      axis: "xy"
      items: ".list"
      handle: ".list_title"
      opacity: .95
    )
    @$("#list_title").focus()

  listPositionChanged: (event, ui) =>
    ui.item.trigger("dropList", ui.item.index())

  drawLists: =>
    @$el.find("tr").html("")
    @table.find("tr").append(@upcoming_view.render().el)
    @collection.each(@addList)

  waitForList: (list) =>
    list.on "sync", @addList

  addList: (list) =>
    list.off "sync", @addList
    view = new ListView(model: list, id: "list_#{list.id}")
    @table.find("tr").append(view.render().el)

  createList: (event) ->
    @collection.create(title: @$("#list_title").val())
    @$("#new_list input").val("")
    false
