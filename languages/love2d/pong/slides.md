# Make Pong in an Hour!

# Making Pong!

- learn basics of Lua
- use Love2d (<http://love2d.org>)
- see game development basics
- draw pong elements
- implement collision detection
- extra: implement COLOR PONG

# Lua: games and C++

- A lot of game engines or C++ projects extend through lua
- Lua. It's awrite.

# Lua: SURPRISE!

- No surprises in Lua

```lua
-- double dash comments like SQL, and ADA. What. Why.

print("hello")
x = 1
y = x + 2
z = 0.3
w = 0.2 * z

print(y)
print(w)
```

# Lua: Tables

- The bread and butter in LUA programming seems to be the exhorbitant
  use of tables
- Tables are kind of everything in LUA. Kind of like the blob
  consuming everything into an untold mass.
- Hashes are actually a table.
- An array is a table.
- Your pet is a table.

# Lua: Table Usage

```lua
keys = 4
makeup = "AAAAAHHHHH"
upon_the_table = {keys, makeup}
```

# Lua: SPOILERS: OBJECT ORIENTATION!

- Guess what!? OBJECTS!
- You get an object, you get an object, and you get an object!
- Actually it's kind of hacky in LUA

```lua
-- you first need to do this:
Meatbag = {}
Meatbag.__index = Meatbag
```

# Lua: Hacking Object Orientation

- TODO what does __index mean

# Lua: Object Orientation I

```lua
-- you first need to do this:
Meatbag = {}
Meatbag.__index = Meatbag

-- you define a constructor this way
-- notice the : and not a .
function Meatbag:new(name, age)
  -- notice that we
  local obj = {}
  -- this is important, don't forget to do this
  setmetatable(obj,Meatbag)

  obj.name = name
  obj.age = age
  return obj
end
```

# Lua: Object Orientation II

```lua
-- typical things like accessors and mutators are
-- not anything surprising

function Meatbag:getName()
  return self.name
end

function Meatbag:getAge()
  return self.age
end
```

# Lua: Object Orientation III

```lua
-- instantiate an object
person = Meatbag:new("jonny", 17)
print(person:getName()) -- notice the :
print(person:getAge())
```
