
package Mutable_Test is 
  type Persona is (Likeable, Shady, Murderous);

  type Faceless (Current_Persona : Persona) is 
    record 
    case Current_Persona is 
    when Likeable => 
      Mood_Is_Happy : Boolean := True;

    when Shady => 
      Money : Natural := 10; 
      Message : String;

    when Murderous =>
      Secret_Phrase : String;
      Response : String;

    end case;
    end record;

  procedure Test;

  procedure Print
    (Face : Faceless);

  -- This will alternate from likeable, to shady to muderous, and back to
  -- likable
  procedure Mutate
    (Face : in out Faceless);

end Mutable_Test;
