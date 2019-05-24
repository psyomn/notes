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

# Lua: Object Orientation I

```lua
-- you first need to do this:
Meatbag = {}
Meatbag.__index = Meatbag

-- you define a constructor this way
-- notice the : and not a .
function Meatbag:new(name, age)
  -- notice that we do the local now. do the local now.
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

# Love2d

Games usually have a loop that certain things fire off. It's a common
thing you'll see a lot of game engines do. These concerns are
typically:

- Loading your game state
- Updating your state
- Drawing the results

# Love2d II: Game loop

Nothing special; your game look would look something like this:

```c
// load game state stuff

while (running) {
    // get input / events

    // update objects states

    // draw them on the screen
}
```

# Love2d III: FPS is not always first person shooter

- PC Masters has 60fps
- Console plebs have 30fps
- Could there be problems porting games that rely on these figures?
  (spoiler: this never happens, but entertain the idea for the
  explanation).
- Let's say our object, for example a ball, moves one pixel every game
  loop. PC Masters will see the ball move twice as fast as the Console
  plebs.
- This is not good.
- How would a better approach look like?

# Love2d IV: Delta Time

- Delta time solves this problem.
- Between each game loop, we calculate the distance that the object
  would have been displaced.
- For now we can use a simple equation to get distance displaced

> pos\_x' = pos\_x + dt * velocity

- And of course you can do the same thing for the `y` coords

> pos\_y' = pos\_y + dt * velocity

# Love2d: Objects

- It's usually comfortable to define objects which are representing
  actors in your game, with certain configurations
- You'll usually want x, y positions, and a height, width
- You'll also want a x velocity, and a y velocity

# Love2d: Skeleton

- create a directory with your game name `pong/`
- create a `main.lua` file inside
- you'll need three methods (and notice the `.` used in this special
  case -- don't ask me what that is)

```lua
function love.load()
end

function love.update(dt)
end

function love.draw()
end
```

# Love2d: Useful stuff

- Rectangles are important. Here's how to draw one

```lua
love.graphics.rectangle("fill", x, y, width, height)
```

- Keyboard input is important

```lua
love.keyboard.isDown("up")  love.keyboard.isDown("right")
love.keyboard.isDown("left") love.keyboard.isDown("down")
love.keyboard.isDown("w") love.keyboard.isDown("a")
love.keyboard.isDown("s") love.keyboard.isDown("d")
```

# Love2d: Rectangle Intersection

- If you're too lazy to think about it:

```lua
-- Intersection check between two rectangles
-- can be done this way:
--   Bx + Bw > Ax &&
--   By + Bh > Ay &&
--   Ax + Aw > Bx &&
--   Ay + Ah > By;
return other:getX() + other:getWidth() > self.x and
    other:getY() + other:getHeight() > self.y and
    self.x + self.width > other:getX() and
    self.y + self.height > other:getY()
```
