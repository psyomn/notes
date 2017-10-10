#pragma once

#include <stdint.h>
#include <strings.h>
#include <stdlib.h>

struct bmp_header {
    uint16_t magic;
    uint32_t filesize;
    uint16_t reserved_1;
    uint16_t reserved_2;
    uint32_t offset;
};

struct dib_header {
    uint8_t placeholder[12];
};

void write_bmp_header(FILE* _f) {
}

void write_dib_header(FILE* _f) {
}

void dbmp_write_sample_file() {

    struct bmp_header header;

    printf("bmp_header: %zu\n", sizeof(struct bmp_header));
    printf("dib_header: %zu\n", sizeof(struct dib_header));

    header.magic      = ('M' << 8) + 'B';

    header.reserved_1 = ('P' << 8) + 'S';
    header.reserved_2 = ('Y' << 8) + 'O';
    header.offset     = sizeof(struct bmp_header)
                      + sizeof(struct dib_header);

    FILE* file = fopen("sample.bmp", "w");
    if (!file) goto error;

    /* write bmp header */
    fwrite(&header.magic, sizeof(header.magic), 1, file);
    fwrite(&header.reserved_1, sizeof(header.reserved_1), 1, file);
    fwrite(&header.reserved_2, sizeof(header.reserved_2), 1, file);
    fwrite(&header.offset, sizeof(header.offset), 1, file);

    fclose(file);

    return;

error:
    fprintf(stderr, "could create new file, aborting");
    exit(-1);
}
