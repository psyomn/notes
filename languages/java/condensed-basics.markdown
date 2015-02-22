% Condensed Java Basics
% Simon Symeonidis
% Wed May 21 2014

# Introduction

The purpose of this document is to highlight the basics, and introduce core
examples to the reader. With this document you should be able to remind yourself
core features of the language, that in turn may be used to create simple object
oriented applications.

We will go through the following: structure of a simple program. Variable
declarations, and simple operations. Control structures. Classes. Visibility in
classes. Inheritance, and use of polymorphism.

## Structure of a Simple Program

A program is a set of operations that need to be executed at some order.
Ultimately you must supply the computer with two things: what needs to be
executed, and where to start. Many programming languages have the _main_
construct to account for this. Java has this convention too. You need to
remember 2 rules for your Java programs, which might be different if you're much
more used to writing C/C++ programs:

1. The file must have the same name as the class you will be writing. For
   example if you are writing `class Person { ... }`, then your file should be
   named `Person.java`.

2. The file must only contain one class definition. You can however define inner
   classes within the main class of the file.

## Hello World

The basic structure of a main program in _Java_ is the following:

~~~~java
public class Main {
  public static void main(String[] args) {
    System.out.println("Hello world!");
  }
}
~~~~

In Java every file contains one _root_ class. That class may contain inner
classes as well. But no file will ever contain more than one class.

Due to the above rule, we need to enclose our _main_ call inside another class.
This raises the question - can there be, in a project, more than one file,
containing a class with the _main_ routine?

And the answer is yes. However, when compiling and running, you would have to
specify which _main_ to use. We will omit this information, as it is beyond
beginner scope (but good to know).

## Variables

Performing operations is nice, but adding the possibility of manipulating data
is even better. There are two things you need to keep in mind: there exists
primitives, and classes.

Primitives would include data types such as _int_, _float_, _char_, _bool_,
_double_.

~~~~java
int x = 2;
int y = 3;
int z = x + y;

double one = 2.3;
double two = one + 4.21;

boolean isOk = false;

char a = 'c';
~~~~

Classes would include types such as _String_, _StringBuilder_, _Person_,
_Calculator_, etc. The general convention is that classes tend to be
capitalized.

And there exists primitive arrays. Primitive arrays means that you have a
sequence of memory locations reserved for data. You can cram inside either a
type of primitive, or class.

Classes, and primitive arrays need to be created in the following way, with the
keyword _new_.

~~~~java
int[] a = new int[12]; /* An array of ints */
String str = new String();
String[] args = new String[12];
~~~~

Please notice the creation of _String_ and _String[]_. The former creates the
object, while the second reserves _array space_ for 12 _String_ objects. You
would have to create each string independently if you wanted to use the array of
objects. So with that said this is how you would set the values of the array.

~~~~java
String[] stringArr = new String[10];

for (int x = 0; x < stringArr.length; ++x) {
  stringArr[x] = new String("The string");
}
~~~~

Please don't confuse these primitive arrays with the Java implementation of the
basic data structures such as _ArrayList_ and _LinkedList_. We will see these in
the next section.


## Classes vs Objects

A good thing to do at this point is to differentiate between what classes and
objects are. Classes are the definition. Objects are the result.

Another analogy would be the following: imagine spheres of different sizes and
color. They all belong to a same family. But each one of them, with the same
questions, will yield different results. For example, any two elements `A` and
`B` are spheres. However they may be of different color. A better example would
be to classify them with respect to behavior: all of them will respect the
formula, that gives us the area of a sphere. The only information required, is
the size of their radius: in other words given some differing information of a
radius `r`, we may apply the same function for any `r`, and get the required
behavior.

So, in other words, a class may contain crucial behavioral definitions, whereas
objects contain the differing information that the behavior requires. More
abstract, classes are specifications, whereas objects are instantiations of
those specifications, possibly given differing data.

The user has control over both classes and objects. Here is a simple class:

~~~~java
class Sphere {
  public Sphere(float iRadius, String iColor) {
    mRadius = iRadius;
    mColor  = iColor;
  }
  public String color() { return mColor; }
  public float area() { return 4 * Math.PI * Math.power(mRadius, 3); }
  private String mColor;
  private float mRadius;
}
~~~~

You can see what was previously described in code form. We have set behavior
for the Sphere we modeled. Now it will behave according to what `radius` we
supply to the object, instantiated from the class. To instantiate an object,
we may do the following:

~~~~java
public class Main {
  public static void main(String[] args) {
    Sphere s = new Sphere(3.2, "red");
    Sphere r = new Sphere(4.8, "blue");
    System.out.println(s.area());
    System.out.println(r.area());
  }
}
~~~~

If we were to visualize this in the memory space, we could see these two objects
as the following:

~~~~nocode
    +--------+   +--------+
    | Sphere |   | Sphere |
    +--------+   +--------+
    | 3.2    |   | 4.8    |
    | "red"  |   | "blue" |
    +--------+   +--------+
~~~~

And using the declared method `area`, we would be able to 'send a message' to
these objects in memory. Both of them know about the method `area`, and what
actions to take (see the implementation of `area()` in the code listing). What
these objects need to do is 'plug in' the variables they hold to their
respective `instance variable` declarations. So when calculating the area of the
red sphere, we would want the radius of `3.1` to be plugged in the formula.
However, when calling area for the "blue" sphere, we wish to 'plug in' `4.8` as
the value of the radius.

