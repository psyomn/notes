with Ada.Text_IO; use Ada.Text_IO;

package body Reusable is

  procedure Swap
    (A : in out T;
     B : in out T) is
     C : T := A;
  begin
    A := B;
    B := C;
  end Swap;

  procedure Test is

    procedure Swap_Integer is
      new Reusable.Swap (Integer);

    procedure Swap_Float is
      new Reusable.Swap (Float);

    A : Integer := 10;
    B : Integer := 13;
    C : Float   := 0.12;
    D : Float   := 2.22;

  begin
    put_line("A, B := "
      & Integer'Image(A) & ", "
      & Integer'Image(B));

    Swap_Integer (A, B);

    put_line("A, B := "
      & Integer'Image(A) & ", "
      & Integer'Image(B));

    --------

    put_line("C, D := "
      & Float'Image(C) & ", "
      & Float'Image(D));

    Swap_Float   (C, D);

    put_line("C, D := "
      & Float'Image(C) & ", "
      & Float'Image(D));
  end Test;

end Reusable;
