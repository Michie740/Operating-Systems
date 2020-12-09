#include "types.h"
#include "stat.h"
#include "user.h"

struct stats{
    int wtime;
    int rtime;
    int iotime;
    int status;
}

int main(){
    int wtime;
    int rtime;
    int iotime;
    int status;
    status = wait_stat(&wtime, &rtime, &iotime, &status);
    return 0;
}