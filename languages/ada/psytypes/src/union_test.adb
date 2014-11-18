with Ada.Text_IO; use Ada.Text_IO;

package body Union_Test is 
  procedure p(S : String) renames Ada.Text_IO.Put_Line;

  -- Checking discriminator will raise compilation error
  --
  -- procedure Illegal(U : United) is
  -- begin 
  --   case U.Discriminator is
  --
  --   when One =>
  --     p("Union type one");
  --     p(Integer'Image(U.Basic));
  --     p(Float'Image(U.Potato));
  --
  --   when Two =>
  --     p("Union type two");
  --     p(Integer'Image(U.Basic));
  --     p(Positive'Image(U.Yotato));
  --     p(Positive'Image(U.Motato));
  -- 
  --   end case;
  -- end Put_United;

  procedure Test is 
    uni : United;
  begin
    p("Union test (Read source)");

    uni := (
      Basic => 3,
      Discriminator => Two, 
      Yotato => 2, 
      Motato => 3);
    new_line;
  end Test;

end Union_Test;
