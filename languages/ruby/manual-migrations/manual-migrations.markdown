% Manual Migrations with Active Record
% Simon Symeonidis (2014)

# Introduction

I needed a quick, and maybe hacky way to have a mechanism to keep client
databases up to date. For example if you're distributing an application that
uses `sqlite3` databases, and you have your initial design, what do you do when
you want to push the application to version 2? 

You can either:

- Scrap all the data that the users have on their current application, and start
  anew :-(

- Provide some sort of mechanism to update the database on the clients computer.

To perform the second point, you need some way of sharing the SQL that needs to
be executed on each update, and for it to understand what order you need to
execute the update sql.

I initially wrote my own for practice and fun, but that's not always a good
idea. If you're curious you can take a look [here](http://github.com/psyomn/turntables).
Maybe it can help you if you're not looking to use something lighter than
`ActiveRecord`. 

## Migrations 

Active record is able to perform the above using migrations. If you ever
programmed on rails, you probably remember all those times you hammered down

~~~~nocode
rake db:migrate
~~~~

That read a file in _config/database.yml_, got db info, and performed all the
reads and writes it needed by reading the contents of _db/migrate_. What if we
want to do this manually?

Pretty easy. First write up your migrations: 

~~~~ruby
class M1 < ActiveRecord::Migration
  def change
    create_table :users do  |t|
      t.string :name
      t.string :surname
      t.integer :age
    end
  end
end

class M2 < ActiveRecord::Migration
  def change
    add_column :users, :income, :float
  end
end

class M3 < ActiveRecord::Migration
  def change
    add_column :users, :address, :text
    add_column :users, :comment, :text
  end
end
~~~~

Now we need to invoke the migrations. First we need to configure the database
info.

~~~~ruby
require 'active_record'
require 'sqlite3'

require_relative 'm1'
require_relative 'm2'
require_relative 'm3'

ActiveRecord::Base.configurations = {
  'development' =>  {
    :adapter => 'sqlite3',
    :database => 'db/data.sqlite3',
    :pool => 5,
    :timeout => 5000 
  }
}

~~~~

Now, make the connection:

~~~~ruby
ActiveRecord::Base.establish_connection(:development)

# This will supress the 'create table' messages
ActiveRecord::Migration.verbose = false

# Notice we pass the constants
ActiveRecord::Migration.run(M1,M2,M3)
~~~~

And you're done! 

Now we need to tackle one last part. Rails seems to manage the migrations with
some code that is not available with the plain active record migrations. The
way this code behaves is to store the version/timestamp of those migrations in a
session table.

If we execute the following as if we were making a rails project:

~~~~bash
rails g model User name surname email
rails g migration AddAddressToUser address
rake db:migrate
~~~~

Then we are able to take a look at the schema with sqlite3:

~~~~sql
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations"
("version");
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name"
varchar(255), "surname" varchar(255), "email" varchar(255), "created_at"
datetime NOT NULL, "updated_at" datetime NOT NULL, "address" varchar(255));
~~~~

And we notice the 'schema\_migrations' table. Let's look inside: 

~~~~nocode
sqlite> select * from schema_migrations; 
20140926235648
20140926235731
~~~~

We can follow the similar approach. But for now we can just use the constant's
names in order to choose which migrations will have to be run. (Note: since
you're building a local application that the user is going to be running, your
migrations will most probably be somewhere in the lib/ directory).

# References / Thanks

Massive thanks to:
[http://snippets.aktagon.com/snippets/257-how-to-use-activerecord-without-rails](http://snippets.aktagon.com/snippets/257-how-to-use-activerecord-without-rails)

Check out the Migration API:
[http://api.rubyonrails.org/classes/ActiveRecord/Migration.html](http://api.rubyonrails.org/classes/ActiveRecord/Migration.html)

