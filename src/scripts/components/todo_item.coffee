React = require("react")
classSet = React.addons.classSet

TodoItem = React.createClass

  getInitialState: ->
    editing: false

  toggleCompleted: (event) ->
    @props.todosCursor.update (todos) =>
      todos.updateIn [@props.todo.get("id")], (todo) ->
        todo.set "completed", not todo.get("completed")

  toggleEdit: (event) ->
    @setState editing: true, =>
      @refs.edit.getDOMNode().focus()

  close: (event) ->
    title = event.target.value

    if title
      @props.todosCursor.update (todos) =>
        todos.updateIn [@props.todo.get("id")], (todo) ->
          todo.set "title", title
    else
      @destroy()

    @setState editing: false

  revertOnEscape: (event) ->
    if event.keyCode is 27 # Esc
      @refs.edit.getDOMNode().value = @props.todo.get("title")
      @setState editing: false

  updateOnEnter: (event) ->
    if event.charCode is 13 # Enter
      @props.todosCursor.update (todos) =>
        todos.updateIn [@props.todo.get("id")], (todo) ->
          todo.set "title", event.target.value
      @setState editing: false

  destroy: ->
    @props.todosCursor.update (todos) =>
      todos.delete @props.todo.get("id")

  shouldComponentUpdate: (newProps, newState) ->
    (@props.todo isnt newProps.todo) or (@state.editing isnt newState.editing)

  render: ->
    classes = classSet
      "completed": @props.todo.get("completed")
      "editing": @state.editing

    completed = if @props.todo.get("completed") then "checked" else ""

    <li className={classes}>
      <div className="view">
        <input className="toggle" type="checkbox" checked={completed} onClick={@toggleCompleted} readOnly />
        <label onDoubleClick={@toggleEdit}>{@props.todo.get("title")}</label>
        <button className="destroy" onClick={@destroy}></button>
      </div>
      <input className="edit" defaultValue={@props.todo.get("title")} onKeyDown={@revertOnEscape} onKeyPress={@updateOnEnter} onBlur={@close} ref="edit" />
    </li>

module.exports = TodoItem