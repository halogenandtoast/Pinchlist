class Task extends Backbone.Model

class TaskList extends Backbone.Collection
  model: Task
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

class TaskView extends Backbone.View
  tagName: "li"
  className: "task"
  events:
    "dropTask" : "updatePosition"

  template: _.template($("#task_template").html())

  render: ->
    @$el.html(@template(@model.toJSON()))
    this

  updatePosition: (event, position) =>
    @model.save(new_position: position + 1)

class ListView extends Backbone.View
  tagName: "td"
  className: "list"
  events:
    "submit .newtask" : "createTask"
    "dropList" : "updatePosition"
    "click .list_actions_link" : "toggleListActions"
    "click .delete a" : "deleteList"

  template: _.template($("#list_template").html())

  initialize: ->
    @model.tasks.on "add", @waitForTask
    @model.tasks.url = "/api/lists/#{@model.get("id")}/tasks"

  render: ->
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
    this

  setupColorPicker: =>
    @$(".picker").colorPicker(onColorChange: @changeColor)

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

  changeColor: (color) =>
    @model.save(color: color.substring(1))

  toggleListActions: =>
    @$(".list_actions").toggle()

  hideListActions: =>
    @$(".list_actions").hide()

  deleteList: =>
    if confirm @$(".delete a").data("confirm")
      @model.destroy
        success: => @remove()
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
    view.setupColorPicker()
    view.focus()

  createList: (event) ->
    @collection.create(title: @$("#list_title").val())
    @$("#new_list input").val("")
    false
