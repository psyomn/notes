with Ada.Text_IO; use Ada.Text_IO;

-- Test with immutable variant records
package body Immutable_Test is 

  procedure Test is
    procedure p(S : String) renames Ada.Text_IO.Put_Line;
    package i is new Ada.Text_IO.Integer_IO (Integer);

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
  end Test;

end Immutable_Test;