Essentially you should think of objects as entities, that know about what their
structure is like (what data fields they have, and what behavior), and which
behave differently whenever given different data. There can be many 'entities'
expressing this behavior at any given time.

Now let us look at the more practical side of things. It is assumed that the
reader is familiar with procedural programming. We will write the following in
`C` code to demonstrate our point. Recall that in C we do not have classes, but
structures which are strictly used to hold data. The functionality comes from
providing many free functions with knowledge on how to manipulate the data. So
the equivalent to the above example with the spheres would be something like the
following:

~~~~C
    typedef struct {
      float    radius;
      uint32_t color_code;
    } sphere_t;

    void
    sphere_set_radius(sphere_t* _s, float _r) {
      _s->radius = _r;
    }

    float
    sphere_calculate_area(sphere_t* _s) {
      return _s->radius * _s->radius * 3.142 * 4;
    }
~~~~

You can notice that on the above, both functions would require a reference to
the structure we are dealing with. That particular structure is omitted from the
type signatures in most object oriented languages, and a keyword called `this`
is provided, if the particular behavior of a class needs to refer to that
particular object in the runtime.

## Visibility

In `C` programs we don't quite have the notion of visibility. We have something
similar in the respect of static declarations in objects (by objects I'm
refering to the object code generated by the compiler, usually having the `.o`
suffix), but that is not what we are talking about.

Take the C structure in the following fragment:

~~~~C
    typedef struct {
      int age;
      float salary;
    } person_t;
~~~~

If we had the following function, accessing members of the struct would be
legal:

~~~~C
    void my_func(person_t* _person) {
      /* Given that _ms is non-null */
      _person->myint = 1;
      _person->fval  = 2.32f;
    }
~~~~

### Private Visibility

In object oriented languages we are able to restrict this visibility. The
motivation is to provide an agnostic way of handling data 'behind the scenes',
whilst providing a _standard interface_ to the application programmer, using
this unit. In Java, one is required to use the `private` keyword for restricting
this visibility. If this restriction is not required, and some feature (either a
method, or a variable) is to be called directly, then we can use the `public`
keyword. The above could be translated to the following Java code, if we wished
to restrict the visibility to the two variables:

~~~~Java
    class Person {
      private Integer age;
      private Float salary;
    }
~~~~

If an application developer tried using the above class, and calling the
attributes directly, there would be a compilation error:

~~~~Java
    Person p = new Person();
    System.out.println(p.age); /* Does not compile */
~~~~

### Public Visibility

As we previously saw, we can declare different parts of a class as public. For
example the following class has a few of it's attributes as public:

~~~~java
    class Person {
      public String name;
      public String surname;
    }
~~~~

This means that we can directly access the data from some other part in the
program in such a fashion:

~~~~java
    public class Main {
      public static void main(String[] args) {
        Person p = new Person();
        p.name = "jonny";
        p.surname = "overload";

        System.out.println(p.name);
        System.out.println(p.surname);
      }
    }
~~~~

One might notice and pose the following question: _if I can simply access the
data that I require using public visibility, why not use public everywhere?_

You could technically use public everywhere. But you would sacrifice one
mechanism that you might not want to otherwise: you treat objects as black boxes
which you do not care how things are implemented on the other side - but you
know what the output is.

So for example think of a random number generator. The random number generator
could use a very common technique to generate random numbers. Some techniques
might purely be algorithmic. Other approaches may include outside resources such
as hard disks, mouse input, microphone input, and anything that can aid you with
providing 'real' random numbers.

### Why Private Visibility

## Creating a Small Application

When you want to create a small application, you essentially want to break down
different functionalities in different classes. In other words, if you choose a
good granularity on how much you break these functionalities down, the easier
your life will be on the development side of things.

Let's look into creating a small application, where we implement an address
book. The address book will hold names, surnames, phone numbers, and emails. The
user will be prompted to enter different information for different situations.
We would like to:

- Have a menu to choose whether to:
    - Create an entry of a person
    - Update the information of a person
    - Delete a person from the address book

We should worry about two things: separating the structures which may hold this
information, to the user interface that interacts with these structures.
Essentially you want to separate these two things to two or more classes.

Let's first begin with our data classes, in other words our conceptual domain.
We are interested in the three data fields: name, surname, and email.

Writing this down we first get the following:

~~~~java
    class Person {
      private String name;
      private String surname;
      private String email;
    }
~~~~

## Interfaces

## Polymorphism

## Templates

Think about stencil art. If you're unfamiliar with this, you can [take a look
here](http://en.wikipedia.org/wiki/Stencil_graffiti). You basically, usually
have a cut out that you spray paint on it. This technique allows you to use
different colors, but the same shape. Templates in Java are kind of like that.

You are able to use the same functionality, but with different types. Templates
are named like classes, but usually have angled brackets denoting what type
they're taking in. Here is an example:

~~~~java
ArrayList<String> listOfStrings = new ArrayList<String>();
~~~~

And of course, replacing _String_ with any other type (including user defined
types as well) is perfectly legal. We will not discus about implementing our own
templates.


