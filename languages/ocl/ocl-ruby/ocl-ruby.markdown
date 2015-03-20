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

Take a note that we can use operators such as `+` or `-` between arrays. For
example, if we use the `+` sign to add two arrays, we concatenate the second
array to the first array. If we use the `-` sign, we remove from the first
array, the elements that occur in the second array.

~~~~ruby
    a = [1,2,3,4,5]
    b = [1,4]

    p a + b # prints: [1, 2, 3, 4, 5, 1, 4]
    p a - b # prints: [2, 3, 5]
~~~~

Now let's look briefly at classes in Ruby. The following is the most minimal,
valid class:

~~~~ruby
    class Vampire
    end
~~~~

Let's add a name to the vampire. We need member variables. In Ruby you use
something called `attr`, `attr_accessor`, and `attr_reader`- they make your
member variables, and generate your getters and setters. There exists alternate
methods of declaring member variables, but for this document, we may stick with
the aforementioned. We will be using `attr_accessor`, for it allows us to get
the value and set the value of a member variable (think of it as `public`
visibility in Java).

~~~~ruby
    class Vampire
      attr_accessor :name
    end
~~~~

Now we can set names to the `Vampire`. We first need to instantiate the class.
If you have a class definition, then you can instantiate objects of the class
using the `new` keyword as an operation to the class (think of it as a factory
method):

~~~~ruby
    class Vampire
      attr_accessor :name
    end

    drac = Vampire.new
    drac.name = "Dracula"

    puts drac.name
~~~~

Now, let's define methods for the vampire. The vampire wants to hide its real
name, but offer it's secret to the ones who pay attention. In other words,
Alucard, is actually Dracula spelled backwards. Vampires like doing this, and we
can generalize this in a function definition. We want to reverse the string and
capitalize it:

~~~~ruby
    class Vampire
      def hide_name
        @name.reverse.capitalize
      end
      attr_accessor :name
    end

    drac = Vampire.new
    drac.name = "Dracula"

    puts drac.name
    puts drac.hide_name
~~~~

Now a final observation. We will take a brief look into metaprogramming. In Ruby
we are able to do a lot of nice (or evil) things during the runtime. We can
query a class about it's instance methods:

~~~~ruby
    class Vampire
      def hide_name
        @name.reverse.capitalize
      end
      attr_accessor :name
    end

    p Vampire.instance_methods - Object.instance_methods
~~~~

> **Quicknote**: _What is 'p'?_. There's two main printing functions in Ruby.
> One is `puts` and the other is `p`. The `p` function is to print things in the
> 'rawest' form. For example puts `"potato"` would print `'potato'`. p `"potato"`,
> would print `'"potato"'`, including the inverted commas, hinting that what is
> printed is a string. Another example is puts `:potato` versus p `:potato.` In this
> case the first prints `'potato'` but the second will print `':potato'`, showing
> clearly that `:potato` is indeed a symbol. You usually use 'p' for debugging, or
> in our case, we want to show exactly what exists in the array.

You might notice the `Object.instance_methods` being subtracted from the
`Vampire`'s instance methods. This is to omit the methods inherited from the
`Object` superclass (which is inherited by default by any class in Ruby, exactly
like `Object` in Java). Effectively this gives us a list of instance methods,
only owned by `Vampire`. And we can return this information in the runtime.

We could also do another query. If we have an instance of an object, then we
could get it's class name:

~~~~ruby
    class Vampire
      def hide_name
        @name.reverse.capitalize
      end
      attr_accessor :name
    end

    drac = Vampire.new
    drac.name = "Dracula"

    puts drac.class.name
~~~~

So now you know about basic reflection, iteration, basic control structures, and
classes in Ruby. There is much to learn, but this will suffice for our brief
comparison to OCL.

# Comparing OCL operations with Ruby Array methods

Since arrays in Ruby have some similar operations to OCL, we can make some
comparisons which may give some practical experience to the reader.

## Select

Let's look at a simple `Ruby` example before we proceed. Let's say we have the
following array with numbers:

~~~~ruby
    arr = [11, 4, 0, 21, 1, 13, 24, 21, 17,
            6, 21, 9, 4, 29, 11, 9, 2, 4, 5, 8]
~~~~

We want to get all the even numbers. To do this we test against a modulo of 2,
and check the remainder. If the remainder is 0, then it is indeed an even
number. Essentially this is our predicate; the boolean expression we want to
test against each number in the list. If this expression yields true, then that
element is desired in the new collection.

Recall `select`:
- it requires its input to be some collection L
- it requires a predicate to test against each element E in collection L
- as output, it provides a new collection L2, which contains each element E,
  which satisfied the predicate.

~~~~ruby
    arr = [11, 4, 0, 21, 1, 13, 24, 21, 17,
            6, 21, 9, 4, 29, 11, 9, 2, 4, 5, 8]

    p arr.select{|e| e % 2 == 0}

    # Output
    # [4, 0, 24, 6, 4, 2, 4, 8]
~~~~

This is quite similar to the OCL expression. The only difference is that we are
using curly braces, to insert our predicate (this is mainly a language thing -
you are essentially passing a lambda which yields bool).

