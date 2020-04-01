#define _GNU_SOURCE

#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

// statx is the new stat. You can still get by with stat, but stat
// lacks network filesystem features, in case you need a loopback
// against that server for information.

#include <stdio.h>

int main(int argc, char *argv[]) {
  (void) argc;

  struct statx stx = {0};

  if (statx(AT_FDCWD, argv[0], 0, 0, &stx) != 0) {
    perror("something went wrong");
    exit(EXIT_FAILURE);
  }

  printf("some minor file information!\n");
  printf("| mode               | %o\n", stx.stx_mode);
  printf("| blksize            | %u\n", stx.stx_blksize);
  printf("| uid                | %d\n", stx.stx_uid);
  printf("| groupid            | %d\n", stx.stx_gid);
  printf("| size               | %llu\n", stx.stx_size);
  printf("| blocks             | %llu\n", stx.stx_blocks);
  printf("| last access        | %lld\n", stx.stx_atime.tv_sec);
  printf("| creation           | %lld\n", stx.stx_btime.tv_sec);
  printf("| last status change | %lld\n", stx.stx_ctime.tv_sec);
  printf("| last modification  | %lld\n", stx.stx_mtime.tv_sec);

  return EXIT_SUCCESS;
}
