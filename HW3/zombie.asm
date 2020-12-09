
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

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
  12:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  15:	e8 89 02 00 00       	call   2a3 <fork>
  1a:	85 c0                	test   %eax,%eax
  1c:	7e 0d                	jle    2b <main+0x2b>
    sleep(5);  // Let child exit before parent.
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	6a 05                	push   $0x5
  23:	e8 13 03 00 00       	call   33b <sleep>
  28:	83 c4 10             	add    $0x10,%esp
  exit();
  2b:	e8 7b 02 00 00       	call   2ab <exit>

00000030 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	57                   	push   %edi
  34:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  38:	8b 55 10             	mov    0x10(%ebp),%edx
  3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  3e:	89 cb                	mov    %ecx,%ebx
  40:	89 df                	mov    %ebx,%edi
  42:	89 d1                	mov    %edx,%ecx
  44:	fc                   	cld    
  45:	f3 aa                	rep stos %al,%es:(%edi)
  47:	89 ca                	mov    %ecx,%edx
  49:	89 fb                	mov    %edi,%ebx
  4b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  51:	90                   	nop
  52:	5b                   	pop    %ebx
  53:	5f                   	pop    %edi
  54:	5d                   	pop    %ebp
  55:	c3                   	ret    

00000056 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  56:	f3 0f 1e fb          	endbr32 
  5a:	55                   	push   %ebp
  5b:	89 e5                	mov    %esp,%ebp
  5d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  66:	90                   	nop
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	8d 42 01             	lea    0x1(%edx),%eax
  6d:	89 45 0c             	mov    %eax,0xc(%ebp)
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	8d 48 01             	lea    0x1(%eax),%ecx
  76:	89 4d 08             	mov    %ecx,0x8(%ebp)
  79:	0f b6 12             	movzbl (%edx),%edx
  7c:	88 10                	mov    %dl,(%eax)
  7e:	0f b6 00             	movzbl (%eax),%eax
  81:	84 c0                	test   %al,%al
  83:	75 e2                	jne    67 <strcpy+0x11>
    ;
  return os;
  85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  88:	c9                   	leave  
  89:	c3                   	ret    

0000008a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8a:	f3 0f 1e fb          	endbr32 
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  91:	eb 08                	jmp    9b <strcmp+0x11>
    p++, q++;
  93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	84 c0                	test   %al,%al
  a3:	74 10                	je     b5 <strcmp+0x2b>
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 10             	movzbl (%eax),%edx
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	38 c2                	cmp    %al,%dl
  b3:	74 de                	je     93 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	0f b6 00             	movzbl (%eax),%eax
  bb:	0f b6 d0             	movzbl %al,%edx
  be:	8b 45 0c             	mov    0xc(%ebp),%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	0f b6 c0             	movzbl %al,%eax
  c7:	29 c2                	sub    %eax,%edx
  c9:	89 d0                	mov    %edx,%eax
}
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    

000000cd <strlen>:

uint
strlen(char *s)
{
  cd:	f3 0f 1e fb          	endbr32 
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  de:	eb 04                	jmp    e4 <strlen+0x17>
  e0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	01 d0                	add    %edx,%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	84 c0                	test   %al,%al
  f1:	75 ed                	jne    e0 <strlen+0x13>
    ;
  return n;
  f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f6:	c9                   	leave  
  f7:	c3                   	ret    

000000f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f8:	f3 0f 1e fb          	endbr32 
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  ff:	8b 45 10             	mov    0x10(%ebp),%eax
 102:	50                   	push   %eax
 103:	ff 75 0c             	pushl  0xc(%ebp)
 106:	ff 75 08             	pushl  0x8(%ebp)
 109:	e8 22 ff ff ff       	call   30 <stosb>
 10e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 111:	8b 45 08             	mov    0x8(%ebp),%eax
}
 114:	c9                   	leave  
 115:	c3                   	ret    

