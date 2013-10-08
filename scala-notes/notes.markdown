Sclack!!: Passing on the Knowledge
==================================

### Forenote

Before starting, I'd like to say that I am in no way an expert on Scala. I have
had the pleasure of being introduced in a course, and using the programming
language for 1-2 months. For a while I've been wondering if there was a
language that wrote like a script, and compiled to either byte code, or native
binaries. And Scala just filled that void for me.

These are my notes on how I used Scala in order to tackle a project that I've
been wanting to give a shot for a while.

I've documented also how I setup the project, and the tools I used in order to
get everything up and running. So if you're interested in writing something
of your own in Scala, this could be a good starting point.

_Versions used, when this was written (Thu Sep 26 21:42:55 EDT 2013):_

* Scala, version 2.10.0-20121205-235900-18481cef9b 

* SBT, version 0.13.0-1

This will first introduce you to some tools that you can use in oder to develop
in Scala, and some code snippets to introduce you to some practical aspects of
the language.

### What is this project about?

I wanted to write a rogue-like in Scala, but provide a minimal graphical
interface. During the time I was working on this project, I was also thinking
about game editors and how you could mess around with assets. I basically 
wanted to see how some aspects of rogue-likes, and some aspects of said game
editors took form when written down in code.

## Starting off the project

I like using command line tools. So, in this application, I used a build tool
called sbt, and vim for writing up the code. The setup is minimal.

### SBT: Simple Build Tool

SBT can be accessed in the command line after you have installed it on your
system. On an (linux) Arch install, you'd do: 

````bash
# pacman -S sbt
````
Other variants of linux should be like this:

Fedora, and Scientific Linux (and other similar red-hat variants) use yum:

````bash
$ sudo yum install sbt
````

Ubuntu and similar use apt-get

````bash
$ sudo apt-get install sbt
````

Then you just need to write your (optional) configuration file for your
project. The configuration file of sbt is located in the root directory of said
project.  It contains information about the project such as _version number_,
_name_, and other fluff like that. More importantly, you can specify the scala
version you require for this application, as well as dependencies. This pretty
much manages everything for you on the fly; the required scala version, along
with the dependencies that work with *that* particular scala version, are
downloaded from repositories such as _maven.org_ (or any other user defined
repository if specified), and compiled as well if needed.

Let us take a look at the current project's sbt file, sclack.sbt:

````scala
import AssemblyKeys._

assemblySettings

name         := "sclack"

version      := "1.0"

scalaVersion := "2.10.0"

libraryDependencies ++= Seq(
  "org.scalatest"  % "scalatest_2.10"     % "1.9.1" % "test",
  "org.scalaquery" % "scalaquery_2.9.0-1" % "0.9.5",
  "org.xerial"     % "sqlite-jdbc"        % "3.6.16",
  "org.scala-lang" % "scala-swing"        % "2.10.0"
)

exportJars := true

````

For this project, I decided using a few 3rd party libraries which some I
did not completely have the chance to investigate given the alotted time. You
can see these libraries inside "libraryDependencies". The first column is the
GroupID (think of it as a certain software vendor id) we want things from, the
second the library name, with a required scala version shown some times, and
the third column being the version of that actual library. 

For the purpose of this project, I added Scalatest, SQLite, ScalaSwing and
ScalaQuery to the dependency stack, though as stated, I did not get a chance to
use everything. I've also used a plugin to sbt called *Assembly* which packages
all the dependencies in a big jar file, so that you can share the resulting
binary with ease. (This however will make a really beefy jar file, and might
not be something you want, so be sure that you want to indeed assemble things).

Note: an SBT configuration file (project-name.sbt), IS A scala file. So you can
probably do some programmatic stuff in there; I have not tested this out yet.
If you want to read more about this file, you can read the official
documentation here: 

