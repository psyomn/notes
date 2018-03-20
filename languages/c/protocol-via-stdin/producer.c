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

struct coordinate* make_coords(size_t num) {
    int fd = open("/dev/random", O_RDONLY);
    struct coordinate* coords = calloc(num, sizeof(*coords));
    uint64_t settings[num];

    read(fd, settings, num * sizeof(settings));
    close(fd);

    for (size_t i = 0; i < num; ++i) {
        coords[i] = (struct coordinate) {
            .x = settings[i] & 0xFFFF
        };
    }

    return coords;
}

int main(int argc, char* argv[]) {
    (void) argc, (void) argv;

    FILE* sout = freopen(NULL, "wb", stdout);
    uint8_t bytes[] = { 1, 2, 3, 4, 5, 0};
    size_t len = sizeof(bytes) / sizeof(bytes[0]);

    fwrite(bytes, sizeof(bytes[0]), len, sout);
    return 0;
}