Very similarly to OCL, there exists `reject` in Ruby's Array API. If we were to
reject the same predicate, then we would end up with the numbers which are odd.

~~~~ruby
    arr = [11, 4, 0, 21, 1, 13, 24, 21, 17,
            6, 21, 9, 4, 29, 11, 9, 2, 4, 5, 8]

    p arr.reject{|e| e % 2 == 0}

    # Output
    # [11, 21, 1, 13, 21, 17, 21, 9, 29, 11, 9, 5]
~~~~

In OCL we may have some constraint expressed in the following way:

~~~~python
    class Person
      uint age;

    context Person
      inv: self.allInstances() -> select(e| e.age > 18) = 12
~~~~

Let's express something similar in Ruby. We will generate 20 people with random
ages, and apply select filters on the list of objects. The array consists of
`Person` objects. Therefore, we need to iterate through each object, and call
its accessors (in this case _age_) in order to retrieve the particular age, and
make a comparison (you can make an arithmetic comparison between an object, and
a number: person\_obj < 12 would make no sense in the context of OCL).

Let's take a look at an example that requires us to:

1. Get all people over the age of 80
2. Get all people between the ages of 50 and 60 inclusive
3. Get all people between the ages of 50 and 60 inclusive, and who's ages are
   even.

~~~~ruby
    class Person
      def initialize(age)
        @age = age
      end

      def inspect
        "<Person aged #{@age}>"
      end
      attr_accessor :age
    end

    # Randomly generate 20 people with ages. This will give you an array of size 20,
    # populated with Person objects, set with randomly generated ages.
    people = ([Proc.new{Person.new(rand(18..90))}] * 20).map &:call

    # The 20 randomly generated people
    puts "All the people"
    p people
    puts

    puts "People over the age of 80"
    print "  "
    p people.select{|e| e.age > 80}
    puts

    puts "People between the ages of 50 and 60 (inclusive)"
    print "  "
    p people.select{|e| e.age >= 50 && e.age <= 60}
    puts

    puts "People between 50, 60, and div by 2"
    p people.select{|e| e.age >= 50 && e.age <= 60 && e.age % 2 == 0 }
    puts
~~~~

Sample output is as follows:

~~~~nocode
    All the people
        [<Person aged 62>, <Person aged 35>, <Person aged 85>,
         <Person aged 87>, <Person aged 34>, <Person aged 27>,
         <Person aged 85>, <Person aged 40>, <Person aged 53>,
         <Person aged 82>, <Person aged 48>, <Person aged 28>,
         <Person aged 43>, <Person aged 21>, <Person aged 63>,
         <Person aged 30>, <Person aged 69>, <Person aged 45>,
         <Person aged 87>, <Person aged 34>]

    People over the age of 80
        [<Person aged 85>, <Person aged 87>, <Person aged 85>,
         <Person aged 82>, <Person aged 87>]

    People between the ages of 50 and 60 (inclusive)
        [<Person aged 53>]

    People between 50, 60, and div by 2
        []
~~~~

Here's some more sample output (that actually has a person who satisfies the
3rd constraint):

~~~~nocode
    All the people
        [<Person aged 70>, <Person aged 47>, <Person aged 74>,
         <Person aged 89>, <Person aged 51>, <Person aged 77>,
         <Person aged 84>, <Person aged 46>, <Person aged 31>,
         <Person aged 42>, <Person aged 72>, <Person aged 66>,
         <Person aged 22>, <Person aged 21>, <Person aged 85>,
         <Person aged 62>, <Person aged 54>, <Person aged 38>,
         <Person aged 78>, <Person aged 42>]

    People over the age of 80
        [<Person aged 89>, <Person aged 84>, <Person aged 85>]

    People between the ages of 50 and 60 (inclusive)
        [<Person aged 51>, <Person aged 54>]

    People between 50, 60, and div by 2
        [<Person aged 54>]
~~~~

> **Quicknote**: This is not important for OCL, but if you're wondering what
> `people = ([Proc.new{Person.new(rand(18..90))}] * 20).map &:call` is actually
> doing, the short answer is that it is instantiating 20 Person objects, and
> assigning randomized ages. The long answer: multiplication with an array means
> "copy the value n times"; so `[1] * 10` would yield an array with 10 intergers
> of value '1'. `Proc` allows us to create objects which contain chunks of code.
> Since these are objects, and contain code, we can store them somewhere, and
> perform operations on them as if they were plain objects. They have a method
> called `call`, which executes the code they contain. So initially we create an
> array containing 20 `Proc`s with the content being the instantiation of
> Person, with a random age. When we get this array, we tell each object to
> perform the `call` method and instantiate, via the map method (so we're
> mapping the `call` operation to each object). This gives us the array of 20
> randomized people, with only a few expressions on a line.

# Collect

Collect will always yield in Ruby, an Array of the same size of the collection
it is applying this method on. If you have an array of values `[1,2,3]`, then
you will get as a result, after applying `collect` an array of size 3. On the
other hand `select` does not have a guaranteed size - the size of the resulting
collection will always depend on the predicate you provide.

