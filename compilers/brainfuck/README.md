# BRAINFUCK

Simple BRAINFUCK interpreter without anything too fancy.

You can interpret a program this way:

```c++
  std::stringstream ss;
  bfi::Brainfuck bf(ss);
  bf.FromString("++++.");
  bf.Run();
  return ss.str();
```

NB: The above outputs values in hex. If you want raw output, you will
need to add this line before interpretation:

```c++
  std::stringstream ss;
  bfi::Brainfuck bf(ss);
  bf.OutputMode(bfi::Brainfuck::OutputMode::raw);
```
