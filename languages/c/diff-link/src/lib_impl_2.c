#include <stdio.h>
#include "lib_spec.h"

void
print_message() {
  printf("Badly implemented library!!\n"
      "Add is not add!!i\n");
}

int
add(int potato, int yotato) {
  return potato + yotato - 1;
}
