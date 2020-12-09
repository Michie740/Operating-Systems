
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  15:	83 ec 08             	sub    $0x8,%esp
  18:	6a 02                	push   $0x2
  1a:	68 ce 08 00 00       	push   $0x8ce
  1f:	e8 9c 03 00 00       	call   3c0 <open>
  24:	83 c4 10             	add    $0x10,%esp
  27:	85 c0                	test   %eax,%eax
  29:	79 26                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  2b:	83 ec 04             	sub    $0x4,%esp
  2e:	6a 01                	push   $0x1
  30:	6a 01                	push   $0x1
  32:	68 ce 08 00 00       	push   $0x8ce
  37:	e8 8c 03 00 00       	call   3c8 <mknod>
  3c:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	6a 02                	push   $0x2
  44:	68 ce 08 00 00       	push   $0x8ce
  49:	e8 72 03 00 00       	call   3c0 <open>
  4e:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	6a 00                	push   $0x0
  56:	e8 9d 03 00 00       	call   3f8 <dup>
  5b:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 00                	push   $0x0
  63:	e8 90 03 00 00       	call   3f8 <dup>
  68:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  6b:	83 ec 08             	sub    $0x8,%esp
  6e:	68 d6 08 00 00       	push   $0x8d6
  73:	6a 01                	push   $0x1
  75:	e8 8a 04 00 00       	call   504 <printf>
  7a:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  7d:	e8 f6 02 00 00       	call   378 <fork>
  82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  89:	79 17                	jns    a2 <main+0xa2>
      printf(1, "init: fork failed\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 e9 08 00 00       	push   $0x8e9
  93:	6a 01                	push   $0x1
  95:	e8 6a 04 00 00       	call   504 <printf>
  9a:	83 c4 10             	add    $0x10,%esp
      exit();
  9d:	e8 de 02 00 00       	call   380 <exit>
    }
    if(pid == 0){
  a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a6:	75 3e                	jne    e6 <main+0xe6>
      exec("sh", argv);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	68 68 0b 00 00       	push   $0xb68
  b0:	68 cb 08 00 00       	push   $0x8cb
  b5:	e8 fe 02 00 00       	call   3b8 <exec>
  ba:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 fc 08 00 00       	push   $0x8fc
  c5:	6a 01                	push   $0x1
  c7:	e8 38 04 00 00       	call   504 <printf>
  cc:	83 c4 10             	add    $0x10,%esp
      exit();
  cf:	e8 ac 02 00 00       	call   380 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 12 09 00 00       	push   $0x912
  dc:	6a 01                	push   $0x1
  de:	e8 21 04 00 00       	call   504 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  e6:	e8 9d 02 00 00       	call   388 <wait>
  eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f2:	0f 88 73 ff ff ff    	js     6b <main+0x6b>
  f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fe:	75 d4                	jne    d4 <main+0xd4>
    printf(1, "init: starting sh\n");
 100:	e9 66 ff ff ff       	jmp    6b <main+0x6b>

00000105 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	57                   	push   %edi
 109:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10d:	8b 55 10             	mov    0x10(%ebp),%edx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	89 cb                	mov    %ecx,%ebx
 115:	89 df                	mov    %ebx,%edi
 117:	89 d1                	mov    %edx,%ecx
 119:	fc                   	cld    
 11a:	f3 aa                	rep stos %al,%es:(%edi)
 11c:	89 ca                	mov    %ecx,%edx
 11e:	89 fb                	mov    %edi,%ebx
 120:	89 5d 08             	mov    %ebx,0x8(%ebp)
 123:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 126:	90                   	nop
 127:	5b                   	pop    %ebx
 128:	5f                   	pop    %edi
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    

0000012b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12b:	f3 0f 1e fb          	endbr32 
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13b:	90                   	nop
 13c:	8b 55 0c             	mov    0xc(%ebp),%edx
 13f:	8d 42 01             	lea    0x1(%edx),%eax
 142:	89 45 0c             	mov    %eax,0xc(%ebp)
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	8d 48 01             	lea    0x1(%eax),%ecx
 14b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 14e:	0f b6 12             	movzbl (%edx),%edx
 151:	88 10                	mov    %dl,(%eax)
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	84 c0                	test   %al,%al
 158:	75 e2                	jne    13c <strcpy+0x11>
    ;
  return os;
 15a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15f:	f3 0f 1e fb          	endbr32 
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 166:	eb 08                	jmp    170 <strcmp+0x11>
    p++, q++;
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	84 c0                	test   %al,%al
 178:	74 10                	je     18a <strcmp+0x2b>
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 10             	movzbl (%eax),%edx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	38 c2                	cmp    %al,%dl
 188:	74 de                	je     168 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	0f b6 c0             	movzbl %al,%eax
 19c:	29 c2                	sub    %eax,%edx
 19e:	89 d0                	mov    %edx,%eax
}
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    

