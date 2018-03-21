#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

struct coordinate {
    int64_t x;
    int64_t y;
    int64_t z;
};

int main(int argc, char* argv[]) {
    (void) argc, (void) argv;

    FILE* resin = freopen(NULL, "rb", stdin);
    uint64_t len = 0;

    if (!fread(&len, sizeof(len), 1, resin)) {
        fprintf(stderr, "could not read from redirected stdin\n");
        return -1;
    }

    printf("will read %zu item(s)\n", len);
    struct coordinate *coords = calloc(len, sizeof(*coords));
    fread(coords, sizeof(*coords), len, resin);

    for (size_t i = 0; i < len; ++i) {
        printf("coord: x:%zu y:%zu z:%zu\n",
               (coords + i)->x,
               (coords + i)->y,
               (coords + i)->z);
    }

    fclose(resin);

    return 0;
}
