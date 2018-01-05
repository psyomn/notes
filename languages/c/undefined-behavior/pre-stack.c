#include <stdio.h>

int main(void) {
  int k = 1337;

  *(&k - 1) = 7331;
  *(&k - 2) = 9332;

  int i;
  int j;

  printf("k p:%p v:%d\n", &k, k);
  printf("i p:%p v:%d\n", &i, i);
  printf("j p:%p v:%d\n", &j, j);

  return 0;
}
