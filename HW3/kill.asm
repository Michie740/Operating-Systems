
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	83 ec 10             	sub    $0x10,%esp
  16:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  18:	83 3b 01             	cmpl   $0x1,(%ebx)
  1b:	7f 17                	jg     34 <main+0x34>
    printf(2, "usage: kill pid...\n");
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	68 3c 08 00 00       	push   $0x83c
  25:	6a 02                	push   $0x2
  27:	e8 49 04 00 00       	call   475 <printf>
  2c:	83 c4 10             	add    $0x10,%esp
    exit();
  2f:	e8 bd 02 00 00       	call   2f1 <exit>
  }
  for(i=1; i<argc; i++)
  34:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  3b:	eb 2d                	jmp    6a <main+0x6a>
    kill(atoi(argv[i]));
  3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	01 d0                	add    %edx,%eax
  4c:	8b 00                	mov    (%eax),%eax
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	50                   	push   %eax
  52:	e8 00 02 00 00       	call   257 <atoi>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	50                   	push   %eax
  5e:	e8 be 02 00 00       	call   321 <kill>
  63:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6d:	3b 03                	cmp    (%ebx),%eax
  6f:	7c cc                	jl     3d <main+0x3d>
  exit();
  71:	e8 7b 02 00 00       	call   2f1 <exit>

00000076 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	57                   	push   %edi
  7a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7e:	8b 55 10             	mov    0x10(%ebp),%edx
  81:	8b 45 0c             	mov    0xc(%ebp),%eax
  84:	89 cb                	mov    %ecx,%ebx
  86:	89 df                	mov    %ebx,%edi
  88:	89 d1                	mov    %edx,%ecx
  8a:	fc                   	cld    
  8b:	f3 aa                	rep stos %al,%es:(%edi)
  8d:	89 ca                	mov    %ecx,%edx
  8f:	89 fb                	mov    %edi,%ebx
  91:	89 5d 08             	mov    %ebx,0x8(%ebp)
  94:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  97:	90                   	nop
  98:	5b                   	pop    %ebx
  99:	5f                   	pop    %edi
  9a:	5d                   	pop    %ebp
  9b:	c3                   	ret    

0000009c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9c:	f3 0f 1e fb          	endbr32 
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ac:	90                   	nop
  ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  b0:	8d 42 01             	lea    0x1(%edx),%eax
  b3:	89 45 0c             	mov    %eax,0xc(%ebp)
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	8d 48 01             	lea    0x1(%eax),%ecx
  bc:	89 4d 08             	mov    %ecx,0x8(%ebp)
  bf:	0f b6 12             	movzbl (%edx),%edx
  c2:	88 10                	mov    %dl,(%eax)
  c4:	0f b6 00             	movzbl (%eax),%eax
  c7:	84 c0                	test   %al,%al
  c9:	75 e2                	jne    ad <strcpy+0x11>
    ;
  return os;
  cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ce:	c9                   	leave  
  cf:	c3                   	ret    

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d7:	eb 08                	jmp    e1 <strcmp+0x11>
    p++, q++;
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 10                	je     fb <strcmp+0x2b>
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 de                	je     d9 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 d0             	movzbl %al,%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 c0             	movzbl %al,%eax
 10d:	29 c2                	sub    %eax,%edx
 10f:	89 d0                	mov    %edx,%eax
}
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    

00000113 <strlen>:

