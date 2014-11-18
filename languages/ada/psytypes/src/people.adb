with Ada.Text_IO; use Ada.Text_IO;

package body People is 
  procedure p(S : String) renames Ada.Text_IO.Put_Line;

  procedure Indent is 
  begin
    put("  ");
  end Indent;

  procedure Put
    (This : Person) is 
  begin
    p("-- Employee");
    p(This.Name);
    p(This.Surname);
    indent; p(Positive'Image(This.Age));
    indent; p(Character'Image(This.Sex));
  end Put;

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

  function Get_Salary
    (This : Employee)
     return Float
  is
  begin 
    return This.Salary;
  end Get_Salary;

  procedure Put
    (This : Employee) is
    -- Case to Person, to call parent put
    P : Person := Person(This);
  begin
    P.Put;
    put_line(Float'Image(This.Salary));
  end Put;

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

end People;
