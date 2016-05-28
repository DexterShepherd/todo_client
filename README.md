<h1> Todo client </h1>
<h3> A simple todo client written in ruby </h3>

<h5>Setup</h5>
* `touch todos.json` wherever you want to save your todos (probably in a dropbox or other synced folder)
* add `TODO_PATH=PATH_TO_TODOS.JSON` to your env
* add `PATH_TO_TODO_CLIENT` to your `$PATH`

<h5>Usage</h5>

`-n --new TODO` add a new todo <br>
`-c --complete INDEX` mark `todo[INDEX]` as complete <br>
`-l --list [O]` list open todos. right now any argument just enabled notes<br>
`-a --all` list all todos <br>
`-i --index INDEX` select note at `INDEX` to act upon <br>
`-n --note NOTE` add note to todo selected with `-i` <br>
`-s --switch LIST` switch focus to LIST 
`--lists` show all lists <br>
`--add_list LIST` add a new list LIST  (also switches focus to it)<br>


![Todo gif](/images/todo.gif?raw=true "")

