
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <factorial>:
//start and immediately fork 20 child process
//each child does something that uses 30 clock ticks
//exit with exit status equal to its pid

//parent print pid wtim rtime turnaround time for each child
int factorial(int x){
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
    if (x <= 1){
   a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   e:	7f 07                	jg     17 <factorial+0x17>
        return 1;
  10:	b8 01 00 00 00       	mov    $0x1,%eax
  15:	eb 16                	jmp    2d <factorial+0x2d>
    }
    return factorial(x-1)*x;
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	83 e8 01             	sub    $0x1,%eax
  1d:	83 ec 0c             	sub    $0xc,%esp
  20:	50                   	push   %eax
  21:	e8 da ff ff ff       	call   0 <factorial>
  26:	83 c4 10             	add    $0x10,%esp
  29:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  2d:	c9                   	leave  
  2e:	c3                   	ret    

0000002f <main>:



int main(){
  2f:	f3 0f 1e fb          	endbr32 
  33:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  37:	83 e4 f0             	and    $0xfffffff0,%esp
  3a:	ff 71 fc             	pushl  -0x4(%ecx)
  3d:	55                   	push   %ebp
  3e:	89 e5                	mov    %esp,%ebp
  40:	51                   	push   %ecx
  41:	83 ec 24             	sub    $0x24,%esp
   // int num = 10;
//    int pid = fork();

//checking
    int pid;
    int wtime = 0;
  44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int rtime = 0;
  4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    int iotime = 0;
  52:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

    int i;
    int ticker = 0;
  59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    int sum;
    sum = 0;
  60:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (i = 0; i < 20; i++){
  67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  6e:	e9 8f 00 00 00       	jmp    102 <main+0xd3>
        pid = fork();
  73:	e8 37 03 00 00       	call   3af <fork>
  78:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //comparing pid
        if (pid == 0){ //ischild
  7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  7f:	75 14                	jne    95 <main+0x66>

            //30 ticks time consuming computation
/*             ticker = uptime();
            while (uptime() < ticker + 30){} */
            while (ticker < 100000000){ticker++;}
  81:	eb 04                	jmp    87 <main+0x58>
  83:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  87:	81 7d f0 ff e0 f5 05 	cmpl   $0x5f5e0ff,-0x10(%ebp)
  8e:	7e f3                	jle    83 <main+0x54>
            exit();
  90:	e8 22 03 00 00       	call   3b7 <exit>
        }
        else{
            int status = wait_stat(&wtime, &rtime, &iotime, &status); //waiting
  95:	8d 45 d8             	lea    -0x28(%ebp),%eax
  98:	50                   	push   %eax
  99:	8d 45 dc             	lea    -0x24(%ebp),%eax
  9c:	50                   	push   %eax
  9d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  a4:	50                   	push   %eax
  a5:	e8 ad 03 00 00       	call   457 <wait_stat>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
            printf(1, "pid: %d | ready: %d | running: %d \n", status, wtime, rtime); 
  b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  b9:	83 ec 0c             	sub    $0xc,%esp
  bc:	51                   	push   %ecx
  bd:	52                   	push   %edx
  be:	50                   	push   %eax
  bf:	68 04 09 00 00       	push   $0x904
  c4:	6a 01                	push   $0x1
  c6:	e8 70 04 00 00       	call   53b <printf>
  cb:	83 c4 20             	add    $0x20,%esp
            printf(1, "turnaround time: %d \n", (wtime + rtime + iotime));
  ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  d4:	01 c2                	add    %eax,%edx
  d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  d9:	01 d0                	add    %edx,%eax
  db:	83 ec 04             	sub    $0x4,%esp
  de:	50                   	push   %eax
  df:	68 28 09 00 00       	push   $0x928
  e4:	6a 01                	push   $0x1
  e6:	e8 50 04 00 00       	call   53b <printf>
  eb:	83 c4 10             	add    $0x10,%esp
            sum += (wtime + rtime + iotime);
  ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f4:	01 c2                	add    %eax,%edx
  f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  f9:	01 d0                	add    %edx,%eax
  fb:	01 45 ec             	add    %eax,-0x14(%ebp)
    for (i = 0; i < 20; i++){
  fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 102:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 106:	0f 8e 67 ff ff ff    	jle    73 <main+0x44>
        }
    }
    printf(1, "Avg turnaround time: %d\n", (sum/20));
 10c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 10f:	ba 67 66 66 66       	mov    $0x66666667,%edx
 114:	89 c8                	mov    %ecx,%eax
 116:	f7 ea                	imul   %edx
 118:	c1 fa 03             	sar    $0x3,%edx
 11b:	89 c8                	mov    %ecx,%eax
 11d:	c1 f8 1f             	sar    $0x1f,%eax
 120:	29 c2                	sub    %eax,%edx
 122:	89 d0                	mov    %edx,%eax
 124:	83 ec 04             	sub    $0x4,%esp
 127:	50                   	push   %eax
 128:	68 3e 09 00 00       	push   $0x93e
 12d:	6a 01                	push   $0x1
 12f:	e8 07 04 00 00       	call   53b <printf>
 134:	83 c4 10             	add    $0x10,%esp
    exit();
 137:	e8 7b 02 00 00       	call   3b7 <exit>

0000013c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 141:	8b 4d 08             	mov    0x8(%ebp),%ecx
 144:	8b 55 10             	mov    0x10(%ebp),%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 cb                	mov    %ecx,%ebx
 14c:	89 df                	mov    %ebx,%edi
 14e:	89 d1                	mov    %edx,%ecx
 150:	fc                   	cld    
 151:	f3 aa                	rep stos %al,%es:(%edi)
 153:	89 ca                	mov    %ecx,%edx
 155:	89 fb                	mov    %edi,%ebx
 157:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15d:	90                   	nop
 15e:	5b                   	pop    %ebx
 15f:	5f                   	pop    %edi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    

00000162 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 162:	f3 0f 1e fb          	endbr32 
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 172:	90                   	nop
 173:	8b 55 0c             	mov    0xc(%ebp),%edx
 176:	8d 42 01             	lea    0x1(%edx),%eax
 179:	89 45 0c             	mov    %eax,0xc(%ebp)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	8d 48 01             	lea    0x1(%eax),%ecx
 182:	89 4d 08             	mov    %ecx,0x8(%ebp)
 185:	0f b6 12             	movzbl (%edx),%edx
 188:	88 10                	mov    %dl,(%eax)
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strcpy+0x11>
    ;
  return os;
 191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 196:	f3 0f 1e fb          	endbr32 
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 19d:	eb 08                	jmp    1a7 <strcmp+0x11>
    p++, q++;
 19f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	74 10                	je     1c1 <strcmp+0x2b>
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 10             	movzbl (%eax),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	38 c2                	cmp    %al,%dl
 1bf:	74 de                	je     19f <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 d0             	movzbl %al,%edx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	0f b6 c0             	movzbl %al,%eax
 1d3:	29 c2                	sub    %eax,%edx
 1d5:	89 d0                	mov    %edx,%eax
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strlen>:

uint
strlen(char *s)
{
 1d9:	f3 0f 1e fb          	endbr32 
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ea:	eb 04                	jmp    1f0 <strlen+0x17>
 1ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	01 d0                	add    %edx,%eax
 1f8:	0f b6 00             	movzbl (%eax),%eax
 1fb:	84 c0                	test   %al,%al
 1fd:	75 ed                	jne    1ec <strlen+0x13>
    ;
  return n;
 1ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 202:	c9                   	leave  
 203:	c3                   	ret    

00000204 <memset>:

void*
memset(void *dst, int c, uint n)
{
 204:	f3 0f 1e fb          	endbr32 
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 20b:	8b 45 10             	mov    0x10(%ebp),%eax
 20e:	50                   	push   %eax
 20f:	ff 75 0c             	pushl  0xc(%ebp)
 212:	ff 75 08             	pushl  0x8(%ebp)
 215:	e8 22 ff ff ff       	call   13c <stosb>
 21a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <strchr>:

char*
strchr(const char *s, char c)
{
 222:	f3 0f 1e fb          	endbr32 
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 232:	eb 14                	jmp    248 <strchr+0x26>
    if(*s == c)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	38 45 fc             	cmp    %al,-0x4(%ebp)
 23d:	75 05                	jne    244 <strchr+0x22>
      return (char*)s;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	eb 13                	jmp    257 <strchr+0x35>
  for(; *s; s++)
 244:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 e2                	jne    234 <strchr+0x12>
  return 0;
 252:	b8 00 00 00 00       	mov    $0x0,%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <gets>:

char*
gets(char *buf, int max)
{
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 26a:	eb 42                	jmp    2ae <gets+0x55>
    cc = read(0, &c, 1);
 26c:	83 ec 04             	sub    $0x4,%esp
 26f:	6a 01                	push   $0x1
 271:	8d 45 ef             	lea    -0x11(%ebp),%eax
 274:	50                   	push   %eax
 275:	6a 00                	push   $0x0
 277:	e8 53 01 00 00       	call   3cf <read>
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 286:	7e 33                	jle    2bb <gets+0x62>
      break;
    buf[i++] = c;
 288:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 291:	89 c2                	mov    %eax,%edx
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	01 c2                	add    %eax,%edx
 298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a2:	3c 0a                	cmp    $0xa,%al
 2a4:	74 16                	je     2bc <gets+0x63>
 2a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2aa:	3c 0d                	cmp    $0xd,%al
 2ac:	74 0e                	je     2bc <gets+0x63>
  for(i=0; i+1 < max; ){
 2ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b1:	83 c0 01             	add    $0x1,%eax
 2b4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2b7:	7f b3                	jg     26c <gets+0x13>
 2b9:	eb 01                	jmp    2bc <gets+0x63>
      break;
 2bb:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	01 d0                	add    %edx,%eax
 2c4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <stat>:

int
stat(char *n, struct stat *st)
{
 2cc:	f3 0f 1e fb          	endbr32 
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d6:	83 ec 08             	sub    $0x8,%esp
 2d9:	6a 00                	push   $0x0
 2db:	ff 75 08             	pushl  0x8(%ebp)
 2de:	e8 14 01 00 00       	call   3f7 <open>
 2e3:	83 c4 10             	add    $0x10,%esp
 2e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ed:	79 07                	jns    2f6 <stat+0x2a>
    return -1;
 2ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f4:	eb 25                	jmp    31b <stat+0x4f>
  r = fstat(fd, st);
 2f6:	83 ec 08             	sub    $0x8,%esp
 2f9:	ff 75 0c             	pushl  0xc(%ebp)
 2fc:	ff 75 f4             	pushl  -0xc(%ebp)
 2ff:	e8 0b 01 00 00       	call   40f <fstat>
 304:	83 c4 10             	add    $0x10,%esp
 307:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30a:	83 ec 0c             	sub    $0xc,%esp
 30d:	ff 75 f4             	pushl  -0xc(%ebp)
 310:	e8 ca 00 00 00       	call   3df <close>
 315:	83 c4 10             	add    $0x10,%esp
  return r;
 318:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <atoi>:

int
atoi(const char *s)
{
 31d:	f3 0f 1e fb          	endbr32 
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 327:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32e:	eb 25                	jmp    355 <atoi+0x38>
    n = n*10 + *s++ - '0';
 330:	8b 55 fc             	mov    -0x4(%ebp),%edx
 333:	89 d0                	mov    %edx,%eax
 335:	c1 e0 02             	shl    $0x2,%eax
 338:	01 d0                	add    %edx,%eax
 33a:	01 c0                	add    %eax,%eax
 33c:	89 c1                	mov    %eax,%ecx
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	8d 50 01             	lea    0x1(%eax),%edx
 344:	89 55 08             	mov    %edx,0x8(%ebp)
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	0f be c0             	movsbl %al,%eax
 34d:	01 c8                	add    %ecx,%eax
 34f:	83 e8 30             	sub    $0x30,%eax
 352:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 2f                	cmp    $0x2f,%al
 35d:	7e 0a                	jle    369 <atoi+0x4c>
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	0f b6 00             	movzbl (%eax),%eax
 365:	3c 39                	cmp    $0x39,%al
 367:	7e c7                	jle    330 <atoi+0x13>
  return n;
 369:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36c:	c9                   	leave  
 36d:	c3                   	ret    

0000036e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36e:	f3 0f 1e fb          	endbr32 
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 384:	eb 17                	jmp    39d <memmove+0x2f>
    *dst++ = *src++;
 386:	8b 55 f8             	mov    -0x8(%ebp),%edx
 389:	8d 42 01             	lea    0x1(%edx),%eax
 38c:	89 45 f8             	mov    %eax,-0x8(%ebp)
 38f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 392:	8d 48 01             	lea    0x1(%eax),%ecx
 395:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 398:	0f b6 12             	movzbl (%edx),%edx
 39b:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 39d:	8b 45 10             	mov    0x10(%ebp),%eax
 3a0:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a3:	89 55 10             	mov    %edx,0x10(%ebp)
 3a6:	85 c0                	test   %eax,%eax
 3a8:	7f dc                	jg     386 <memmove+0x18>
  return vdst;
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3af:	b8 01 00 00 00       	mov    $0x1,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <exit>:
SYSCALL(exit)
 3b7:	b8 02 00 00 00       	mov    $0x2,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <wait>:
SYSCALL(wait)
 3bf:	b8 03 00 00 00       	mov    $0x3,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <pipe>:
SYSCALL(pipe)
 3c7:	b8 04 00 00 00       	mov    $0x4,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <read>:
SYSCALL(read)
 3cf:	b8 05 00 00 00       	mov    $0x5,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <write>:
SYSCALL(write)
 3d7:	b8 10 00 00 00       	mov    $0x10,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <close>:
SYSCALL(close)
 3df:	b8 15 00 00 00       	mov    $0x15,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <kill>:
SYSCALL(kill)
 3e7:	b8 06 00 00 00       	mov    $0x6,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <exec>:
SYSCALL(exec)
 3ef:	b8 07 00 00 00       	mov    $0x7,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <open>:
SYSCALL(open)
 3f7:	b8 0f 00 00 00       	mov    $0xf,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <mknod>:
SYSCALL(mknod)
 3ff:	b8 11 00 00 00       	mov    $0x11,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <unlink>:
SYSCALL(unlink)
 407:	b8 12 00 00 00       	mov    $0x12,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <fstat>:
SYSCALL(fstat)
 40f:	b8 08 00 00 00       	mov    $0x8,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <link>:
SYSCALL(link)
 417:	b8 13 00 00 00       	mov    $0x13,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <mkdir>:
SYSCALL(mkdir)
 41f:	b8 14 00 00 00       	mov    $0x14,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <chdir>:
SYSCALL(chdir)
 427:	b8 09 00 00 00       	mov    $0x9,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <dup>:
SYSCALL(dup)
 42f:	b8 0a 00 00 00       	mov    $0xa,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <getpid>:
SYSCALL(getpid)
 437:	b8 0b 00 00 00       	mov    $0xb,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <sbrk>:
SYSCALL(sbrk)
 43f:	b8 0c 00 00 00       	mov    $0xc,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <sleep>:
SYSCALL(sleep)
 447:	b8 0d 00 00 00       	mov    $0xd,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <uptime>:
SYSCALL(uptime)
 44f:	b8 0e 00 00 00       	mov    $0xe,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <wait_stat>:
SYSCALL(wait_stat)
 457:	b8 16 00 00 00       	mov    $0x16,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45f:	f3 0f 1e fb          	endbr32 
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 18             	sub    $0x18,%esp
 469:	8b 45 0c             	mov    0xc(%ebp),%eax
 46c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 46f:	83 ec 04             	sub    $0x4,%esp
 472:	6a 01                	push   $0x1
 474:	8d 45 f4             	lea    -0xc(%ebp),%eax
 477:	50                   	push   %eax
 478:	ff 75 08             	pushl  0x8(%ebp)
 47b:	e8 57 ff ff ff       	call   3d7 <write>
 480:	83 c4 10             	add    $0x10,%esp
}
 483:	90                   	nop
 484:	c9                   	leave  
 485:	c3                   	ret    

00000486 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 486:	f3 0f 1e fb          	endbr32 
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 490:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 497:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49b:	74 17                	je     4b4 <printint+0x2e>
 49d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a1:	79 11                	jns    4b4 <printint+0x2e>
    neg = 1;
 4a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ad:	f7 d8                	neg    %eax
 4af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b2:	eb 06                	jmp    4ba <printint+0x34>
  } else {
    x = xx;
 4b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c7:	ba 00 00 00 00       	mov    $0x0,%edx
 4cc:	f7 f1                	div    %ecx
 4ce:	89 d1                	mov    %edx,%ecx
 4d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d3:	8d 50 01             	lea    0x1(%eax),%edx
 4d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d9:	0f b6 91 c4 0b 00 00 	movzbl 0xbc4(%ecx),%edx
 4e0:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ea:	ba 00 00 00 00       	mov    $0x0,%edx
 4ef:	f7 f1                	div    %ecx
 4f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f8:	75 c7                	jne    4c1 <printint+0x3b>
  if(neg)
 4fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fe:	74 2d                	je     52d <printint+0xa7>
    buf[i++] = '-';
 500:	8b 45 f4             	mov    -0xc(%ebp),%eax
 503:	8d 50 01             	lea    0x1(%eax),%edx
 506:	89 55 f4             	mov    %edx,-0xc(%ebp)
 509:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50e:	eb 1d                	jmp    52d <printint+0xa7>
    putc(fd, buf[i]);
 510:	8d 55 dc             	lea    -0x24(%ebp),%edx
 513:	8b 45 f4             	mov    -0xc(%ebp),%eax
 516:	01 d0                	add    %edx,%eax
 518:	0f b6 00             	movzbl (%eax),%eax
 51b:	0f be c0             	movsbl %al,%eax
 51e:	83 ec 08             	sub    $0x8,%esp
 521:	50                   	push   %eax
 522:	ff 75 08             	pushl  0x8(%ebp)
 525:	e8 35 ff ff ff       	call   45f <putc>
 52a:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 52d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 535:	79 d9                	jns    510 <printint+0x8a>
}
 537:	90                   	nop
 538:	90                   	nop
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53b:	f3 0f 1e fb          	endbr32 
 53f:	55                   	push   %ebp
 540:	89 e5                	mov    %esp,%ebp
 542:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54c:	8d 45 0c             	lea    0xc(%ebp),%eax
 54f:	83 c0 04             	add    $0x4,%eax
 552:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 55c:	e9 59 01 00 00       	jmp    6ba <printf+0x17f>
    c = fmt[i] & 0xff;
 561:	8b 55 0c             	mov    0xc(%ebp),%edx
 564:	8b 45 f0             	mov    -0x10(%ebp),%eax
 567:	01 d0                	add    %edx,%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	25 ff 00 00 00       	and    $0xff,%eax
 574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57b:	75 2c                	jne    5a9 <printf+0x6e>
      if(c == '%'){
 57d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 581:	75 0c                	jne    58f <printf+0x54>
        state = '%';
 583:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58a:	e9 27 01 00 00       	jmp    6b6 <printf+0x17b>
      } else {
        putc(fd, c);
 58f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 592:	0f be c0             	movsbl %al,%eax
 595:	83 ec 08             	sub    $0x8,%esp
 598:	50                   	push   %eax
 599:	ff 75 08             	pushl  0x8(%ebp)
 59c:	e8 be fe ff ff       	call   45f <putc>
 5a1:	83 c4 10             	add    $0x10,%esp
 5a4:	e9 0d 01 00 00       	jmp    6b6 <printf+0x17b>
      }
    } else if(state == '%'){
 5a9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ad:	0f 85 03 01 00 00    	jne    6b6 <printf+0x17b>
      if(c == 'd'){
 5b3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b7:	75 1e                	jne    5d7 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	6a 01                	push   $0x1
 5c0:	6a 0a                	push   $0xa
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 bb fe ff ff       	call   486 <printint>
 5cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 d8 00 00 00       	jmp    6af <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 5d7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5db:	74 06                	je     5e3 <printf+0xa8>
 5dd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e1:	75 1e                	jne    601 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 5e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	6a 00                	push   $0x0
 5ea:	6a 10                	push   $0x10
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 91 fe ff ff       	call   486 <printint>
 5f5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fc:	e9 ae 00 00 00       	jmp    6af <printf+0x174>
      } else if(c == 's'){
 601:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 605:	75 43                	jne    64a <printf+0x10f>
        s = (char*)*ap;
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 617:	75 25                	jne    63e <printf+0x103>
          s = "(null)";
 619:	c7 45 f4 57 09 00 00 	movl   $0x957,-0xc(%ebp)
        while(*s != 0){
 620:	eb 1c                	jmp    63e <printf+0x103>
          putc(fd, *s);
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	50                   	push   %eax
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 28 fe ff ff       	call   45f <putc>
 637:	83 c4 10             	add    $0x10,%esp
          s++;
 63a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	84 c0                	test   %al,%al
 646:	75 da                	jne    622 <printf+0xe7>
 648:	eb 65                	jmp    6af <printf+0x174>
        }
      } else if(c == 'c'){
 64a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64e:	75 1d                	jne    66d <printf+0x132>
        putc(fd, *ap);
 650:	8b 45 e8             	mov    -0x18(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 fb fd ff ff       	call   45f <putc>
 664:	83 c4 10             	add    $0x10,%esp
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	eb 42                	jmp    6af <printf+0x174>
      } else if(c == '%'){
 66d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 671:	75 17                	jne    68a <printf+0x14f>
        putc(fd, c);
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	83 ec 08             	sub    $0x8,%esp
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 da fd ff ff       	call   45f <putc>
 685:	83 c4 10             	add    $0x10,%esp
 688:	eb 25                	jmp    6af <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68a:	83 ec 08             	sub    $0x8,%esp
 68d:	6a 25                	push   $0x25
 68f:	ff 75 08             	pushl  0x8(%ebp)
 692:	e8 c8 fd ff ff       	call   45f <putc>
 697:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 69a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69d:	0f be c0             	movsbl %al,%eax
 6a0:	83 ec 08             	sub    $0x8,%esp
 6a3:	50                   	push   %eax
 6a4:	ff 75 08             	pushl  0x8(%ebp)
 6a7:	e8 b3 fd ff ff       	call   45f <putc>
 6ac:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6b6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	0f b6 00             	movzbl (%eax),%eax
 6c5:	84 c0                	test   %al,%al
 6c7:	0f 85 94 fe ff ff    	jne    561 <printf+0x26>
    }
  }
}
 6cd:	90                   	nop
 6ce:	90                   	nop
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d1:	f3 0f 1e fb          	endbr32 
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	83 e8 08             	sub    $0x8,%eax
 6e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 6e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ec:	eb 24                	jmp    712 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6f6:	72 12                	jb     70a <free+0x39>
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fe:	77 24                	ja     724 <free+0x53>
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 708:	72 1a                	jb     724 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	76 d4                	jbe    6ee <free+0x1d>
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 722:	73 ca                	jae    6ee <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	39 c2                	cmp    %eax,%edx
 73d:	75 24                	jne    763 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	8b 50 04             	mov    0x4(%eax),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	01 c2                	add    %eax,%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	8b 10                	mov    (%eax),%edx
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	89 10                	mov    %edx,(%eax)
 761:	eb 0a                	jmp    76d <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	01 d0                	add    %edx,%eax
 77f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 782:	75 20                	jne    7a4 <free+0xd3>
    p->s.size += bp->s.size;
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 50 04             	mov    0x4(%eax),%edx
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	01 c2                	add    %eax,%edx
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	8b 10                	mov    (%eax),%edx
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	89 10                	mov    %edx,(%eax)
 7a2:	eb 08                	jmp    7ac <free+0xdb>
  } else
    p->s.ptr = bp;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7aa:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	a3 e0 0b 00 00       	mov    %eax,0xbe0
}
 7b4:	90                   	nop
 7b5:	c9                   	leave  
 7b6:	c3                   	ret    

000007b7 <morecore>:

static Header*
morecore(uint nu)
{
 7b7:	f3 0f 1e fb          	endbr32 
 7bb:	55                   	push   %ebp
 7bc:	89 e5                	mov    %esp,%ebp
 7be:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c8:	77 07                	ja     7d1 <morecore+0x1a>
    nu = 4096;
 7ca:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d1:	8b 45 08             	mov    0x8(%ebp),%eax
 7d4:	c1 e0 03             	shl    $0x3,%eax
 7d7:	83 ec 0c             	sub    $0xc,%esp
 7da:	50                   	push   %eax
 7db:	e8 5f fc ff ff       	call   43f <sbrk>
 7e0:	83 c4 10             	add    $0x10,%esp
 7e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ea:	75 07                	jne    7f3 <morecore+0x3c>
    return 0;
 7ec:	b8 00 00 00 00       	mov    $0x0,%eax
 7f1:	eb 26                	jmp    819 <morecore+0x62>
  hp = (Header*)p;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	8b 55 08             	mov    0x8(%ebp),%edx
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	83 c0 08             	add    $0x8,%eax
 808:	83 ec 0c             	sub    $0xc,%esp
 80b:	50                   	push   %eax
 80c:	e8 c0 fe ff ff       	call   6d1 <free>
 811:	83 c4 10             	add    $0x10,%esp
  return freep;
 814:	a1 e0 0b 00 00       	mov    0xbe0,%eax
}
 819:	c9                   	leave  
 81a:	c3                   	ret    

0000081b <malloc>:

void*
malloc(uint nbytes)
{
 81b:	f3 0f 1e fb          	endbr32 
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 825:	8b 45 08             	mov    0x8(%ebp),%eax
 828:	83 c0 07             	add    $0x7,%eax
 82b:	c1 e8 03             	shr    $0x3,%eax
 82e:	83 c0 01             	add    $0x1,%eax
 831:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 834:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 839:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 840:	75 23                	jne    865 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 842:	c7 45 f0 d8 0b 00 00 	movl   $0xbd8,-0x10(%ebp)
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	a3 e0 0b 00 00       	mov    %eax,0xbe0
 851:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 856:	a3 d8 0b 00 00       	mov    %eax,0xbd8
    base.s.size = 0;
 85b:	c7 05 dc 0b 00 00 00 	movl   $0x0,0xbdc
 862:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 876:	77 4d                	ja     8c5 <malloc+0xaa>
      if(p->s.size == nunits)
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8b 40 04             	mov    0x4(%eax),%eax
 87e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 881:	75 0c                	jne    88f <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 10                	mov    (%eax),%edx
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	89 10                	mov    %edx,(%eax)
 88d:	eb 26                	jmp    8b5 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	2b 45 ec             	sub    -0x14(%ebp),%eax
 898:	89 c2                	mov    %eax,%edx
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	c1 e0 03             	shl    $0x3,%eax
 8a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	a3 e0 0b 00 00       	mov    %eax,0xbe0
      return (void*)(p + 1);
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	83 c0 08             	add    $0x8,%eax
 8c3:	eb 3b                	jmp    900 <malloc+0xe5>
    }
    if(p == freep)
 8c5:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 8ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8cd:	75 1e                	jne    8ed <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 8cf:	83 ec 0c             	sub    $0xc,%esp
 8d2:	ff 75 ec             	pushl  -0x14(%ebp)
 8d5:	e8 dd fe ff ff       	call   7b7 <morecore>
 8da:	83 c4 10             	add    $0x10,%esp
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e4:	75 07                	jne    8ed <malloc+0xd2>
        return 0;
 8e6:	b8 00 00 00 00       	mov    $0x0,%eax
 8eb:	eb 13                	jmp    900 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 00                	mov    (%eax),%eax
 8f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8fb:	e9 6d ff ff ff       	jmp    86d <malloc+0x52>
  }
}
 900:	c9                   	leave  
 901:	c3                   	ret    
