#include <stdio.h>

#define begin {
#define end }
#define mod %
#define eq ==

int main(void) {
  int x;

  for (x = 0; x < 10; ++x) begin
    if (x mod 2 eq 0) begin
      printf("%d is even!\n", x);
    end
  end
  return 0;
}
