
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   a:	eb 15                	jmp    21 <cat+0x21>
    write(1, buf, n);
   c:	83 ec 04             	sub    $0x4,%esp
   f:	ff 75 f4             	pushl  -0xc(%ebp)
  12:	68 c0 0b 00 00       	push   $0xbc0
  17:	6a 01                	push   $0x1
  19:	e8 94 03 00 00       	call   3b2 <write>
  1e:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf, sizeof(buf))) > 0)
  21:	83 ec 04             	sub    $0x4,%esp
  24:	68 00 02 00 00       	push   $0x200
  29:	68 c0 0b 00 00       	push   $0xbc0
  2e:	ff 75 08             	pushl  0x8(%ebp)
  31:	e8 74 03 00 00       	call   3aa <read>
  36:	83 c4 10             	add    $0x10,%esp
  39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  40:	7f ca                	jg     c <cat+0xc>
  if(n < 0){
  42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  46:	79 17                	jns    5f <cat+0x5f>
    printf(1, "cat: read error\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 dd 08 00 00       	push   $0x8dd
  50:	6a 01                	push   $0x1
  52:	e8 bf 04 00 00       	call   516 <printf>
  57:	83 c4 10             	add    $0x10,%esp
    exit();
  5a:	e8 33 03 00 00       	call   392 <exit>
  }
}
  5f:	90                   	nop
  60:	c9                   	leave  
  61:	c3                   	ret    

00000062 <main>:

int
main(int argc, char *argv[])
{
  62:	f3 0f 1e fb          	endbr32 
  66:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  6a:	83 e4 f0             	and    $0xfffffff0,%esp
  6d:	ff 71 fc             	pushl  -0x4(%ecx)
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	51                   	push   %ecx
  75:	83 ec 10             	sub    $0x10,%esp
  78:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  7a:	83 3b 01             	cmpl   $0x1,(%ebx)
  7d:	7f 12                	jg     91 <main+0x2f>
    cat(0);
  7f:	83 ec 0c             	sub    $0xc,%esp
  82:	6a 00                	push   $0x0
  84:	e8 77 ff ff ff       	call   0 <cat>
  89:	83 c4 10             	add    $0x10,%esp
    exit();
  8c:	e8 01 03 00 00       	call   392 <exit>
  }

  for(i = 1; i < argc; i++){
  91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  98:	eb 71                	jmp    10b <main+0xa9>
    if((fd = open(argv[i], 0)) < 0){
  9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  a4:	8b 43 04             	mov    0x4(%ebx),%eax
  a7:	01 d0                	add    %edx,%eax
  a9:	8b 00                	mov    (%eax),%eax
  ab:	83 ec 08             	sub    $0x8,%esp
  ae:	6a 00                	push   $0x0
  b0:	50                   	push   %eax
  b1:	e8 1c 03 00 00       	call   3d2 <open>
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  c0:	79 29                	jns    eb <main+0x89>
      printf(1, "cat: cannot open %s\n", argv[i]);
  c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  cc:	8b 43 04             	mov    0x4(%ebx),%eax
  cf:	01 d0                	add    %edx,%eax
  d1:	8b 00                	mov    (%eax),%eax
  d3:	83 ec 04             	sub    $0x4,%esp
  d6:	50                   	push   %eax
  d7:	68 ee 08 00 00       	push   $0x8ee
  dc:	6a 01                	push   $0x1
  de:	e8 33 04 00 00       	call   516 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
      exit();
  e6:	e8 a7 02 00 00       	call   392 <exit>
    }
    cat(fd);
  eb:	83 ec 0c             	sub    $0xc,%esp
  ee:	ff 75 f0             	pushl  -0x10(%ebp)
  f1:	e8 0a ff ff ff       	call   0 <cat>
  f6:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f9:	83 ec 0c             	sub    $0xc,%esp
  fc:	ff 75 f0             	pushl  -0x10(%ebp)
  ff:	e8 b6 02 00 00       	call   3ba <close>
 104:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 107:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 10b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 10e:	3b 03                	cmp    (%ebx),%eax
 110:	7c 88                	jl     9a <main+0x38>
  }
  exit();
 112:	e8 7b 02 00 00       	call   392 <exit>

