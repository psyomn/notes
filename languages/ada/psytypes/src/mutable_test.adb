with Ada.Text_IO;
with ada.strings.fixed;

package body Mutable_Test is 

  procedure p(S : String) renames Ada.Text_IO.Put_Line;

  procedure Test is 
    -- To make the variant record mutable, we must not define a discriminant
    face_changer : faceless;

    -- below is an example of a immutable variant record
    -- face_changer : faceless (Current_Persona => Likeable);
  begin
    for I in Integer range 1..10 loop
      Mutate(face_changer);
      Print(face_changer);
      Ada.Text_IO.New_Line;
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
      p("Money: ");
      p(Natural'Image(face.money));
      p(face.message);

    when murderous =>
      p("You notice a very odd fellow. You hear two things: ");
      p(face.secret_phrase);
      p(face.response); 

    end case;
  end Print;

  procedure Mutate 
    (Face : in out Faceless) is 

    package ST renames Ada.Strings;

    -- Things someone says, depending on persona
    likeable_str  : String := "hello there stranger, wacha buyin?";
    shady_say_str : String := "valar morghulis";
    shady_res_str : String := "valar doaheris";

    fixed_message : String(String_Min .. String_Max) := (others => ' ');
    fixed_secret  : String(String_Min .. String_Max) := (others => ' ');
    fixed_response: String(String_Min .. String_Max) := (others => ' ');
  begin 
    case face.current_persona is
    when likeable => 
      fixed_message(likeable_str'range) := likeable_str;

      face := (
        current_persona => shady,
        money           => 20,
        message         => fixed_message);

    when shady =>
      fixed_secret(shady_say_str'range)   := shady_say_str;
      fixed_response(shady_res_str'range) := shady_res_str;

      face := (
        current_persona => murderous,
        secret_phrase   => fixed_secret,
        response        => fixed_response);

    when murderous =>
      face := (
        current_persona => likeable, 
        Mood_is_happy => True);

    when others => null;
    end case;
  end Mutate;

end Mutable_Test;

