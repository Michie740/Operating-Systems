#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

/*
Read through adding to lines[x] until you hit \n,
then you add to the next one*/

//to account for strings
char buf[512];
char buf2[512];

//using malloc to resize the array that holds onto the chars (doubles when array gets filled)
char* doubleSize(char* source, int originalLength){
    char* new;
    new = (char*)malloc(originalLength * 2);
    int i;
    for (i = 0; i < originalLength; i++){
        new[i] = source[i];
    }
    free(source);
    return new;
}

//file descriptor, name, how many lines, subtract howmany, 1 = change 
//-n 3 just uses the linenumber no change bc only how many lines to print
//-n +8 will have an offset, and the code will detect an offset
//whichC = 1 = tailaddchar
//whichC = 2 = tailjustChar
//these two also use offsets but we first check to see if whichC is not 0 so it doesnt interfere
void tail(int fd, char *name, int linenumber, int offset, int whichC){
    int i, n, m, lineSize;
    int lesser;
    int linenumreplace;
    int charcount;
    int thisC;

    lesser = charcount = 0;

    //will be changing it so dont want to change input
    thisC = whichC;

    //512 is the max buffer value we got, if line is greater, then we will act accordingly
    char* eachLine;
    eachLine = (char*)malloc(512);

    //keeps track of how many chars are in eachLine (tells us when to double)
    int doubler;
    doubler = 512;

    //tells us where to insert into eachLine
    int startLine;
    
    //for that file in stream
    //gotta create it, then write to it, and read from it
    int fd2 = open("destroy", O_CREATE | O_RDWR);
    
    //countnumber of lines + count number of chars while we're at it 
    while ((n = read(fd, buf, sizeof(buf))) > 0){
        write(fd2, buf, n);
        for (i = 0; i < n; i++){
            charcount++;
            if (buf[i] == '\n'){
                lesser++;
            }
        }
    }

    close(fd);
    close(fd2);

    //opening temp file
    fd2 = open("destroy", 0);

    if (thisC != 1 && thisC != 2){
        if (offset != 0){
            //print everything but the offset number
            //for -n +8
            linenumreplace = lesser - offset;
        }
        else{
            //print lines
            //for regular tail + for -n 3
            linenumreplace = linenumber;
        }  
    }
    //for -c +8
    //read through the chars first (will end if offset > chars in file)
    else if (thisC == 1){
        read(fd2, buf2, offset);
        linenumreplace = lesser;
    }
    //for -c 8 will print out everything
    else{
        linenumreplace = lesser;
    }

    while((m = read(fd2, buf2, sizeof(buf2))) > 0){
        for (lineSize = 0; lineSize < m; lineSize++){
            if (thisC == 2){
                //to read out all chars after the offset
                if (charcount > offset){
                    charcount--;
                }
                //then after that, run the func like we would normally do
                else if (charcount == offset){
                    thisC = 0;
                }
            }
            //getting to the last x number of lines + preventing -c 8 from messing up
            if (thisC != 2 && lesser > linenumreplace){
                if (buf2[lineSize] == '\n'){
                    lesser--;
                }
            }
            //writing the lines preventing -c 8 from messing up
            else if (thisC != 2 && lesser <= linenumreplace){
                //write and reset everything
                if (buf2[lineSize] == '\n'){
                    write(1, eachLine, startLine);
                    printf(1, "\n");
                    startLine = 0;
                    free(eachLine);
                    eachLine = (char*)malloc(512);
                    doubler = 512;
                }
                else{
                    //if the line array is full, double it
                    if (startLine == doubler){
                        eachLine = doubleSize(eachLine, doubler);
                        doubler = doubler * 2;
                    }
                    //insert to array and increment the locator thing
                    eachLine[startLine] = buf2[lineSize];
                    startLine++;
                }
            }
        }
    }
    
    //clean up
    free(eachLine);
    close(fd2);
    unlink("destroy");

    if(n < 0){
        printf(1, "wc: read error\n");
        exit();
    }
    exit();
}   

int 
main(int argc, char* argv[]){

    //fd is the file descriptor (entry number)
    int fd;

    //if there are no arguments (files) 
    if (argc <= 1){
        //when its 0 its standard input
        tail(0, "", 10, 0, 0);
        exit();
    }

    //file input
    else if (argc == 2){
        if ((fd = open(argv[1], 0)) < 0){
            printf(1, "tail: cannot open %s\n", argv[1]);
            exit();
        }
        tail(fd, argv[1], 10, 0, 0);
    }

    //extensions
    else if (argc == 4){
        int val;
        char num[1024];
        if ((fd = open(argv[3], 0)) < 0){
            printf(1, "tail: cannot open %s\n", argv[3]);
            exit();
        }
        if (argv[1][0] == '-'){
            if (argv[1][1] == 'n'){
                if (argv[2][0] == '+'){
                    strcpy(num, argv[2]);
                    char *copy;
                    copy = num;
                    //to get next value
                    copy++;
                    val = atoi(copy);
                    if (val == 0){
                        printf(1, "tail: Either you put a bad number, or you put in 0, and then whats the point then?\n");
                        exit();
                    }
                    tail(fd, argv[3], 0, val - 1, 0);
                }
                else{
                    val = atoi(argv[2]);
                    if (val == 0){
                        printf(1, "tail: Either you put a bad number, or you put in 0, and then whats the point then?\n");
                        exit();
                    }
                    tail(fd, argv[3], val, 0, 0);
                }
            }
            else if (argv[1][1] == 'c'){
                if (argv[2][0] == '+'){
                    strcpy(num, argv[2]);
                    char *copy;
                    copy = num;
                    //to get next value
                    copy++;
                    val = atoi(copy);
                    if (val == 0){
                        printf(1, "tail: Either you put a bad number, or you put in 0, and then whats the point then?\n");
                        exit();
                    }
                    tail(fd, argv[3], 0, val - 1, 1);
                }
                else{
                    val = atoi(argv[2]);
                    if (val == 0){
                        printf(1, "tail: Either you put a bad number, or you put in 0, and then whats the point then?\n");
                        exit();
                    }
                    tail(fd, argv[3], 0, val, 2);
                }
            }
            else{
                printf(1, "tail:  not valid command\n");
                exit();
            }
        }
        else{
            printf(1, "tail: I can't work with the amount of inputs you gave :(\n");
            exit();
        }
    }
    printf(1, "tail: INput INvalid IMbecile\n");
    exit();
}