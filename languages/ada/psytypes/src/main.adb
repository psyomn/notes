with Ada.Text_IO; use Ada.text_io;

with Mutable_Test;

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
  i.put(Employee'size); new_line;
  new_line; 

  p("Size of the variant record as software guy object:");
  i.put(software'size);
  new_line;

  p("Size of the variant record as politician object:");
  i.put(politic'size);
  new_line;

  Mutable_Test.Test;

end Main; 

