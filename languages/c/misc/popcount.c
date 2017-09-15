#include <stdio.h>
#include <stdint.h>

uint8_t
bad_popcount(uint64_t var) {
  uint8_t ret = 0;
  for (size_t x = 0; x < 64; ++x) {
    ret += var & 1;
    var >>= 1;
  }
  return ret;
}

uint8_t
cpu_popcount(uint64_t var) {
  return __builtin_popcount(var);
}

uint8_t
hamming_distance(a, b) uint64_t a, b; {
  return bad_popcount(a ^ b);
}

int main(void) {
  for (size_t x = 0; x < 30; ++x) {
    printf("popcount(%zu) = %d\n", x, bad_popcount(x));
  }

  printf("hamming distance: %d\n", hamming_distance(0b1100, 0b0110));

  printf("builtin popcount: %d\n", cpu_popcount(0b1111));
	 
  return 0;
}
