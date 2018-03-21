#include <time.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

struct coordinate {
    int64_t x;
    int64_t y;
    int64_t z;
};

enum make_config { zero = 0, gen_rand = 1, seq = 2 };

struct coordinate* make_coords(size_t num, enum make_config conf) {
    int fd = open("/dev/random", O_RDONLY);
    struct coordinate* coords = calloc(num, sizeof(*coords));
    if (conf == zero) return coords;

    uint64_t settings[num];
    read(fd, settings, num * sizeof(settings));
    close(fd);

    if (conf == gen_rand) {
        for (size_t i = 0; i < num; ++i) {
            coords[i] = (struct coordinate) {
                .x = settings[i] & 0xFFFF,
                .y = (settings[i] & 0xFFFF0000) >> 16,
                .z = (settings[i] & 0xFFFF00000000) >> 32,
            };
        }
    }

    if (conf == seq) {
        for (size_t i = 0; i < num; ++i) {
            coords[i] = (struct coordinate) { .x = i, .y = i, .z = i };
        }
    }

    return coords;
}

int main(int argc, char* argv[]) {
    (void) argc, (void) argv;
    FILE* sout = freopen(NULL, "wb", stdout);
    size_t len = 100000;
    struct coordinate* coords = make_coords(len, seq);
    fwrite(&len, sizeof(uint64_t), 1, sout);
    fwrite(coords, sizeof(coords[0]), len, sout);
    free(coords);
    return 0;
}
