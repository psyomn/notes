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