uint
strlen(char *s)
{
 113:	f3 0f 1e fb          	endbr32 
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 124:	eb 04                	jmp    12a <strlen+0x17>
 126:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	01 d0                	add    %edx,%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	84 c0                	test   %al,%al
 137:	75 ed                	jne    126 <strlen+0x13>
    ;
  return n;
 139:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	f3 0f 1e fb          	endbr32 
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 145:	8b 45 10             	mov    0x10(%ebp),%eax
 148:	50                   	push   %eax
 149:	ff 75 0c             	pushl  0xc(%ebp)
 14c:	ff 75 08             	pushl  0x8(%ebp)
 14f:	e8 22 ff ff ff       	call   76 <stosb>
 154:	83 c4 0c             	add    $0xc,%esp
  return dst;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <strchr>:

char*
strchr(const char *s, char c)
{
 15c:	f3 0f 1e fb          	endbr32 
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 04             	sub    $0x4,%esp
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16c:	eb 14                	jmp    182 <strchr+0x26>
    if(*s == c)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	38 45 fc             	cmp    %al,-0x4(%ebp)
 177:	75 05                	jne    17e <strchr+0x22>
      return (char*)s;
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	eb 13                	jmp    191 <strchr+0x35>
  for(; *s; s++)
 17e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	75 e2                	jne    16e <strchr+0x12>
  return 0;
 18c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <gets>:

char*
gets(char *buf, int max)
{
 193:	f3 0f 1e fb          	endbr32 
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a4:	eb 42                	jmp    1e8 <gets+0x55>
    cc = read(0, &c, 1);
 1a6:	83 ec 04             	sub    $0x4,%esp
 1a9:	6a 01                	push   $0x1
 1ab:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ae:	50                   	push   %eax
 1af:	6a 00                	push   $0x0
 1b1:	e8 53 01 00 00       	call   309 <read>
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c0:	7e 33                	jle    1f5 <gets+0x62>
      break;
    buf[i++] = c;
 1c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c5:	8d 50 01             	lea    0x1(%eax),%edx
 1c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cb:	89 c2                	mov    %eax,%edx
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	01 c2                	add    %eax,%edx
 1d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 16                	je     1f6 <gets+0x63>
 1e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e4:	3c 0d                	cmp    $0xd,%al
 1e6:	74 0e                	je     1f6 <gets+0x63>
  for(i=0; i+1 < max; ){
 1e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1eb:	83 c0 01             	add    $0x1,%eax
 1ee:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f1:	7f b3                	jg     1a6 <gets+0x13>
 1f3:	eb 01                	jmp    1f6 <gets+0x63>
      break;
 1f5:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	f3 0f 1e fb          	endbr32 
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 00                	push   $0x0
 215:	ff 75 08             	pushl  0x8(%ebp)
 218:	e8 14 01 00 00       	call   331 <open>
 21d:	83 c4 10             	add    $0x10,%esp
 220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 227:	79 07                	jns    230 <stat+0x2a>
    return -1;
 229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22e:	eb 25                	jmp    255 <stat+0x4f>
  r = fstat(fd, st);
 230:	83 ec 08             	sub    $0x8,%esp
 233:	ff 75 0c             	pushl  0xc(%ebp)
 236:	ff 75 f4             	pushl  -0xc(%ebp)
 239:	e8 0b 01 00 00       	call   349 <fstat>
 23e:	83 c4 10             	add    $0x10,%esp
 241:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 244:	83 ec 0c             	sub    $0xc,%esp
 247:	ff 75 f4             	pushl  -0xc(%ebp)
 24a:	e8 ca 00 00 00       	call   319 <close>
 24f:	83 c4 10             	add    $0x10,%esp
  return r;
 252:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <atoi>:

int
atoi(const char *s)
{
 257:	f3 0f 1e fb          	endbr32 
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 268:	eb 25                	jmp    28f <atoi+0x38>
    n = n*10 + *s++ - '0';
 26a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26d:	89 d0                	mov    %edx,%eax
 26f:	c1 e0 02             	shl    $0x2,%eax
 272:	01 d0                	add    %edx,%eax
 274:	01 c0                	add    %eax,%eax
 276:	89 c1                	mov    %eax,%ecx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	8d 50 01             	lea    0x1(%eax),%edx
 27e:	89 55 08             	mov    %edx,0x8(%ebp)
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	0f be c0             	movsbl %al,%eax
 287:	01 c8                	add    %ecx,%eax
 289:	83 e8 30             	sub    $0x30,%eax
 28c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	3c 2f                	cmp    $0x2f,%al
 297:	7e 0a                	jle    2a3 <atoi+0x4c>
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 39                	cmp    $0x39,%al
 2a1:	7e c7                	jle    26a <atoi+0x13>
  return n;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a8:	f3 0f 1e fb          	endbr32 
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2be:	eb 17                	jmp    2d7 <memmove+0x2f>
    *dst++ = *src++;
 2c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c3:	8d 42 01             	lea    0x1(%edx),%eax
 2c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2cc:	8d 48 01             	lea    0x1(%eax),%ecx
 2cf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2d2:	0f b6 12             	movzbl (%edx),%edx
 2d5:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2d7:	8b 45 10             	mov    0x10(%ebp),%eax
 2da:	8d 50 ff             	lea    -0x1(%eax),%edx
 2dd:	89 55 10             	mov    %edx,0x10(%ebp)
 2e0:	85 c0                	test   %eax,%eax
 2e2:	7f dc                	jg     2c0 <memmove+0x18>
  return vdst;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <exit>:
SYSCALL(exit)
 2f1:	b8 02 00 00 00       	mov    $0x2,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <wait>:
SYSCALL(wait)
 2f9:	b8 03 00 00 00       	mov    $0x3,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <pipe>:
SYSCALL(pipe)
 301:	b8 04 00 00 00       	mov    $0x4,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <read>:
SYSCALL(read)
 309:	b8 05 00 00 00       	mov    $0x5,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <write>:
SYSCALL(write)
 311:	b8 10 00 00 00       	mov    $0x10,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <close>:
SYSCALL(close)
 319:	b8 15 00 00 00       	mov    $0x15,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <kill>:
SYSCALL(kill)
 321:	b8 06 00 00 00       	mov    $0x6,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exec>:
SYSCALL(exec)
 329:	b8 07 00 00 00       	mov    $0x7,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <open>:
SYSCALL(open)
 331:	b8 0f 00 00 00       	mov    $0xf,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mknod>:
SYSCALL(mknod)
 339:	b8 11 00 00 00       	mov    $0x11,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <unlink>:
SYSCALL(unlink)
 341:	b8 12 00 00 00       	mov    $0x12,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <fstat>:
SYSCALL(fstat)
 349:	b8 08 00 00 00       	mov    $0x8,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <link>:
SYSCALL(link)
 351:	b8 13 00 00 00       	mov    $0x13,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <mkdir>:
SYSCALL(mkdir)
 359:	b8 14 00 00 00       	mov    $0x14,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <chdir>:
SYSCALL(chdir)
 361:	b8 09 00 00 00       	mov    $0x9,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <dup>:
SYSCALL(dup)
 369:	b8 0a 00 00 00       	mov    $0xa,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <getpid>:
SYSCALL(getpid)
 371:	b8 0b 00 00 00       	mov    $0xb,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <sbrk>:
SYSCALL(sbrk)
 379:	b8 0c 00 00 00       	mov    $0xc,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sleep>:
SYSCALL(sleep)
 381:	b8 0d 00 00 00       	mov    $0xd,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <uptime>:
SYSCALL(uptime)
 389:	b8 0e 00 00 00       	mov    $0xe,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <wait_stat>:
SYSCALL(wait_stat)
 391:	b8 16 00 00 00       	mov    $0x16,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 399:	f3 0f 1e fb          	endbr32 
 39d:	55                   	push   %ebp
 39e:	89 e5                	mov    %esp,%ebp
 3a0:	83 ec 18             	sub    $0x18,%esp
 3a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a9:	83 ec 04             	sub    $0x4,%esp
 3ac:	6a 01                	push   $0x1
 3ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b1:	50                   	push   %eax
 3b2:	ff 75 08             	pushl  0x8(%ebp)
 3b5:	e8 57 ff ff ff       	call   311 <write>
 3ba:	83 c4 10             	add    $0x10,%esp
}
 3bd:	90                   	nop
 3be:	c9                   	leave  
 3bf:	c3                   	ret    

000003c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d5:	74 17                	je     3ee <printint+0x2e>
 3d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3db:	79 11                	jns    3ee <printint+0x2e>
    neg = 1;
 3dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	f7 d8                	neg    %eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ec:	eb 06                	jmp    3f4 <printint+0x34>
  } else {
    x = xx;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 401:	ba 00 00 00 00       	mov    $0x0,%edx
 406:	f7 f1                	div    %ecx
 408:	89 d1                	mov    %edx,%ecx
 40a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40d:	8d 50 01             	lea    0x1(%eax),%edx
 410:	89 55 f4             	mov    %edx,-0xc(%ebp)
 413:	0f b6 91 a0 0a 00 00 	movzbl 0xaa0(%ecx),%edx
 41a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 41e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 421:	8b 45 ec             	mov    -0x14(%ebp),%eax
 424:	ba 00 00 00 00       	mov    $0x0,%edx
 429:	f7 f1                	div    %ecx
 42b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 432:	75 c7                	jne    3fb <printint+0x3b>
  if(neg)
 434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 438:	74 2d                	je     467 <printint+0xa7>
    buf[i++] = '-';
 43a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43d:	8d 50 01             	lea    0x1(%eax),%edx
 440:	89 55 f4             	mov    %edx,-0xc(%ebp)
 443:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 448:	eb 1d                	jmp    467 <printint+0xa7>
    putc(fd, buf[i]);
 44a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 450:	01 d0                	add    %edx,%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	0f be c0             	movsbl %al,%eax
 458:	83 ec 08             	sub    $0x8,%esp
 45b:	50                   	push   %eax
 45c:	ff 75 08             	pushl  0x8(%ebp)
 45f:	e8 35 ff ff ff       	call   399 <putc>
 464:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 467:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46f:	79 d9                	jns    44a <printint+0x8a>
}
 471:	90                   	nop
 472:	90                   	nop
 473:	c9                   	leave  
 474:	c3                   	ret    

00000475 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 475:	f3 0f 1e fb          	endbr32 
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 486:	8d 45 0c             	lea    0xc(%ebp),%eax
 489:	83 c0 04             	add    $0x4,%eax
 48c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 496:	e9 59 01 00 00       	jmp    5f4 <printf+0x17f>
    c = fmt[i] & 0xff;
 49b:	8b 55 0c             	mov    0xc(%ebp),%edx
 49e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a1:	01 d0                	add    %edx,%eax
 4a3:	0f b6 00             	movzbl (%eax),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	25 ff 00 00 00       	and    $0xff,%eax
 4ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b5:	75 2c                	jne    4e3 <printf+0x6e>
      if(c == '%'){
 4b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bb:	75 0c                	jne    4c9 <printf+0x54>
        state = '%';
 4bd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c4:	e9 27 01 00 00       	jmp    5f0 <printf+0x17b>
      } else {
        putc(fd, c);
 4c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cc:	0f be c0             	movsbl %al,%eax
 4cf:	83 ec 08             	sub    $0x8,%esp
 4d2:	50                   	push   %eax
 4d3:	ff 75 08             	pushl  0x8(%ebp)
 4d6:	e8 be fe ff ff       	call   399 <putc>
 4db:	83 c4 10             	add    $0x10,%esp
 4de:	e9 0d 01 00 00       	jmp    5f0 <printf+0x17b>
      }
    } else if(state == '%'){
 4e3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e7:	0f 85 03 01 00 00    	jne    5f0 <printf+0x17b>
      if(c == 'd'){
 4ed:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f1:	75 1e                	jne    511 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	6a 01                	push   $0x1
 4fa:	6a 0a                	push   $0xa
 4fc:	50                   	push   %eax
 4fd:	ff 75 08             	pushl  0x8(%ebp)
 500:	e8 bb fe ff ff       	call   3c0 <printint>
 505:	83 c4 10             	add    $0x10,%esp
        ap++;
 508:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50c:	e9 d8 00 00 00       	jmp    5e9 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 511:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 515:	74 06                	je     51d <printf+0xa8>
 517:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51b:	75 1e                	jne    53b <printf+0xc6>
        printint(fd, *ap, 16, 0);
 51d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 520:	8b 00                	mov    (%eax),%eax
 522:	6a 00                	push   $0x0
 524:	6a 10                	push   $0x10
 526:	50                   	push   %eax
 527:	ff 75 08             	pushl  0x8(%ebp)
 52a:	e8 91 fe ff ff       	call   3c0 <printint>
 52f:	83 c4 10             	add    $0x10,%esp
        ap++;
 532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 536:	e9 ae 00 00 00       	jmp    5e9 <printf+0x174>
      } else if(c == 's'){
 53b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 53f:	75 43                	jne    584 <printf+0x10f>
        s = (char*)*ap;
 541:	8b 45 e8             	mov    -0x18(%ebp),%eax
 544:	8b 00                	mov    (%eax),%eax
 546:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 551:	75 25                	jne    578 <printf+0x103>
          s = "(null)";
 553:	c7 45 f4 50 08 00 00 	movl   $0x850,-0xc(%ebp)
        while(*s != 0){
 55a:	eb 1c                	jmp    578 <printf+0x103>
          putc(fd, *s);
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	83 ec 08             	sub    $0x8,%esp
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 28 fe ff ff       	call   399 <putc>
 571:	83 c4 10             	add    $0x10,%esp
          s++;
 574:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	0f b6 00             	movzbl (%eax),%eax
 57e:	84 c0                	test   %al,%al
 580:	75 da                	jne    55c <printf+0xe7>
 582:	eb 65                	jmp    5e9 <printf+0x174>
        }
      } else if(c == 'c'){
 584:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 588:	75 1d                	jne    5a7 <printf+0x132>
        putc(fd, *ap);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	8b 00                	mov    (%eax),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 fb fd ff ff       	call   399 <putc>
 59e:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a5:	eb 42                	jmp    5e9 <printf+0x174>
      } else if(c == '%'){
 5a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ab:	75 17                	jne    5c4 <printf+0x14f>
        putc(fd, c);
 5ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 ec 08             	sub    $0x8,%esp
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 da fd ff ff       	call   399 <putc>
 5bf:	83 c4 10             	add    $0x10,%esp
 5c2:	eb 25                	jmp    5e9 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c4:	83 ec 08             	sub    $0x8,%esp
 5c7:	6a 25                	push   $0x25
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 c8 fd ff ff       	call   399 <putc>
 5d1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	83 ec 08             	sub    $0x8,%esp
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 b3 fd ff ff       	call   399 <putc>
 5e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fa:	01 d0                	add    %edx,%eax
 5fc:	0f b6 00             	movzbl (%eax),%eax
 5ff:	84 c0                	test   %al,%al
 601:	0f 85 94 fe ff ff    	jne    49b <printf+0x26>
    }
  }
}
 607:	90                   	nop
 608:	90                   	nop
 609:	c9                   	leave  
 60a:	c3                   	ret    

0000060b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60b:	f3 0f 1e fb          	endbr32 
 60f:	55                   	push   %ebp
 610:	89 e5                	mov    %esp,%ebp
 612:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	83 e8 08             	sub    $0x8,%eax
 61b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	a1 bc 0a 00 00       	mov    0xabc,%eax
 623:	89 45 fc             	mov    %eax,-0x4(%ebp)
 626:	eb 24                	jmp    64c <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 630:	72 12                	jb     644 <free+0x39>
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 638:	77 24                	ja     65e <free+0x53>
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 642:	72 1a                	jb     65e <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 652:	76 d4                	jbe    628 <free+0x1d>
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 65c:	73 ca                	jae    628 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	8b 40 04             	mov    0x4(%eax),%eax
 664:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	01 c2                	add    %eax,%edx
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	39 c2                	cmp    %eax,%edx
 677:	75 24                	jne    69d <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	8b 50 04             	mov    0x4(%eax),%edx
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	01 c2                	add    %eax,%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	8b 10                	mov    (%eax),%edx
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	89 10                	mov    %edx,(%eax)
 69b:	eb 0a                	jmp    6a7 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 10                	mov    (%eax),%edx
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 40 04             	mov    0x4(%eax),%eax
 6ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	01 d0                	add    %edx,%eax
 6b9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6bc:	75 20                	jne    6de <free+0xd3>
    p->s.size += bp->s.size;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 50 04             	mov    0x4(%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	8b 40 04             	mov    0x4(%eax),%eax
 6ca:	01 c2                	add    %eax,%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 10                	mov    (%eax),%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	89 10                	mov    %edx,(%eax)
 6dc:	eb 08                	jmp    6e6 <free+0xdb>
  } else
    p->s.ptr = bp;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	a3 bc 0a 00 00       	mov    %eax,0xabc
}
 6ee:	90                   	nop
 6ef:	c9                   	leave  
 6f0:	c3                   	ret    

