# SQL

This document aims to give you beginner level knowledge of the following points
in databases: 

* Learn about relationships
* Learn about views
* Learn about polymorphic relationships
* work with SQLite, MySQL, and PostgreSQL (their differences, and use cases)
* slight talk about other data storage facilities such as Redis, and MongoDb

## Approach

We will be going over 2 SQL implementations. One of the implementation is
SQLite3. The next implementation we will focus on is PostgreSQL. SQLite3 will 
be used in the beginning due to its easy configuration with the system. We will
be able to disregard other issues, such as database user management, and get at
the coding as fast as possible. As stated this is to learn the language, and
SQLite3 should not normally be considered as a good database for a system that
requires higher concurrency and responsiveness (though please note that it
still has valid use cases on other applications)

### SQLite3

First you'll need to install the database system. Please follow the
installation instructions here:

> [http://www.sqlite.org/download.html](http://www.sqlite.org/download.html)

Specifically, download the precompiled binaries for windows
(sqlite-shell-win32).

If you're on linux, use the package manager specific to your distribution to
install sqlite3. 

Both of these should provide you with a shell that will allow you to manipulate
sqlite3 databases.

#### Using the shell

When you run the sqlite3 shell, you'll see the following: 

~~~~{.bash}
[psyomn@aeolus ~ 0]$ sqlite3
SQLite version 3.8.1 2013-10-17 12:57:35
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> 
~~~~

#### Creating a table

Consider that we want to persist information in a database of people. The
information we want to store for each person is their name, surname and their
age. If we had a notebook, and we wanted to store this information, we would
create a table by separating the page in three parts: name, surname and age.
This is what we want to do as well with the table in this databse.

~~~~{.sql}
sqlite3> create table person (
    ...>   name varchar(50), 
    ...>   surname varchar(50),
    ...>   age int);
~~~~

#### Inserting into a table

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

#### Selecting from the Table

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

#### Deleting a row from a table

If we wish to remove an entry from the database table, we can do so by 
using `delete`. In order to delete something in particular we need to 
tell _sqlite3_ specifically that this is what we want. So here we add
a WHERE clause.

#### Updating a row in a table

#### Altering a table
