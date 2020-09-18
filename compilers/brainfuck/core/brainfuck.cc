#include "brainfuck.h"

#include <iostream>

namespace bfi {
  void Brainfuck::FromFile(const std::filesystem::path& path) {
    std::ifstream t(path);

    std::stringstream buffer;
    buffer << t.rdbuf();
    mCode = buffer.str();
    std::cout << mCode << std::endl;
  }

  void Brainfuck::FromString(const std::string& str) {
    mCode = str;
  }

  void Brainfuck::MoveCursor(enum CursorDirection direction) {
    switch (direction) {
    case CursorDirection::right: ++mCellPos; break;
    case CursorDirection::left: --mCellPos; break;
    }
  }

  inline void Brainfuck::IncrCell() { mCells[mCellPos] += 1; }
  inline void Brainfuck::DecrCell() { mCells[mCellPos] -= 1; }

  void Brainfuck::InputChar() {
    // TODO think of a better way, to make the following more testable
    char input = 0;
    std::cin >> input;
    mOutputStream << input;
  }

  void Brainfuck::OutputChar() {
    switch (mOutputMode) {
    case OutputMode::text:
      mOutputStream << std::hex << int(mCells[mCellPos]);
      break;
    case OutputMode::raw:
      mOutputStream << mCells[mCellPos];
      break;
    }
  }

  void Brainfuck::Run() {
    enum Status currentStatus = executing;

    while (currentStatus == Status::executing) {
      switch (mCode[mCodePos]) {
      case '+': IncrCell();   break;
      case '-': DecrCell();   break;
      case '.': OutputChar(); break;
      case ',': InputChar();  break;
      case '[': JumpLBrack(); break;
      case ']': JumpRBrack(); break;
      case '>': MoveCursor(CursorDirection::right); break;
      case '<': MoveCursor(CursorDirection::left);  break;
      }

      ++mCodePos;
      if (mCodePos > mCode.size()) currentStatus = Status::success;
    }
  }

  void Brainfuck::JumpLBrack() {
    if (mCells[mCellPos] != 0) return;

    std::size_t skip = 0;

    ++skip;

    while (skip) {
      ++mCodePos;
      switch(mCode[mCodePos]) {
      case '[': ++skip; break;
      case ']': --skip; break;
      }
    }
  }

  void Brainfuck::JumpRBrack() {
    // TODO: remove mBrackDepth
    std::size_t skip = 0;
    --mCodePos;
    ++skip;

    while (skip) {
      switch (mCode[mCodePos]) {
      case ']': ++skip; break;
      case '[': --skip; break;
      }

      --mCodePos;
    }
  }

  Brainfuck::Status Brainfuck::Validate() {
    // TODO
  }
}
