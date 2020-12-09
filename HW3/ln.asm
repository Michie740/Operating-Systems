
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  15:	83 3b 03             	cmpl   $0x3,(%ebx)
  18:	74 17                	je     31 <main+0x31>
    printf(2, "Usage: ln old new\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 3e 08 00 00       	push   $0x83e
  22:	6a 02                	push   $0x2
  24:	e8 4e 04 00 00       	call   477 <printf>
  29:	83 c4 10             	add    $0x10,%esp
    exit();
  2c:	e8 c2 02 00 00       	call   2f3 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  31:	8b 43 04             	mov    0x4(%ebx),%eax
  34:	83 c0 08             	add    $0x8,%eax
  37:	8b 10                	mov    (%eax),%edx
  39:	8b 43 04             	mov    0x4(%ebx),%eax
  3c:	83 c0 04             	add    $0x4,%eax
  3f:	8b 00                	mov    (%eax),%eax
  41:	83 ec 08             	sub    $0x8,%esp
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	e8 08 03 00 00       	call   353 <link>
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	85 c0                	test   %eax,%eax
  50:	79 21                	jns    73 <main+0x73>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  52:	8b 43 04             	mov    0x4(%ebx),%eax
  55:	83 c0 08             	add    $0x8,%eax
  58:	8b 10                	mov    (%eax),%edx
  5a:	8b 43 04             	mov    0x4(%ebx),%eax
  5d:	83 c0 04             	add    $0x4,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	52                   	push   %edx
  63:	50                   	push   %eax
  64:	68 51 08 00 00       	push   $0x851
  69:	6a 02                	push   $0x2
  6b:	e8 07 04 00 00       	call   477 <printf>
  70:	83 c4 10             	add    $0x10,%esp
  exit();
  73:	e8 7b 02 00 00       	call   2f3 <exit>

00000078 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 10             	mov    0x10(%ebp),%edx
  83:	8b 45 0c             	mov    0xc(%ebp),%eax
  86:	89 cb                	mov    %ecx,%ebx
  88:	89 df                	mov    %ebx,%edi
  8a:	89 d1                	mov    %edx,%ecx
  8c:	fc                   	cld    
  8d:	f3 aa                	rep stos %al,%es:(%edi)
  8f:	89 ca                	mov    %ecx,%edx
  91:	89 fb                	mov    %edi,%ebx
  93:	89 5d 08             	mov    %ebx,0x8(%ebp)
  96:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  99:	90                   	nop
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	f3 0f 1e fb          	endbr32 
  a2:	55                   	push   %ebp
  a3:	89 e5                	mov    %esp,%ebp
  a5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ae:	90                   	nop
  af:	8b 55 0c             	mov    0xc(%ebp),%edx
  b2:	8d 42 01             	lea    0x1(%edx),%eax
  b5:	89 45 0c             	mov    %eax,0xc(%ebp)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	8d 48 01             	lea    0x1(%eax),%ecx
  be:	89 4d 08             	mov    %ecx,0x8(%ebp)
  c1:	0f b6 12             	movzbl (%edx),%edx
  c4:	88 10                	mov    %dl,(%eax)
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	84 c0                	test   %al,%al
  cb:	75 e2                	jne    af <strcpy+0x11>
    ;
  return os;
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d0:	c9                   	leave  
  d1:	c3                   	ret    

000000d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d2:	f3 0f 1e fb          	endbr32 
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d9:	eb 08                	jmp    e3 <strcmp+0x11>
    p++, q++;
  db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  df:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	84 c0                	test   %al,%al
  eb:	74 10                	je     fd <strcmp+0x2b>
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	0f b6 10             	movzbl (%eax),%edx
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	38 c2                	cmp    %al,%dl
  fb:	74 de                	je     db <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	0f b6 d0             	movzbl %al,%edx
 106:	8b 45 0c             	mov    0xc(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	0f b6 c0             	movzbl %al,%eax
 10f:	29 c2                	sub    %eax,%edx
 111:	89 d0                	mov    %edx,%eax
}
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    

00000115 <strlen>:

uint
strlen(char *s)
{
 115:	f3 0f 1e fb          	endbr32 
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 126:	eb 04                	jmp    12c <strlen+0x17>
 128:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	01 d0                	add    %edx,%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	75 ed                	jne    128 <strlen+0x13>
    ;
  return n;
 13b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 147:	8b 45 10             	mov    0x10(%ebp),%eax
 14a:	50                   	push   %eax
 14b:	ff 75 0c             	pushl  0xc(%ebp)
 14e:	ff 75 08             	pushl  0x8(%ebp)
 151:	e8 22 ff ff ff       	call   78 <stosb>
 156:	83 c4 0c             	add    $0xc,%esp
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	f3 0f 1e fb          	endbr32 
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	83 ec 04             	sub    $0x4,%esp
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16e:	eb 14                	jmp    184 <strchr+0x26>
    if(*s == c)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	38 45 fc             	cmp    %al,-0x4(%ebp)
 179:	75 05                	jne    180 <strchr+0x22>
      return (char*)s;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	eb 13                	jmp    193 <strchr+0x35>
  for(; *s; s++)
 180:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	84 c0                	test   %al,%al
 18c:	75 e2                	jne    170 <strchr+0x12>
  return 0;
 18e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <gets>:

char*
gets(char *buf, int max)
{
 195:	f3 0f 1e fb          	endbr32 
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x55>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 53 01 00 00       	call   30b <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x62>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x63>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x63>
  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f3:	7f b3                	jg     1a8 <gets+0x13>
 1f5:	eb 01                	jmp    1f8 <gets+0x63>
      break;
 1f7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	f3 0f 1e fb          	endbr32 
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	6a 00                	push   $0x0
 217:	ff 75 08             	pushl  0x8(%ebp)
 21a:	e8 14 01 00 00       	call   333 <open>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 229:	79 07                	jns    232 <stat+0x2a>
    return -1;
 22b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 230:	eb 25                	jmp    257 <stat+0x4f>
  r = fstat(fd, st);
 232:	83 ec 08             	sub    $0x8,%esp
 235:	ff 75 0c             	pushl  0xc(%ebp)
 238:	ff 75 f4             	pushl  -0xc(%ebp)
 23b:	e8 0b 01 00 00       	call   34b <fstat>
 240:	83 c4 10             	add    $0x10,%esp
 243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	ff 75 f4             	pushl  -0xc(%ebp)
 24c:	e8 ca 00 00 00       	call   31b <close>
 251:	83 c4 10             	add    $0x10,%esp
  return r;
 254:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <atoi>:

int
atoi(const char *s)
{
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26a:	eb 25                	jmp    291 <atoi+0x38>
    n = n*10 + *s++ - '0';
 26c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26f:	89 d0                	mov    %edx,%eax
 271:	c1 e0 02             	shl    $0x2,%eax
 274:	01 d0                	add    %edx,%eax
 276:	01 c0                	add    %eax,%eax
 278:	89 c1                	mov    %eax,%ecx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	8d 50 01             	lea    0x1(%eax),%edx
 280:	89 55 08             	mov    %edx,0x8(%ebp)
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	0f be c0             	movsbl %al,%eax
 289:	01 c8                	add    %ecx,%eax
 28b:	83 e8 30             	sub    $0x30,%eax
 28e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 2f                	cmp    $0x2f,%al
 299:	7e 0a                	jle    2a5 <atoi+0x4c>
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 39                	cmp    $0x39,%al
 2a3:	7e c7                	jle    26c <atoi+0x13>
  return n;
 2a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a8:	c9                   	leave  
 2a9:	c3                   	ret    

000002aa <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2aa:	f3 0f 1e fb          	endbr32 
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c0:	eb 17                	jmp    2d9 <memmove+0x2f>
    *dst++ = *src++;
 2c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c5:	8d 42 01             	lea    0x1(%edx),%eax
 2c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ce:	8d 48 01             	lea    0x1(%eax),%ecx
 2d1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2d4:	0f b6 12             	movzbl (%edx),%edx
 2d7:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2d9:	8b 45 10             	mov    0x10(%ebp),%eax
 2dc:	8d 50 ff             	lea    -0x1(%eax),%edx
 2df:	89 55 10             	mov    %edx,0x10(%ebp)
 2e2:	85 c0                	test   %eax,%eax
 2e4:	7f dc                	jg     2c2 <memmove+0x18>
  return vdst;
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <wait_stat>:
SYSCALL(wait_stat)
 393:	b8 16 00 00 00       	mov    $0x16,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39b:	f3 0f 1e fb          	endbr32 
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 18             	sub    $0x18,%esp
 3a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ab:	83 ec 04             	sub    $0x4,%esp
 3ae:	6a 01                	push   $0x1
 3b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b3:	50                   	push   %eax
 3b4:	ff 75 08             	pushl  0x8(%ebp)
 3b7:	e8 57 ff ff ff       	call   313 <write>
 3bc:	83 c4 10             	add    $0x10,%esp
}
 3bf:	90                   	nop
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    

000003c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c2:	f3 0f 1e fb          	endbr32 
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
 3c9:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d7:	74 17                	je     3f0 <printint+0x2e>
 3d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3dd:	79 11                	jns    3f0 <printint+0x2e>
    neg = 1;
 3df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	f7 d8                	neg    %eax
 3eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ee:	eb 06                	jmp    3f6 <printint+0x34>
  } else {
    x = xx;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 400:	8b 45 ec             	mov    -0x14(%ebp),%eax
 403:	ba 00 00 00 00       	mov    $0x0,%edx
 408:	f7 f1                	div    %ecx
 40a:	89 d1                	mov    %edx,%ecx
 40c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40f:	8d 50 01             	lea    0x1(%eax),%edx
 412:	89 55 f4             	mov    %edx,-0xc(%ebp)
 415:	0f b6 91 b4 0a 00 00 	movzbl 0xab4(%ecx),%edx
 41c:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 420:	8b 4d 10             	mov    0x10(%ebp),%ecx
 423:	8b 45 ec             	mov    -0x14(%ebp),%eax
 426:	ba 00 00 00 00       	mov    $0x0,%edx
 42b:	f7 f1                	div    %ecx
 42d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 430:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 434:	75 c7                	jne    3fd <printint+0x3b>
  if(neg)
 436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43a:	74 2d                	je     469 <printint+0xa7>
    buf[i++] = '-';
 43c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43f:	8d 50 01             	lea    0x1(%eax),%edx
 442:	89 55 f4             	mov    %edx,-0xc(%ebp)
 445:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 44a:	eb 1d                	jmp    469 <printint+0xa7>
    putc(fd, buf[i]);
 44c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	0f be c0             	movsbl %al,%eax
 45a:	83 ec 08             	sub    $0x8,%esp
 45d:	50                   	push   %eax
 45e:	ff 75 08             	pushl  0x8(%ebp)
 461:	e8 35 ff ff ff       	call   39b <putc>
 466:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 469:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 471:	79 d9                	jns    44c <printint+0x8a>
}
 473:	90                   	nop
 474:	90                   	nop
 475:	c9                   	leave  
 476:	c3                   	ret    

00000477 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 477:	f3 0f 1e fb          	endbr32 
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 481:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 488:	8d 45 0c             	lea    0xc(%ebp),%eax
 48b:	83 c0 04             	add    $0x4,%eax
 48e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 498:	e9 59 01 00 00       	jmp    5f6 <printf+0x17f>
    c = fmt[i] & 0xff;
 49d:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a3:	01 d0                	add    %edx,%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	0f be c0             	movsbl %al,%eax
 4ab:	25 ff 00 00 00       	and    $0xff,%eax
 4b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b7:	75 2c                	jne    4e5 <printf+0x6e>
      if(c == '%'){
 4b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bd:	75 0c                	jne    4cb <printf+0x54>
        state = '%';
 4bf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c6:	e9 27 01 00 00       	jmp    5f2 <printf+0x17b>
      } else {
        putc(fd, c);
 4cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	83 ec 08             	sub    $0x8,%esp
 4d4:	50                   	push   %eax
 4d5:	ff 75 08             	pushl  0x8(%ebp)
 4d8:	e8 be fe ff ff       	call   39b <putc>
 4dd:	83 c4 10             	add    $0x10,%esp
 4e0:	e9 0d 01 00 00       	jmp    5f2 <printf+0x17b>
      }
    } else if(state == '%'){
 4e5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e9:	0f 85 03 01 00 00    	jne    5f2 <printf+0x17b>
      if(c == 'd'){
 4ef:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f3:	75 1e                	jne    513 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 4f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f8:	8b 00                	mov    (%eax),%eax
 4fa:	6a 01                	push   $0x1
 4fc:	6a 0a                	push   $0xa
 4fe:	50                   	push   %eax
 4ff:	ff 75 08             	pushl  0x8(%ebp)
 502:	e8 bb fe ff ff       	call   3c2 <printint>
 507:	83 c4 10             	add    $0x10,%esp
        ap++;
 50a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50e:	e9 d8 00 00 00       	jmp    5eb <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 513:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 517:	74 06                	je     51f <printf+0xa8>
 519:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51d:	75 1e                	jne    53d <printf+0xc6>
        printint(fd, *ap, 16, 0);
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	6a 00                	push   $0x0
 526:	6a 10                	push   $0x10
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 91 fe ff ff       	call   3c2 <printint>
 531:	83 c4 10             	add    $0x10,%esp
        ap++;
 534:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 538:	e9 ae 00 00 00       	jmp    5eb <printf+0x174>
      } else if(c == 's'){
 53d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 541:	75 43                	jne    586 <printf+0x10f>
        s = (char*)*ap;
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 553:	75 25                	jne    57a <printf+0x103>
          s = "(null)";
 555:	c7 45 f4 65 08 00 00 	movl   $0x865,-0xc(%ebp)
        while(*s != 0){
 55c:	eb 1c                	jmp    57a <printf+0x103>
          putc(fd, *s);
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	0f b6 00             	movzbl (%eax),%eax
 564:	0f be c0             	movsbl %al,%eax
 567:	83 ec 08             	sub    $0x8,%esp
 56a:	50                   	push   %eax
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 28 fe ff ff       	call   39b <putc>
 573:	83 c4 10             	add    $0x10,%esp
          s++;
 576:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 57a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	84 c0                	test   %al,%al
 582:	75 da                	jne    55e <printf+0xe7>
 584:	eb 65                	jmp    5eb <printf+0x174>
        }
      } else if(c == 'c'){
 586:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58a:	75 1d                	jne    5a9 <printf+0x132>
        putc(fd, *ap);
 58c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58f:	8b 00                	mov    (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 fb fd ff ff       	call   39b <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a7:	eb 42                	jmp    5eb <printf+0x174>
      } else if(c == '%'){
 5a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ad:	75 17                	jne    5c6 <printf+0x14f>
        putc(fd, c);
 5af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 da fd ff ff       	call   39b <putc>
 5c1:	83 c4 10             	add    $0x10,%esp
 5c4:	eb 25                	jmp    5eb <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	6a 25                	push   $0x25
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 c8 fd ff ff       	call   39b <putc>
 5d3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	83 ec 08             	sub    $0x8,%esp
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 b3 fd ff ff       	call   39b <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fc:	01 d0                	add    %edx,%eax
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	84 c0                	test   %al,%al
 603:	0f 85 94 fe ff ff    	jne    49d <printf+0x26>
    }
  }
}
 609:	90                   	nop
 60a:	90                   	nop
 60b:	c9                   	leave  
 60c:	c3                   	ret    

0000060d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60d:	f3 0f 1e fb          	endbr32 
 611:	55                   	push   %ebp
 612:	89 e5                	mov    %esp,%ebp
 614:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	83 e8 08             	sub    $0x8,%eax
 61d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 620:	a1 d0 0a 00 00       	mov    0xad0,%eax
 625:	89 45 fc             	mov    %eax,-0x4(%ebp)
 628:	eb 24                	jmp    64e <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 632:	72 12                	jb     646 <free+0x39>
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	77 24                	ja     660 <free+0x53>
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 644:	72 1a                	jb     660 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 654:	76 d4                	jbe    62a <free+0x1d>
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 65e:	73 ca                	jae    62a <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	8b 40 04             	mov    0x4(%eax),%eax
 666:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	01 c2                	add    %eax,%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	39 c2                	cmp    %eax,%edx
 679:	75 24                	jne    69f <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	8b 50 04             	mov    0x4(%eax),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	8b 40 04             	mov    0x4(%eax),%eax
 689:	01 c2                	add    %eax,%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	8b 10                	mov    (%eax),%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	89 10                	mov    %edx,(%eax)
 69d:	eb 0a                	jmp    6a9 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 40 04             	mov    0x4(%eax),%eax
 6af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	01 d0                	add    %edx,%eax
 6bb:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6be:	75 20                	jne    6e0 <free+0xd3>
    p->s.size += bp->s.size;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 50 04             	mov    0x4(%eax),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	01 c2                	add    %eax,%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 10                	mov    (%eax),%edx
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	89 10                	mov    %edx,(%eax)
 6de:	eb 08                	jmp    6e8 <free+0xdb>
  } else
    p->s.ptr = bp;
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 6f0:	90                   	nop
 6f1:	c9                   	leave  
 6f2:	c3                   	ret    

