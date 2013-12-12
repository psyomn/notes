% An SQL Beginner Tutorial
% Simon Symeonidis
% Fri Dec  6 00:03:29 EST 2013

This document aims to give you beginner level knowledge of the following points
in databases: 

* Learn about relationships
* Learn about views
* Learn about polymorphic relationships
* work with SQLite, MySQL, and PostgreSQL (their differences, and use cases)
* slight talk about other data storage facilities such as Redis, and MongoDb

# Approach

We will be going over 2 SQL implementations. One of the implementation is
SQLite3. The next implementation we will focus on is PostgreSQL. SQLite3 will 
be used in the beginning due to its easy configuration with the system. We will
be able to disregard other issues, such as database user management, and get at
the coding as fast as possible. As stated this is to learn the language, and
SQLite3 should not normally be considered as a good database for a system that
requires higher concurrency and responsiveness (though please note that it
still has valid use cases on other applications)

At the end of the document, we'll briefly talk about other database-like
storage alternatives that might be used as well. We will make a distinction
however, and emphasize that for the right job, we must choose the right tool.

# Minor Forenote

A database contains tables. Tables contain records, often called rows. A
database usually contains data of a specific application. Tables represent
entities in the domain logic of that application, that require persistence.

For example, a `Person` class could require to have its state persisted. A
`Person` class, may aggregate (have many of / have a list of) `Book` classes.
On the programming level, these relationships are possible using memory
allocation and references to objects. When persisting such relationships, we
need to identify the type of relationship (has-one, has-many), and represent
them using unique keys, and proper schemas (table structures).

## SQLite3

First you'll need to install the database system. Please follow the
installation instructions here:

