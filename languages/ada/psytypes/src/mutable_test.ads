
package Mutable_Test is 
  type Persona is (Likeable, Shady, Murderous);

  String_Min : Integer := 1;
  String_Max : Integer := 50;

  -- NOTE: You *NEED* to have a default option for mutable Faceless types to
  -- exist
  type Faceless (Current_Persona : Persona := Likeable) is 
    record 
    case Current_Persona is 
    when Likeable => 
      Mood_Is_Happy : Boolean := True;

    when Shady => 
      Money : Natural := 10; 
      Message : String(String_Min .. String_Max);

    when Murderous =>
      Secret_Phrase : String(String_Min .. String_Max);
      Response : String(String_Min .. String_Max);

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
