% Introduction to Ada, and Formal Specifications
% Simon Symeonidis

# Introduction

- "C makes it easy to shoot yourself in the foot; C++ makes it harder,
  but when you do it blows your whole leg off." -- Bjarne Stroustroup

# Introduction II

- You aim at your foot and pull the trigger, but the safety stops the
  gun from firing. The safety won't budge until you tag your foot with
  a sign reading "Bullet Hole in this foot", and call the
  paramedics. You do so, then shoot yourself in the foot. -- Ted
  Denisson [AdaPowerTD]

# History

- Where did Ada come from?
- Where is it going?

# One Language to rule them all

- It came from the DoD
- Originally the motivation behind Ada was to have one standard
  language for a number of application in the DoD.
- They had a lot of different application written in different
  languages that did things poorly.
- Speculated maintenance nightmare.

# One Language find them all

- There was a competition to find a language that fit a lot of use
  cases the DoD had.
- These requirements were known as the `Steelman Language
  Requirements`, and you can read them here [Steelman]
- A language design finally won in this competition, and it was going
  to be known as `Ada`.
- An in the darkness bind them.

# Is Ada popular yet?

- Nope, and probably will never be.
![Ada vs C/C++/C# on Google Trends](./ada-google-trends.png)

# Why does Ada look that way

- empirical studies on:
    - usability
    - readability
    - and all that good stuff

# What is happening to Ada

- language still actively being developed on
- some example releases:
    - Ada83
    - Ada95
    - Ada2005
    - Ada2012
- this has lead the language to become massive
- like really big
- really really big

# Readability

- Things are readable, right?

```ada
procedure Main is
begin
   null;
end Hello_World;
```

# Alright, let's begin with stuff

- You need an Ada compiler. At the time of writing, there's two
  compilers available.
    - gcc-ada (gnu)
    - adacore ada (commercial, and free if open source)

# First things First

- A very common programming construct to understand for Ada is the
  following:

```nocode
<program unit name>
  <declarations>
  <code body>
```

- That is, unlike some programming languages, your variable
  declarations must all be present within the declaration block.
- Just like C/C++, we have headers and implementation
  files. In Ada, these files are Signature (ads), and Body files (adb)
  respectively.

# Before we start

- To compile things you need to run `gnatmake` on a file.
- For our purposes a simple file called `main.adb` will suffice.
- In other words, we won't be going over program units (packages etc)
  in this particular presentation.

```nocode
$ gnatmake main.adb
```

- Also you might not be used to this, but Ada is case **insensitive**
    - `xXxDaRkLoRd666xXx` is equivalent to `xxxdarklord666xxx`

# I have no mouth and I must scream

- Let's write a very simple program.

```ada
-- main.adb
procedure Main is
begin
   null;
end Main;
```

- You'll notice the `null`. In Ada you need to specify empty function
  and procedure bodies with a `null`.

# Including standard libraries

- Basically "How do I print things".
- Basically, "Hell world".

```ada
-- main.adb
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
begin
   Put_line ("pleh dnes");
end Main;
```

# Control Structures: IF

- Some stuff will seem familiar
```ada
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
begin
   if True then
      Put_Line ("hi there");
   else
      Put_Line (
         "mommy threatened the compiler " &
         "would optimize me out");
   end if;
end Main;
```

- :(
```nocode
[psyomn@mrbubbles]: tmp>$ strings main | grep mommy
[psyomn@mrbubbles]: tmp>$
```

# Control Structures: LOOP

- Simplest loop
```ada
procedure Main is
   Count : Integer := 0;
begin
Kawai_Loop :
   loop
      Count := Count + 5;
      exit Kawai_Loop when Count > 10;
   end loop Kawai_Loop;
end Main;
```

# Control Structures: FOR

- Your standard for loops

```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
begin
Mew_Mew_Mew :
   for I in Integer range 1 .. 10 loop
      for J in Integer range 1 .. 100 loop
         exit Mew_Mew_Mew when I + J = 109;
      end loop;
   end loop Mew_Mew_Mew;
end Main;
```

# Control Structures: SWITCH (not the nintendo one)

- You can specify ranges which is nice
- You specify the default case with `others`.
```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
begin
   case 10 is
      when 1 => null;
      when 2 => null;
      when 3 .. 10 => null;
      when others => null;
   end case;
end Main;
```

# Functions, Procedures

- Ada has functions and procedures.
- Procedures return nothing
- Functions return some type
- Functions and procedures must be declared in the declarative part of
  the function or procedure.

# Functions, Procedures: Procedures

```ada
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
   procedure Do_Thing(X : Integer) is begin
      Put_Line("im doing the thingy thing" & X'Img);
   end Do_Thing;
begin
   Do_Thing(123);
   -- output: im doing the thingy thing 123
end Main;
```

# Functions, Procedures: Function Syntax

```ada
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
   function Funcky_Thing (X : Integer; Y : Integer)
   return Integer is
      Result : Integer := X + Y;
   begin
      return Result;
   end Funcky_Thing;

   Val : Integer;
begin
   Val := Funcky_Thing(10, 12);
   Put_Line("funcky: " & Val'Img);
end Main;
```

# Functions, Procedures: Ins and Outs

<!-- TODO Fix formatting... -->
```ada
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
   procedure Em_Pleh
     (X: in Integer; Y: out Integer; Z: in out Integer) is
   begin
      case X is
         when 1       => Y := 10;
         when 2 .. 10 => Y := 90;
         when others  => Y := 666;
      end case;
      Z := Z + 1;
   end Em_Pleh;
   type Range_Type is range 1 .. 10;
   M_X, M_Y, M_Z : Integer := 0;
begin
   for I in Range_Type loop
      Em_Pleh (X => M_X, Y => M_Y, Z => M_Z);
   end loop;
   Put_Line ("X:" & M_X'Img & " Y:" & M_Y'Img & " Z:" & M_Z'Img);
end Main;
```

# Small Exercise I: Question

Write a function that returns the result Z when it substracts X from
Y (which are both postive integers), and also returns a boolean
denoting whether the result is Even.

Hint: Modulo keyword is `mod`. The types for integers and booleans you
can use `Integer` and `Boolean`.

# Small Exercise I: Solution

- It should look something like this:

```ada
function Derp (X : Integer;
               Y : Integer;
               Z : in out Integer)
              return Boolean is
begin
   Z := Y - X;
   return Z mod 2 = 0;
end Derp;
```

# Ada's Type System

Ada had from the earliest type system that resembles some of the more
modern ones of today (eg: Rust, OCaml). You can subtype existing types
to fit your needs as you see fit.

<!----
 ----- TODO
 ----->

# Small Exercise II


<!---
 ---- Design by Contract
 ---->

# Ada is MASSIVE

- There tends to be a lot of features that are crammed into the
  language.
- This can be bad and good for obvious reasons.
- Usually you can turn these features on and off with pragmas.

# Enabling and Using 'Design by Contract' in Ada

- Design by Contract in its simplest: you specify expectations and
  guarantees on your functions and procedures.
- These terms have been coined as preconditions and postconditions.
- Callers, and Callees: Callers are the units that are calling a
  specific functions or procedure.
- Example: `fn a() -> { STUFF; }`, `fn b() -> a();`
- In the context of function `b`, `b` is the `caller` and `a` is the
  callee.

# DbC: Preconditions, Postconditions, Hoare Triple

Hoare Triples: P is a precondition, C is the command, and Q is the
postcondition.

> \{P\} C \{Q\}

__Preconditions__: Expect that stuff given by the caller to the callee,
has data within acceptable bounds of the function/procedure.

__Command__: The actual programming unit we want to execute.

__Postconditions__: Given that the data given was good, we must ensure
that the data produced and given back is within the specified
bounds, to the caller.

# Example DbC: Toy Problem

- Let `a`, and `b` be positive numbers.
- The operation we wish to perform is add these two numbers.
- Due to the nature of `a`, and `b` being positive integers, we want
  to make sure that their addition is greater than either.
- Can you identify the Hoare Triple above?

# Example DbC: Implementation of 'C'

- The operation we wish to perform is add these two numbers.
```ada
function Add (A: Integer; B: Integer) return Integer
is
   Ret : Integer := A + B;
begin
   return Ret;
end Add;
```

# Example DbC: Implementation of 'P'

```ada
function Add (A: Integer; B: Integer) return Integer with
   Pre  => A > 0 and B > 0
is ...
```

# Example DbC: Implementation of 'Q'

```ada
function Add (A: Integer; B: Integer) return Integer with
   Pre  => A > 0 and B > 0,
   Post => Add'Result > A and then Add'Result > B
is
```

# Example DbC: In Action

- We can quickly see things blowing up in action.
```ada
procedure Main is
   function Add ...
   Val : Integer := 0;
begin
   -- Val := Add (1, 2); OK
   -- Val := Add (-1, 2); BOOM: "provide positive integers"
   -- Val := Add (1, -2); BOOM: "command failed expectations"
end Main;
```

- To trigger the postcondition, we could mess up the implementation
  (eg: return `-100`). This seems funny in small scale, but helps in
  larger, complex implementations.

# Example DbC: Performance Concerns

- Pre and Post conditions work like assertions, and can be switched on
  and off.

<!---
 ---- Concurrency
 ---->

# Parallel Programming

<!-- TODO should this be in the talk?
     Maybe an exercise would be fun for this. -->
- Ada was designed to have parallel programming in the core language.
- You can get this sort of thing by using `Tasks`

# Formal Specifications

- motivation
<!-- how do I explain this ? -->

# Where to go from here, Resources

- *AdaCore* is doing most of the new, interesting things with Ada.
- *Planet Ada* has some fun projects. At the time of writing site seems
  to be down, might be back soon? [PlanetAda]
- *Make With Ada*
- Interesting case studies one can read in Ada: "Rail, Space,
  Security: Three Case Studies for SPARK", Claire Dross 2014
  [AdaCaseStudies2014]

# References

<!-- TODO: formatting is messed up here -->
- [Steelman] https://www.dwheeler.com/steelman/steelman.htm
- [AdaPowerTD] http://www.adapower.com/index.php?Command=Class&ClassID=Humor&CID=8
- [AdaCaseStudies2014] http://www.spark-2014.org/uploads/erts_2014.pdf
- [PlanetAda] http://planet.ada.wtf
