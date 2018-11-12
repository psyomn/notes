#ifndef SOME_CONSTANT
#define SOME_CONSTANT (1)
#endif
#include <stdio.h>

int execute(int i) {
  printf("plugin constant: %d\n", SOME_CONSTANT);
  return i * 2;
}
