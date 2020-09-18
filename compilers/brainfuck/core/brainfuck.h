#pragma once

#include <filesystem>
#include <string>
#include <vector>
#include <fstream>
#include <streambuf>
#include <cstdint>

namespace bfi {
class Brainfuck {
 public:
  enum Status { error, started, executing, success, failure };
  enum OutputMode { raw, text };

  Brainfuck(std::ostream& stream) :
    mExitCode(Status::started),
    mCellPos(0),
    mCodePos(0),
    mBrackDepth(0),
    mCode(""),
    mCells(std::vector<std::uint8_t>(300000, 0)),
    mOutputMode(OutputMode::text),
    mOutputStream(stream) {}

  Brainfuck(Brainfuck& other) = delete;
  Brainfuck(Brainfuck&& other) = delete;
  Brainfuck& operator=(Brainfuck&& other) = delete;
  ~Brainfuck() {};

  void FromFile(const std::filesystem::path& path);
  void FromString(const std::string& str);
  void Run();

  enum CursorDirection { left, right };
  void MoveCursor(enum CursorDirection direction);

  inline void IncrCell();
  inline void DecrCell();

  void OutputChar();
  void InputChar();

  void JumpLBrack();
  void JumpRBrack();

  inline Status GetStatus() const { return mExitCode; }
  inline int GetExitCode() const { return mExitCode == Status::success ? 0 : 1; }

  Status Validate();
 private:
  enum Status mExitCode;
  std::size_t mCellPos;
  std::size_t mCodePos;
  std::size_t mBrackDepth;
  std::string mCode;
  std::vector<std::uint8_t> mCells;
  enum OutputMode mOutputMode;
  std::ostream& mOutputStream;
};
}