000006f3 <morecore>:

static Header*
morecore(uint nu)
{
 6f3:	f3 0f 1e fb          	endbr32 
 6f7:	55                   	push   %ebp
 6f8:	89 e5                	mov    %esp,%ebp
 6fa:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 704:	77 07                	ja     70d <morecore+0x1a>
    nu = 4096;
 706:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	c1 e0 03             	shl    $0x3,%eax
 713:	83 ec 0c             	sub    $0xc,%esp
 716:	50                   	push   %eax
 717:	e8 5f fc ff ff       	call   37b <sbrk>
 71c:	83 c4 10             	add    $0x10,%esp
 71f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 722:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 726:	75 07                	jne    72f <morecore+0x3c>
    return 0;
 728:	b8 00 00 00 00       	mov    $0x0,%eax
 72d:	eb 26                	jmp    755 <morecore+0x62>
  hp = (Header*)p;
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 735:	8b 45 f0             	mov    -0x10(%ebp),%eax
 738:	8b 55 08             	mov    0x8(%ebp),%edx
 73b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	83 c0 08             	add    $0x8,%eax
 744:	83 ec 0c             	sub    $0xc,%esp
 747:	50                   	push   %eax
 748:	e8 c0 fe ff ff       	call   60d <free>
 74d:	83 c4 10             	add    $0x10,%esp
  return freep;
 750:	a1 d0 0a 00 00       	mov    0xad0,%eax
}
 755:	c9                   	leave  
 756:	c3                   	ret    

