#include "types.h"
#include "stat.h"
#include "user.h"

/*
  Do not edit this file. Add your assembly to sumtofunc.S.
 */

extern int sumto(int);

int main(int argc, char **argv) {
  int n, sum;

  if (argc != 2) {
    printf(2, "usage: sumto <number>\n");
    exit();
  }

  n = atoi(argv[1]);
  sum = sumto(n);

  printf(1, "sum: %d\n", sum);
  exit();
}
