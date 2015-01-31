#include <stdio.h>

#define GENERIC_SUM(T) \
  T sum_ ## T (T A, T B) { \
    return A + B;   \
  }

GENERIC_SUM(int);
GENERIC_SUM(float);
GENERIC_SUM(double);

int main(void) {
  int    x = sum_int(1, 2);
  float  y = sum_float(12.32f, 32.11f);
  double z = sum_double(99.0123f, 312.123123f);

  printf("%d\n", x);
  printf("%f\n", y);
  printf("%f\n", z);

  return 0;
}

