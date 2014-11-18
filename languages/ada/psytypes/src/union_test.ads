package Union_Test is 

  procedure Test;

  type United_Discriminator is (One, Two);

  type United (Discriminator : United_Discriminator := One) is 
    record
      Basic : Integer;
      case Discriminator is
      when One =>
        Potato : Float; 
      when Two =>
        Yotato : Positive;
        Motato : Positive;
      end case;
    end record;

  pragma Unchecked_Union (United);

end Union_Test;