00000757 <malloc>:

void*
malloc(uint nbytes)
{
 757:	f3 0f 1e fb          	endbr32 
 75b:	55                   	push   %ebp
 75c:	89 e5                	mov    %esp,%ebp
 75e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	83 c0 07             	add    $0x7,%eax
 767:	c1 e8 03             	shr    $0x3,%eax
 76a:	83 c0 01             	add    $0x1,%eax
 76d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 770:	a1 d0 0a 00 00       	mov    0xad0,%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
 778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77c:	75 23                	jne    7a1 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 77e:	c7 45 f0 c8 0a 00 00 	movl   $0xac8,-0x10(%ebp)
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	a3 d0 0a 00 00       	mov    %eax,0xad0
 78d:	a1 d0 0a 00 00       	mov    0xad0,%eax
 792:	a3 c8 0a 00 00       	mov    %eax,0xac8
    base.s.size = 0;
 797:	c7 05 cc 0a 00 00 00 	movl   $0x0,0xacc
 79e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7b2:	77 4d                	ja     801 <malloc+0xaa>
      if(p->s.size == nunits)
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7bd:	75 0c                	jne    7cb <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
 7c9:	eb 26                	jmp    7f1 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d4:	89 c2                	mov    %eax,%edx
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	c1 e0 03             	shl    $0x3,%eax
 7e5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	a3 d0 0a 00 00       	mov    %eax,0xad0
      return (void*)(p + 1);
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	83 c0 08             	add    $0x8,%eax
 7ff:	eb 3b                	jmp    83c <malloc+0xe5>
    }
    if(p == freep)
 801:	a1 d0 0a 00 00       	mov    0xad0,%eax
 806:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 809:	75 1e                	jne    829 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	ff 75 ec             	pushl  -0x14(%ebp)
 811:	e8 dd fe ff ff       	call   6f3 <morecore>
 816:	83 c4 10             	add    $0x10,%esp
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 820:	75 07                	jne    829 <malloc+0xd2>
        return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 13                	jmp    83c <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 837:	e9 6d ff ff ff       	jmp    7a9 <malloc+0x52>
  }
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    
