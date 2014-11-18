
package People is 

  type Person is tagged private;

  -- Extend Person, and Employee is private
  type Employee is new Person with private;

  -- Print the person information on the terminal
  procedure Put
    (This : Person);

  procedure Increase_Age
    (This : in out Person);

  function Get_Age
    (This : Person)
    return Positive;

  procedure OOP_Test;

  --
  -- And extending person
  --

  function Get_Salary
    (This : Employee)
     return Float;

  procedure Put
    (This : Employee);

private
  type Person is tagged
    record 
      Name    : String(1..50);
      Surname : String(1..50); 
      Age     : Positive;
      Sex     : Character;
    end record;

  -- Employee has all the info of person, but it will also have a float value
  -- denoting the salary of person
  type Employee is new Person with
    record 
      Salary : Float;
    end record;
end People;
