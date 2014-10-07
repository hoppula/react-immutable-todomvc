React = require("react/addons")
Immutable = require("immutable")

Todos = require("./components/todos.coffee")
todos = Immutable.Vector()

# read stored state from localStorage
if localStorage
  todosJSON = localStorage.getItem("immutableTodos")
  if todosJSON
    # stringifying sparse arrays to JSON creates null values, get rid of them
    todos = Immutable.fromJS(JSON.parse(todosJSON)).filter((todo) -> todo isnt null).toVector()

React.renderComponent <Todos todos={todos} />, document.getElementById("app")