000001a2 <strlen>:

uint
strlen(char *s)
{
 1a2:	f3 0f 1e fb          	endbr32 
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b3:	eb 04                	jmp    1b9 <strlen+0x17>
 1b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	01 d0                	add    %edx,%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	84 c0                	test   %al,%al
 1c6:	75 ed                	jne    1b5 <strlen+0x13>
    ;
  return n;
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cd:	f3 0f 1e fb          	endbr32 
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	ff 75 0c             	pushl  0xc(%ebp)
 1db:	ff 75 08             	pushl  0x8(%ebp)
 1de:	e8 22 ff ff ff       	call   105 <stosb>
 1e3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <strchr>:

char*
strchr(const char *s, char c)
{
 1eb:	f3 0f 1e fb          	endbr32 
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fb:	eb 14                	jmp    211 <strchr+0x26>
    if(*s == c)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	38 45 fc             	cmp    %al,-0x4(%ebp)
 206:	75 05                	jne    20d <strchr+0x22>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 13                	jmp    220 <strchr+0x35>
  for(; *s; s++)
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 e2                	jne    1fd <strchr+0x12>
  return 0;
 21b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	f3 0f 1e fb          	endbr32 
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 233:	eb 42                	jmp    277 <gets+0x55>
    cc = read(0, &c, 1);
 235:	83 ec 04             	sub    $0x4,%esp
 238:	6a 01                	push   $0x1
 23a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23d:	50                   	push   %eax
 23e:	6a 00                	push   $0x0
 240:	e8 53 01 00 00       	call   398 <read>
 245:	83 c4 10             	add    $0x10,%esp
 248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24f:	7e 33                	jle    284 <gets+0x62>
      break;
    buf[i++] = c;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	01 c2                	add    %eax,%edx
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	3c 0a                	cmp    $0xa,%al
 26d:	74 16                	je     285 <gets+0x63>
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	3c 0d                	cmp    $0xd,%al
 275:	74 0e                	je     285 <gets+0x63>
  for(i=0; i+1 < max; ){
 277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27a:	83 c0 01             	add    $0x1,%eax
 27d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 280:	7f b3                	jg     235 <gets+0x13>
 282:	eb 01                	jmp    285 <gets+0x63>
      break;
 284:	90                   	nop
      break;
  }
  buf[i] = '\0';
 285:	8b 55 f4             	mov    -0xc(%ebp),%edx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <stat>:

int
stat(char *n, struct stat *st)
{
 295:	f3 0f 1e fb          	endbr32 
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	6a 00                	push   $0x0
 2a4:	ff 75 08             	pushl  0x8(%ebp)
 2a7:	e8 14 01 00 00       	call   3c0 <open>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b6:	79 07                	jns    2bf <stat+0x2a>
    return -1;
 2b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bd:	eb 25                	jmp    2e4 <stat+0x4f>
  r = fstat(fd, st);
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	ff 75 0c             	pushl  0xc(%ebp)
 2c5:	ff 75 f4             	pushl  -0xc(%ebp)
 2c8:	e8 0b 01 00 00       	call   3d8 <fstat>
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d3:	83 ec 0c             	sub    $0xc,%esp
 2d6:	ff 75 f4             	pushl  -0xc(%ebp)
 2d9:	e8 ca 00 00 00       	call   3a8 <close>
 2de:	83 c4 10             	add    $0x10,%esp
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	f3 0f 1e fb          	endbr32 
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f7:	eb 25                	jmp    31e <atoi+0x38>
    n = n*10 + *s++ - '0';
 2f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	c1 e0 02             	shl    $0x2,%eax
 301:	01 d0                	add    %edx,%eax
 303:	01 c0                	add    %eax,%eax
 305:	89 c1                	mov    %eax,%ecx
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	8d 50 01             	lea    0x1(%eax),%edx
 30d:	89 55 08             	mov    %edx,0x8(%ebp)
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	0f be c0             	movsbl %al,%eax
 316:	01 c8                	add    %ecx,%eax
 318:	83 e8 30             	sub    $0x30,%eax
 31b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	0f b6 00             	movzbl (%eax),%eax
 324:	3c 2f                	cmp    $0x2f,%al
 326:	7e 0a                	jle    332 <atoi+0x4c>
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	3c 39                	cmp    $0x39,%al
 330:	7e c7                	jle    2f9 <atoi+0x13>
  return n;
 332:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 335:	c9                   	leave  
 336:	c3                   	ret    

00000337 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 337:	f3 0f 1e fb          	endbr32 
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34d:	eb 17                	jmp    366 <memmove+0x2f>
    *dst++ = *src++;
 34f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 352:	8d 42 01             	lea    0x1(%edx),%eax
 355:	89 45 f8             	mov    %eax,-0x8(%ebp)
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35b:	8d 48 01             	lea    0x1(%eax),%ecx
 35e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 361:	0f b6 12             	movzbl (%edx),%edx
 364:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 366:	8b 45 10             	mov    0x10(%ebp),%eax
 369:	8d 50 ff             	lea    -0x1(%eax),%edx
 36c:	89 55 10             	mov    %edx,0x10(%ebp)
 36f:	85 c0                	test   %eax,%eax
 371:	7f dc                	jg     34f <memmove+0x18>
  return vdst;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 378:	b8 01 00 00 00       	mov    $0x1,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <exit>:
SYSCALL(exit)
 380:	b8 02 00 00 00       	mov    $0x2,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <wait>:
SYSCALL(wait)
 388:	b8 03 00 00 00       	mov    $0x3,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <pipe>:
SYSCALL(pipe)
 390:	b8 04 00 00 00       	mov    $0x4,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <read>:
SYSCALL(read)
 398:	b8 05 00 00 00       	mov    $0x5,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <write>:
SYSCALL(write)
 3a0:	b8 10 00 00 00       	mov    $0x10,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <close>:
SYSCALL(close)
 3a8:	b8 15 00 00 00       	mov    $0x15,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <kill>:
SYSCALL(kill)
 3b0:	b8 06 00 00 00       	mov    $0x6,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <exec>:
SYSCALL(exec)
 3b8:	b8 07 00 00 00       	mov    $0x7,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <open>:
SYSCALL(open)
 3c0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <mknod>:
SYSCALL(mknod)
 3c8:	b8 11 00 00 00       	mov    $0x11,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <unlink>:
SYSCALL(unlink)
 3d0:	b8 12 00 00 00       	mov    $0x12,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <fstat>:
SYSCALL(fstat)
 3d8:	b8 08 00 00 00       	mov    $0x8,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <link>:
SYSCALL(link)
 3e0:	b8 13 00 00 00       	mov    $0x13,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mkdir>:
SYSCALL(mkdir)
 3e8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <chdir>:
SYSCALL(chdir)
 3f0:	b8 09 00 00 00       	mov    $0x9,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <dup>:
SYSCALL(dup)
 3f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <getpid>:
SYSCALL(getpid)
 400:	b8 0b 00 00 00       	mov    $0xb,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sbrk>:
SYSCALL(sbrk)
 408:	b8 0c 00 00 00       	mov    $0xc,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sleep>:
SYSCALL(sleep)
 410:	b8 0d 00 00 00       	mov    $0xd,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <uptime>:
SYSCALL(uptime)
 418:	b8 0e 00 00 00       	mov    $0xe,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <wait_stat>:
SYSCALL(wait_stat)
 420:	b8 16 00 00 00       	mov    $0x16,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 428:	f3 0f 1e fb          	endbr32 
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 18             	sub    $0x18,%esp
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 438:	83 ec 04             	sub    $0x4,%esp
 43b:	6a 01                	push   $0x1
 43d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 440:	50                   	push   %eax
 441:	ff 75 08             	pushl  0x8(%ebp)
 444:	e8 57 ff ff ff       	call   3a0 <write>
 449:	83 c4 10             	add    $0x10,%esp
}
 44c:	90                   	nop
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44f:	f3 0f 1e fb          	endbr32 
 453:	55                   	push   %ebp
 454:	89 e5                	mov    %esp,%ebp
 456:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 459:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 460:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 464:	74 17                	je     47d <printint+0x2e>
 466:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 46a:	79 11                	jns    47d <printint+0x2e>
    neg = 1;
 46c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 473:	8b 45 0c             	mov    0xc(%ebp),%eax
 476:	f7 d8                	neg    %eax
 478:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47b:	eb 06                	jmp    483 <printint+0x34>
  } else {
    x = xx;
 47d:	8b 45 0c             	mov    0xc(%ebp),%eax
 480:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 483:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 48a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 490:	ba 00 00 00 00       	mov    $0x0,%edx
 495:	f7 f1                	div    %ecx
 497:	89 d1                	mov    %edx,%ecx
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	8d 50 01             	lea    0x1(%eax),%edx
 49f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a2:	0f b6 91 70 0b 00 00 	movzbl 0xb70(%ecx),%edx
 4a9:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b3:	ba 00 00 00 00       	mov    $0x0,%edx
 4b8:	f7 f1                	div    %ecx
 4ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c1:	75 c7                	jne    48a <printint+0x3b>
  if(neg)
 4c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c7:	74 2d                	je     4f6 <printint+0xa7>
    buf[i++] = '-';
 4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cc:	8d 50 01             	lea    0x1(%eax),%edx
 4cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d7:	eb 1d                	jmp    4f6 <printint+0xa7>
    putc(fd, buf[i]);
 4d9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4df:	01 d0                	add    %edx,%eax
 4e1:	0f b6 00             	movzbl (%eax),%eax
 4e4:	0f be c0             	movsbl %al,%eax
 4e7:	83 ec 08             	sub    $0x8,%esp
 4ea:	50                   	push   %eax
 4eb:	ff 75 08             	pushl  0x8(%ebp)
 4ee:	e8 35 ff ff ff       	call   428 <putc>
 4f3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4f6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fe:	79 d9                	jns    4d9 <printint+0x8a>
}
 500:	90                   	nop
 501:	90                   	nop
 502:	c9                   	leave  
 503:	c3                   	ret    

00000504 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 504:	f3 0f 1e fb          	endbr32 
 508:	55                   	push   %ebp
 509:	89 e5                	mov    %esp,%ebp
 50b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 515:	8d 45 0c             	lea    0xc(%ebp),%eax
 518:	83 c0 04             	add    $0x4,%eax
 51b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 525:	e9 59 01 00 00       	jmp    683 <printf+0x17f>
    c = fmt[i] & 0xff;
 52a:	8b 55 0c             	mov    0xc(%ebp),%edx
 52d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 530:	01 d0                	add    %edx,%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	0f be c0             	movsbl %al,%eax
 538:	25 ff 00 00 00       	and    $0xff,%eax
 53d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 540:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 544:	75 2c                	jne    572 <printf+0x6e>
      if(c == '%'){
 546:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54a:	75 0c                	jne    558 <printf+0x54>
        state = '%';
 54c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 553:	e9 27 01 00 00       	jmp    67f <printf+0x17b>
      } else {
        putc(fd, c);
 558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	83 ec 08             	sub    $0x8,%esp
 561:	50                   	push   %eax
 562:	ff 75 08             	pushl  0x8(%ebp)
 565:	e8 be fe ff ff       	call   428 <putc>
 56a:	83 c4 10             	add    $0x10,%esp
 56d:	e9 0d 01 00 00       	jmp    67f <printf+0x17b>
      }
    } else if(state == '%'){
 572:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 576:	0f 85 03 01 00 00    	jne    67f <printf+0x17b>
      if(c == 'd'){
 57c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 580:	75 1e                	jne    5a0 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 582:	8b 45 e8             	mov    -0x18(%ebp),%eax
 585:	8b 00                	mov    (%eax),%eax
 587:	6a 01                	push   $0x1
 589:	6a 0a                	push   $0xa
 58b:	50                   	push   %eax
 58c:	ff 75 08             	pushl  0x8(%ebp)
 58f:	e8 bb fe ff ff       	call   44f <printint>
 594:	83 c4 10             	add    $0x10,%esp
        ap++;
 597:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59b:	e9 d8 00 00 00       	jmp    678 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 5a0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a4:	74 06                	je     5ac <printf+0xa8>
 5a6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5aa:	75 1e                	jne    5ca <printf+0xc6>
        printint(fd, *ap, 16, 0);
 5ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	6a 00                	push   $0x0
 5b3:	6a 10                	push   $0x10
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 91 fe ff ff       	call   44f <printint>
 5be:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c5:	e9 ae 00 00 00       	jmp    678 <printf+0x174>
      } else if(c == 's'){
 5ca:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ce:	75 43                	jne    613 <printf+0x10f>
        s = (char*)*ap;
 5d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e0:	75 25                	jne    607 <printf+0x103>
          s = "(null)";
 5e2:	c7 45 f4 1b 09 00 00 	movl   $0x91b,-0xc(%ebp)
        while(*s != 0){
 5e9:	eb 1c                	jmp    607 <printf+0x103>
          putc(fd, *s);
 5eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ee:	0f b6 00             	movzbl (%eax),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	83 ec 08             	sub    $0x8,%esp
 5f7:	50                   	push   %eax
 5f8:	ff 75 08             	pushl  0x8(%ebp)
 5fb:	e8 28 fe ff ff       	call   428 <putc>
 600:	83 c4 10             	add    $0x10,%esp
          s++;
 603:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 607:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	84 c0                	test   %al,%al
 60f:	75 da                	jne    5eb <printf+0xe7>
 611:	eb 65                	jmp    678 <printf+0x174>
        }
      } else if(c == 'c'){
 613:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 617:	75 1d                	jne    636 <printf+0x132>
        putc(fd, *ap);
 619:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	0f be c0             	movsbl %al,%eax
 621:	83 ec 08             	sub    $0x8,%esp
 624:	50                   	push   %eax
 625:	ff 75 08             	pushl  0x8(%ebp)
 628:	e8 fb fd ff ff       	call   428 <putc>
 62d:	83 c4 10             	add    $0x10,%esp
        ap++;
 630:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 634:	eb 42                	jmp    678 <printf+0x174>
      } else if(c == '%'){
 636:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63a:	75 17                	jne    653 <printf+0x14f>
        putc(fd, c);
 63c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63f:	0f be c0             	movsbl %al,%eax
 642:	83 ec 08             	sub    $0x8,%esp
 645:	50                   	push   %eax
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 da fd ff ff       	call   428 <putc>
 64e:	83 c4 10             	add    $0x10,%esp
 651:	eb 25                	jmp    678 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 653:	83 ec 08             	sub    $0x8,%esp
 656:	6a 25                	push   $0x25
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 c8 fd ff ff       	call   428 <putc>
 660:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	83 ec 08             	sub    $0x8,%esp
 66c:	50                   	push   %eax
 66d:	ff 75 08             	pushl  0x8(%ebp)
 670:	e8 b3 fd ff ff       	call   428 <putc>
 675:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 678:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 67f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 683:	8b 55 0c             	mov    0xc(%ebp),%edx
 686:	8b 45 f0             	mov    -0x10(%ebp),%eax
 689:	01 d0                	add    %edx,%eax
 68b:	0f b6 00             	movzbl (%eax),%eax
 68e:	84 c0                	test   %al,%al
 690:	0f 85 94 fe ff ff    	jne    52a <printf+0x26>
    }
  }
}
 696:	90                   	nop
 697:	90                   	nop
 698:	c9                   	leave  
 699:	c3                   	ret    