00000117 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	57                   	push   %edi
 11b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11f:	8b 55 10             	mov    0x10(%ebp),%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	89 cb                	mov    %ecx,%ebx
 127:	89 df                	mov    %ebx,%edi
 129:	89 d1                	mov    %edx,%ecx
 12b:	fc                   	cld    
 12c:	f3 aa                	rep stos %al,%es:(%edi)
 12e:	89 ca                	mov    %ecx,%edx
 130:	89 fb                	mov    %edi,%ebx
 132:	89 5d 08             	mov    %ebx,0x8(%ebp)
 135:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 138:	90                   	nop
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13d:	f3 0f 1e fb          	endbr32 
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14d:	90                   	nop
 14e:	8b 55 0c             	mov    0xc(%ebp),%edx
 151:	8d 42 01             	lea    0x1(%edx),%eax
 154:	89 45 0c             	mov    %eax,0xc(%ebp)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	8d 48 01             	lea    0x1(%eax),%ecx
 15d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 160:	0f b6 12             	movzbl (%edx),%edx
 163:	88 10                	mov    %dl,(%eax)
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	84 c0                	test   %al,%al
 16a:	75 e2                	jne    14e <strcpy+0x11>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 171:	f3 0f 1e fb          	endbr32 
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 178:	eb 08                	jmp    182 <strcmp+0x11>
    p++, q++;
 17a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	74 10                	je     19c <strcmp+0x2b>
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 10             	movzbl (%eax),%edx
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	38 c2                	cmp    %al,%dl
 19a:	74 de                	je     17a <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	0f b6 d0             	movzbl %al,%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	0f b6 00             	movzbl (%eax),%eax
 1ab:	0f b6 c0             	movzbl %al,%eax
 1ae:	29 c2                	sub    %eax,%edx
 1b0:	89 d0                	mov    %edx,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <strlen>:

