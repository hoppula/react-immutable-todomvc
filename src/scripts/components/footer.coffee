React = require("react/addons")
classSet = React.addons.classSet

Footer = React.createClass
  clearCompleted: ->
    @props.todosCursor.update (todos) ->
      todos.filter (todo) ->
        todo isnt undefined and not todo.get("completed")
      .toVector()

  render: ->
    remaining = @props.todosCursor
      .filter (todo) ->
        todo isnt undefined and not todo.get("completed")
      .count()

    completed = @props.todosCursor
      .filter (todo) ->
        todo isnt undefined and todo.get("completed")
      .count()

    remainingTitle = if remaining is 1 then "item" else "items"

    <footer id="footer">
      <span id="todo-count">
        <strong>{remaining}</strong> {remainingTitle} left
      </span>
      <ul id="filters">
        <li>
          <a className={classSet(selected: @props.filter is "all")} href="#/">All</a>
        </li>
        <li>
          <a className={classSet(selected: @props.filter is "active")} href="#/active">Active</a>
        </li>
        <li>
          <a className={classSet(selected: @props.filter is "completed")} href="#/completed">Completed</a>
        </li>
      </ul>
      {<button id="clear-completed" onClick={@clearCompleted}>Clear completed ({completed})</button> if completed}
    </footer>

module.exports = Footer