0000069a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69a:	f3 0f 1e fb          	endbr32 
 69e:	55                   	push   %ebp
 69f:	89 e5                	mov    %esp,%ebp
 6a1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	83 e8 08             	sub    $0x8,%eax
 6aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ad:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 6b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b5:	eb 24                	jmp    6db <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6bf:	72 12                	jb     6d3 <free+0x39>
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c7:	77 24                	ja     6ed <free+0x53>
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6d1:	72 1a                	jb     6ed <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	76 d4                	jbe    6b7 <free+0x1d>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6eb:	73 ca                	jae    6b7 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	39 c2                	cmp    %eax,%edx
 706:	75 24                	jne    72c <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	8b 40 04             	mov    0x4(%eax),%eax
 716:	01 c2                	add    %eax,%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	8b 10                	mov    (%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 10                	mov    %edx,(%eax)
 72a:	eb 0a                	jmp    736 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 10                	mov    (%eax),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 40 04             	mov    0x4(%eax),%eax
 73c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	01 d0                	add    %edx,%eax
 748:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 74b:	75 20                	jne    76d <free+0xd3>
    p->s.size += bp->s.size;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 40 04             	mov    0x4(%eax),%eax
 759:	01 c2                	add    %eax,%edx
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 10                	mov    (%eax),%edx
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	89 10                	mov    %edx,(%eax)
 76b:	eb 08                	jmp    775 <free+0xdb>
  } else
    p->s.ptr = bp;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 55 f8             	mov    -0x8(%ebp),%edx
 773:	89 10                	mov    %edx,(%eax)
  freep = p;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	a3 8c 0b 00 00       	mov    %eax,0xb8c
}
 77d:	90                   	nop
 77e:	c9                   	leave  
 77f:	c3                   	ret    