> [http://www.sqlite.org/download.html](http://www.sqlite.org/download.html)

Specifically, download the precompiled binaries for windows
(sqlite-shell-win32).

If you're on linux, use the package manager specific to your distribution to
install sqlite3. 

Both of these should provide you with a shell that will allow you to manipulate
sqlite3 databases.

### Using the shell

When you run the sqlite3 shell, you'll see the following: 

~~~~{.bash}
[psyomn@aeolus ~ 0]$ sqlite3
SQLite version 3.8.1 2013-10-17 12:57:35
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> 
~~~~

### Creating a table

Consider that we want to persist information in a database of people. The
information we want to store for each person is their name, surname and their
age. If we had a notebook, and we wanted to store this information, we would
create a table by separating the page in three parts: name, surname and age.
This is what we want to do as well with the table in this database.

~~~~{.sql}
sqlite3> create table person (
    ...>   name varchar(50), 
    ...>   surname varchar(50),
    ...>   age int);
~~~~

#### A Note on Types

In tables, we need to specify the type that the columns must store on each
row. For example, for a person's name, we would require that we have a string
of maximum 50 characters, as shown above (_varchar(50)_). For a person's age
we would need an interger type - that would be most appropriate. 

In different SQL implementations, there exist different available types. So
for example a type that exists in SQLite3 might not appear in the implementation
of MySQL, or PostgreSQL. For the most part, primitive types such as integers, 
floats, and strings are available. 

If it is important for an SQL schema to be as cross platform as possible (in
the sense of being able to migrate the schema from SQLite3, to MySQL, or
PostgreSQL), it is usually best to stick to very basic queries or declarations.
For example sticking to primitive types might give you less headaches in the
future. Usually this is not something to worry about.

### Inserting into a table

Run the following provided you have created the required table. 

~~~~{.sql}
sqlite3> insert into person (name,surname,age) values ('jon', 'doe', 18);
~~~~

If you want to enter a list of people in a single command, you can do the 
following:

~~~~{.sql}
sqlite3> insert into person (name,surname,age) values 
    ...> ('jon', 'doe', 18), 
    ...> ('jon' 'snow', 32), 
    ...> ('marry', 'spanakopitakis', 21);
~~~~

With the previous code sample, we now have a database that contains the current
table:

----- -------------- ---
Name  Surname        Age
----- -------------- ---
jon   doe            18

jon   snow           32

marry spanakopitakis 21
----- -------------- ---

### Selecting from the Table

Naturally, after inserting information to the table, we want to be able
to retrieve it. The keyword to memorize for this aspect is _Select_. 
We need to provide it what fields we are interested from the table, and
finally the table name as well. For an example let us select all the 
surnames and ages from the table _person_.

~~~~{.sql}
sqlite3> select surnamge, age from person;
~~~~

But what if we wanted to impose a constraint? For example, let us require
that we select the fields _name_ and _age_ for the person named 'marry'.

~~~~{.sql}
sqlite3> select name, age from person where name='marry';
~~~~

That is good and all, but problem arises when we have more people being 
recorded in the system called 'marry'. Then we won't be able to distinguish 
who is who. This is where keys come into effect, and how specific find queries
are usually implemented in _SQL_.

### Destroying a Table

Since we want the ability to distinguish between data pairs where we can not
rely on the uniqueness of each field, we can assign a key. We call this key an
`id`. However we already defined the table person. Let's get rid of it, so we
can create a new table with the id field.

~~~~{.sql}
sqlite3> drop table person;
~~~~

Now let's recreate the table with the wanted id.

~~~~{.sql}
sqlite3> create table person (
    ...>   id integer primary key autoincrement,
    ...>   name varchar(50),
    ...>   age  int);
~~~~

We set the key as an integer, and denote that it is a primary key. We also
express the wish of making it automatically increment by adding `autoincrement`
in the end. Each time a record is added to this table, an id will automatically
be assigned to it, by increasing the previous maximum key by one. So for
example, if we were to repeat the entries of _jon doe, jon snow, and marry
spanakopitakis_, jon doe would have a key with value '1', jon snow '2', and
marry '3'. We can now reference rows properly and form relations using them.

### Deleting a row from a table

If we wish to remove an entry from the database table, we can do so by 
using `delete`. In order to delete something in particular we need to tell
_sqlite3_ specifically what row. So here we add a WHERE clause. Let's take the
case that we want to remove the row with id '2'. We would need to do the
following: 

~~~~{.sql}
delete from person where id = 2;
~~~~

Be cautious when writing this query. If you acccidentally forget to add the
where clause, and write:

~~~~{.sql}
delete from person;
~~~~

All the rows will be deleted! 

### Updating a row in a table

Once we store the information in a row, there might be a situation where
somewhere in the future, we wish to update the information. For example, let
us consider the following table:

---- ------- ---------------- -------
id   Name    Surname          Age
---- ------- ---------------- -------
  1  Jon     Johnson          23

  2  Frank   Frankson         25
---- ------- ---------------- -------

Jon came in a few weeks ago, and they entered his information. But the person
entering his information did a mistake and instead of typing in '32', they
typed in '23'. Jon comes in, and wants to have his proper age on the system.

The query we need to come up with consists of at least the keyword 'update'. 
However we need to pinpoint where the update will happen exactly. Since we
want to update Jon, we need to add a `where` clause on `id = 1`. We need to 
specify also the columns that we want to modify. We use the keyword `set` for
this. 

Here is the required query: 

~~~~{.sql}
sqlite3> update person set age=32 where id = 1;
~~~~

Frank Frankson changed his name to Charlie Thawson. He came in in order to 
update this information. We have to update two columns simultaneously now. 
We just need to use `set` once, and then separate the columns by comma. And
then we're done. 

~~~~{.sql}
sqlite3> update person set name='charlie', surname='thawson' where id = 2;
~~~~

### Altering a table

Table alterations are required when we want to change the table schema, while
there is still data inside. For example if we did not care about contents in 
the table, we could _drop_ it, and create the new table with the new schema. 


Usually the most common alterations that you will have to consider are when 
you want to add columns to the table. Consider the following schema: 

~~~~{.sql}
sqlite3> create table pet (name varchar(50));
~~~~

Now, we want to add a cuteness rank to the pet, so that we can persist how
cute a cat is in comparison with a dog. 

~~~~{.sql}
sqlite> alter table pet add column cuteness_score int;
~~~~

We are now able to assign cute scores to pets!

### Constraints

It is possible to impose constraints on information that is to be added to the
table. The three commonly used accross most SQL implementations are _unique_,
_not null_ and _foreign key_ constraints. We will talk about _foreign keys_
later, as they are a little more involved. 

The constraint _not null_ as it suggests, requires that added information to a
table column is _not null_ (eg: you explicitly pass _null_, or you don't
provide a value for the column at all).

#### Not Null

Here is an example of using the constraint. We want a person record to require
a name in order to be inserted: 

~~~~{.sql}
sqlite> create table person (name varchar(30) not null, age int);
sqlite> insert into table person (name) values ('jon'), ('david');
Error: near "table": syntax error
sqlite> insert into person (name) values ('jon'), ('david');
sqlite> insert into person (name,age) values ('jon',13), ('david', 12);
sqlite> insert into person (age) values (12);
Error: person.name may not be NULL
~~~~

#### Unique

Unique just makes sure that all the values in the given column are _unique_. An
example use case for this constraint would be a online forum (like phpbb, and
other boards) where the user that is registering, is required to have a unique
nickname.

~~~~{.sql}
sqlite> create table user (email varchar(30), 
   ...> password varchar(30), nickname varchar(30) unique);
sqlite> insert into user (email, password, 
   ...> nickname) values ("someone@somewhere",
   ...> "mypass", "nick123");
sqlite> insert into user (email, password, 
   ...> nickname) values ("someone@somewhere",
   ...> "mypass", "nick123");
Error: column nickname is not unique
~~~~

## Table Relations

We previously referenced the foreign key constraints. Before talking about
those, we want to cover slightly the topic of table relations.

Storing records of data is useful, but often it is not enough. For example we
can have a class Person, that aggregates (has a list of) Books. We can store
people as records, and Books as well. However we need a way to identify which
user's in a table, books belong to. To demonstrate a simple example, think of
the following issue: Bob and Joe are two users of the system. They both store
books in the system. They forget about the books because it's the weekend, and
reading can wait up until Monday. When they come back they don't remember which
books they own. Luckily they have both written their names inside them, and 
can find them again, without accidentally taking a book that belongs to someone
else. Figure \ref{fig:hasmany} shows us how Jon owns different books.

![Jon Has Many Books\label{fig:hasmany}](fig/dot/has-many.png)

Writing 'names' in the books is a high level example of what actually happens
here: they have given their identity to the book, in order to claim it back
later on. By labeling many books this way, they can own many books. In more 
technical terms, they are _assigning their id_ to the _book record_.

This way we can visualize the problem with the two following tables: one for
the user base, and the second one for any book that they own.

**User Table**

--- --------- ----------
id  Name      Age
--- --------- ----------
1   Joe       32

2   Bob       42
--- --------- ----------

**Book Table**

--- --------------------- -------- 
id  Book Title            user_id
--- --------------------- --------
1   Neuromancer           1

2   Wizard of Oz          2

3   Logicomix             1

4   Full Metal Alchemist  1

7   Alice in Wonderland   2
--- --------------------- --------

Now for example, if we wanted to find out what books user 'Joe' had left during
the weekend, we would first look at Joe's id. Once we have his id, we would use
it to search on the 'book' table.

Let us look at the actual code behind this. First we need to create and 
poppulate the tables. 

~~~~{.sql}
sqlite> create table users (id integer primary key autoincrement, 
   ...> name varchar(30),
   ...> age int);

sqlite> create table books (id integer primary key autoincrement,
   ...> title varchar(60),
   ...> user_id integer);

sqlite> insert into users (name, age) values
   ...> ('joe', 32),
   ...> ('bob', 42);

sqlite> insert into books (title, user_id) values 
   ...> ('Neuromancer', 1), ('Wizard of Oz', 2), ('Logicomix', 1),
   ...> ('Full Metal Alchemist', 1), ('Alice in Wonderland', 2);

~~~~

Now to find the id of the user Joe we would need to look into our
users table.

~~~~{.sql}
sqlite> select id from users where name='joe';
1
~~~~

So this id represents 'joe'. Now if we want to retrieve all the
books that the user 'joe' has left behind we run the following: 

~~~~{.sql}
sqlite> select * from books where user_id=1;
1|Neuromancer|1
3|Logicomix|1
4|Full Metal Alchemist|1
~~~~

It is also possible to nest the sql queries in this manner (the query in the 
brackets finds the id of the user, and the result is used to find the
books with the given _user\_id): 

~~~~{.sql}
sqlite> select * from books where user_id=(select id from users where name='joe');
1|Neuromancer|1
3|Logicomix|1
4|Full Metal Alchemist|1
~~~~

This is how we are able to represent relationships in databases. 

### Relations: 2 Common Types

In applications you'll usually encounter 2 common types of relationships. In
one type of relationship, we're able to assign multiple records to one record
(the example of Jon and his books). In another type of relationship, we can
describe different records, that own other different records. 

To make things clear, let us provide more concrete examples. For the former
where one entity owns many other entities, and those entities only belong
to that entity, an example would be that of a user posting on a forum. The
User is the Entity. A Post is another entity. A User owns many Posts. A
particular post belongs to a particular user. 

On the other hand we have shared resources. For example, think of Entities A,
B, C. A and B own other C entities. In the former example we could realize this
by assigning books with the user's identification numbers (ids). A simple
graphical representation can be seen in Figure \ref{fig:through} where two 
different people with ids _1 and 2_ have the same shared item, identified by
the key _2_.

This relationship requires an auxiliary table to form this sort of
relationship. The auxiliary table needs only to contain the keys of the
_Person_ table, and the keys of the _SharedItem_ table.

![Has Many _Through_ another table \label{fig:through}](fig/dot/has-many-through.png)

## Constraints to Relationships

We now covered how we can relate different data entities to each other using
keys on tables. Adding to this, we can add constraints to the relationships.
In order to make sure that we are inserting data that makes sense, we can check
whether the relationship we're trying to build is possible or not by checking
if the keys exist on either table. Take a look at the following example.

--- --------
id  CatName
--- --------
1   Fluffy

2   Mittens
--- --------

--- ----------- --------
id  Ball Color  OwnerID
--- ----------- --------
1   Red         1

2   Green       2
--- ----------- --------

Looking at these tables, we can see that we have two cats, and two wool balls. 
Fluffy owns the red ball, and Mittens owns the Green ball. For this
relationship to have been made, we would need to make two inserts on the cats
table, and another two in the wool balls table. The wool balls table would
_reuse the ids of the cats_ in order to denote ownership of said balls. Now,
what would happen if we tried assigning an owner id to a new ball, that no cat
had? That would leave our _balls_ table in a very weird state. _We don't want
that_.

This is where foreign key constraints come in, and can help you detect such 
issues. Different SQL implementations require you to activate them in different
ways. In _MySQL_ you're required to use a specific engine (See _InnoDb_). In
SQLite3, you're required to write this into the shell: 

~~~~{.sql}
[psyomn@aeolus tmp 0]$ sqlite3
SQLite version 3.8.2 2013-12-06 14:53:30
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> PRAGMA foreign_keys = ON;
~~~~

Now let's see the implementation of the above example with SQL code. Notice
how we impose a foreign key constraint on the _balls_ table.

~~~~{.sql}
create table cats ( 
  id integer primary key autoincrement, 
  name varchar(40)
);

create table wool_balls (
  id       integer primary key autoincrement,
  owner_id integer, 
  color varchar(40),
  
  -- foreign key constraint
  foreign key(owner_id) references cats(id)
);
~~~~

Now let us see what happens when we do legal inserts.

~~~~{.sql}
insert into cats (name) values ('fluffy'), ('mittens');

-- ok 
insert into wool_balls (owner_id, color) values
  (1, "red"),
  (1, "blue"),
  (2, "green");
~~~~

Making sure the inserts were normal.

~~~~{.sql}
sqlite> select * from wool_balls;
1|1|red
2|1|blue
3|2|green
~~~~

Trying to add an illegal row (no cat with id _3_).

~~~~{.sql}
-- boom
insert into wool_balls (owner_id, color) values
  (3, "magenta");
Error: near line 10: FOREIGN KEY constraint failed
~~~~

Making sure that the illegal row was not added.

~~~~{.sql}
sqlite> select * from wool_balls;
1|1|red
2|1|blue
3|2|green
~~~~

One final note: if we delete a row from a table that has a relationship
elsewhere, then the record it was referencing will remain there. So for
example, if a cat with a name 'mittens' is in the cats table, and has a 'blue'
ball in the wool balls table, and the cat is later removed from the table, the
blue ball will remain in the other table. If we want to remove any other record
that might be referenced, we can do it using a built-in mechanism

This mechanism uses _on delete cascade_ in order to spot foreign key
references, and invoke deletions on those tables; and the deletions continue
to occur if those tables have cascading deletes as well. This ensures the data
integrity store in databases.

### A note on Constraints

Databases provide the possibility of adding constraints to data that is to be
added to a table. However, it should be noted that some frameworks or even
applications choose to have this logic implemented in the application level -
that is not using the constraint mechanisms of the database, and catching these
violations on said application level. For example, the application using a
database is able to detect if a field is empty - there is no need for this
issue to go down through all the layers of the application (ie: presentation to
domain logic, to technical services, and finally the database), if all of this
can be prevented at the top. But on the other hand there might be situations
where this is favorable. It is always best to have a wide range of choices. 

## Polymorphic Relations

Polymorphic relationships are a little odd, but good to know. They might be
considered slow at runtime due to different tables requesting access on one
particular table, as it will soon be shown. (_Note: not sure about the
efficiency, it's not something I've actually sat down and benchmarked_).

The scenario usually goes as follows. You want to persist a trait that is
common to many entities. For example, think about a site that posts songs, and
news about bands. The site would also have member pages. To give it a social
spin, we want to let users comment on any item.

If we did not use polymorphic relations, we would use has-many relationships, 
and create a table for each aspect. For example, song postings would have a
song_comments table. News postings would have a news_comments table, and so on.
This could be a tedious job to do, and provide a lot of redundant work for the
coders. 

A solution to this would be to identify these resources as _Commentable_.
Therefore, songs, news, and user pages are all ... _commentable_.

Polymorphic relations in essence are nothing too complicated. They are in fact
the auxiliary table that exists in the second demonstrated type of has-many
relation, with an extra field: the discriminator. 

Recall that the has-many relationship required a table with two foreign keys.
We can see this again in Figure \ref{fig:show}. That auxiliary table was to
be specifically used by 'Person'. Therefore we know that one of the foreign
keys stored in the table is of 'Person', and the other is of 'SharedItem'.

However, when we wish to do the same with different tables, we can only assign
one of the foreign keys to a known table: the shared item foreign key. The id
of the table that is referencing the shared item is also stored. But it might
appear more than what it is in reality because tables such as news, songs, and
user pages might have the same comment ids. 

So we add one more field, a discrimitator, to bind context to the leftmost id.
The discrimitor can be any form. For the sake of clarity, let us use strings,
which are the names of the tables.

------------- ------------------- ---------------------
Discriminator Discriminator's ID  Comment ID
------------- ------------------- ---------------------
News          1                   1

Song          1                   2

Song          2                   3
------------- ------------------- ---------------------

# Exercise

We want to implement a simple schema of a movie database. We want to be able to
persist the information of the following aspects: who acted in a film, who
directed the film, and who produce the film (note, there could be more than one
company that produced a film). Something to be careful about is that any actor,
director, or producer can have more than one role (for example a director can
appear in the movie for a short while, and be credited as an actor). 

The information we want to store about each person is their name, their surname, 
their date of birth. 

We want to store movies. Movies have a title, a year, and a budget. A movie can
be a comedy, a horror movie, a romance movie, or any combination of the
previously mentioned genres. A movie must also store a budget. (Note: many
movies have similar genres... _this means they share a specification / resource
hint hint!_).

The final aspect is that we want a user to exist in the system. The user stores
a username, and a password, as well as an email. A user assigns different
movies, ratings depending on whether they liked the movie or not. A user also
wishes to maintain a list of movies they wish to see, or would like to see in
the future (note: the information for both wish to see, and seen movies should
be maintained in _one_ table; don't create a separate table for wish to see and
seen, in other words).


# Other weird Databases

