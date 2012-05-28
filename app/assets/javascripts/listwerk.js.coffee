class Task extends Backbone.Model

class TaskList extends Backbone.Collection
  model: Task
  comparator: (task) ->
    task.get("position")

class List extends Backbone.Model
  urlRoot: "api/lists"
  initialize: (attributes) ->
    @tasks = new TaskList(attributes['tasks'])
    @tasks.url = '/api/lists/'+@get("id")+'/tasks'

class @Lists extends Backbone.Collection
  model: List
  url: "api/lists"
  comparator: (list) ->
    list.get("position")

class TaskView extends Backbone.View
  tagName: "li"
  className: "task"
  events:
    "drop" : "update_position"

  template: _.template($("#task_template").html())

  render: ->
    @$el.html(@template(@model.toJSON()))
    this

  update_position: (event, position) =>
    @model.save(new_position: position + 1)

class ListView extends Backbone.View
  tagName: "td"
  className: "list"
  events:
    "submit .newtask" : "create_task"
    "drop" : "update_position"

  template: _.template($("#list_template").html())

  initialize: ->
    @model.tasks.on "add", @add_task

  render: ->
    @$el.html(@template(@model.toJSON()))
    @model.tasks.each (task) =>
      @add_task(task)
    @$(".tasks").sortable(
      connectWith: ".tasks"
      helper: 'clone'
      items: "li"
      distance: 6
      opacity: .93
      update: @task_position_changed
    )
    this

  focus: ->
    @$("[name='task[title]']").focus()

  add_task: (task) =>
    view = new TaskView(model: task)
    @$(".tasks").append(view.render().el)

  add_all: =>
    @tasks.each(@add_task)

  create_task: =>
    @model.tasks.create(title: @$("[name='task[title]']").val())
    @$("[name='task[title]']").val("")
    false

  update_position: (event, position) =>
    @model.save(new_position: position + 1)

  task_position_changed: (event, ui) =>
    ui.item.trigger("drop", ui.item.index())


class @DashboardView extends Backbone.View
  el: "#listwerk"
  events:
    "submit #new_list" : "create_list"

  initialize: ->
    @table = @$("#container > table")
    @collection.on "add", @wait_for_list
    @render()

  render: ->
    @draw_lists()
    @$("tr").sortable(
      axis: "xy"
      items: ".list"
      handle: ".list_title"
      opacity: .95
      update: @list_position_changed
    )
    @$("#list_title").focus()

  list_position_changed: (event, ui) =>
    ui.item.trigger("drop", ui.item.index())

  draw_lists: =>
    @$el.find("tr").html("")
    @collection.each(@add_list)

  wait_for_list: (list) =>
    list.on "sync", @add_list

  add_list: (list) =>
    list.off "sync", @add_list
    view = new ListView(model: list)
    @table.find("tr").append(view.render().el)
    view.focus()

  create_list: (event) ->
    @collection.create(title: @$("#list_title").val())
    @$("#new_list input").val("")
    false
