#include <stdio.h>
#include "tinybmp.c"

// fnv1 is bad
// fnv1a is better
// siphash2 kind of fast, and quite secure
// id function is not bad for ints

struct hash {
    size_t capacity;
    size_t usage;
};

int main() {
    dbmp_write_sample_file();
    return 0;
}
