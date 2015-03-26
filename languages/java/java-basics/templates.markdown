## Templates

To explain templates, let us go over an analogy. Imagine you are cutting out a
square shape from a piece of paper. You can use this paper with the square hole,
and paint, to quickly draw similar shapes with the same paint. That is you have
a set of features that you want constant when drawing the shape - the only
difference is the color you use. Templates in essence are similar, but may a
little more dynamic than your average stencil art.

With templates, you are able to use the same functionality, but with different
types. Templates are named like classes, but usually have angled brackets
denoting what type they're taking in. Here is an example, that might now seem
familiar:

~~~~java
    ArrayList<String> listOfStrings = new ArrayList<String>();
~~~~

We know what an array list is, and possible operations it can support (such as
`add`, `get` etc). All this functionality may be specified in an generic form.
For example, we can say that a collection such as `ArrayList` contains elements
of type `T`. And we can also remove these elements, or add them to the
structure dynamically. Templates, in this respect, are much more specific than
interfaces, but more generic than abstract classes. There will be some sort of
implementation, but one that does not specify the types.


