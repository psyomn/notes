#include <stdio.h>

#define BADMAC a += a;

int main(void) {
  int a = 1, b = 2, c = 0;

  BADMAC;

  c = a + b;

  printf("I expected a + b = %d\n", 3);
  printf("But I actually got a + b = %d\n", c);
  return 0;
}

/** output:

  I expected a + b = 3
  But I actually got a + b = 4

*/
