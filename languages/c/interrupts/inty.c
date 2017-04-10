#include <unistd.h>
#include <stdio.h>
#include <signal.h>

void handle_sigsegv(int _d)
{
  printf("caught sigsegv\n");
}

void handle_sigkill(int _d)
{
  printf("caught sigkill");
}

void handle_sigint(int _d)
{
  printf("caught sigint");
}

void handle_sigquit(int _d)
{
  printf("quit stuff");
}

int main(void) {
  printf("Hello world\n");

  signal(SIGSEGV, handle_sigsegv);
  signal(SIGKILL, handle_sigkill);
  signal(SIGINT, handle_sigint);
  signal(SIGQUIT, handle_sigquit);

  while (1) {
    printf("ZzzzzzzZ ZZZZZZZZZZ \n");
    sleep(1);
  }

  return 0;
}
