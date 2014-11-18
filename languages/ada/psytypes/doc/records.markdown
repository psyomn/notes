% Minor notes on records in Ada (up to 2014)
% Simon Symeonidis

# Introduction

These are my notes for when I was looking into different records that you can
use in Ada. I found it a little confusing, and decided to write everything down
the way it would be easiest for me to personally understand. These notes mirror
the online book found on [wiki].

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



# References

- [wiki] http://en.wikibooks.org/wiki/Ada\_Programming/Types/record
- [disc] http://archive.adaic.com/standards/83rat/html/ratl-04-07.html#4.7.2
  (Good writeup on records, etc).
- [unio] https://gcc.gnu.org/onlinedocs/gcc-3.4.5/gnat\_rm/Pragma-Unchecked\_005fUnion.html