00000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	f3 0f 1e fb          	endbr32 
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 04             	sub    $0x4,%esp
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 126:	eb 14                	jmp    13c <strchr+0x26>
    if(*s == c)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 131:	75 05                	jne    138 <strchr+0x22>
      return (char*)s;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	eb 13                	jmp    14b <strchr+0x35>
  for(; *s; s++)
 138:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 e2                	jne    128 <strchr+0x12>
  return 0;
 146:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <gets>:

char*
gets(char *buf, int max)
{
 14d:	f3 0f 1e fb          	endbr32 
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 157:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15e:	eb 42                	jmp    1a2 <gets+0x55>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	8d 45 ef             	lea    -0x11(%ebp),%eax
 168:	50                   	push   %eax
 169:	6a 00                	push   $0x0
 16b:	e8 53 01 00 00       	call   2c3 <read>
 170:	83 c4 10             	add    $0x10,%esp
 173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17a:	7e 33                	jle    1af <gets+0x62>
      break;
    buf[i++] = c;
 17c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17f:	8d 50 01             	lea    0x1(%eax),%edx
 182:	89 55 f4             	mov    %edx,-0xc(%ebp)
 185:	89 c2                	mov    %eax,%edx
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	01 c2                	add    %eax,%edx
 18c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 190:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 192:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 196:	3c 0a                	cmp    $0xa,%al
 198:	74 16                	je     1b0 <gets+0x63>
 19a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19e:	3c 0d                	cmp    $0xd,%al
 1a0:	74 0e                	je     1b0 <gets+0x63>
  for(i=0; i+1 < max; ){
 1a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a5:	83 c0 01             	add    $0x1,%eax
 1a8:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1ab:	7f b3                	jg     160 <gets+0x13>
 1ad:	eb 01                	jmp    1b0 <gets+0x63>
      break;
 1af:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 d0                	add    %edx,%eax
 1b8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1be:	c9                   	leave  
 1bf:	c3                   	ret    

000001c0 <stat>:

int
stat(char *n, struct stat *st)
{
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	6a 00                	push   $0x0
 1cf:	ff 75 08             	pushl  0x8(%ebp)
 1d2:	e8 14 01 00 00       	call   2eb <open>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1e1:	79 07                	jns    1ea <stat+0x2a>
    return -1;
 1e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e8:	eb 25                	jmp    20f <stat+0x4f>
  r = fstat(fd, st);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	ff 75 0c             	pushl  0xc(%ebp)
 1f0:	ff 75 f4             	pushl  -0xc(%ebp)
 1f3:	e8 0b 01 00 00       	call   303 <fstat>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1fe:	83 ec 0c             	sub    $0xc,%esp
 201:	ff 75 f4             	pushl  -0xc(%ebp)
 204:	e8 ca 00 00 00       	call   2d3 <close>
 209:	83 c4 10             	add    $0x10,%esp
  return r;
 20c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <atoi>:

int
atoi(const char *s)
{
 211:	f3 0f 1e fb          	endbr32 
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 222:	eb 25                	jmp    249 <atoi+0x38>
    n = n*10 + *s++ - '0';
 224:	8b 55 fc             	mov    -0x4(%ebp),%edx
 227:	89 d0                	mov    %edx,%eax
 229:	c1 e0 02             	shl    $0x2,%eax
 22c:	01 d0                	add    %edx,%eax
 22e:	01 c0                	add    %eax,%eax
 230:	89 c1                	mov    %eax,%ecx
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	8d 50 01             	lea    0x1(%eax),%edx
 238:	89 55 08             	mov    %edx,0x8(%ebp)
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f be c0             	movsbl %al,%eax
 241:	01 c8                	add    %ecx,%eax
 243:	83 e8 30             	sub    $0x30,%eax
 246:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	0f b6 00             	movzbl (%eax),%eax
 24f:	3c 2f                	cmp    $0x2f,%al
 251:	7e 0a                	jle    25d <atoi+0x4c>
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	3c 39                	cmp    $0x39,%al
 25b:	7e c7                	jle    224 <atoi+0x13>
  return n;
 25d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 262:	f3 0f 1e fb          	endbr32 
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 278:	eb 17                	jmp    291 <memmove+0x2f>
    *dst++ = *src++;
 27a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 27d:	8d 42 01             	lea    0x1(%edx),%eax
 280:	89 45 f8             	mov    %eax,-0x8(%ebp)
 283:	8b 45 fc             	mov    -0x4(%ebp),%eax
 286:	8d 48 01             	lea    0x1(%eax),%ecx
 289:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 28c:	0f b6 12             	movzbl (%edx),%edx
 28f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 291:	8b 45 10             	mov    0x10(%ebp),%eax
 294:	8d 50 ff             	lea    -0x1(%eax),%edx
 297:	89 55 10             	mov    %edx,0x10(%ebp)
 29a:	85 c0                	test   %eax,%eax
 29c:	7f dc                	jg     27a <memmove+0x18>
  return vdst;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a3:	b8 01 00 00 00       	mov    $0x1,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <exit>:
SYSCALL(exit)
 2ab:	b8 02 00 00 00       	mov    $0x2,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <wait>:
SYSCALL(wait)
 2b3:	b8 03 00 00 00       	mov    $0x3,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <pipe>:
SYSCALL(pipe)
 2bb:	b8 04 00 00 00       	mov    $0x4,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <read>:
SYSCALL(read)
 2c3:	b8 05 00 00 00       	mov    $0x5,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <write>:
SYSCALL(write)
 2cb:	b8 10 00 00 00       	mov    $0x10,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <close>:
SYSCALL(close)
 2d3:	b8 15 00 00 00       	mov    $0x15,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <kill>:
SYSCALL(kill)
 2db:	b8 06 00 00 00       	mov    $0x6,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <exec>:
SYSCALL(exec)
 2e3:	b8 07 00 00 00       	mov    $0x7,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <open>:
SYSCALL(open)
 2eb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <mknod>:
SYSCALL(mknod)
 2f3:	b8 11 00 00 00       	mov    $0x11,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <unlink>:
SYSCALL(unlink)
 2fb:	b8 12 00 00 00       	mov    $0x12,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <fstat>:
SYSCALL(fstat)
 303:	b8 08 00 00 00       	mov    $0x8,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <link>:
SYSCALL(link)
 30b:	b8 13 00 00 00       	mov    $0x13,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mkdir>:
SYSCALL(mkdir)
 313:	b8 14 00 00 00       	mov    $0x14,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <chdir>:
SYSCALL(chdir)
 31b:	b8 09 00 00 00       	mov    $0x9,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <dup>:
SYSCALL(dup)
 323:	b8 0a 00 00 00       	mov    $0xa,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <getpid>:
SYSCALL(getpid)
 32b:	b8 0b 00 00 00       	mov    $0xb,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <sbrk>:
SYSCALL(sbrk)
 333:	b8 0c 00 00 00       	mov    $0xc,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sleep>:
SYSCALL(sleep)
 33b:	b8 0d 00 00 00       	mov    $0xd,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <uptime>:
SYSCALL(uptime)
 343:	b8 0e 00 00 00       	mov    $0xe,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <wait_stat>:
SYSCALL(wait_stat)
 34b:	b8 16 00 00 00       	mov    $0x16,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 353:	f3 0f 1e fb          	endbr32 
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	83 ec 18             	sub    $0x18,%esp
 35d:	8b 45 0c             	mov    0xc(%ebp),%eax
 360:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 363:	83 ec 04             	sub    $0x4,%esp
 366:	6a 01                	push   $0x1
 368:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36b:	50                   	push   %eax
 36c:	ff 75 08             	pushl  0x8(%ebp)
 36f:	e8 57 ff ff ff       	call   2cb <write>
 374:	83 c4 10             	add    $0x10,%esp
}
 377:	90                   	nop
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37a:	f3 0f 1e fb          	endbr32 
 37e:	55                   	push   %ebp
 37f:	89 e5                	mov    %esp,%ebp
 381:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38f:	74 17                	je     3a8 <printint+0x2e>
 391:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 395:	79 11                	jns    3a8 <printint+0x2e>
    neg = 1;
 397:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	f7 d8                	neg    %eax
 3a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a6:	eb 06                	jmp    3ae <printint+0x34>
  } else {
    x = xx;
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bb:	ba 00 00 00 00       	mov    $0x0,%edx
 3c0:	f7 f1                	div    %ecx
 3c2:	89 d1                	mov    %edx,%ecx
 3c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c7:	8d 50 01             	lea    0x1(%eax),%edx
 3ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3cd:	0f b6 91 44 0a 00 00 	movzbl 0xa44(%ecx),%edx
 3d4:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 f1                	div    %ecx
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ec:	75 c7                	jne    3b5 <printint+0x3b>
  if(neg)
 3ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f2:	74 2d                	je     421 <printint+0xa7>
    buf[i++] = '-';
 3f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f7:	8d 50 01             	lea    0x1(%eax),%edx
 3fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 402:	eb 1d                	jmp    421 <printint+0xa7>
    putc(fd, buf[i]);
 404:	8d 55 dc             	lea    -0x24(%ebp),%edx
 407:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40a:	01 d0                	add    %edx,%eax
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	0f be c0             	movsbl %al,%eax
 412:	83 ec 08             	sub    $0x8,%esp
 415:	50                   	push   %eax
 416:	ff 75 08             	pushl  0x8(%ebp)
 419:	e8 35 ff ff ff       	call   353 <putc>
 41e:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 421:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 429:	79 d9                	jns    404 <printint+0x8a>
}
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42f:	f3 0f 1e fb          	endbr32 
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 439:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 440:	8d 45 0c             	lea    0xc(%ebp),%eax
 443:	83 c0 04             	add    $0x4,%eax
 446:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 450:	e9 59 01 00 00       	jmp    5ae <printf+0x17f>
    c = fmt[i] & 0xff;
 455:	8b 55 0c             	mov    0xc(%ebp),%edx
 458:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45b:	01 d0                	add    %edx,%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	0f be c0             	movsbl %al,%eax
 463:	25 ff 00 00 00       	and    $0xff,%eax
 468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46f:	75 2c                	jne    49d <printf+0x6e>
      if(c == '%'){
 471:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 475:	75 0c                	jne    483 <printf+0x54>
        state = '%';
 477:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47e:	e9 27 01 00 00       	jmp    5aa <printf+0x17b>
      } else {
        putc(fd, c);
 483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 486:	0f be c0             	movsbl %al,%eax
 489:	83 ec 08             	sub    $0x8,%esp
 48c:	50                   	push   %eax
 48d:	ff 75 08             	pushl  0x8(%ebp)
 490:	e8 be fe ff ff       	call   353 <putc>
 495:	83 c4 10             	add    $0x10,%esp
 498:	e9 0d 01 00 00       	jmp    5aa <printf+0x17b>
      }
    } else if(state == '%'){
 49d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a1:	0f 85 03 01 00 00    	jne    5aa <printf+0x17b>
      if(c == 'd'){
 4a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ab:	75 1e                	jne    4cb <printf+0x9c>
        printint(fd, *ap, 10, 1);
 4ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b0:	8b 00                	mov    (%eax),%eax
 4b2:	6a 01                	push   $0x1
 4b4:	6a 0a                	push   $0xa
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 bb fe ff ff       	call   37a <printint>
 4bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c6:	e9 d8 00 00 00       	jmp    5a3 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 4cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4cf:	74 06                	je     4d7 <printf+0xa8>
 4d1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d5:	75 1e                	jne    4f5 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 4d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4da:	8b 00                	mov    (%eax),%eax
 4dc:	6a 00                	push   $0x0
 4de:	6a 10                	push   $0x10
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	pushl  0x8(%ebp)
 4e4:	e8 91 fe ff ff       	call   37a <printint>
 4e9:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f0:	e9 ae 00 00 00       	jmp    5a3 <printf+0x174>
      } else if(c == 's'){
 4f5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f9:	75 43                	jne    53e <printf+0x10f>
        s = (char*)*ap;
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 503:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50b:	75 25                	jne    532 <printf+0x103>
          s = "(null)";
 50d:	c7 45 f4 f6 07 00 00 	movl   $0x7f6,-0xc(%ebp)
        while(*s != 0){
 514:	eb 1c                	jmp    532 <printf+0x103>
          putc(fd, *s);
 516:	8b 45 f4             	mov    -0xc(%ebp),%eax
 519:	0f b6 00             	movzbl (%eax),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	83 ec 08             	sub    $0x8,%esp
 522:	50                   	push   %eax
 523:	ff 75 08             	pushl  0x8(%ebp)
 526:	e8 28 fe ff ff       	call   353 <putc>
 52b:	83 c4 10             	add    $0x10,%esp
          s++;
 52e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 532:	8b 45 f4             	mov    -0xc(%ebp),%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	84 c0                	test   %al,%al
 53a:	75 da                	jne    516 <printf+0xe7>
 53c:	eb 65                	jmp    5a3 <printf+0x174>
        }
      } else if(c == 'c'){
 53e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 542:	75 1d                	jne    561 <printf+0x132>
        putc(fd, *ap);
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	8b 00                	mov    (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	83 ec 08             	sub    $0x8,%esp
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 fb fd ff ff       	call   353 <putc>
 558:	83 c4 10             	add    $0x10,%esp
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55f:	eb 42                	jmp    5a3 <printf+0x174>
      } else if(c == '%'){
 561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 565:	75 17                	jne    57e <printf+0x14f>
        putc(fd, c);
 567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 da fd ff ff       	call   353 <putc>
 579:	83 c4 10             	add    $0x10,%esp
 57c:	eb 25                	jmp    5a3 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57e:	83 ec 08             	sub    $0x8,%esp
 581:	6a 25                	push   $0x25
 583:	ff 75 08             	pushl  0x8(%ebp)
 586:	e8 c8 fd ff ff       	call   353 <putc>
 58b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 b3 fd ff ff       	call   353 <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b4:	01 d0                	add    %edx,%eax
 5b6:	0f b6 00             	movzbl (%eax),%eax
 5b9:	84 c0                	test   %al,%al
 5bb:	0f 85 94 fe ff ff    	jne    455 <printf+0x26>
    }
  }
}
 5c1:	90                   	nop
 5c2:	90                   	nop
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    

000005c5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c5:	f3 0f 1e fb          	endbr32 
 5c9:	55                   	push   %ebp
 5ca:	89 e5                	mov    %esp,%ebp
 5cc:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	83 e8 08             	sub    $0x8,%eax
 5d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d8:	a1 60 0a 00 00       	mov    0xa60,%eax
 5dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e0:	eb 24                	jmp    606 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5ea:	72 12                	jb     5fe <free+0x39>
 5ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f2:	77 24                	ja     618 <free+0x53>
 5f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5fc:	72 1a                	jb     618 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	89 45 fc             	mov    %eax,-0x4(%ebp)
 606:	8b 45 f8             	mov    -0x8(%ebp),%eax
 609:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60c:	76 d4                	jbe    5e2 <free+0x1d>
 60e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 616:	73 ca                	jae    5e2 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 618:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61b:	8b 40 04             	mov    0x4(%eax),%eax
 61e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	01 c2                	add    %eax,%edx
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	39 c2                	cmp    %eax,%edx
 631:	75 24                	jne    657 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	8b 50 04             	mov    0x4(%eax),%edx
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	8b 40 04             	mov    0x4(%eax),%eax
 641:	01 c2                	add    %eax,%edx
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	8b 10                	mov    (%eax),%edx
 650:	8b 45 f8             	mov    -0x8(%ebp),%eax
 653:	89 10                	mov    %edx,(%eax)
 655:	eb 0a                	jmp    661 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 10                	mov    (%eax),%edx
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	01 d0                	add    %edx,%eax
 673:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 676:	75 20                	jne    698 <free+0xd3>
    p->s.size += bp->s.size;
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 50 04             	mov    0x4(%eax),%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	01 c2                	add    %eax,%edx
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 10                	mov    (%eax),%edx
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	89 10                	mov    %edx,(%eax)
 696:	eb 08                	jmp    6a0 <free+0xdb>
  } else
    p->s.ptr = bp;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 69e:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 6a8:	90                   	nop
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    

