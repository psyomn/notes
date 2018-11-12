#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <unistd.h>

const static char const * PLUGIN_NAME = "./plugin.so";

void recompile(size_t count) {
  const char const * cc = "gcc";
  char buffer[1024] = {0};
  int ret = 0;

  sprintf(buffer, "%s -D SOME_CONSTANT=%lu -fPIC -c plugin.c -o plugin.o", cc, count);
  ret = system(buffer);
  if (ret != 0) {
    fprintf(stderr, "problem compiling plugin: %d \n", ret);
    abort();
  }

  buffer[0] = 0;
  sprintf(buffer, "%s -shared -o plugin.so plugin.o", cc);
  system(buffer);
  if (ret != 0) {
    fprintf(stderr, "problem making so: %d \n", ret);
    abort();
  }
}

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
  const size_t max = 100;

  for (size_t i = 0; i < max; ++i) {
    void *handle = load_handle(PLUGIN_NAME);
    int (*fn)(int);
    fn = dlsym(handle, "execute");
    printf("run fn: %d\n", fn(10));
    dlclose(handle);

    if (i % 10 == 0) {
      recompile(i);
    }

    sleep(1);
  }

  return 0;
}
