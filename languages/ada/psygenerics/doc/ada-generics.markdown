% Generics in Ada
% Simon Symeonidis
% Thu Nov 20 00:54:40 EST 2014

# Introduction

Minor notes on generics in Ada.

### Defining Generic Operations

Reading up on [gene], to define operations that are generic, by themselves (ie
not requiring to declare the whole package as generic), we can do the following:

__reusable.ads__

~~~~ada
    package Reusable is

      generic
        type T is private;

      procedure Swap
        (A : in out T;
         B : in out T);

      procedure Test;

    end Reusable;
~~~~

And now we implement the body of `Swap`. This is the common `swap` that
exchanges the values of two variables.

__reusable.adb__

~~~~ada
    procedure Swap
      (A : in out T;
       B : in out T) is
       C : T := A;
    begin
      A := B;
      B := C;
    end Swap;
~~~~

To call it, we just need to just do an extra step. We need to define that we
want to use this generic implementation, for a specific type. In other words
we'll be creating a `new` version of `Swap` for a particular `type`.

__main.adb__

~~~~ada
    procedure Swap_Integer is
      new Reusable.Swap (Integer);

    procedure Swap_Float is
      new Reusable.Swap (Float);
~~~~

So the generic implementation can be used to swap floats, and integers now. The
full example is as follows:

__reusable.adb__

~~~~ada
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
~~~~

# Generic OOP

It's the same idea as the above. However we need to define a generic clause
outside the package specification. This is where we define:

- Our generic element
- Other values (for example a max size for a stack) [wiki-gene]

## Define the Specification

Notice the generic at the top. Other than that, the rest is pretty standard OOP
in Ada.

__stack.ads__

~~~~ada
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
~~~~

Again, nothing too surprising here. For simplicity, I did not make it possible
for the stack to be of variant, bounded size. If you wanted to do this, a good
example is given in [gene-wiki], where the extra value of stack size is added at
the top of the specification, within the generic clause.

__stack.adb__

~~~~ada
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
~~~~

And finally to actually use this we do the following:

__main.adb__

~~~~ada
    with Ada.Text_IO; use Ada.Text_IO;
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
~~~~

# References

- \[gene\] [http://en.wikibooks.org/wiki/Ada\_Programming/Generics](http://en.wikibooks.org/wiki/Ada_Programming/Generics)
- \[wiki-gene\] [http://en.wikipedia.org/wiki/Generic_programming#Generics\_in\_Ada](http://en.wikipedia.org/wiki/Generic_programming#Generics_in_Ada)