000006ab <morecore>:

static Header*
morecore(uint nu)
{
 6ab:	f3 0f 1e fb          	endbr32 
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6bc:	77 07                	ja     6c5 <morecore+0x1a>
    nu = 4096;
 6be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	c1 e0 03             	shl    $0x3,%eax
 6cb:	83 ec 0c             	sub    $0xc,%esp
 6ce:	50                   	push   %eax
 6cf:	e8 5f fc ff ff       	call   333 <sbrk>
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6de:	75 07                	jne    6e7 <morecore+0x3c>
    return 0;
 6e0:	b8 00 00 00 00       	mov    $0x0,%eax
 6e5:	eb 26                	jmp    70d <morecore+0x62>
  hp = (Header*)p;
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f0:	8b 55 08             	mov    0x8(%ebp),%edx
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f9:	83 c0 08             	add    $0x8,%eax
 6fc:	83 ec 0c             	sub    $0xc,%esp
 6ff:	50                   	push   %eax
 700:	e8 c0 fe ff ff       	call   5c5 <free>
 705:	83 c4 10             	add    $0x10,%esp
  return freep;
 708:	a1 60 0a 00 00       	mov    0xa60,%eax
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <malloc>:

void*
malloc(uint nbytes)
{
 70f:	f3 0f 1e fb          	endbr32 
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	83 c0 07             	add    $0x7,%eax
 71f:	c1 e8 03             	shr    $0x3,%eax
 722:	83 c0 01             	add    $0x1,%eax
 725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 728:	a1 60 0a 00 00       	mov    0xa60,%eax
 72d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 730:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 734:	75 23                	jne    759 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 736:	c7 45 f0 58 0a 00 00 	movl   $0xa58,-0x10(%ebp)
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	a3 60 0a 00 00       	mov    %eax,0xa60
 745:	a1 60 0a 00 00       	mov    0xa60,%eax
 74a:	a3 58 0a 00 00       	mov    %eax,0xa58
    base.s.size = 0;
 74f:	c7 05 5c 0a 00 00 00 	movl   $0x0,0xa5c
 756:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 76a:	77 4d                	ja     7b9 <malloc+0xaa>
      if(p->s.size == nunits)
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 775:	75 0c                	jne    783 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
 781:	eb 26                	jmp    7a9 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78c:	89 c2                	mov    %eax,%edx
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	c1 e0 03             	shl    $0x3,%eax
 79d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	a3 60 0a 00 00       	mov    %eax,0xa60
      return (void*)(p + 1);
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	83 c0 08             	add    $0x8,%eax
 7b7:	eb 3b                	jmp    7f4 <malloc+0xe5>
    }
    if(p == freep)
 7b9:	a1 60 0a 00 00       	mov    0xa60,%eax
 7be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c1:	75 1e                	jne    7e1 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	ff 75 ec             	pushl  -0x14(%ebp)
 7c9:	e8 dd fe ff ff       	call   6ab <morecore>
 7ce:	83 c4 10             	add    $0x10,%esp
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d8:	75 07                	jne    7e1 <malloc+0xd2>
        return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb 13                	jmp    7f4 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ef:	e9 6d ff ff ff       	jmp    761 <malloc+0x52>
  }
}
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    