000006f1 <morecore>:

static Header*
morecore(uint nu)
{
 6f1:	f3 0f 1e fb          	endbr32 
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 702:	77 07                	ja     70b <morecore+0x1a>
    nu = 4096;
 704:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	c1 e0 03             	shl    $0x3,%eax
 711:	83 ec 0c             	sub    $0xc,%esp
 714:	50                   	push   %eax
 715:	e8 5f fc ff ff       	call   379 <sbrk>
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 720:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 724:	75 07                	jne    72d <morecore+0x3c>
    return 0;
 726:	b8 00 00 00 00       	mov    $0x0,%eax
 72b:	eb 26                	jmp    753 <morecore+0x62>
  hp = (Header*)p;
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	8b 55 08             	mov    0x8(%ebp),%edx
 739:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	83 c0 08             	add    $0x8,%eax
 742:	83 ec 0c             	sub    $0xc,%esp
 745:	50                   	push   %eax
 746:	e8 c0 fe ff ff       	call   60b <free>
 74b:	83 c4 10             	add    $0x10,%esp
  return freep;
 74e:	a1 bc 0a 00 00       	mov    0xabc,%eax
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <malloc>:

void*
malloc(uint nbytes)
{
 755:	f3 0f 1e fb          	endbr32 
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	83 c0 07             	add    $0x7,%eax
 765:	c1 e8 03             	shr    $0x3,%eax
 768:	83 c0 01             	add    $0x1,%eax
 76b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76e:	a1 bc 0a 00 00       	mov    0xabc,%eax
 773:	89 45 f0             	mov    %eax,-0x10(%ebp)
 776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77a:	75 23                	jne    79f <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 77c:	c7 45 f0 b4 0a 00 00 	movl   $0xab4,-0x10(%ebp)
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	a3 bc 0a 00 00       	mov    %eax,0xabc
 78b:	a1 bc 0a 00 00       	mov    0xabc,%eax
 790:	a3 b4 0a 00 00       	mov    %eax,0xab4
    base.s.size = 0;
 795:	c7 05 b8 0a 00 00 00 	movl   $0x0,0xab8
 79c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7b0:	77 4d                	ja     7ff <malloc+0xaa>
      if(p->s.size == nunits)
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7bb:	75 0c                	jne    7c9 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 10                	mov    (%eax),%edx
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	89 10                	mov    %edx,(%eax)
 7c7:	eb 26                	jmp    7ef <malloc+0x9a>
      else {
        p->s.size -= nunits;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d2:	89 c2                	mov    %eax,%edx
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	c1 e0 03             	shl    $0x3,%eax
 7e3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ec:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	a3 bc 0a 00 00       	mov    %eax,0xabc
      return (void*)(p + 1);
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	83 c0 08             	add    $0x8,%eax
 7fd:	eb 3b                	jmp    83a <malloc+0xe5>
    }
    if(p == freep)
 7ff:	a1 bc 0a 00 00       	mov    0xabc,%eax
 804:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 807:	75 1e                	jne    827 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 809:	83 ec 0c             	sub    $0xc,%esp
 80c:	ff 75 ec             	pushl  -0x14(%ebp)
 80f:	e8 dd fe ff ff       	call   6f1 <morecore>
 814:	83 c4 10             	add    $0x10,%esp
 817:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81e:	75 07                	jne    827 <malloc+0xd2>
        return 0;
 820:	b8 00 00 00 00       	mov    $0x0,%eax
 825:	eb 13                	jmp    83a <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 835:	e9 6d ff ff ff       	jmp    7a7 <malloc+0x52>
  }
}
 83a:	c9                   	leave  
 83b:	c3                   	ret    
