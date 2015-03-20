# Foreword

This document is written to help you obtain a more practical experience of some
of the opertions in OCL. This is mainly for understanding how the operations
work, and how they can be used in OCL, by comparing the OCL expressions using
Ruby Arrays. This is not a substitution to OCL. We are essentially playing
around with collections in this document, and not applying real constraints onto
anything. It would be possible to do something easilly however, like this, if
one would wish with the Ruby programming language. That is beyond the scope of
this document.

# Crash Course in Ruby

We will cover some basic things in Ruby, in case the reader is not already
familiar with the programming language. Everything in Ruby is an object. So
something that you could do and would be valid would be:

~~~~ruby
    10.times do |x|
      puts x
    end
~~~~

That will loop something 10 times. So yes, even numbers are treated as objects.
The 'x' inside the vertical bars will be the current element we're applying
things to; in this case it is the index of the loop. It will start off with 0,
1, 2, 3, and finally end up in 9. The function `puts` prints a line into the
terminal. If we run the above we get:

~~~~nocode
   0
   1
   2
   3
   4
   5
   6
   7
   8
   9
~~~~

To express arrays, we can do the following in Ruby:

~~~~ruby
    arr = [1,2,3]
~~~~

Notice that we are not specifying a type on the left hand side. We can assign
anything anywhere, and pass everything everywhere. We can also have different
types in the same array. Take a look at this:

~~~~ruby
    arr = [1,2,"potato", 12.31, :i_like_pets]
~~~~

This is legal, and totally fine with the interpreter. Now let's take a look at
iterators in ruby. To iterate, we could use indices, but we are given a language
construct that pales them into comparison:

~~~~ruby
    arr = [1,2,"potato", 12.31, :i_like_pets]
    arr.each do |element|
      puts element
    end
~~~~

The above is also legal - we can iterate over the array, regardless of element
types. You can read that as: "in *arr*, *do* for *each* *element*". The above
would give the following output:

~~~~ruby
    1
    2
    potato
    12.31
    i_like_pets
~~~~

Now let's look briefly at classes in Ruby. The following is the most minimal,
valid class:

~~~~ruby
    class Vampire
    end
~~~~

Let's add a name to the vampire. We need member variables. In ruby you use
something called `attr`, `attr\_accessor`, and `attr\_reader`- they make your
member variables, and generate your getters and setters.

