with Ada.Text_IO; use Ada.text_io;

-- User
with
  Immutable_Test
, Mutable_Test
, Union_Test
, People
, Employee;

procedure Main is
begin
  Mutable_Test.Test;
  Immutable_Test.Test;
  Union_Test.Test;
  Employee.OOP_Test;
end Main;

