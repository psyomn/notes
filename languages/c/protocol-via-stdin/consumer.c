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
    int curr = 0;

    while ((curr = getc(resin))) {
        printf("got: %x\n", curr);
    }

    fclose(resin);

    return 0;
}
