package People is

  type Object is tagged private;

  -- Print the person information on the terminal
  procedure Put
    (This : Object);

  procedure Increase_Age
    (This : in out Object);

  procedure Set_Age
    (This : in out Object;
     Age  : Positive);

  procedure Set_Name
    (This : in out Object;
     Name : String);

  procedure Set_Surname
    (This    : in out Object;
     Surname : String);

  procedure Set_Male
    (This : in out Object);

  procedure Set_Female
    (This : in out Object);

  function Get_Age
    (This : Object)
     return Positive;

private

  type Object is tagged
    record
      Name    : String(1..50);
      Surname : String(1..50);
      Age     : Positive;
      Sex     : Character;
    end record;

end People;
