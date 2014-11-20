package Reusable is

  generic
    type T is private;

  procedure Swap
    (A : in out T;
     B : in out T);

  procedure Test;

end Reusable;
