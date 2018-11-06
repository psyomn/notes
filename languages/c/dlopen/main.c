#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

void usage(char *name) {
  printf("usage: \n"
         "%s <dl>\n", name);
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    usage(argv[0]);
    exit(1);
  }

  char *error = NULL;
  void *handle = dlopen(argv[1], RTLD_LAZY);
  int (*pluginfunc)(int);

  if (!handle) {
    fprintf(stderr, "problem loading plugin: %s\n", dlerror());
    exit(EXIT_FAILURE);
  }
  dlerror();

  /* name of function you want to act as a pluggable interface */
  pluginfunc = dlsym(handle, "execute");

  error = dlerror();
  if (error) {
    fprintf(stderr, "error: %s\n", error);
    exit(EXIT_FAILURE);
  }

  printf("pluginfunc result: %d\n", pluginfunc(10));

  dlclose(handle);

  return 0;
}
