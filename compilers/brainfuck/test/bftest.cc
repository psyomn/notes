#include "gtest/gtest.h"
#include "core/brainfuck.h"

#include <sstream>

std::string RunBF(const std::string& program) {
  std::stringstream ss;
  bfi::Brainfuck bf(ss);
  bf.FromString(program);
  bf.Run();
  return ss.str();
}

TEST (bf_test, basic_increment_cell)
{
  ASSERT_EQ(RunBF("++++"), "");
}

TEST (bf_test, basic_increment_cell_and_print)
{
  ASSERT_EQ(RunBF("++++."), "4");
}

TEST (bf_test, basic_increment_and_decrement_print)
{
  ASSERT_EQ(RunBF("++++--."),"2");
}

TEST (bf_test, basic_movr_movl_print)
{
  ASSERT_EQ(RunBF("++++>++++><.<."), "44");
}

TEST (bf_test, empty_loop_test)
{
  ASSERT_EQ(RunBF("[]."), "0");
}

TEST (bf_test, empty_nested_loop_test)
{
  ASSERT_EQ(RunBF("[[]].."), "00");
  ASSERT_EQ(RunBF("[[..]].."), "00");
  ASSERT_EQ(RunBF("[[[]]]..."), "000");
  ASSERT_EQ(RunBF("[[[..+++...]]]..."), "000");
}

TEST (bf_test, loop_test)
{
  ASSERT_EQ(RunBF("+++++++++[.-]"), "987654321");
}

TEST (bf_test, nested_loops_test_early_exit)
{
  ASSERT_EQ(RunBF("[+[+[+[+[-.]]]]]"), "");
}

TEST (bf_test, nested_loops_test)
{
  ASSERT_EQ(RunBF("+[+[+[+[+[-.]]]]]"), "43210");
}

TEST (bf_test, extraneous_movr)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);

  bf.FromString("++++>++++<[[-]>]<<<<.>.");
  bf.Run();

  ASSERT_EQ(bf.GetStatus(), bfi::Brainfuck::Status::success);
}

TEST (bf_test, zero_all_right)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);

  bf.FromString("++++>++++<[[-]>]<<.>.");
  bf.Run();

  ASSERT_EQ(ss.str(), "00");
}

TEST (bf_test, check_min_wrap_around)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);
  const std::size_t expectedMaxIndex = bf.GetMaxNumCells() - 1;

  bf.FromString("<");
  bf.Run();

  ASSERT_EQ(bf.GetCellPos(), expectedMaxIndex);
}

TEST (bf_test, check_max_wrap_around)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);

  bf.FromString("<>");
  bf.Run();

  ASSERT_EQ(bf.GetCellPos(), 0);
}

TEST (bf_test, hello_world_by_primo)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);

  bf.OutputMode(bfi::Brainfuck::OutputMode::raw);

  // https://esolangs.org/wiki/Brainfuck#Examples primo's hello world in brainfuck
  bf.FromString("--<-<<+[+[<+>--->->->-<<<]>]<<--.<++++++.<<-..<<.<+.>>.>>.<<<.+++.>>.>>-.<<<+.");
  bf.Run();

  ASSERT_EQ(ss.str(), "Hello, World!");
}

TEST (bf_test, simple_validation)
{
  {
    std::stringstream ss;
    bfi::Brainfuck bf(ss);
    bf.FromString("[[[.]]");
    ASSERT_EQ(bf.Validate(), bfi::Brainfuck::Status::error);
  }

  {
    std::stringstream ss;
    bfi::Brainfuck bf(ss);
    bf.FromString("[[[.]]]");
    ASSERT_EQ(bf.Validate(), bfi::Brainfuck::Status::success);
  }
}

TEST (bf_test, ignore_non_brainfuck)
{
  ASSERT_EQ(RunBF("this is part.brainfuck+part.non+brainfuck."), "012");
}
