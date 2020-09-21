#pragma once

#include <filesystem>
#include <string>
#include <vector>
#include <fstream>
#include <streambuf>
#include <cstdint>
#include <cstddef>

namespace bfi {
class Brainfuck {
 public:
  enum Status { error, started, executing, success, failure };
  enum OutputMode { raw, text };

  Brainfuck(std::ostream& stream) :
    mMaxCells(300000),
    mStatus(Status::started),
    mCellPos(0),
    mCodePos(0),
    mCode(""),
    mCells(std::vector<std::uint8_t>(mMaxCells, 0)),
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

  inline Status GetStatus() const { return mStatus; }
  inline int GetExitCode() const { return mStatus == Status::success ? 0 : 1; }
  inline std::size_t GetCellPos() const { return mCellPos; }
  inline std::size_t GetMaxNumCells() const { return mMaxCells; }

  enum Status Validate();
  inline void OutputMode(enum OutputMode outputMode) { mOutputMode = outputMode; }

 private:
  const std::size_t mMaxCells;
  enum Status mStatus;
  std::size_t mCellPos;
  std::size_t mCodePos;
  std::string mCode;
  std::vector<std::uint8_t> mCells;
  enum OutputMode mOutputMode;
  std::ostream& mOutputStream;
};
}
