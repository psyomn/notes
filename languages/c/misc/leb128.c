#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

void uleb128(const char* number_string) {
  const size_t len = strnlen(number_string, 24);
  uint64_t result = 0;
  uint8_t* p = (uint8_t*) &result;

  for (size_t x = 0; x < len; ++x) {
    result = (result << 3) + (result << 1);

    const uint8_t c = number_string[x];
    if (!(c >= 0x30 && c <= 0x39)) goto error;

    const uint64_t to_add = c - 0x30;
    if (result > ((~(uint64_t)(0)) - to_add)) goto error;
      
    result += to_add;
  }

  for (size_t x = 0; x < sizeof(result); ++x) {
    uint8_t current = *p;
    uint8_t bits = current & (0xF >> 1);
    result >>= 7;

    if (result != 0) bits |= ~(0XF >> 1);

    printf("%x ", bits);
  }

  return;

error:
  fprintf(stderr, "supply only 64bit unsigned numbers\n");
  exit(-1);
}

void sleb128() {
  fprintf(stdout, "todo");
}

int main(int argc, char* argv[]) {
  if (argc <= 1) {
    fprintf(stdout,
	    "Usage:\n"
	    "  leb128 <big-big-number>\n");
    return -1;
  }

  if (argv[1][0] == '-') {
    sleb128();
  }
  else {
    uleb128(argv[1]);
  }

  return 0;
}
