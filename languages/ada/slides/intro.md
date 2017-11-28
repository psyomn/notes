% Introduction to Ada, and Formal Specifications
% Maybe Part I
% Simon Symeonidis

# Introduction

- Let's get in the Ada mood.

> C makes it easy to shoot yourself in the foot; C++ makes it harder,
> but when you do it blows your whole leg off.

> -- Bjarne Stroustroup

# Introduction II

> You aim at your foot and pull the trigger, but the safety stops the
> gun from firing. The safety won't budge until you tag your foot with
> a sign reading "Bullet Hole in this foot", and call the
> paramedics. You do so, then shoot yourself in the foot.

> -- Ted Denisson [AdaPowerTD]

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
- These requirements were known as the 'Steelman Language
  Requirements', and you can read them here [Steelman]
- A language design finally won in this competition, and it was going
  to be known as 'Ada'.
- An in the darkness bind them.

# Is Ada popular yet?

- Nope, and probably will never be.
- That being said, Ada has made it in niche markets like real time
  embedded systems.
![Ada vs C/C++/C# on Google Trends](./ada-google-trends.png)

# What is happening to Ada

- language still actively being developed on
- some example releases:
    - Ada83
    - Ada95
    - Ada2005
    - Ada2012
    - Ada2017
- this has lead the language to become massive
- like really big
- really really big
- On top of bigness, there's GNAT extensions, and makes Ada even
  BIGGER.
- As a result it was a headache to organize this talk and decide what
  to show, and how to present.

# Alright, let's begin with stuff

- You need an Ada compiler. At the time of writing, there's two
  compilers available.
    - gcc-ada (gnu)
    - adacore ada (commercial, and free if open source)

# Before we start

- To compile things you need to run 'gnatmake' on a file.
- For our purposes a simple file called 'main.adb' will suffice.
- In other words, we won't be going over program units (packages etc)
  in this particular presentation.

```nocode
$ gnatmake main.adb
```

- Also you might not be used to this, but Ada is case **insensitive**
    - 'xXxDaRkLoRd666xXx' is equivalent to 'xxxdarklord666xxx'

# First things First

- A very common programming construct to understand for Ada is the
  following:

```nocode
<program unit name>
  <declarations>
  <code body>
<end name>
```

- That is, unlike some programming languages, your variable
  declarations must all be present within the declaration block.
- Just like C/C++, we have headers and implementation
  files. In Ada, these files are Signature (ads), and Body files (adb)
  respectively.

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
  and procedure bodies with a `null`. Empty inside. Close to home :(.

# Including standard libraries

- Basically, "How do I print things".
- Basically, "Hell world".

```ada
-- main.adb
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
begin
   Put_line ("pleh dnes");
end Main;
```

- If you did not use the `use Ada.Text_IO`, you would need to specify
  the canonical name `Ada.Text_IO.Put_Line("gnideelb truh mi");`.

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
         exit Mew_Mew_Mew when I = 5 and J = 109;
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

# Primitive Types

You can use the typical

- Integer, Natural, Positive
- Float, Long_Float
- Boolean, Char
- String (You need to specify it in array form usually)

```ada
  X : Integer := 0;
  B : Boolean := False;
  S : String (1 .. 10);
```

# Oh, btw, REMEMBER WHEN I SAID DECLARE FIRST? I LIED! NEEAEAHHH

- You can get away the delcarative part of your functions and
  procedure if you really need to, via a declare block.
- I don't recommend you use this too much unless if you know what
  you're doing. (Your code will start looking funny).

```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
   X : Integer := 2121;
begin
   declare
      Y : Integer := 12 + X;
   begin
      Put_Line(Y'Img);
   end;
end Main;
```

# Arrays (known size)

- Specifying arrays may be a little strange in Ada.
- You need to declare the type of array you want
- And then use it (I will take this potato chip, and EAT IT).

```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
   type Int_Array is array (Positive range 1 .. 10) of Integer;
   X : Int_Array;
begin
   X (1) := 1;
   X (112) := 2; -- this will raise, and you also get warnings
   -- gcc -c -gnata main.adb
   -- main.adb:7:07: warning: value not in range of subtype of "Standard.Integer" defined at line 3
   -- main.adb:7:07: warning: "Constraint_Error" will be raised at run time
end Main;
```

# Arrays (unknown size)

- You just need to pass the strange diamond.

```ada
   type Int_Array is array(Positive range <>) of Integer;
   Arr : Int_Array (1 .. 10);
```

# Arrays and Ranges

- What's the point of range?

```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
   type Int_Array is array(Positive range <>) of Integer;
   Arr : Int_Array (1 .. 10);
begin
   for I in Positive range Arr'Range loop
      -- index starts at 1
      Arr (I) := I;
   end loop;

   for I in Positive range Arr'Range loop
      declare
         X : Integer := Arr (I);
      begin
         Put_Line (X'Img);
      end;
   end loop;
end Main;
```

# Arrays and Strange, stRange Ranges

- Basically a quality of life, nice small language feature
- Ranges, indexing does not need to start from 1
- Can express richer bounds like this if need be

```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
   type Int_Array is array(Positive range <>) of Integer;
   Arr : Int_Array (5 .. 15);
begin
   for I in Positive range Arr'Range loop
      -- index starts at 1
      Arr (I) := I;
   end loop;

   for I in Positive range Arr'Range loop
      declare
         X : Integer := Arr (I);
      begin
         Put_Line (X'Img);
      end;
   end loop;
end Main;
```

# Record Types

- Can be thought of like C structs
- Not covered here, but there's derivations of records and things get
  very strange (see variadic record types).

# Example Record

```ada
procedure Main is
   type Something is
      record
         X : Integer;
         B : Boolean;
      end record;

   S : Something;
   Preset : Something := (X => 12, B => False);
begin
   S.X := 12;
   S.B := True;
end Main;
```

# Functions, Procedures

- Ada has functions and procedures
- Procedures return nothing
- Functions return some type
- Functions and procedures must be declared in the declarative part of
  the function or procedure
- (Like Pascal, and Rust, you can declare functions in your
  functions... oohhh sninny).

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
   Put_Line ("funcky: " & Val'Img);
end Main;
```

# Small Exercise: Functions

- Warmup
- Write a small function that adds two integers together.

# Small Exercise: Solution

```ada
with Ada.Text_IO; use Ada.Text_Io;
procedure Main is
   function Add (X : Integer; Y : Integer) return Integer is
   begin
      return X + Y;
   end Add;
   X : Integer := Add(1, 3);
begin
   Put_Line (X'Img);
end Main;
```

# Functions, Procedures: Ins and Outs (Explained)

- You can specify what kind of mutability is allowed to variables
  passed to functions or procedures.
- Think of this as a 'richer' pass by reference in C
- Prefix them with either or both of `in` and `out`.

# Functions, Procedures: Ins and Outs (Warnings)

- *in*: read only parameters

> main.adb:5:07: assignment to "in" mode parameter not allowed

- *out*: write to parameters (You can still use this as an *in out*,
  but the compiler will be whiny).

> main.adb:5:10: warning: "X" may be referenced before it has a value

- *in out*: value passed in is important to the function or procedure,
  and you can write to it directly.

> yolo

# Functions, Procedures: Ins and Outs (Code)

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

# Exercise (In Out): Question

Write a function that returns the result Z when it substracts X from
Y (which are both postive integers), and also returns a boolean
denoting whether the result is Even.

Hint: Modulo keyword is `mod`. The types for integers and booleans you
can use `Integer` and `Boolean`.

# Exercise (In Out): Solution

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

<!---
 ---- Concurrency
 ---->

# Exercise: DbC

- You have a record that contains a boolean and a number.
- Write a function that takes in a record.
- The function expects that the boolean is always true.
- The function guarantees that the number given back is always even.
- Call the function, and make the precondition blow up.
- How can you break the postcondition (think simple; the answer on how
  to do this was already given).

# Exercise: DbC Solution

- Solution could look something like

```ada
   type My_Rec is
     record
        B : Boolean;
        E : Integer;
     end record;

   function A (R : My_Rec) return Integer with
     Pre => R.B = True,
     Post => A'Result mod 2 = 0
   is begin
      return R.E;
   end A;

   R : My_Rec := (B => True, E => 2);
   BR : My_Rec := (B => False, E => 2);
   BR2 : My_Rec := (B => True, E => 3);
```

# Parallel Programming

- Ada was designed to have parallel programming in the core language.
- You can get this sort of thing by using 'Tasks'.
- 'Tasks' may seem a little strange to you.
- Won't go in much detail this talk

# Task Example (Spec)

- Task types are like records
- You first need to declare the task type

```ada
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
  task type A is
    entry Start;
    entry Stop;
  end A;
```

# Task Example (Body hit the floor)
- Your body should look something like this

```ada
  task body A is
    Max_Count : constant Integer := 100;
    Counter : Integer := 0;
  begin
    accept Start;
    loop
      exit when Counter >= Max_Count;
      Ada.Text_IO.Put_Line ("boop");
      Counter := Counter + 1;
      delay 0.003;
    end loop;
    accept Stop;
    Ada.Text_IO.Put_Line ("STOP");
  end;
```

# Task (instantiate, and run)

```ada
procedure Main is
  ...
   Task_A : A;
begin
   Task_A.start;
   Task_A.Stop;
end Main;
```

# Task (Output)

```nocode
[psyomn@mrbubbles]: tmp>$ ./main
...
boop
boop
boop
boop
boop
boop
boop
STOP
```

# Formal Specifications

- Ada has formal specifications built into the language (remember when
  I said that Ada was huge?)
- You can use a proving tool called gnatprove.
- Won't go over this, this presentation.

# Where to go from here, Resources

Some interesting points:

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
