-- An example variant record that is immutable
-- @author psyomn
package Immutable_Test is

  -- Options for the variant; both make a number of people angry ;o)
  type Option is (Software_Guy, Politician); 

  -- Immutable Variant record example 
  type Employee (Opts : Option) is 
    record 
      name    : String (1..50);
      surname : String (1..50);
      age     : positive;

      case Opts is 
      when Software_Guy => 
        very_angry_userbase     : natural;
      when Politician => 
        angry_political_members : natural;
        angry_civilians         : natural;
      end case;
    end record;

  procedure Test;

end Immutable_Test;
