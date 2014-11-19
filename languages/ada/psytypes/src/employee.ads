with People; use People;

package Employee is
  -- Extend Person, and Employee is private
  type Object is new People.Object with private;

  procedure Set_Salary
    (This   : in out Employee.Object;
     Salary : Float);

  function Get_Salary
    (This : Employee.Object)
     return Float;

  overriding
  procedure Put
    (This : Object);

  procedure OOP_Test;

private

  -- Employee has all the info of person, but it will also have a float value
  -- denoting the salary of person
  type Object is new People.Object with
    record
      Salary : Float;
    end record;

end Employee;
