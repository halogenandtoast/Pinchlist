class Task extends Backbone.Model

class TaskList extends Backbone.Collection
  model: Task

class List extends Backbone.Model
  urlRoot: "api/lists"

class @Lists extends Backbone.Collection
  model: List
  url: "api/lists"
  comparator: (list) ->
    list.position

class TaskView extends Backbone.View
  tagName: "li"
  className: "task"

  template: _.template($("#task_template").html())

  render: ->
    @$el.html(@template(@model.toJSON()))
    this

class ListView extends Backbone.View
  tagName: "td"
  className: "list"
  events:
    "submit .newtask" : "create_task"
    "drop" : "update_position"

  template: _.template($("#list_template").html())

  initialize: ->
    @tasks = new TaskList()
    @tasks.url = "/api/lists/"+@model.id+"/tasks"
    @tasks.on "add", @add_task

  render: ->
    @$el.html(@template(@model.toJSON()))
    _.each @model.get("tasks"), (task) =>
      @tasks.add(new Task(task))
    this

  add_task: (task) =>
    view = new TaskView(model: task)
    @$(".tasks").append(view.render().el)

  add_all: =>
    @tasks.each(@add_task)

  create_task: =>
    @tasks.create(title: @$("[name='task[title]']").val())
    @$("[name='task[title]']").val("")
    false

  update_position: (event, position) =>
    @model.save(new_position: position + 1)

class @DashboardView extends Backbone.View
  el: "#listwerk"
  events:
    "submit #new_list" : "create_list"

  initialize: ->
    @table = @$("#container > table")
    @collection.on "sync", @redraw
    @render()

  render: ->
    @redraw()
    @$("tr").sortable(
      axis: "xy"
      items: ".list"
      handle: ".list_title"
      opacity: .95
      update: @list_position_changed
    )

  list_position_changed: (event, ui) =>
    ui.item.trigger("drop", ui.item.index())

  redraw: =>
    console.log @$el.find(".list")
    @$el.find("tr").html("")
    console.log(@collection)
    @collection.each(@add_list)

  add_list: (list) =>
    view = new ListView(model: list)
    @table.find("tr").append(view.render().el)

  create_list: (event) ->
    @collection.create(title: @$("#list_title").val())
    false
