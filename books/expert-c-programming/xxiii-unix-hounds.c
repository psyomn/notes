#include <stdio.h>
#include <time.h>
#include <stdint.h>

int main(void) {
  const time_t now = time(NULL);
  time_t calc_max = 0;

  for (size_t x = 0; x < sizeof(time_t) - 1; ++x) {
    /* The -1 is needed else time_h is too big and segfaults when invoked with ctime */
    calc_max <<= 8;
    calc_max |= 0xF;
  }

  const time_t max = calc_max;
  const char* ascii_time = ctime(&max);
  printf("%s\n", ascii_time);

  printf("sizeof(time_t): %zu\n", sizeof(time_t));
  printf("now: %zu\n", now);
  printf("max: %zu\n", max);
  const double difference = difftime(now, max);

  printf("difference: %f\n", difference);


  return 0;
}
