package body Stack is

  procedure Push
    (This    : in out Object;
     Element : T) is
  begin
    This.Data(This.Index) := Element;
    This.Index := This.Index + 1;
  end Push;

  function Pop
    (This : in out Object)
     return T is
    New_Index : Integer := This.Index - 1;
    Element   : T := This.Data(New_Index);
  begin
    This.Index := New_Index;
    return Element;
  end Pop;

  function Create
    return Object is
    S : Stack.Object;
  begin
    S.Initialize;
    return S;
  end Create;

  procedure Initialize
    (This : in out Object) is
  begin
    This.Index := 1;
  end Initialize;

end Stack;
