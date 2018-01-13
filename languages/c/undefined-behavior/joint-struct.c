#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// might not be 100% undefined behavior...

struct a {
  uint32_t a;
  uint16_t b;
  uint16_t c;
};

struct b {
  uint16_t a;
  uint16_t b;
  uint32_t c;
};

int main(void)
{
  struct a* _a = calloc(1, sizeof(*_a));
  struct b* _b = calloc(1, sizeof(*_b));
  struct a* _t = _a;

  _a->a = 0xAAAEAAAD;
  _a->b = 0xBBBB;
  _a->c = 0xCCCC;

  _b->a = 0xAAAD;
  _b->b = 0xBBBB;
  _b->c = 0xCCCACCCB;

  _a = (struct a*) _b;
  _b = (struct b*) _t;

  printf("%llx\n", _a->a);
  printf("%llx\n", _a->b);
  printf("%llx\n\n", _a->c);

  printf("%llx\n", _b->a);
  printf("%llx\n", _b->b);
  printf("%llx\n", _b->c);

  free(_a);
  free(_b);

  return 0;
}
