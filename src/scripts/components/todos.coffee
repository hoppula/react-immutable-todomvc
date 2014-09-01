React = require("react")
Immutable = require("immutable")
Router = require("director").Router

Footer = require("./footer.coffee")
TodoItem = require("./todo_item.coffee")

filters =
  all: "all"
  active: "active"
  completed: "completed"

Todos = React.createClass
  getInitialState: ->
    rootCursor: @props.todos.cursor(@onChange)
    filter: filters.all

  componentDidMount: ->
    router = Router
      "/": @setState.bind(@, filter: filters.all)
      "/active": @setState.bind(@, filter: filters.active)
      "/completed": @setState.bind(@, filter: filters.completed)

    router.init "/"

  # cursor update is handled here, newTodos is the new immutable todos Map that replaces the existing state
  onChange: (newTodos) ->
    if localStorage
      localStorage.setItem("immutableTodos", JSON.stringify( newTodos.toJS() ))

    @setState rootCursor: newTodos.cursor(@onChange)
    return

  add: (event) ->
    if event.charCode is 13 # Enter
      @state.rootCursor.update (todos) ->
        last = todos.last()
        id = if last then (parseInt(last.get("id")) + 1).toString() else "0"
        todos.set(id, Immutable.Map(id: id, title: event.target.value, completed: false))

      # clear input value
      @refs.add.getDOMNode().value = ""

  toggleAll: (event) ->
    checked = event.target.checked
    @state.rootCursor.update (todos) ->
      todos.map (todo) ->
        todo.set "completed", checked
      .toMap()

  render: ->
    <section id="todoapp">
      <header id="header">
        <h1>todos</h1>
        <input id="new-todo" onKeyPress={@add} placeholder="What needs to be done?" ref="add" autofocus />
      </header>

      <section id="main">
        <input id="toggle-all" type="checkbox" onClick={@toggleAll} />
        <label htmlFor="toggle-all">Mark all as complete</label>
        <ul id="todo-list">
        {
          @state.rootCursor.filter (todo) =>
            switch @state.filter
              when "all" then true
              when "active" then not todo.get("completed")
              when "completed" then todo.get("completed")
          .map (todo) =>
            <TodoItem todo={todo.deref()} todosCursor={@state.rootCursor} key={todo.deref().get("id")} />
          .toJS()
        }
        </ul>
      </section>

      <Footer todosCursor={@state.rootCursor} filter={@state.filter} />
    </section>

module.exports = Todos
