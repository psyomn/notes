% Minor notes on records in Ada (up to 2014)
% Simon Symeonidis

# Simple Record example 

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
    - Think of it as a union. Depending on how we want to use it, this structure
      adapts to the parameters we pass through. See more in the example.

- Union (2005)
    - 

- Tagged Record (Class)
    -

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

Here, we define a variant record. 

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

And the output is the following (number of bits):

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


# Using Records

# References

- [wiki] http://en.wikibooks.org/wiki/Ada\_Programming/Types/record