uint
strlen(char *s)
{
 1b4:	f3 0f 1e fb          	endbr32 
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c5:	eb 04                	jmp    1cb <strlen+0x17>
 1c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	75 ed                	jne    1c7 <strlen+0x13>
    ;
  return n;
 1da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <memset>:

void*
memset(void *dst, int c, uint n)
{
 1df:	f3 0f 1e fb          	endbr32 
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e6:	8b 45 10             	mov    0x10(%ebp),%eax
 1e9:	50                   	push   %eax
 1ea:	ff 75 0c             	pushl  0xc(%ebp)
 1ed:	ff 75 08             	pushl  0x8(%ebp)
 1f0:	e8 22 ff ff ff       	call   117 <stosb>
 1f5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <strchr>:

char*
strchr(const char *s, char c)
{
 1fd:	f3 0f 1e fb          	endbr32 
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20d:	eb 14                	jmp    223 <strchr+0x26>
    if(*s == c)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	38 45 fc             	cmp    %al,-0x4(%ebp)
 218:	75 05                	jne    21f <strchr+0x22>
      return (char*)s;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x35>
  for(; *s; s++)
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0x12>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <gets>:

char*
gets(char *buf, int max)
{
 234:	f3 0f 1e fb          	endbr32 
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 245:	eb 42                	jmp    289 <gets+0x55>
    cc = read(0, &c, 1);
 247:	83 ec 04             	sub    $0x4,%esp
 24a:	6a 01                	push   $0x1
 24c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24f:	50                   	push   %eax
 250:	6a 00                	push   $0x0
 252:	e8 53 01 00 00       	call   3aa <read>
 257:	83 c4 10             	add    $0x10,%esp
 25a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 261:	7e 33                	jle    296 <gets+0x62>
      break;
    buf[i++] = c;
 263:	8b 45 f4             	mov    -0xc(%ebp),%eax
 266:	8d 50 01             	lea    0x1(%eax),%edx
 269:	89 55 f4             	mov    %edx,-0xc(%ebp)
 26c:	89 c2                	mov    %eax,%edx
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	01 c2                	add    %eax,%edx
 273:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 277:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0a                	cmp    $0xa,%al
 27f:	74 16                	je     297 <gets+0x63>
 281:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 285:	3c 0d                	cmp    $0xd,%al
 287:	74 0e                	je     297 <gets+0x63>
  for(i=0; i+1 < max; ){
 289:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28c:	83 c0 01             	add    $0x1,%eax
 28f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 292:	7f b3                	jg     247 <gets+0x13>
 294:	eb 01                	jmp    297 <gets+0x63>
      break;
 296:	90                   	nop
      break;
  }
  buf[i] = '\0';
 297:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	01 d0                	add    %edx,%eax
 29f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <stat>:

int
stat(char *n, struct stat *st)
{
 2a7:	f3 0f 1e fb          	endbr32 
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b1:	83 ec 08             	sub    $0x8,%esp
 2b4:	6a 00                	push   $0x0
 2b6:	ff 75 08             	pushl  0x8(%ebp)
 2b9:	e8 14 01 00 00       	call   3d2 <open>
 2be:	83 c4 10             	add    $0x10,%esp
 2c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c8:	79 07                	jns    2d1 <stat+0x2a>
    return -1;
 2ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cf:	eb 25                	jmp    2f6 <stat+0x4f>
  r = fstat(fd, st);
 2d1:	83 ec 08             	sub    $0x8,%esp
 2d4:	ff 75 0c             	pushl  0xc(%ebp)
 2d7:	ff 75 f4             	pushl  -0xc(%ebp)
 2da:	e8 0b 01 00 00       	call   3ea <fstat>
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e5:	83 ec 0c             	sub    $0xc,%esp
 2e8:	ff 75 f4             	pushl  -0xc(%ebp)
 2eb:	e8 ca 00 00 00       	call   3ba <close>
 2f0:	83 c4 10             	add    $0x10,%esp
  return r;
 2f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	f3 0f 1e fb          	endbr32 
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 302:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 309:	eb 25                	jmp    330 <atoi+0x38>
    n = n*10 + *s++ - '0';
 30b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30e:	89 d0                	mov    %edx,%eax
 310:	c1 e0 02             	shl    $0x2,%eax
 313:	01 d0                	add    %edx,%eax
 315:	01 c0                	add    %eax,%eax
 317:	89 c1                	mov    %eax,%ecx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	8d 50 01             	lea    0x1(%eax),%edx
 31f:	89 55 08             	mov    %edx,0x8(%ebp)
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	0f be c0             	movsbl %al,%eax
 328:	01 c8                	add    %ecx,%eax
 32a:	83 e8 30             	sub    $0x30,%eax
 32d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	3c 2f                	cmp    $0x2f,%al
 338:	7e 0a                	jle    344 <atoi+0x4c>
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	3c 39                	cmp    $0x39,%al
 342:	7e c7                	jle    30b <atoi+0x13>
  return n;
 344:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 349:	f3 0f 1e fb          	endbr32 
 34d:	55                   	push   %ebp
 34e:	89 e5                	mov    %esp,%ebp
 350:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 35f:	eb 17                	jmp    378 <memmove+0x2f>
    *dst++ = *src++;
 361:	8b 55 f8             	mov    -0x8(%ebp),%edx
 364:	8d 42 01             	lea    0x1(%edx),%eax
 367:	89 45 f8             	mov    %eax,-0x8(%ebp)
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36d:	8d 48 01             	lea    0x1(%eax),%ecx
 370:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 373:	0f b6 12             	movzbl (%edx),%edx
 376:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 378:	8b 45 10             	mov    0x10(%ebp),%eax
 37b:	8d 50 ff             	lea    -0x1(%eax),%edx
 37e:	89 55 10             	mov    %edx,0x10(%ebp)
 381:	85 c0                	test   %eax,%eax
 383:	7f dc                	jg     361 <memmove+0x18>
  return vdst;
 385:	8b 45 08             	mov    0x8(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38a:	b8 01 00 00 00       	mov    $0x1,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <exit>:
SYSCALL(exit)
 392:	b8 02 00 00 00       	mov    $0x2,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <wait>:
SYSCALL(wait)
 39a:	b8 03 00 00 00       	mov    $0x3,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <pipe>:
SYSCALL(pipe)
 3a2:	b8 04 00 00 00       	mov    $0x4,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <read>:
SYSCALL(read)
 3aa:	b8 05 00 00 00       	mov    $0x5,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <write>:
SYSCALL(write)
 3b2:	b8 10 00 00 00       	mov    $0x10,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <close>:
SYSCALL(close)
 3ba:	b8 15 00 00 00       	mov    $0x15,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <kill>:
SYSCALL(kill)
 3c2:	b8 06 00 00 00       	mov    $0x6,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <exec>:
SYSCALL(exec)
 3ca:	b8 07 00 00 00       	mov    $0x7,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <open>:
SYSCALL(open)
 3d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mknod>:
SYSCALL(mknod)
 3da:	b8 11 00 00 00       	mov    $0x11,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <unlink>:
SYSCALL(unlink)
 3e2:	b8 12 00 00 00       	mov    $0x12,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <fstat>:
SYSCALL(fstat)
 3ea:	b8 08 00 00 00       	mov    $0x8,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <link>:
SYSCALL(link)
 3f2:	b8 13 00 00 00       	mov    $0x13,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <mkdir>:
SYSCALL(mkdir)
 3fa:	b8 14 00 00 00       	mov    $0x14,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <chdir>:
SYSCALL(chdir)
 402:	b8 09 00 00 00       	mov    $0x9,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <dup>:
SYSCALL(dup)
 40a:	b8 0a 00 00 00       	mov    $0xa,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <getpid>:
SYSCALL(getpid)
 412:	b8 0b 00 00 00       	mov    $0xb,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <sbrk>:
SYSCALL(sbrk)
 41a:	b8 0c 00 00 00       	mov    $0xc,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <sleep>:
SYSCALL(sleep)
 422:	b8 0d 00 00 00       	mov    $0xd,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <uptime>:
SYSCALL(uptime)
 42a:	b8 0e 00 00 00       	mov    $0xe,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <wait_stat>:
SYSCALL(wait_stat)
 432:	b8 16 00 00 00       	mov    $0x16,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43a:	f3 0f 1e fb          	endbr32 
 43e:	55                   	push   %ebp
 43f:	89 e5                	mov    %esp,%ebp
 441:	83 ec 18             	sub    $0x18,%esp
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 44a:	83 ec 04             	sub    $0x4,%esp
 44d:	6a 01                	push   $0x1
 44f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 452:	50                   	push   %eax
 453:	ff 75 08             	pushl  0x8(%ebp)
 456:	e8 57 ff ff ff       	call   3b2 <write>
 45b:	83 c4 10             	add    $0x10,%esp
}
 45e:	90                   	nop
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 461:	f3 0f 1e fb          	endbr32 
 465:	55                   	push   %ebp
 466:	89 e5                	mov    %esp,%ebp
 468:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 472:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 476:	74 17                	je     48f <printint+0x2e>
 478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 47c:	79 11                	jns    48f <printint+0x2e>
    neg = 1;
 47e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 485:	8b 45 0c             	mov    0xc(%ebp),%eax
 488:	f7 d8                	neg    %eax
 48a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48d:	eb 06                	jmp    495 <printint+0x34>
  } else {
    x = xx;
 48f:	8b 45 0c             	mov    0xc(%ebp),%eax
 492:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 49c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 49f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a2:	ba 00 00 00 00       	mov    $0x0,%edx
 4a7:	f7 f1                	div    %ecx
 4a9:	89 d1                	mov    %edx,%ecx
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	8d 50 01             	lea    0x1(%eax),%edx
 4b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b4:	0f b6 91 74 0b 00 00 	movzbl 0xb74(%ecx),%edx
 4bb:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c5:	ba 00 00 00 00       	mov    $0x0,%edx
 4ca:	f7 f1                	div    %ecx
 4cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d3:	75 c7                	jne    49c <printint+0x3b>
  if(neg)
 4d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d9:	74 2d                	je     508 <printint+0xa7>
    buf[i++] = '-';
 4db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4de:	8d 50 01             	lea    0x1(%eax),%edx
 4e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e9:	eb 1d                	jmp    508 <printint+0xa7>
    putc(fd, buf[i]);
 4eb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f1:	01 d0                	add    %edx,%eax
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f be c0             	movsbl %al,%eax
 4f9:	83 ec 08             	sub    $0x8,%esp
 4fc:	50                   	push   %eax
 4fd:	ff 75 08             	pushl  0x8(%ebp)
 500:	e8 35 ff ff ff       	call   43a <putc>
 505:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 508:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 50c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 510:	79 d9                	jns    4eb <printint+0x8a>
}
 512:	90                   	nop
 513:	90                   	nop
 514:	c9                   	leave  
 515:	c3                   	ret    

00000516 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 516:	f3 0f 1e fb          	endbr32 
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 520:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 527:	8d 45 0c             	lea    0xc(%ebp),%eax
 52a:	83 c0 04             	add    $0x4,%eax
 52d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 530:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 537:	e9 59 01 00 00       	jmp    695 <printf+0x17f>
    c = fmt[i] & 0xff;
 53c:	8b 55 0c             	mov    0xc(%ebp),%edx
 53f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 542:	01 d0                	add    %edx,%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	25 ff 00 00 00       	and    $0xff,%eax
 54f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 556:	75 2c                	jne    584 <printf+0x6e>
      if(c == '%'){
 558:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55c:	75 0c                	jne    56a <printf+0x54>
        state = '%';
 55e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 565:	e9 27 01 00 00       	jmp    691 <printf+0x17b>
      } else {
        putc(fd, c);
 56a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 ec 08             	sub    $0x8,%esp
 573:	50                   	push   %eax
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 be fe ff ff       	call   43a <putc>
 57c:	83 c4 10             	add    $0x10,%esp
 57f:	e9 0d 01 00 00       	jmp    691 <printf+0x17b>
      }
    } else if(state == '%'){
 584:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 588:	0f 85 03 01 00 00    	jne    691 <printf+0x17b>
      if(c == 'd'){
 58e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 592:	75 1e                	jne    5b2 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 594:	8b 45 e8             	mov    -0x18(%ebp),%eax
 597:	8b 00                	mov    (%eax),%eax
 599:	6a 01                	push   $0x1
 59b:	6a 0a                	push   $0xa
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 bb fe ff ff       	call   461 <printint>
 5a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	e9 d8 00 00 00       	jmp    68a <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 5b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b6:	74 06                	je     5be <printf+0xa8>
 5b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5bc:	75 1e                	jne    5dc <printf+0xc6>
        printint(fd, *ap, 16, 0);
 5be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	6a 00                	push   $0x0
 5c5:	6a 10                	push   $0x10
 5c7:	50                   	push   %eax
 5c8:	ff 75 08             	pushl  0x8(%ebp)
 5cb:	e8 91 fe ff ff       	call   461 <printint>
 5d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d7:	e9 ae 00 00 00       	jmp    68a <printf+0x174>
      } else if(c == 's'){
 5dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e0:	75 43                	jne    625 <printf+0x10f>
        s = (char*)*ap;
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f2:	75 25                	jne    619 <printf+0x103>
          s = "(null)";
 5f4:	c7 45 f4 03 09 00 00 	movl   $0x903,-0xc(%ebp)
        while(*s != 0){
 5fb:	eb 1c                	jmp    619 <printf+0x103>
          putc(fd, *s);
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	0f b6 00             	movzbl (%eax),%eax
 603:	0f be c0             	movsbl %al,%eax
 606:	83 ec 08             	sub    $0x8,%esp
 609:	50                   	push   %eax
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 28 fe ff ff       	call   43a <putc>
 612:	83 c4 10             	add    $0x10,%esp
          s++;
 615:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 619:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	84 c0                	test   %al,%al
 621:	75 da                	jne    5fd <printf+0xe7>
 623:	eb 65                	jmp    68a <printf+0x174>
        }
      } else if(c == 'c'){
 625:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 629:	75 1d                	jne    648 <printf+0x132>
        putc(fd, *ap);
 62b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	83 ec 08             	sub    $0x8,%esp
 636:	50                   	push   %eax
 637:	ff 75 08             	pushl  0x8(%ebp)
 63a:	e8 fb fd ff ff       	call   43a <putc>
 63f:	83 c4 10             	add    $0x10,%esp
        ap++;
 642:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 646:	eb 42                	jmp    68a <printf+0x174>
      } else if(c == '%'){
 648:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64c:	75 17                	jne    665 <printf+0x14f>
        putc(fd, c);
 64e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	83 ec 08             	sub    $0x8,%esp
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 da fd ff ff       	call   43a <putc>
 660:	83 c4 10             	add    $0x10,%esp
 663:	eb 25                	jmp    68a <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 665:	83 ec 08             	sub    $0x8,%esp
 668:	6a 25                	push   $0x25
 66a:	ff 75 08             	pushl  0x8(%ebp)
 66d:	e8 c8 fd ff ff       	call   43a <putc>
 672:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	83 ec 08             	sub    $0x8,%esp
 67e:	50                   	push   %eax
 67f:	ff 75 08             	pushl  0x8(%ebp)
 682:	e8 b3 fd ff ff       	call   43a <putc>
 687:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 691:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 695:	8b 55 0c             	mov    0xc(%ebp),%edx
 698:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69b:	01 d0                	add    %edx,%eax
 69d:	0f b6 00             	movzbl (%eax),%eax
 6a0:	84 c0                	test   %al,%al
 6a2:	0f 85 94 fe ff ff    	jne    53c <printf+0x26>
    }
  }
}
 6a8:	90                   	nop
 6a9:	90                   	nop
 6aa:	c9                   	leave  
 6ab:	c3                   	ret    

000006ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ac:	f3 0f 1e fb          	endbr32 
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	83 e8 08             	sub    $0x8,%eax
 6bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bf:	a1 a8 0b 00 00       	mov    0xba8,%eax
 6c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c7:	eb 24                	jmp    6ed <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6d1:	72 12                	jb     6e5 <free+0x39>
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 24                	ja     6ff <free+0x53>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6e3:	72 1a                	jb     6ff <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	76 d4                	jbe    6c9 <free+0x1d>
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6fd:	73 ca                	jae    6c9 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	39 c2                	cmp    %eax,%edx
 718:	75 24                	jne    73e <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 50 04             	mov    0x4(%eax),%edx
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 40 04             	mov    0x4(%eax),%eax
 728:	01 c2                	add    %eax,%edx
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	8b 10                	mov    (%eax),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	89 10                	mov    %edx,(%eax)
 73c:	eb 0a                	jmp    748 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 75d:	75 20                	jne    77f <free+0xd3>
    p->s.size += bp->s.size;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 50 04             	mov    0x4(%eax),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	01 c2                	add    %eax,%edx
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 08                	jmp    787 <free+0xdb>
  } else
    p->s.ptr = bp;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 55 f8             	mov    -0x8(%ebp),%edx
 785:	89 10                	mov    %edx,(%eax)
  freep = p;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 78f:	90                   	nop
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <morecore>:

static Header*
morecore(uint nu)
{
 792:	f3 0f 1e fb          	endbr32 
 796:	55                   	push   %ebp
 797:	89 e5                	mov    %esp,%ebp
 799:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a3:	77 07                	ja     7ac <morecore+0x1a>
    nu = 4096;
 7a5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	c1 e0 03             	shl    $0x3,%eax
 7b2:	83 ec 0c             	sub    $0xc,%esp
 7b5:	50                   	push   %eax
 7b6:	e8 5f fc ff ff       	call   41a <sbrk>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c5:	75 07                	jne    7ce <morecore+0x3c>
    return 0;
 7c7:	b8 00 00 00 00       	mov    $0x0,%eax
 7cc:	eb 26                	jmp    7f4 <morecore+0x62>
  hp = (Header*)p;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	8b 55 08             	mov    0x8(%ebp),%edx
 7da:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	83 c0 08             	add    $0x8,%eax
 7e3:	83 ec 0c             	sub    $0xc,%esp
 7e6:	50                   	push   %eax
 7e7:	e8 c0 fe ff ff       	call   6ac <free>
 7ec:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ef:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    

000007f6 <malloc>:

void*
malloc(uint nbytes)
{
 7f6:	f3 0f 1e fb          	endbr32 
 7fa:	55                   	push   %ebp
 7fb:	89 e5                	mov    %esp,%ebp
 7fd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	83 c0 07             	add    $0x7,%eax
 806:	c1 e8 03             	shr    $0x3,%eax
 809:	83 c0 01             	add    $0x1,%eax
 80c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80f:	a1 a8 0b 00 00       	mov    0xba8,%eax
 814:	89 45 f0             	mov    %eax,-0x10(%ebp)
 817:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81b:	75 23                	jne    840 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 81d:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	a3 a8 0b 00 00       	mov    %eax,0xba8
 82c:	a1 a8 0b 00 00       	mov    0xba8,%eax
 831:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 836:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 83d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	8b 45 f0             	mov    -0x10(%ebp),%eax
 843:	8b 00                	mov    (%eax),%eax
 845:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 851:	77 4d                	ja     8a0 <malloc+0xaa>
      if(p->s.size == nunits)
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 85c:	75 0c                	jne    86a <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8b 10                	mov    (%eax),%edx
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	89 10                	mov    %edx,(%eax)
 868:	eb 26                	jmp    890 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	8b 40 04             	mov    0x4(%eax),%eax
 870:	2b 45 ec             	sub    -0x14(%ebp),%eax
 873:	89 c2                	mov    %eax,%edx
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 40 04             	mov    0x4(%eax),%eax
 881:	c1 e0 03             	shl    $0x3,%eax
 884:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 88d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 890:	8b 45 f0             	mov    -0x10(%ebp),%eax
 893:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	83 c0 08             	add    $0x8,%eax
 89e:	eb 3b                	jmp    8db <malloc+0xe5>
    }
    if(p == freep)
 8a0:	a1 a8 0b 00 00       	mov    0xba8,%eax
 8a5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a8:	75 1e                	jne    8c8 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 8aa:	83 ec 0c             	sub    $0xc,%esp
 8ad:	ff 75 ec             	pushl  -0x14(%ebp)
 8b0:	e8 dd fe ff ff       	call   792 <morecore>
 8b5:	83 c4 10             	add    $0x10,%esp
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8bf:	75 07                	jne    8c8 <malloc+0xd2>
        return 0;
 8c1:	b8 00 00 00 00       	mov    $0x0,%eax
 8c6:	eb 13                	jmp    8db <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	8b 00                	mov    (%eax),%eax
 8d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d6:	e9 6d ff ff ff       	jmp    848 <malloc+0x52>
  }
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    
