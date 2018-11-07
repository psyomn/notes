#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

const static char const * plugin_name_1 = "./plugin1.so";
const static char const * plugin_name_2 = "./plugin2.so";

void* load_handle(const char* plugin_name) {
  void *handle = dlopen(plugin_name, RTLD_LAZY);

  if (!handle) {
    fprintf(stderr, "problem loading plugin: %s\n", dlerror());
    exit(EXIT_FAILURE);
  }
  char *s = NULL;

  if ((s = dlerror())) fprintf(stderr, "error: %s\n", s);

  return handle;
}

int main(void) {
  void *handle_1 = load_handle(plugin_name_1);
  void *handle_2 = load_handle(plugin_name_2);

  int (*fn1)(int);
  fn1 = dlsym(handle_1, "execute");

  int (*fn2)(int);
  fn2 = dlsym(handle_2, "execute");

  printf("run fn1: %d\n", fn1(10));
  printf("run fn2: %d\n", fn2(10));

  dlclose(handle_1);
  dlclose(handle_2);

  return 0;
}
