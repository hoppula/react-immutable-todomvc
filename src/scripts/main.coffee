React = require("react")
Immutable = require("immutable")

Todos = require("./components/todos.coffee")
todos = Immutable.Map()

# read from localStorage
if localStorage
  todosJSON = localStorage.getItem("immutableTodos")
  if todosJSON
    todos = Immutable.fromJS(JSON.parse(todosJSON))

React.renderComponent <Todos todos={todos} />, document.getElementById("app")