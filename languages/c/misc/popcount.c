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

uint8_t
naive_popcount(uint64_t var) {
  const uint64_t a = var;
  const uint64_t b1 = a        & 0x5555555555555555;
  const uint64_t b2 = (a >> 1) & 0x5555555555555555;
  const uint64_t c  = b1 + b2;
  const uint64_t d1 = c        & 0x3333333333333333;
  const uint64_t d2 = (c >> 2) & 0x3333333333333333;
  const uint64_t e  = d1 + d2;
  const uint64_t f1 = e        & 0x0f0f0f0f0f0f0f0f;
  const uint64_t f2 = (e >> 4) & 0x0f0f0f0f0f0f0f0f;
  const uint64_t g = (f1 + f2);
  const uint64_t h1 = g        & 0x00ff00ff00ff00ff;
  const uint64_t h2 = (g >> 8) & 0x0000ffff0000ffff;
  const uint64_t j = (h1 + h2);
  const uint64_t k1 = j & 0x00000000ffffffff;
  const uint64_t k2 = (j >> 16) & 0x00000000ffffffff;
  return k1 + k2;
}


int main(void) {
  for (size_t x = 0; x < 30; ++x) {
    printf("popcount(%zu) = %d\n", x, bad_popcount(x));
  }

  printf("hamming distance: %d\n", hamming_distance(0b1100, 0b0110));

  printf("builtin popcount: %d\n", cpu_popcount(0b1111));

  printf("smarter popcount: %d\n", naive_popcount(0x0));
  printf("smarter popcount: %d\n", naive_popcount(0b1011));
  printf("smarter popcount: %d\n", naive_popcount(0b100101011));
  printf("smarter popcount: %d\n", naive_popcount(0b110111010110001111011));
	 
  return 0;
}
