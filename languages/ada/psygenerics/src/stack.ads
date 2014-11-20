generic
  type T is private;
package Stack is

  type Object is tagged private;

  procedure Push
    (This    : in out Object;
     Element : T);

  function Pop
    (This : in out Object)
     return T;

  function Create
    return Object;

  procedure Initialize
    (This : in out Object);

private

  type T_Array is array (1..50) of T;

  type Object is tagged
    record
      Data  : T_Array;
      Index : Positive;
    end record;

end Stack;
