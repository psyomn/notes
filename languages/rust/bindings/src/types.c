#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void nothing() { return; }
void one_param(const uint32_t x) {}

size_t string_length(const char* str) {
  return strlen(str);
}

struct simple {
  uint16_t one;
  uint16_t two;
  uint32_t three;
  uint64_t four;
};

struct simple*
create_simple() {
  struct simple* spl = malloc(sizeof(struct simple));

  spl->one = 1;
  spl->two = 2;
  spl->three = 3;
  spl->four = 4;

  return spl;
}

void
free_simple(struct simple* _s) {
  free(_s);
}

uint16_t
simple_get_first(struct simple* _s) {
  return _s->one;
}

uint32_t
simple_get_third(struct simple* _s) {
  return _s->three;
}

uint64_t
simple_get_fourth(struct simple* _s) {
  return _s->four;
}
