#include "types.h"
#include "stat.h"
#include "user.h"

//start and immediately fork 20 child process
//each child does something that uses at least 30 clock ticks
//exit with exit status equal to its pid

//parent print pid wtim rtime turnaround time for each child



int main(){

//checking
    int pid;
    int wtime = 0;
    int rtime = 0;
    int iotime = 0;

    int i;
    int ticker = 0;
    int sum;
    sum = 0;
    for (i = 0; i < 20; i++){
        pid = fork();
        //comparing pid
        if (pid == 0){ //ischild

            //30 ticks time consuming computation
/*             ticker = uptime();
            while (uptime() < ticker + 30){} */
            while (ticker < 100000000){ticker++;}
            exit();
        }
        else{
            int status = wait_stat(&wtime, &rtime, &iotime, &status); //waiting
            printf(1, "pid: %d | ready: %d | running: %d \n", status, wtime, rtime); 
            printf(1, "turnaround time: %d \n", (wtime + rtime + iotime));
            sum += (wtime + rtime + iotime);
        }
    }
    printf(1, "Avg turnaround time: %d\n", (sum/20));
    exit();
}