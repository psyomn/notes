#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define OP_HALT  0x00
#define OP_LOADI 0x01
#define OP_ADD   0x02
#define OP_PREG  0x03

struct tiny_vm_state {
  uint64_t pc;
  uint64_t reg[8];
};

struct tiny_vm_program {
  size_t len;
  uint64_t* bytecode;
};

struct tiny_vm_state *tiny_vm_new() {
  return calloc(1, sizeof(struct tiny_vm_state));
}

void tiny_vm_free(struct tiny_vm_state* vm) {
  assert(vm);
  free(vm);
}

int tiny_vm_run_bytecode(struct tiny_vm_state* vm, struct tiny_vm_program* program) {
  assert(vm); assert(program);

  while (1) {
    const uint64_t current = program->bytecode[vm->pc];

    switch (current) {
    case OP_HALT:
      printf("halt!\n");
      return 0;
      break;
    case OP_LOADI:
      break;
    case OP_ADD:
      break;
    case OP_PREG:
      printf("print op!\n");
      break;
    }

    vm->pc++;
  }
}

int main(int argc, char *argv[]) {
  struct tiny_vm_state* vm = tiny_vm_new();

  if (argc < 2) {
    printf("Usage:\n%s <program>\n", argv[0]);
    return -1;
  }

  struct stat stt = {0};

  const char* fname = argv[1];

  if (stat(fname, &stt) == -1) {
    printf("can't stat file: %s\n", fname);
    return -1;
  }

  if (stt.st_size % sizeof(uint64_t) != 0) {
    printf("malformed bytecode\n");
    return -1;
  }

  int fd = open(fname, O_RDONLY);
  uint64_t *bytecode = calloc(stt.st_size / sizeof(*bytecode), sizeof(*bytecode));

  if (read(fd, bytecode, stt.st_size) == -1) {
    printf("could not read program file\n");
    return -1;
  }

  struct tiny_vm_program program = { .len = stt.st_size / sizeof(*bytecode), bytecode };

  tiny_vm_run_bytecode(vm, &program);

  close(fd);
  tiny_vm_free(vm);
  return 0;
}
