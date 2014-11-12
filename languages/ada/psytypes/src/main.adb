with Ada.Text_IO; use Ada.text_io;

-- User
with Immutable_Test;
with Mutable_Test;

procedure Main is 
begin
  Mutable_Test.Test;
  Immutable_Test.Test;
end Main; 

