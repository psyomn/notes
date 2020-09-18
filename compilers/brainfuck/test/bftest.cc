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

TEST (bf_test, zero_all_right)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);
  bf.FromString("++++>++++>++++>++++<<<<[[-]>]<<<<.>.>.>.");
  bf.Run();

  ASSERT_EQ(ss.str(), "0000");
}

TEST (bf_test, hello_world_by_primo)
{
  std::stringstream ss;
  bfi::Brainfuck bf(ss);
  // https://esolangs.org/wiki/Brainfuck#Examples
  bf.FromString("--<-<<+[+[<+>--->->->-<<<]>]<<--.<++++++.<<-..<<.<+.>>.>>.<<<.+++.>>.>>-.<<<+.");
  bf.Run();

  ASSERT_EQ(ss.str(), "arg");
}

// TEST (bf_test, broken_loop_test)
// {
//   {
//     std::stringstream ss;
//     bfi::Brainfuck bf(ss);
//     bf.FromString("[");
//     bf.Run();
//   }
//   {
//     std::stringstream ss;
//     bfi::Brainfuck bf(ss);
//     bf.FromString("++++[");
//   }
// }
