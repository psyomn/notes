with Ada.Text_IO; use Ada.Text_IO;

package body People is

  procedure p(S : String) renames Ada.Text_IO.Put_Line;

  procedure Indent is
  begin
    put("  ");
  end Indent;

  procedure Put
    (This : Object) is
  begin
    p("-- Employee");
    p(This.Name);
    p(This.Surname);
    indent; p(Positive'Image(This.Age));
    indent; p(Character'Image(This.Sex));
  end Put;

  procedure Increase_Age
    (This : in out Object) is
  begin
    This.Age := This.Age + 1;
  end Increase_Age;

  -- Copy a string to a target. If the source is bigger than target, it will be
  -- cut off at target's max size.
  -- @param Source is what we want to copy
  -- @param Target is where we want to copy the string into
  procedure Copy_String
    (Source : String;
     Target : in out String) is
    Min_Max_Size : Integer;
  begin
    Target (Target'Range) := (others => ' ');

    -- We want to use the object's max string size, if source exceeds it. If
    -- source is smaller, then we copy up to that.
    Min_Max_Size := (if Source'Last >= Target'Last then Target'Last else Source'Last);
    Target (Target'First .. Min_Max_Size) := Source (Source'First .. Min_Max_Size);
  end Copy_String;

  procedure Set_Age
    (This : in out Object;
     Age  : Positive) is
  begin
    This.Age := Age;
  end Set_Age;

  procedure Set_Name
    (This : in out Object;
     Name : String) is
  begin
    Copy_String(Name, This.Name);
  end Set_Name;

  procedure Set_Surname
    (This    : in out Object;
     Surname : String) is
  begin
    Copy_String(Surname, This.Surname);
  end Set_Surname;

  procedure Set_Male
    (This : in out Object) is
  begin
    This.Sex := 'm';
  end Set_Male;

  procedure Set_Female
    (This : in out Object) is
  begin
    This.Sex := 'f';
  end Set_Female;

  function Get_Age
    (This : Object)
    return Positive is
  begin
    return This.Age;
  end Get_Age;

end People;