Here's a demo to show, how to misuse collect, and why you should use select
instead, if you want to get the elements satisfied by the predicate:

~~~~ruby
    arr = [11, 4, 0, 21, 1, 13, 24, 21, 17, 6,
           21, 9, 4, 29, 11, 9, 2, 4, 5, 8]

    p arr.collect{|e| e % 2 == 0}
    # output
    # [false, true, true, false, false, false, true,
    #  false, false, true, false, false, true, false,
    #  false, false, true, true, false, true]
~~~~

In the case of Ruby, collect will make a collection, the same size as the one
provided, with whatever evaluates inside the collect part. So essentially, the
collect operation in contrast to the select operation will make a collection out
of anything that it evaluates within its body (in this case `e % 2 == 0`).

In other words, it would be definitely legal to express with a collect, that we
want all the elements of the previous array, but incremented by one. We can
achieve this with the following code snippet:

~~~~ruby
    arr = [1,2,3,4,5]
    p arr.collect{|e| e + 1}
    # output
    # [2, 3, 4, 5, 6]
~~~~

In other words, we can perform any operation in the collect body, and that will
be 'collected' in the resulting array. And exactly for that reason, it is
perfectly normal to call either class member variables, or methods, and collect
the results in the resulting array.

Take the following example. We have some people, and we make an array of them.
On this array we can perform a `collect` operation, and return all the ages of
each object. To do this, we call the `age` attribute, an that will yield the age
value, which in turn is added to the resulting collection. We can also see that
we can call a method `age_rage`, which depending on the age of the person,
returns a string about how angry they are (note: the last statement evaluated in
ruby, is what a code block yields, so you don't need to use a return statement
this way - essentially in `age_rage`, depending on the evaluation of the age,
the appropriate string is returned).

~~~~ruby
    class Person
      def initialize(age)
        @age = age
      end

      def age_rage
        case @age
        when 12     then "life is nice"
        when 13..34 then "im older and angry"
        when 35..50 then "mgr gr gr"
        else "I AM FURIOUS! WARGAGLBAGL!"
        end
      end

      attr_accessor :age
    end

    p1 = Person.new(12)
    p2 = Person.new(32)
    p3 = Person.new(42)
    p4 = Person.new(74)

    arr = [p1, p2, p3, p4]

    puts "The collection of ages: "
    p arr.collect{|e| e.age}
    puts

    puts "Anger depending on age"
    p arr.collect{|e| e.age_rage}
    puts

    # The collection of ages:
    # [12, 32, 42, 74]
    #
    # Anger depending on age
    # ["life is nice", "im older and angry",
    #  "mgr gr gr", "I AM FURIOUS! WARGAGLBAGL!"]
~~~~

# Combining Select, and Collect

Let's take a look at an example where we have a list of people, and we want to
get their ages, and only return the ages which are divisible by 2.

~~~~ruby
    class Person
      def initialize(age); @age = age end
      attr_accessor :age
    end

    arr = [Person.new(10), Person.new(32), Person.new(33), Person.new(43)]

    p arr.collect{|e| e.age}.select{|e| e % 2 == 0}
    # output: [10, 32]
~~~~

# Many classes in Array

In OCL, we have the ability to check kind/type either with the operations
'oclIsKindOf', and 'oclIsTypeOf', or get the type directly from the instantiated
object, via the member variable 'oclType' (you can assume that in the context of
OCL, these operations and member variable have been added automatically for any
class). In Ruby we have some metaprogramming abilities, where we can express
some OCL constraints. Let us have a collection, which contains different types.
Using `select` we can pick out what is what, and count it. You can observe it,
in the following code snippet:

~~~~ruby
    class Vampire
    end

    class Person
    end

    class Cat
    end

    class Dog
    end

    vamp1 = Vampire.new
    vamp2 = Vampire.new
    vamp3 = Vampire.new

    pers1 = Person.new
    pers2 = Person.new
    pers3 = Person.new

    cat1 = Cat.new
    cat2 = Cat.new

    dog1 = Dog.new
    dog2 = Dog.new

    # An array that contains all the above
    mixed_a = [
      vamp1, vamp2, vamp3, pers1,
      pers2, pers3, cat1, cat2,
      dog1, dog2]

    # How many dogs exist in the array?
    puts mixed_a.select{|e| e.class.name == "Dog"}.size

    # How many cats exist in the array?
    puts mixed_a.select{|e| e.class.name == "Cat"}.size

    # How many vamps exist in array?
    puts mixed_a.select{|e| e.class.name == "Vampire"}.size

    # How many people in array?
    puts mixed_a.select{|e| e.class.name == "Person"}.size

    # Output
    # 2
    # 2
    # 3
    # 3
~~~~

# Ocl asSet()

If we have a collection in OCL, there is a chance that there exists duplicates.
If we don't want duplicates we can use the `asSet` operation in OCL. In Ruby
this is called `uniq` (unique), not to be confused with the OCL operation
`isUnique()`.

~~~~ruby
    arr = [1, 1, 1, 2, 3]
    p arr.uniq
    # output: [1,2,3]
~~~~

