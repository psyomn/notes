% Minor notes on records in Ada (up to 2014)
% Simon Symeonidis

# Introduction

These are my notes for when I was looking into different records that you can
use in Ada. I found it a little confusing, and decided to write everything down
the way it would be easiest for me to personally understand. These notes mirror
the online book found on [wiki].

All the actual code is available here:

> [http://github.com/psyomn/architecture-notes/languages/ada/psytypes/](http://github.com/psyomn/architecture-notes/languages/ada/psytypes/)

The documentation is in the doc subdir:

> [http://github.com/psyomn/architecture-notes/languages/ada/psytypes/doc/](http://github.com/psyomn/architecture-notes/languages/ada/psytypes/doc/)

# Overall

Records are like structs in C. Exactly like C they do not contain behavior.  Ada
supports the following records:

- Basic Record
    - For storing basic records which can contain types such as `Integer`,
      `Float`, etc.

- Null Record
    - Used for placeholders, of if you want to define a base class.

- Discriminant Record
    - You have a parameterized record. The parameter that you specify for the
      record can affect record size; for example passing a parameter of
      `Positive` in order to regulate an array / string size.

- Variant Record (Mutable / Immutable)
    - Think of it as a _selective union_. Depending on how we want to use it,
      this structure adapts to the parameters we pass through. See more in the
      example.

- Union (2005)
    - Very similar to unions in C. From what the docs say in [wiki], this takes
      compatibility with C code in mind (ie: binding ada programs to c, or vice
      versa).

- Tagged Record (Class)
    - Is a record that later on can be used as a class.

## Basic Record

To define a record type:

~~~~ada
    type Employee is
      record
        id   : Positive;
        name : String (50);
        age  : Positive range 1 .. 200;
      end record;
~~~~

A record type is very much like a `C` structure. Unlike C structures, you can
use the typing system of Ada to enforce the above restrictions (eg: do not
allow ages that are over 200).


## Null Record

To define a null record:

~~~~ada
    type Empty_Record is
      record
        null;
      end record;
~~~~

Null records are used to [wiki]:

- Denote that eventually the programmer will fill the record in
- Provide the base class that is to be inherited later on.

According to [wiki], when you are using object orientation in Ada, the
convention is to define null records the following way:

~~~~ada
    type Person is null record;
~~~~

# Variant record

In `C` we are able to define unions like the following:

~~~~c
    #include <stdio.h>

    union uni
    {
      unsigned char c;
      short s;
      int i;
      double d;
    };

    int main()
    {
      union uni u;

      printf("sizeof union %d\n", sizeof(u));

      u.s = 1;

      printf("u.s = %d\n", u.s);

      u.i = 120000;

      printf("u.i = %d\n", u.i);
      printf("u.s = %d\n", u.s);

      return 0;
    }
~~~~

The declaration inside the union, which requires the maximum amount of bytes is
what is going to determine the size of the union. Then, the smaller variable
declarations will just use what they need.

Here, we define a variant record. Please notice that after employee, we specify
that we expect a _discriminator_. We do not set a default _discriminator_, and
because of this, Employee is an _immutable variant record_.

~~~~ada
    with Ada.Text_IO; use Ada.text_io;

    procedure Main is

      procedure p(S : String) renames Ada.Text_IO.Put_Line;
      package i is new Ada.Text_IO.Integer_IO (Integer);

      -- Options for the variant; both make a number of people angry ;o)
      type Option is (Software_Guy, Politician);

      -- Variant record example
      type Employee (Opts : Option) is
        record
          name    : String (1..50);
          surname : String (1..50);
          age     : positive;

          case Opts is
          when Software_Guy =>
            very_angry_userbase     : natural;
          when Politician =>
            angry_political_members : natural;
            angry_civilians         : natural;
          end case;
        end record;

      software : Employee (Software_Guy);
      politic  : Employee (Politician);
      postest  : Positive;
      nattest  : Natural;
    begin

      p("Size of the Employee variant record:");
      i.put(Employee'size);
      new_line;

      p("Size of the variant record as software guy object:");
      i.put(software'size);
      new_line;

      p("Size of the variant record as politician object:");
      i.put(politic'size);
      new_line;

    end Main;

~~~~

And the output is the following (number of bits) when testing against different
instantiations of the variant record:

~~~~nocode
Size of the Employee variant record:
        928

Size of the variant record as software guy object:
        896

Size of the variant record as politician object:
        928
~~~~

We notice that the run time object of the `software guy` is smaller than the
`politician` object, yet the structure of `Employee` yields the max.

# Mutable and Immutable Variant Records

For immutable variant records, you may take a look at the above example. In
order to define a variant record that is mutable, then you need to do the same
as in the `type Employee` part, but add a default value to the option. We will
demonstrate that using a new type 'Faceless' for the example.

Essentially this is what the mutable test would look like, as a specification:

~~~~ada
    package Mutable_Test is
      type Persona is (Likeable, Shady, Murderous);

      String_Min : Integer := 1;
      String_Max : Integer := 50;

      -- NOTE: You *NEED* to have a default option for mutable Faceless types to
      -- exist
      type Faceless (Current_Persona : Persona := Likeable) is
        record
        case Current_Persona is
        when Likeable =>
          Mood_Is_Happy : Boolean := True;

        when Shady =>
          Money : Natural := 10;
          Message : String(String_Min .. String_Max);

        when Murderous =>
          Secret_Phrase : String(String_Min .. String_Max);
          Response : String(String_Min .. String_Max);

        end case;
        end record;

      procedure Test;

      procedure Print
        (Face : Faceless);

      -- This will alternate from likeable, to shady to muderous, and back to
      -- likable
      procedure Mutate
        (Face : in out Faceless);

    end Mutable_Test;
~~~~

The second gotcha is that when you declare a type 'Faceless' and you want it to
be _mutable_, then you do not give a default option in the declare block. We see
this in the Test procedure inside the package body of Mutable\_Test.

~~~~ada
    procedure Test is
      -- To make the variant record mutable, we must not define a discriminant
      face_changer : faceless;

      -- below is an example of a immutable variant record
      -- face_changer : faceless (Current_Persona => Likeable);
    begin
      for I in Integer range 1..10 loop
        Mutate(face_changer);
        Print(face_changer);
        Ada.Text_IO.New_Line;
      end loop;
    end Test;
~~~~

Finally for a full fledged example using the mutable variant records, we have
the following body:

~~~~ada
    with Ada.Text_IO;
    with ada.strings.fixed;

    package body Mutable_Test is

      procedure p(S : String) renames Ada.Text_IO.Put_Line;

      procedure Test is
        -- To make the variant record mutable, we must not define a discriminant
        face_changer : faceless;

        -- below is an example of a immutable variant record
        -- face_changer : faceless (Current_Persona => Likeable);
      begin
        for I in Integer range 1..10 loop
          Mutate(face_changer);
          Print(face_changer);
          Ada.Text_IO.New_Line;
        end loop;
      end Test;

      procedure Print
        (Face : Faceless) is
      begin
        p(Persona'Image(face.current_persona));
        case face.current_persona is
        when likeable =>
          p("Is happy?");
          p(Boolean'Image(face.Mood_Is_Happy));

        when shady =>
          p("Money: ");
          p(Natural'Image(face.money));
          p(face.message);

        when murderous =>
          p("You notice a very odd fellow. You hear two things: ");
          p(face.secret_phrase);
          p(face.response);

        end case;
      end Print;

      procedure Mutate
        (Face : in out Faceless) is

        package ST renames Ada.Strings;

        -- Things someone says, depending on persona
        likeable_str  : String := "hello there stranger, wacha buyin?";
        shady_say_str : String := "valar morghulis";
        shady_res_str : String := "valar doaheris";

        fixed_message : String(String_Min .. String_Max) := (others => ' ');
        fixed_secret  : String(String_Min .. String_Max) := (others => ' ');
        fixed_response: String(String_Min .. String_Max) := (others => ' ');
      begin
        case face.current_persona is
        when likeable =>
          fixed_message(likeable_str'range) := likeable_str;

          face := (
            current_persona => shady,
            money           => 20,
            message         => fixed_message);

        when shady =>
          fixed_secret(shady_say_str'range)   := shady_say_str;
          fixed_response(shady_res_str'range) := shady_res_str;

          face := (
            current_persona => murderous,
            secret_phrase   => fixed_secret,
            response        => fixed_response);

        when murderous =>
          face := (
            current_persona => likeable,
            Mood_is_happy => True);

        when others => null;
        end case;
      end Mutate;

    end Mutable_Test;
~~~~

# Unions

Unions are defined the same way as mutable variant records. The difference is
that you add a `pragma` at the end of the definition, with the unions name.

~~~~ada
    type Faceless (P : Persona := Persona'First) is
      record
        -- ...
      end record;

    pragma Unchecked_Union (Faceless);
~~~~

You're not able to check the discriminant if you have a case block like the
following:

~~~~ada
    -- Checking discriminator will raise compilation error
    -- Note that this will not compile
    procedure Illegal(U : United) is
    begin
      case U.Discriminator is

      when One =>
        p("Union type one");
        p(Integer'Image(U.Basic));
        p(Float'Image(U.Potato));

      when Two =>
        p("Union type two");
        p(Integer'Image(U.Basic));
        p(Positive'Image(U.Yotato));
        p(Positive'Image(U.Motato));

      end case;
    end Put_United;
~~~~

There is an interesting writeup on the rules on how to use the above here [unio].

# Tagged Records

Tagged records are what other programming languages call classes [wiki]. We
demonstrate a very simple tagged record, that holds information about a person.

~~~~ada
  type Person is tagged
    record
      Name    : String(1..50);
      Surname : String(1..50);
      Age     : Positive;
      Sex     : Character;
    end record;
~~~~

The whole package would contain a few classes that would be related closely, if
inheritance were to come into play. This way we get the whole package in the
following manner, bundled along with its primitive [prim] operations

~~~~ada
    package People is

      type Person is tagged private;

      -- Print the person information on the terminal
      procedure Put_Person
        (This : Person);

      procedure Increase_Age
        (This : in out Person);

      function Get_Age
        (This : Person)
        return Positive;

      procedure OOP_Test;

    private
      type Person is tagged
        record
          Name    : String(1..50);
          Surname : String(1..50);
          Age     : Positive;
          Sex     : Character;
        end record;
    end People;
~~~~

At the above, you will notice private. This is to make sure that attributes of
the `Person` type are inaccessible in order to not break encapsulation [extn].

And the package body:

~~~~ada
    with Ada.Text_IO; use Ada.Text_IO;

    package body People is
      procedure p(S : String) renames Ada.Text_IO.Put_Line;

      procedure Indent is
      begin
        put("  ");
      end Indent;

      procedure Put_Person
        (This : Person) is
      begin
        p("------");
        p(This.Name);
        p(This.Surname);
        indent; p(Positive'Image(This.Age));
        indent; p(Character'Image(This.Sex));
      end Put_Person;

      procedure Increase_Age
        (This : in out Person) is
      begin
        This.Age := This.Age + 1;
      end Increase_Age;

      function Get_Age
        (This : Person)
        return Positive
      is
      begin
        return This.Age;
      end Get_Age;

      procedure OOP_Test is
        P : Person;
        name          : String                  := "Jon";
        surname       : String                  := "Doeson";
        fixed_name    : String(P.Name'Range)    := (others => ' ');
        fixed_surname : String(P.Surname'Range) := (others => ' ');
      begin
        fixed_name    (name'range)    := name;
        fixed_surname (surname'range) := surname;

        P := (
          Name    => fixed_name,
          Surname => fixed_surname,
          age     => 32,
          sex => 'm');

        Put_Person(P);
      end OOP_Test;

    end People;
~~~~

## Extending Tagged Records

Now for a simple example of inheritance, we will be extending the tagged record.
We create an employee. The employee shall have an extra attribute `Salary`.
First we declare the type as a private type, and then declare the full type
inside the private section of the package:

~~~~ada
    package People is
      -- ...
      type Employee is new Person with private;
      -- ...
    private
      type Employee is new Person with
        record
          Salary : Float;
        end record;
    end People;
~~~~

### Overriding

To override, we just redefine the function for the subclass / extended type. For
this example, we will be adding a `Put` procedure that will print all the
information of the `Employee`:

~~~~ada
    procedure Put
      (This : Employee);
~~~~

The above is sufficient to override a method. Optionally you may add the
`overriding` keyword to the method to be overriden (think in terms of `virtual`
with inherited C++ classes).

~~~~ada
    overriding
    procedure Put
      (This : Person);
~~~~

Again, the keyword is optional. The proper method will run either way. Next let
us look into the implementation of `Put`:

~~~~ada
    procedure Put
      (This : Employee) is
      -- Case to Person, to call parent put
      P : Person := Person(This);
    begin
      P.Put;
      put_line(Float'Image(This.Salary));
    end Put;
~~~~

I can cast the `Employee` object into a `Person` type, and invoke the
`Person.Put` procedure. This way I am able to print whatever the attributes of
the person are, and then print the actual salary of the person. This is for a
mental note on how to cast types - you might not want to do things this way on
the long run.

Finally the `OOP_Test` method is changed in the following manner:

~~~~ada
    procedure OOP_Test is
      P : Person;
      E : Employee;

      name          : String                  := "Jon";
      surname       : String                  := "Doeson";
      fixed_name    : String(P.Name'Range)    := (others => ' ');
      fixed_surname : String(P.Surname'Range) := (others => ' ');

      e_name          : String                  := "Mary";
      e_surname       : String                  := "Maryson";
      e_fixed_name    : String(E.Name'Range)    := (others => ' ');
      e_fixed_surname : String(E.Surname'Range) := (others => ' ');
    begin
      fixed_name      (name'range)            := name;
      fixed_surname   (surname'range)         := surname;

      e_fixed_name    (e_name'range)          := e_name;
      e_fixed_surname (e_surname'range) := e_surname;

      P := (
        Name    => fixed_name,
        Surname => fixed_surname,
        age     => 32,
        sex     => 'm');

      E := (
        Name    => e_fixed_name,
        Surname => e_fixed_surname,
        age     => 92,
        Sex     => 'f',
        Salary  => 92.3);

      P.Put;
      put_line("Increment age ...");
      P.Increase_Age;
      P.Put;

      E.Put;
      for I in Integer range 1 .. 4 loop
        E.Increase_Age;
      end loop;

      E.Put;
    end OOP_Test;
~~~~

And some sample output of this particular procedure

~~~~nocode
    -- Employee
    Jon
    Doeson
       32
      'm'
    Increment age ...
    -- Employee
    Jon
    Doeson
       33
      'm'
    -- Employee
    Mary
    Maryson
       92
      'f'
     9.23000E+01
    -- Employee
    Mary
    Maryson
       96
      'f'
     9.23000E+01
~~~~

### Minor note on Overriding

If you have something like the following as a base class:

~~~~ada
    package People is
      type Person is tagged private;
      procedure Put
        (This : Person);
    private
      type Person is
        record
          Age : Integer;
        end record;
    end People;
~~~~

And then we extend it as Employee:

~~~~ada
    package Employees is
      type Employee is new People.Person with private;
      -- Does not compile
      overriding
      procedure Put
        (This : Employee);
    private
      type Employee is new Person with
        record
          Salary : Float;
        end record;
    package Employees;
~~~~

Using the _keyword_ `overriding` in this case will cause a compilation error.
Overriding will, however work normally. On further investigation, it seems the
convention of defining classes to use in Ada as seen in [extn] is to define
classes in the following manner.

~~~~ada
    package Person is
      type Object is tagged record private;
      procedure Put
        (This : Object);
    private
      -- ...
    end Person;
~~~~

And then define the other package this way:

~~~~ada
    package Employee is
      type Object is new Person.Object with private;
      overriding
      procedure Put
        (This : Object);
    private
      -- ...
    end Employee;
~~~~

This will compile without a problem. Overriding is optional however, so we won't
see any changes in behavior.

# OOP the proper way

Refactoring the minor project to be like the examples found in [extn], we get
the code in the following listings. I will be only showing the employee and
person ada body and specification files.

__employee.ads__

~~~~ada
    with People; use People;

    package Employee is
      -- Extend Person, and Employee is private
      type Object is new People.Object with private;

      procedure Set_Salary
        (This   : in out Employee.Object;
         Salary : Float);

      function Get_Salary
        (This : Employee.Object)
         return Float;

      overriding
      procedure Put
        (This : Object);

      procedure OOP_Test;

    private

      -- Employee has all the info of person, but it will also have a float
      -- value denoting the salary of person
      type Object is new People.Object with
        record
          Salary : Float;
        end record;

    end Employee;
~~~~

__people.ads__

~~~~ada
    package People is

      type Object is tagged private;

      -- Print the person information on the terminal
      procedure Put
        (This : Object);

      procedure Increase_Age
        (This : in out Object);

      procedure Set_Age
        (This : in out Object;
         Age  : Positive);

      procedure Set_Name
        (This : in out Object;
         Name : String);

      procedure Set_Surname
        (This    : in out Object;
         Surname : String);

      procedure Set_Male
        (This : in out Object);

      procedure Set_Female
        (This : in out Object);

      function Get_Age
        (This : Object)
         return Positive;

    private

      type Object is tagged
        record
          Name    : String(1..50);
          Surname : String(1..50);
          Age     : Positive;
          Sex     : Character;
        end record;

    end People;
~~~~

__employee.adb__

~~~~ada
  with
    Ada.Text_IO
  , People;

  use
    People
  , Ada.Text_IO;

  package body Employee is

    function Get_Salary
      (This : Employee.Object)
       return Float is
    begin
      return This.Salary;
    end Get_Salary;

    procedure Set_Salary
      (This   : in out Employee.Object;
       Salary : Float ) is
    begin
      This.Salary := Salary;
    end Set_Salary;

    procedure Put
      (This : Object) is
      -- Case to Person, to call parent put
      P : People.Object := People.Object (This);
    begin
      P.Put;
      put_line(Float'Image(This.Salary));
    end Put;

    procedure OOP_Test is
      P : People.Object;
      E : Employee.Object;
    begin
      P.Set_Name("Jon");
      P.Set_Surname("Doeson");
      P.Set_Age(32);
      P.Set_Male;
      P.Put;

      E.Set_Name("Mary");
      E.Set_Surname("Maryson");
      E.Set_Age(23);
      E.Set_Female;
      E.Set_Salary(9000.12);
      E.Put;

      for I in Integer range 1 .. 4 loop
        E.Increase_Age;
      end loop;

      E.Put;
    end OOP_Test;

  end Employee;
~~~~

__people.adb__

~~~~ada
    with Ada.Text_IO; use Ada.Text_IO;

    package body People is

      procedure p(S : String) renames Ada.Text_IO.Put_Line;

      procedure Indent is
      begin
        put("  ");
      end Indent;

      procedure Put
        (This : Object) is
      begin
        p("-- Employee");
        p(This.Name);
        p(This.Surname);
        indent; p(Positive'Image(This.Age));
        indent; p(Character'Image(This.Sex));
      end Put;

      procedure Increase_Age
        (This : in out Object) is
      begin
        This.Age := This.Age + 1;
      end Increase_Age;

      -- Copy a string to a target. If the source is bigger than target, it will be
      -- cut off at target's max size.
      -- @param Source is what we want to copy
      -- @param Target is where we want to copy the string into
      procedure Copy_String
        (Source : String;
         Target : in out String) is
        Min_Max_Size : Integer;
      begin
        Target (Target'Range) := (others => ' ');

        -- We want to use the object's max string size, if source exceeds it. If
        -- source is smaller, then we copy up to that.
        Min_Max_Size := (if Source'Last >= Target'Last then Target'Last else Source'Last);
        Target (Target'First .. Min_Max_Size) := Source (Source'First .. Min_Max_Size);
      end Copy_String;

      procedure Set_Age
        (This : in out Object;
         Age  : Positive) is
      begin
        This.Age := Age;
      end Set_Age;

      procedure Set_Name
        (This : in out Object;
         Name : String) is
      begin
        Copy_String(Name, This.Name);
      end Set_Name;

      procedure Set_Surname
        (This    : in out Object;
         Surname : String) is
      begin
        Copy_String(Surname, This.Surname);
      end Set_Surname;

      procedure Set_Male
        (This : in out Object) is
      begin
        This.Sex := 'm';
      end Set_Male;

      procedure Set_Female
        (This : in out Object) is
      begin
        This.Sex := 'f';
      end Set_Female;

      function Get_Age
        (This : Object)
        return Positive is
      begin
        return This.Age;
      end Get_Age;

    end People;
~~~~

# References

- \[wiki\] [http://en.wikibooks.org/wiki/Ada\_Programming/Types/record](http://en.wikibooks.org/wiki/Ada_Programming/Types/record)
- \[disc\] [http://archive.adaic.com/standards/83rat/html/ratl-04-07.html#4.7.2](http://archive.adaic.com/standards/83rat/html/ratl-04-07.html#4.7.2)
- \[unio\] [https://gcc.gnu.org/onlinedocs/gcc-3.4.5/gnat\_rm/Pragma-Unchecked\_005fUnion.html](https://gcc.gnu.org/onlinedocs/gcc-3.4.5/gnat\_rm/Pragma-Unchecked\_005fUnion.html)
- \[prim\] [http://www.adaic.org/resources/add\_content/docs/95style/html/sec\_9/9-3-1.html](http://www.adaic.org/resources/add\_content/docs/95style/html/sec\_9/9-3-1.html)
- \[extn\] [http://en.wikibooks.org/wiki/Ada\_Programming/Object\_Orientation#Type\_extensions](http://en.wikibooks.org/wiki/Ada\_Programming/Object\_Orientation#Type\_extensions)

