#include <stdio.h>
#include "lib_spec.h"

int
main(void) {
  print_message();
  printf("1 + 2 = %d\n", add(1,2));
  return 0;
}
