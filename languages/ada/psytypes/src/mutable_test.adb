with Ada.Text_IO;

package body Mutable_Test is 

  procedure p(S : String) renames Ada.Text_IO.Put_Line;

  procedure Test is 
    face_changer : faceless (Current_Persona => Likeable);
  begin
    for I in Integer range 1..10 loop
      Mutate(face_changer);
      Print(face_changer);
    end loop;
  end Test;

  procedure Print
    (Face : Faceless) is 
  begin
    p(Persona'Image(face.current_persona));
    case face.current_persona is 
    when likeable => 
      p("Is happy?");
      p(Boolean'Image(face.Mood_Is_Happy));

    when shady => 
      p("Moneyz: ");
      p(Natural'Image(face.money));
      p(face.message);

    when murderous =>
      p(face.secret_phrase);
      p(face.response); 

    end case;
  end Print;

  procedure Mutate 
    (Face : in out Faceless) is 
  begin 
    case face.current_persona is
    when likeable => 
      face := (
        current_persona => shady,
        money => 20,
        message => "hello there stranger, wacha buying?");
        
    when shady =>
      face := (
        current_persona => murderous,
        secret_phrase => "valar morghulis",
        response => "valar doaheris");

    when murderous =>
      face := (
        current_persona => likeable, 
        Mood_is_happy => True);

    end case;
  end Mutate;


end Mutable_Test;