00000780 <morecore>:

static Header*
morecore(uint nu)
{
 780:	f3 0f 1e fb          	endbr32 
 784:	55                   	push   %ebp
 785:	89 e5                	mov    %esp,%ebp
 787:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 78a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 791:	77 07                	ja     79a <morecore+0x1a>
    nu = 4096;
 793:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 79a:	8b 45 08             	mov    0x8(%ebp),%eax
 79d:	c1 e0 03             	shl    $0x3,%eax
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	50                   	push   %eax
 7a4:	e8 5f fc ff ff       	call   408 <sbrk>
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7af:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b3:	75 07                	jne    7bc <morecore+0x3c>
    return 0;
 7b5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ba:	eb 26                	jmp    7e2 <morecore+0x62>
  hp = (Header*)p;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	8b 55 08             	mov    0x8(%ebp),%edx
 7c8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ce:	83 c0 08             	add    $0x8,%eax
 7d1:	83 ec 0c             	sub    $0xc,%esp
 7d4:	50                   	push   %eax
 7d5:	e8 c0 fe ff ff       	call   69a <free>
 7da:	83 c4 10             	add    $0x10,%esp
  return freep;
 7dd:	a1 8c 0b 00 00       	mov    0xb8c,%eax
}
 7e2:	c9                   	leave  
 7e3:	c3                   	ret    

