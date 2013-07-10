--$ First version will be created with this. The comments to be added in the
--$ versions history table can be prepended with the '$' sign in order for you
--$ specify comments (if needed). It's here if you want it. 
-- This is an example file to show how the turntables gem could work maybe
-- with people. and stuff.
-- This SQL file adds the person, and work_descriptions entities to the 
-- database. 
CREATE TABLE persons (
  id      integer primary key autoincrement,
  name    varchar(50),
  surname varchar(50), 
  age     integer
);

CREATE TABLE work_descriptions (
  id          integer primary key autoincrement,
  description text
);

