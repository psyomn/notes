with Ada.Text_IO; use Ada.Text_IO;

-- User
with Reusable;
with Stack;

procedure Main is
  package Integer_Stack is
    new Stack (Integer);
  Int_S : Integer_Stack.Object := Integer_Stack.Create;
begin
  Reusable.Test;

  ---

  Int_S.Push (1);
  Int_S.Push (2);
  Int_S.Push (3);

  put_line (Integer'Image(Int_S.Pop));
  put_line (Integer'Image(Int_S.Pop));
  put_line (Integer'Image(Int_S.Pop));

  Int_S.Push (4);
  put_line (Integer'Image(Int_S.Pop));

end Main;