> [SBT file Specification](http://goo.gl/klcF93)

And some even more detailed configuration details here:

> [SBT file Specification on STEROIDS](http://goo.gl/M7reZa)

Finally you just need to run sbt:

````bash
$ sbt
````

On a last note, as previously mentioned, the sbt file is not really required
for a project. You can enter any directory with Scala sources, 
and run sbt in `project-root-dir', you're ready to compile and run your
application.

##### SBT Commands

The only commands you really need to memorize, are 'compile' and 'run'. And
'run' calls `compile` if needed. So that's one command.

If you're using a testing framework as I am (scalatest), you can type `test' in
order to run your tests. 

If `scaladoc` is available on your scala install, you should be able to run the
command `doc` in sbt, and that will generate API documentation given that you
have written javadoc like comments. 

## Software Engineering

Some pretty standard Software Engineering techniques have been used in this
project. The parts of the system are separated in UI, Domain, and Technical
packages. There's slight use of some standard patterns, but I didn't get the
chance to continue much of the project.

### Testing

Using Scalatest, we're given access to different testing suites. I used a BDD
suite, and all the tests may be observed in `src/test'. To execute them, run 
sbt and type 'test'.

````bash
[psyomn@aeolus sclack 0]$ sbt
Loading /usr/share/java/sbt/bin/sbt-launch-lib.bash
[info] Loading project definition from .../scala/sclack/project
[info] Set current project to sclack (in build file:.../scala/sclack/)
> test
[info] WizardTest:
[info] Wizard traits 
[info] - should be an instance of Character
[info] - should be observable
[info] - should be demonstratable
[info] Wizard attributes 
[info] TileHelperTest:
[info] TileHelper 
[info]   Attributes 
[info]   - should include a tile method
[info]   - should include a width method
[info]   - should include a height method
[info]   - should include a tileset method
...
````

The tests are probably not what you would see in the real world, but I was just
messing around, and curious to see this testing suite in action.

### Some Scala Code in Action

Let us take a look at some fun and interesting stuff that was done in the
software.

#### Classes and Objects 

Basically we discern between things we want to instantiate, and things we don't
want to instantiate (ever). For example, a standard main entry point, would
look like this: 

````scala
object Main {
  def main(args: Array[String]){
    ...
  }
}
````

On the other hand, here is a simple class used in the application for
simulating a die. We instantiate this class with sides, as you can see
right next to the class declaration.

````scala
package sclack.domain

import scala.util.Random

class Die(sides: Int){

  def roll = random.nextInt.abs % sides + 1
  val random = new Random()
}

...

var die = new Die(20)

````

For an example using objects, we can see the following. This is a helper class
that I needed that just gives back cartesian coordinates. This does not need
instantiation, however the methods fit well together. Therefore this object
was defined:

````scala
package sclack.tech

object CoordinateHelper {

   def adjacentCoordinates(coord: (Int,Int)) : Array[(Int,Int)] = {
     Array[(Int,Int)](
     (coord._1 - 1, coord._2), /* left  */
     (coord._1 + 1, coord._2), /* right */
     (coord._1, coord._2 - 1), /* up    */
     (coord._1, coord._2 + 1)  /* down  */
     )
   }

   def moveNorth(curr: (Int,Int)) : (Int, Int) = {
     (curr._1, curr._2 - 1)
   }

   ... 
}

````

Just 2 small observations: tuples in Scala are expressed as variables inside
parentheses. For example `(Int, String, Int)`  is a tuple with the first
element being `Int`, the second being `String`, and the third being `Int`. Also
you might have noticed that there are no `return` statements in the above code,
though the methods actually have a type signature. This is legal because the
value returned is the last value evaluated in Scala.

#### Inheritance

Here is an example of inheritance in Sclack and Scala: 

````scala
abstract class Character extends Entity with Observable 
                                        with Demonstratable{

  def observe = "A fine fellow"
  def demonstrate = TileManager.tile("dun", 3)

  var hitpoints    : Int = 10
  var constitution : Int = 10
  var intelligence : Int = 5
  var magicPoints  : Int = 0
  var strength     : Int = 1
  var dexterity    : Int = 1
  var skillpoints  : Int = 0
  var level        : Int = 1
  var experience   : Int = 0
  
  ...
  
  def combinedStrength : Int
  def combinedIntelligence : Int
  def combinedConstitution : Int
  def combinedDexterity : Int

  /** 
   * Easy way to discern class (should not be used programmatically for
   * checks) 
   */
  def discipline : String 

}
````
And here is an inheriting class. You can see how to override in this example.

````scala
package sclack.domain

class Fighter extends Character {
  override def observe = "You see a muscular, intimidating person."
  def combinedStrength = strength + 5
  def combinedIntelligence = intelligence - 3
  def combinedConstitution = constitution + 2
  def combinedDexterity = dexterity + 1
  def discipline = "Fighter" 
}

````

#### Traits 

If you come from a java background, you can think of `Traits` as interfaces.
For example, let us present a trait that we want to use for observable entities
in the game. We want to get a string describing that entity.

````scala
trait Observable {
  def observe : String
}

````

Now we can use this trait for pretty much anything that is `Observable`.

````scala
class Rogue extends Character {
  override def observe = "You see a ninja like person"

  ...
}

````


#### Using tilesets

I mentioned that I was thinking about game makers when approaching this game.
The game editors I had in mind were mostly from the old school ones, which were
2D, and used tilesets to create maps. Tilesets are a collection of small square
patterns that are used repeatedly in a rectangular map, in order to demonstrate
the virtual world. I wanted to see how easy or hard the implementation of such
a service would be and bellow are the results: 

````scala
class TileHelper(x: Int, y: Int, bdr: Int = 0, tset: java.net.URL){
  
  lazy val tileset = ImageIO.read(tset)

  def tile(id: Int) : BufferedImage = {
    if (id <= 0) throw new SclackTechnicalException("ids are > 0")

    tileset.getSubimage(
      relativeX(id),
      relativeY(id),
      width,
      height)
  }
  ...
````

This creates a helper that can be instantiated. In the case of this project,
we instantiate a tilehelper per tileset. If we have a resonable amount of
tilesets it's not too memory costly. You can notice a `lazy` there as well.
That is used to delay the loading of the graphics file until it is needed. This
would allow for nicer execution if we had a few many tilesets to load this way,
since instead of loading everything in one shot, resources are loaded as 
needed, and making execution seem rather smooth. 

For this application we kept things simple, and created a `TileManager`. The
`TileManager` provides shorthands to access the different tiles of each
tilesets, by providing it a tileset identifier (in this case we have ''fan''
and ''dun'' as the two identifiers), and a tile id.

````scala
package sclack.tech

import java.awt.image.BufferedImage
import scala.collection.mutable.HashMap
import java.awt.image.BufferedImage

object TileManager {

  private var tilemap = new HashMap[String,BufferedImage]

  def tile(name: String, ix: Int) : BufferedImage = {
    name match {
    case "dun" => 
      return dungeonTileHelper.tile(ix)
    case "fan" => 
      return fantasyTileHelper.tile(ix)
    }
  }

  def widthOf(name: String) : Int = {
    name match {
    case "dun" => return dungeonTileHelper.width
    case "fan" => return fantasyTileHelper.width
    }
  }

  def heightOf(name: String) : Int = {
    name match {
    case "dun" => return dungeonTileHelper.height
    case "fan" => return fantasyTileHelper.height
    }
  }

  private val dungeonTilesetName = "/16x16-dungeon-tiles-nes-remake.png"
  private val fantasyTilesetName = "/16x16-fantasy-tileset.png"
  private val dungeonTilesetRes  = getClass.getResource(dungeonTilesetName)
  private val fantasyTilesetRes  = getClass.getResource(fantasyTilesetName)

  private val dungeonTileHelper  = new TileHelper(16,16,2,dungeonTilesetRes)
  private val fantasyTileHelper  = new TileHelper(16,16,0,fantasyTilesetRes)
}

````

#### Overriding Swing's Paint Method

I ended up using some _java.awt_ parts to get this working, but for the world
rendering in the application, I overrode the paint methods provided by the 
panel. This can be seen in the bellow code fragment.

````scala
package sclack.ui.widgets

import sclack.tech.TileManager

/** 
 * This is the widget where the world is demonstrated upon. 
 * Whatever happens to the domain version of the world should 
 * be represented here.
 * 
 * @author Simon Symeonidis 
 */
object WorldWidget extends Panel {
  var currMap : sclack.domain.Map = _
  var tileMan = TileManager

  preferredSize = new Dimension(400,400)
  maximumSize   = new Dimension(400,400)
  minimumSize   = new Dimension(400,400)
  border        = new EmptyBorder(10,10,10,10)

  override def paint(g: Graphics2D) {
    drawMap(g)
    drawNPCs(g)
    drawPlayer(g)
    
    g.finalize()
  }
                                                                  
  private def drawMap(g: Graphics2D) {
    val width  = currMap.width  - 1
    val height = currMap.height - 1
    var currentTile : Int = 0

    for (i <- 0 to height){
      for (j <- 0 to width){
        currentTile = (height + 1) * i + j
        g.drawImage(
          tileMan.tile("fan", 
          currMap.at(i,j)), /* What to draw */ 
          j * 16, i * 16, null)
      }
    }
  }

  /* Isolate drawing logic for maps */
  private def drawNPCs(g: Graphics2D) {
    for (ent <- currMap.entities){
      g.drawImage(ent._3.demonstrate, ent._1, ent._2, null)
    }
  }

  /* For drawing the main player on the map */
  private def drawPlayer(g: Graphics2D) {
    g.drawImage(
      currMap.mainChar.demonstrate, 
      currMap.mainCharPos._1 * 16,
      currMap.mainCharPos._2 * 16,
      null)
  }
}

````

### Random nice things

A relatively nice thing that I was also able to use is the `splat` operator. 
The splat operator can be noticed bellow, as the parameter of the `listenTo`
function. 

````scala
object ActionButtons extends GridBagPanel {
  val buttonsCaptions : Array[String] = Array[String](
    "?",      "/\\",    "?", 
    "<",      "center", ">",
    "Attack", "V",      "Observe")

  val buttons : Array[Button] = buttonsCaptions.map(new Button(_))

  listenTo(buttons:_*)
  reactions += {
    case ButtonClicked(b) => 
      b.text match {
        case `buttCapSpecial1` => reactSpecial1
        case `buttCapSpecial2` => reactSpecial2
        case `buttCapNorth`    => reactNorth
        ...
  }
````

This is very helpful, as we can express a lot by typing in a little: if we were
to not use a splat operator, we would have to manually insert all the buttons
by index:

````scala
  listenTo(buttons(0), buttons(1), buttons(2), ...)
````

Another nice thing that has been brought into Scala is the `map` method as well
which is more commonly seen in funtional programming. I ended up using this to
shorten the amount of lines I had to write in order to generate the buttons:

````scala
  val buttonsCaptions : Array[String] = Array[String](
    "?",      "/\\",    "?", 
    "<",      "center", ">",
    "Attack", "V",      "Observe")

  val buttons : Array[Button] = buttonsCaptions.map(new Button(_))

````

The underscore is where each element of the mapped array is placed into. So
we're using the mapping function in this case to create buttons from all the 
labels in the `buttonsCaptions` array.

Last but not least, here is an example of a BDD test that can get you started:

````scala
import org.scalatest.FunSpec
import org.scalatest.BeforeAndAfter

import sclack.domain.{Fighter, Character}
import sclack.testing.Common

class FighterTest extends FunSpec with BeforeAndAfter{
  
  var fighter : Fighter = _

  before {
    fighter = new Fighter()
  }

  describe("Fighter traits") {
    it("should be an instance of Character") {
      assert(fighter.isInstanceOf[Character])
    }

    it("should be observable") {
      assert(Common.hasMethod("observe", fighter))
    }
    
    it("should be demonstratable") {
      assert(Common.hasMethod("demonstrate", fighter))
    }
  }

}
````

This test is not quite what you'd probably see in a real project, but should
demonstrate the basics. The Common object is a custom helper class, and
I wanted to take a look at reflection capabilities in Scala. It just checks to
see if the method is available in the given class:

````scala
package sclack.testing

object Common {
   /* Thanks to http://stackoverflow.com/questions/2886446 */
  def hasMethod(name: String, obj: Object) = obj.getClass
      .getMethods
      .map(_.getName)
      .contains(name)
}

````

## Repository

All the code is available on github:

> [github.com/psyomn/sclack.git](http://www.github.com/psyomn/sclack.git)