000007e4 <malloc>:

void*
malloc(uint nbytes)
{
 7e4:	f3 0f 1e fb          	endbr32 
 7e8:	55                   	push   %ebp
 7e9:	89 e5                	mov    %esp,%ebp
 7eb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ee:	8b 45 08             	mov    0x8(%ebp),%eax
 7f1:	83 c0 07             	add    $0x7,%eax
 7f4:	c1 e8 03             	shr    $0x3,%eax
 7f7:	83 c0 01             	add    $0x1,%eax
 7fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7fd:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 802:	89 45 f0             	mov    %eax,-0x10(%ebp)
 805:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 809:	75 23                	jne    82e <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 80b:	c7 45 f0 84 0b 00 00 	movl   $0xb84,-0x10(%ebp)
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	a3 8c 0b 00 00       	mov    %eax,0xb8c
 81a:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 81f:	a3 84 0b 00 00       	mov    %eax,0xb84
    base.s.size = 0;
 824:	c7 05 88 0b 00 00 00 	movl   $0x0,0xb88
 82b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	8b 00                	mov    (%eax),%eax
 833:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 83f:	77 4d                	ja     88e <malloc+0xaa>
      if(p->s.size == nunits)
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	8b 40 04             	mov    0x4(%eax),%eax
 847:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 84a:	75 0c                	jne    858 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 10                	mov    (%eax),%edx
 851:	8b 45 f0             	mov    -0x10(%ebp),%eax
 854:	89 10                	mov    %edx,(%eax)
 856:	eb 26                	jmp    87e <malloc+0x9a>
      else {
        p->s.size -= nunits;
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	8b 40 04             	mov    0x4(%eax),%eax
 85e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 861:	89 c2                	mov    %eax,%edx
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 40 04             	mov    0x4(%eax),%eax
 86f:	c1 e0 03             	shl    $0x3,%eax
 872:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 55 ec             	mov    -0x14(%ebp),%edx
 87b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	a3 8c 0b 00 00       	mov    %eax,0xb8c
      return (void*)(p + 1);
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	83 c0 08             	add    $0x8,%eax
 88c:	eb 3b                	jmp    8c9 <malloc+0xe5>
    }
    if(p == freep)
 88e:	a1 8c 0b 00 00       	mov    0xb8c,%eax
 893:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 896:	75 1e                	jne    8b6 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 898:	83 ec 0c             	sub    $0xc,%esp
 89b:	ff 75 ec             	pushl  -0x14(%ebp)
 89e:	e8 dd fe ff ff       	call   780 <morecore>
 8a3:	83 c4 10             	add    $0x10,%esp
 8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ad:	75 07                	jne    8b6 <malloc+0xd2>
        return 0;
 8af:	b8 00 00 00 00       	mov    $0x0,%eax
 8b4:	eb 13                	jmp    8c9 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c4:	e9 6d ff ff ff       	jmp    836 <malloc+0x52>
  }
}
 8c9:	c9                   	leave  
 8ca:	c3                   	ret    
