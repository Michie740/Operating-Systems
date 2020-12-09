
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 d6 10 80       	mov    $0x8010d650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f4 39 10 80       	mov    $0x801039f4,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	f3 0f 1e fb          	endbr32 
80100038:	55                   	push   %ebp
80100039:	89 e5                	mov    %esp,%ebp
8010003b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003e:	83 ec 08             	sub    $0x8,%esp
80100041:	68 8c 8c 10 80       	push   $0x80108c8c
80100046:	68 60 d6 10 80       	push   $0x8010d660
8010004b:	e8 2f 55 00 00       	call   8010557f <initlock>
80100050:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100053:	c7 05 70 15 11 80 64 	movl   $0x80111564,0x80111570
8010005a:	15 11 80 
  bcache.head.next = &bcache.head;
8010005d:	c7 05 74 15 11 80 64 	movl   $0x80111564,0x80111574
80100064:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100067:	c7 45 f4 94 d6 10 80 	movl   $0x8010d694,-0xc(%ebp)
8010006e:	eb 3a                	jmp    801000aa <binit+0x76>
    b->next = bcache.head.next;
80100070:	8b 15 74 15 11 80    	mov    0x80111574,%edx
80100076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100079:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
8010007c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007f:	c7 40 0c 64 15 11 80 	movl   $0x80111564,0xc(%eax)
    b->dev = -1;
80100086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100089:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100090:	a1 74 15 11 80       	mov    0x80111574,%eax
80100095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100098:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
8010009b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009e:	a3 74 15 11 80       	mov    %eax,0x80111574
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a3:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000aa:	b8 64 15 11 80       	mov    $0x80111564,%eax
801000af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000b2:	72 bc                	jb     80100070 <binit+0x3c>
  }
}
801000b4:	90                   	nop
801000b5:	90                   	nop
801000b6:	c9                   	leave  
801000b7:	c3                   	ret    

801000b8 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b8:	f3 0f 1e fb          	endbr32 
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 60 d6 10 80       	push   $0x8010d660
801000ca:	e8 d6 54 00 00       	call   801055a5 <acquire>
801000cf:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d2:	a1 74 15 11 80       	mov    0x80111574,%eax
801000d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000da:	eb 67                	jmp    80100143 <bget+0x8b>
    if(b->dev == dev && b->blockno == blockno){
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 04             	mov    0x4(%eax),%eax
801000e2:	39 45 08             	cmp    %eax,0x8(%ebp)
801000e5:	75 53                	jne    8010013a <bget+0x82>
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 40 08             	mov    0x8(%eax),%eax
801000ed:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000f0:	75 48                	jne    8010013a <bget+0x82>
      if(!(b->flags & B_BUSY)){
801000f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f5:	8b 00                	mov    (%eax),%eax
801000f7:	83 e0 01             	and    $0x1,%eax
801000fa:	85 c0                	test   %eax,%eax
801000fc:	75 27                	jne    80100125 <bget+0x6d>
        b->flags |= B_BUSY;
801000fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100101:	8b 00                	mov    (%eax),%eax
80100103:	83 c8 01             	or     $0x1,%eax
80100106:	89 c2                	mov    %eax,%edx
80100108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010b:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
8010010d:	83 ec 0c             	sub    $0xc,%esp
80100110:	68 60 d6 10 80       	push   $0x8010d660
80100115:	e8 f6 54 00 00       	call   80105610 <release>
8010011a:	83 c4 10             	add    $0x10,%esp
        return b;
8010011d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100120:	e9 98 00 00 00       	jmp    801001bd <bget+0x105>
      }
      sleep(b, &bcache.lock);
80100125:	83 ec 08             	sub    $0x8,%esp
80100128:	68 60 d6 10 80       	push   $0x8010d660
8010012d:	ff 75 f4             	pushl  -0xc(%ebp)
80100130:	e8 cd 4e 00 00       	call   80105002 <sleep>
80100135:	83 c4 10             	add    $0x10,%esp
      goto loop;
80100138:	eb 98                	jmp    801000d2 <bget+0x1a>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010013a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013d:	8b 40 10             	mov    0x10(%eax),%eax
80100140:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100143:	81 7d f4 64 15 11 80 	cmpl   $0x80111564,-0xc(%ebp)
8010014a:	75 90                	jne    801000dc <bget+0x24>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010014c:	a1 70 15 11 80       	mov    0x80111570,%eax
80100151:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100154:	eb 51                	jmp    801001a7 <bget+0xef>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100159:	8b 00                	mov    (%eax),%eax
8010015b:	83 e0 01             	and    $0x1,%eax
8010015e:	85 c0                	test   %eax,%eax
80100160:	75 3c                	jne    8010019e <bget+0xe6>
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 00                	mov    (%eax),%eax
80100167:	83 e0 04             	and    $0x4,%eax
8010016a:	85 c0                	test   %eax,%eax
8010016c:	75 30                	jne    8010019e <bget+0xe6>
      b->dev = dev;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 08             	mov    0x8(%ebp),%edx
80100174:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017d:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100183:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100189:	83 ec 0c             	sub    $0xc,%esp
8010018c:	68 60 d6 10 80       	push   $0x8010d660
80100191:	e8 7a 54 00 00       	call   80105610 <release>
80100196:	83 c4 10             	add    $0x10,%esp
      return b;
80100199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010019c:	eb 1f                	jmp    801001bd <bget+0x105>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010019e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a1:	8b 40 0c             	mov    0xc(%eax),%eax
801001a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001a7:	81 7d f4 64 15 11 80 	cmpl   $0x80111564,-0xc(%ebp)
801001ae:	75 a6                	jne    80100156 <bget+0x9e>
    }
  }
  panic("bget: no buffers");
801001b0:	83 ec 0c             	sub    $0xc,%esp
801001b3:	68 93 8c 10 80       	push   $0x80108c93
801001b8:	e8 da 03 00 00       	call   80100597 <panic>
}
801001bd:	c9                   	leave  
801001be:	c3                   	ret    

801001bf <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001bf:	f3 0f 1e fb          	endbr32 
801001c3:	55                   	push   %ebp
801001c4:	89 e5                	mov    %esp,%ebp
801001c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001c9:	83 ec 08             	sub    $0x8,%esp
801001cc:	ff 75 0c             	pushl  0xc(%ebp)
801001cf:	ff 75 08             	pushl  0x8(%ebp)
801001d2:	e8 e1 fe ff ff       	call   801000b8 <bget>
801001d7:	83 c4 10             	add    $0x10,%esp
801001da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e0:	8b 00                	mov    (%eax),%eax
801001e2:	83 e0 02             	and    $0x2,%eax
801001e5:	85 c0                	test   %eax,%eax
801001e7:	75 0e                	jne    801001f7 <bread+0x38>
    iderw(b);
801001e9:	83 ec 0c             	sub    $0xc,%esp
801001ec:	ff 75 f4             	pushl  -0xc(%ebp)
801001ef:	e8 05 28 00 00       	call   801029f9 <iderw>
801001f4:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001fa:	c9                   	leave  
801001fb:	c3                   	ret    

801001fc <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001fc:	f3 0f 1e fb          	endbr32 
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100206:	8b 45 08             	mov    0x8(%ebp),%eax
80100209:	8b 00                	mov    (%eax),%eax
8010020b:	83 e0 01             	and    $0x1,%eax
8010020e:	85 c0                	test   %eax,%eax
80100210:	75 0d                	jne    8010021f <bwrite+0x23>
    panic("bwrite");
80100212:	83 ec 0c             	sub    $0xc,%esp
80100215:	68 a4 8c 10 80       	push   $0x80108ca4
8010021a:	e8 78 03 00 00       	call   80100597 <panic>
  b->flags |= B_DIRTY;
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	8b 00                	mov    (%eax),%eax
80100224:	83 c8 04             	or     $0x4,%eax
80100227:	89 c2                	mov    %eax,%edx
80100229:	8b 45 08             	mov    0x8(%ebp),%eax
8010022c:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010022e:	83 ec 0c             	sub    $0xc,%esp
80100231:	ff 75 08             	pushl  0x8(%ebp)
80100234:	e8 c0 27 00 00       	call   801029f9 <iderw>
80100239:	83 c4 10             	add    $0x10,%esp
}
8010023c:	90                   	nop
8010023d:	c9                   	leave  
8010023e:	c3                   	ret    

8010023f <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010023f:	f3 0f 1e fb          	endbr32 
80100243:	55                   	push   %ebp
80100244:	89 e5                	mov    %esp,%ebp
80100246:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100249:	8b 45 08             	mov    0x8(%ebp),%eax
8010024c:	8b 00                	mov    (%eax),%eax
8010024e:	83 e0 01             	and    $0x1,%eax
80100251:	85 c0                	test   %eax,%eax
80100253:	75 0d                	jne    80100262 <brelse+0x23>
    panic("brelse");
80100255:	83 ec 0c             	sub    $0xc,%esp
80100258:	68 ab 8c 10 80       	push   $0x80108cab
8010025d:	e8 35 03 00 00       	call   80100597 <panic>

  acquire(&bcache.lock);
80100262:	83 ec 0c             	sub    $0xc,%esp
80100265:	68 60 d6 10 80       	push   $0x8010d660
8010026a:	e8 36 53 00 00       	call   801055a5 <acquire>
8010026f:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
80100272:	8b 45 08             	mov    0x8(%ebp),%eax
80100275:	8b 40 10             	mov    0x10(%eax),%eax
80100278:	8b 55 08             	mov    0x8(%ebp),%edx
8010027b:	8b 52 0c             	mov    0xc(%edx),%edx
8010027e:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	8b 40 0c             	mov    0xc(%eax),%eax
80100287:	8b 55 08             	mov    0x8(%ebp),%edx
8010028a:	8b 52 10             	mov    0x10(%edx),%edx
8010028d:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100290:	8b 15 74 15 11 80    	mov    0x80111574,%edx
80100296:	8b 45 08             	mov    0x8(%ebp),%eax
80100299:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	c7 40 0c 64 15 11 80 	movl   $0x80111564,0xc(%eax)
  bcache.head.next->prev = b;
801002a6:	a1 74 15 11 80       	mov    0x80111574,%eax
801002ab:	8b 55 08             	mov    0x8(%ebp),%edx
801002ae:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
801002b1:	8b 45 08             	mov    0x8(%ebp),%eax
801002b4:	a3 74 15 11 80       	mov    %eax,0x80111574

  b->flags &= ~B_BUSY;
801002b9:	8b 45 08             	mov    0x8(%ebp),%eax
801002bc:	8b 00                	mov    (%eax),%eax
801002be:	83 e0 fe             	and    $0xfffffffe,%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	8b 45 08             	mov    0x8(%ebp),%eax
801002c6:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002c8:	83 ec 0c             	sub    $0xc,%esp
801002cb:	ff 75 08             	pushl  0x8(%ebp)
801002ce:	e8 26 4e 00 00       	call   801050f9 <wakeup>
801002d3:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002d6:	83 ec 0c             	sub    $0xc,%esp
801002d9:	68 60 d6 10 80       	push   $0x8010d660
801002de:	e8 2d 53 00 00       	call   80105610 <release>
801002e3:	83 c4 10             	add    $0x10,%esp
}
801002e6:	90                   	nop
801002e7:	c9                   	leave  
801002e8:	c3                   	ret    

801002e9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002e9:	55                   	push   %ebp
801002ea:	89 e5                	mov    %esp,%ebp
801002ec:	83 ec 14             	sub    $0x14,%esp
801002ef:	8b 45 08             	mov    0x8(%ebp),%eax
801002f2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002fa:	89 c2                	mov    %eax,%edx
801002fc:	ec                   	in     (%dx),%al
801002fd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100300:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100304:	c9                   	leave  
80100305:	c3                   	ret    

80100306 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100306:	55                   	push   %ebp
80100307:	89 e5                	mov    %esp,%ebp
80100309:	83 ec 08             	sub    $0x8,%esp
8010030c:	8b 45 08             	mov    0x8(%ebp),%eax
8010030f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100312:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100316:	89 d0                	mov    %edx,%eax
80100318:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010031b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010031f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100323:	ee                   	out    %al,(%dx)
}
80100324:	90                   	nop
80100325:	c9                   	leave  
80100326:	c3                   	ret    

80100327 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100327:	55                   	push   %ebp
80100328:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010032a:	fa                   	cli    
}
8010032b:	90                   	nop
8010032c:	5d                   	pop    %ebp
8010032d:	c3                   	ret    

8010032e <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010032e:	f3 0f 1e fb          	endbr32 
80100332:	55                   	push   %ebp
80100333:	89 e5                	mov    %esp,%ebp
80100335:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100338:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010033c:	74 1c                	je     8010035a <printint+0x2c>
8010033e:	8b 45 08             	mov    0x8(%ebp),%eax
80100341:	c1 e8 1f             	shr    $0x1f,%eax
80100344:	0f b6 c0             	movzbl %al,%eax
80100347:	89 45 10             	mov    %eax,0x10(%ebp)
8010034a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010034e:	74 0a                	je     8010035a <printint+0x2c>
    x = -xx;
80100350:	8b 45 08             	mov    0x8(%ebp),%eax
80100353:	f7 d8                	neg    %eax
80100355:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100358:	eb 06                	jmp    80100360 <printint+0x32>
  else
    x = xx;
8010035a:	8b 45 08             	mov    0x8(%ebp),%eax
8010035d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100360:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010036a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036d:	ba 00 00 00 00       	mov    $0x0,%edx
80100372:	f7 f1                	div    %ecx
80100374:	89 d1                	mov    %edx,%ecx
80100376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100379:	8d 50 01             	lea    0x1(%eax),%edx
8010037c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010037f:	0f b6 91 04 a0 10 80 	movzbl -0x7fef5ffc(%ecx),%edx
80100386:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
8010038a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010038d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100390:	ba 00 00 00 00       	mov    $0x0,%edx
80100395:	f7 f1                	div    %ecx
80100397:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010039a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010039e:	75 c7                	jne    80100367 <printint+0x39>

  if(sign)
801003a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003a4:	74 2a                	je     801003d0 <printint+0xa2>
    buf[i++] = '-';
801003a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a9:	8d 50 01             	lea    0x1(%eax),%edx
801003ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003af:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003b4:	eb 1a                	jmp    801003d0 <printint+0xa2>
    consputc(buf[i]);
801003b6:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bc:	01 d0                	add    %edx,%eax
801003be:	0f b6 00             	movzbl (%eax),%eax
801003c1:	0f be c0             	movsbl %al,%eax
801003c4:	83 ec 0c             	sub    $0xc,%esp
801003c7:	50                   	push   %eax
801003c8:	e8 06 04 00 00       	call   801007d3 <consputc>
801003cd:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003d8:	79 dc                	jns    801003b6 <printint+0x88>
}
801003da:	90                   	nop
801003db:	90                   	nop
801003dc:	c9                   	leave  
801003dd:	c3                   	ret    

801003de <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003de:	f3 0f 1e fb          	endbr32 
801003e2:	55                   	push   %ebp
801003e3:	89 e5                	mov    %esp,%ebp
801003e5:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003e8:	a1 f4 c5 10 80       	mov    0x8010c5f4,%eax
801003ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003f4:	74 10                	je     80100406 <cprintf+0x28>
    acquire(&cons.lock);
801003f6:	83 ec 0c             	sub    $0xc,%esp
801003f9:	68 c0 c5 10 80       	push   $0x8010c5c0
801003fe:	e8 a2 51 00 00       	call   801055a5 <acquire>
80100403:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100406:	8b 45 08             	mov    0x8(%ebp),%eax
80100409:	85 c0                	test   %eax,%eax
8010040b:	75 0d                	jne    8010041a <cprintf+0x3c>
    panic("null fmt");
8010040d:	83 ec 0c             	sub    $0xc,%esp
80100410:	68 b2 8c 10 80       	push   $0x80108cb2
80100415:	e8 7d 01 00 00       	call   80100597 <panic>

  argp = (uint*)(void*)(&fmt + 1);
8010041a:	8d 45 0c             	lea    0xc(%ebp),%eax
8010041d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100427:	e9 2f 01 00 00       	jmp    8010055b <cprintf+0x17d>
    if(c != '%'){
8010042c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100430:	74 13                	je     80100445 <cprintf+0x67>
      consputc(c);
80100432:	83 ec 0c             	sub    $0xc,%esp
80100435:	ff 75 e4             	pushl  -0x1c(%ebp)
80100438:	e8 96 03 00 00       	call   801007d3 <consputc>
8010043d:	83 c4 10             	add    $0x10,%esp
      continue;
80100440:	e9 12 01 00 00       	jmp    80100557 <cprintf+0x179>
    }
    c = fmt[++i] & 0xff;
80100445:	8b 55 08             	mov    0x8(%ebp),%edx
80100448:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010044c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010044f:	01 d0                	add    %edx,%eax
80100451:	0f b6 00             	movzbl (%eax),%eax
80100454:	0f be c0             	movsbl %al,%eax
80100457:	25 ff 00 00 00       	and    $0xff,%eax
8010045c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010045f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100463:	0f 84 14 01 00 00    	je     8010057d <cprintf+0x19f>
      break;
    switch(c){
80100469:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010046d:	74 5e                	je     801004cd <cprintf+0xef>
8010046f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100473:	0f 8f c2 00 00 00    	jg     8010053b <cprintf+0x15d>
80100479:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010047d:	74 6b                	je     801004ea <cprintf+0x10c>
8010047f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100483:	0f 8f b2 00 00 00    	jg     8010053b <cprintf+0x15d>
80100489:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010048d:	74 3e                	je     801004cd <cprintf+0xef>
8010048f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100493:	0f 8f a2 00 00 00    	jg     8010053b <cprintf+0x15d>
80100499:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010049d:	0f 84 89 00 00 00    	je     8010052c <cprintf+0x14e>
801004a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004a7:	0f 85 8e 00 00 00    	jne    8010053b <cprintf+0x15d>
    case 'd':
      printint(*argp++, 10, 1);
801004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b0:	8d 50 04             	lea    0x4(%eax),%edx
801004b3:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004b6:	8b 00                	mov    (%eax),%eax
801004b8:	83 ec 04             	sub    $0x4,%esp
801004bb:	6a 01                	push   $0x1
801004bd:	6a 0a                	push   $0xa
801004bf:	50                   	push   %eax
801004c0:	e8 69 fe ff ff       	call   8010032e <printint>
801004c5:	83 c4 10             	add    $0x10,%esp
      break;
801004c8:	e9 8a 00 00 00       	jmp    80100557 <cprintf+0x179>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d0:	8d 50 04             	lea    0x4(%eax),%edx
801004d3:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004d6:	8b 00                	mov    (%eax),%eax
801004d8:	83 ec 04             	sub    $0x4,%esp
801004db:	6a 00                	push   $0x0
801004dd:	6a 10                	push   $0x10
801004df:	50                   	push   %eax
801004e0:	e8 49 fe ff ff       	call   8010032e <printint>
801004e5:	83 c4 10             	add    $0x10,%esp
      break;
801004e8:	eb 6d                	jmp    80100557 <cprintf+0x179>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ed:	8d 50 04             	lea    0x4(%eax),%edx
801004f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f3:	8b 00                	mov    (%eax),%eax
801004f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004fc:	75 22                	jne    80100520 <cprintf+0x142>
        s = "(null)";
801004fe:	c7 45 ec bb 8c 10 80 	movl   $0x80108cbb,-0x14(%ebp)
      for(; *s; s++)
80100505:	eb 19                	jmp    80100520 <cprintf+0x142>
        consputc(*s);
80100507:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010050a:	0f b6 00             	movzbl (%eax),%eax
8010050d:	0f be c0             	movsbl %al,%eax
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	50                   	push   %eax
80100514:	e8 ba 02 00 00       	call   801007d3 <consputc>
80100519:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010051c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100520:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100523:	0f b6 00             	movzbl (%eax),%eax
80100526:	84 c0                	test   %al,%al
80100528:	75 dd                	jne    80100507 <cprintf+0x129>
      break;
8010052a:	eb 2b                	jmp    80100557 <cprintf+0x179>
    case '%':
      consputc('%');
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	6a 25                	push   $0x25
80100531:	e8 9d 02 00 00       	call   801007d3 <consputc>
80100536:	83 c4 10             	add    $0x10,%esp
      break;
80100539:	eb 1c                	jmp    80100557 <cprintf+0x179>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010053b:	83 ec 0c             	sub    $0xc,%esp
8010053e:	6a 25                	push   $0x25
80100540:	e8 8e 02 00 00       	call   801007d3 <consputc>
80100545:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100548:	83 ec 0c             	sub    $0xc,%esp
8010054b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010054e:	e8 80 02 00 00       	call   801007d3 <consputc>
80100553:	83 c4 10             	add    $0x10,%esp
      break;
80100556:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100557:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010055b:	8b 55 08             	mov    0x8(%ebp),%edx
8010055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100561:	01 d0                	add    %edx,%eax
80100563:	0f b6 00             	movzbl (%eax),%eax
80100566:	0f be c0             	movsbl %al,%eax
80100569:	25 ff 00 00 00       	and    $0xff,%eax
8010056e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100571:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100575:	0f 85 b1 fe ff ff    	jne    8010042c <cprintf+0x4e>
8010057b:	eb 01                	jmp    8010057e <cprintf+0x1a0>
      break;
8010057d:	90                   	nop
    }
  }

  if(locking)
8010057e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100582:	74 10                	je     80100594 <cprintf+0x1b6>
    release(&cons.lock);
80100584:	83 ec 0c             	sub    $0xc,%esp
80100587:	68 c0 c5 10 80       	push   $0x8010c5c0
8010058c:	e8 7f 50 00 00       	call   80105610 <release>
80100591:	83 c4 10             	add    $0x10,%esp
}
80100594:	90                   	nop
80100595:	c9                   	leave  
80100596:	c3                   	ret    

80100597 <panic>:

void
panic(char *s)
{
80100597:	f3 0f 1e fb          	endbr32 
8010059b:	55                   	push   %ebp
8010059c:	89 e5                	mov    %esp,%ebp
8010059e:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
801005a1:	e8 81 fd ff ff       	call   80100327 <cli>
  cons.locking = 0;
801005a6:	c7 05 f4 c5 10 80 00 	movl   $0x0,0x8010c5f4
801005ad:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
801005b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801005b6:	0f b6 00             	movzbl (%eax),%eax
801005b9:	0f b6 c0             	movzbl %al,%eax
801005bc:	83 ec 08             	sub    $0x8,%esp
801005bf:	50                   	push   %eax
801005c0:	68 c2 8c 10 80       	push   $0x80108cc2
801005c5:	e8 14 fe ff ff       	call   801003de <cprintf>
801005ca:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005cd:	8b 45 08             	mov    0x8(%ebp),%eax
801005d0:	83 ec 0c             	sub    $0xc,%esp
801005d3:	50                   	push   %eax
801005d4:	e8 05 fe ff ff       	call   801003de <cprintf>
801005d9:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 d1 8c 10 80       	push   $0x80108cd1
801005e4:	e8 f5 fd ff ff       	call   801003de <cprintf>
801005e9:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ec:	83 ec 08             	sub    $0x8,%esp
801005ef:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f2:	50                   	push   %eax
801005f3:	8d 45 08             	lea    0x8(%ebp),%eax
801005f6:	50                   	push   %eax
801005f7:	e8 6a 50 00 00       	call   80105666 <getcallerpcs>
801005fc:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100606:	eb 1c                	jmp    80100624 <panic+0x8d>
    cprintf(" %p", pcs[i]);
80100608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010060b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010060f:	83 ec 08             	sub    $0x8,%esp
80100612:	50                   	push   %eax
80100613:	68 d3 8c 10 80       	push   $0x80108cd3
80100618:	e8 c1 fd ff ff       	call   801003de <cprintf>
8010061d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100620:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100624:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100628:	7e de                	jle    80100608 <panic+0x71>
  panicked = 1; // freeze other CPU
8010062a:	c7 05 a0 c5 10 80 01 	movl   $0x1,0x8010c5a0
80100631:	00 00 00 
  for(;;)
80100634:	eb fe                	jmp    80100634 <panic+0x9d>

80100636 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100636:	f3 0f 1e fb          	endbr32 
8010063a:	55                   	push   %ebp
8010063b:	89 e5                	mov    %esp,%ebp
8010063d:	53                   	push   %ebx
8010063e:	83 ec 14             	sub    $0x14,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100641:	6a 0e                	push   $0xe
80100643:	68 d4 03 00 00       	push   $0x3d4
80100648:	e8 b9 fc ff ff       	call   80100306 <outb>
8010064d:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100650:	68 d5 03 00 00       	push   $0x3d5
80100655:	e8 8f fc ff ff       	call   801002e9 <inb>
8010065a:	83 c4 04             	add    $0x4,%esp
8010065d:	0f b6 c0             	movzbl %al,%eax
80100660:	c1 e0 08             	shl    $0x8,%eax
80100663:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100666:	6a 0f                	push   $0xf
80100668:	68 d4 03 00 00       	push   $0x3d4
8010066d:	e8 94 fc ff ff       	call   80100306 <outb>
80100672:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100675:	68 d5 03 00 00       	push   $0x3d5
8010067a:	e8 6a fc ff ff       	call   801002e9 <inb>
8010067f:	83 c4 04             	add    $0x4,%esp
80100682:	0f b6 c0             	movzbl %al,%eax
80100685:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100688:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010068c:	75 30                	jne    801006be <cgaputc+0x88>
    pos += 80 - pos%80;
8010068e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100691:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100696:	89 c8                	mov    %ecx,%eax
80100698:	f7 ea                	imul   %edx
8010069a:	c1 fa 05             	sar    $0x5,%edx
8010069d:	89 c8                	mov    %ecx,%eax
8010069f:	c1 f8 1f             	sar    $0x1f,%eax
801006a2:	29 c2                	sub    %eax,%edx
801006a4:	89 d0                	mov    %edx,%eax
801006a6:	c1 e0 02             	shl    $0x2,%eax
801006a9:	01 d0                	add    %edx,%eax
801006ab:	c1 e0 04             	shl    $0x4,%eax
801006ae:	29 c1                	sub    %eax,%ecx
801006b0:	89 ca                	mov    %ecx,%edx
801006b2:	b8 50 00 00 00       	mov    $0x50,%eax
801006b7:	29 d0                	sub    %edx,%eax
801006b9:	01 45 f4             	add    %eax,-0xc(%ebp)
801006bc:	eb 38                	jmp    801006f6 <cgaputc+0xc0>
  else if(c == BACKSPACE){
801006be:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006c5:	75 0c                	jne    801006d3 <cgaputc+0x9d>
    if(pos > 0) --pos;
801006c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006cb:	7e 29                	jle    801006f6 <cgaputc+0xc0>
801006cd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006d1:	eb 23                	jmp    801006f6 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006d3:	8b 45 08             	mov    0x8(%ebp),%eax
801006d6:	0f b6 c0             	movzbl %al,%eax
801006d9:	80 cc 07             	or     $0x7,%ah
801006dc:	89 c3                	mov    %eax,%ebx
801006de:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006e7:	8d 50 01             	lea    0x1(%eax),%edx
801006ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006ed:	01 c0                	add    %eax,%eax
801006ef:	01 c8                	add    %ecx,%eax
801006f1:	89 da                	mov    %ebx,%edx
801006f3:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006fa:	78 09                	js     80100705 <cgaputc+0xcf>
801006fc:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100703:	7e 0d                	jle    80100712 <cgaputc+0xdc>
    panic("pos under/overflow");
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 d7 8c 10 80       	push   $0x80108cd7
8010070d:	e8 85 fe ff ff       	call   80100597 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
80100712:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100719:	7e 4c                	jle    80100767 <cgaputc+0x131>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010071b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100720:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100726:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010072b:	83 ec 04             	sub    $0x4,%esp
8010072e:	68 60 0e 00 00       	push   $0xe60
80100733:	52                   	push   %edx
80100734:	50                   	push   %eax
80100735:	e8 ae 51 00 00       	call   801058e8 <memmove>
8010073a:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
8010073d:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100741:	b8 80 07 00 00       	mov    $0x780,%eax
80100746:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100749:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010074c:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100751:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100754:	01 c9                	add    %ecx,%ecx
80100756:	01 c8                	add    %ecx,%eax
80100758:	83 ec 04             	sub    $0x4,%esp
8010075b:	52                   	push   %edx
8010075c:	6a 00                	push   $0x0
8010075e:	50                   	push   %eax
8010075f:	e8 bd 50 00 00       	call   80105821 <memset>
80100764:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100767:	83 ec 08             	sub    $0x8,%esp
8010076a:	6a 0e                	push   $0xe
8010076c:	68 d4 03 00 00       	push   $0x3d4
80100771:	e8 90 fb ff ff       	call   80100306 <outb>
80100776:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010077c:	c1 f8 08             	sar    $0x8,%eax
8010077f:	0f b6 c0             	movzbl %al,%eax
80100782:	83 ec 08             	sub    $0x8,%esp
80100785:	50                   	push   %eax
80100786:	68 d5 03 00 00       	push   $0x3d5
8010078b:	e8 76 fb ff ff       	call   80100306 <outb>
80100790:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100793:	83 ec 08             	sub    $0x8,%esp
80100796:	6a 0f                	push   $0xf
80100798:	68 d4 03 00 00       	push   $0x3d4
8010079d:	e8 64 fb ff ff       	call   80100306 <outb>
801007a2:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007a8:	0f b6 c0             	movzbl %al,%eax
801007ab:	83 ec 08             	sub    $0x8,%esp
801007ae:	50                   	push   %eax
801007af:	68 d5 03 00 00       	push   $0x3d5
801007b4:	e8 4d fb ff ff       	call   80100306 <outb>
801007b9:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007bc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007c4:	01 d2                	add    %edx,%edx
801007c6:	01 d0                	add    %edx,%eax
801007c8:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007cd:	90                   	nop
801007ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007d1:	c9                   	leave  
801007d2:	c3                   	ret    

801007d3 <consputc>:

void
consputc(int c)
{
801007d3:	f3 0f 1e fb          	endbr32 
801007d7:	55                   	push   %ebp
801007d8:	89 e5                	mov    %esp,%ebp
801007da:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007dd:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
801007e2:	85 c0                	test   %eax,%eax
801007e4:	74 07                	je     801007ed <consputc+0x1a>
    cli();
801007e6:	e8 3c fb ff ff       	call   80100327 <cli>
    for(;;)
801007eb:	eb fe                	jmp    801007eb <consputc+0x18>
      ;
  }

  if(c == BACKSPACE){
801007ed:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007f4:	75 29                	jne    8010081f <consputc+0x4c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007f6:	83 ec 0c             	sub    $0xc,%esp
801007f9:	6a 08                	push   $0x8
801007fb:	e8 c8 6a 00 00       	call   801072c8 <uartputc>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	83 ec 0c             	sub    $0xc,%esp
80100806:	6a 20                	push   $0x20
80100808:	e8 bb 6a 00 00       	call   801072c8 <uartputc>
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	83 ec 0c             	sub    $0xc,%esp
80100813:	6a 08                	push   $0x8
80100815:	e8 ae 6a 00 00       	call   801072c8 <uartputc>
8010081a:	83 c4 10             	add    $0x10,%esp
8010081d:	eb 0e                	jmp    8010082d <consputc+0x5a>
  } else
    uartputc(c);
8010081f:	83 ec 0c             	sub    $0xc,%esp
80100822:	ff 75 08             	pushl  0x8(%ebp)
80100825:	e8 9e 6a 00 00       	call   801072c8 <uartputc>
8010082a:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010082d:	83 ec 0c             	sub    $0xc,%esp
80100830:	ff 75 08             	pushl  0x8(%ebp)
80100833:	e8 fe fd ff ff       	call   80100636 <cgaputc>
80100838:	83 c4 10             	add    $0x10,%esp
}
8010083b:	90                   	nop
8010083c:	c9                   	leave  
8010083d:	c3                   	ret    

8010083e <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
8010083e:	f3 0f 1e fb          	endbr32 
80100842:	55                   	push   %ebp
80100843:	89 e5                	mov    %esp,%ebp
80100845:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
8010084f:	83 ec 0c             	sub    $0xc,%esp
80100852:	68 c0 c5 10 80       	push   $0x8010c5c0
80100857:	e8 49 4d 00 00       	call   801055a5 <acquire>
8010085c:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010085f:	e9 52 01 00 00       	jmp    801009b6 <consoleintr+0x178>
    switch(c){
80100864:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100868:	0f 84 81 00 00 00    	je     801008ef <consoleintr+0xb1>
8010086e:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100872:	0f 8f ac 00 00 00    	jg     80100924 <consoleintr+0xe6>
80100878:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
8010087c:	74 43                	je     801008c1 <consoleintr+0x83>
8010087e:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100882:	0f 8f 9c 00 00 00    	jg     80100924 <consoleintr+0xe6>
80100888:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
8010088c:	74 61                	je     801008ef <consoleintr+0xb1>
8010088e:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100892:	0f 85 8c 00 00 00    	jne    80100924 <consoleintr+0xe6>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100898:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010089f:	e9 12 01 00 00       	jmp    801009b6 <consoleintr+0x178>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008a4:	a1 08 18 11 80       	mov    0x80111808,%eax
801008a9:	83 e8 01             	sub    $0x1,%eax
801008ac:	a3 08 18 11 80       	mov    %eax,0x80111808
        consputc(BACKSPACE);
801008b1:	83 ec 0c             	sub    $0xc,%esp
801008b4:	68 00 01 00 00       	push   $0x100
801008b9:	e8 15 ff ff ff       	call   801007d3 <consputc>
801008be:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008c1:	8b 15 08 18 11 80    	mov    0x80111808,%edx
801008c7:	a1 04 18 11 80       	mov    0x80111804,%eax
801008cc:	39 c2                	cmp    %eax,%edx
801008ce:	0f 84 e2 00 00 00    	je     801009b6 <consoleintr+0x178>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008d4:	a1 08 18 11 80       	mov    0x80111808,%eax
801008d9:	83 e8 01             	sub    $0x1,%eax
801008dc:	83 e0 7f             	and    $0x7f,%eax
801008df:	0f b6 80 80 17 11 80 	movzbl -0x7feee880(%eax),%eax
      while(input.e != input.w &&
801008e6:	3c 0a                	cmp    $0xa,%al
801008e8:	75 ba                	jne    801008a4 <consoleintr+0x66>
      }
      break;
801008ea:	e9 c7 00 00 00       	jmp    801009b6 <consoleintr+0x178>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008ef:	8b 15 08 18 11 80    	mov    0x80111808,%edx
801008f5:	a1 04 18 11 80       	mov    0x80111804,%eax
801008fa:	39 c2                	cmp    %eax,%edx
801008fc:	0f 84 b4 00 00 00    	je     801009b6 <consoleintr+0x178>
        input.e--;
80100902:	a1 08 18 11 80       	mov    0x80111808,%eax
80100907:	83 e8 01             	sub    $0x1,%eax
8010090a:	a3 08 18 11 80       	mov    %eax,0x80111808
        consputc(BACKSPACE);
8010090f:	83 ec 0c             	sub    $0xc,%esp
80100912:	68 00 01 00 00       	push   $0x100
80100917:	e8 b7 fe ff ff       	call   801007d3 <consputc>
8010091c:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010091f:	e9 92 00 00 00       	jmp    801009b6 <consoleintr+0x178>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100924:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100928:	0f 84 87 00 00 00    	je     801009b5 <consoleintr+0x177>
8010092e:	8b 15 08 18 11 80    	mov    0x80111808,%edx
80100934:	a1 00 18 11 80       	mov    0x80111800,%eax
80100939:	29 c2                	sub    %eax,%edx
8010093b:	89 d0                	mov    %edx,%eax
8010093d:	83 f8 7f             	cmp    $0x7f,%eax
80100940:	77 73                	ja     801009b5 <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
80100942:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100946:	74 05                	je     8010094d <consoleintr+0x10f>
80100948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010094b:	eb 05                	jmp    80100952 <consoleintr+0x114>
8010094d:	b8 0a 00 00 00       	mov    $0xa,%eax
80100952:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100955:	a1 08 18 11 80       	mov    0x80111808,%eax
8010095a:	8d 50 01             	lea    0x1(%eax),%edx
8010095d:	89 15 08 18 11 80    	mov    %edx,0x80111808
80100963:	83 e0 7f             	and    $0x7f,%eax
80100966:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100969:	88 90 80 17 11 80    	mov    %dl,-0x7feee880(%eax)
        consputc(c);
8010096f:	83 ec 0c             	sub    $0xc,%esp
80100972:	ff 75 f0             	pushl  -0x10(%ebp)
80100975:	e8 59 fe ff ff       	call   801007d3 <consputc>
8010097a:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010097d:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100981:	74 18                	je     8010099b <consoleintr+0x15d>
80100983:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100987:	74 12                	je     8010099b <consoleintr+0x15d>
80100989:	a1 08 18 11 80       	mov    0x80111808,%eax
8010098e:	8b 15 00 18 11 80    	mov    0x80111800,%edx
80100994:	83 ea 80             	sub    $0xffffff80,%edx
80100997:	39 d0                	cmp    %edx,%eax
80100999:	75 1a                	jne    801009b5 <consoleintr+0x177>
          input.w = input.e;
8010099b:	a1 08 18 11 80       	mov    0x80111808,%eax
801009a0:	a3 04 18 11 80       	mov    %eax,0x80111804
          wakeup(&input.r);
801009a5:	83 ec 0c             	sub    $0xc,%esp
801009a8:	68 00 18 11 80       	push   $0x80111800
801009ad:	e8 47 47 00 00       	call   801050f9 <wakeup>
801009b2:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009b5:	90                   	nop
  while((c = getc()) >= 0){
801009b6:	8b 45 08             	mov    0x8(%ebp),%eax
801009b9:	ff d0                	call   *%eax
801009bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009c2:	0f 89 9c fe ff ff    	jns    80100864 <consoleintr+0x26>
    }
  }
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 c0 c5 10 80       	push   $0x8010c5c0
801009d0:	e8 3b 4c 00 00       	call   80105610 <release>
801009d5:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009dc:	74 05                	je     801009e3 <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
801009de:	e8 0b 48 00 00       	call   801051ee <procdump>
  }
}
801009e3:	90                   	nop
801009e4:	c9                   	leave  
801009e5:	c3                   	ret    

801009e6 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009e6:	f3 0f 1e fb          	endbr32 
801009ea:	55                   	push   %ebp
801009eb:	89 e5                	mov    %esp,%ebp
801009ed:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009f0:	83 ec 0c             	sub    $0xc,%esp
801009f3:	ff 75 08             	pushl  0x8(%ebp)
801009f6:	e8 78 11 00 00       	call   80101b73 <iunlock>
801009fb:	83 c4 10             	add    $0x10,%esp
  target = n;
801009fe:	8b 45 10             	mov    0x10(%ebp),%eax
80100a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a04:	83 ec 0c             	sub    $0xc,%esp
80100a07:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a0c:	e8 94 4b 00 00       	call   801055a5 <acquire>
80100a11:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a14:	e9 ac 00 00 00       	jmp    80100ac5 <consoleread+0xdf>
    while(input.r == input.w){
      if(proc->killed){
80100a19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a1f:	8b 40 24             	mov    0x24(%eax),%eax
80100a22:	85 c0                	test   %eax,%eax
80100a24:	74 28                	je     80100a4e <consoleread+0x68>
        release(&cons.lock);
80100a26:	83 ec 0c             	sub    $0xc,%esp
80100a29:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a2e:	e8 dd 4b 00 00       	call   80105610 <release>
80100a33:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a36:	83 ec 0c             	sub    $0xc,%esp
80100a39:	ff 75 08             	pushl  0x8(%ebp)
80100a3c:	e8 d0 0f 00 00       	call   80101a11 <ilock>
80100a41:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a49:	e9 ab 00 00 00       	jmp    80100af9 <consoleread+0x113>
      }
      sleep(&input.r, &cons.lock);
80100a4e:	83 ec 08             	sub    $0x8,%esp
80100a51:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a56:	68 00 18 11 80       	push   $0x80111800
80100a5b:	e8 a2 45 00 00       	call   80105002 <sleep>
80100a60:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a63:	8b 15 00 18 11 80    	mov    0x80111800,%edx
80100a69:	a1 04 18 11 80       	mov    0x80111804,%eax
80100a6e:	39 c2                	cmp    %eax,%edx
80100a70:	74 a7                	je     80100a19 <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a72:	a1 00 18 11 80       	mov    0x80111800,%eax
80100a77:	8d 50 01             	lea    0x1(%eax),%edx
80100a7a:	89 15 00 18 11 80    	mov    %edx,0x80111800
80100a80:	83 e0 7f             	and    $0x7f,%eax
80100a83:	0f b6 80 80 17 11 80 	movzbl -0x7feee880(%eax),%eax
80100a8a:	0f be c0             	movsbl %al,%eax
80100a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a90:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a94:	75 17                	jne    80100aad <consoleread+0xc7>
      if(n < target){
80100a96:	8b 45 10             	mov    0x10(%ebp),%eax
80100a99:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a9c:	76 2f                	jbe    80100acd <consoleread+0xe7>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a9e:	a1 00 18 11 80       	mov    0x80111800,%eax
80100aa3:	83 e8 01             	sub    $0x1,%eax
80100aa6:	a3 00 18 11 80       	mov    %eax,0x80111800
      }
      break;
80100aab:	eb 20                	jmp    80100acd <consoleread+0xe7>
    }
    *dst++ = c;
80100aad:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ab0:	8d 50 01             	lea    0x1(%eax),%edx
80100ab3:	89 55 0c             	mov    %edx,0xc(%ebp)
80100ab6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100ab9:	88 10                	mov    %dl,(%eax)
    --n;
80100abb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100abf:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ac3:	74 0b                	je     80100ad0 <consoleread+0xea>
  while(n > 0){
80100ac5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ac9:	7f 98                	jg     80100a63 <consoleread+0x7d>
80100acb:	eb 04                	jmp    80100ad1 <consoleread+0xeb>
      break;
80100acd:	90                   	nop
80100ace:	eb 01                	jmp    80100ad1 <consoleread+0xeb>
      break;
80100ad0:	90                   	nop
  }
  release(&cons.lock);
80100ad1:	83 ec 0c             	sub    $0xc,%esp
80100ad4:	68 c0 c5 10 80       	push   $0x8010c5c0
80100ad9:	e8 32 4b 00 00       	call   80105610 <release>
80100ade:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ae1:	83 ec 0c             	sub    $0xc,%esp
80100ae4:	ff 75 08             	pushl  0x8(%ebp)
80100ae7:	e8 25 0f 00 00       	call   80101a11 <ilock>
80100aec:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100aef:	8b 45 10             	mov    0x10(%ebp),%eax
80100af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100af5:	29 c2                	sub    %eax,%edx
80100af7:	89 d0                	mov    %edx,%eax
}
80100af9:	c9                   	leave  
80100afa:	c3                   	ret    

80100afb <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100afb:	f3 0f 1e fb          	endbr32 
80100aff:	55                   	push   %ebp
80100b00:	89 e5                	mov    %esp,%ebp
80100b02:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b05:	83 ec 0c             	sub    $0xc,%esp
80100b08:	ff 75 08             	pushl  0x8(%ebp)
80100b0b:	e8 63 10 00 00       	call   80101b73 <iunlock>
80100b10:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b13:	83 ec 0c             	sub    $0xc,%esp
80100b16:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b1b:	e8 85 4a 00 00       	call   801055a5 <acquire>
80100b20:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b2a:	eb 21                	jmp    80100b4d <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b32:	01 d0                	add    %edx,%eax
80100b34:	0f b6 00             	movzbl (%eax),%eax
80100b37:	0f be c0             	movsbl %al,%eax
80100b3a:	0f b6 c0             	movzbl %al,%eax
80100b3d:	83 ec 0c             	sub    $0xc,%esp
80100b40:	50                   	push   %eax
80100b41:	e8 8d fc ff ff       	call   801007d3 <consputc>
80100b46:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b49:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b50:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b53:	7c d7                	jl     80100b2c <consolewrite+0x31>
  release(&cons.lock);
80100b55:	83 ec 0c             	sub    $0xc,%esp
80100b58:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b5d:	e8 ae 4a 00 00       	call   80105610 <release>
80100b62:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b65:	83 ec 0c             	sub    $0xc,%esp
80100b68:	ff 75 08             	pushl  0x8(%ebp)
80100b6b:	e8 a1 0e 00 00       	call   80101a11 <ilock>
80100b70:	83 c4 10             	add    $0x10,%esp

  return n;
80100b73:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b76:	c9                   	leave  
80100b77:	c3                   	ret    

80100b78 <consoleinit>:

void
consoleinit(void)
{
80100b78:	f3 0f 1e fb          	endbr32 
80100b7c:	55                   	push   %ebp
80100b7d:	89 e5                	mov    %esp,%ebp
80100b7f:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b82:	83 ec 08             	sub    $0x8,%esp
80100b85:	68 ea 8c 10 80       	push   $0x80108cea
80100b8a:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b8f:	e8 eb 49 00 00       	call   8010557f <initlock>
80100b94:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b97:	c7 05 cc 21 11 80 fb 	movl   $0x80100afb,0x801121cc
80100b9e:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba1:	c7 05 c8 21 11 80 e6 	movl   $0x801009e6,0x801121c8
80100ba8:	09 10 80 
  cons.locking = 1;
80100bab:	c7 05 f4 c5 10 80 01 	movl   $0x1,0x8010c5f4
80100bb2:	00 00 00 

  picenable(IRQ_KBD);
80100bb5:	83 ec 0c             	sub    $0xc,%esp
80100bb8:	6a 01                	push   $0x1
80100bba:	e8 1a 35 00 00       	call   801040d9 <picenable>
80100bbf:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bc2:	83 ec 08             	sub    $0x8,%esp
80100bc5:	6a 00                	push   $0x0
80100bc7:	6a 01                	push   $0x1
80100bc9:	e8 08 20 00 00       	call   80102bd6 <ioapicenable>
80100bce:	83 c4 10             	add    $0x10,%esp
}
80100bd1:	90                   	nop
80100bd2:	c9                   	leave  
80100bd3:	c3                   	ret    

80100bd4 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bd4:	f3 0f 1e fb          	endbr32 
80100bd8:	55                   	push   %ebp
80100bd9:	89 e5                	mov    %esp,%ebp
80100bdb:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100be1:	e8 b7 2a 00 00       	call   8010369d <begin_op>
  if((ip = namei(path)) == 0){
80100be6:	83 ec 0c             	sub    $0xc,%esp
80100be9:	ff 75 08             	pushl  0x8(%ebp)
80100bec:	e8 09 1a 00 00       	call   801025fa <namei>
80100bf1:	83 c4 10             	add    $0x10,%esp
80100bf4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bf7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bfb:	75 0f                	jne    80100c0c <exec+0x38>
    end_op();
80100bfd:	e8 2b 2b 00 00       	call   8010372d <end_op>
    return -1;
80100c02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c07:	e9 ce 03 00 00       	jmp    80100fda <exec+0x406>
  }
  ilock(ip);
80100c0c:	83 ec 0c             	sub    $0xc,%esp
80100c0f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c12:	e8 fa 0d 00 00       	call   80101a11 <ilock>
80100c17:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c1a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c21:	6a 34                	push   $0x34
80100c23:	6a 00                	push   $0x0
80100c25:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c2b:	50                   	push   %eax
80100c2c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c2f:	e8 62 13 00 00       	call   80101f96 <readi>
80100c34:	83 c4 10             	add    $0x10,%esp
80100c37:	83 f8 33             	cmp    $0x33,%eax
80100c3a:	0f 86 49 03 00 00    	jbe    80100f89 <exec+0x3b5>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c40:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c46:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c4b:	0f 85 3b 03 00 00    	jne    80100f8c <exec+0x3b8>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c51:	e8 df 77 00 00       	call   80108435 <setupkvm>
80100c56:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c59:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c5d:	0f 84 2c 03 00 00    	je     80100f8f <exec+0x3bb>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c63:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c71:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c77:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c7a:	e9 ab 00 00 00       	jmp    80100d2a <exec+0x156>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c82:	6a 20                	push   $0x20
80100c84:	50                   	push   %eax
80100c85:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c8b:	50                   	push   %eax
80100c8c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c8f:	e8 02 13 00 00       	call   80101f96 <readi>
80100c94:	83 c4 10             	add    $0x10,%esp
80100c97:	83 f8 20             	cmp    $0x20,%eax
80100c9a:	0f 85 f2 02 00 00    	jne    80100f92 <exec+0x3be>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ca0:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ca6:	83 f8 01             	cmp    $0x1,%eax
80100ca9:	75 71                	jne    80100d1c <exec+0x148>
      continue;
    if(ph.memsz < ph.filesz)
80100cab:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cb1:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cb7:	39 c2                	cmp    %eax,%edx
80100cb9:	0f 82 d6 02 00 00    	jb     80100f95 <exec+0x3c1>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cbf:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cc5:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100ccb:	01 d0                	add    %edx,%eax
80100ccd:	83 ec 04             	sub    $0x4,%esp
80100cd0:	50                   	push   %eax
80100cd1:	ff 75 e0             	pushl  -0x20(%ebp)
80100cd4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cd7:	e8 19 7b 00 00       	call   801087f5 <allocuvm>
80100cdc:	83 c4 10             	add    $0x10,%esp
80100cdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ce2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ce6:	0f 84 ac 02 00 00    	je     80100f98 <exec+0x3c4>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cec:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cf2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cf8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100cfe:	83 ec 0c             	sub    $0xc,%esp
80100d01:	52                   	push   %edx
80100d02:	50                   	push   %eax
80100d03:	ff 75 d8             	pushl  -0x28(%ebp)
80100d06:	51                   	push   %ecx
80100d07:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d0a:	e8 0b 7a 00 00       	call   8010871a <loaduvm>
80100d0f:	83 c4 20             	add    $0x20,%esp
80100d12:	85 c0                	test   %eax,%eax
80100d14:	0f 88 81 02 00 00    	js     80100f9b <exec+0x3c7>
80100d1a:	eb 01                	jmp    80100d1d <exec+0x149>
      continue;
80100d1c:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d1d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d24:	83 c0 20             	add    $0x20,%eax
80100d27:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d2a:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d31:	0f b7 c0             	movzwl %ax,%eax
80100d34:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d37:	0f 8c 42 ff ff ff    	jl     80100c7f <exec+0xab>
      goto bad;
  }
  iunlockput(ip);
80100d3d:	83 ec 0c             	sub    $0xc,%esp
80100d40:	ff 75 d8             	pushl  -0x28(%ebp)
80100d43:	e8 95 0f 00 00       	call   80101cdd <iunlockput>
80100d48:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d4b:	e8 dd 29 00 00       	call   8010372d <end_op>
  ip = 0;
80100d50:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d57:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d5a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d64:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d6a:	05 00 20 00 00       	add    $0x2000,%eax
80100d6f:	83 ec 04             	sub    $0x4,%esp
80100d72:	50                   	push   %eax
80100d73:	ff 75 e0             	pushl  -0x20(%ebp)
80100d76:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d79:	e8 77 7a 00 00       	call   801087f5 <allocuvm>
80100d7e:	83 c4 10             	add    $0x10,%esp
80100d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d88:	0f 84 10 02 00 00    	je     80100f9e <exec+0x3ca>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d91:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d96:	83 ec 08             	sub    $0x8,%esp
80100d99:	50                   	push   %eax
80100d9a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d9d:	e8 83 7c 00 00       	call   80108a25 <clearpteu>
80100da2:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da8:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100db2:	e9 96 00 00 00       	jmp    80100e4d <exec+0x279>
    if(argc >= MAXARG)
80100db7:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dbb:	0f 87 e0 01 00 00    	ja     80100fa1 <exec+0x3cd>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dce:	01 d0                	add    %edx,%eax
80100dd0:	8b 00                	mov    (%eax),%eax
80100dd2:	83 ec 0c             	sub    $0xc,%esp
80100dd5:	50                   	push   %eax
80100dd6:	e8 af 4c 00 00       	call   80105a8a <strlen>
80100ddb:	83 c4 10             	add    $0x10,%esp
80100dde:	89 c2                	mov    %eax,%edx
80100de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de3:	29 d0                	sub    %edx,%eax
80100de5:	83 e8 01             	sub    $0x1,%eax
80100de8:	83 e0 fc             	and    $0xfffffffc,%eax
80100deb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dfb:	01 d0                	add    %edx,%eax
80100dfd:	8b 00                	mov    (%eax),%eax
80100dff:	83 ec 0c             	sub    $0xc,%esp
80100e02:	50                   	push   %eax
80100e03:	e8 82 4c 00 00       	call   80105a8a <strlen>
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	89 c1                	mov    %eax,%ecx
80100e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e1d:	01 d0                	add    %edx,%eax
80100e1f:	8b 00                	mov    (%eax),%eax
80100e21:	51                   	push   %ecx
80100e22:	50                   	push   %eax
80100e23:	ff 75 dc             	pushl  -0x24(%ebp)
80100e26:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e29:	e8 b9 7d 00 00       	call   80108be7 <copyout>
80100e2e:	83 c4 10             	add    $0x10,%esp
80100e31:	85 c0                	test   %eax,%eax
80100e33:	0f 88 6b 01 00 00    	js     80100fa4 <exec+0x3d0>
      goto bad;
    ustack[3+argc] = sp;
80100e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3c:	8d 50 03             	lea    0x3(%eax),%edx
80100e3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e42:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e49:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e57:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e5a:	01 d0                	add    %edx,%eax
80100e5c:	8b 00                	mov    (%eax),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	0f 85 51 ff ff ff    	jne    80100db7 <exec+0x1e3>
  }
  ustack[3+argc] = 0;
80100e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e69:	83 c0 03             	add    $0x3,%eax
80100e6c:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e73:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e77:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e7e:	ff ff ff 
  ustack[1] = argc;
80100e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e84:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8d:	83 c0 01             	add    $0x1,%eax
80100e90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e9a:	29 d0                	sub    %edx,%eax
80100e9c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea5:	83 c0 04             	add    $0x4,%eax
80100ea8:	c1 e0 02             	shl    $0x2,%eax
80100eab:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb1:	83 c0 04             	add    $0x4,%eax
80100eb4:	c1 e0 02             	shl    $0x2,%eax
80100eb7:	50                   	push   %eax
80100eb8:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ebe:	50                   	push   %eax
80100ebf:	ff 75 dc             	pushl  -0x24(%ebp)
80100ec2:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ec5:	e8 1d 7d 00 00       	call   80108be7 <copyout>
80100eca:	83 c4 10             	add    $0x10,%esp
80100ecd:	85 c0                	test   %eax,%eax
80100ecf:	0f 88 d2 00 00 00    	js     80100fa7 <exec+0x3d3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80100ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ee1:	eb 17                	jmp    80100efa <exec+0x326>
    if(*s == '/')
80100ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee6:	0f b6 00             	movzbl (%eax),%eax
80100ee9:	3c 2f                	cmp    $0x2f,%al
80100eeb:	75 09                	jne    80100ef6 <exec+0x322>
      last = s+1;
80100eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef0:	83 c0 01             	add    $0x1,%eax
80100ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ef6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efd:	0f b6 00             	movzbl (%eax),%eax
80100f00:	84 c0                	test   %al,%al
80100f02:	75 df                	jne    80100ee3 <exec+0x30f>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0a:	83 c0 6c             	add    $0x6c,%eax
80100f0d:	83 ec 04             	sub    $0x4,%esp
80100f10:	6a 10                	push   $0x10
80100f12:	ff 75 f0             	pushl  -0x10(%ebp)
80100f15:	50                   	push   %eax
80100f16:	e8 21 4b 00 00       	call   80105a3c <safestrcpy>
80100f1b:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f24:	8b 40 04             	mov    0x4(%eax),%eax
80100f27:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f33:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f3f:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f47:	8b 40 18             	mov    0x18(%eax),%eax
80100f4a:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f50:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f59:	8b 40 18             	mov    0x18(%eax),%eax
80100f5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f5f:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	50                   	push   %eax
80100f6c:	e8 b7 75 00 00       	call   80108528 <switchuvm>
80100f71:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 75 d0             	pushl  -0x30(%ebp)
80100f7a:	e8 02 7a 00 00       	call   80108981 <freevm>
80100f7f:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f82:	b8 00 00 00 00       	mov    $0x0,%eax
80100f87:	eb 51                	jmp    80100fda <exec+0x406>
    goto bad;
80100f89:	90                   	nop
80100f8a:	eb 1c                	jmp    80100fa8 <exec+0x3d4>
    goto bad;
80100f8c:	90                   	nop
80100f8d:	eb 19                	jmp    80100fa8 <exec+0x3d4>
    goto bad;
80100f8f:	90                   	nop
80100f90:	eb 16                	jmp    80100fa8 <exec+0x3d4>
      goto bad;
80100f92:	90                   	nop
80100f93:	eb 13                	jmp    80100fa8 <exec+0x3d4>
      goto bad;
80100f95:	90                   	nop
80100f96:	eb 10                	jmp    80100fa8 <exec+0x3d4>
      goto bad;
80100f98:	90                   	nop
80100f99:	eb 0d                	jmp    80100fa8 <exec+0x3d4>
      goto bad;
80100f9b:	90                   	nop
80100f9c:	eb 0a                	jmp    80100fa8 <exec+0x3d4>
    goto bad;
80100f9e:	90                   	nop
80100f9f:	eb 07                	jmp    80100fa8 <exec+0x3d4>
      goto bad;
80100fa1:	90                   	nop
80100fa2:	eb 04                	jmp    80100fa8 <exec+0x3d4>
      goto bad;
80100fa4:	90                   	nop
80100fa5:	eb 01                	jmp    80100fa8 <exec+0x3d4>
    goto bad;
80100fa7:	90                   	nop

 bad:
  if(pgdir)
80100fa8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fac:	74 0e                	je     80100fbc <exec+0x3e8>
    freevm(pgdir);
80100fae:	83 ec 0c             	sub    $0xc,%esp
80100fb1:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fb4:	e8 c8 79 00 00       	call   80108981 <freevm>
80100fb9:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fbc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fc0:	74 13                	je     80100fd5 <exec+0x401>
    iunlockput(ip);
80100fc2:	83 ec 0c             	sub    $0xc,%esp
80100fc5:	ff 75 d8             	pushl  -0x28(%ebp)
80100fc8:	e8 10 0d 00 00       	call   80101cdd <iunlockput>
80100fcd:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fd0:	e8 58 27 00 00       	call   8010372d <end_op>
  }
  return -1;
80100fd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fda:	c9                   	leave  
80100fdb:	c3                   	ret    

80100fdc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fdc:	f3 0f 1e fb          	endbr32 
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fe6:	83 ec 08             	sub    $0x8,%esp
80100fe9:	68 f2 8c 10 80       	push   $0x80108cf2
80100fee:	68 20 18 11 80       	push   $0x80111820
80100ff3:	e8 87 45 00 00       	call   8010557f <initlock>
80100ff8:	83 c4 10             	add    $0x10,%esp
}
80100ffb:	90                   	nop
80100ffc:	c9                   	leave  
80100ffd:	c3                   	ret    

80100ffe <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ffe:	f3 0f 1e fb          	endbr32 
80101002:	55                   	push   %ebp
80101003:	89 e5                	mov    %esp,%ebp
80101005:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101008:	83 ec 0c             	sub    $0xc,%esp
8010100b:	68 20 18 11 80       	push   $0x80111820
80101010:	e8 90 45 00 00       	call   801055a5 <acquire>
80101015:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101018:	c7 45 f4 54 18 11 80 	movl   $0x80111854,-0xc(%ebp)
8010101f:	eb 2d                	jmp    8010104e <filealloc+0x50>
    if(f->ref == 0){
80101021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101024:	8b 40 04             	mov    0x4(%eax),%eax
80101027:	85 c0                	test   %eax,%eax
80101029:	75 1f                	jne    8010104a <filealloc+0x4c>
      f->ref = 1;
8010102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010102e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101035:	83 ec 0c             	sub    $0xc,%esp
80101038:	68 20 18 11 80       	push   $0x80111820
8010103d:	e8 ce 45 00 00       	call   80105610 <release>
80101042:	83 c4 10             	add    $0x10,%esp
      return f;
80101045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101048:	eb 23                	jmp    8010106d <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010104a:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010104e:	b8 b4 21 11 80       	mov    $0x801121b4,%eax
80101053:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101056:	72 c9                	jb     80101021 <filealloc+0x23>
    }
  }
  release(&ftable.lock);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	68 20 18 11 80       	push   $0x80111820
80101060:	e8 ab 45 00 00       	call   80105610 <release>
80101065:	83 c4 10             	add    $0x10,%esp
  return 0;
80101068:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010106d:	c9                   	leave  
8010106e:	c3                   	ret    

8010106f <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010106f:	f3 0f 1e fb          	endbr32 
80101073:	55                   	push   %ebp
80101074:	89 e5                	mov    %esp,%ebp
80101076:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101079:	83 ec 0c             	sub    $0xc,%esp
8010107c:	68 20 18 11 80       	push   $0x80111820
80101081:	e8 1f 45 00 00       	call   801055a5 <acquire>
80101086:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101089:	8b 45 08             	mov    0x8(%ebp),%eax
8010108c:	8b 40 04             	mov    0x4(%eax),%eax
8010108f:	85 c0                	test   %eax,%eax
80101091:	7f 0d                	jg     801010a0 <filedup+0x31>
    panic("filedup");
80101093:	83 ec 0c             	sub    $0xc,%esp
80101096:	68 f9 8c 10 80       	push   $0x80108cf9
8010109b:	e8 f7 f4 ff ff       	call   80100597 <panic>
  f->ref++;
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	8b 40 04             	mov    0x4(%eax),%eax
801010a6:	8d 50 01             	lea    0x1(%eax),%edx
801010a9:	8b 45 08             	mov    0x8(%ebp),%eax
801010ac:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 20 18 11 80       	push   $0x80111820
801010b7:	e8 54 45 00 00       	call   80105610 <release>
801010bc:	83 c4 10             	add    $0x10,%esp
  return f;
801010bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010c2:	c9                   	leave  
801010c3:	c3                   	ret    

801010c4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010c4:	f3 0f 1e fb          	endbr32 
801010c8:	55                   	push   %ebp
801010c9:	89 e5                	mov    %esp,%ebp
801010cb:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010ce:	83 ec 0c             	sub    $0xc,%esp
801010d1:	68 20 18 11 80       	push   $0x80111820
801010d6:	e8 ca 44 00 00       	call   801055a5 <acquire>
801010db:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010de:	8b 45 08             	mov    0x8(%ebp),%eax
801010e1:	8b 40 04             	mov    0x4(%eax),%eax
801010e4:	85 c0                	test   %eax,%eax
801010e6:	7f 0d                	jg     801010f5 <fileclose+0x31>
    panic("fileclose");
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	68 01 8d 10 80       	push   $0x80108d01
801010f0:	e8 a2 f4 ff ff       	call   80100597 <panic>
  if(--f->ref > 0){
801010f5:	8b 45 08             	mov    0x8(%ebp),%eax
801010f8:	8b 40 04             	mov    0x4(%eax),%eax
801010fb:	8d 50 ff             	lea    -0x1(%eax),%edx
801010fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101101:	89 50 04             	mov    %edx,0x4(%eax)
80101104:	8b 45 08             	mov    0x8(%ebp),%eax
80101107:	8b 40 04             	mov    0x4(%eax),%eax
8010110a:	85 c0                	test   %eax,%eax
8010110c:	7e 15                	jle    80101123 <fileclose+0x5f>
    release(&ftable.lock);
8010110e:	83 ec 0c             	sub    $0xc,%esp
80101111:	68 20 18 11 80       	push   $0x80111820
80101116:	e8 f5 44 00 00       	call   80105610 <release>
8010111b:	83 c4 10             	add    $0x10,%esp
8010111e:	e9 8b 00 00 00       	jmp    801011ae <fileclose+0xea>
    return;
  }
  ff = *f;
80101123:	8b 45 08             	mov    0x8(%ebp),%eax
80101126:	8b 10                	mov    (%eax),%edx
80101128:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010112b:	8b 50 04             	mov    0x4(%eax),%edx
8010112e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101131:	8b 50 08             	mov    0x8(%eax),%edx
80101134:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101137:	8b 50 0c             	mov    0xc(%eax),%edx
8010113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010113d:	8b 50 10             	mov    0x10(%eax),%edx
80101140:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101143:	8b 40 14             	mov    0x14(%eax),%eax
80101146:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101153:	8b 45 08             	mov    0x8(%ebp),%eax
80101156:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010115c:	83 ec 0c             	sub    $0xc,%esp
8010115f:	68 20 18 11 80       	push   $0x80111820
80101164:	e8 a7 44 00 00       	call   80105610 <release>
80101169:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010116c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010116f:	83 f8 01             	cmp    $0x1,%eax
80101172:	75 19                	jne    8010118d <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
80101174:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101178:	0f be d0             	movsbl %al,%edx
8010117b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010117e:	83 ec 08             	sub    $0x8,%esp
80101181:	52                   	push   %edx
80101182:	50                   	push   %eax
80101183:	e8 c5 31 00 00       	call   8010434d <pipeclose>
80101188:	83 c4 10             	add    $0x10,%esp
8010118b:	eb 21                	jmp    801011ae <fileclose+0xea>
  else if(ff.type == FD_INODE){
8010118d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101190:	83 f8 02             	cmp    $0x2,%eax
80101193:	75 19                	jne    801011ae <fileclose+0xea>
    begin_op();
80101195:	e8 03 25 00 00       	call   8010369d <begin_op>
    iput(ff.ip);
8010119a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010119d:	83 ec 0c             	sub    $0xc,%esp
801011a0:	50                   	push   %eax
801011a1:	e8 43 0a 00 00       	call   80101be9 <iput>
801011a6:	83 c4 10             	add    $0x10,%esp
    end_op();
801011a9:	e8 7f 25 00 00       	call   8010372d <end_op>
  }
}
801011ae:	c9                   	leave  
801011af:	c3                   	ret    

801011b0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011b0:	f3 0f 1e fb          	endbr32 
801011b4:	55                   	push   %ebp
801011b5:	89 e5                	mov    %esp,%ebp
801011b7:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 00                	mov    (%eax),%eax
801011bf:	83 f8 02             	cmp    $0x2,%eax
801011c2:	75 40                	jne    80101204 <filestat+0x54>
    ilock(f->ip);
801011c4:	8b 45 08             	mov    0x8(%ebp),%eax
801011c7:	8b 40 10             	mov    0x10(%eax),%eax
801011ca:	83 ec 0c             	sub    $0xc,%esp
801011cd:	50                   	push   %eax
801011ce:	e8 3e 08 00 00       	call   80101a11 <ilock>
801011d3:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011d6:	8b 45 08             	mov    0x8(%ebp),%eax
801011d9:	8b 40 10             	mov    0x10(%eax),%eax
801011dc:	83 ec 08             	sub    $0x8,%esp
801011df:	ff 75 0c             	pushl  0xc(%ebp)
801011e2:	50                   	push   %eax
801011e3:	e8 64 0d 00 00       	call   80101f4c <stati>
801011e8:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011eb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ee:	8b 40 10             	mov    0x10(%eax),%eax
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	50                   	push   %eax
801011f5:	e8 79 09 00 00       	call   80101b73 <iunlock>
801011fa:	83 c4 10             	add    $0x10,%esp
    return 0;
801011fd:	b8 00 00 00 00       	mov    $0x0,%eax
80101202:	eb 05                	jmp    80101209 <filestat+0x59>
  }
  return -1;
80101204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101209:	c9                   	leave  
8010120a:	c3                   	ret    

8010120b <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010120b:	f3 0f 1e fb          	endbr32 
8010120f:	55                   	push   %ebp
80101210:	89 e5                	mov    %esp,%ebp
80101212:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010121c:	84 c0                	test   %al,%al
8010121e:	75 0a                	jne    8010122a <fileread+0x1f>
    return -1;
80101220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101225:	e9 9b 00 00 00       	jmp    801012c5 <fileread+0xba>
  if(f->type == FD_PIPE)
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	8b 00                	mov    (%eax),%eax
8010122f:	83 f8 01             	cmp    $0x1,%eax
80101232:	75 1a                	jne    8010124e <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	8b 40 0c             	mov    0xc(%eax),%eax
8010123a:	83 ec 04             	sub    $0x4,%esp
8010123d:	ff 75 10             	pushl  0x10(%ebp)
80101240:	ff 75 0c             	pushl  0xc(%ebp)
80101243:	50                   	push   %eax
80101244:	e8 ba 32 00 00       	call   80104503 <piperead>
80101249:	83 c4 10             	add    $0x10,%esp
8010124c:	eb 77                	jmp    801012c5 <fileread+0xba>
  if(f->type == FD_INODE){
8010124e:	8b 45 08             	mov    0x8(%ebp),%eax
80101251:	8b 00                	mov    (%eax),%eax
80101253:	83 f8 02             	cmp    $0x2,%eax
80101256:	75 60                	jne    801012b8 <fileread+0xad>
    ilock(f->ip);
80101258:	8b 45 08             	mov    0x8(%ebp),%eax
8010125b:	8b 40 10             	mov    0x10(%eax),%eax
8010125e:	83 ec 0c             	sub    $0xc,%esp
80101261:	50                   	push   %eax
80101262:	e8 aa 07 00 00       	call   80101a11 <ilock>
80101267:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010126a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 50 14             	mov    0x14(%eax),%edx
80101273:	8b 45 08             	mov    0x8(%ebp),%eax
80101276:	8b 40 10             	mov    0x10(%eax),%eax
80101279:	51                   	push   %ecx
8010127a:	52                   	push   %edx
8010127b:	ff 75 0c             	pushl  0xc(%ebp)
8010127e:	50                   	push   %eax
8010127f:	e8 12 0d 00 00       	call   80101f96 <readi>
80101284:	83 c4 10             	add    $0x10,%esp
80101287:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010128a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010128e:	7e 11                	jle    801012a1 <fileread+0x96>
      f->off += r;
80101290:	8b 45 08             	mov    0x8(%ebp),%eax
80101293:	8b 50 14             	mov    0x14(%eax),%edx
80101296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101299:	01 c2                	add    %eax,%edx
8010129b:	8b 45 08             	mov    0x8(%ebp),%eax
8010129e:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012a1:	8b 45 08             	mov    0x8(%ebp),%eax
801012a4:	8b 40 10             	mov    0x10(%eax),%eax
801012a7:	83 ec 0c             	sub    $0xc,%esp
801012aa:	50                   	push   %eax
801012ab:	e8 c3 08 00 00       	call   80101b73 <iunlock>
801012b0:	83 c4 10             	add    $0x10,%esp
    return r;
801012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b6:	eb 0d                	jmp    801012c5 <fileread+0xba>
  }
  panic("fileread");
801012b8:	83 ec 0c             	sub    $0xc,%esp
801012bb:	68 0b 8d 10 80       	push   $0x80108d0b
801012c0:	e8 d2 f2 ff ff       	call   80100597 <panic>
}
801012c5:	c9                   	leave  
801012c6:	c3                   	ret    

801012c7 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012c7:	f3 0f 1e fb          	endbr32 
801012cb:	55                   	push   %ebp
801012cc:	89 e5                	mov    %esp,%ebp
801012ce:	53                   	push   %ebx
801012cf:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012d2:	8b 45 08             	mov    0x8(%ebp),%eax
801012d5:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012d9:	84 c0                	test   %al,%al
801012db:	75 0a                	jne    801012e7 <filewrite+0x20>
    return -1;
801012dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012e2:	e9 1b 01 00 00       	jmp    80101402 <filewrite+0x13b>
  if(f->type == FD_PIPE)
801012e7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ea:	8b 00                	mov    (%eax),%eax
801012ec:	83 f8 01             	cmp    $0x1,%eax
801012ef:	75 1d                	jne    8010130e <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801012f1:	8b 45 08             	mov    0x8(%ebp),%eax
801012f4:	8b 40 0c             	mov    0xc(%eax),%eax
801012f7:	83 ec 04             	sub    $0x4,%esp
801012fa:	ff 75 10             	pushl  0x10(%ebp)
801012fd:	ff 75 0c             	pushl  0xc(%ebp)
80101300:	50                   	push   %eax
80101301:	e8 f6 30 00 00       	call   801043fc <pipewrite>
80101306:	83 c4 10             	add    $0x10,%esp
80101309:	e9 f4 00 00 00       	jmp    80101402 <filewrite+0x13b>
  if(f->type == FD_INODE){
8010130e:	8b 45 08             	mov    0x8(%ebp),%eax
80101311:	8b 00                	mov    (%eax),%eax
80101313:	83 f8 02             	cmp    $0x2,%eax
80101316:	0f 85 d9 00 00 00    	jne    801013f5 <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010131c:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101323:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010132a:	e9 a3 00 00 00       	jmp    801013d2 <filewrite+0x10b>
      int n1 = n - i;
8010132f:	8b 45 10             	mov    0x10(%ebp),%eax
80101332:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101335:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010133b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010133e:	7e 06                	jle    80101346 <filewrite+0x7f>
        n1 = max;
80101340:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101343:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101346:	e8 52 23 00 00       	call   8010369d <begin_op>
      ilock(f->ip);
8010134b:	8b 45 08             	mov    0x8(%ebp),%eax
8010134e:	8b 40 10             	mov    0x10(%eax),%eax
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	50                   	push   %eax
80101355:	e8 b7 06 00 00       	call   80101a11 <ilock>
8010135a:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010135d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101360:	8b 45 08             	mov    0x8(%ebp),%eax
80101363:	8b 50 14             	mov    0x14(%eax),%edx
80101366:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010136c:	01 c3                	add    %eax,%ebx
8010136e:	8b 45 08             	mov    0x8(%ebp),%eax
80101371:	8b 40 10             	mov    0x10(%eax),%eax
80101374:	51                   	push   %ecx
80101375:	52                   	push   %edx
80101376:	53                   	push   %ebx
80101377:	50                   	push   %eax
80101378:	e8 72 0d 00 00       	call   801020ef <writei>
8010137d:	83 c4 10             	add    $0x10,%esp
80101380:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101383:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101387:	7e 11                	jle    8010139a <filewrite+0xd3>
        f->off += r;
80101389:	8b 45 08             	mov    0x8(%ebp),%eax
8010138c:	8b 50 14             	mov    0x14(%eax),%edx
8010138f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101392:	01 c2                	add    %eax,%edx
80101394:	8b 45 08             	mov    0x8(%ebp),%eax
80101397:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010139a:	8b 45 08             	mov    0x8(%ebp),%eax
8010139d:	8b 40 10             	mov    0x10(%eax),%eax
801013a0:	83 ec 0c             	sub    $0xc,%esp
801013a3:	50                   	push   %eax
801013a4:	e8 ca 07 00 00       	call   80101b73 <iunlock>
801013a9:	83 c4 10             	add    $0x10,%esp
      end_op();
801013ac:	e8 7c 23 00 00       	call   8010372d <end_op>

      if(r < 0)
801013b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013b5:	78 29                	js     801013e0 <filewrite+0x119>
        break;
      if(r != n1)
801013b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013bd:	74 0d                	je     801013cc <filewrite+0x105>
        panic("short filewrite");
801013bf:	83 ec 0c             	sub    $0xc,%esp
801013c2:	68 14 8d 10 80       	push   $0x80108d14
801013c7:	e8 cb f1 ff ff       	call   80100597 <panic>
      i += r;
801013cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013cf:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d5:	3b 45 10             	cmp    0x10(%ebp),%eax
801013d8:	0f 8c 51 ff ff ff    	jl     8010132f <filewrite+0x68>
801013de:	eb 01                	jmp    801013e1 <filewrite+0x11a>
        break;
801013e0:	90                   	nop
    }
    return i == n ? n : -1;
801013e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801013e7:	75 05                	jne    801013ee <filewrite+0x127>
801013e9:	8b 45 10             	mov    0x10(%ebp),%eax
801013ec:	eb 14                	jmp    80101402 <filewrite+0x13b>
801013ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013f3:	eb 0d                	jmp    80101402 <filewrite+0x13b>
  }
  panic("filewrite");
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	68 24 8d 10 80       	push   $0x80108d24
801013fd:	e8 95 f1 ff ff       	call   80100597 <panic>
}
80101402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101405:	c9                   	leave  
80101406:	c3                   	ret    

80101407 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101407:	f3 0f 1e fb          	endbr32 
8010140b:	55                   	push   %ebp
8010140c:	89 e5                	mov    %esp,%ebp
8010140e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101411:	8b 45 08             	mov    0x8(%ebp),%eax
80101414:	83 ec 08             	sub    $0x8,%esp
80101417:	6a 01                	push   $0x1
80101419:	50                   	push   %eax
8010141a:	e8 a0 ed ff ff       	call   801001bf <bread>
8010141f:	83 c4 10             	add    $0x10,%esp
80101422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101428:	83 c0 18             	add    $0x18,%eax
8010142b:	83 ec 04             	sub    $0x4,%esp
8010142e:	6a 1c                	push   $0x1c
80101430:	50                   	push   %eax
80101431:	ff 75 0c             	pushl  0xc(%ebp)
80101434:	e8 af 44 00 00       	call   801058e8 <memmove>
80101439:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010143c:	83 ec 0c             	sub    $0xc,%esp
8010143f:	ff 75 f4             	pushl  -0xc(%ebp)
80101442:	e8 f8 ed ff ff       	call   8010023f <brelse>
80101447:	83 c4 10             	add    $0x10,%esp
}
8010144a:	90                   	nop
8010144b:	c9                   	leave  
8010144c:	c3                   	ret    

8010144d <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010144d:	f3 0f 1e fb          	endbr32 
80101451:	55                   	push   %ebp
80101452:	89 e5                	mov    %esp,%ebp
80101454:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101457:	8b 55 0c             	mov    0xc(%ebp),%edx
8010145a:	8b 45 08             	mov    0x8(%ebp),%eax
8010145d:	83 ec 08             	sub    $0x8,%esp
80101460:	52                   	push   %edx
80101461:	50                   	push   %eax
80101462:	e8 58 ed ff ff       	call   801001bf <bread>
80101467:	83 c4 10             	add    $0x10,%esp
8010146a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101470:	83 c0 18             	add    $0x18,%eax
80101473:	83 ec 04             	sub    $0x4,%esp
80101476:	68 00 02 00 00       	push   $0x200
8010147b:	6a 00                	push   $0x0
8010147d:	50                   	push   %eax
8010147e:	e8 9e 43 00 00       	call   80105821 <memset>
80101483:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101486:	83 ec 0c             	sub    $0xc,%esp
80101489:	ff 75 f4             	pushl  -0xc(%ebp)
8010148c:	e8 55 24 00 00       	call   801038e6 <log_write>
80101491:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	ff 75 f4             	pushl  -0xc(%ebp)
8010149a:	e8 a0 ed ff ff       	call   8010023f <brelse>
8010149f:	83 c4 10             	add    $0x10,%esp
}
801014a2:	90                   	nop
801014a3:	c9                   	leave  
801014a4:	c3                   	ret    

801014a5 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014a5:	f3 0f 1e fb          	endbr32 
801014a9:	55                   	push   %ebp
801014aa:	89 e5                	mov    %esp,%ebp
801014ac:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014bd:	e9 13 01 00 00       	jmp    801015d5 <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
801014c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014c5:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014cb:	85 c0                	test   %eax,%eax
801014cd:	0f 48 c2             	cmovs  %edx,%eax
801014d0:	c1 f8 0c             	sar    $0xc,%eax
801014d3:	89 c2                	mov    %eax,%edx
801014d5:	a1 38 22 11 80       	mov    0x80112238,%eax
801014da:	01 d0                	add    %edx,%eax
801014dc:	83 ec 08             	sub    $0x8,%esp
801014df:	50                   	push   %eax
801014e0:	ff 75 08             	pushl  0x8(%ebp)
801014e3:	e8 d7 ec ff ff       	call   801001bf <bread>
801014e8:	83 c4 10             	add    $0x10,%esp
801014eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014f5:	e9 a6 00 00 00       	jmp    801015a0 <balloc+0xfb>
      m = 1 << (bi % 8);
801014fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fd:	99                   	cltd   
801014fe:	c1 ea 1d             	shr    $0x1d,%edx
80101501:	01 d0                	add    %edx,%eax
80101503:	83 e0 07             	and    $0x7,%eax
80101506:	29 d0                	sub    %edx,%eax
80101508:	ba 01 00 00 00       	mov    $0x1,%edx
8010150d:	89 c1                	mov    %eax,%ecx
8010150f:	d3 e2                	shl    %cl,%edx
80101511:	89 d0                	mov    %edx,%eax
80101513:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101516:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101519:	8d 50 07             	lea    0x7(%eax),%edx
8010151c:	85 c0                	test   %eax,%eax
8010151e:	0f 48 c2             	cmovs  %edx,%eax
80101521:	c1 f8 03             	sar    $0x3,%eax
80101524:	89 c2                	mov    %eax,%edx
80101526:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101529:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010152e:	0f b6 c0             	movzbl %al,%eax
80101531:	23 45 e8             	and    -0x18(%ebp),%eax
80101534:	85 c0                	test   %eax,%eax
80101536:	75 64                	jne    8010159c <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101538:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153b:	8d 50 07             	lea    0x7(%eax),%edx
8010153e:	85 c0                	test   %eax,%eax
80101540:	0f 48 c2             	cmovs  %edx,%eax
80101543:	c1 f8 03             	sar    $0x3,%eax
80101546:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101549:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010154e:	89 d1                	mov    %edx,%ecx
80101550:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101553:	09 ca                	or     %ecx,%edx
80101555:	89 d1                	mov    %edx,%ecx
80101557:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010155a:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010155e:	83 ec 0c             	sub    $0xc,%esp
80101561:	ff 75 ec             	pushl  -0x14(%ebp)
80101564:	e8 7d 23 00 00       	call   801038e6 <log_write>
80101569:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010156c:	83 ec 0c             	sub    $0xc,%esp
8010156f:	ff 75 ec             	pushl  -0x14(%ebp)
80101572:	e8 c8 ec ff ff       	call   8010023f <brelse>
80101577:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101580:	01 c2                	add    %eax,%edx
80101582:	8b 45 08             	mov    0x8(%ebp),%eax
80101585:	83 ec 08             	sub    $0x8,%esp
80101588:	52                   	push   %edx
80101589:	50                   	push   %eax
8010158a:	e8 be fe ff ff       	call   8010144d <bzero>
8010158f:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101592:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101595:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101598:	01 d0                	add    %edx,%eax
8010159a:	eb 57                	jmp    801015f3 <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010159c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015a0:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015a7:	7f 17                	jg     801015c0 <balloc+0x11b>
801015a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015af:	01 d0                	add    %edx,%eax
801015b1:	89 c2                	mov    %eax,%edx
801015b3:	a1 20 22 11 80       	mov    0x80112220,%eax
801015b8:	39 c2                	cmp    %eax,%edx
801015ba:	0f 82 3a ff ff ff    	jb     801014fa <balloc+0x55>
      }
    }
    brelse(bp);
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	ff 75 ec             	pushl  -0x14(%ebp)
801015c6:	e8 74 ec ff ff       	call   8010023f <brelse>
801015cb:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015ce:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015d5:	8b 15 20 22 11 80    	mov    0x80112220,%edx
801015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015de:	39 c2                	cmp    %eax,%edx
801015e0:	0f 87 dc fe ff ff    	ja     801014c2 <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801015e6:	83 ec 0c             	sub    $0xc,%esp
801015e9:	68 30 8d 10 80       	push   $0x80108d30
801015ee:	e8 a4 ef ff ff       	call   80100597 <panic>
}
801015f3:	c9                   	leave  
801015f4:	c3                   	ret    

801015f5 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015f5:	f3 0f 1e fb          	endbr32 
801015f9:	55                   	push   %ebp
801015fa:	89 e5                	mov    %esp,%ebp
801015fc:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015ff:	83 ec 08             	sub    $0x8,%esp
80101602:	68 20 22 11 80       	push   $0x80112220
80101607:	ff 75 08             	pushl  0x8(%ebp)
8010160a:	e8 f8 fd ff ff       	call   80101407 <readsb>
8010160f:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101612:	8b 45 0c             	mov    0xc(%ebp),%eax
80101615:	c1 e8 0c             	shr    $0xc,%eax
80101618:	89 c2                	mov    %eax,%edx
8010161a:	a1 38 22 11 80       	mov    0x80112238,%eax
8010161f:	01 c2                	add    %eax,%edx
80101621:	8b 45 08             	mov    0x8(%ebp),%eax
80101624:	83 ec 08             	sub    $0x8,%esp
80101627:	52                   	push   %edx
80101628:	50                   	push   %eax
80101629:	e8 91 eb ff ff       	call   801001bf <bread>
8010162e:	83 c4 10             	add    $0x10,%esp
80101631:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101634:	8b 45 0c             	mov    0xc(%ebp),%eax
80101637:	25 ff 0f 00 00       	and    $0xfff,%eax
8010163c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101642:	99                   	cltd   
80101643:	c1 ea 1d             	shr    $0x1d,%edx
80101646:	01 d0                	add    %edx,%eax
80101648:	83 e0 07             	and    $0x7,%eax
8010164b:	29 d0                	sub    %edx,%eax
8010164d:	ba 01 00 00 00       	mov    $0x1,%edx
80101652:	89 c1                	mov    %eax,%ecx
80101654:	d3 e2                	shl    %cl,%edx
80101656:	89 d0                	mov    %edx,%eax
80101658:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165e:	8d 50 07             	lea    0x7(%eax),%edx
80101661:	85 c0                	test   %eax,%eax
80101663:	0f 48 c2             	cmovs  %edx,%eax
80101666:	c1 f8 03             	sar    $0x3,%eax
80101669:	89 c2                	mov    %eax,%edx
8010166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010166e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101673:	0f b6 c0             	movzbl %al,%eax
80101676:	23 45 ec             	and    -0x14(%ebp),%eax
80101679:	85 c0                	test   %eax,%eax
8010167b:	75 0d                	jne    8010168a <bfree+0x95>
    panic("freeing free block");
8010167d:	83 ec 0c             	sub    $0xc,%esp
80101680:	68 46 8d 10 80       	push   $0x80108d46
80101685:	e8 0d ef ff ff       	call   80100597 <panic>
  bp->data[bi/8] &= ~m;
8010168a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010168d:	8d 50 07             	lea    0x7(%eax),%edx
80101690:	85 c0                	test   %eax,%eax
80101692:	0f 48 c2             	cmovs  %edx,%eax
80101695:	c1 f8 03             	sar    $0x3,%eax
80101698:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010169b:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016a0:	89 d1                	mov    %edx,%ecx
801016a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016a5:	f7 d2                	not    %edx
801016a7:	21 ca                	and    %ecx,%edx
801016a9:	89 d1                	mov    %edx,%ecx
801016ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ae:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016b2:	83 ec 0c             	sub    $0xc,%esp
801016b5:	ff 75 f4             	pushl  -0xc(%ebp)
801016b8:	e8 29 22 00 00       	call   801038e6 <log_write>
801016bd:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	ff 75 f4             	pushl  -0xc(%ebp)
801016c6:	e8 74 eb ff ff       	call   8010023f <brelse>
801016cb:	83 c4 10             	add    $0x10,%esp
}
801016ce:	90                   	nop
801016cf:	c9                   	leave  
801016d0:	c3                   	ret    

801016d1 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016d1:	f3 0f 1e fb          	endbr32 
801016d5:	55                   	push   %ebp
801016d6:	89 e5                	mov    %esp,%ebp
801016d8:	57                   	push   %edi
801016d9:	56                   	push   %esi
801016da:	53                   	push   %ebx
801016db:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	68 59 8d 10 80       	push   $0x80108d59
801016e6:	68 40 22 11 80       	push   $0x80112240
801016eb:	e8 8f 3e 00 00       	call   8010557f <initlock>
801016f0:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	68 20 22 11 80       	push   $0x80112220
801016fb:	ff 75 08             	pushl  0x8(%ebp)
801016fe:	e8 04 fd ff ff       	call   80101407 <readsb>
80101703:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101706:	a1 38 22 11 80       	mov    0x80112238,%eax
8010170b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010170e:	8b 3d 34 22 11 80    	mov    0x80112234,%edi
80101714:	8b 35 30 22 11 80    	mov    0x80112230,%esi
8010171a:	8b 1d 2c 22 11 80    	mov    0x8011222c,%ebx
80101720:	8b 0d 28 22 11 80    	mov    0x80112228,%ecx
80101726:	8b 15 24 22 11 80    	mov    0x80112224,%edx
8010172c:	a1 20 22 11 80       	mov    0x80112220,%eax
80101731:	ff 75 e4             	pushl  -0x1c(%ebp)
80101734:	57                   	push   %edi
80101735:	56                   	push   %esi
80101736:	53                   	push   %ebx
80101737:	51                   	push   %ecx
80101738:	52                   	push   %edx
80101739:	50                   	push   %eax
8010173a:	68 60 8d 10 80       	push   $0x80108d60
8010173f:	e8 9a ec ff ff       	call   801003de <cprintf>
80101744:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101747:	90                   	nop
80101748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010174b:	5b                   	pop    %ebx
8010174c:	5e                   	pop    %esi
8010174d:	5f                   	pop    %edi
8010174e:	5d                   	pop    %ebp
8010174f:	c3                   	ret    

80101750 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101750:	f3 0f 1e fb          	endbr32 
80101754:	55                   	push   %ebp
80101755:	89 e5                	mov    %esp,%ebp
80101757:	83 ec 28             	sub    $0x28,%esp
8010175a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010175d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101761:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101768:	e9 9e 00 00 00       	jmp    8010180b <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
8010176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101770:	c1 e8 03             	shr    $0x3,%eax
80101773:	89 c2                	mov    %eax,%edx
80101775:	a1 34 22 11 80       	mov    0x80112234,%eax
8010177a:	01 d0                	add    %edx,%eax
8010177c:	83 ec 08             	sub    $0x8,%esp
8010177f:	50                   	push   %eax
80101780:	ff 75 08             	pushl  0x8(%ebp)
80101783:	e8 37 ea ff ff       	call   801001bf <bread>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101791:	8d 50 18             	lea    0x18(%eax),%edx
80101794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101797:	83 e0 07             	and    $0x7,%eax
8010179a:	c1 e0 06             	shl    $0x6,%eax
8010179d:	01 d0                	add    %edx,%eax
8010179f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a5:	0f b7 00             	movzwl (%eax),%eax
801017a8:	66 85 c0             	test   %ax,%ax
801017ab:	75 4c                	jne    801017f9 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801017ad:	83 ec 04             	sub    $0x4,%esp
801017b0:	6a 40                	push   $0x40
801017b2:	6a 00                	push   $0x0
801017b4:	ff 75 ec             	pushl  -0x14(%ebp)
801017b7:	e8 65 40 00 00       	call   80105821 <memset>
801017bc:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017c2:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017c6:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017c9:	83 ec 0c             	sub    $0xc,%esp
801017cc:	ff 75 f0             	pushl  -0x10(%ebp)
801017cf:	e8 12 21 00 00       	call   801038e6 <log_write>
801017d4:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017d7:	83 ec 0c             	sub    $0xc,%esp
801017da:	ff 75 f0             	pushl  -0x10(%ebp)
801017dd:	e8 5d ea ff ff       	call   8010023f <brelse>
801017e2:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	50                   	push   %eax
801017ec:	ff 75 08             	pushl  0x8(%ebp)
801017ef:	e8 fc 00 00 00       	call   801018f0 <iget>
801017f4:	83 c4 10             	add    $0x10,%esp
801017f7:	eb 30                	jmp    80101829 <ialloc+0xd9>
    }
    brelse(bp);
801017f9:	83 ec 0c             	sub    $0xc,%esp
801017fc:	ff 75 f0             	pushl  -0x10(%ebp)
801017ff:	e8 3b ea ff ff       	call   8010023f <brelse>
80101804:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101807:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010180b:	8b 15 28 22 11 80    	mov    0x80112228,%edx
80101811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101814:	39 c2                	cmp    %eax,%edx
80101816:	0f 87 51 ff ff ff    	ja     8010176d <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
8010181c:	83 ec 0c             	sub    $0xc,%esp
8010181f:	68 b3 8d 10 80       	push   $0x80108db3
80101824:	e8 6e ed ff ff       	call   80100597 <panic>
}
80101829:	c9                   	leave  
8010182a:	c3                   	ret    

8010182b <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010182b:	f3 0f 1e fb          	endbr32 
8010182f:	55                   	push   %ebp
80101830:	89 e5                	mov    %esp,%ebp
80101832:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101835:	8b 45 08             	mov    0x8(%ebp),%eax
80101838:	8b 40 04             	mov    0x4(%eax),%eax
8010183b:	c1 e8 03             	shr    $0x3,%eax
8010183e:	89 c2                	mov    %eax,%edx
80101840:	a1 34 22 11 80       	mov    0x80112234,%eax
80101845:	01 c2                	add    %eax,%edx
80101847:	8b 45 08             	mov    0x8(%ebp),%eax
8010184a:	8b 00                	mov    (%eax),%eax
8010184c:	83 ec 08             	sub    $0x8,%esp
8010184f:	52                   	push   %edx
80101850:	50                   	push   %eax
80101851:	e8 69 e9 ff ff       	call   801001bf <bread>
80101856:	83 c4 10             	add    $0x10,%esp
80101859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185f:	8d 50 18             	lea    0x18(%eax),%edx
80101862:	8b 45 08             	mov    0x8(%ebp),%eax
80101865:	8b 40 04             	mov    0x4(%eax),%eax
80101868:	83 e0 07             	and    $0x7,%eax
8010186b:	c1 e0 06             	shl    $0x6,%eax
8010186e:	01 d0                	add    %edx,%eax
80101870:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101873:	8b 45 08             	mov    0x8(%ebp),%eax
80101876:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101880:	8b 45 08             	mov    0x8(%ebp),%eax
80101883:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101887:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188a:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010188e:	8b 45 08             	mov    0x8(%ebp),%eax
80101891:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101898:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010189c:	8b 45 08             	mov    0x8(%ebp),%eax
8010189f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a6:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018aa:	8b 45 08             	mov    0x8(%ebp),%eax
801018ad:	8b 50 18             	mov    0x18(%eax),%edx
801018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b3:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	8d 50 1c             	lea    0x1c(%eax),%edx
801018bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018bf:	83 c0 0c             	add    $0xc,%eax
801018c2:	83 ec 04             	sub    $0x4,%esp
801018c5:	6a 34                	push   $0x34
801018c7:	52                   	push   %edx
801018c8:	50                   	push   %eax
801018c9:	e8 1a 40 00 00       	call   801058e8 <memmove>
801018ce:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d1:	83 ec 0c             	sub    $0xc,%esp
801018d4:	ff 75 f4             	pushl  -0xc(%ebp)
801018d7:	e8 0a 20 00 00       	call   801038e6 <log_write>
801018dc:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018df:	83 ec 0c             	sub    $0xc,%esp
801018e2:	ff 75 f4             	pushl  -0xc(%ebp)
801018e5:	e8 55 e9 ff ff       	call   8010023f <brelse>
801018ea:	83 c4 10             	add    $0x10,%esp
}
801018ed:	90                   	nop
801018ee:	c9                   	leave  
801018ef:	c3                   	ret    

801018f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018f0:	f3 0f 1e fb          	endbr32 
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018fa:	83 ec 0c             	sub    $0xc,%esp
801018fd:	68 40 22 11 80       	push   $0x80112240
80101902:	e8 9e 3c 00 00       	call   801055a5 <acquire>
80101907:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101911:	c7 45 f4 74 22 11 80 	movl   $0x80112274,-0xc(%ebp)
80101918:	eb 5d                	jmp    80101977 <iget+0x87>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191d:	8b 40 08             	mov    0x8(%eax),%eax
80101920:	85 c0                	test   %eax,%eax
80101922:	7e 39                	jle    8010195d <iget+0x6d>
80101924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101927:	8b 00                	mov    (%eax),%eax
80101929:	39 45 08             	cmp    %eax,0x8(%ebp)
8010192c:	75 2f                	jne    8010195d <iget+0x6d>
8010192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101931:	8b 40 04             	mov    0x4(%eax),%eax
80101934:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101937:	75 24                	jne    8010195d <iget+0x6d>
      ip->ref++;
80101939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193c:	8b 40 08             	mov    0x8(%eax),%eax
8010193f:	8d 50 01             	lea    0x1(%eax),%edx
80101942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101945:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101948:	83 ec 0c             	sub    $0xc,%esp
8010194b:	68 40 22 11 80       	push   $0x80112240
80101950:	e8 bb 3c 00 00       	call   80105610 <release>
80101955:	83 c4 10             	add    $0x10,%esp
      return ip;
80101958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195b:	eb 74                	jmp    801019d1 <iget+0xe1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010195d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101961:	75 10                	jne    80101973 <iget+0x83>
80101963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101966:	8b 40 08             	mov    0x8(%eax),%eax
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 06                	jne    80101973 <iget+0x83>
      empty = ip;
8010196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101970:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101973:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101977:	81 7d f4 14 32 11 80 	cmpl   $0x80113214,-0xc(%ebp)
8010197e:	72 9a                	jb     8010191a <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101984:	75 0d                	jne    80101993 <iget+0xa3>
    panic("iget: no inodes");
80101986:	83 ec 0c             	sub    $0xc,%esp
80101989:	68 c5 8d 10 80       	push   $0x80108dc5
8010198e:	e8 04 ec ff ff       	call   80100597 <panic>

  ip = empty;
80101993:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199c:	8b 55 08             	mov    0x8(%ebp),%edx
8010199f:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801019a7:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ad:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019be:	83 ec 0c             	sub    $0xc,%esp
801019c1:	68 40 22 11 80       	push   $0x80112240
801019c6:	e8 45 3c 00 00       	call   80105610 <release>
801019cb:	83 c4 10             	add    $0x10,%esp

  return ip;
801019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019d1:	c9                   	leave  
801019d2:	c3                   	ret    

801019d3 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019d3:	f3 0f 1e fb          	endbr32 
801019d7:	55                   	push   %ebp
801019d8:	89 e5                	mov    %esp,%ebp
801019da:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019dd:	83 ec 0c             	sub    $0xc,%esp
801019e0:	68 40 22 11 80       	push   $0x80112240
801019e5:	e8 bb 3b 00 00       	call   801055a5 <acquire>
801019ea:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	8b 40 08             	mov    0x8(%eax),%eax
801019f3:	8d 50 01             	lea    0x1(%eax),%edx
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019fc:	83 ec 0c             	sub    $0xc,%esp
801019ff:	68 40 22 11 80       	push   $0x80112240
80101a04:	e8 07 3c 00 00       	call   80105610 <release>
80101a09:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a0f:	c9                   	leave  
80101a10:	c3                   	ret    

80101a11 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a11:	f3 0f 1e fb          	endbr32 
80101a15:	55                   	push   %ebp
80101a16:	89 e5                	mov    %esp,%ebp
80101a18:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a1f:	74 0a                	je     80101a2b <ilock+0x1a>
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
80101a24:	8b 40 08             	mov    0x8(%eax),%eax
80101a27:	85 c0                	test   %eax,%eax
80101a29:	7f 0d                	jg     80101a38 <ilock+0x27>
    panic("ilock");
80101a2b:	83 ec 0c             	sub    $0xc,%esp
80101a2e:	68 d5 8d 10 80       	push   $0x80108dd5
80101a33:	e8 5f eb ff ff       	call   80100597 <panic>

  acquire(&icache.lock);
80101a38:	83 ec 0c             	sub    $0xc,%esp
80101a3b:	68 40 22 11 80       	push   $0x80112240
80101a40:	e8 60 3b 00 00       	call   801055a5 <acquire>
80101a45:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a48:	eb 13                	jmp    80101a5d <ilock+0x4c>
    sleep(ip, &icache.lock);
80101a4a:	83 ec 08             	sub    $0x8,%esp
80101a4d:	68 40 22 11 80       	push   $0x80112240
80101a52:	ff 75 08             	pushl  0x8(%ebp)
80101a55:	e8 a8 35 00 00       	call   80105002 <sleep>
80101a5a:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 e0 01             	and    $0x1,%eax
80101a66:	85 c0                	test   %eax,%eax
80101a68:	75 e0                	jne    80101a4a <ilock+0x39>
  ip->flags |= I_BUSY;
80101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a70:	83 c8 01             	or     $0x1,%eax
80101a73:	89 c2                	mov    %eax,%edx
80101a75:	8b 45 08             	mov    0x8(%ebp),%eax
80101a78:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a7b:	83 ec 0c             	sub    $0xc,%esp
80101a7e:	68 40 22 11 80       	push   $0x80112240
80101a83:	e8 88 3b 00 00       	call   80105610 <release>
80101a88:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8e:	8b 40 0c             	mov    0xc(%eax),%eax
80101a91:	83 e0 02             	and    $0x2,%eax
80101a94:	85 c0                	test   %eax,%eax
80101a96:	0f 85 d4 00 00 00    	jne    80101b70 <ilock+0x15f>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 40 04             	mov    0x4(%eax),%eax
80101aa2:	c1 e8 03             	shr    $0x3,%eax
80101aa5:	89 c2                	mov    %eax,%edx
80101aa7:	a1 34 22 11 80       	mov    0x80112234,%eax
80101aac:	01 c2                	add    %eax,%edx
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	8b 00                	mov    (%eax),%eax
80101ab3:	83 ec 08             	sub    $0x8,%esp
80101ab6:	52                   	push   %edx
80101ab7:	50                   	push   %eax
80101ab8:	e8 02 e7 ff ff       	call   801001bf <bread>
80101abd:	83 c4 10             	add    $0x10,%esp
80101ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac6:	8d 50 18             	lea    0x18(%eax),%edx
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	8b 40 04             	mov    0x4(%eax),%eax
80101acf:	83 e0 07             	and    $0x7,%eax
80101ad2:	c1 e0 06             	shl    $0x6,%eax
80101ad5:	01 d0                	add    %edx,%eax
80101ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101add:	0f b7 10             	movzwl (%eax),%edx
80101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae3:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aea:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101aee:	8b 45 08             	mov    0x8(%ebp),%eax
80101af1:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af8:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b06:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b14:	8b 50 08             	mov    0x8(%eax),%edx
80101b17:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1a:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b20:	8d 50 0c             	lea    0xc(%eax),%edx
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	83 c0 1c             	add    $0x1c,%eax
80101b29:	83 ec 04             	sub    $0x4,%esp
80101b2c:	6a 34                	push   $0x34
80101b2e:	52                   	push   %edx
80101b2f:	50                   	push   %eax
80101b30:	e8 b3 3d 00 00       	call   801058e8 <memmove>
80101b35:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b38:	83 ec 0c             	sub    $0xc,%esp
80101b3b:	ff 75 f4             	pushl  -0xc(%ebp)
80101b3e:	e8 fc e6 ff ff       	call   8010023f <brelse>
80101b43:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b46:	8b 45 08             	mov    0x8(%ebp),%eax
80101b49:	8b 40 0c             	mov    0xc(%eax),%eax
80101b4c:	83 c8 02             	or     $0x2,%eax
80101b4f:	89 c2                	mov    %eax,%edx
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b5e:	66 85 c0             	test   %ax,%ax
80101b61:	75 0d                	jne    80101b70 <ilock+0x15f>
      panic("ilock: no type");
80101b63:	83 ec 0c             	sub    $0xc,%esp
80101b66:	68 db 8d 10 80       	push   $0x80108ddb
80101b6b:	e8 27 ea ff ff       	call   80100597 <panic>
  }
}
80101b70:	90                   	nop
80101b71:	c9                   	leave  
80101b72:	c3                   	ret    

80101b73 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b73:	f3 0f 1e fb          	endbr32 
80101b77:	55                   	push   %ebp
80101b78:	89 e5                	mov    %esp,%ebp
80101b7a:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b81:	74 17                	je     80101b9a <iunlock+0x27>
80101b83:	8b 45 08             	mov    0x8(%ebp),%eax
80101b86:	8b 40 0c             	mov    0xc(%eax),%eax
80101b89:	83 e0 01             	and    $0x1,%eax
80101b8c:	85 c0                	test   %eax,%eax
80101b8e:	74 0a                	je     80101b9a <iunlock+0x27>
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	8b 40 08             	mov    0x8(%eax),%eax
80101b96:	85 c0                	test   %eax,%eax
80101b98:	7f 0d                	jg     80101ba7 <iunlock+0x34>
    panic("iunlock");
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 ea 8d 10 80       	push   $0x80108dea
80101ba2:	e8 f0 e9 ff ff       	call   80100597 <panic>

  acquire(&icache.lock);
80101ba7:	83 ec 0c             	sub    $0xc,%esp
80101baa:	68 40 22 11 80       	push   $0x80112240
80101baf:	e8 f1 39 00 00       	call   801055a5 <acquire>
80101bb4:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bba:	8b 40 0c             	mov    0xc(%eax),%eax
80101bbd:	83 e0 fe             	and    $0xfffffffe,%eax
80101bc0:	89 c2                	mov    %eax,%edx
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	ff 75 08             	pushl  0x8(%ebp)
80101bce:	e8 26 35 00 00       	call   801050f9 <wakeup>
80101bd3:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	68 40 22 11 80       	push   $0x80112240
80101bde:	e8 2d 3a 00 00       	call   80105610 <release>
80101be3:	83 c4 10             	add    $0x10,%esp
}
80101be6:	90                   	nop
80101be7:	c9                   	leave  
80101be8:	c3                   	ret    

80101be9 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101be9:	f3 0f 1e fb          	endbr32 
80101bed:	55                   	push   %ebp
80101bee:	89 e5                	mov    %esp,%ebp
80101bf0:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bf3:	83 ec 0c             	sub    $0xc,%esp
80101bf6:	68 40 22 11 80       	push   $0x80112240
80101bfb:	e8 a5 39 00 00       	call   801055a5 <acquire>
80101c00:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101c03:	8b 45 08             	mov    0x8(%ebp),%eax
80101c06:	8b 40 08             	mov    0x8(%eax),%eax
80101c09:	83 f8 01             	cmp    $0x1,%eax
80101c0c:	0f 85 a9 00 00 00    	jne    80101cbb <iput+0xd2>
80101c12:	8b 45 08             	mov    0x8(%ebp),%eax
80101c15:	8b 40 0c             	mov    0xc(%eax),%eax
80101c18:	83 e0 02             	and    $0x2,%eax
80101c1b:	85 c0                	test   %eax,%eax
80101c1d:	0f 84 98 00 00 00    	je     80101cbb <iput+0xd2>
80101c23:	8b 45 08             	mov    0x8(%ebp),%eax
80101c26:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c2a:	66 85 c0             	test   %ax,%ax
80101c2d:	0f 85 88 00 00 00    	jne    80101cbb <iput+0xd2>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c33:	8b 45 08             	mov    0x8(%ebp),%eax
80101c36:	8b 40 0c             	mov    0xc(%eax),%eax
80101c39:	83 e0 01             	and    $0x1,%eax
80101c3c:	85 c0                	test   %eax,%eax
80101c3e:	74 0d                	je     80101c4d <iput+0x64>
      panic("iput busy");
80101c40:	83 ec 0c             	sub    $0xc,%esp
80101c43:	68 f2 8d 10 80       	push   $0x80108df2
80101c48:	e8 4a e9 ff ff       	call   80100597 <panic>
    ip->flags |= I_BUSY;
80101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c50:	8b 40 0c             	mov    0xc(%eax),%eax
80101c53:	83 c8 01             	or     $0x1,%eax
80101c56:	89 c2                	mov    %eax,%edx
80101c58:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5b:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
80101c61:	68 40 22 11 80       	push   $0x80112240
80101c66:	e8 a5 39 00 00       	call   80105610 <release>
80101c6b:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
80101c71:	ff 75 08             	pushl  0x8(%ebp)
80101c74:	e8 ab 01 00 00       	call   80101e24 <itrunc>
80101c79:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7f:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c85:	83 ec 0c             	sub    $0xc,%esp
80101c88:	ff 75 08             	pushl  0x8(%ebp)
80101c8b:	e8 9b fb ff ff       	call   8010182b <iupdate>
80101c90:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c93:	83 ec 0c             	sub    $0xc,%esp
80101c96:	68 40 22 11 80       	push   $0x80112240
80101c9b:	e8 05 39 00 00       	call   801055a5 <acquire>
80101ca0:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101cad:	83 ec 0c             	sub    $0xc,%esp
80101cb0:	ff 75 08             	pushl  0x8(%ebp)
80101cb3:	e8 41 34 00 00       	call   801050f9 <wakeup>
80101cb8:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbe:	8b 40 08             	mov    0x8(%eax),%eax
80101cc1:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc7:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cca:	83 ec 0c             	sub    $0xc,%esp
80101ccd:	68 40 22 11 80       	push   $0x80112240
80101cd2:	e8 39 39 00 00       	call   80105610 <release>
80101cd7:	83 c4 10             	add    $0x10,%esp
}
80101cda:	90                   	nop
80101cdb:	c9                   	leave  
80101cdc:	c3                   	ret    

80101cdd <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cdd:	f3 0f 1e fb          	endbr32 
80101ce1:	55                   	push   %ebp
80101ce2:	89 e5                	mov    %esp,%ebp
80101ce4:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	ff 75 08             	pushl  0x8(%ebp)
80101ced:	e8 81 fe ff ff       	call   80101b73 <iunlock>
80101cf2:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cf5:	83 ec 0c             	sub    $0xc,%esp
80101cf8:	ff 75 08             	pushl  0x8(%ebp)
80101cfb:	e8 e9 fe ff ff       	call   80101be9 <iput>
80101d00:	83 c4 10             	add    $0x10,%esp
}
80101d03:	90                   	nop
80101d04:	c9                   	leave  
80101d05:	c3                   	ret    

80101d06 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d06:	f3 0f 1e fb          	endbr32 
80101d0a:	55                   	push   %ebp
80101d0b:	89 e5                	mov    %esp,%ebp
80101d0d:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d10:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d14:	77 42                	ja     80101d58 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101d16:	8b 45 08             	mov    0x8(%ebp),%eax
80101d19:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d1c:	83 c2 04             	add    $0x4,%edx
80101d1f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d2a:	75 24                	jne    80101d50 <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8b 00                	mov    (%eax),%eax
80101d31:	83 ec 0c             	sub    $0xc,%esp
80101d34:	50                   	push   %eax
80101d35:	e8 6b f7 ff ff       	call   801014a5 <balloc>
80101d3a:	83 c4 10             	add    $0x10,%esp
80101d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d40:	8b 45 08             	mov    0x8(%ebp),%eax
80101d43:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d46:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d53:	e9 ca 00 00 00       	jmp    80101e22 <bmap+0x11c>
  }
  bn -= NDIRECT;
80101d58:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d5c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d60:	0f 87 af 00 00 00    	ja     80101e15 <bmap+0x10f>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d73:	75 1d                	jne    80101d92 <bmap+0x8c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d75:	8b 45 08             	mov    0x8(%ebp),%eax
80101d78:	8b 00                	mov    (%eax),%eax
80101d7a:	83 ec 0c             	sub    $0xc,%esp
80101d7d:	50                   	push   %eax
80101d7e:	e8 22 f7 ff ff       	call   801014a5 <balloc>
80101d83:	83 c4 10             	add    $0x10,%esp
80101d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d89:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d8f:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 00                	mov    (%eax),%eax
80101d97:	83 ec 08             	sub    $0x8,%esp
80101d9a:	ff 75 f4             	pushl  -0xc(%ebp)
80101d9d:	50                   	push   %eax
80101d9e:	e8 1c e4 ff ff       	call   801001bf <bread>
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dac:	83 c0 18             	add    $0x18,%eax
80101daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101db2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101db5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dbf:	01 d0                	add    %edx,%eax
80101dc1:	8b 00                	mov    (%eax),%eax
80101dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dca:	75 36                	jne    80101e02 <bmap+0xfc>
      a[bn] = addr = balloc(ip->dev);
80101dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcf:	8b 00                	mov    (%eax),%eax
80101dd1:	83 ec 0c             	sub    $0xc,%esp
80101dd4:	50                   	push   %eax
80101dd5:	e8 cb f6 ff ff       	call   801014a5 <balloc>
80101dda:	83 c4 10             	add    $0x10,%esp
80101ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ded:	01 c2                	add    %eax,%edx
80101def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101df2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101df4:	83 ec 0c             	sub    $0xc,%esp
80101df7:	ff 75 f0             	pushl  -0x10(%ebp)
80101dfa:	e8 e7 1a 00 00       	call   801038e6 <log_write>
80101dff:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e02:	83 ec 0c             	sub    $0xc,%esp
80101e05:	ff 75 f0             	pushl  -0x10(%ebp)
80101e08:	e8 32 e4 ff ff       	call   8010023f <brelse>
80101e0d:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e13:	eb 0d                	jmp    80101e22 <bmap+0x11c>
  }

  panic("bmap: out of range");
80101e15:	83 ec 0c             	sub    $0xc,%esp
80101e18:	68 fc 8d 10 80       	push   $0x80108dfc
80101e1d:	e8 75 e7 ff ff       	call   80100597 <panic>
}
80101e22:	c9                   	leave  
80101e23:	c3                   	ret    

80101e24 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e24:	f3 0f 1e fb          	endbr32 
80101e28:	55                   	push   %ebp
80101e29:	89 e5                	mov    %esp,%ebp
80101e2b:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e35:	eb 45                	jmp    80101e7c <itrunc+0x58>
    if(ip->addrs[i]){
80101e37:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e3d:	83 c2 04             	add    $0x4,%edx
80101e40:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e44:	85 c0                	test   %eax,%eax
80101e46:	74 30                	je     80101e78 <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101e48:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e4e:	83 c2 04             	add    $0x4,%edx
80101e51:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e55:	8b 55 08             	mov    0x8(%ebp),%edx
80101e58:	8b 12                	mov    (%edx),%edx
80101e5a:	83 ec 08             	sub    $0x8,%esp
80101e5d:	50                   	push   %eax
80101e5e:	52                   	push   %edx
80101e5f:	e8 91 f7 ff ff       	call   801015f5 <bfree>
80101e64:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e67:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e6d:	83 c2 04             	add    $0x4,%edx
80101e70:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e77:	00 
  for(i = 0; i < NDIRECT; i++){
80101e78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e7c:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e80:	7e b5                	jle    80101e37 <itrunc+0x13>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e82:	8b 45 08             	mov    0x8(%ebp),%eax
80101e85:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e88:	85 c0                	test   %eax,%eax
80101e8a:	0f 84 a1 00 00 00    	je     80101f31 <itrunc+0x10d>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e90:	8b 45 08             	mov    0x8(%ebp),%eax
80101e93:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e96:	8b 45 08             	mov    0x8(%ebp),%eax
80101e99:	8b 00                	mov    (%eax),%eax
80101e9b:	83 ec 08             	sub    $0x8,%esp
80101e9e:	52                   	push   %edx
80101e9f:	50                   	push   %eax
80101ea0:	e8 1a e3 ff ff       	call   801001bf <bread>
80101ea5:	83 c4 10             	add    $0x10,%esp
80101ea8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eae:	83 c0 18             	add    $0x18,%eax
80101eb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101eb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ebb:	eb 3c                	jmp    80101ef9 <itrunc+0xd5>
      if(a[j])
80101ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eca:	01 d0                	add    %edx,%eax
80101ecc:	8b 00                	mov    (%eax),%eax
80101ece:	85 c0                	test   %eax,%eax
80101ed0:	74 23                	je     80101ef5 <itrunc+0xd1>
        bfree(ip->dev, a[j]);
80101ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ed5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101edf:	01 d0                	add    %edx,%eax
80101ee1:	8b 00                	mov    (%eax),%eax
80101ee3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ee6:	8b 12                	mov    (%edx),%edx
80101ee8:	83 ec 08             	sub    $0x8,%esp
80101eeb:	50                   	push   %eax
80101eec:	52                   	push   %edx
80101eed:	e8 03 f7 ff ff       	call   801015f5 <bfree>
80101ef2:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101ef5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101efc:	83 f8 7f             	cmp    $0x7f,%eax
80101eff:	76 bc                	jbe    80101ebd <itrunc+0x99>
    }
    brelse(bp);
80101f01:	83 ec 0c             	sub    $0xc,%esp
80101f04:	ff 75 ec             	pushl  -0x14(%ebp)
80101f07:	e8 33 e3 ff ff       	call   8010023f <brelse>
80101f0c:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f12:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f15:	8b 55 08             	mov    0x8(%ebp),%edx
80101f18:	8b 12                	mov    (%edx),%edx
80101f1a:	83 ec 08             	sub    $0x8,%esp
80101f1d:	50                   	push   %eax
80101f1e:	52                   	push   %edx
80101f1f:	e8 d1 f6 ff ff       	call   801015f5 <bfree>
80101f24:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f31:	8b 45 08             	mov    0x8(%ebp),%eax
80101f34:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f3b:	83 ec 0c             	sub    $0xc,%esp
80101f3e:	ff 75 08             	pushl  0x8(%ebp)
80101f41:	e8 e5 f8 ff ff       	call   8010182b <iupdate>
80101f46:	83 c4 10             	add    $0x10,%esp
}
80101f49:	90                   	nop
80101f4a:	c9                   	leave  
80101f4b:	c3                   	ret    

80101f4c <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f4c:	f3 0f 1e fb          	endbr32 
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f53:	8b 45 08             	mov    0x8(%ebp),%eax
80101f56:	8b 00                	mov    (%eax),%eax
80101f58:	89 c2                	mov    %eax,%edx
80101f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f5d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f60:	8b 45 08             	mov    0x8(%ebp),%eax
80101f63:	8b 50 04             	mov    0x4(%eax),%edx
80101f66:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f69:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6f:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f73:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f76:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f80:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f83:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f87:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8a:	8b 50 18             	mov    0x18(%eax),%edx
80101f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f90:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f93:	90                   	nop
80101f94:	5d                   	pop    %ebp
80101f95:	c3                   	ret    

80101f96 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f96:	f3 0f 1e fb          	endbr32 
80101f9a:	55                   	push   %ebp
80101f9b:	89 e5                	mov    %esp,%ebp
80101f9d:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101fa7:	66 83 f8 03          	cmp    $0x3,%ax
80101fab:	75 5c                	jne    80102009 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101fad:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb4:	66 85 c0             	test   %ax,%ax
80101fb7:	78 20                	js     80101fd9 <readi+0x43>
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fc0:	66 83 f8 09          	cmp    $0x9,%ax
80101fc4:	7f 13                	jg     80101fd9 <readi+0x43>
80101fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fcd:	98                   	cwtl   
80101fce:	8b 04 c5 c0 21 11 80 	mov    -0x7feede40(,%eax,8),%eax
80101fd5:	85 c0                	test   %eax,%eax
80101fd7:	75 0a                	jne    80101fe3 <readi+0x4d>
      return -1;
80101fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fde:	e9 0a 01 00 00       	jmp    801020ed <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fea:	98                   	cwtl   
80101feb:	8b 04 c5 c0 21 11 80 	mov    -0x7feede40(,%eax,8),%eax
80101ff2:	8b 55 14             	mov    0x14(%ebp),%edx
80101ff5:	83 ec 04             	sub    $0x4,%esp
80101ff8:	52                   	push   %edx
80101ff9:	ff 75 0c             	pushl  0xc(%ebp)
80101ffc:	ff 75 08             	pushl  0x8(%ebp)
80101fff:	ff d0                	call   *%eax
80102001:	83 c4 10             	add    $0x10,%esp
80102004:	e9 e4 00 00 00       	jmp    801020ed <readi+0x157>
  }

  if(off > ip->size || off + n < off)
80102009:	8b 45 08             	mov    0x8(%ebp),%eax
8010200c:	8b 40 18             	mov    0x18(%eax),%eax
8010200f:	39 45 10             	cmp    %eax,0x10(%ebp)
80102012:	77 0d                	ja     80102021 <readi+0x8b>
80102014:	8b 55 10             	mov    0x10(%ebp),%edx
80102017:	8b 45 14             	mov    0x14(%ebp),%eax
8010201a:	01 d0                	add    %edx,%eax
8010201c:	39 45 10             	cmp    %eax,0x10(%ebp)
8010201f:	76 0a                	jbe    8010202b <readi+0x95>
    return -1;
80102021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102026:	e9 c2 00 00 00       	jmp    801020ed <readi+0x157>
  if(off + n > ip->size)
8010202b:	8b 55 10             	mov    0x10(%ebp),%edx
8010202e:	8b 45 14             	mov    0x14(%ebp),%eax
80102031:	01 c2                	add    %eax,%edx
80102033:	8b 45 08             	mov    0x8(%ebp),%eax
80102036:	8b 40 18             	mov    0x18(%eax),%eax
80102039:	39 c2                	cmp    %eax,%edx
8010203b:	76 0c                	jbe    80102049 <readi+0xb3>
    n = ip->size - off;
8010203d:	8b 45 08             	mov    0x8(%ebp),%eax
80102040:	8b 40 18             	mov    0x18(%eax),%eax
80102043:	2b 45 10             	sub    0x10(%ebp),%eax
80102046:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102049:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102050:	e9 89 00 00 00       	jmp    801020de <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102055:	8b 45 10             	mov    0x10(%ebp),%eax
80102058:	c1 e8 09             	shr    $0x9,%eax
8010205b:	83 ec 08             	sub    $0x8,%esp
8010205e:	50                   	push   %eax
8010205f:	ff 75 08             	pushl  0x8(%ebp)
80102062:	e8 9f fc ff ff       	call   80101d06 <bmap>
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	8b 55 08             	mov    0x8(%ebp),%edx
8010206d:	8b 12                	mov    (%edx),%edx
8010206f:	83 ec 08             	sub    $0x8,%esp
80102072:	50                   	push   %eax
80102073:	52                   	push   %edx
80102074:	e8 46 e1 ff ff       	call   801001bf <bread>
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010207f:	8b 45 10             	mov    0x10(%ebp),%eax
80102082:	25 ff 01 00 00       	and    $0x1ff,%eax
80102087:	ba 00 02 00 00       	mov    $0x200,%edx
8010208c:	29 c2                	sub    %eax,%edx
8010208e:	8b 45 14             	mov    0x14(%ebp),%eax
80102091:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102094:	39 c2                	cmp    %eax,%edx
80102096:	0f 46 c2             	cmovbe %edx,%eax
80102099:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010209c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010209f:	8d 50 18             	lea    0x18(%eax),%edx
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	25 ff 01 00 00       	and    $0x1ff,%eax
801020aa:	01 d0                	add    %edx,%eax
801020ac:	83 ec 04             	sub    $0x4,%esp
801020af:	ff 75 ec             	pushl  -0x14(%ebp)
801020b2:	50                   	push   %eax
801020b3:	ff 75 0c             	pushl  0xc(%ebp)
801020b6:	e8 2d 38 00 00       	call   801058e8 <memmove>
801020bb:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020be:	83 ec 0c             	sub    $0xc,%esp
801020c1:	ff 75 f0             	pushl  -0x10(%ebp)
801020c4:	e8 76 e1 ff ff       	call   8010023f <brelse>
801020c9:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cf:	01 45 f4             	add    %eax,-0xc(%ebp)
801020d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020d5:	01 45 10             	add    %eax,0x10(%ebp)
801020d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020db:	01 45 0c             	add    %eax,0xc(%ebp)
801020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020e1:	3b 45 14             	cmp    0x14(%ebp),%eax
801020e4:	0f 82 6b ff ff ff    	jb     80102055 <readi+0xbf>
  }
  return n;
801020ea:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020ed:	c9                   	leave  
801020ee:	c3                   	ret    

801020ef <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020ef:	f3 0f 1e fb          	endbr32 
801020f3:	55                   	push   %ebp
801020f4:	89 e5                	mov    %esp,%ebp
801020f6:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020f9:	8b 45 08             	mov    0x8(%ebp),%eax
801020fc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102100:	66 83 f8 03          	cmp    $0x3,%ax
80102104:	75 5c                	jne    80102162 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102106:	8b 45 08             	mov    0x8(%ebp),%eax
80102109:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010210d:	66 85 c0             	test   %ax,%ax
80102110:	78 20                	js     80102132 <writei+0x43>
80102112:	8b 45 08             	mov    0x8(%ebp),%eax
80102115:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102119:	66 83 f8 09          	cmp    $0x9,%ax
8010211d:	7f 13                	jg     80102132 <writei+0x43>
8010211f:	8b 45 08             	mov    0x8(%ebp),%eax
80102122:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102126:	98                   	cwtl   
80102127:	8b 04 c5 c4 21 11 80 	mov    -0x7feede3c(,%eax,8),%eax
8010212e:	85 c0                	test   %eax,%eax
80102130:	75 0a                	jne    8010213c <writei+0x4d>
      return -1;
80102132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102137:	e9 3b 01 00 00       	jmp    80102277 <writei+0x188>
    return devsw[ip->major].write(ip, src, n);
8010213c:	8b 45 08             	mov    0x8(%ebp),%eax
8010213f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102143:	98                   	cwtl   
80102144:	8b 04 c5 c4 21 11 80 	mov    -0x7feede3c(,%eax,8),%eax
8010214b:	8b 55 14             	mov    0x14(%ebp),%edx
8010214e:	83 ec 04             	sub    $0x4,%esp
80102151:	52                   	push   %edx
80102152:	ff 75 0c             	pushl  0xc(%ebp)
80102155:	ff 75 08             	pushl  0x8(%ebp)
80102158:	ff d0                	call   *%eax
8010215a:	83 c4 10             	add    $0x10,%esp
8010215d:	e9 15 01 00 00       	jmp    80102277 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
80102162:	8b 45 08             	mov    0x8(%ebp),%eax
80102165:	8b 40 18             	mov    0x18(%eax),%eax
80102168:	39 45 10             	cmp    %eax,0x10(%ebp)
8010216b:	77 0d                	ja     8010217a <writei+0x8b>
8010216d:	8b 55 10             	mov    0x10(%ebp),%edx
80102170:	8b 45 14             	mov    0x14(%ebp),%eax
80102173:	01 d0                	add    %edx,%eax
80102175:	39 45 10             	cmp    %eax,0x10(%ebp)
80102178:	76 0a                	jbe    80102184 <writei+0x95>
    return -1;
8010217a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010217f:	e9 f3 00 00 00       	jmp    80102277 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
80102184:	8b 55 10             	mov    0x10(%ebp),%edx
80102187:	8b 45 14             	mov    0x14(%ebp),%eax
8010218a:	01 d0                	add    %edx,%eax
8010218c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102191:	76 0a                	jbe    8010219d <writei+0xae>
    return -1;
80102193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102198:	e9 da 00 00 00       	jmp    80102277 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010219d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021a4:	e9 97 00 00 00       	jmp    80102240 <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021a9:	8b 45 10             	mov    0x10(%ebp),%eax
801021ac:	c1 e8 09             	shr    $0x9,%eax
801021af:	83 ec 08             	sub    $0x8,%esp
801021b2:	50                   	push   %eax
801021b3:	ff 75 08             	pushl  0x8(%ebp)
801021b6:	e8 4b fb ff ff       	call   80101d06 <bmap>
801021bb:	83 c4 10             	add    $0x10,%esp
801021be:	8b 55 08             	mov    0x8(%ebp),%edx
801021c1:	8b 12                	mov    (%edx),%edx
801021c3:	83 ec 08             	sub    $0x8,%esp
801021c6:	50                   	push   %eax
801021c7:	52                   	push   %edx
801021c8:	e8 f2 df ff ff       	call   801001bf <bread>
801021cd:	83 c4 10             	add    $0x10,%esp
801021d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021d3:	8b 45 10             	mov    0x10(%ebp),%eax
801021d6:	25 ff 01 00 00       	and    $0x1ff,%eax
801021db:	ba 00 02 00 00       	mov    $0x200,%edx
801021e0:	29 c2                	sub    %eax,%edx
801021e2:	8b 45 14             	mov    0x14(%ebp),%eax
801021e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021e8:	39 c2                	cmp    %eax,%edx
801021ea:	0f 46 c2             	cmovbe %edx,%eax
801021ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021f3:	8d 50 18             	lea    0x18(%eax),%edx
801021f6:	8b 45 10             	mov    0x10(%ebp),%eax
801021f9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021fe:	01 d0                	add    %edx,%eax
80102200:	83 ec 04             	sub    $0x4,%esp
80102203:	ff 75 ec             	pushl  -0x14(%ebp)
80102206:	ff 75 0c             	pushl  0xc(%ebp)
80102209:	50                   	push   %eax
8010220a:	e8 d9 36 00 00       	call   801058e8 <memmove>
8010220f:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102212:	83 ec 0c             	sub    $0xc,%esp
80102215:	ff 75 f0             	pushl  -0x10(%ebp)
80102218:	e8 c9 16 00 00       	call   801038e6 <log_write>
8010221d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102220:	83 ec 0c             	sub    $0xc,%esp
80102223:	ff 75 f0             	pushl  -0x10(%ebp)
80102226:	e8 14 e0 ff ff       	call   8010023f <brelse>
8010222b:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010222e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102231:	01 45 f4             	add    %eax,-0xc(%ebp)
80102234:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102237:	01 45 10             	add    %eax,0x10(%ebp)
8010223a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010223d:	01 45 0c             	add    %eax,0xc(%ebp)
80102240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102243:	3b 45 14             	cmp    0x14(%ebp),%eax
80102246:	0f 82 5d ff ff ff    	jb     801021a9 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
8010224c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102250:	74 22                	je     80102274 <writei+0x185>
80102252:	8b 45 08             	mov    0x8(%ebp),%eax
80102255:	8b 40 18             	mov    0x18(%eax),%eax
80102258:	39 45 10             	cmp    %eax,0x10(%ebp)
8010225b:	76 17                	jbe    80102274 <writei+0x185>
    ip->size = off;
8010225d:	8b 45 08             	mov    0x8(%ebp),%eax
80102260:	8b 55 10             	mov    0x10(%ebp),%edx
80102263:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102266:	83 ec 0c             	sub    $0xc,%esp
80102269:	ff 75 08             	pushl  0x8(%ebp)
8010226c:	e8 ba f5 ff ff       	call   8010182b <iupdate>
80102271:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102274:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102277:	c9                   	leave  
80102278:	c3                   	ret    

80102279 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102279:	f3 0f 1e fb          	endbr32 
8010227d:	55                   	push   %ebp
8010227e:	89 e5                	mov    %esp,%ebp
80102280:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102283:	83 ec 04             	sub    $0x4,%esp
80102286:	6a 0e                	push   $0xe
80102288:	ff 75 0c             	pushl  0xc(%ebp)
8010228b:	ff 75 08             	pushl  0x8(%ebp)
8010228e:	e8 f3 36 00 00       	call   80105986 <strncmp>
80102293:	83 c4 10             	add    $0x10,%esp
}
80102296:	c9                   	leave  
80102297:	c3                   	ret    

80102298 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102298:	f3 0f 1e fb          	endbr32 
8010229c:	55                   	push   %ebp
8010229d:	89 e5                	mov    %esp,%ebp
8010229f:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801022a2:	8b 45 08             	mov    0x8(%ebp),%eax
801022a5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801022a9:	66 83 f8 01          	cmp    $0x1,%ax
801022ad:	74 0d                	je     801022bc <dirlookup+0x24>
    panic("dirlookup not DIR");
801022af:	83 ec 0c             	sub    $0xc,%esp
801022b2:	68 0f 8e 10 80       	push   $0x80108e0f
801022b7:	e8 db e2 ff ff       	call   80100597 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801022bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022c3:	eb 7b                	jmp    80102340 <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022c5:	6a 10                	push   $0x10
801022c7:	ff 75 f4             	pushl  -0xc(%ebp)
801022ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022cd:	50                   	push   %eax
801022ce:	ff 75 08             	pushl  0x8(%ebp)
801022d1:	e8 c0 fc ff ff       	call   80101f96 <readi>
801022d6:	83 c4 10             	add    $0x10,%esp
801022d9:	83 f8 10             	cmp    $0x10,%eax
801022dc:	74 0d                	je     801022eb <dirlookup+0x53>
      panic("dirlink read");
801022de:	83 ec 0c             	sub    $0xc,%esp
801022e1:	68 21 8e 10 80       	push   $0x80108e21
801022e6:	e8 ac e2 ff ff       	call   80100597 <panic>
    if(de.inum == 0)
801022eb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022ef:	66 85 c0             	test   %ax,%ax
801022f2:	74 47                	je     8010233b <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
801022f4:	83 ec 08             	sub    $0x8,%esp
801022f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022fa:	83 c0 02             	add    $0x2,%eax
801022fd:	50                   	push   %eax
801022fe:	ff 75 0c             	pushl  0xc(%ebp)
80102301:	e8 73 ff ff ff       	call   80102279 <namecmp>
80102306:	83 c4 10             	add    $0x10,%esp
80102309:	85 c0                	test   %eax,%eax
8010230b:	75 2f                	jne    8010233c <dirlookup+0xa4>
      // entry matches path element
      if(poff)
8010230d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102311:	74 08                	je     8010231b <dirlookup+0x83>
        *poff = off;
80102313:	8b 45 10             	mov    0x10(%ebp),%eax
80102316:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102319:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010231b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010231f:	0f b7 c0             	movzwl %ax,%eax
80102322:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102325:	8b 45 08             	mov    0x8(%ebp),%eax
80102328:	8b 00                	mov    (%eax),%eax
8010232a:	83 ec 08             	sub    $0x8,%esp
8010232d:	ff 75 f0             	pushl  -0x10(%ebp)
80102330:	50                   	push   %eax
80102331:	e8 ba f5 ff ff       	call   801018f0 <iget>
80102336:	83 c4 10             	add    $0x10,%esp
80102339:	eb 19                	jmp    80102354 <dirlookup+0xbc>
      continue;
8010233b:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010233c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102340:	8b 45 08             	mov    0x8(%ebp),%eax
80102343:	8b 40 18             	mov    0x18(%eax),%eax
80102346:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102349:	0f 82 76 ff ff ff    	jb     801022c5 <dirlookup+0x2d>
    }
  }

  return 0;
8010234f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102354:	c9                   	leave  
80102355:	c3                   	ret    

80102356 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102356:	f3 0f 1e fb          	endbr32 
8010235a:	55                   	push   %ebp
8010235b:	89 e5                	mov    %esp,%ebp
8010235d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102360:	83 ec 04             	sub    $0x4,%esp
80102363:	6a 00                	push   $0x0
80102365:	ff 75 0c             	pushl  0xc(%ebp)
80102368:	ff 75 08             	pushl  0x8(%ebp)
8010236b:	e8 28 ff ff ff       	call   80102298 <dirlookup>
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102376:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010237a:	74 18                	je     80102394 <dirlink+0x3e>
    iput(ip);
8010237c:	83 ec 0c             	sub    $0xc,%esp
8010237f:	ff 75 f0             	pushl  -0x10(%ebp)
80102382:	e8 62 f8 ff ff       	call   80101be9 <iput>
80102387:	83 c4 10             	add    $0x10,%esp
    return -1;
8010238a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010238f:	e9 9c 00 00 00       	jmp    80102430 <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010239b:	eb 39                	jmp    801023d6 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a0:	6a 10                	push   $0x10
801023a2:	50                   	push   %eax
801023a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023a6:	50                   	push   %eax
801023a7:	ff 75 08             	pushl  0x8(%ebp)
801023aa:	e8 e7 fb ff ff       	call   80101f96 <readi>
801023af:	83 c4 10             	add    $0x10,%esp
801023b2:	83 f8 10             	cmp    $0x10,%eax
801023b5:	74 0d                	je     801023c4 <dirlink+0x6e>
      panic("dirlink read");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 21 8e 10 80       	push   $0x80108e21
801023bf:	e8 d3 e1 ff ff       	call   80100597 <panic>
    if(de.inum == 0)
801023c4:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023c8:	66 85 c0             	test   %ax,%ax
801023cb:	74 18                	je     801023e5 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d0:	83 c0 10             	add    $0x10,%eax
801023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023d6:	8b 45 08             	mov    0x8(%ebp),%eax
801023d9:	8b 50 18             	mov    0x18(%eax),%edx
801023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023df:	39 c2                	cmp    %eax,%edx
801023e1:	77 ba                	ja     8010239d <dirlink+0x47>
801023e3:	eb 01                	jmp    801023e6 <dirlink+0x90>
      break;
801023e5:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023e6:	83 ec 04             	sub    $0x4,%esp
801023e9:	6a 0e                	push   $0xe
801023eb:	ff 75 0c             	pushl  0xc(%ebp)
801023ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023f1:	83 c0 02             	add    $0x2,%eax
801023f4:	50                   	push   %eax
801023f5:	e8 e6 35 00 00       	call   801059e0 <strncpy>
801023fa:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023fd:	8b 45 10             	mov    0x10(%ebp),%eax
80102400:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102407:	6a 10                	push   $0x10
80102409:	50                   	push   %eax
8010240a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010240d:	50                   	push   %eax
8010240e:	ff 75 08             	pushl  0x8(%ebp)
80102411:	e8 d9 fc ff ff       	call   801020ef <writei>
80102416:	83 c4 10             	add    $0x10,%esp
80102419:	83 f8 10             	cmp    $0x10,%eax
8010241c:	74 0d                	je     8010242b <dirlink+0xd5>
    panic("dirlink");
8010241e:	83 ec 0c             	sub    $0xc,%esp
80102421:	68 2e 8e 10 80       	push   $0x80108e2e
80102426:	e8 6c e1 ff ff       	call   80100597 <panic>
  
  return 0;
8010242b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102430:	c9                   	leave  
80102431:	c3                   	ret    

80102432 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102432:	f3 0f 1e fb          	endbr32 
80102436:	55                   	push   %ebp
80102437:	89 e5                	mov    %esp,%ebp
80102439:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010243c:	eb 04                	jmp    80102442 <skipelem+0x10>
    path++;
8010243e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102442:	8b 45 08             	mov    0x8(%ebp),%eax
80102445:	0f b6 00             	movzbl (%eax),%eax
80102448:	3c 2f                	cmp    $0x2f,%al
8010244a:	74 f2                	je     8010243e <skipelem+0xc>
  if(*path == 0)
8010244c:	8b 45 08             	mov    0x8(%ebp),%eax
8010244f:	0f b6 00             	movzbl (%eax),%eax
80102452:	84 c0                	test   %al,%al
80102454:	75 07                	jne    8010245d <skipelem+0x2b>
    return 0;
80102456:	b8 00 00 00 00       	mov    $0x0,%eax
8010245b:	eb 77                	jmp    801024d4 <skipelem+0xa2>
  s = path;
8010245d:	8b 45 08             	mov    0x8(%ebp),%eax
80102460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102463:	eb 04                	jmp    80102469 <skipelem+0x37>
    path++;
80102465:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
8010246c:	0f b6 00             	movzbl (%eax),%eax
8010246f:	3c 2f                	cmp    $0x2f,%al
80102471:	74 0a                	je     8010247d <skipelem+0x4b>
80102473:	8b 45 08             	mov    0x8(%ebp),%eax
80102476:	0f b6 00             	movzbl (%eax),%eax
80102479:	84 c0                	test   %al,%al
8010247b:	75 e8                	jne    80102465 <skipelem+0x33>
  len = path - s;
8010247d:	8b 45 08             	mov    0x8(%ebp),%eax
80102480:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102483:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102486:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010248a:	7e 15                	jle    801024a1 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010248c:	83 ec 04             	sub    $0x4,%esp
8010248f:	6a 0e                	push   $0xe
80102491:	ff 75 f4             	pushl  -0xc(%ebp)
80102494:	ff 75 0c             	pushl  0xc(%ebp)
80102497:	e8 4c 34 00 00       	call   801058e8 <memmove>
8010249c:	83 c4 10             	add    $0x10,%esp
8010249f:	eb 26                	jmp    801024c7 <skipelem+0x95>
  else {
    memmove(name, s, len);
801024a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	50                   	push   %eax
801024a8:	ff 75 f4             	pushl  -0xc(%ebp)
801024ab:	ff 75 0c             	pushl  0xc(%ebp)
801024ae:	e8 35 34 00 00       	call   801058e8 <memmove>
801024b3:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801024b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801024b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024bc:	01 d0                	add    %edx,%eax
801024be:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801024c1:	eb 04                	jmp    801024c7 <skipelem+0x95>
    path++;
801024c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801024c7:	8b 45 08             	mov    0x8(%ebp),%eax
801024ca:	0f b6 00             	movzbl (%eax),%eax
801024cd:	3c 2f                	cmp    $0x2f,%al
801024cf:	74 f2                	je     801024c3 <skipelem+0x91>
  return path;
801024d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024d4:	c9                   	leave  
801024d5:	c3                   	ret    

801024d6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024d6:	f3 0f 1e fb          	endbr32 
801024da:	55                   	push   %ebp
801024db:	89 e5                	mov    %esp,%ebp
801024dd:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024e0:	8b 45 08             	mov    0x8(%ebp),%eax
801024e3:	0f b6 00             	movzbl (%eax),%eax
801024e6:	3c 2f                	cmp    $0x2f,%al
801024e8:	75 17                	jne    80102501 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801024ea:	83 ec 08             	sub    $0x8,%esp
801024ed:	6a 01                	push   $0x1
801024ef:	6a 01                	push   $0x1
801024f1:	e8 fa f3 ff ff       	call   801018f0 <iget>
801024f6:	83 c4 10             	add    $0x10,%esp
801024f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024fc:	e9 bb 00 00 00       	jmp    801025bc <namex+0xe6>
  else
    ip = idup(proc->cwd);
80102501:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102507:	8b 40 68             	mov    0x68(%eax),%eax
8010250a:	83 ec 0c             	sub    $0xc,%esp
8010250d:	50                   	push   %eax
8010250e:	e8 c0 f4 ff ff       	call   801019d3 <idup>
80102513:	83 c4 10             	add    $0x10,%esp
80102516:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102519:	e9 9e 00 00 00       	jmp    801025bc <namex+0xe6>
    ilock(ip);
8010251e:	83 ec 0c             	sub    $0xc,%esp
80102521:	ff 75 f4             	pushl  -0xc(%ebp)
80102524:	e8 e8 f4 ff ff       	call   80101a11 <ilock>
80102529:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010252f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102533:	66 83 f8 01          	cmp    $0x1,%ax
80102537:	74 18                	je     80102551 <namex+0x7b>
      iunlockput(ip);
80102539:	83 ec 0c             	sub    $0xc,%esp
8010253c:	ff 75 f4             	pushl  -0xc(%ebp)
8010253f:	e8 99 f7 ff ff       	call   80101cdd <iunlockput>
80102544:	83 c4 10             	add    $0x10,%esp
      return 0;
80102547:	b8 00 00 00 00       	mov    $0x0,%eax
8010254c:	e9 a7 00 00 00       	jmp    801025f8 <namex+0x122>
    }
    if(nameiparent && *path == '\0'){
80102551:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102555:	74 20                	je     80102577 <namex+0xa1>
80102557:	8b 45 08             	mov    0x8(%ebp),%eax
8010255a:	0f b6 00             	movzbl (%eax),%eax
8010255d:	84 c0                	test   %al,%al
8010255f:	75 16                	jne    80102577 <namex+0xa1>
      // Stop one level early.
      iunlock(ip);
80102561:	83 ec 0c             	sub    $0xc,%esp
80102564:	ff 75 f4             	pushl  -0xc(%ebp)
80102567:	e8 07 f6 ff ff       	call   80101b73 <iunlock>
8010256c:	83 c4 10             	add    $0x10,%esp
      return ip;
8010256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102572:	e9 81 00 00 00       	jmp    801025f8 <namex+0x122>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102577:	83 ec 04             	sub    $0x4,%esp
8010257a:	6a 00                	push   $0x0
8010257c:	ff 75 10             	pushl  0x10(%ebp)
8010257f:	ff 75 f4             	pushl  -0xc(%ebp)
80102582:	e8 11 fd ff ff       	call   80102298 <dirlookup>
80102587:	83 c4 10             	add    $0x10,%esp
8010258a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010258d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102591:	75 15                	jne    801025a8 <namex+0xd2>
      iunlockput(ip);
80102593:	83 ec 0c             	sub    $0xc,%esp
80102596:	ff 75 f4             	pushl  -0xc(%ebp)
80102599:	e8 3f f7 ff ff       	call   80101cdd <iunlockput>
8010259e:	83 c4 10             	add    $0x10,%esp
      return 0;
801025a1:	b8 00 00 00 00       	mov    $0x0,%eax
801025a6:	eb 50                	jmp    801025f8 <namex+0x122>
    }
    iunlockput(ip);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	ff 75 f4             	pushl  -0xc(%ebp)
801025ae:	e8 2a f7 ff ff       	call   80101cdd <iunlockput>
801025b3:	83 c4 10             	add    $0x10,%esp
    ip = next;
801025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801025bc:	83 ec 08             	sub    $0x8,%esp
801025bf:	ff 75 10             	pushl  0x10(%ebp)
801025c2:	ff 75 08             	pushl  0x8(%ebp)
801025c5:	e8 68 fe ff ff       	call   80102432 <skipelem>
801025ca:	83 c4 10             	add    $0x10,%esp
801025cd:	89 45 08             	mov    %eax,0x8(%ebp)
801025d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d4:	0f 85 44 ff ff ff    	jne    8010251e <namex+0x48>
  }
  if(nameiparent){
801025da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025de:	74 15                	je     801025f5 <namex+0x11f>
    iput(ip);
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	ff 75 f4             	pushl  -0xc(%ebp)
801025e6:	e8 fe f5 ff ff       	call   80101be9 <iput>
801025eb:	83 c4 10             	add    $0x10,%esp
    return 0;
801025ee:	b8 00 00 00 00       	mov    $0x0,%eax
801025f3:	eb 03                	jmp    801025f8 <namex+0x122>
  }
  return ip;
801025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025f8:	c9                   	leave  
801025f9:	c3                   	ret    

801025fa <namei>:

struct inode*
namei(char *path)
{
801025fa:	f3 0f 1e fb          	endbr32 
801025fe:	55                   	push   %ebp
801025ff:	89 e5                	mov    %esp,%ebp
80102601:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102604:	83 ec 04             	sub    $0x4,%esp
80102607:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010260a:	50                   	push   %eax
8010260b:	6a 00                	push   $0x0
8010260d:	ff 75 08             	pushl  0x8(%ebp)
80102610:	e8 c1 fe ff ff       	call   801024d6 <namex>
80102615:	83 c4 10             	add    $0x10,%esp
}
80102618:	c9                   	leave  
80102619:	c3                   	ret    

8010261a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010261a:	f3 0f 1e fb          	endbr32 
8010261e:	55                   	push   %ebp
8010261f:	89 e5                	mov    %esp,%ebp
80102621:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102624:	83 ec 04             	sub    $0x4,%esp
80102627:	ff 75 0c             	pushl  0xc(%ebp)
8010262a:	6a 01                	push   $0x1
8010262c:	ff 75 08             	pushl  0x8(%ebp)
8010262f:	e8 a2 fe ff ff       	call   801024d6 <namex>
80102634:	83 c4 10             	add    $0x10,%esp
}
80102637:	c9                   	leave  
80102638:	c3                   	ret    

80102639 <inb>:
{
80102639:	55                   	push   %ebp
8010263a:	89 e5                	mov    %esp,%ebp
8010263c:	83 ec 14             	sub    $0x14,%esp
8010263f:	8b 45 08             	mov    0x8(%ebp),%eax
80102642:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010264a:	89 c2                	mov    %eax,%edx
8010264c:	ec                   	in     (%dx),%al
8010264d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102650:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102654:	c9                   	leave  
80102655:	c3                   	ret    

80102656 <insl>:
{
80102656:	55                   	push   %ebp
80102657:	89 e5                	mov    %esp,%ebp
80102659:	57                   	push   %edi
8010265a:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010265b:	8b 55 08             	mov    0x8(%ebp),%edx
8010265e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102661:	8b 45 10             	mov    0x10(%ebp),%eax
80102664:	89 cb                	mov    %ecx,%ebx
80102666:	89 df                	mov    %ebx,%edi
80102668:	89 c1                	mov    %eax,%ecx
8010266a:	fc                   	cld    
8010266b:	f3 6d                	rep insl (%dx),%es:(%edi)
8010266d:	89 c8                	mov    %ecx,%eax
8010266f:	89 fb                	mov    %edi,%ebx
80102671:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102674:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102677:	90                   	nop
80102678:	5b                   	pop    %ebx
80102679:	5f                   	pop    %edi
8010267a:	5d                   	pop    %ebp
8010267b:	c3                   	ret    

8010267c <outb>:
{
8010267c:	55                   	push   %ebp
8010267d:	89 e5                	mov    %esp,%ebp
8010267f:	83 ec 08             	sub    $0x8,%esp
80102682:	8b 45 08             	mov    0x8(%ebp),%eax
80102685:	8b 55 0c             	mov    0xc(%ebp),%edx
80102688:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010268c:	89 d0                	mov    %edx,%eax
8010268e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102691:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102695:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102699:	ee                   	out    %al,(%dx)
}
8010269a:	90                   	nop
8010269b:	c9                   	leave  
8010269c:	c3                   	ret    

8010269d <outsl>:
{
8010269d:	55                   	push   %ebp
8010269e:	89 e5                	mov    %esp,%ebp
801026a0:	56                   	push   %esi
801026a1:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801026a2:	8b 55 08             	mov    0x8(%ebp),%edx
801026a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026a8:	8b 45 10             	mov    0x10(%ebp),%eax
801026ab:	89 cb                	mov    %ecx,%ebx
801026ad:	89 de                	mov    %ebx,%esi
801026af:	89 c1                	mov    %eax,%ecx
801026b1:	fc                   	cld    
801026b2:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801026b4:	89 c8                	mov    %ecx,%eax
801026b6:	89 f3                	mov    %esi,%ebx
801026b8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026bb:	89 45 10             	mov    %eax,0x10(%ebp)
}
801026be:	90                   	nop
801026bf:	5b                   	pop    %ebx
801026c0:	5e                   	pop    %esi
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret    

801026c3 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801026c3:	f3 0f 1e fb          	endbr32 
801026c7:	55                   	push   %ebp
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801026cd:	90                   	nop
801026ce:	68 f7 01 00 00       	push   $0x1f7
801026d3:	e8 61 ff ff ff       	call   80102639 <inb>
801026d8:	83 c4 04             	add    $0x4,%esp
801026db:	0f b6 c0             	movzbl %al,%eax
801026de:	89 45 fc             	mov    %eax,-0x4(%ebp)
801026e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026e4:	25 c0 00 00 00       	and    $0xc0,%eax
801026e9:	83 f8 40             	cmp    $0x40,%eax
801026ec:	75 e0                	jne    801026ce <idewait+0xb>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026f2:	74 11                	je     80102705 <idewait+0x42>
801026f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026f7:	83 e0 21             	and    $0x21,%eax
801026fa:	85 c0                	test   %eax,%eax
801026fc:	74 07                	je     80102705 <idewait+0x42>
    return -1;
801026fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102703:	eb 05                	jmp    8010270a <idewait+0x47>
  return 0;
80102705:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010270a:	c9                   	leave  
8010270b:	c3                   	ret    

8010270c <ideinit>:

void
ideinit(void)
{
8010270c:	f3 0f 1e fb          	endbr32 
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102716:	83 ec 08             	sub    $0x8,%esp
80102719:	68 36 8e 10 80       	push   $0x80108e36
8010271e:	68 00 c6 10 80       	push   $0x8010c600
80102723:	e8 57 2e 00 00       	call   8010557f <initlock>
80102728:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
8010272b:	83 ec 0c             	sub    $0xc,%esp
8010272e:	6a 0e                	push   $0xe
80102730:	e8 a4 19 00 00       	call   801040d9 <picenable>
80102735:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102738:	a1 40 39 11 80       	mov    0x80113940,%eax
8010273d:	83 e8 01             	sub    $0x1,%eax
80102740:	83 ec 08             	sub    $0x8,%esp
80102743:	50                   	push   %eax
80102744:	6a 0e                	push   $0xe
80102746:	e8 8b 04 00 00       	call   80102bd6 <ioapicenable>
8010274b:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010274e:	83 ec 0c             	sub    $0xc,%esp
80102751:	6a 00                	push   $0x0
80102753:	e8 6b ff ff ff       	call   801026c3 <idewait>
80102758:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010275b:	83 ec 08             	sub    $0x8,%esp
8010275e:	68 f0 00 00 00       	push   $0xf0
80102763:	68 f6 01 00 00       	push   $0x1f6
80102768:	e8 0f ff ff ff       	call   8010267c <outb>
8010276d:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102777:	eb 24                	jmp    8010279d <ideinit+0x91>
    if(inb(0x1f7) != 0){
80102779:	83 ec 0c             	sub    $0xc,%esp
8010277c:	68 f7 01 00 00       	push   $0x1f7
80102781:	e8 b3 fe ff ff       	call   80102639 <inb>
80102786:	83 c4 10             	add    $0x10,%esp
80102789:	84 c0                	test   %al,%al
8010278b:	74 0c                	je     80102799 <ideinit+0x8d>
      havedisk1 = 1;
8010278d:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
80102794:	00 00 00 
      break;
80102797:	eb 0d                	jmp    801027a6 <ideinit+0x9a>
  for(i=0; i<1000; i++){
80102799:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010279d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801027a4:	7e d3                	jle    80102779 <ideinit+0x6d>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801027a6:	83 ec 08             	sub    $0x8,%esp
801027a9:	68 e0 00 00 00       	push   $0xe0
801027ae:	68 f6 01 00 00       	push   $0x1f6
801027b3:	e8 c4 fe ff ff       	call   8010267c <outb>
801027b8:	83 c4 10             	add    $0x10,%esp
}
801027bb:	90                   	nop
801027bc:	c9                   	leave  
801027bd:	c3                   	ret    

801027be <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027be:	f3 0f 1e fb          	endbr32 
801027c2:	55                   	push   %ebp
801027c3:	89 e5                	mov    %esp,%ebp
801027c5:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801027c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801027cc:	75 0d                	jne    801027db <idestart+0x1d>
    panic("idestart");
801027ce:	83 ec 0c             	sub    $0xc,%esp
801027d1:	68 3a 8e 10 80       	push   $0x80108e3a
801027d6:	e8 bc dd ff ff       	call   80100597 <panic>
  if(b->blockno >= FSSIZE)
801027db:	8b 45 08             	mov    0x8(%ebp),%eax
801027de:	8b 40 08             	mov    0x8(%eax),%eax
801027e1:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801027e6:	76 0d                	jbe    801027f5 <idestart+0x37>
    panic("incorrect blockno");
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	68 43 8e 10 80       	push   $0x80108e43
801027f0:	e8 a2 dd ff ff       	call   80100597 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027f5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027fc:	8b 45 08             	mov    0x8(%ebp),%eax
801027ff:	8b 50 08             	mov    0x8(%eax),%edx
80102802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102805:	0f af c2             	imul   %edx,%eax
80102808:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010280b:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010280f:	7e 0d                	jle    8010281e <idestart+0x60>
80102811:	83 ec 0c             	sub    $0xc,%esp
80102814:	68 3a 8e 10 80       	push   $0x80108e3a
80102819:	e8 79 dd ff ff       	call   80100597 <panic>
  
  idewait(0);
8010281e:	83 ec 0c             	sub    $0xc,%esp
80102821:	6a 00                	push   $0x0
80102823:	e8 9b fe ff ff       	call   801026c3 <idewait>
80102828:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010282b:	83 ec 08             	sub    $0x8,%esp
8010282e:	6a 00                	push   $0x0
80102830:	68 f6 03 00 00       	push   $0x3f6
80102835:	e8 42 fe ff ff       	call   8010267c <outb>
8010283a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102840:	0f b6 c0             	movzbl %al,%eax
80102843:	83 ec 08             	sub    $0x8,%esp
80102846:	50                   	push   %eax
80102847:	68 f2 01 00 00       	push   $0x1f2
8010284c:	e8 2b fe ff ff       	call   8010267c <outb>
80102851:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102854:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102857:	0f b6 c0             	movzbl %al,%eax
8010285a:	83 ec 08             	sub    $0x8,%esp
8010285d:	50                   	push   %eax
8010285e:	68 f3 01 00 00       	push   $0x1f3
80102863:	e8 14 fe ff ff       	call   8010267c <outb>
80102868:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
8010286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010286e:	c1 f8 08             	sar    $0x8,%eax
80102871:	0f b6 c0             	movzbl %al,%eax
80102874:	83 ec 08             	sub    $0x8,%esp
80102877:	50                   	push   %eax
80102878:	68 f4 01 00 00       	push   $0x1f4
8010287d:	e8 fa fd ff ff       	call   8010267c <outb>
80102882:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102885:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102888:	c1 f8 10             	sar    $0x10,%eax
8010288b:	0f b6 c0             	movzbl %al,%eax
8010288e:	83 ec 08             	sub    $0x8,%esp
80102891:	50                   	push   %eax
80102892:	68 f5 01 00 00       	push   $0x1f5
80102897:	e8 e0 fd ff ff       	call   8010267c <outb>
8010289c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010289f:	8b 45 08             	mov    0x8(%ebp),%eax
801028a2:	8b 40 04             	mov    0x4(%eax),%eax
801028a5:	c1 e0 04             	shl    $0x4,%eax
801028a8:	83 e0 10             	and    $0x10,%eax
801028ab:	89 c2                	mov    %eax,%edx
801028ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028b0:	c1 f8 18             	sar    $0x18,%eax
801028b3:	83 e0 0f             	and    $0xf,%eax
801028b6:	09 d0                	or     %edx,%eax
801028b8:	83 c8 e0             	or     $0xffffffe0,%eax
801028bb:	0f b6 c0             	movzbl %al,%eax
801028be:	83 ec 08             	sub    $0x8,%esp
801028c1:	50                   	push   %eax
801028c2:	68 f6 01 00 00       	push   $0x1f6
801028c7:	e8 b0 fd ff ff       	call   8010267c <outb>
801028cc:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801028cf:	8b 45 08             	mov    0x8(%ebp),%eax
801028d2:	8b 00                	mov    (%eax),%eax
801028d4:	83 e0 04             	and    $0x4,%eax
801028d7:	85 c0                	test   %eax,%eax
801028d9:	74 30                	je     8010290b <idestart+0x14d>
    outb(0x1f7, IDE_CMD_WRITE);
801028db:	83 ec 08             	sub    $0x8,%esp
801028de:	6a 30                	push   $0x30
801028e0:	68 f7 01 00 00       	push   $0x1f7
801028e5:	e8 92 fd ff ff       	call   8010267c <outb>
801028ea:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028ed:	8b 45 08             	mov    0x8(%ebp),%eax
801028f0:	83 c0 18             	add    $0x18,%eax
801028f3:	83 ec 04             	sub    $0x4,%esp
801028f6:	68 80 00 00 00       	push   $0x80
801028fb:	50                   	push   %eax
801028fc:	68 f0 01 00 00       	push   $0x1f0
80102901:	e8 97 fd ff ff       	call   8010269d <outsl>
80102906:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102909:	eb 12                	jmp    8010291d <idestart+0x15f>
    outb(0x1f7, IDE_CMD_READ);
8010290b:	83 ec 08             	sub    $0x8,%esp
8010290e:	6a 20                	push   $0x20
80102910:	68 f7 01 00 00       	push   $0x1f7
80102915:	e8 62 fd ff ff       	call   8010267c <outb>
8010291a:	83 c4 10             	add    $0x10,%esp
}
8010291d:	90                   	nop
8010291e:	c9                   	leave  
8010291f:	c3                   	ret    

80102920 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
80102925:	89 e5                	mov    %esp,%ebp
80102927:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010292a:	83 ec 0c             	sub    $0xc,%esp
8010292d:	68 00 c6 10 80       	push   $0x8010c600
80102932:	e8 6e 2c 00 00       	call   801055a5 <acquire>
80102937:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
8010293a:	a1 34 c6 10 80       	mov    0x8010c634,%eax
8010293f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102946:	75 15                	jne    8010295d <ideintr+0x3d>
    release(&idelock);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	68 00 c6 10 80       	push   $0x8010c600
80102950:	e8 bb 2c 00 00       	call   80105610 <release>
80102955:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102958:	e9 9a 00 00 00       	jmp    801029f7 <ideintr+0xd7>
  }
  idequeue = b->qnext;
8010295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102960:	8b 40 14             	mov    0x14(%eax),%eax
80102963:	a3 34 c6 10 80       	mov    %eax,0x8010c634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296b:	8b 00                	mov    (%eax),%eax
8010296d:	83 e0 04             	and    $0x4,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	75 2d                	jne    801029a1 <ideintr+0x81>
80102974:	83 ec 0c             	sub    $0xc,%esp
80102977:	6a 01                	push   $0x1
80102979:	e8 45 fd ff ff       	call   801026c3 <idewait>
8010297e:	83 c4 10             	add    $0x10,%esp
80102981:	85 c0                	test   %eax,%eax
80102983:	78 1c                	js     801029a1 <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE/4);
80102985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102988:	83 c0 18             	add    $0x18,%eax
8010298b:	83 ec 04             	sub    $0x4,%esp
8010298e:	68 80 00 00 00       	push   $0x80
80102993:	50                   	push   %eax
80102994:	68 f0 01 00 00       	push   $0x1f0
80102999:	e8 b8 fc ff ff       	call   80102656 <insl>
8010299e:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a4:	8b 00                	mov    (%eax),%eax
801029a6:	83 c8 02             	or     $0x2,%eax
801029a9:	89 c2                	mov    %eax,%edx
801029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ae:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b3:	8b 00                	mov    (%eax),%eax
801029b5:	83 e0 fb             	and    $0xfffffffb,%eax
801029b8:	89 c2                	mov    %eax,%edx
801029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029bd:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801029bf:	83 ec 0c             	sub    $0xc,%esp
801029c2:	ff 75 f4             	pushl  -0xc(%ebp)
801029c5:	e8 2f 27 00 00       	call   801050f9 <wakeup>
801029ca:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801029cd:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801029d2:	85 c0                	test   %eax,%eax
801029d4:	74 11                	je     801029e7 <ideintr+0xc7>
    idestart(idequeue);
801029d6:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801029db:	83 ec 0c             	sub    $0xc,%esp
801029de:	50                   	push   %eax
801029df:	e8 da fd ff ff       	call   801027be <idestart>
801029e4:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029e7:	83 ec 0c             	sub    $0xc,%esp
801029ea:	68 00 c6 10 80       	push   $0x8010c600
801029ef:	e8 1c 2c 00 00       	call   80105610 <release>
801029f4:	83 c4 10             	add    $0x10,%esp
}
801029f7:	c9                   	leave  
801029f8:	c3                   	ret    

801029f9 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029f9:	f3 0f 1e fb          	endbr32 
801029fd:	55                   	push   %ebp
801029fe:	89 e5                	mov    %esp,%ebp
80102a00:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102a03:	8b 45 08             	mov    0x8(%ebp),%eax
80102a06:	8b 00                	mov    (%eax),%eax
80102a08:	83 e0 01             	and    $0x1,%eax
80102a0b:	85 c0                	test   %eax,%eax
80102a0d:	75 0d                	jne    80102a1c <iderw+0x23>
    panic("iderw: buf not busy");
80102a0f:	83 ec 0c             	sub    $0xc,%esp
80102a12:	68 55 8e 10 80       	push   $0x80108e55
80102a17:	e8 7b db ff ff       	call   80100597 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1f:	8b 00                	mov    (%eax),%eax
80102a21:	83 e0 06             	and    $0x6,%eax
80102a24:	83 f8 02             	cmp    $0x2,%eax
80102a27:	75 0d                	jne    80102a36 <iderw+0x3d>
    panic("iderw: nothing to do");
80102a29:	83 ec 0c             	sub    $0xc,%esp
80102a2c:	68 69 8e 10 80       	push   $0x80108e69
80102a31:	e8 61 db ff ff       	call   80100597 <panic>
  if(b->dev != 0 && !havedisk1)
80102a36:	8b 45 08             	mov    0x8(%ebp),%eax
80102a39:	8b 40 04             	mov    0x4(%eax),%eax
80102a3c:	85 c0                	test   %eax,%eax
80102a3e:	74 16                	je     80102a56 <iderw+0x5d>
80102a40:	a1 38 c6 10 80       	mov    0x8010c638,%eax
80102a45:	85 c0                	test   %eax,%eax
80102a47:	75 0d                	jne    80102a56 <iderw+0x5d>
    panic("iderw: ide disk 1 not present");
80102a49:	83 ec 0c             	sub    $0xc,%esp
80102a4c:	68 7e 8e 10 80       	push   $0x80108e7e
80102a51:	e8 41 db ff ff       	call   80100597 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	68 00 c6 10 80       	push   $0x8010c600
80102a5e:	e8 42 2b 00 00       	call   801055a5 <acquire>
80102a63:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a66:	8b 45 08             	mov    0x8(%ebp),%eax
80102a69:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a70:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
80102a77:	eb 0b                	jmp    80102a84 <iderw+0x8b>
80102a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7c:	8b 00                	mov    (%eax),%eax
80102a7e:	83 c0 14             	add    $0x14,%eax
80102a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a87:	8b 00                	mov    (%eax),%eax
80102a89:	85 c0                	test   %eax,%eax
80102a8b:	75 ec                	jne    80102a79 <iderw+0x80>
    ;
  *pp = b;
80102a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a90:	8b 55 08             	mov    0x8(%ebp),%edx
80102a93:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a95:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102a9a:	39 45 08             	cmp    %eax,0x8(%ebp)
80102a9d:	75 23                	jne    80102ac2 <iderw+0xc9>
    idestart(b);
80102a9f:	83 ec 0c             	sub    $0xc,%esp
80102aa2:	ff 75 08             	pushl  0x8(%ebp)
80102aa5:	e8 14 fd ff ff       	call   801027be <idestart>
80102aaa:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102aad:	eb 13                	jmp    80102ac2 <iderw+0xc9>
    sleep(b, &idelock);
80102aaf:	83 ec 08             	sub    $0x8,%esp
80102ab2:	68 00 c6 10 80       	push   $0x8010c600
80102ab7:	ff 75 08             	pushl  0x8(%ebp)
80102aba:	e8 43 25 00 00       	call   80105002 <sleep>
80102abf:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac5:	8b 00                	mov    (%eax),%eax
80102ac7:	83 e0 06             	and    $0x6,%eax
80102aca:	83 f8 02             	cmp    $0x2,%eax
80102acd:	75 e0                	jne    80102aaf <iderw+0xb6>
  }

  release(&idelock);
80102acf:	83 ec 0c             	sub    $0xc,%esp
80102ad2:	68 00 c6 10 80       	push   $0x8010c600
80102ad7:	e8 34 2b 00 00       	call   80105610 <release>
80102adc:	83 c4 10             	add    $0x10,%esp
}
80102adf:	90                   	nop
80102ae0:	c9                   	leave  
80102ae1:	c3                   	ret    

80102ae2 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102ae2:	f3 0f 1e fb          	endbr32 
80102ae6:	55                   	push   %ebp
80102ae7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ae9:	a1 14 32 11 80       	mov    0x80113214,%eax
80102aee:	8b 55 08             	mov    0x8(%ebp),%edx
80102af1:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102af3:	a1 14 32 11 80       	mov    0x80113214,%eax
80102af8:	8b 40 10             	mov    0x10(%eax),%eax
}
80102afb:	5d                   	pop    %ebp
80102afc:	c3                   	ret    

80102afd <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102afd:	f3 0f 1e fb          	endbr32 
80102b01:	55                   	push   %ebp
80102b02:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b04:	a1 14 32 11 80       	mov    0x80113214,%eax
80102b09:	8b 55 08             	mov    0x8(%ebp),%edx
80102b0c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102b0e:	a1 14 32 11 80       	mov    0x80113214,%eax
80102b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80102b16:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b19:	90                   	nop
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    

80102b1c <ioapicinit>:

void
ioapicinit(void)
{
80102b1c:	f3 0f 1e fb          	endbr32 
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102b26:	a1 44 33 11 80       	mov    0x80113344,%eax
80102b2b:	85 c0                	test   %eax,%eax
80102b2d:	0f 84 a0 00 00 00    	je     80102bd3 <ioapicinit+0xb7>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102b33:	c7 05 14 32 11 80 00 	movl   $0xfec00000,0x80113214
80102b3a:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102b3d:	6a 01                	push   $0x1
80102b3f:	e8 9e ff ff ff       	call   80102ae2 <ioapicread>
80102b44:	83 c4 04             	add    $0x4,%esp
80102b47:	c1 e8 10             	shr    $0x10,%eax
80102b4a:	25 ff 00 00 00       	and    $0xff,%eax
80102b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102b52:	6a 00                	push   $0x0
80102b54:	e8 89 ff ff ff       	call   80102ae2 <ioapicread>
80102b59:	83 c4 04             	add    $0x4,%esp
80102b5c:	c1 e8 18             	shr    $0x18,%eax
80102b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b62:	0f b6 05 40 33 11 80 	movzbl 0x80113340,%eax
80102b69:	0f b6 c0             	movzbl %al,%eax
80102b6c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102b6f:	74 10                	je     80102b81 <ioapicinit+0x65>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	68 9c 8e 10 80       	push   $0x80108e9c
80102b79:	e8 60 d8 ff ff       	call   801003de <cprintf>
80102b7e:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b88:	eb 3f                	jmp    80102bc9 <ioapicinit+0xad>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8d:	83 c0 20             	add    $0x20,%eax
80102b90:	0d 00 00 01 00       	or     $0x10000,%eax
80102b95:	89 c2                	mov    %eax,%edx
80102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9a:	83 c0 08             	add    $0x8,%eax
80102b9d:	01 c0                	add    %eax,%eax
80102b9f:	83 ec 08             	sub    $0x8,%esp
80102ba2:	52                   	push   %edx
80102ba3:	50                   	push   %eax
80102ba4:	e8 54 ff ff ff       	call   80102afd <ioapicwrite>
80102ba9:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102baf:	83 c0 08             	add    $0x8,%eax
80102bb2:	01 c0                	add    %eax,%eax
80102bb4:	83 c0 01             	add    $0x1,%eax
80102bb7:	83 ec 08             	sub    $0x8,%esp
80102bba:	6a 00                	push   $0x0
80102bbc:	50                   	push   %eax
80102bbd:	e8 3b ff ff ff       	call   80102afd <ioapicwrite>
80102bc2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102bc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bcc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102bcf:	7e b9                	jle    80102b8a <ioapicinit+0x6e>
80102bd1:	eb 01                	jmp    80102bd4 <ioapicinit+0xb8>
    return;
80102bd3:	90                   	nop
  }
}
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    

80102bd6 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102bd6:	f3 0f 1e fb          	endbr32 
80102bda:	55                   	push   %ebp
80102bdb:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102bdd:	a1 44 33 11 80       	mov    0x80113344,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	74 39                	je     80102c1f <ioapicenable+0x49>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102be6:	8b 45 08             	mov    0x8(%ebp),%eax
80102be9:	83 c0 20             	add    $0x20,%eax
80102bec:	89 c2                	mov    %eax,%edx
80102bee:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf1:	83 c0 08             	add    $0x8,%eax
80102bf4:	01 c0                	add    %eax,%eax
80102bf6:	52                   	push   %edx
80102bf7:	50                   	push   %eax
80102bf8:	e8 00 ff ff ff       	call   80102afd <ioapicwrite>
80102bfd:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c00:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c03:	c1 e0 18             	shl    $0x18,%eax
80102c06:	89 c2                	mov    %eax,%edx
80102c08:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0b:	83 c0 08             	add    $0x8,%eax
80102c0e:	01 c0                	add    %eax,%eax
80102c10:	83 c0 01             	add    $0x1,%eax
80102c13:	52                   	push   %edx
80102c14:	50                   	push   %eax
80102c15:	e8 e3 fe ff ff       	call   80102afd <ioapicwrite>
80102c1a:	83 c4 08             	add    $0x8,%esp
80102c1d:	eb 01                	jmp    80102c20 <ioapicenable+0x4a>
    return;
80102c1f:	90                   	nop
}
80102c20:	c9                   	leave  
80102c21:	c3                   	ret    

80102c22 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102c22:	55                   	push   %ebp
80102c23:	89 e5                	mov    %esp,%ebp
80102c25:	8b 45 08             	mov    0x8(%ebp),%eax
80102c28:	05 00 00 00 80       	add    $0x80000000,%eax
80102c2d:	5d                   	pop    %ebp
80102c2e:	c3                   	ret    

80102c2f <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c2f:	f3 0f 1e fb          	endbr32 
80102c33:	55                   	push   %ebp
80102c34:	89 e5                	mov    %esp,%ebp
80102c36:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102c39:	83 ec 08             	sub    $0x8,%esp
80102c3c:	68 ce 8e 10 80       	push   $0x80108ece
80102c41:	68 20 32 11 80       	push   $0x80113220
80102c46:	e8 34 29 00 00       	call   8010557f <initlock>
80102c4b:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c4e:	c7 05 54 32 11 80 00 	movl   $0x0,0x80113254
80102c55:	00 00 00 
  freerange(vstart, vend);
80102c58:	83 ec 08             	sub    $0x8,%esp
80102c5b:	ff 75 0c             	pushl  0xc(%ebp)
80102c5e:	ff 75 08             	pushl  0x8(%ebp)
80102c61:	e8 2e 00 00 00       	call   80102c94 <freerange>
80102c66:	83 c4 10             	add    $0x10,%esp
}
80102c69:	90                   	nop
80102c6a:	c9                   	leave  
80102c6b:	c3                   	ret    

80102c6c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c6c:	f3 0f 1e fb          	endbr32 
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c76:	83 ec 08             	sub    $0x8,%esp
80102c79:	ff 75 0c             	pushl  0xc(%ebp)
80102c7c:	ff 75 08             	pushl  0x8(%ebp)
80102c7f:	e8 10 00 00 00       	call   80102c94 <freerange>
80102c84:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c87:	c7 05 54 32 11 80 01 	movl   $0x1,0x80113254
80102c8e:	00 00 00 
}
80102c91:	90                   	nop
80102c92:	c9                   	leave  
80102c93:	c3                   	ret    

80102c94 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c94:	f3 0f 1e fb          	endbr32 
80102c98:	55                   	push   %ebp
80102c99:	89 e5                	mov    %esp,%ebp
80102c9b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca1:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ca6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cae:	eb 15                	jmp    80102cc5 <freerange+0x31>
    kfree(p);
80102cb0:	83 ec 0c             	sub    $0xc,%esp
80102cb3:	ff 75 f4             	pushl  -0xc(%ebp)
80102cb6:	e8 1b 00 00 00       	call   80102cd6 <kfree>
80102cbb:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cbe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc8:	05 00 10 00 00       	add    $0x1000,%eax
80102ccd:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102cd0:	73 de                	jae    80102cb0 <freerange+0x1c>
}
80102cd2:	90                   	nop
80102cd3:	90                   	nop
80102cd4:	c9                   	leave  
80102cd5:	c3                   	ret    

80102cd6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102cd6:	f3 0f 1e fb          	endbr32 
80102cda:	55                   	push   %ebp
80102cdb:	89 e5                	mov    %esp,%ebp
80102cdd:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce3:	25 ff 0f 00 00       	and    $0xfff,%eax
80102ce8:	85 c0                	test   %eax,%eax
80102cea:	75 1b                	jne    80102d07 <kfree+0x31>
80102cec:	81 7d 08 3c 66 11 80 	cmpl   $0x8011663c,0x8(%ebp)
80102cf3:	72 12                	jb     80102d07 <kfree+0x31>
80102cf5:	ff 75 08             	pushl  0x8(%ebp)
80102cf8:	e8 25 ff ff ff       	call   80102c22 <v2p>
80102cfd:	83 c4 04             	add    $0x4,%esp
80102d00:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d05:	76 0d                	jbe    80102d14 <kfree+0x3e>
    panic("kfree");
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 d3 8e 10 80       	push   $0x80108ed3
80102d0f:	e8 83 d8 ff ff       	call   80100597 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d14:	83 ec 04             	sub    $0x4,%esp
80102d17:	68 00 10 00 00       	push   $0x1000
80102d1c:	6a 01                	push   $0x1
80102d1e:	ff 75 08             	pushl  0x8(%ebp)
80102d21:	e8 fb 2a 00 00       	call   80105821 <memset>
80102d26:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102d29:	a1 54 32 11 80       	mov    0x80113254,%eax
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	74 10                	je     80102d42 <kfree+0x6c>
    acquire(&kmem.lock);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	68 20 32 11 80       	push   $0x80113220
80102d3a:	e8 66 28 00 00       	call   801055a5 <acquire>
80102d3f:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102d42:	8b 45 08             	mov    0x8(%ebp),%eax
80102d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d48:	8b 15 58 32 11 80    	mov    0x80113258,%edx
80102d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d51:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d56:	a3 58 32 11 80       	mov    %eax,0x80113258
  if(kmem.use_lock)
80102d5b:	a1 54 32 11 80       	mov    0x80113254,%eax
80102d60:	85 c0                	test   %eax,%eax
80102d62:	74 10                	je     80102d74 <kfree+0x9e>
    release(&kmem.lock);
80102d64:	83 ec 0c             	sub    $0xc,%esp
80102d67:	68 20 32 11 80       	push   $0x80113220
80102d6c:	e8 9f 28 00 00       	call   80105610 <release>
80102d71:	83 c4 10             	add    $0x10,%esp
}
80102d74:	90                   	nop
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    

80102d77 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d77:	f3 0f 1e fb          	endbr32 
80102d7b:	55                   	push   %ebp
80102d7c:	89 e5                	mov    %esp,%ebp
80102d7e:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d81:	a1 54 32 11 80       	mov    0x80113254,%eax
80102d86:	85 c0                	test   %eax,%eax
80102d88:	74 10                	je     80102d9a <kalloc+0x23>
    acquire(&kmem.lock);
80102d8a:	83 ec 0c             	sub    $0xc,%esp
80102d8d:	68 20 32 11 80       	push   $0x80113220
80102d92:	e8 0e 28 00 00       	call   801055a5 <acquire>
80102d97:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d9a:	a1 58 32 11 80       	mov    0x80113258,%eax
80102d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102da6:	74 0a                	je     80102db2 <kalloc+0x3b>
    kmem.freelist = r->next;
80102da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dab:	8b 00                	mov    (%eax),%eax
80102dad:	a3 58 32 11 80       	mov    %eax,0x80113258
  if(kmem.use_lock)
80102db2:	a1 54 32 11 80       	mov    0x80113254,%eax
80102db7:	85 c0                	test   %eax,%eax
80102db9:	74 10                	je     80102dcb <kalloc+0x54>
    release(&kmem.lock);
80102dbb:	83 ec 0c             	sub    $0xc,%esp
80102dbe:	68 20 32 11 80       	push   $0x80113220
80102dc3:	e8 48 28 00 00       	call   80105610 <release>
80102dc8:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102dce:	c9                   	leave  
80102dcf:	c3                   	ret    

80102dd0 <inb>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 14             	sub    $0x14,%esp
80102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80102dd9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102de1:	89 c2                	mov    %eax,%edx
80102de3:	ec                   	in     (%dx),%al
80102de4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102de7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102deb:	c9                   	leave  
80102dec:	c3                   	ret    

80102ded <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102ded:	f3 0f 1e fb          	endbr32 
80102df1:	55                   	push   %ebp
80102df2:	89 e5                	mov    %esp,%ebp
80102df4:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102df7:	6a 64                	push   $0x64
80102df9:	e8 d2 ff ff ff       	call   80102dd0 <inb>
80102dfe:	83 c4 04             	add    $0x4,%esp
80102e01:	0f b6 c0             	movzbl %al,%eax
80102e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e0a:	83 e0 01             	and    $0x1,%eax
80102e0d:	85 c0                	test   %eax,%eax
80102e0f:	75 0a                	jne    80102e1b <kbdgetc+0x2e>
    return -1;
80102e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e16:	e9 23 01 00 00       	jmp    80102f3e <kbdgetc+0x151>
  data = inb(KBDATAP);
80102e1b:	6a 60                	push   $0x60
80102e1d:	e8 ae ff ff ff       	call   80102dd0 <inb>
80102e22:	83 c4 04             	add    $0x4,%esp
80102e25:	0f b6 c0             	movzbl %al,%eax
80102e28:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102e2b:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102e32:	75 17                	jne    80102e4b <kbdgetc+0x5e>
    shift |= E0ESC;
80102e34:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e39:	83 c8 40             	or     $0x40,%eax
80102e3c:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102e41:	b8 00 00 00 00       	mov    $0x0,%eax
80102e46:	e9 f3 00 00 00       	jmp    80102f3e <kbdgetc+0x151>
  } else if(data & 0x80){
80102e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e4e:	25 80 00 00 00       	and    $0x80,%eax
80102e53:	85 c0                	test   %eax,%eax
80102e55:	74 45                	je     80102e9c <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102e57:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e5c:	83 e0 40             	and    $0x40,%eax
80102e5f:	85 c0                	test   %eax,%eax
80102e61:	75 08                	jne    80102e6b <kbdgetc+0x7e>
80102e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e66:	83 e0 7f             	and    $0x7f,%eax
80102e69:	eb 03                	jmp    80102e6e <kbdgetc+0x81>
80102e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e74:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e79:	0f b6 00             	movzbl (%eax),%eax
80102e7c:	83 c8 40             	or     $0x40,%eax
80102e7f:	0f b6 c0             	movzbl %al,%eax
80102e82:	f7 d0                	not    %eax
80102e84:	89 c2                	mov    %eax,%edx
80102e86:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102e8b:	21 d0                	and    %edx,%eax
80102e8d:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102e92:	b8 00 00 00 00       	mov    $0x0,%eax
80102e97:	e9 a2 00 00 00       	jmp    80102f3e <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102e9c:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ea1:	83 e0 40             	and    $0x40,%eax
80102ea4:	85 c0                	test   %eax,%eax
80102ea6:	74 14                	je     80102ebc <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ea8:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102eaf:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102eb4:	83 e0 bf             	and    $0xffffffbf,%eax
80102eb7:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
80102ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ebf:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ec4:	0f b6 00             	movzbl (%eax),%eax
80102ec7:	0f b6 d0             	movzbl %al,%edx
80102eca:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ecf:	09 d0                	or     %edx,%eax
80102ed1:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80102ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ed9:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102ede:	0f b6 00             	movzbl (%eax),%eax
80102ee1:	0f b6 d0             	movzbl %al,%edx
80102ee4:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ee9:	31 d0                	xor    %edx,%eax
80102eeb:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ef0:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ef5:	83 e0 03             	and    $0x3,%eax
80102ef8:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f02:	01 d0                	add    %edx,%eax
80102f04:	0f b6 00             	movzbl (%eax),%eax
80102f07:	0f b6 c0             	movzbl %al,%eax
80102f0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f0d:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f12:	83 e0 08             	and    $0x8,%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	74 22                	je     80102f3b <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102f19:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102f1d:	76 0c                	jbe    80102f2b <kbdgetc+0x13e>
80102f1f:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102f23:	77 06                	ja     80102f2b <kbdgetc+0x13e>
      c += 'A' - 'a';
80102f25:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102f29:	eb 10                	jmp    80102f3b <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102f2b:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102f2f:	76 0a                	jbe    80102f3b <kbdgetc+0x14e>
80102f31:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102f35:	77 04                	ja     80102f3b <kbdgetc+0x14e>
      c += 'a' - 'A';
80102f37:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102f3e:	c9                   	leave  
80102f3f:	c3                   	ret    

80102f40 <kbdintr>:

void
kbdintr(void)
{
80102f40:	f3 0f 1e fb          	endbr32 
80102f44:	55                   	push   %ebp
80102f45:	89 e5                	mov    %esp,%ebp
80102f47:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 ed 2d 10 80       	push   $0x80102ded
80102f52:	e8 e7 d8 ff ff       	call   8010083e <consoleintr>
80102f57:	83 c4 10             	add    $0x10,%esp
}
80102f5a:	90                   	nop
80102f5b:	c9                   	leave  
80102f5c:	c3                   	ret    

80102f5d <inb>:
{
80102f5d:	55                   	push   %ebp
80102f5e:	89 e5                	mov    %esp,%ebp
80102f60:	83 ec 14             	sub    $0x14,%esp
80102f63:	8b 45 08             	mov    0x8(%ebp),%eax
80102f66:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f6a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102f6e:	89 c2                	mov    %eax,%edx
80102f70:	ec                   	in     (%dx),%al
80102f71:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f74:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f78:	c9                   	leave  
80102f79:	c3                   	ret    

80102f7a <outb>:
{
80102f7a:	55                   	push   %ebp
80102f7b:	89 e5                	mov    %esp,%ebp
80102f7d:	83 ec 08             	sub    $0x8,%esp
80102f80:	8b 45 08             	mov    0x8(%ebp),%eax
80102f83:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f86:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102f8a:	89 d0                	mov    %edx,%eax
80102f8c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f8f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f93:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f97:	ee                   	out    %al,(%dx)
}
80102f98:	90                   	nop
80102f99:	c9                   	leave  
80102f9a:	c3                   	ret    

80102f9b <readeflags>:
{
80102f9b:	55                   	push   %ebp
80102f9c:	89 e5                	mov    %esp,%ebp
80102f9e:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102fa1:	9c                   	pushf  
80102fa2:	58                   	pop    %eax
80102fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102fa9:	c9                   	leave  
80102faa:	c3                   	ret    

80102fab <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102fab:	f3 0f 1e fb          	endbr32 
80102faf:	55                   	push   %ebp
80102fb0:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102fb2:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102fb7:	8b 55 08             	mov    0x8(%ebp),%edx
80102fba:	c1 e2 02             	shl    $0x2,%edx
80102fbd:	01 c2                	add    %eax,%edx
80102fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fc2:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102fc4:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102fc9:	83 c0 20             	add    $0x20,%eax
80102fcc:	8b 00                	mov    (%eax),%eax
}
80102fce:	90                   	nop
80102fcf:	5d                   	pop    %ebp
80102fd0:	c3                   	ret    

80102fd1 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102fd1:	f3 0f 1e fb          	endbr32 
80102fd5:	55                   	push   %ebp
80102fd6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102fd8:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102fdd:	85 c0                	test   %eax,%eax
80102fdf:	0f 84 0c 01 00 00    	je     801030f1 <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102fe5:	68 3f 01 00 00       	push   $0x13f
80102fea:	6a 3c                	push   $0x3c
80102fec:	e8 ba ff ff ff       	call   80102fab <lapicw>
80102ff1:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ff4:	6a 0b                	push   $0xb
80102ff6:	68 f8 00 00 00       	push   $0xf8
80102ffb:	e8 ab ff ff ff       	call   80102fab <lapicw>
80103000:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103003:	68 20 00 02 00       	push   $0x20020
80103008:	68 c8 00 00 00       	push   $0xc8
8010300d:	e8 99 ff ff ff       	call   80102fab <lapicw>
80103012:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80103015:	68 80 96 98 00       	push   $0x989680
8010301a:	68 e0 00 00 00       	push   $0xe0
8010301f:	e8 87 ff ff ff       	call   80102fab <lapicw>
80103024:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103027:	68 00 00 01 00       	push   $0x10000
8010302c:	68 d4 00 00 00       	push   $0xd4
80103031:	e8 75 ff ff ff       	call   80102fab <lapicw>
80103036:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103039:	68 00 00 01 00       	push   $0x10000
8010303e:	68 d8 00 00 00       	push   $0xd8
80103043:	e8 63 ff ff ff       	call   80102fab <lapicw>
80103048:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010304b:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80103050:	83 c0 30             	add    $0x30,%eax
80103053:	8b 00                	mov    (%eax),%eax
80103055:	c1 e8 10             	shr    $0x10,%eax
80103058:	25 fc 00 00 00       	and    $0xfc,%eax
8010305d:	85 c0                	test   %eax,%eax
8010305f:	74 12                	je     80103073 <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
80103061:	68 00 00 01 00       	push   $0x10000
80103066:	68 d0 00 00 00       	push   $0xd0
8010306b:	e8 3b ff ff ff       	call   80102fab <lapicw>
80103070:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103073:	6a 33                	push   $0x33
80103075:	68 dc 00 00 00       	push   $0xdc
8010307a:	e8 2c ff ff ff       	call   80102fab <lapicw>
8010307f:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103082:	6a 00                	push   $0x0
80103084:	68 a0 00 00 00       	push   $0xa0
80103089:	e8 1d ff ff ff       	call   80102fab <lapicw>
8010308e:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103091:	6a 00                	push   $0x0
80103093:	68 a0 00 00 00       	push   $0xa0
80103098:	e8 0e ff ff ff       	call   80102fab <lapicw>
8010309d:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801030a0:	6a 00                	push   $0x0
801030a2:	6a 2c                	push   $0x2c
801030a4:	e8 02 ff ff ff       	call   80102fab <lapicw>
801030a9:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801030ac:	6a 00                	push   $0x0
801030ae:	68 c4 00 00 00       	push   $0xc4
801030b3:	e8 f3 fe ff ff       	call   80102fab <lapicw>
801030b8:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801030bb:	68 00 85 08 00       	push   $0x88500
801030c0:	68 c0 00 00 00       	push   $0xc0
801030c5:	e8 e1 fe ff ff       	call   80102fab <lapicw>
801030ca:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801030cd:	90                   	nop
801030ce:	a1 5c 32 11 80       	mov    0x8011325c,%eax
801030d3:	05 00 03 00 00       	add    $0x300,%eax
801030d8:	8b 00                	mov    (%eax),%eax
801030da:	25 00 10 00 00       	and    $0x1000,%eax
801030df:	85 c0                	test   %eax,%eax
801030e1:	75 eb                	jne    801030ce <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801030e3:	6a 00                	push   $0x0
801030e5:	6a 20                	push   $0x20
801030e7:	e8 bf fe ff ff       	call   80102fab <lapicw>
801030ec:	83 c4 08             	add    $0x8,%esp
801030ef:	eb 01                	jmp    801030f2 <lapicinit+0x121>
    return;
801030f1:	90                   	nop
}
801030f2:	c9                   	leave  
801030f3:	c3                   	ret    

801030f4 <cpunum>:

int
cpunum(void)
{
801030f4:	f3 0f 1e fb          	endbr32 
801030f8:	55                   	push   %ebp
801030f9:	89 e5                	mov    %esp,%ebp
801030fb:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801030fe:	e8 98 fe ff ff       	call   80102f9b <readeflags>
80103103:	25 00 02 00 00       	and    $0x200,%eax
80103108:	85 c0                	test   %eax,%eax
8010310a:	74 26                	je     80103132 <cpunum+0x3e>
    static int n;
    if(n++ == 0)
8010310c:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80103111:	8d 50 01             	lea    0x1(%eax),%edx
80103114:	89 15 40 c6 10 80    	mov    %edx,0x8010c640
8010311a:	85 c0                	test   %eax,%eax
8010311c:	75 14                	jne    80103132 <cpunum+0x3e>
      cprintf("cpu called from %x with interrupts enabled\n",
8010311e:	8b 45 04             	mov    0x4(%ebp),%eax
80103121:	83 ec 08             	sub    $0x8,%esp
80103124:	50                   	push   %eax
80103125:	68 dc 8e 10 80       	push   $0x80108edc
8010312a:	e8 af d2 ff ff       	call   801003de <cprintf>
8010312f:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103132:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80103137:	85 c0                	test   %eax,%eax
80103139:	74 0f                	je     8010314a <cpunum+0x56>
    return lapic[ID]>>24;
8010313b:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80103140:	83 c0 20             	add    $0x20,%eax
80103143:	8b 00                	mov    (%eax),%eax
80103145:	c1 e8 18             	shr    $0x18,%eax
80103148:	eb 05                	jmp    8010314f <cpunum+0x5b>
  return 0;
8010314a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010314f:	c9                   	leave  
80103150:	c3                   	ret    

80103151 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103151:	f3 0f 1e fb          	endbr32 
80103155:	55                   	push   %ebp
80103156:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103158:	a1 5c 32 11 80       	mov    0x8011325c,%eax
8010315d:	85 c0                	test   %eax,%eax
8010315f:	74 0c                	je     8010316d <lapiceoi+0x1c>
    lapicw(EOI, 0);
80103161:	6a 00                	push   $0x0
80103163:	6a 2c                	push   $0x2c
80103165:	e8 41 fe ff ff       	call   80102fab <lapicw>
8010316a:	83 c4 08             	add    $0x8,%esp
}
8010316d:	90                   	nop
8010316e:	c9                   	leave  
8010316f:	c3                   	ret    

80103170 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103170:	f3 0f 1e fb          	endbr32 
80103174:	55                   	push   %ebp
80103175:	89 e5                	mov    %esp,%ebp
}
80103177:	90                   	nop
80103178:	5d                   	pop    %ebp
80103179:	c3                   	ret    

8010317a <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010317a:	f3 0f 1e fb          	endbr32 
8010317e:	55                   	push   %ebp
8010317f:	89 e5                	mov    %esp,%ebp
80103181:	83 ec 14             	sub    $0x14,%esp
80103184:	8b 45 08             	mov    0x8(%ebp),%eax
80103187:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010318a:	6a 0f                	push   $0xf
8010318c:	6a 70                	push   $0x70
8010318e:	e8 e7 fd ff ff       	call   80102f7a <outb>
80103193:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103196:	6a 0a                	push   $0xa
80103198:	6a 71                	push   $0x71
8010319a:	e8 db fd ff ff       	call   80102f7a <outb>
8010319f:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801031a2:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801031a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031ac:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801031b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801031b4:	c1 e8 04             	shr    $0x4,%eax
801031b7:	89 c2                	mov    %eax,%edx
801031b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031bc:	83 c0 02             	add    $0x2,%eax
801031bf:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031c2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031c6:	c1 e0 18             	shl    $0x18,%eax
801031c9:	50                   	push   %eax
801031ca:	68 c4 00 00 00       	push   $0xc4
801031cf:	e8 d7 fd ff ff       	call   80102fab <lapicw>
801031d4:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801031d7:	68 00 c5 00 00       	push   $0xc500
801031dc:	68 c0 00 00 00       	push   $0xc0
801031e1:	e8 c5 fd ff ff       	call   80102fab <lapicw>
801031e6:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031e9:	68 c8 00 00 00       	push   $0xc8
801031ee:	e8 7d ff ff ff       	call   80103170 <microdelay>
801031f3:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801031f6:	68 00 85 00 00       	push   $0x8500
801031fb:	68 c0 00 00 00       	push   $0xc0
80103200:	e8 a6 fd ff ff       	call   80102fab <lapicw>
80103205:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103208:	6a 64                	push   $0x64
8010320a:	e8 61 ff ff ff       	call   80103170 <microdelay>
8010320f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103219:	eb 3d                	jmp    80103258 <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
8010321b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010321f:	c1 e0 18             	shl    $0x18,%eax
80103222:	50                   	push   %eax
80103223:	68 c4 00 00 00       	push   $0xc4
80103228:	e8 7e fd ff ff       	call   80102fab <lapicw>
8010322d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103230:	8b 45 0c             	mov    0xc(%ebp),%eax
80103233:	c1 e8 0c             	shr    $0xc,%eax
80103236:	80 cc 06             	or     $0x6,%ah
80103239:	50                   	push   %eax
8010323a:	68 c0 00 00 00       	push   $0xc0
8010323f:	e8 67 fd ff ff       	call   80102fab <lapicw>
80103244:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103247:	68 c8 00 00 00       	push   $0xc8
8010324c:	e8 1f ff ff ff       	call   80103170 <microdelay>
80103251:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103254:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103258:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010325c:	7e bd                	jle    8010321b <lapicstartap+0xa1>
  }
}
8010325e:	90                   	nop
8010325f:	90                   	nop
80103260:	c9                   	leave  
80103261:	c3                   	ret    

80103262 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103262:	f3 0f 1e fb          	endbr32 
80103266:	55                   	push   %ebp
80103267:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103269:	8b 45 08             	mov    0x8(%ebp),%eax
8010326c:	0f b6 c0             	movzbl %al,%eax
8010326f:	50                   	push   %eax
80103270:	6a 70                	push   $0x70
80103272:	e8 03 fd ff ff       	call   80102f7a <outb>
80103277:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010327a:	68 c8 00 00 00       	push   $0xc8
8010327f:	e8 ec fe ff ff       	call   80103170 <microdelay>
80103284:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103287:	6a 71                	push   $0x71
80103289:	e8 cf fc ff ff       	call   80102f5d <inb>
8010328e:	83 c4 04             	add    $0x4,%esp
80103291:	0f b6 c0             	movzbl %al,%eax
}
80103294:	c9                   	leave  
80103295:	c3                   	ret    

80103296 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103296:	f3 0f 1e fb          	endbr32 
8010329a:	55                   	push   %ebp
8010329b:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010329d:	6a 00                	push   $0x0
8010329f:	e8 be ff ff ff       	call   80103262 <cmos_read>
801032a4:	83 c4 04             	add    $0x4,%esp
801032a7:	8b 55 08             	mov    0x8(%ebp),%edx
801032aa:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801032ac:	6a 02                	push   $0x2
801032ae:	e8 af ff ff ff       	call   80103262 <cmos_read>
801032b3:	83 c4 04             	add    $0x4,%esp
801032b6:	8b 55 08             	mov    0x8(%ebp),%edx
801032b9:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801032bc:	6a 04                	push   $0x4
801032be:	e8 9f ff ff ff       	call   80103262 <cmos_read>
801032c3:	83 c4 04             	add    $0x4,%esp
801032c6:	8b 55 08             	mov    0x8(%ebp),%edx
801032c9:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801032cc:	6a 07                	push   $0x7
801032ce:	e8 8f ff ff ff       	call   80103262 <cmos_read>
801032d3:	83 c4 04             	add    $0x4,%esp
801032d6:	8b 55 08             	mov    0x8(%ebp),%edx
801032d9:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801032dc:	6a 08                	push   $0x8
801032de:	e8 7f ff ff ff       	call   80103262 <cmos_read>
801032e3:	83 c4 04             	add    $0x4,%esp
801032e6:	8b 55 08             	mov    0x8(%ebp),%edx
801032e9:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801032ec:	6a 09                	push   $0x9
801032ee:	e8 6f ff ff ff       	call   80103262 <cmos_read>
801032f3:	83 c4 04             	add    $0x4,%esp
801032f6:	8b 55 08             	mov    0x8(%ebp),%edx
801032f9:	89 42 14             	mov    %eax,0x14(%edx)
}
801032fc:	90                   	nop
801032fd:	c9                   	leave  
801032fe:	c3                   	ret    

801032ff <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801032ff:	f3 0f 1e fb          	endbr32 
80103303:	55                   	push   %ebp
80103304:	89 e5                	mov    %esp,%ebp
80103306:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103309:	6a 0b                	push   $0xb
8010330b:	e8 52 ff ff ff       	call   80103262 <cmos_read>
80103310:	83 c4 04             	add    $0x4,%esp
80103313:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103319:	83 e0 04             	and    $0x4,%eax
8010331c:	85 c0                	test   %eax,%eax
8010331e:	0f 94 c0             	sete   %al
80103321:	0f b6 c0             	movzbl %al,%eax
80103324:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103327:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010332a:	50                   	push   %eax
8010332b:	e8 66 ff ff ff       	call   80103296 <fill_rtcdate>
80103330:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103333:	6a 0a                	push   $0xa
80103335:	e8 28 ff ff ff       	call   80103262 <cmos_read>
8010333a:	83 c4 04             	add    $0x4,%esp
8010333d:	25 80 00 00 00       	and    $0x80,%eax
80103342:	85 c0                	test   %eax,%eax
80103344:	75 27                	jne    8010336d <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
80103346:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103349:	50                   	push   %eax
8010334a:	e8 47 ff ff ff       	call   80103296 <fill_rtcdate>
8010334f:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103352:	83 ec 04             	sub    $0x4,%esp
80103355:	6a 18                	push   $0x18
80103357:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010335a:	50                   	push   %eax
8010335b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010335e:	50                   	push   %eax
8010335f:	e8 28 25 00 00       	call   8010588c <memcmp>
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 c0                	test   %eax,%eax
80103369:	74 05                	je     80103370 <cmostime+0x71>
8010336b:	eb ba                	jmp    80103327 <cmostime+0x28>
        continue;
8010336d:	90                   	nop
    fill_rtcdate(&t1);
8010336e:	eb b7                	jmp    80103327 <cmostime+0x28>
      break;
80103370:	90                   	nop
  }

  // convert
  if (bcd) {
80103371:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103375:	0f 84 b4 00 00 00    	je     8010342f <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010337b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010337e:	c1 e8 04             	shr    $0x4,%eax
80103381:	89 c2                	mov    %eax,%edx
80103383:	89 d0                	mov    %edx,%eax
80103385:	c1 e0 02             	shl    $0x2,%eax
80103388:	01 d0                	add    %edx,%eax
8010338a:	01 c0                	add    %eax,%eax
8010338c:	89 c2                	mov    %eax,%edx
8010338e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103391:	83 e0 0f             	and    $0xf,%eax
80103394:	01 d0                	add    %edx,%eax
80103396:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103399:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010339c:	c1 e8 04             	shr    $0x4,%eax
8010339f:	89 c2                	mov    %eax,%edx
801033a1:	89 d0                	mov    %edx,%eax
801033a3:	c1 e0 02             	shl    $0x2,%eax
801033a6:	01 d0                	add    %edx,%eax
801033a8:	01 c0                	add    %eax,%eax
801033aa:	89 c2                	mov    %eax,%edx
801033ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033af:	83 e0 0f             	and    $0xf,%eax
801033b2:	01 d0                	add    %edx,%eax
801033b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801033b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033ba:	c1 e8 04             	shr    $0x4,%eax
801033bd:	89 c2                	mov    %eax,%edx
801033bf:	89 d0                	mov    %edx,%eax
801033c1:	c1 e0 02             	shl    $0x2,%eax
801033c4:	01 d0                	add    %edx,%eax
801033c6:	01 c0                	add    %eax,%eax
801033c8:	89 c2                	mov    %eax,%edx
801033ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033cd:	83 e0 0f             	and    $0xf,%eax
801033d0:	01 d0                	add    %edx,%eax
801033d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801033d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033d8:	c1 e8 04             	shr    $0x4,%eax
801033db:	89 c2                	mov    %eax,%edx
801033dd:	89 d0                	mov    %edx,%eax
801033df:	c1 e0 02             	shl    $0x2,%eax
801033e2:	01 d0                	add    %edx,%eax
801033e4:	01 c0                	add    %eax,%eax
801033e6:	89 c2                	mov    %eax,%edx
801033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033eb:	83 e0 0f             	and    $0xf,%eax
801033ee:	01 d0                	add    %edx,%eax
801033f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033f6:	c1 e8 04             	shr    $0x4,%eax
801033f9:	89 c2                	mov    %eax,%edx
801033fb:	89 d0                	mov    %edx,%eax
801033fd:	c1 e0 02             	shl    $0x2,%eax
80103400:	01 d0                	add    %edx,%eax
80103402:	01 c0                	add    %eax,%eax
80103404:	89 c2                	mov    %eax,%edx
80103406:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103409:	83 e0 0f             	and    $0xf,%eax
8010340c:	01 d0                	add    %edx,%eax
8010340e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103411:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103414:	c1 e8 04             	shr    $0x4,%eax
80103417:	89 c2                	mov    %eax,%edx
80103419:	89 d0                	mov    %edx,%eax
8010341b:	c1 e0 02             	shl    $0x2,%eax
8010341e:	01 d0                	add    %edx,%eax
80103420:	01 c0                	add    %eax,%eax
80103422:	89 c2                	mov    %eax,%edx
80103424:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103427:	83 e0 0f             	and    $0xf,%eax
8010342a:	01 d0                	add    %edx,%eax
8010342c:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010342f:	8b 45 08             	mov    0x8(%ebp),%eax
80103432:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103435:	89 10                	mov    %edx,(%eax)
80103437:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010343a:	89 50 04             	mov    %edx,0x4(%eax)
8010343d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103440:	89 50 08             	mov    %edx,0x8(%eax)
80103443:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103446:	89 50 0c             	mov    %edx,0xc(%eax)
80103449:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010344c:	89 50 10             	mov    %edx,0x10(%eax)
8010344f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103452:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103455:	8b 45 08             	mov    0x8(%ebp),%eax
80103458:	8b 40 14             	mov    0x14(%eax),%eax
8010345b:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103461:	8b 45 08             	mov    0x8(%ebp),%eax
80103464:	89 50 14             	mov    %edx,0x14(%eax)
}
80103467:	90                   	nop
80103468:	c9                   	leave  
80103469:	c3                   	ret    

8010346a <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010346a:	f3 0f 1e fb          	endbr32 
8010346e:	55                   	push   %ebp
8010346f:	89 e5                	mov    %esp,%ebp
80103471:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103474:	83 ec 08             	sub    $0x8,%esp
80103477:	68 08 8f 10 80       	push   $0x80108f08
8010347c:	68 60 32 11 80       	push   $0x80113260
80103481:	e8 f9 20 00 00       	call   8010557f <initlock>
80103486:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103489:	83 ec 08             	sub    $0x8,%esp
8010348c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010348f:	50                   	push   %eax
80103490:	ff 75 08             	pushl  0x8(%ebp)
80103493:	e8 6f df ff ff       	call   80101407 <readsb>
80103498:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010349e:	a3 94 32 11 80       	mov    %eax,0x80113294
  log.size = sb.nlog;
801034a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034a6:	a3 98 32 11 80       	mov    %eax,0x80113298
  log.dev = dev;
801034ab:	8b 45 08             	mov    0x8(%ebp),%eax
801034ae:	a3 a4 32 11 80       	mov    %eax,0x801132a4
  recover_from_log();
801034b3:	e8 bf 01 00 00       	call   80103677 <recover_from_log>
}
801034b8:	90                   	nop
801034b9:	c9                   	leave  
801034ba:	c3                   	ret    

801034bb <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801034bb:	f3 0f 1e fb          	endbr32 
801034bf:	55                   	push   %ebp
801034c0:	89 e5                	mov    %esp,%ebp
801034c2:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034cc:	e9 95 00 00 00       	jmp    80103566 <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801034d1:	8b 15 94 32 11 80    	mov    0x80113294,%edx
801034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034da:	01 d0                	add    %edx,%eax
801034dc:	83 c0 01             	add    $0x1,%eax
801034df:	89 c2                	mov    %eax,%edx
801034e1:	a1 a4 32 11 80       	mov    0x801132a4,%eax
801034e6:	83 ec 08             	sub    $0x8,%esp
801034e9:	52                   	push   %edx
801034ea:	50                   	push   %eax
801034eb:	e8 cf cc ff ff       	call   801001bf <bread>
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f9:	83 c0 10             	add    $0x10,%eax
801034fc:	8b 04 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%eax
80103503:	89 c2                	mov    %eax,%edx
80103505:	a1 a4 32 11 80       	mov    0x801132a4,%eax
8010350a:	83 ec 08             	sub    $0x8,%esp
8010350d:	52                   	push   %edx
8010350e:	50                   	push   %eax
8010350f:	e8 ab cc ff ff       	call   801001bf <bread>
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010351a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010351d:	8d 50 18             	lea    0x18(%eax),%edx
80103520:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103523:	83 c0 18             	add    $0x18,%eax
80103526:	83 ec 04             	sub    $0x4,%esp
80103529:	68 00 02 00 00       	push   $0x200
8010352e:	52                   	push   %edx
8010352f:	50                   	push   %eax
80103530:	e8 b3 23 00 00       	call   801058e8 <memmove>
80103535:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103538:	83 ec 0c             	sub    $0xc,%esp
8010353b:	ff 75 ec             	pushl  -0x14(%ebp)
8010353e:	e8 b9 cc ff ff       	call   801001fc <bwrite>
80103543:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	ff 75 f0             	pushl  -0x10(%ebp)
8010354c:	e8 ee cc ff ff       	call   8010023f <brelse>
80103551:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103554:	83 ec 0c             	sub    $0xc,%esp
80103557:	ff 75 ec             	pushl  -0x14(%ebp)
8010355a:	e8 e0 cc ff ff       	call   8010023f <brelse>
8010355f:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103562:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103566:	a1 a8 32 11 80       	mov    0x801132a8,%eax
8010356b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010356e:	0f 8c 5d ff ff ff    	jl     801034d1 <install_trans+0x16>
  }
}
80103574:	90                   	nop
80103575:	90                   	nop
80103576:	c9                   	leave  
80103577:	c3                   	ret    

80103578 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103578:	f3 0f 1e fb          	endbr32 
8010357c:	55                   	push   %ebp
8010357d:	89 e5                	mov    %esp,%ebp
8010357f:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103582:	a1 94 32 11 80       	mov    0x80113294,%eax
80103587:	89 c2                	mov    %eax,%edx
80103589:	a1 a4 32 11 80       	mov    0x801132a4,%eax
8010358e:	83 ec 08             	sub    $0x8,%esp
80103591:	52                   	push   %edx
80103592:	50                   	push   %eax
80103593:	e8 27 cc ff ff       	call   801001bf <bread>
80103598:	83 c4 10             	add    $0x10,%esp
8010359b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010359e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035a1:	83 c0 18             	add    $0x18,%eax
801035a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801035a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035aa:	8b 00                	mov    (%eax),%eax
801035ac:	a3 a8 32 11 80       	mov    %eax,0x801132a8
  for (i = 0; i < log.lh.n; i++) {
801035b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035b8:	eb 1b                	jmp    801035d5 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
801035ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035c0:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801035c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035c7:	83 c2 10             	add    $0x10,%edx
801035ca:	89 04 95 6c 32 11 80 	mov    %eax,-0x7feecd94(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035d5:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801035da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035dd:	7c db                	jl     801035ba <read_head+0x42>
  }
  brelse(buf);
801035df:	83 ec 0c             	sub    $0xc,%esp
801035e2:	ff 75 f0             	pushl  -0x10(%ebp)
801035e5:	e8 55 cc ff ff       	call   8010023f <brelse>
801035ea:	83 c4 10             	add    $0x10,%esp
}
801035ed:	90                   	nop
801035ee:	c9                   	leave  
801035ef:	c3                   	ret    

801035f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035fa:	a1 94 32 11 80       	mov    0x80113294,%eax
801035ff:	89 c2                	mov    %eax,%edx
80103601:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103606:	83 ec 08             	sub    $0x8,%esp
80103609:	52                   	push   %edx
8010360a:	50                   	push   %eax
8010360b:	e8 af cb ff ff       	call   801001bf <bread>
80103610:	83 c4 10             	add    $0x10,%esp
80103613:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103616:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103619:	83 c0 18             	add    $0x18,%eax
8010361c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010361f:	8b 15 a8 32 11 80    	mov    0x801132a8,%edx
80103625:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103628:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010362a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103631:	eb 1b                	jmp    8010364e <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103636:	83 c0 10             	add    $0x10,%eax
80103639:	8b 0c 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%ecx
80103640:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103643:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103646:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010364a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010364e:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103653:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103656:	7c db                	jl     80103633 <write_head+0x43>
  }
  bwrite(buf);
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	ff 75 f0             	pushl  -0x10(%ebp)
8010365e:	e8 99 cb ff ff       	call   801001fc <bwrite>
80103663:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103666:	83 ec 0c             	sub    $0xc,%esp
80103669:	ff 75 f0             	pushl  -0x10(%ebp)
8010366c:	e8 ce cb ff ff       	call   8010023f <brelse>
80103671:	83 c4 10             	add    $0x10,%esp
}
80103674:	90                   	nop
80103675:	c9                   	leave  
80103676:	c3                   	ret    

80103677 <recover_from_log>:

static void
recover_from_log(void)
{
80103677:	f3 0f 1e fb          	endbr32 
8010367b:	55                   	push   %ebp
8010367c:	89 e5                	mov    %esp,%ebp
8010367e:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103681:	e8 f2 fe ff ff       	call   80103578 <read_head>
  install_trans(); // if committed, copy from log to disk
80103686:	e8 30 fe ff ff       	call   801034bb <install_trans>
  log.lh.n = 0;
8010368b:	c7 05 a8 32 11 80 00 	movl   $0x0,0x801132a8
80103692:	00 00 00 
  write_head(); // clear the log
80103695:	e8 56 ff ff ff       	call   801035f0 <write_head>
}
8010369a:	90                   	nop
8010369b:	c9                   	leave  
8010369c:	c3                   	ret    

8010369d <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010369d:	f3 0f 1e fb          	endbr32 
801036a1:	55                   	push   %ebp
801036a2:	89 e5                	mov    %esp,%ebp
801036a4:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801036a7:	83 ec 0c             	sub    $0xc,%esp
801036aa:	68 60 32 11 80       	push   $0x80113260
801036af:	e8 f1 1e 00 00       	call   801055a5 <acquire>
801036b4:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801036b7:	a1 a0 32 11 80       	mov    0x801132a0,%eax
801036bc:	85 c0                	test   %eax,%eax
801036be:	74 17                	je     801036d7 <begin_op+0x3a>
      sleep(&log, &log.lock);
801036c0:	83 ec 08             	sub    $0x8,%esp
801036c3:	68 60 32 11 80       	push   $0x80113260
801036c8:	68 60 32 11 80       	push   $0x80113260
801036cd:	e8 30 19 00 00       	call   80105002 <sleep>
801036d2:	83 c4 10             	add    $0x10,%esp
801036d5:	eb e0                	jmp    801036b7 <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801036d7:	8b 0d a8 32 11 80    	mov    0x801132a8,%ecx
801036dd:	a1 9c 32 11 80       	mov    0x8011329c,%eax
801036e2:	8d 50 01             	lea    0x1(%eax),%edx
801036e5:	89 d0                	mov    %edx,%eax
801036e7:	c1 e0 02             	shl    $0x2,%eax
801036ea:	01 d0                	add    %edx,%eax
801036ec:	01 c0                	add    %eax,%eax
801036ee:	01 c8                	add    %ecx,%eax
801036f0:	83 f8 1e             	cmp    $0x1e,%eax
801036f3:	7e 17                	jle    8010370c <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801036f5:	83 ec 08             	sub    $0x8,%esp
801036f8:	68 60 32 11 80       	push   $0x80113260
801036fd:	68 60 32 11 80       	push   $0x80113260
80103702:	e8 fb 18 00 00       	call   80105002 <sleep>
80103707:	83 c4 10             	add    $0x10,%esp
8010370a:	eb ab                	jmp    801036b7 <begin_op+0x1a>
    } else {
      log.outstanding += 1;
8010370c:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103711:	83 c0 01             	add    $0x1,%eax
80103714:	a3 9c 32 11 80       	mov    %eax,0x8011329c
      release(&log.lock);
80103719:	83 ec 0c             	sub    $0xc,%esp
8010371c:	68 60 32 11 80       	push   $0x80113260
80103721:	e8 ea 1e 00 00       	call   80105610 <release>
80103726:	83 c4 10             	add    $0x10,%esp
      break;
80103729:	90                   	nop
    }
  }
}
8010372a:	90                   	nop
8010372b:	c9                   	leave  
8010372c:	c3                   	ret    

8010372d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010372d:	f3 0f 1e fb          	endbr32 
80103731:	55                   	push   %ebp
80103732:	89 e5                	mov    %esp,%ebp
80103734:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103737:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	68 60 32 11 80       	push   $0x80113260
80103746:	e8 5a 1e 00 00       	call   801055a5 <acquire>
8010374b:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010374e:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103753:	83 e8 01             	sub    $0x1,%eax
80103756:	a3 9c 32 11 80       	mov    %eax,0x8011329c
  if(log.committing)
8010375b:	a1 a0 32 11 80       	mov    0x801132a0,%eax
80103760:	85 c0                	test   %eax,%eax
80103762:	74 0d                	je     80103771 <end_op+0x44>
    panic("log.committing");
80103764:	83 ec 0c             	sub    $0xc,%esp
80103767:	68 0c 8f 10 80       	push   $0x80108f0c
8010376c:	e8 26 ce ff ff       	call   80100597 <panic>
  if(log.outstanding == 0){
80103771:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103776:	85 c0                	test   %eax,%eax
80103778:	75 13                	jne    8010378d <end_op+0x60>
    do_commit = 1;
8010377a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103781:	c7 05 a0 32 11 80 01 	movl   $0x1,0x801132a0
80103788:	00 00 00 
8010378b:	eb 10                	jmp    8010379d <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010378d:	83 ec 0c             	sub    $0xc,%esp
80103790:	68 60 32 11 80       	push   $0x80113260
80103795:	e8 5f 19 00 00       	call   801050f9 <wakeup>
8010379a:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010379d:	83 ec 0c             	sub    $0xc,%esp
801037a0:	68 60 32 11 80       	push   $0x80113260
801037a5:	e8 66 1e 00 00       	call   80105610 <release>
801037aa:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801037ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037b1:	74 3f                	je     801037f2 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801037b3:	e8 fa 00 00 00       	call   801038b2 <commit>
    acquire(&log.lock);
801037b8:	83 ec 0c             	sub    $0xc,%esp
801037bb:	68 60 32 11 80       	push   $0x80113260
801037c0:	e8 e0 1d 00 00       	call   801055a5 <acquire>
801037c5:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801037c8:	c7 05 a0 32 11 80 00 	movl   $0x0,0x801132a0
801037cf:	00 00 00 
    wakeup(&log);
801037d2:	83 ec 0c             	sub    $0xc,%esp
801037d5:	68 60 32 11 80       	push   $0x80113260
801037da:	e8 1a 19 00 00       	call   801050f9 <wakeup>
801037df:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	68 60 32 11 80       	push   $0x80113260
801037ea:	e8 21 1e 00 00       	call   80105610 <release>
801037ef:	83 c4 10             	add    $0x10,%esp
  }
}
801037f2:	90                   	nop
801037f3:	c9                   	leave  
801037f4:	c3                   	ret    

801037f5 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801037f5:	f3 0f 1e fb          	endbr32 
801037f9:	55                   	push   %ebp
801037fa:	89 e5                	mov    %esp,%ebp
801037fc:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103806:	e9 95 00 00 00       	jmp    801038a0 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010380b:	8b 15 94 32 11 80    	mov    0x80113294,%edx
80103811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103814:	01 d0                	add    %edx,%eax
80103816:	83 c0 01             	add    $0x1,%eax
80103819:	89 c2                	mov    %eax,%edx
8010381b:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	52                   	push   %edx
80103824:	50                   	push   %eax
80103825:	e8 95 c9 ff ff       	call   801001bf <bread>
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103833:	83 c0 10             	add    $0x10,%eax
80103836:	8b 04 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%eax
8010383d:	89 c2                	mov    %eax,%edx
8010383f:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103844:	83 ec 08             	sub    $0x8,%esp
80103847:	52                   	push   %edx
80103848:	50                   	push   %eax
80103849:	e8 71 c9 ff ff       	call   801001bf <bread>
8010384e:	83 c4 10             	add    $0x10,%esp
80103851:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103854:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103857:	8d 50 18             	lea    0x18(%eax),%edx
8010385a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385d:	83 c0 18             	add    $0x18,%eax
80103860:	83 ec 04             	sub    $0x4,%esp
80103863:	68 00 02 00 00       	push   $0x200
80103868:	52                   	push   %edx
80103869:	50                   	push   %eax
8010386a:	e8 79 20 00 00       	call   801058e8 <memmove>
8010386f:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103872:	83 ec 0c             	sub    $0xc,%esp
80103875:	ff 75 f0             	pushl  -0x10(%ebp)
80103878:	e8 7f c9 ff ff       	call   801001fc <bwrite>
8010387d:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	ff 75 ec             	pushl  -0x14(%ebp)
80103886:	e8 b4 c9 ff ff       	call   8010023f <brelse>
8010388b:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010388e:	83 ec 0c             	sub    $0xc,%esp
80103891:	ff 75 f0             	pushl  -0x10(%ebp)
80103894:	e8 a6 c9 ff ff       	call   8010023f <brelse>
80103899:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010389c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038a0:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801038a5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801038a8:	0f 8c 5d ff ff ff    	jl     8010380b <write_log+0x16>
  }
}
801038ae:	90                   	nop
801038af:	90                   	nop
801038b0:	c9                   	leave  
801038b1:	c3                   	ret    

801038b2 <commit>:

static void
commit()
{
801038b2:	f3 0f 1e fb          	endbr32 
801038b6:	55                   	push   %ebp
801038b7:	89 e5                	mov    %esp,%ebp
801038b9:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801038bc:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801038c1:	85 c0                	test   %eax,%eax
801038c3:	7e 1e                	jle    801038e3 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
801038c5:	e8 2b ff ff ff       	call   801037f5 <write_log>
    write_head();    // Write header to disk -- the real commit
801038ca:	e8 21 fd ff ff       	call   801035f0 <write_head>
    install_trans(); // Now install writes to home locations
801038cf:	e8 e7 fb ff ff       	call   801034bb <install_trans>
    log.lh.n = 0; 
801038d4:	c7 05 a8 32 11 80 00 	movl   $0x0,0x801132a8
801038db:	00 00 00 
    write_head();    // Erase the transaction from the log
801038de:	e8 0d fd ff ff       	call   801035f0 <write_head>
  }
}
801038e3:	90                   	nop
801038e4:	c9                   	leave  
801038e5:	c3                   	ret    

801038e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801038e6:	f3 0f 1e fb          	endbr32 
801038ea:	55                   	push   %ebp
801038eb:	89 e5                	mov    %esp,%ebp
801038ed:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038f0:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801038f5:	83 f8 1d             	cmp    $0x1d,%eax
801038f8:	7f 12                	jg     8010390c <log_write+0x26>
801038fa:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801038ff:	8b 15 98 32 11 80    	mov    0x80113298,%edx
80103905:	83 ea 01             	sub    $0x1,%edx
80103908:	39 d0                	cmp    %edx,%eax
8010390a:	7c 0d                	jl     80103919 <log_write+0x33>
    panic("too big a transaction");
8010390c:	83 ec 0c             	sub    $0xc,%esp
8010390f:	68 1b 8f 10 80       	push   $0x80108f1b
80103914:	e8 7e cc ff ff       	call   80100597 <panic>
  if (log.outstanding < 1)
80103919:	a1 9c 32 11 80       	mov    0x8011329c,%eax
8010391e:	85 c0                	test   %eax,%eax
80103920:	7f 0d                	jg     8010392f <log_write+0x49>
    panic("log_write outside of trans");
80103922:	83 ec 0c             	sub    $0xc,%esp
80103925:	68 31 8f 10 80       	push   $0x80108f31
8010392a:	e8 68 cc ff ff       	call   80100597 <panic>

  acquire(&log.lock);
8010392f:	83 ec 0c             	sub    $0xc,%esp
80103932:	68 60 32 11 80       	push   $0x80113260
80103937:	e8 69 1c 00 00       	call   801055a5 <acquire>
8010393c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010393f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103946:	eb 1d                	jmp    80103965 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010394b:	83 c0 10             	add    $0x10,%eax
8010394e:	8b 04 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%eax
80103955:	89 c2                	mov    %eax,%edx
80103957:	8b 45 08             	mov    0x8(%ebp),%eax
8010395a:	8b 40 08             	mov    0x8(%eax),%eax
8010395d:	39 c2                	cmp    %eax,%edx
8010395f:	74 10                	je     80103971 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
80103961:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103965:	a1 a8 32 11 80       	mov    0x801132a8,%eax
8010396a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010396d:	7c d9                	jl     80103948 <log_write+0x62>
8010396f:	eb 01                	jmp    80103972 <log_write+0x8c>
      break;
80103971:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103972:	8b 45 08             	mov    0x8(%ebp),%eax
80103975:	8b 40 08             	mov    0x8(%eax),%eax
80103978:	89 c2                	mov    %eax,%edx
8010397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010397d:	83 c0 10             	add    $0x10,%eax
80103980:	89 14 85 6c 32 11 80 	mov    %edx,-0x7feecd94(,%eax,4)
  if (i == log.lh.n)
80103987:	a1 a8 32 11 80       	mov    0x801132a8,%eax
8010398c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010398f:	75 0d                	jne    8010399e <log_write+0xb8>
    log.lh.n++;
80103991:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103996:	83 c0 01             	add    $0x1,%eax
80103999:	a3 a8 32 11 80       	mov    %eax,0x801132a8
  b->flags |= B_DIRTY; // prevent eviction
8010399e:	8b 45 08             	mov    0x8(%ebp),%eax
801039a1:	8b 00                	mov    (%eax),%eax
801039a3:	83 c8 04             	or     $0x4,%eax
801039a6:	89 c2                	mov    %eax,%edx
801039a8:	8b 45 08             	mov    0x8(%ebp),%eax
801039ab:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801039ad:	83 ec 0c             	sub    $0xc,%esp
801039b0:	68 60 32 11 80       	push   $0x80113260
801039b5:	e8 56 1c 00 00       	call   80105610 <release>
801039ba:	83 c4 10             	add    $0x10,%esp
}
801039bd:	90                   	nop
801039be:	c9                   	leave  
801039bf:	c3                   	ret    

801039c0 <v2p>:
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	8b 45 08             	mov    0x8(%ebp),%eax
801039c6:	05 00 00 00 80       	add    $0x80000000,%eax
801039cb:	5d                   	pop    %ebp
801039cc:	c3                   	ret    

801039cd <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801039cd:	55                   	push   %ebp
801039ce:	89 e5                	mov    %esp,%ebp
801039d0:	8b 45 08             	mov    0x8(%ebp),%eax
801039d3:	05 00 00 00 80       	add    $0x80000000,%eax
801039d8:	5d                   	pop    %ebp
801039d9:	c3                   	ret    

801039da <xchg>:
  asm volatile("hlt");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801039da:	55                   	push   %ebp
801039db:	89 e5                	mov    %esp,%ebp
801039dd:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801039e0:	8b 55 08             	mov    0x8(%ebp),%edx
801039e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801039e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801039e9:	f0 87 02             	lock xchg %eax,(%edx)
801039ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801039ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801039f2:	c9                   	leave  
801039f3:	c3                   	ret    

801039f4 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801039f4:	f3 0f 1e fb          	endbr32 
801039f8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801039fc:	83 e4 f0             	and    $0xfffffff0,%esp
801039ff:	ff 71 fc             	pushl  -0x4(%ecx)
80103a02:	55                   	push   %ebp
80103a03:	89 e5                	mov    %esp,%ebp
80103a05:	51                   	push   %ecx
80103a06:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a09:	83 ec 08             	sub    $0x8,%esp
80103a0c:	68 00 00 40 80       	push   $0x80400000
80103a11:	68 3c 66 11 80       	push   $0x8011663c
80103a16:	e8 14 f2 ff ff       	call   80102c2f <kinit1>
80103a1b:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a1e:	e8 c8 4a 00 00       	call   801084eb <kvmalloc>
  mpinit();        // collect info about this machine
80103a23:	e8 5a 04 00 00       	call   80103e82 <mpinit>
  lapicinit();
80103a28:	e8 a4 f5 ff ff       	call   80102fd1 <lapicinit>
  seginit();       // set up segments
80103a2d:	e8 52 44 00 00       	call   80107e84 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103a32:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a38:	0f b6 00             	movzbl (%eax),%eax
80103a3b:	0f b6 c0             	movzbl %al,%eax
80103a3e:	83 ec 08             	sub    $0x8,%esp
80103a41:	50                   	push   %eax
80103a42:	68 4c 8f 10 80       	push   $0x80108f4c
80103a47:	e8 92 c9 ff ff       	call   801003de <cprintf>
80103a4c:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103a4f:	e8 b6 06 00 00       	call   8010410a <picinit>
  ioapicinit();    // another interrupt controller
80103a54:	e8 c3 f0 ff ff       	call   80102b1c <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103a59:	e8 1a d1 ff ff       	call   80100b78 <consoleinit>
  uartinit();      // serial port
80103a5e:	e8 6d 37 00 00       	call   801071d0 <uartinit>
  pinit();         // process table
80103a63:	e8 ba 0b 00 00       	call   80104622 <pinit>
  tvinit();        // trap vectors
80103a68:	e8 18 33 00 00       	call   80106d85 <tvinit>
  binit();         // buffer cache
80103a6d:	e8 c2 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a72:	e8 65 d5 ff ff       	call   80100fdc <fileinit>
  ideinit();       // disk
80103a77:	e8 90 ec ff ff       	call   8010270c <ideinit>
  if(!ismp)
80103a7c:	a1 44 33 11 80       	mov    0x80113344,%eax
80103a81:	85 c0                	test   %eax,%eax
80103a83:	75 05                	jne    80103a8a <main+0x96>
    timerinit();   // uniprocessor timer
80103a85:	e8 54 32 00 00       	call   80106cde <timerinit>
  startothers();   // start other processors
80103a8a:	e8 87 00 00 00       	call   80103b16 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a8f:	83 ec 08             	sub    $0x8,%esp
80103a92:	68 00 00 00 8e       	push   $0x8e000000
80103a97:	68 00 00 40 80       	push   $0x80400000
80103a9c:	e8 cb f1 ff ff       	call   80102c6c <kinit2>
80103aa1:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103aa4:	e8 0d 0d 00 00       	call   801047b6 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103aa9:	e8 1e 00 00 00       	call   80103acc <mpmain>

80103aae <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103aae:	f3 0f 1e fb          	endbr32 
80103ab2:	55                   	push   %ebp
80103ab3:	89 e5                	mov    %esp,%ebp
80103ab5:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103ab8:	e8 4a 4a 00 00       	call   80108507 <switchkvm>
  seginit();
80103abd:	e8 c2 43 00 00       	call   80107e84 <seginit>
  lapicinit();
80103ac2:	e8 0a f5 ff ff       	call   80102fd1 <lapicinit>
  mpmain();
80103ac7:	e8 00 00 00 00       	call   80103acc <mpmain>

80103acc <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103acc:	f3 0f 1e fb          	endbr32 
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103ad6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103adc:	0f b6 00             	movzbl (%eax),%eax
80103adf:	0f b6 c0             	movzbl %al,%eax
80103ae2:	83 ec 08             	sub    $0x8,%esp
80103ae5:	50                   	push   %eax
80103ae6:	68 63 8f 10 80       	push   $0x80108f63
80103aeb:	e8 ee c8 ff ff       	call   801003de <cprintf>
80103af0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103af3:	e8 07 34 00 00       	call   80106eff <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103af8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103afe:	05 a8 00 00 00       	add    $0xa8,%eax
80103b03:	83 ec 08             	sub    $0x8,%esp
80103b06:	6a 01                	push   $0x1
80103b08:	50                   	push   %eax
80103b09:	e8 cc fe ff ff       	call   801039da <xchg>
80103b0e:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103b11:	e8 8f 12 00 00       	call   80104da5 <scheduler>

80103b16 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b16:	f3 0f 1e fb          	endbr32 
80103b1a:	55                   	push   %ebp
80103b1b:	89 e5                	mov    %esp,%ebp
80103b1d:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103b20:	68 00 70 00 00       	push   $0x7000
80103b25:	e8 a3 fe ff ff       	call   801039cd <p2v>
80103b2a:	83 c4 04             	add    $0x4,%esp
80103b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b30:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b35:	83 ec 04             	sub    $0x4,%esp
80103b38:	50                   	push   %eax
80103b39:	68 0c c5 10 80       	push   $0x8010c50c
80103b3e:	ff 75 f0             	pushl  -0x10(%ebp)
80103b41:	e8 a2 1d 00 00       	call   801058e8 <memmove>
80103b46:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b49:	c7 45 f4 60 33 11 80 	movl   $0x80113360,-0xc(%ebp)
80103b50:	e9 8e 00 00 00       	jmp    80103be3 <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
80103b55:	e8 9a f5 ff ff       	call   801030f4 <cpunum>
80103b5a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b60:	05 60 33 11 80       	add    $0x80113360,%eax
80103b65:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b68:	74 71                	je     80103bdb <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b6a:	e8 08 f2 ff ff       	call   80102d77 <kalloc>
80103b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b75:	83 e8 04             	sub    $0x4,%eax
80103b78:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b7b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b81:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b86:	83 e8 08             	sub    $0x8,%eax
80103b89:	c7 00 ae 3a 10 80    	movl   $0x80103aae,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103b8f:	83 ec 0c             	sub    $0xc,%esp
80103b92:	68 00 b0 10 80       	push   $0x8010b000
80103b97:	e8 24 fe ff ff       	call   801039c0 <v2p>
80103b9c:	83 c4 10             	add    $0x10,%esp
80103b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103ba2:	83 ea 0c             	sub    $0xc,%edx
80103ba5:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->id, v2p(code));
80103ba7:	83 ec 0c             	sub    $0xc,%esp
80103baa:	ff 75 f0             	pushl  -0x10(%ebp)
80103bad:	e8 0e fe ff ff       	call   801039c0 <v2p>
80103bb2:	83 c4 10             	add    $0x10,%esp
80103bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103bb8:	0f b6 12             	movzbl (%edx),%edx
80103bbb:	0f b6 d2             	movzbl %dl,%edx
80103bbe:	83 ec 08             	sub    $0x8,%esp
80103bc1:	50                   	push   %eax
80103bc2:	52                   	push   %edx
80103bc3:	e8 b2 f5 ff ff       	call   8010317a <lapicstartap>
80103bc8:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bcb:	90                   	nop
80103bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcf:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103bd5:	85 c0                	test   %eax,%eax
80103bd7:	74 f3                	je     80103bcc <startothers+0xb6>
80103bd9:	eb 01                	jmp    80103bdc <startothers+0xc6>
      continue;
80103bdb:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103bdc:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103be3:	a1 40 39 11 80       	mov    0x80113940,%eax
80103be8:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103bee:	05 60 33 11 80       	add    $0x80113360,%eax
80103bf3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bf6:	0f 82 59 ff ff ff    	jb     80103b55 <startothers+0x3f>
      ;
  }
}
80103bfc:	90                   	nop
80103bfd:	90                   	nop
80103bfe:	c9                   	leave  
80103bff:	c3                   	ret    

80103c00 <p2v>:
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	8b 45 08             	mov    0x8(%ebp),%eax
80103c06:	05 00 00 00 80       	add    $0x80000000,%eax
80103c0b:	5d                   	pop    %ebp
80103c0c:	c3                   	ret    

80103c0d <inb>:
{
80103c0d:	55                   	push   %ebp
80103c0e:	89 e5                	mov    %esp,%ebp
80103c10:	83 ec 14             	sub    $0x14,%esp
80103c13:	8b 45 08             	mov    0x8(%ebp),%eax
80103c16:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c1a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c1e:	89 c2                	mov    %eax,%edx
80103c20:	ec                   	in     (%dx),%al
80103c21:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c24:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c28:	c9                   	leave  
80103c29:	c3                   	ret    

80103c2a <outb>:
{
80103c2a:	55                   	push   %ebp
80103c2b:	89 e5                	mov    %esp,%ebp
80103c2d:	83 ec 08             	sub    $0x8,%esp
80103c30:	8b 45 08             	mov    0x8(%ebp),%eax
80103c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c36:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103c3a:	89 d0                	mov    %edx,%eax
80103c3c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c3f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c43:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c47:	ee                   	out    %al,(%dx)
}
80103c48:	90                   	nop
80103c49:	c9                   	leave  
80103c4a:	c3                   	ret    

80103c4b <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103c4b:	f3 0f 1e fb          	endbr32 
80103c4f:	55                   	push   %ebp
80103c50:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103c52:	a1 44 c6 10 80       	mov    0x8010c644,%eax
80103c57:	2d 60 33 11 80       	sub    $0x80113360,%eax
80103c5c:	c1 f8 02             	sar    $0x2,%eax
80103c5f:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103c65:	5d                   	pop    %ebp
80103c66:	c3                   	ret    

80103c67 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103c67:	f3 0f 1e fb          	endbr32 
80103c6b:	55                   	push   %ebp
80103c6c:	89 e5                	mov    %esp,%ebp
80103c6e:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103c71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c7f:	eb 15                	jmp    80103c96 <sum+0x2f>
    sum += addr[i];
80103c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c84:	8b 45 08             	mov    0x8(%ebp),%eax
80103c87:	01 d0                	add    %edx,%eax
80103c89:	0f b6 00             	movzbl (%eax),%eax
80103c8c:	0f b6 c0             	movzbl %al,%eax
80103c8f:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c99:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c9c:	7c e3                	jl     80103c81 <sum+0x1a>
  return sum;
80103c9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103ca1:	c9                   	leave  
80103ca2:	c3                   	ret    

80103ca3 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ca3:	f3 0f 1e fb          	endbr32 
80103ca7:	55                   	push   %ebp
80103ca8:	89 e5                	mov    %esp,%ebp
80103caa:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103cad:	ff 75 08             	pushl  0x8(%ebp)
80103cb0:	e8 4b ff ff ff       	call   80103c00 <p2v>
80103cb5:	83 c4 04             	add    $0x4,%esp
80103cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
80103cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc1:	01 d0                	add    %edx,%eax
80103cc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ccc:	eb 36                	jmp    80103d04 <mpsearch1+0x61>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103cce:	83 ec 04             	sub    $0x4,%esp
80103cd1:	6a 04                	push   $0x4
80103cd3:	68 74 8f 10 80       	push   $0x80108f74
80103cd8:	ff 75 f4             	pushl  -0xc(%ebp)
80103cdb:	e8 ac 1b 00 00       	call   8010588c <memcmp>
80103ce0:	83 c4 10             	add    $0x10,%esp
80103ce3:	85 c0                	test   %eax,%eax
80103ce5:	75 19                	jne    80103d00 <mpsearch1+0x5d>
80103ce7:	83 ec 08             	sub    $0x8,%esp
80103cea:	6a 10                	push   $0x10
80103cec:	ff 75 f4             	pushl  -0xc(%ebp)
80103cef:	e8 73 ff ff ff       	call   80103c67 <sum>
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	84 c0                	test   %al,%al
80103cf9:	75 05                	jne    80103d00 <mpsearch1+0x5d>
      return (struct mp*)p;
80103cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfe:	eb 11                	jmp    80103d11 <mpsearch1+0x6e>
  for(p = addr; p < e; p += sizeof(struct mp))
80103d00:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d0a:	72 c2                	jb     80103cce <mpsearch1+0x2b>
  return 0;
80103d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d11:	c9                   	leave  
80103d12:	c3                   	ret    

80103d13 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103d13:	f3 0f 1e fb          	endbr32 
80103d17:	55                   	push   %ebp
80103d18:	89 e5                	mov    %esp,%ebp
80103d1a:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103d1d:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d27:	83 c0 0f             	add    $0xf,%eax
80103d2a:	0f b6 00             	movzbl (%eax),%eax
80103d2d:	0f b6 c0             	movzbl %al,%eax
80103d30:	c1 e0 08             	shl    $0x8,%eax
80103d33:	89 c2                	mov    %eax,%edx
80103d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d38:	83 c0 0e             	add    $0xe,%eax
80103d3b:	0f b6 00             	movzbl (%eax),%eax
80103d3e:	0f b6 c0             	movzbl %al,%eax
80103d41:	09 d0                	or     %edx,%eax
80103d43:	c1 e0 04             	shl    $0x4,%eax
80103d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d4d:	74 21                	je     80103d70 <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
80103d4f:	83 ec 08             	sub    $0x8,%esp
80103d52:	68 00 04 00 00       	push   $0x400
80103d57:	ff 75 f0             	pushl  -0x10(%ebp)
80103d5a:	e8 44 ff ff ff       	call   80103ca3 <mpsearch1>
80103d5f:	83 c4 10             	add    $0x10,%esp
80103d62:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d69:	74 51                	je     80103dbc <mpsearch+0xa9>
      return mp;
80103d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d6e:	eb 61                	jmp    80103dd1 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d73:	83 c0 14             	add    $0x14,%eax
80103d76:	0f b6 00             	movzbl (%eax),%eax
80103d79:	0f b6 c0             	movzbl %al,%eax
80103d7c:	c1 e0 08             	shl    $0x8,%eax
80103d7f:	89 c2                	mov    %eax,%edx
80103d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d84:	83 c0 13             	add    $0x13,%eax
80103d87:	0f b6 00             	movzbl (%eax),%eax
80103d8a:	0f b6 c0             	movzbl %al,%eax
80103d8d:	09 d0                	or     %edx,%eax
80103d8f:	c1 e0 0a             	shl    $0xa,%eax
80103d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d98:	2d 00 04 00 00       	sub    $0x400,%eax
80103d9d:	83 ec 08             	sub    $0x8,%esp
80103da0:	68 00 04 00 00       	push   $0x400
80103da5:	50                   	push   %eax
80103da6:	e8 f8 fe ff ff       	call   80103ca3 <mpsearch1>
80103dab:	83 c4 10             	add    $0x10,%esp
80103dae:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103db1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103db5:	74 05                	je     80103dbc <mpsearch+0xa9>
      return mp;
80103db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103dba:	eb 15                	jmp    80103dd1 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103dbc:	83 ec 08             	sub    $0x8,%esp
80103dbf:	68 00 00 01 00       	push   $0x10000
80103dc4:	68 00 00 0f 00       	push   $0xf0000
80103dc9:	e8 d5 fe ff ff       	call   80103ca3 <mpsearch1>
80103dce:	83 c4 10             	add    $0x10,%esp
}
80103dd1:	c9                   	leave  
80103dd2:	c3                   	ret    

80103dd3 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103dd3:	f3 0f 1e fb          	endbr32 
80103dd7:	55                   	push   %ebp
80103dd8:	89 e5                	mov    %esp,%ebp
80103dda:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ddd:	e8 31 ff ff ff       	call   80103d13 <mpsearch>
80103de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103de9:	74 0a                	je     80103df5 <mpconfig+0x22>
80103deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dee:	8b 40 04             	mov    0x4(%eax),%eax
80103df1:	85 c0                	test   %eax,%eax
80103df3:	75 0a                	jne    80103dff <mpconfig+0x2c>
    return 0;
80103df5:	b8 00 00 00 00       	mov    $0x0,%eax
80103dfa:	e9 81 00 00 00       	jmp    80103e80 <mpconfig+0xad>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e02:	8b 40 04             	mov    0x4(%eax),%eax
80103e05:	83 ec 0c             	sub    $0xc,%esp
80103e08:	50                   	push   %eax
80103e09:	e8 f2 fd ff ff       	call   80103c00 <p2v>
80103e0e:	83 c4 10             	add    $0x10,%esp
80103e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103e14:	83 ec 04             	sub    $0x4,%esp
80103e17:	6a 04                	push   $0x4
80103e19:	68 79 8f 10 80       	push   $0x80108f79
80103e1e:	ff 75 f0             	pushl  -0x10(%ebp)
80103e21:	e8 66 1a 00 00       	call   8010588c <memcmp>
80103e26:	83 c4 10             	add    $0x10,%esp
80103e29:	85 c0                	test   %eax,%eax
80103e2b:	74 07                	je     80103e34 <mpconfig+0x61>
    return 0;
80103e2d:	b8 00 00 00 00       	mov    $0x0,%eax
80103e32:	eb 4c                	jmp    80103e80 <mpconfig+0xad>
  if(conf->version != 1 && conf->version != 4)
80103e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e37:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e3b:	3c 01                	cmp    $0x1,%al
80103e3d:	74 12                	je     80103e51 <mpconfig+0x7e>
80103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e42:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e46:	3c 04                	cmp    $0x4,%al
80103e48:	74 07                	je     80103e51 <mpconfig+0x7e>
    return 0;
80103e4a:	b8 00 00 00 00       	mov    $0x0,%eax
80103e4f:	eb 2f                	jmp    80103e80 <mpconfig+0xad>
  if(sum((uchar*)conf, conf->length) != 0)
80103e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e54:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e58:	0f b7 c0             	movzwl %ax,%eax
80103e5b:	83 ec 08             	sub    $0x8,%esp
80103e5e:	50                   	push   %eax
80103e5f:	ff 75 f0             	pushl  -0x10(%ebp)
80103e62:	e8 00 fe ff ff       	call   80103c67 <sum>
80103e67:	83 c4 10             	add    $0x10,%esp
80103e6a:	84 c0                	test   %al,%al
80103e6c:	74 07                	je     80103e75 <mpconfig+0xa2>
    return 0;
80103e6e:	b8 00 00 00 00       	mov    $0x0,%eax
80103e73:	eb 0b                	jmp    80103e80 <mpconfig+0xad>
  *pmp = mp;
80103e75:	8b 45 08             	mov    0x8(%ebp),%eax
80103e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e7b:	89 10                	mov    %edx,(%eax)
  return conf;
80103e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e80:	c9                   	leave  
80103e81:	c3                   	ret    

80103e82 <mpinit>:

void
mpinit(void)
{
80103e82:	f3 0f 1e fb          	endbr32 
80103e86:	55                   	push   %ebp
80103e87:	89 e5                	mov    %esp,%ebp
80103e89:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103e8c:	c7 05 44 c6 10 80 60 	movl   $0x80113360,0x8010c644
80103e93:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103e9c:	50                   	push   %eax
80103e9d:	e8 31 ff ff ff       	call   80103dd3 <mpconfig>
80103ea2:	83 c4 10             	add    $0x10,%esp
80103ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ea8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103eac:	0f 84 ba 01 00 00    	je     8010406c <mpinit+0x1ea>
    return;
  ismp = 1;
80103eb2:	c7 05 44 33 11 80 01 	movl   $0x1,0x80113344
80103eb9:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ebf:	8b 40 24             	mov    0x24(%eax),%eax
80103ec2:	a3 5c 32 11 80       	mov    %eax,0x8011325c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103eca:	83 c0 2c             	add    $0x2c,%eax
80103ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ed3:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ed7:	0f b7 d0             	movzwl %ax,%edx
80103eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103edd:	01 d0                	add    %edx,%eax
80103edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ee2:	e9 16 01 00 00       	jmp    80103ffd <mpinit+0x17b>
    switch(*p){
80103ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eea:	0f b6 00             	movzbl (%eax),%eax
80103eed:	0f b6 c0             	movzbl %al,%eax
80103ef0:	83 f8 04             	cmp    $0x4,%eax
80103ef3:	0f 8f e0 00 00 00    	jg     80103fd9 <mpinit+0x157>
80103ef9:	83 f8 03             	cmp    $0x3,%eax
80103efc:	0f 8d d1 00 00 00    	jge    80103fd3 <mpinit+0x151>
80103f02:	83 f8 02             	cmp    $0x2,%eax
80103f05:	0f 84 b0 00 00 00    	je     80103fbb <mpinit+0x139>
80103f0b:	83 f8 02             	cmp    $0x2,%eax
80103f0e:	0f 8f c5 00 00 00    	jg     80103fd9 <mpinit+0x157>
80103f14:	85 c0                	test   %eax,%eax
80103f16:	74 0e                	je     80103f26 <mpinit+0xa4>
80103f18:	83 f8 01             	cmp    $0x1,%eax
80103f1b:	0f 84 b2 00 00 00    	je     80103fd3 <mpinit+0x151>
80103f21:	e9 b3 00 00 00       	jmp    80103fd9 <mpinit+0x157>
    case MPPROC:
      proc = (struct mpproc*)p;
80103f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu != proc->apicid){
80103f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f2f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f33:	0f b6 d0             	movzbl %al,%edx
80103f36:	a1 40 39 11 80       	mov    0x80113940,%eax
80103f3b:	39 c2                	cmp    %eax,%edx
80103f3d:	74 2b                	je     80103f6a <mpinit+0xe8>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f42:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f46:	0f b6 d0             	movzbl %al,%edx
80103f49:	a1 40 39 11 80       	mov    0x80113940,%eax
80103f4e:	83 ec 04             	sub    $0x4,%esp
80103f51:	52                   	push   %edx
80103f52:	50                   	push   %eax
80103f53:	68 7e 8f 10 80       	push   $0x80108f7e
80103f58:	e8 81 c4 ff ff       	call   801003de <cprintf>
80103f5d:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103f60:	c7 05 44 33 11 80 00 	movl   $0x0,0x80113344
80103f67:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f6d:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103f71:	0f b6 c0             	movzbl %al,%eax
80103f74:	83 e0 02             	and    $0x2,%eax
80103f77:	85 c0                	test   %eax,%eax
80103f79:	74 15                	je     80103f90 <mpinit+0x10e>
        bcpu = &cpus[ncpu];
80103f7b:	a1 40 39 11 80       	mov    0x80113940,%eax
80103f80:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f86:	05 60 33 11 80       	add    $0x80113360,%eax
80103f8b:	a3 44 c6 10 80       	mov    %eax,0x8010c644
      cpus[ncpu].id = ncpu;
80103f90:	8b 15 40 39 11 80    	mov    0x80113940,%edx
80103f96:	a1 40 39 11 80       	mov    0x80113940,%eax
80103f9b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103fa1:	05 60 33 11 80       	add    $0x80113360,%eax
80103fa6:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103fa8:	a1 40 39 11 80       	mov    0x80113940,%eax
80103fad:	83 c0 01             	add    $0x1,%eax
80103fb0:	a3 40 39 11 80       	mov    %eax,0x80113940
      p += sizeof(struct mpproc);
80103fb5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103fb9:	eb 42                	jmp    80103ffd <mpinit+0x17b>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
      ioapicid = ioapic->apicno;
80103fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103fc4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103fc8:	a2 40 33 11 80       	mov    %al,0x80113340
      p += sizeof(struct mpioapic);
80103fcd:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103fd1:	eb 2a                	jmp    80103ffd <mpinit+0x17b>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103fd3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103fd7:	eb 24                	jmp    80103ffd <mpinit+0x17b>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fdc:	0f b6 00             	movzbl (%eax),%eax
80103fdf:	0f b6 c0             	movzbl %al,%eax
80103fe2:	83 ec 08             	sub    $0x8,%esp
80103fe5:	50                   	push   %eax
80103fe6:	68 9c 8f 10 80       	push   $0x80108f9c
80103feb:	e8 ee c3 ff ff       	call   801003de <cprintf>
80103ff0:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ff3:	c7 05 44 33 11 80 00 	movl   $0x0,0x80113344
80103ffa:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104000:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104003:	0f 82 de fe ff ff    	jb     80103ee7 <mpinit+0x65>
    }
  }
  if(!ismp){
80104009:	a1 44 33 11 80       	mov    0x80113344,%eax
8010400e:	85 c0                	test   %eax,%eax
80104010:	75 1d                	jne    8010402f <mpinit+0x1ad>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104012:	c7 05 40 39 11 80 01 	movl   $0x1,0x80113940
80104019:	00 00 00 
    lapic = 0;
8010401c:	c7 05 5c 32 11 80 00 	movl   $0x0,0x8011325c
80104023:	00 00 00 
    ioapicid = 0;
80104026:	c6 05 40 33 11 80 00 	movb   $0x0,0x80113340
    return;
8010402d:	eb 3e                	jmp    8010406d <mpinit+0x1eb>
  }

  if(mp->imcrp){
8010402f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104032:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104036:	84 c0                	test   %al,%al
80104038:	74 33                	je     8010406d <mpinit+0x1eb>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010403a:	83 ec 08             	sub    $0x8,%esp
8010403d:	6a 70                	push   $0x70
8010403f:	6a 22                	push   $0x22
80104041:	e8 e4 fb ff ff       	call   80103c2a <outb>
80104046:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104049:	83 ec 0c             	sub    $0xc,%esp
8010404c:	6a 23                	push   $0x23
8010404e:	e8 ba fb ff ff       	call   80103c0d <inb>
80104053:	83 c4 10             	add    $0x10,%esp
80104056:	83 c8 01             	or     $0x1,%eax
80104059:	0f b6 c0             	movzbl %al,%eax
8010405c:	83 ec 08             	sub    $0x8,%esp
8010405f:	50                   	push   %eax
80104060:	6a 23                	push   $0x23
80104062:	e8 c3 fb ff ff       	call   80103c2a <outb>
80104067:	83 c4 10             	add    $0x10,%esp
8010406a:	eb 01                	jmp    8010406d <mpinit+0x1eb>
    return;
8010406c:	90                   	nop
  }
}
8010406d:	c9                   	leave  
8010406e:	c3                   	ret    

8010406f <outb>:
{
8010406f:	55                   	push   %ebp
80104070:	89 e5                	mov    %esp,%ebp
80104072:	83 ec 08             	sub    $0x8,%esp
80104075:	8b 45 08             	mov    0x8(%ebp),%eax
80104078:	8b 55 0c             	mov    0xc(%ebp),%edx
8010407b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010407f:	89 d0                	mov    %edx,%eax
80104081:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104084:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104088:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010408c:	ee                   	out    %al,(%dx)
}
8010408d:	90                   	nop
8010408e:	c9                   	leave  
8010408f:	c3                   	ret    

80104090 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	83 ec 04             	sub    $0x4,%esp
8010409a:	8b 45 08             	mov    0x8(%ebp),%eax
8010409d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801040a1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040a5:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
801040ab:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040af:	0f b6 c0             	movzbl %al,%eax
801040b2:	50                   	push   %eax
801040b3:	6a 21                	push   $0x21
801040b5:	e8 b5 ff ff ff       	call   8010406f <outb>
801040ba:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
801040bd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801040c1:	66 c1 e8 08          	shr    $0x8,%ax
801040c5:	0f b6 c0             	movzbl %al,%eax
801040c8:	50                   	push   %eax
801040c9:	68 a1 00 00 00       	push   $0xa1
801040ce:	e8 9c ff ff ff       	call   8010406f <outb>
801040d3:	83 c4 08             	add    $0x8,%esp
}
801040d6:	90                   	nop
801040d7:	c9                   	leave  
801040d8:	c3                   	ret    

801040d9 <picenable>:

void
picenable(int irq)
{
801040d9:	f3 0f 1e fb          	endbr32 
801040dd:	55                   	push   %ebp
801040de:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
801040e0:	8b 45 08             	mov    0x8(%ebp),%eax
801040e3:	ba 01 00 00 00       	mov    $0x1,%edx
801040e8:	89 c1                	mov    %eax,%ecx
801040ea:	d3 e2                	shl    %cl,%edx
801040ec:	89 d0                	mov    %edx,%eax
801040ee:	f7 d0                	not    %eax
801040f0:	89 c2                	mov    %eax,%edx
801040f2:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040f9:	21 d0                	and    %edx,%eax
801040fb:	0f b7 c0             	movzwl %ax,%eax
801040fe:	50                   	push   %eax
801040ff:	e8 8c ff ff ff       	call   80104090 <picsetmask>
80104104:	83 c4 04             	add    $0x4,%esp
}
80104107:	90                   	nop
80104108:	c9                   	leave  
80104109:	c3                   	ret    

8010410a <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
8010410a:	f3 0f 1e fb          	endbr32 
8010410e:	55                   	push   %ebp
8010410f:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104111:	68 ff 00 00 00       	push   $0xff
80104116:	6a 21                	push   $0x21
80104118:	e8 52 ff ff ff       	call   8010406f <outb>
8010411d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104120:	68 ff 00 00 00       	push   $0xff
80104125:	68 a1 00 00 00       	push   $0xa1
8010412a:	e8 40 ff ff ff       	call   8010406f <outb>
8010412f:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104132:	6a 11                	push   $0x11
80104134:	6a 20                	push   $0x20
80104136:	e8 34 ff ff ff       	call   8010406f <outb>
8010413b:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
8010413e:	6a 20                	push   $0x20
80104140:	6a 21                	push   $0x21
80104142:	e8 28 ff ff ff       	call   8010406f <outb>
80104147:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010414a:	6a 04                	push   $0x4
8010414c:	6a 21                	push   $0x21
8010414e:	e8 1c ff ff ff       	call   8010406f <outb>
80104153:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104156:	6a 03                	push   $0x3
80104158:	6a 21                	push   $0x21
8010415a:	e8 10 ff ff ff       	call   8010406f <outb>
8010415f:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104162:	6a 11                	push   $0x11
80104164:	68 a0 00 00 00       	push   $0xa0
80104169:	e8 01 ff ff ff       	call   8010406f <outb>
8010416e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104171:	6a 28                	push   $0x28
80104173:	68 a1 00 00 00       	push   $0xa1
80104178:	e8 f2 fe ff ff       	call   8010406f <outb>
8010417d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104180:	6a 02                	push   $0x2
80104182:	68 a1 00 00 00       	push   $0xa1
80104187:	e8 e3 fe ff ff       	call   8010406f <outb>
8010418c:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010418f:	6a 03                	push   $0x3
80104191:	68 a1 00 00 00       	push   $0xa1
80104196:	e8 d4 fe ff ff       	call   8010406f <outb>
8010419b:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010419e:	6a 68                	push   $0x68
801041a0:	6a 20                	push   $0x20
801041a2:	e8 c8 fe ff ff       	call   8010406f <outb>
801041a7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801041aa:	6a 0a                	push   $0xa
801041ac:	6a 20                	push   $0x20
801041ae:	e8 bc fe ff ff       	call   8010406f <outb>
801041b3:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801041b6:	6a 68                	push   $0x68
801041b8:	68 a0 00 00 00       	push   $0xa0
801041bd:	e8 ad fe ff ff       	call   8010406f <outb>
801041c2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801041c5:	6a 0a                	push   $0xa
801041c7:	68 a0 00 00 00       	push   $0xa0
801041cc:	e8 9e fe ff ff       	call   8010406f <outb>
801041d1:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801041d4:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801041db:	66 83 f8 ff          	cmp    $0xffff,%ax
801041df:	74 13                	je     801041f4 <picinit+0xea>
    picsetmask(irqmask);
801041e1:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801041e8:	0f b7 c0             	movzwl %ax,%eax
801041eb:	50                   	push   %eax
801041ec:	e8 9f fe ff ff       	call   80104090 <picsetmask>
801041f1:	83 c4 04             	add    $0x4,%esp
}
801041f4:	90                   	nop
801041f5:	c9                   	leave  
801041f6:	c3                   	ret    

801041f7 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801041f7:	f3 0f 1e fb          	endbr32 
801041fb:	55                   	push   %ebp
801041fc:	89 e5                	mov    %esp,%ebp
801041fe:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010420b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104211:	8b 45 0c             	mov    0xc(%ebp),%eax
80104214:	8b 10                	mov    (%eax),%edx
80104216:	8b 45 08             	mov    0x8(%ebp),%eax
80104219:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010421b:	e8 de cd ff ff       	call   80100ffe <filealloc>
80104220:	8b 55 08             	mov    0x8(%ebp),%edx
80104223:	89 02                	mov    %eax,(%edx)
80104225:	8b 45 08             	mov    0x8(%ebp),%eax
80104228:	8b 00                	mov    (%eax),%eax
8010422a:	85 c0                	test   %eax,%eax
8010422c:	0f 84 c8 00 00 00    	je     801042fa <pipealloc+0x103>
80104232:	e8 c7 cd ff ff       	call   80100ffe <filealloc>
80104237:	8b 55 0c             	mov    0xc(%ebp),%edx
8010423a:	89 02                	mov    %eax,(%edx)
8010423c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010423f:	8b 00                	mov    (%eax),%eax
80104241:	85 c0                	test   %eax,%eax
80104243:	0f 84 b1 00 00 00    	je     801042fa <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104249:	e8 29 eb ff ff       	call   80102d77 <kalloc>
8010424e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104255:	0f 84 a2 00 00 00    	je     801042fd <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104265:	00 00 00 
  p->writeopen = 1;
80104268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426b:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104272:	00 00 00 
  p->nwrite = 0;
80104275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104278:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010427f:	00 00 00 
  p->nread = 0;
80104282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104285:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010428c:	00 00 00 
  initlock(&p->lock, "pipe");
8010428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104292:	83 ec 08             	sub    $0x8,%esp
80104295:	68 bc 8f 10 80       	push   $0x80108fbc
8010429a:	50                   	push   %eax
8010429b:	e8 df 12 00 00       	call   8010557f <initlock>
801042a0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801042a3:	8b 45 08             	mov    0x8(%ebp),%eax
801042a6:	8b 00                	mov    (%eax),%eax
801042a8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801042ae:	8b 45 08             	mov    0x8(%ebp),%eax
801042b1:	8b 00                	mov    (%eax),%eax
801042b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801042b7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ba:	8b 00                	mov    (%eax),%eax
801042bc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801042c0:	8b 45 08             	mov    0x8(%ebp),%eax
801042c3:	8b 00                	mov    (%eax),%eax
801042c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042c8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801042cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ce:	8b 00                	mov    (%eax),%eax
801042d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801042d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801042d9:	8b 00                	mov    (%eax),%eax
801042db:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801042df:	8b 45 0c             	mov    0xc(%ebp),%eax
801042e2:	8b 00                	mov    (%eax),%eax
801042e4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801042e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801042eb:	8b 00                	mov    (%eax),%eax
801042ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042f0:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801042f3:	b8 00 00 00 00       	mov    $0x0,%eax
801042f8:	eb 51                	jmp    8010434b <pipealloc+0x154>
    goto bad;
801042fa:	90                   	nop
801042fb:	eb 01                	jmp    801042fe <pipealloc+0x107>
    goto bad;
801042fd:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801042fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104302:	74 0e                	je     80104312 <pipealloc+0x11b>
    kfree((char*)p);
80104304:	83 ec 0c             	sub    $0xc,%esp
80104307:	ff 75 f4             	pushl  -0xc(%ebp)
8010430a:	e8 c7 e9 ff ff       	call   80102cd6 <kfree>
8010430f:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104312:	8b 45 08             	mov    0x8(%ebp),%eax
80104315:	8b 00                	mov    (%eax),%eax
80104317:	85 c0                	test   %eax,%eax
80104319:	74 11                	je     8010432c <pipealloc+0x135>
    fileclose(*f0);
8010431b:	8b 45 08             	mov    0x8(%ebp),%eax
8010431e:	8b 00                	mov    (%eax),%eax
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	50                   	push   %eax
80104324:	e8 9b cd ff ff       	call   801010c4 <fileclose>
80104329:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010432c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432f:	8b 00                	mov    (%eax),%eax
80104331:	85 c0                	test   %eax,%eax
80104333:	74 11                	je     80104346 <pipealloc+0x14f>
    fileclose(*f1);
80104335:	8b 45 0c             	mov    0xc(%ebp),%eax
80104338:	8b 00                	mov    (%eax),%eax
8010433a:	83 ec 0c             	sub    $0xc,%esp
8010433d:	50                   	push   %eax
8010433e:	e8 81 cd ff ff       	call   801010c4 <fileclose>
80104343:	83 c4 10             	add    $0x10,%esp
  return -1;
80104346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010434b:	c9                   	leave  
8010434c:	c3                   	ret    

8010434d <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010434d:	f3 0f 1e fb          	endbr32 
80104351:	55                   	push   %ebp
80104352:	89 e5                	mov    %esp,%ebp
80104354:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	50                   	push   %eax
8010435e:	e8 42 12 00 00       	call   801055a5 <acquire>
80104363:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104366:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010436a:	74 23                	je     8010438f <pipeclose+0x42>
    p->writeopen = 0;
8010436c:	8b 45 08             	mov    0x8(%ebp),%eax
8010436f:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104376:	00 00 00 
    wakeup(&p->nread);
80104379:	8b 45 08             	mov    0x8(%ebp),%eax
8010437c:	05 34 02 00 00       	add    $0x234,%eax
80104381:	83 ec 0c             	sub    $0xc,%esp
80104384:	50                   	push   %eax
80104385:	e8 6f 0d 00 00       	call   801050f9 <wakeup>
8010438a:	83 c4 10             	add    $0x10,%esp
8010438d:	eb 21                	jmp    801043b0 <pipeclose+0x63>
  } else {
    p->readopen = 0;
8010438f:	8b 45 08             	mov    0x8(%ebp),%eax
80104392:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104399:	00 00 00 
    wakeup(&p->nwrite);
8010439c:	8b 45 08             	mov    0x8(%ebp),%eax
8010439f:	05 38 02 00 00       	add    $0x238,%eax
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	50                   	push   %eax
801043a8:	e8 4c 0d 00 00       	call   801050f9 <wakeup>
801043ad:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801043b0:	8b 45 08             	mov    0x8(%ebp),%eax
801043b3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801043b9:	85 c0                	test   %eax,%eax
801043bb:	75 2c                	jne    801043e9 <pipeclose+0x9c>
801043bd:	8b 45 08             	mov    0x8(%ebp),%eax
801043c0:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801043c6:	85 c0                	test   %eax,%eax
801043c8:	75 1f                	jne    801043e9 <pipeclose+0x9c>
    release(&p->lock);
801043ca:	8b 45 08             	mov    0x8(%ebp),%eax
801043cd:	83 ec 0c             	sub    $0xc,%esp
801043d0:	50                   	push   %eax
801043d1:	e8 3a 12 00 00       	call   80105610 <release>
801043d6:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801043d9:	83 ec 0c             	sub    $0xc,%esp
801043dc:	ff 75 08             	pushl  0x8(%ebp)
801043df:	e8 f2 e8 ff ff       	call   80102cd6 <kfree>
801043e4:	83 c4 10             	add    $0x10,%esp
801043e7:	eb 10                	jmp    801043f9 <pipeclose+0xac>
  } else
    release(&p->lock);
801043e9:	8b 45 08             	mov    0x8(%ebp),%eax
801043ec:	83 ec 0c             	sub    $0xc,%esp
801043ef:	50                   	push   %eax
801043f0:	e8 1b 12 00 00       	call   80105610 <release>
801043f5:	83 c4 10             	add    $0x10,%esp
}
801043f8:	90                   	nop
801043f9:	90                   	nop
801043fa:	c9                   	leave  
801043fb:	c3                   	ret    

801043fc <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801043fc:	f3 0f 1e fb          	endbr32 
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	50                   	push   %eax
8010440e:	e8 92 11 00 00       	call   801055a5 <acquire>
80104413:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010441d:	e9 ae 00 00 00       	jmp    801044d0 <pipewrite+0xd4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104422:	8b 45 08             	mov    0x8(%ebp),%eax
80104425:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010442b:	85 c0                	test   %eax,%eax
8010442d:	74 0d                	je     8010443c <pipewrite+0x40>
8010442f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104435:	8b 40 24             	mov    0x24(%eax),%eax
80104438:	85 c0                	test   %eax,%eax
8010443a:	74 19                	je     80104455 <pipewrite+0x59>
        release(&p->lock);
8010443c:	8b 45 08             	mov    0x8(%ebp),%eax
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	50                   	push   %eax
80104443:	e8 c8 11 00 00       	call   80105610 <release>
80104448:	83 c4 10             	add    $0x10,%esp
        return -1;
8010444b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104450:	e9 a9 00 00 00       	jmp    801044fe <pipewrite+0x102>
      }
      wakeup(&p->nread);
80104455:	8b 45 08             	mov    0x8(%ebp),%eax
80104458:	05 34 02 00 00       	add    $0x234,%eax
8010445d:	83 ec 0c             	sub    $0xc,%esp
80104460:	50                   	push   %eax
80104461:	e8 93 0c 00 00       	call   801050f9 <wakeup>
80104466:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104469:	8b 45 08             	mov    0x8(%ebp),%eax
8010446c:	8b 55 08             	mov    0x8(%ebp),%edx
8010446f:	81 c2 38 02 00 00    	add    $0x238,%edx
80104475:	83 ec 08             	sub    $0x8,%esp
80104478:	50                   	push   %eax
80104479:	52                   	push   %edx
8010447a:	e8 83 0b 00 00       	call   80105002 <sleep>
8010447f:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104482:	8b 45 08             	mov    0x8(%ebp),%eax
80104485:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010448b:	8b 45 08             	mov    0x8(%ebp),%eax
8010448e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104494:	05 00 02 00 00       	add    $0x200,%eax
80104499:	39 c2                	cmp    %eax,%edx
8010449b:	74 85                	je     80104422 <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010449d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801044a3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801044a6:	8b 45 08             	mov    0x8(%ebp),%eax
801044a9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044af:	8d 48 01             	lea    0x1(%eax),%ecx
801044b2:	8b 55 08             	mov    0x8(%ebp),%edx
801044b5:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801044bb:	25 ff 01 00 00       	and    $0x1ff,%eax
801044c0:	89 c1                	mov    %eax,%ecx
801044c2:	0f b6 13             	movzbl (%ebx),%edx
801044c5:	8b 45 08             	mov    0x8(%ebp),%eax
801044c8:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801044cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d3:	3b 45 10             	cmp    0x10(%ebp),%eax
801044d6:	7c aa                	jl     80104482 <pipewrite+0x86>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801044d8:	8b 45 08             	mov    0x8(%ebp),%eax
801044db:	05 34 02 00 00       	add    $0x234,%eax
801044e0:	83 ec 0c             	sub    $0xc,%esp
801044e3:	50                   	push   %eax
801044e4:	e8 10 0c 00 00       	call   801050f9 <wakeup>
801044e9:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044ec:	8b 45 08             	mov    0x8(%ebp),%eax
801044ef:	83 ec 0c             	sub    $0xc,%esp
801044f2:	50                   	push   %eax
801044f3:	e8 18 11 00 00       	call   80105610 <release>
801044f8:	83 c4 10             	add    $0x10,%esp
  return n;
801044fb:	8b 45 10             	mov    0x10(%ebp),%eax
}
801044fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104501:	c9                   	leave  
80104502:	c3                   	ret    

80104503 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104503:	f3 0f 1e fb          	endbr32 
80104507:	55                   	push   %ebp
80104508:	89 e5                	mov    %esp,%ebp
8010450a:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010450d:	8b 45 08             	mov    0x8(%ebp),%eax
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	50                   	push   %eax
80104514:	e8 8c 10 00 00       	call   801055a5 <acquire>
80104519:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010451c:	eb 3f                	jmp    8010455d <piperead+0x5a>
    if(proc->killed){
8010451e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104524:	8b 40 24             	mov    0x24(%eax),%eax
80104527:	85 c0                	test   %eax,%eax
80104529:	74 19                	je     80104544 <piperead+0x41>
      release(&p->lock);
8010452b:	8b 45 08             	mov    0x8(%ebp),%eax
8010452e:	83 ec 0c             	sub    $0xc,%esp
80104531:	50                   	push   %eax
80104532:	e8 d9 10 00 00       	call   80105610 <release>
80104537:	83 c4 10             	add    $0x10,%esp
      return -1;
8010453a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453f:	e9 be 00 00 00       	jmp    80104602 <piperead+0xff>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104544:	8b 45 08             	mov    0x8(%ebp),%eax
80104547:	8b 55 08             	mov    0x8(%ebp),%edx
8010454a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104550:	83 ec 08             	sub    $0x8,%esp
80104553:	50                   	push   %eax
80104554:	52                   	push   %edx
80104555:	e8 a8 0a 00 00       	call   80105002 <sleep>
8010455a:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010455d:	8b 45 08             	mov    0x8(%ebp),%eax
80104560:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104566:	8b 45 08             	mov    0x8(%ebp),%eax
80104569:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010456f:	39 c2                	cmp    %eax,%edx
80104571:	75 0d                	jne    80104580 <piperead+0x7d>
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
80104576:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010457c:	85 c0                	test   %eax,%eax
8010457e:	75 9e                	jne    8010451e <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104587:	eb 48                	jmp    801045d1 <piperead+0xce>
    if(p->nread == p->nwrite)
80104589:	8b 45 08             	mov    0x8(%ebp),%eax
8010458c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104592:	8b 45 08             	mov    0x8(%ebp),%eax
80104595:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010459b:	39 c2                	cmp    %eax,%edx
8010459d:	74 3c                	je     801045db <piperead+0xd8>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010459f:	8b 45 08             	mov    0x8(%ebp),%eax
801045a2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045a8:	8d 48 01             	lea    0x1(%eax),%ecx
801045ab:	8b 55 08             	mov    0x8(%ebp),%edx
801045ae:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801045b4:	25 ff 01 00 00       	and    $0x1ff,%eax
801045b9:	89 c1                	mov    %eax,%ecx
801045bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045be:	8b 45 0c             	mov    0xc(%ebp),%eax
801045c1:	01 c2                	add    %eax,%edx
801045c3:	8b 45 08             	mov    0x8(%ebp),%eax
801045c6:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
801045cb:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801045cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	3b 45 10             	cmp    0x10(%ebp),%eax
801045d7:	7c b0                	jl     80104589 <piperead+0x86>
801045d9:	eb 01                	jmp    801045dc <piperead+0xd9>
      break;
801045db:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801045dc:	8b 45 08             	mov    0x8(%ebp),%eax
801045df:	05 38 02 00 00       	add    $0x238,%eax
801045e4:	83 ec 0c             	sub    $0xc,%esp
801045e7:	50                   	push   %eax
801045e8:	e8 0c 0b 00 00       	call   801050f9 <wakeup>
801045ed:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801045f0:	8b 45 08             	mov    0x8(%ebp),%eax
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	50                   	push   %eax
801045f7:	e8 14 10 00 00       	call   80105610 <release>
801045fc:	83 c4 10             	add    $0x10,%esp
  return i;
801045ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104602:	c9                   	leave  
80104603:	c3                   	ret    

80104604 <readeflags>:
{
80104604:	55                   	push   %ebp
80104605:	89 e5                	mov    %esp,%ebp
80104607:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010460a:	9c                   	pushf  
8010460b:	58                   	pop    %eax
8010460c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010460f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104612:	c9                   	leave  
80104613:	c3                   	ret    

80104614 <sti>:
{
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104617:	fb                   	sti    
}
80104618:	90                   	nop
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret    

8010461b <hlt>:
{
8010461b:	55                   	push   %ebp
8010461c:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
8010461e:	f4                   	hlt    
}
8010461f:	90                   	nop
80104620:	5d                   	pop    %ebp
80104621:	c3                   	ret    

80104622 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104622:	f3 0f 1e fb          	endbr32 
80104626:	55                   	push   %ebp
80104627:	89 e5                	mov    %esp,%ebp
80104629:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010462c:	83 ec 08             	sub    $0x8,%esp
8010462f:	68 c1 8f 10 80       	push   $0x80108fc1
80104634:	68 60 39 11 80       	push   $0x80113960
80104639:	e8 41 0f 00 00       	call   8010557f <initlock>
8010463e:	83 c4 10             	add    $0x10,%esp
}
80104641:	90                   	nop
80104642:	c9                   	leave  
80104643:	c3                   	ret    

80104644 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104644:	f3 0f 1e fb          	endbr32 
80104648:	55                   	push   %ebp
80104649:	89 e5                	mov    %esp,%ebp
8010464b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010464e:	83 ec 0c             	sub    $0xc,%esp
80104651:	68 60 39 11 80       	push   $0x80113960
80104656:	e8 4a 0f 00 00       	call   801055a5 <acquire>
8010465b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010465e:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104665:	eb 11                	jmp    80104678 <allocproc+0x34>
    if(p->state == UNUSED)
80104667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466a:	8b 40 0c             	mov    0xc(%eax),%eax
8010466d:	85 c0                	test   %eax,%eax
8010466f:	74 2a                	je     8010469b <allocproc+0x57>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104671:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104678:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
8010467f:	72 e6                	jb     80104667 <allocproc+0x23>
      goto found;
  release(&ptable.lock);
80104681:	83 ec 0c             	sub    $0xc,%esp
80104684:	68 60 39 11 80       	push   $0x80113960
80104689:	e8 82 0f 00 00       	call   80105610 <release>
8010468e:	83 c4 10             	add    $0x10,%esp
  return 0;
80104691:	b8 00 00 00 00       	mov    $0x0,%eax
80104696:	e9 19 01 00 00       	jmp    801047b4 <allocproc+0x170>
      goto found;
8010469b:	90                   	nop
8010469c:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
801046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a3:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801046aa:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801046af:	8d 50 01             	lea    0x1(%eax),%edx
801046b2:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801046b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046bb:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801046be:	83 ec 0c             	sub    $0xc,%esp
801046c1:	68 60 39 11 80       	push   $0x80113960
801046c6:	e8 45 0f 00 00       	call   80105610 <release>
801046cb:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801046ce:	e8 a4 e6 ff ff       	call   80102d77 <kalloc>
801046d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046d6:	89 42 08             	mov    %eax,0x8(%edx)
801046d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dc:	8b 40 08             	mov    0x8(%eax),%eax
801046df:	85 c0                	test   %eax,%eax
801046e1:	75 14                	jne    801046f7 <allocproc+0xb3>
    p->state = UNUSED;
801046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801046ed:	b8 00 00 00 00       	mov    $0x0,%eax
801046f2:	e9 bd 00 00 00       	jmp    801047b4 <allocproc+0x170>
  }
  sp = p->kstack + KSTACKSIZE;
801046f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fa:	8b 40 08             	mov    0x8(%eax),%eax
801046fd:	05 00 10 00 00       	add    $0x1000,%eax
80104702:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104705:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010470f:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104712:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104716:	ba 3f 6d 10 80       	mov    $0x80106d3f,%edx
8010471b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010471e:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104720:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104727:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010472a:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104730:	8b 40 1c             	mov    0x1c(%eax),%eax
80104733:	83 ec 04             	sub    $0x4,%esp
80104736:	6a 14                	push   $0x14
80104738:	6a 00                	push   $0x0
8010473a:	50                   	push   %eax
8010473b:	e8 e1 10 00 00       	call   80105821 <memset>
80104740:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104746:	8b 40 1c             	mov    0x1c(%eax),%eax
80104749:	ba b8 4f 10 80       	mov    $0x80104fb8,%edx
8010474e:	89 50 10             	mov    %edx,0x10(%eax)

  acquire(&tickslock);
80104751:	83 ec 0c             	sub    $0xc,%esp
80104754:	68 a0 5d 11 80       	push   $0x80115da0
80104759:	e8 47 0e 00 00       	call   801055a5 <acquire>
8010475e:	83 c4 10             	add    $0x10,%esp
  p->ctime = ticks;
80104761:	8b 15 e0 65 11 80    	mov    0x801165e0,%edx
80104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476a:	89 50 7c             	mov    %edx,0x7c(%eax)
  release(&tickslock);
8010476d:	83 ec 0c             	sub    $0xc,%esp
80104770:	68 a0 5d 11 80       	push   $0x80115da0
80104775:	e8 96 0e 00 00       	call   80105610 <release>
8010477a:	83 c4 10             	add    $0x10,%esp
  p->stime = 0;
8010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104780:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104787:	00 00 00 
  p->retime = 0;
8010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478d:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104794:	00 00 00 
  p->rutime = 0;
80104797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479a:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801047a1:	00 00 00 
  p->ttime = 0;
801047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801047ae:	00 00 00 

  return p;
801047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801047b4:	c9                   	leave  
801047b5:	c3                   	ret    

801047b6 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801047b6:	f3 0f 1e fb          	endbr32 
801047ba:	55                   	push   %ebp
801047bb:	89 e5                	mov    %esp,%ebp
801047bd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801047c0:	e8 7f fe ff ff       	call   80104644 <allocproc>
801047c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801047c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cb:	a3 48 c6 10 80       	mov    %eax,0x8010c648
  if((p->pgdir = setupkvm()) == 0)
801047d0:	e8 60 3c 00 00       	call   80108435 <setupkvm>
801047d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047d8:	89 42 04             	mov    %eax,0x4(%edx)
801047db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047de:	8b 40 04             	mov    0x4(%eax),%eax
801047e1:	85 c0                	test   %eax,%eax
801047e3:	75 0d                	jne    801047f2 <userinit+0x3c>
    panic("userinit: out of memory?");
801047e5:	83 ec 0c             	sub    $0xc,%esp
801047e8:	68 c8 8f 10 80       	push   $0x80108fc8
801047ed:	e8 a5 bd ff ff       	call   80100597 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047f2:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fa:	8b 40 04             	mov    0x4(%eax),%eax
801047fd:	83 ec 04             	sub    $0x4,%esp
80104800:	52                   	push   %edx
80104801:	68 e0 c4 10 80       	push   $0x8010c4e0
80104806:	50                   	push   %eax
80104807:	e8 94 3e 00 00       	call   801086a0 <inituvm>
8010480c:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010480f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104812:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481b:	8b 40 18             	mov    0x18(%eax),%eax
8010481e:	83 ec 04             	sub    $0x4,%esp
80104821:	6a 4c                	push   $0x4c
80104823:	6a 00                	push   $0x0
80104825:	50                   	push   %eax
80104826:	e8 f6 0f 00 00       	call   80105821 <memset>
8010482b:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104831:	8b 40 18             	mov    0x18(%eax),%eax
80104834:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010483a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483d:	8b 40 18             	mov    0x18(%eax),%eax
80104840:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104849:	8b 50 18             	mov    0x18(%eax),%edx
8010484c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484f:	8b 40 18             	mov    0x18(%eax),%eax
80104852:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104856:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010485a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485d:	8b 50 18             	mov    0x18(%eax),%edx
80104860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104863:	8b 40 18             	mov    0x18(%eax),%eax
80104866:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010486a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010486e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104871:	8b 40 18             	mov    0x18(%eax),%eax
80104874:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010487b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487e:	8b 40 18             	mov    0x18(%eax),%eax
80104881:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488b:	8b 40 18             	mov    0x18(%eax),%eax
8010488e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104898:	83 c0 6c             	add    $0x6c,%eax
8010489b:	83 ec 04             	sub    $0x4,%esp
8010489e:	6a 10                	push   $0x10
801048a0:	68 e1 8f 10 80       	push   $0x80108fe1
801048a5:	50                   	push   %eax
801048a6:	e8 91 11 00 00       	call   80105a3c <safestrcpy>
801048ab:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801048ae:	83 ec 0c             	sub    $0xc,%esp
801048b1:	68 ea 8f 10 80       	push   $0x80108fea
801048b6:	e8 3f dd ff ff       	call   801025fa <namei>
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048c1:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801048c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

}
801048ce:	90                   	nop
801048cf:	c9                   	leave  
801048d0:	c3                   	ret    

801048d1 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048d1:	f3 0f 1e fb          	endbr32 
801048d5:	55                   	push   %ebp
801048d6:	89 e5                	mov    %esp,%ebp
801048d8:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801048db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e1:	8b 00                	mov    (%eax),%eax
801048e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801048e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048ea:	7e 31                	jle    8010491d <growproc+0x4c>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801048ec:	8b 55 08             	mov    0x8(%ebp),%edx
801048ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f2:	01 c2                	add    %eax,%edx
801048f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fa:	8b 40 04             	mov    0x4(%eax),%eax
801048fd:	83 ec 04             	sub    $0x4,%esp
80104900:	52                   	push   %edx
80104901:	ff 75 f4             	pushl  -0xc(%ebp)
80104904:	50                   	push   %eax
80104905:	e8 eb 3e 00 00       	call   801087f5 <allocuvm>
8010490a:	83 c4 10             	add    $0x10,%esp
8010490d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104914:	75 3e                	jne    80104954 <growproc+0x83>
      return -1;
80104916:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010491b:	eb 59                	jmp    80104976 <growproc+0xa5>
  } else if(n < 0){
8010491d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104921:	79 31                	jns    80104954 <growproc+0x83>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104923:	8b 55 08             	mov    0x8(%ebp),%edx
80104926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104929:	01 c2                	add    %eax,%edx
8010492b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104931:	8b 40 04             	mov    0x4(%eax),%eax
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	52                   	push   %edx
80104938:	ff 75 f4             	pushl  -0xc(%ebp)
8010493b:	50                   	push   %eax
8010493c:	e8 7f 3f 00 00       	call   801088c0 <deallocuvm>
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010494b:	75 07                	jne    80104954 <growproc+0x83>
      return -1;
8010494d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104952:	eb 22                	jmp    80104976 <growproc+0xa5>
  }
  proc->sz = sz;
80104954:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010495d:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010495f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104965:	83 ec 0c             	sub    $0xc,%esp
80104968:	50                   	push   %eax
80104969:	e8 ba 3b 00 00       	call   80108528 <switchuvm>
8010496e:	83 c4 10             	add    $0x10,%esp
  return 0;
80104971:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104976:	c9                   	leave  
80104977:	c3                   	ret    

80104978 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104978:	f3 0f 1e fb          	endbr32 
8010497c:	55                   	push   %ebp
8010497d:	89 e5                	mov    %esp,%ebp
8010497f:	57                   	push   %edi
80104980:	56                   	push   %esi
80104981:	53                   	push   %ebx
80104982:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104985:	e8 ba fc ff ff       	call   80104644 <allocproc>
8010498a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010498d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104991:	75 0a                	jne    8010499d <fork+0x25>
    return -1;
80104993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104998:	e9 64 01 00 00       	jmp    80104b01 <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010499d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a3:	8b 10                	mov    (%eax),%edx
801049a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ab:	8b 40 04             	mov    0x4(%eax),%eax
801049ae:	83 ec 08             	sub    $0x8,%esp
801049b1:	52                   	push   %edx
801049b2:	50                   	push   %eax
801049b3:	e8 b2 40 00 00       	call   80108a6a <copyuvm>
801049b8:	83 c4 10             	add    $0x10,%esp
801049bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801049be:	89 42 04             	mov    %eax,0x4(%edx)
801049c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c4:	8b 40 04             	mov    0x4(%eax),%eax
801049c7:	85 c0                	test   %eax,%eax
801049c9:	75 30                	jne    801049fb <fork+0x83>
    kfree(np->kstack);
801049cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ce:	8b 40 08             	mov    0x8(%eax),%eax
801049d1:	83 ec 0c             	sub    $0xc,%esp
801049d4:	50                   	push   %eax
801049d5:	e8 fc e2 ff ff       	call   80102cd6 <kfree>
801049da:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801049dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801049e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801049f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f6:	e9 06 01 00 00       	jmp    80104b01 <fork+0x189>
  }

  np->sz = proc->sz;
801049fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a01:	8b 10                	mov    (%eax),%edx
80104a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a06:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a08:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a12:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104a15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a1b:	8b 48 18             	mov    0x18(%eax),%ecx
80104a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a21:	8b 40 18             	mov    0x18(%eax),%eax
80104a24:	89 c2                	mov    %eax,%edx
80104a26:	89 cb                	mov    %ecx,%ebx
80104a28:	b8 13 00 00 00       	mov    $0x13,%eax
80104a2d:	89 d7                	mov    %edx,%edi
80104a2f:	89 de                	mov    %ebx,%esi
80104a31:	89 c1                	mov    %eax,%ecx
80104a33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a38:	8b 40 18             	mov    0x18(%eax),%eax
80104a3b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a49:	eb 41                	jmp    80104a8c <fork+0x114>
    if(proc->ofile[i])
80104a4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a54:	83 c2 08             	add    $0x8,%edx
80104a57:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a5b:	85 c0                	test   %eax,%eax
80104a5d:	74 29                	je     80104a88 <fork+0x110>
      np->ofile[i] = filedup(proc->ofile[i]);
80104a5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a68:	83 c2 08             	add    $0x8,%edx
80104a6b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a6f:	83 ec 0c             	sub    $0xc,%esp
80104a72:	50                   	push   %eax
80104a73:	e8 f7 c5 ff ff       	call   8010106f <filedup>
80104a78:	83 c4 10             	add    $0x10,%esp
80104a7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a7e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104a81:	83 c1 08             	add    $0x8,%ecx
80104a84:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104a88:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a8c:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a90:	7e b9                	jle    80104a4b <fork+0xd3>
  np->cwd = idup(proc->cwd);
80104a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a98:	8b 40 68             	mov    0x68(%eax),%eax
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	50                   	push   %eax
80104a9f:	e8 2f cf ff ff       	call   801019d3 <idup>
80104aa4:	83 c4 10             	add    $0x10,%esp
80104aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104aaa:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104aad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab3:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab9:	83 c0 6c             	add    $0x6c,%eax
80104abc:	83 ec 04             	sub    $0x4,%esp
80104abf:	6a 10                	push   $0x10
80104ac1:	52                   	push   %edx
80104ac2:	50                   	push   %eax
80104ac3:	e8 74 0f 00 00       	call   80105a3c <safestrcpy>
80104ac8:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ace:	8b 40 10             	mov    0x10(%eax),%eax
80104ad1:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	68 60 39 11 80       	push   $0x80113960
80104adc:	e8 c4 0a 00 00       	call   801055a5 <acquire>
80104ae1:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ae7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104aee:	83 ec 0c             	sub    $0xc,%esp
80104af1:	68 60 39 11 80       	push   $0x80113960
80104af6:	e8 15 0b 00 00       	call   80105610 <release>
80104afb:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104afe:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b04:	5b                   	pop    %ebx
80104b05:	5e                   	pop    %esi
80104b06:	5f                   	pop    %edi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret    

80104b09 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104b09:	f3 0f 1e fb          	endbr32 
80104b0d:	55                   	push   %ebp
80104b0e:	89 e5                	mov    %esp,%ebp
80104b10:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104b13:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b1a:	a1 48 c6 10 80       	mov    0x8010c648,%eax
80104b1f:	39 c2                	cmp    %eax,%edx
80104b21:	75 0d                	jne    80104b30 <exit+0x27>
    panic("init exiting");
80104b23:	83 ec 0c             	sub    $0xc,%esp
80104b26:	68 ec 8f 10 80       	push   $0x80108fec
80104b2b:	e8 67 ba ff ff       	call   80100597 <panic>

  


  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104b37:	eb 48                	jmp    80104b81 <exit+0x78>
    if(proc->ofile[fd]){
80104b39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b42:	83 c2 08             	add    $0x8,%edx
80104b45:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b49:	85 c0                	test   %eax,%eax
80104b4b:	74 30                	je     80104b7d <exit+0x74>
      fileclose(proc->ofile[fd]);
80104b4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b56:	83 c2 08             	add    $0x8,%edx
80104b59:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b5d:	83 ec 0c             	sub    $0xc,%esp
80104b60:	50                   	push   %eax
80104b61:	e8 5e c5 ff ff       	call   801010c4 <fileclose>
80104b66:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104b69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b72:	83 c2 08             	add    $0x8,%edx
80104b75:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104b7c:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104b7d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104b81:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104b85:	7e b2                	jle    80104b39 <exit+0x30>
    }
  }

  begin_op();
80104b87:	e8 11 eb ff ff       	call   8010369d <begin_op>
  iput(proc->cwd);
80104b8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b92:	8b 40 68             	mov    0x68(%eax),%eax
80104b95:	83 ec 0c             	sub    $0xc,%esp
80104b98:	50                   	push   %eax
80104b99:	e8 4b d0 ff ff       	call   80101be9 <iput>
80104b9e:	83 c4 10             	add    $0x10,%esp
  end_op();
80104ba1:	e8 87 eb ff ff       	call   8010372d <end_op>
  proc->cwd = 0;
80104ba6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bac:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104bb3:	83 ec 0c             	sub    $0xc,%esp
80104bb6:	68 60 39 11 80       	push   $0x80113960
80104bbb:	e8 e5 09 00 00       	call   801055a5 <acquire>
80104bc0:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104bc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc9:	8b 40 14             	mov    0x14(%eax),%eax
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 dd 04 00 00       	call   801050b2 <wakeup1>
80104bd5:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd8:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104bdf:	eb 3f                	jmp    80104c20 <exit+0x117>
    if(p->parent == proc){
80104be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be4:	8b 50 14             	mov    0x14(%eax),%edx
80104be7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bed:	39 c2                	cmp    %eax,%edx
80104bef:	75 28                	jne    80104c19 <exit+0x110>
      p->parent = initproc;
80104bf1:	8b 15 48 c6 10 80    	mov    0x8010c648,%edx
80104bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfa:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c00:	8b 40 0c             	mov    0xc(%eax),%eax
80104c03:	83 f8 05             	cmp    $0x5,%eax
80104c06:	75 11                	jne    80104c19 <exit+0x110>
        wakeup1(initproc);
80104c08:	a1 48 c6 10 80       	mov    0x8010c648,%eax
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	50                   	push   %eax
80104c11:	e8 9c 04 00 00       	call   801050b2 <wakeup1>
80104c16:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c19:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104c20:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
80104c27:	72 b8                	jb     80104be1 <exit+0xd8>
    }
  }

  acquire(&tickslock);
80104c29:	83 ec 0c             	sub    $0xc,%esp
80104c2c:	68 a0 5d 11 80       	push   $0x80115da0
80104c31:	e8 6f 09 00 00       	call   801055a5 <acquire>
80104c36:	83 c4 10             	add    $0x10,%esp
  proc->ttime = ticks;
80104c39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c3f:	8b 15 e0 65 11 80    	mov    0x801165e0,%edx
80104c45:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  release(&tickslock);
80104c4b:	83 ec 0c             	sub    $0xc,%esp
80104c4e:	68 a0 5d 11 80       	push   $0x80115da0
80104c53:	e8 b8 09 00 00       	call   80105610 <release>
80104c58:	83 c4 10             	add    $0x10,%esp
  // p->stime = p->ttime - (p->ctime + p->retime + p->rutime); //sleep time is leftover time

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104c5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c61:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104c68:	e8 4c 02 00 00       	call   80104eb9 <sched>
  panic("zombie exit");
80104c6d:	83 ec 0c             	sub    $0xc,%esp
80104c70:	68 f9 8f 10 80       	push   $0x80108ff9
80104c75:	e8 1d b9 ff ff       	call   80100597 <panic>

80104c7a <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104c7a:	f3 0f 1e fb          	endbr32 
80104c7e:	55                   	push   %ebp
80104c7f:	89 e5                	mov    %esp,%ebp
80104c81:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	68 60 39 11 80       	push   $0x80113960
80104c8c:	e8 14 09 00 00       	call   801055a5 <acquire>
80104c91:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104c94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c9b:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104ca2:	e9 a9 00 00 00       	jmp    80104d50 <wait+0xd6>
      if(p->parent != proc)
80104ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104caa:	8b 50 14             	mov    0x14(%eax),%edx
80104cad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb3:	39 c2                	cmp    %eax,%edx
80104cb5:	0f 85 8d 00 00 00    	jne    80104d48 <wait+0xce>
        continue;
      havekids = 1;
80104cbb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc5:	8b 40 0c             	mov    0xc(%eax),%eax
80104cc8:	83 f8 05             	cmp    $0x5,%eax
80104ccb:	75 7c                	jne    80104d49 <wait+0xcf>
        // Found one.
        pid = p->pid;
80104ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd0:	8b 40 10             	mov    0x10(%eax),%eax
80104cd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd9:	8b 40 08             	mov    0x8(%eax),%eax
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	50                   	push   %eax
80104ce0:	e8 f1 df ff ff       	call   80102cd6 <kfree>
80104ce5:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ceb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf5:	8b 40 04             	mov    0x4(%eax),%eax
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	50                   	push   %eax
80104cfc:	e8 80 3c 00 00       	call   80108981 <freevm>
80104d01:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d11:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d1b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d25:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2c:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104d33:	83 ec 0c             	sub    $0xc,%esp
80104d36:	68 60 39 11 80       	push   $0x80113960
80104d3b:	e8 d0 08 00 00       	call   80105610 <release>
80104d40:	83 c4 10             	add    $0x10,%esp
        return pid;
80104d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d46:	eb 5b                	jmp    80104da3 <wait+0x129>
        continue;
80104d48:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d49:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104d50:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
80104d57:	0f 82 4a ff ff ff    	jb     80104ca7 <wait+0x2d>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104d5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d61:	74 0d                	je     80104d70 <wait+0xf6>
80104d63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d69:	8b 40 24             	mov    0x24(%eax),%eax
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	74 17                	je     80104d87 <wait+0x10d>
      release(&ptable.lock);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 60 39 11 80       	push   $0x80113960
80104d78:	e8 93 08 00 00       	call   80105610 <release>
80104d7d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d85:	eb 1c                	jmp    80104da3 <wait+0x129>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104d87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8d:	83 ec 08             	sub    $0x8,%esp
80104d90:	68 60 39 11 80       	push   $0x80113960
80104d95:	50                   	push   %eax
80104d96:	e8 67 02 00 00       	call   80105002 <sleep>
80104d9b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104d9e:	e9 f1 fe ff ff       	jmp    80104c94 <wait+0x1a>
  }
}
80104da3:	c9                   	leave  
80104da4:	c3                   	ret    

80104da5 <scheduler>:



void
scheduler(void)
{
80104da5:	f3 0f 1e fb          	endbr32 
80104da9:	55                   	push   %ebp
80104daa:	89 e5                	mov    %esp,%ebp
80104dac:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int foundproc = 1;
80104daf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104db6:	e8 59 f8 ff ff       	call   80104614 <sti>

    if (!foundproc) hlt();
80104dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104dbf:	75 05                	jne    80104dc6 <scheduler+0x21>
80104dc1:	e8 55 f8 ff ff       	call   8010461b <hlt>

    foundproc = 0;
80104dc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104dcd:	83 ec 0c             	sub    $0xc,%esp
80104dd0:	68 60 39 11 80       	push   $0x80113960
80104dd5:	e8 cb 07 00 00       	call   801055a5 <acquire>
80104dda:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ddd:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104de4:	e9 ae 00 00 00       	jmp    80104e97 <scheduler+0xf2>

      struct proc *first = 0;
80104de9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

      if(p->state != RUNNABLE)
80104df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df3:	8b 40 0c             	mov    0xc(%eax),%eax
80104df6:	83 f8 03             	cmp    $0x3,%eax
80104df9:	0f 85 90 00 00 00    	jne    80104e8f <scheduler+0xea>
        continue;
 
      if (first != 0){
80104dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104e03:	74 18                	je     80104e1d <scheduler+0x78>
        if (p->ctime < first->ctime){
80104e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e08:	8b 50 7c             	mov    0x7c(%eax),%edx
80104e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e0e:	8b 40 7c             	mov    0x7c(%eax),%eax
80104e11:	39 c2                	cmp    %eax,%edx
80104e13:	73 0e                	jae    80104e23 <scheduler+0x7e>
          first = p;
80104e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e18:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e1b:	eb 06                	jmp    80104e23 <scheduler+0x7e>
        }
      }
      else{
        first = p;
80104e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e20:	89 45 ec             	mov    %eax,-0x14(%ebp)
      }
    
      if (first != 0){
80104e23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104e27:	74 06                	je     80104e2f <scheduler+0x8a>
      
        p = first;
80104e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      }

      if (p != 0){
80104e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e33:	74 5b                	je     80104e90 <scheduler+0xeb>
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.

        foundproc = 1;
80104e35:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        proc = p;
80104e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3f:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4

        switchuvm(p);
80104e45:	83 ec 0c             	sub    $0xc,%esp
80104e48:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4b:	e8 d8 36 00 00       	call   80108528 <switchuvm>
80104e50:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNING;
80104e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e56:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        swtch(&cpu->scheduler, proc->context);
80104e5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e63:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e66:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104e6d:	83 c2 04             	add    $0x4,%edx
80104e70:	83 ec 08             	sub    $0x8,%esp
80104e73:	50                   	push   %eax
80104e74:	52                   	push   %edx
80104e75:	e8 3b 0c 00 00       	call   80105ab5 <swtch>
80104e7a:	83 c4 10             	add    $0x10,%esp
        switchkvm();
80104e7d:	e8 85 36 00 00       	call   80108507 <switchkvm>


          // Process is done running for now.
          // It should have changed its p->state before coming back.
        proc = 0;
80104e82:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104e89:	00 00 00 00 
80104e8d:	eb 01                	jmp    80104e90 <scheduler+0xeb>
        continue;
80104e8f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e90:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104e97:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
80104e9e:	0f 82 45 ff ff ff    	jb     80104de9 <scheduler+0x44>
      }

      
      
    }
    release(&ptable.lock);
80104ea4:	83 ec 0c             	sub    $0xc,%esp
80104ea7:	68 60 39 11 80       	push   $0x80113960
80104eac:	e8 5f 07 00 00       	call   80105610 <release>
80104eb1:	83 c4 10             	add    $0x10,%esp
    sti();
80104eb4:	e9 fd fe ff ff       	jmp    80104db6 <scheduler+0x11>

80104eb9 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104eb9:	f3 0f 1e fb          	endbr32 
80104ebd:	55                   	push   %ebp
80104ebe:	89 e5                	mov    %esp,%ebp
80104ec0:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104ec3:	83 ec 0c             	sub    $0xc,%esp
80104ec6:	68 60 39 11 80       	push   $0x80113960
80104ecb:	e8 15 08 00 00       	call   801056e5 <holding>
80104ed0:	83 c4 10             	add    $0x10,%esp
80104ed3:	85 c0                	test   %eax,%eax
80104ed5:	75 0d                	jne    80104ee4 <sched+0x2b>
    panic("sched ptable.lock");
80104ed7:	83 ec 0c             	sub    $0xc,%esp
80104eda:	68 05 90 10 80       	push   $0x80109005
80104edf:	e8 b3 b6 ff ff       	call   80100597 <panic>
  if(cpu->ncli != 1)
80104ee4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104eea:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ef0:	83 f8 01             	cmp    $0x1,%eax
80104ef3:	74 0d                	je     80104f02 <sched+0x49>
    panic("sched locks");
80104ef5:	83 ec 0c             	sub    $0xc,%esp
80104ef8:	68 17 90 10 80       	push   $0x80109017
80104efd:	e8 95 b6 ff ff       	call   80100597 <panic>
  if(proc->state == RUNNING)
80104f02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f08:	8b 40 0c             	mov    0xc(%eax),%eax
80104f0b:	83 f8 04             	cmp    $0x4,%eax
80104f0e:	75 0d                	jne    80104f1d <sched+0x64>
    panic("sched running");
80104f10:	83 ec 0c             	sub    $0xc,%esp
80104f13:	68 23 90 10 80       	push   $0x80109023
80104f18:	e8 7a b6 ff ff       	call   80100597 <panic>
  if(readeflags()&FL_IF)
80104f1d:	e8 e2 f6 ff ff       	call   80104604 <readeflags>
80104f22:	25 00 02 00 00       	and    $0x200,%eax
80104f27:	85 c0                	test   %eax,%eax
80104f29:	74 0d                	je     80104f38 <sched+0x7f>
    panic("sched interruptible");
80104f2b:	83 ec 0c             	sub    $0xc,%esp
80104f2e:	68 31 90 10 80       	push   $0x80109031
80104f33:	e8 5f b6 ff ff       	call   80100597 <panic>
  intena = cpu->intena;
80104f38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f3e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104f47:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f4d:	8b 40 04             	mov    0x4(%eax),%eax
80104f50:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f57:	83 c2 1c             	add    $0x1c,%edx
80104f5a:	83 ec 08             	sub    $0x8,%esp
80104f5d:	50                   	push   %eax
80104f5e:	52                   	push   %edx
80104f5f:	e8 51 0b 00 00       	call   80105ab5 <swtch>
80104f64:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104f67:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f70:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104f76:	90                   	nop
80104f77:	c9                   	leave  
80104f78:	c3                   	ret    

80104f79 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104f79:	f3 0f 1e fb          	endbr32 
80104f7d:	55                   	push   %ebp
80104f7e:	89 e5                	mov    %esp,%ebp
80104f80:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104f83:	83 ec 0c             	sub    $0xc,%esp
80104f86:	68 60 39 11 80       	push   $0x80113960
80104f8b:	e8 15 06 00 00       	call   801055a5 <acquire>
80104f90:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104f93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f99:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104fa0:	e8 14 ff ff ff       	call   80104eb9 <sched>
  release(&ptable.lock);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	68 60 39 11 80       	push   $0x80113960
80104fad:	e8 5e 06 00 00       	call   80105610 <release>
80104fb2:	83 c4 10             	add    $0x10,%esp
}
80104fb5:	90                   	nop
80104fb6:	c9                   	leave  
80104fb7:	c3                   	ret    

80104fb8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104fb8:	f3 0f 1e fb          	endbr32 
80104fbc:	55                   	push   %ebp
80104fbd:	89 e5                	mov    %esp,%ebp
80104fbf:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104fc2:	83 ec 0c             	sub    $0xc,%esp
80104fc5:	68 60 39 11 80       	push   $0x80113960
80104fca:	e8 41 06 00 00       	call   80105610 <release>
80104fcf:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104fd2:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	74 24                	je     80104fff <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104fdb:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104fe2:	00 00 00 
    iinit(ROOTDEV);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	6a 01                	push   $0x1
80104fea:	e8 e2 c6 ff ff       	call   801016d1 <iinit>
80104fef:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104ff2:	83 ec 0c             	sub    $0xc,%esp
80104ff5:	6a 01                	push   $0x1
80104ff7:	e8 6e e4 ff ff       	call   8010346a <initlog>
80104ffc:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104fff:	90                   	nop
80105000:	c9                   	leave  
80105001:	c3                   	ret    

80105002 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105002:	f3 0f 1e fb          	endbr32 
80105006:	55                   	push   %ebp
80105007:	89 e5                	mov    %esp,%ebp
80105009:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
8010500c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105012:	85 c0                	test   %eax,%eax
80105014:	75 0d                	jne    80105023 <sleep+0x21>
    panic("sleep");
80105016:	83 ec 0c             	sub    $0xc,%esp
80105019:	68 45 90 10 80       	push   $0x80109045
8010501e:	e8 74 b5 ff ff       	call   80100597 <panic>

  if(lk == 0)
80105023:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105027:	75 0d                	jne    80105036 <sleep+0x34>
    panic("sleep without lk");
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	68 4b 90 10 80       	push   $0x8010904b
80105031:	e8 61 b5 ff ff       	call   80100597 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105036:	81 7d 0c 60 39 11 80 	cmpl   $0x80113960,0xc(%ebp)
8010503d:	74 1e                	je     8010505d <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	68 60 39 11 80       	push   $0x80113960
80105047:	e8 59 05 00 00       	call   801055a5 <acquire>
8010504c:	83 c4 10             	add    $0x10,%esp
    release(lk);
8010504f:	83 ec 0c             	sub    $0xc,%esp
80105052:	ff 75 0c             	pushl  0xc(%ebp)
80105055:	e8 b6 05 00 00       	call   80105610 <release>
8010505a:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010505d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105063:	8b 55 08             	mov    0x8(%ebp),%edx
80105066:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80105069:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010506f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80105076:	e8 3e fe ff ff       	call   80104eb9 <sched>

  // Tidy up.
  proc->chan = 0;
8010507b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105081:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80105088:	81 7d 0c 60 39 11 80 	cmpl   $0x80113960,0xc(%ebp)
8010508f:	74 1e                	je     801050af <sleep+0xad>
    release(&ptable.lock);
80105091:	83 ec 0c             	sub    $0xc,%esp
80105094:	68 60 39 11 80       	push   $0x80113960
80105099:	e8 72 05 00 00       	call   80105610 <release>
8010509e:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801050a1:	83 ec 0c             	sub    $0xc,%esp
801050a4:	ff 75 0c             	pushl  0xc(%ebp)
801050a7:	e8 f9 04 00 00       	call   801055a5 <acquire>
801050ac:	83 c4 10             	add    $0x10,%esp
  }
}
801050af:	90                   	nop
801050b0:	c9                   	leave  
801050b1:	c3                   	ret    

801050b2 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801050b2:	f3 0f 1e fb          	endbr32 
801050b6:	55                   	push   %ebp
801050b7:	89 e5                	mov    %esp,%ebp
801050b9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050bc:	c7 45 fc 94 39 11 80 	movl   $0x80113994,-0x4(%ebp)
801050c3:	eb 27                	jmp    801050ec <wakeup1+0x3a>
    if(p->state == SLEEPING && p->chan == chan)
801050c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c8:	8b 40 0c             	mov    0xc(%eax),%eax
801050cb:	83 f8 02             	cmp    $0x2,%eax
801050ce:	75 15                	jne    801050e5 <wakeup1+0x33>
801050d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d3:	8b 40 20             	mov    0x20(%eax),%eax
801050d6:	39 45 08             	cmp    %eax,0x8(%ebp)
801050d9:	75 0a                	jne    801050e5 <wakeup1+0x33>
      p->state = RUNNABLE;
801050db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050e5:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
801050ec:	81 7d fc 94 5d 11 80 	cmpl   $0x80115d94,-0x4(%ebp)
801050f3:	72 d0                	jb     801050c5 <wakeup1+0x13>
}
801050f5:	90                   	nop
801050f6:	90                   	nop
801050f7:	c9                   	leave  
801050f8:	c3                   	ret    

801050f9 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801050f9:	f3 0f 1e fb          	endbr32 
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
80105100:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105103:	83 ec 0c             	sub    $0xc,%esp
80105106:	68 60 39 11 80       	push   $0x80113960
8010510b:	e8 95 04 00 00       	call   801055a5 <acquire>
80105110:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105113:	83 ec 0c             	sub    $0xc,%esp
80105116:	ff 75 08             	pushl  0x8(%ebp)
80105119:	e8 94 ff ff ff       	call   801050b2 <wakeup1>
8010511e:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105121:	83 ec 0c             	sub    $0xc,%esp
80105124:	68 60 39 11 80       	push   $0x80113960
80105129:	e8 e2 04 00 00       	call   80105610 <release>
8010512e:	83 c4 10             	add    $0x10,%esp
}
80105131:	90                   	nop
80105132:	c9                   	leave  
80105133:	c3                   	ret    

80105134 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105134:	f3 0f 1e fb          	endbr32 
80105138:	55                   	push   %ebp
80105139:	89 e5                	mov    %esp,%ebp
8010513b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010513e:	83 ec 0c             	sub    $0xc,%esp
80105141:	68 60 39 11 80       	push   $0x80113960
80105146:	e8 5a 04 00 00       	call   801055a5 <acquire>
8010514b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010514e:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80105155:	eb 77                	jmp    801051ce <kill+0x9a>
    if(p->pid == pid){
80105157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515a:	8b 40 10             	mov    0x10(%eax),%eax
8010515d:	39 45 08             	cmp    %eax,0x8(%ebp)
80105160:	75 65                	jne    801051c7 <kill+0x93>
      p->killed = 1;
80105162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105165:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      acquire(&tickslock);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	68 a0 5d 11 80       	push   $0x80115da0
80105174:	e8 2c 04 00 00       	call   801055a5 <acquire>
80105179:	83 c4 10             	add    $0x10,%esp
      p->ttime = ticks;
8010517c:	8b 15 e0 65 11 80    	mov    0x801165e0,%edx
80105182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105185:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      release(&tickslock);
8010518b:	83 ec 0c             	sub    $0xc,%esp
8010518e:	68 a0 5d 11 80       	push   $0x80115da0
80105193:	e8 78 04 00 00       	call   80105610 <release>
80105198:	83 c4 10             	add    $0x10,%esp
      // Wake process from sleep if necessary.

      if(p->state == SLEEPING)
8010519b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519e:	8b 40 0c             	mov    0xc(%eax),%eax
801051a1:	83 f8 02             	cmp    $0x2,%eax
801051a4:	75 0a                	jne    801051b0 <kill+0x7c>
        p->state = RUNNABLE;
801051a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	68 60 39 11 80       	push   $0x80113960
801051b8:	e8 53 04 00 00       	call   80105610 <release>
801051bd:	83 c4 10             	add    $0x10,%esp
      return 0;
801051c0:	b8 00 00 00 00       	mov    $0x0,%eax
801051c5:	eb 25                	jmp    801051ec <kill+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051c7:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801051ce:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
801051d5:	72 80                	jb     80105157 <kill+0x23>
    }
  }
  release(&ptable.lock);
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	68 60 39 11 80       	push   $0x80113960
801051df:	e8 2c 04 00 00       	call   80105610 <release>
801051e4:	83 c4 10             	add    $0x10,%esp
  return -1;
801051e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ec:	c9                   	leave  
801051ed:	c3                   	ret    

801051ee <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801051ee:	f3 0f 1e fb          	endbr32 
801051f2:	55                   	push   %ebp
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051f8:	c7 45 f0 94 39 11 80 	movl   $0x80113994,-0x10(%ebp)
801051ff:	e9 da 00 00 00       	jmp    801052de <procdump+0xf0>
    if(p->state == UNUSED)
80105204:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105207:	8b 40 0c             	mov    0xc(%eax),%eax
8010520a:	85 c0                	test   %eax,%eax
8010520c:	0f 84 c4 00 00 00    	je     801052d6 <procdump+0xe8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105212:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105215:	8b 40 0c             	mov    0xc(%eax),%eax
80105218:	83 f8 05             	cmp    $0x5,%eax
8010521b:	77 23                	ja     80105240 <procdump+0x52>
8010521d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105220:	8b 40 0c             	mov    0xc(%eax),%eax
80105223:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010522a:	85 c0                	test   %eax,%eax
8010522c:	74 12                	je     80105240 <procdump+0x52>
      state = states[p->state];
8010522e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105231:	8b 40 0c             	mov    0xc(%eax),%eax
80105234:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010523b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010523e:	eb 07                	jmp    80105247 <procdump+0x59>
    else
      state = "???";
80105240:	c7 45 ec 5c 90 10 80 	movl   $0x8010905c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105247:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010524a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010524d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105250:	8b 40 10             	mov    0x10(%eax),%eax
80105253:	52                   	push   %edx
80105254:	ff 75 ec             	pushl  -0x14(%ebp)
80105257:	50                   	push   %eax
80105258:	68 60 90 10 80       	push   $0x80109060
8010525d:	e8 7c b1 ff ff       	call   801003de <cprintf>
80105262:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105268:	8b 40 0c             	mov    0xc(%eax),%eax
8010526b:	83 f8 02             	cmp    $0x2,%eax
8010526e:	75 54                	jne    801052c4 <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105270:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105273:	8b 40 1c             	mov    0x1c(%eax),%eax
80105276:	8b 40 0c             	mov    0xc(%eax),%eax
80105279:	83 c0 08             	add    $0x8,%eax
8010527c:	89 c2                	mov    %eax,%edx
8010527e:	83 ec 08             	sub    $0x8,%esp
80105281:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105284:	50                   	push   %eax
80105285:	52                   	push   %edx
80105286:	e8 db 03 00 00       	call   80105666 <getcallerpcs>
8010528b:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010528e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105295:	eb 1c                	jmp    801052b3 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80105297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010529a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010529e:	83 ec 08             	sub    $0x8,%esp
801052a1:	50                   	push   %eax
801052a2:	68 69 90 10 80       	push   $0x80109069
801052a7:	e8 32 b1 ff ff       	call   801003de <cprintf>
801052ac:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801052af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801052b3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801052b7:	7f 0b                	jg     801052c4 <procdump+0xd6>
801052b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052bc:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801052c0:	85 c0                	test   %eax,%eax
801052c2:	75 d3                	jne    80105297 <procdump+0xa9>
    }
    cprintf("\n");
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	68 6d 90 10 80       	push   $0x8010906d
801052cc:	e8 0d b1 ff ff       	call   801003de <cprintf>
801052d1:	83 c4 10             	add    $0x10,%esp
801052d4:	eb 01                	jmp    801052d7 <procdump+0xe9>
      continue;
801052d6:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052d7:	81 45 f0 90 00 00 00 	addl   $0x90,-0x10(%ebp)
801052de:	81 7d f0 94 5d 11 80 	cmpl   $0x80115d94,-0x10(%ebp)
801052e5:	0f 82 19 ff ff ff    	jb     80105204 <procdump+0x16>
  }
}
801052eb:	90                   	nop
801052ec:	90                   	nop
801052ed:	c9                   	leave  
801052ee:	c3                   	ret    

801052ef <update_stat>:

// update stat
void update_stat(){
801052ef:	f3 0f 1e fb          	endbr32 
801052f3:	55                   	push   %ebp
801052f4:	89 e5                	mov    %esp,%ebp
801052f6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  acquire(&ptable.lock);
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	68 60 39 11 80       	push   $0x80113960
80105301:	e8 9f 02 00 00       	call   801055a5 <acquire>
80105306:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105309:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80105310:	eb 6b                	jmp    8010537d <update_stat+0x8e>
    if (p->state == RUNNING){
80105312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105315:	8b 40 0c             	mov    0xc(%eax),%eax
80105318:	83 f8 04             	cmp    $0x4,%eax
8010531b:	75 17                	jne    80105334 <update_stat+0x45>
      p->rutime++;
8010531d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105320:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80105326:	8d 50 01             	lea    0x1(%eax),%edx
80105329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010532c:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
80105332:	eb 42                	jmp    80105376 <update_stat+0x87>
    }
    else if (p->state == SLEEPING){
80105334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105337:	8b 40 0c             	mov    0xc(%eax),%eax
8010533a:	83 f8 02             	cmp    $0x2,%eax
8010533d:	75 17                	jne    80105356 <update_stat+0x67>
      p->stime++;
8010533f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105342:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105348:	8d 50 01             	lea    0x1(%eax),%edx
8010534b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
80105354:	eb 20                	jmp    80105376 <update_stat+0x87>
    }
    else if (p->state == RUNNABLE){
80105356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105359:	8b 40 0c             	mov    0xc(%eax),%eax
8010535c:	83 f8 03             	cmp    $0x3,%eax
8010535f:	75 15                	jne    80105376 <update_stat+0x87>
      p->retime++;
80105361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105364:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010536a:	8d 50 01             	lea    0x1(%eax),%edx
8010536d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105370:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105376:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010537d:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
80105384:	72 8c                	jb     80105312 <update_stat+0x23>
    }
    
  }
  release(&ptable.lock);
80105386:	83 ec 0c             	sub    $0xc,%esp
80105389:	68 60 39 11 80       	push   $0x80113960
8010538e:	e8 7d 02 00 00       	call   80105610 <release>
80105393:	83 c4 10             	add    $0x10,%esp
}
80105396:	90                   	nop
80105397:	c9                   	leave  
80105398:	c3                   	ret    

80105399 <wait_stat>:


int 
wait_stat(int* wtime, int* rtime, int* iotime, int* status)
{
80105399:	f3 0f 1e fb          	endbr32 
8010539d:	55                   	push   %ebp
8010539e:	89 e5                	mov    %esp,%ebp
801053a0:	83 ec 18             	sub    $0x18,%esp
  // 
  struct proc *p;
  int havekids, pid;


  acquire(&ptable.lock);
801053a3:	83 ec 0c             	sub    $0xc,%esp
801053a6:	68 60 39 11 80       	push   $0x80113960
801053ab:	e8 f5 01 00 00       	call   801055a5 <acquire>
801053b0:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801053b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053ba:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
801053c1:	e9 23 01 00 00       	jmp    801054e9 <wait_stat+0x150>

      if(p->parent != proc){
801053c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c9:	8b 50 14             	mov    0x14(%eax),%edx
801053cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053d2:	39 c2                	cmp    %eax,%edx
801053d4:	0f 85 07 01 00 00    	jne    801054e1 <wait_stat+0x148>
        continue;
      }
      havekids = 1;
801053da:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

      if(p->state == ZOMBIE){
801053e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e4:	8b 40 0c             	mov    0xc(%eax),%eax
801053e7:	83 f8 05             	cmp    $0x5,%eax
801053ea:	0f 85 f2 00 00 00    	jne    801054e2 <wait_stat+0x149>
        // save runtimes of the kids
        *wtime = p->retime;
801053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f3:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801053f9:	89 c2                	mov    %eax,%edx
801053fb:	8b 45 08             	mov    0x8(%ebp),%eax
801053fe:	89 10                	mov    %edx,(%eax)
        *rtime = p->rutime;
80105400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105403:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80105409:	89 c2                	mov    %eax,%edx
8010540b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010540e:	89 10                	mov    %edx,(%eax)
        *iotime = p->stime;
80105410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105413:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105419:	89 c2                	mov    %eax,%edx
8010541b:	8b 45 10             	mov    0x10(%ebp),%eax
8010541e:	89 10                	mov    %edx,(%eax)



        // Found one.
        pid = p->pid;
80105420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105423:	8b 40 10             	mov    0x10(%eax),%eax
80105426:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80105429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010542c:	8b 40 08             	mov    0x8(%eax),%eax
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	50                   	push   %eax
80105433:	e8 9e d8 ff ff       	call   80102cd6 <kfree>
80105438:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010543b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80105445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105448:	8b 40 04             	mov    0x4(%eax),%eax
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	50                   	push   %eax
8010544f:	e8 2d 35 00 00       	call   80108981 <freevm>
80105454:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80105457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010545a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80105461:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105464:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010546b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010546e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80105475:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105478:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010547c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->retime = 0;
80105486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105489:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80105490:	00 00 00 
        p->rutime = 0;
80105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105496:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010549d:	00 00 00 
        p->ttime = 0;
801054a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801054aa:	00 00 00 
        p->ctime = 0;
801054ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b0:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
        p->stime = 0;
801054b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ba:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801054c1:	00 00 00 
        release(&ptable.lock);
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	68 60 39 11 80       	push   $0x80113960
801054cc:	e8 3f 01 00 00       	call   80105610 <release>
801054d1:	83 c4 10             	add    $0x10,%esp
        *status = pid;
801054d4:	8b 45 14             	mov    0x14(%ebp),%eax
801054d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801054da:	89 10                	mov    %edx,(%eax)
        return pid;
801054dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054df:	eb 64                	jmp    80105545 <wait_stat+0x1ac>
        continue;
801054e1:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054e2:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801054e9:	81 7d f4 94 5d 11 80 	cmpl   $0x80115d94,-0xc(%ebp)
801054f0:	0f 82 d0 fe ff ff    	jb     801053c6 <wait_stat+0x2d>
      }
    }

    // No point waiting if we don't have any children.
    // nothing to return
    if(!havekids || proc->killed){
801054f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054fa:	74 0d                	je     80105509 <wait_stat+0x170>
801054fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105502:	8b 40 24             	mov    0x24(%eax),%eax
80105505:	85 c0                	test   %eax,%eax
80105507:	74 20                	je     80105529 <wait_stat+0x190>
      release(&ptable.lock);
80105509:	83 ec 0c             	sub    $0xc,%esp
8010550c:	68 60 39 11 80       	push   $0x80113960
80105511:	e8 fa 00 00 00       	call   80105610 <release>
80105516:	83 c4 10             	add    $0x10,%esp
      *status = -1;
80105519:	8b 45 14             	mov    0x14(%ebp),%eax
8010551c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
      return -1;
80105522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105527:	eb 1c                	jmp    80105545 <wait_stat+0x1ac>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105529:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010552f:	83 ec 08             	sub    $0x8,%esp
80105532:	68 60 39 11 80       	push   $0x80113960
80105537:	50                   	push   %eax
80105538:	e8 c5 fa ff ff       	call   80105002 <sleep>
8010553d:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80105540:	e9 6e fe ff ff       	jmp    801053b3 <wait_stat+0x1a>
  }

80105545:	c9                   	leave  
80105546:	c3                   	ret    

80105547 <readeflags>:
{
80105547:	55                   	push   %ebp
80105548:	89 e5                	mov    %esp,%ebp
8010554a:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010554d:	9c                   	pushf  
8010554e:	58                   	pop    %eax
8010554f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105552:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    

80105557 <cli>:
{
80105557:	55                   	push   %ebp
80105558:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010555a:	fa                   	cli    
}
8010555b:	90                   	nop
8010555c:	5d                   	pop    %ebp
8010555d:	c3                   	ret    

8010555e <sti>:
{
8010555e:	55                   	push   %ebp
8010555f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105561:	fb                   	sti    
}
80105562:	90                   	nop
80105563:	5d                   	pop    %ebp
80105564:	c3                   	ret    

80105565 <xchg>:
{
80105565:	55                   	push   %ebp
80105566:	89 e5                	mov    %esp,%ebp
80105568:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
8010556b:	8b 55 08             	mov    0x8(%ebp),%edx
8010556e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105571:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105574:	f0 87 02             	lock xchg %eax,(%edx)
80105577:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010557a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010557d:	c9                   	leave  
8010557e:	c3                   	ret    

8010557f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010557f:	f3 0f 1e fb          	endbr32 
80105583:	55                   	push   %ebp
80105584:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105586:	8b 45 08             	mov    0x8(%ebp),%eax
80105589:	8b 55 0c             	mov    0xc(%ebp),%edx
8010558c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010558f:	8b 45 08             	mov    0x8(%ebp),%eax
80105592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105598:	8b 45 08             	mov    0x8(%ebp),%eax
8010559b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801055a2:	90                   	nop
801055a3:	5d                   	pop    %ebp
801055a4:	c3                   	ret    

801055a5 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801055a5:	f3 0f 1e fb          	endbr32 
801055a9:	55                   	push   %ebp
801055aa:	89 e5                	mov    %esp,%ebp
801055ac:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801055af:	e8 5f 01 00 00       	call   80105713 <pushcli>
  if(holding(lk))
801055b4:	8b 45 08             	mov    0x8(%ebp),%eax
801055b7:	83 ec 0c             	sub    $0xc,%esp
801055ba:	50                   	push   %eax
801055bb:	e8 25 01 00 00       	call   801056e5 <holding>
801055c0:	83 c4 10             	add    $0x10,%esp
801055c3:	85 c0                	test   %eax,%eax
801055c5:	74 0d                	je     801055d4 <acquire+0x2f>
    panic("acquire");
801055c7:	83 ec 0c             	sub    $0xc,%esp
801055ca:	68 99 90 10 80       	push   $0x80109099
801055cf:	e8 c3 af ff ff       	call   80100597 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801055d4:	90                   	nop
801055d5:	8b 45 08             	mov    0x8(%ebp),%eax
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	6a 01                	push   $0x1
801055dd:	50                   	push   %eax
801055de:	e8 82 ff ff ff       	call   80105565 <xchg>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	75 eb                	jne    801055d5 <acquire+0x30>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801055ea:	8b 45 08             	mov    0x8(%ebp),%eax
801055ed:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055f4:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801055f7:	8b 45 08             	mov    0x8(%ebp),%eax
801055fa:	83 c0 0c             	add    $0xc,%eax
801055fd:	83 ec 08             	sub    $0x8,%esp
80105600:	50                   	push   %eax
80105601:	8d 45 08             	lea    0x8(%ebp),%eax
80105604:	50                   	push   %eax
80105605:	e8 5c 00 00 00       	call   80105666 <getcallerpcs>
8010560a:	83 c4 10             	add    $0x10,%esp
}
8010560d:	90                   	nop
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010561a:	83 ec 0c             	sub    $0xc,%esp
8010561d:	ff 75 08             	pushl  0x8(%ebp)
80105620:	e8 c0 00 00 00       	call   801056e5 <holding>
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	85 c0                	test   %eax,%eax
8010562a:	75 0d                	jne    80105639 <release+0x29>
    panic("release");
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	68 a1 90 10 80       	push   $0x801090a1
80105634:	e8 5e af ff ff       	call   80100597 <panic>

  lk->pcs[0] = 0;
80105639:	8b 45 08             	mov    0x8(%ebp),%eax
8010563c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105643:	8b 45 08             	mov    0x8(%ebp),%eax
80105646:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010564d:	8b 45 08             	mov    0x8(%ebp),%eax
80105650:	83 ec 08             	sub    $0x8,%esp
80105653:	6a 00                	push   $0x0
80105655:	50                   	push   %eax
80105656:	e8 0a ff ff ff       	call   80105565 <xchg>
8010565b:	83 c4 10             	add    $0x10,%esp

  popcli();
8010565e:	e8 f9 00 00 00       	call   8010575c <popcli>
}
80105663:	90                   	nop
80105664:	c9                   	leave  
80105665:	c3                   	ret    

80105666 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105666:	f3 0f 1e fb          	endbr32 
8010566a:	55                   	push   %ebp
8010566b:	89 e5                	mov    %esp,%ebp
8010566d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105670:	8b 45 08             	mov    0x8(%ebp),%eax
80105673:	83 e8 08             	sub    $0x8,%eax
80105676:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105679:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105680:	eb 38                	jmp    801056ba <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105682:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105686:	74 53                	je     801056db <getcallerpcs+0x75>
80105688:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010568f:	76 4a                	jbe    801056db <getcallerpcs+0x75>
80105691:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105695:	74 44                	je     801056db <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105697:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010569a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a4:	01 c2                	add    %eax,%edx
801056a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056a9:	8b 40 04             	mov    0x4(%eax),%eax
801056ac:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801056ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b1:	8b 00                	mov    (%eax),%eax
801056b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801056b6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056ba:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056be:	7e c2                	jle    80105682 <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
801056c0:	eb 19                	jmp    801056db <getcallerpcs+0x75>
    pcs[i] = 0;
801056c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801056cf:	01 d0                	add    %edx,%eax
801056d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056d7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056db:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056df:	7e e1                	jle    801056c2 <getcallerpcs+0x5c>
}
801056e1:	90                   	nop
801056e2:	90                   	nop
801056e3:	c9                   	leave  
801056e4:	c3                   	ret    

801056e5 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056e5:	f3 0f 1e fb          	endbr32 
801056e9:	55                   	push   %ebp
801056ea:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801056ec:	8b 45 08             	mov    0x8(%ebp),%eax
801056ef:	8b 00                	mov    (%eax),%eax
801056f1:	85 c0                	test   %eax,%eax
801056f3:	74 17                	je     8010570c <holding+0x27>
801056f5:	8b 45 08             	mov    0x8(%ebp),%eax
801056f8:	8b 50 08             	mov    0x8(%eax),%edx
801056fb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105701:	39 c2                	cmp    %eax,%edx
80105703:	75 07                	jne    8010570c <holding+0x27>
80105705:	b8 01 00 00 00       	mov    $0x1,%eax
8010570a:	eb 05                	jmp    80105711 <holding+0x2c>
8010570c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105711:	5d                   	pop    %ebp
80105712:	c3                   	ret    

80105713 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105713:	f3 0f 1e fb          	endbr32 
80105717:	55                   	push   %ebp
80105718:	89 e5                	mov    %esp,%ebp
8010571a:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010571d:	e8 25 fe ff ff       	call   80105547 <readeflags>
80105722:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105725:	e8 2d fe ff ff       	call   80105557 <cli>
  if(cpu->ncli++ == 0)
8010572a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105731:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105737:	8d 48 01             	lea    0x1(%eax),%ecx
8010573a:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105740:	85 c0                	test   %eax,%eax
80105742:	75 15                	jne    80105759 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80105744:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010574a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010574d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105753:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105759:	90                   	nop
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    

8010575c <popcli>:

void
popcli(void)
{
8010575c:	f3 0f 1e fb          	endbr32 
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105766:	e8 dc fd ff ff       	call   80105547 <readeflags>
8010576b:	25 00 02 00 00       	and    $0x200,%eax
80105770:	85 c0                	test   %eax,%eax
80105772:	74 0d                	je     80105781 <popcli+0x25>
    panic("popcli - interruptible");
80105774:	83 ec 0c             	sub    $0xc,%esp
80105777:	68 a9 90 10 80       	push   $0x801090a9
8010577c:	e8 16 ae ff ff       	call   80100597 <panic>
  if(--cpu->ncli < 0)
80105781:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105787:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010578d:	83 ea 01             	sub    $0x1,%edx
80105790:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105796:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010579c:	85 c0                	test   %eax,%eax
8010579e:	79 0d                	jns    801057ad <popcli+0x51>
    panic("popcli");
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	68 c0 90 10 80       	push   $0x801090c0
801057a8:	e8 ea ad ff ff       	call   80100597 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801057ad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057b3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801057b9:	85 c0                	test   %eax,%eax
801057bb:	75 15                	jne    801057d2 <popcli+0x76>
801057bd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057c3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801057c9:	85 c0                	test   %eax,%eax
801057cb:	74 05                	je     801057d2 <popcli+0x76>
    sti();
801057cd:	e8 8c fd ff ff       	call   8010555e <sti>
}
801057d2:	90                   	nop
801057d3:	c9                   	leave  
801057d4:	c3                   	ret    

801057d5 <stosb>:
{
801057d5:	55                   	push   %ebp
801057d6:	89 e5                	mov    %esp,%ebp
801057d8:	57                   	push   %edi
801057d9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057da:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057dd:	8b 55 10             	mov    0x10(%ebp),%edx
801057e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e3:	89 cb                	mov    %ecx,%ebx
801057e5:	89 df                	mov    %ebx,%edi
801057e7:	89 d1                	mov    %edx,%ecx
801057e9:	fc                   	cld    
801057ea:	f3 aa                	rep stos %al,%es:(%edi)
801057ec:	89 ca                	mov    %ecx,%edx
801057ee:	89 fb                	mov    %edi,%ebx
801057f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057f3:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057f6:	90                   	nop
801057f7:	5b                   	pop    %ebx
801057f8:	5f                   	pop    %edi
801057f9:	5d                   	pop    %ebp
801057fa:	c3                   	ret    

801057fb <stosl>:
{
801057fb:	55                   	push   %ebp
801057fc:	89 e5                	mov    %esp,%ebp
801057fe:	57                   	push   %edi
801057ff:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105800:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105803:	8b 55 10             	mov    0x10(%ebp),%edx
80105806:	8b 45 0c             	mov    0xc(%ebp),%eax
80105809:	89 cb                	mov    %ecx,%ebx
8010580b:	89 df                	mov    %ebx,%edi
8010580d:	89 d1                	mov    %edx,%ecx
8010580f:	fc                   	cld    
80105810:	f3 ab                	rep stos %eax,%es:(%edi)
80105812:	89 ca                	mov    %ecx,%edx
80105814:	89 fb                	mov    %edi,%ebx
80105816:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105819:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010581c:	90                   	nop
8010581d:	5b                   	pop    %ebx
8010581e:	5f                   	pop    %edi
8010581f:	5d                   	pop    %ebp
80105820:	c3                   	ret    

80105821 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105821:	f3 0f 1e fb          	endbr32 
80105825:	55                   	push   %ebp
80105826:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105828:	8b 45 08             	mov    0x8(%ebp),%eax
8010582b:	83 e0 03             	and    $0x3,%eax
8010582e:	85 c0                	test   %eax,%eax
80105830:	75 43                	jne    80105875 <memset+0x54>
80105832:	8b 45 10             	mov    0x10(%ebp),%eax
80105835:	83 e0 03             	and    $0x3,%eax
80105838:	85 c0                	test   %eax,%eax
8010583a:	75 39                	jne    80105875 <memset+0x54>
    c &= 0xFF;
8010583c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105843:	8b 45 10             	mov    0x10(%ebp),%eax
80105846:	c1 e8 02             	shr    $0x2,%eax
80105849:	89 c1                	mov    %eax,%ecx
8010584b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010584e:	c1 e0 18             	shl    $0x18,%eax
80105851:	89 c2                	mov    %eax,%edx
80105853:	8b 45 0c             	mov    0xc(%ebp),%eax
80105856:	c1 e0 10             	shl    $0x10,%eax
80105859:	09 c2                	or     %eax,%edx
8010585b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585e:	c1 e0 08             	shl    $0x8,%eax
80105861:	09 d0                	or     %edx,%eax
80105863:	0b 45 0c             	or     0xc(%ebp),%eax
80105866:	51                   	push   %ecx
80105867:	50                   	push   %eax
80105868:	ff 75 08             	pushl  0x8(%ebp)
8010586b:	e8 8b ff ff ff       	call   801057fb <stosl>
80105870:	83 c4 0c             	add    $0xc,%esp
80105873:	eb 12                	jmp    80105887 <memset+0x66>
  } else
    stosb(dst, c, n);
80105875:	8b 45 10             	mov    0x10(%ebp),%eax
80105878:	50                   	push   %eax
80105879:	ff 75 0c             	pushl  0xc(%ebp)
8010587c:	ff 75 08             	pushl  0x8(%ebp)
8010587f:	e8 51 ff ff ff       	call   801057d5 <stosb>
80105884:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105887:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010588a:	c9                   	leave  
8010588b:	c3                   	ret    

8010588c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010588c:	f3 0f 1e fb          	endbr32 
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105896:	8b 45 08             	mov    0x8(%ebp),%eax
80105899:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010589c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010589f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801058a2:	eb 30                	jmp    801058d4 <memcmp+0x48>
    if(*s1 != *s2)
801058a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058a7:	0f b6 10             	movzbl (%eax),%edx
801058aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058ad:	0f b6 00             	movzbl (%eax),%eax
801058b0:	38 c2                	cmp    %al,%dl
801058b2:	74 18                	je     801058cc <memcmp+0x40>
      return *s1 - *s2;
801058b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058b7:	0f b6 00             	movzbl (%eax),%eax
801058ba:	0f b6 d0             	movzbl %al,%edx
801058bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058c0:	0f b6 00             	movzbl (%eax),%eax
801058c3:	0f b6 c0             	movzbl %al,%eax
801058c6:	29 c2                	sub    %eax,%edx
801058c8:	89 d0                	mov    %edx,%eax
801058ca:	eb 1a                	jmp    801058e6 <memcmp+0x5a>
    s1++, s2++;
801058cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058d0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801058d4:	8b 45 10             	mov    0x10(%ebp),%eax
801058d7:	8d 50 ff             	lea    -0x1(%eax),%edx
801058da:	89 55 10             	mov    %edx,0x10(%ebp)
801058dd:	85 c0                	test   %eax,%eax
801058df:	75 c3                	jne    801058a4 <memcmp+0x18>
  }

  return 0;
801058e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058e6:	c9                   	leave  
801058e7:	c3                   	ret    

801058e8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058e8:	f3 0f 1e fb          	endbr32 
801058ec:	55                   	push   %ebp
801058ed:	89 e5                	mov    %esp,%ebp
801058ef:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801058f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801058f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058f8:	8b 45 08             	mov    0x8(%ebp),%eax
801058fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105901:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105904:	73 54                	jae    8010595a <memmove+0x72>
80105906:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105909:	8b 45 10             	mov    0x10(%ebp),%eax
8010590c:	01 d0                	add    %edx,%eax
8010590e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105911:	73 47                	jae    8010595a <memmove+0x72>
    s += n;
80105913:	8b 45 10             	mov    0x10(%ebp),%eax
80105916:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105919:	8b 45 10             	mov    0x10(%ebp),%eax
8010591c:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010591f:	eb 13                	jmp    80105934 <memmove+0x4c>
      *--d = *--s;
80105921:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105925:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105929:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010592c:	0f b6 10             	movzbl (%eax),%edx
8010592f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105932:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105934:	8b 45 10             	mov    0x10(%ebp),%eax
80105937:	8d 50 ff             	lea    -0x1(%eax),%edx
8010593a:	89 55 10             	mov    %edx,0x10(%ebp)
8010593d:	85 c0                	test   %eax,%eax
8010593f:	75 e0                	jne    80105921 <memmove+0x39>
  if(s < d && s + n > d){
80105941:	eb 24                	jmp    80105967 <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105943:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105946:	8d 42 01             	lea    0x1(%edx),%eax
80105949:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010594c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010594f:	8d 48 01             	lea    0x1(%eax),%ecx
80105952:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80105955:	0f b6 12             	movzbl (%edx),%edx
80105958:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010595a:	8b 45 10             	mov    0x10(%ebp),%eax
8010595d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105960:	89 55 10             	mov    %edx,0x10(%ebp)
80105963:	85 c0                	test   %eax,%eax
80105965:	75 dc                	jne    80105943 <memmove+0x5b>

  return dst;
80105967:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010596a:	c9                   	leave  
8010596b:	c3                   	ret    

8010596c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010596c:	f3 0f 1e fb          	endbr32 
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105973:	ff 75 10             	pushl  0x10(%ebp)
80105976:	ff 75 0c             	pushl  0xc(%ebp)
80105979:	ff 75 08             	pushl  0x8(%ebp)
8010597c:	e8 67 ff ff ff       	call   801058e8 <memmove>
80105981:	83 c4 0c             	add    $0xc,%esp
}
80105984:	c9                   	leave  
80105985:	c3                   	ret    

80105986 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105986:	f3 0f 1e fb          	endbr32 
8010598a:	55                   	push   %ebp
8010598b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010598d:	eb 0c                	jmp    8010599b <strncmp+0x15>
    n--, p++, q++;
8010598f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105993:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105997:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
8010599b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010599f:	74 1a                	je     801059bb <strncmp+0x35>
801059a1:	8b 45 08             	mov    0x8(%ebp),%eax
801059a4:	0f b6 00             	movzbl (%eax),%eax
801059a7:	84 c0                	test   %al,%al
801059a9:	74 10                	je     801059bb <strncmp+0x35>
801059ab:	8b 45 08             	mov    0x8(%ebp),%eax
801059ae:	0f b6 10             	movzbl (%eax),%edx
801059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801059b4:	0f b6 00             	movzbl (%eax),%eax
801059b7:	38 c2                	cmp    %al,%dl
801059b9:	74 d4                	je     8010598f <strncmp+0x9>
  if(n == 0)
801059bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059bf:	75 07                	jne    801059c8 <strncmp+0x42>
    return 0;
801059c1:	b8 00 00 00 00       	mov    $0x0,%eax
801059c6:	eb 16                	jmp    801059de <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
801059c8:	8b 45 08             	mov    0x8(%ebp),%eax
801059cb:	0f b6 00             	movzbl (%eax),%eax
801059ce:	0f b6 d0             	movzbl %al,%edx
801059d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d4:	0f b6 00             	movzbl (%eax),%eax
801059d7:	0f b6 c0             	movzbl %al,%eax
801059da:	29 c2                	sub    %eax,%edx
801059dc:	89 d0                	mov    %edx,%eax
}
801059de:	5d                   	pop    %ebp
801059df:	c3                   	ret    

801059e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059e0:	f3 0f 1e fb          	endbr32 
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059ea:	8b 45 08             	mov    0x8(%ebp),%eax
801059ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059f0:	90                   	nop
801059f1:	8b 45 10             	mov    0x10(%ebp),%eax
801059f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801059f7:	89 55 10             	mov    %edx,0x10(%ebp)
801059fa:	85 c0                	test   %eax,%eax
801059fc:	7e 2c                	jle    80105a2a <strncpy+0x4a>
801059fe:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a01:	8d 42 01             	lea    0x1(%edx),%eax
80105a04:	89 45 0c             	mov    %eax,0xc(%ebp)
80105a07:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0a:	8d 48 01             	lea    0x1(%eax),%ecx
80105a0d:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105a10:	0f b6 12             	movzbl (%edx),%edx
80105a13:	88 10                	mov    %dl,(%eax)
80105a15:	0f b6 00             	movzbl (%eax),%eax
80105a18:	84 c0                	test   %al,%al
80105a1a:	75 d5                	jne    801059f1 <strncpy+0x11>
    ;
  while(n-- > 0)
80105a1c:	eb 0c                	jmp    80105a2a <strncpy+0x4a>
    *s++ = 0;
80105a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80105a21:	8d 50 01             	lea    0x1(%eax),%edx
80105a24:	89 55 08             	mov    %edx,0x8(%ebp)
80105a27:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105a2a:	8b 45 10             	mov    0x10(%ebp),%eax
80105a2d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a30:	89 55 10             	mov    %edx,0x10(%ebp)
80105a33:	85 c0                	test   %eax,%eax
80105a35:	7f e7                	jg     80105a1e <strncpy+0x3e>
  return os;
80105a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    

80105a3c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a3c:	f3 0f 1e fb          	endbr32 
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a46:	8b 45 08             	mov    0x8(%ebp),%eax
80105a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a50:	7f 05                	jg     80105a57 <safestrcpy+0x1b>
    return os;
80105a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a55:	eb 31                	jmp    80105a88 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a57:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a5f:	7e 1e                	jle    80105a7f <safestrcpy+0x43>
80105a61:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a64:	8d 42 01             	lea    0x1(%edx),%eax
80105a67:	89 45 0c             	mov    %eax,0xc(%ebp)
80105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6d:	8d 48 01             	lea    0x1(%eax),%ecx
80105a70:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105a73:	0f b6 12             	movzbl (%edx),%edx
80105a76:	88 10                	mov    %dl,(%eax)
80105a78:	0f b6 00             	movzbl (%eax),%eax
80105a7b:	84 c0                	test   %al,%al
80105a7d:	75 d8                	jne    80105a57 <safestrcpy+0x1b>
    ;
  *s = 0;
80105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a82:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a88:	c9                   	leave  
80105a89:	c3                   	ret    

80105a8a <strlen>:

int
strlen(const char *s)
{
80105a8a:	f3 0f 1e fb          	endbr32 
80105a8e:	55                   	push   %ebp
80105a8f:	89 e5                	mov    %esp,%ebp
80105a91:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a9b:	eb 04                	jmp    80105aa1 <strlen+0x17>
80105a9d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105aa1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa7:	01 d0                	add    %edx,%eax
80105aa9:	0f b6 00             	movzbl (%eax),%eax
80105aac:	84 c0                	test   %al,%al
80105aae:	75 ed                	jne    80105a9d <strlen+0x13>
    ;
  return n;
80105ab0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ab3:	c9                   	leave  
80105ab4:	c3                   	ret    

80105ab5 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105ab5:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105ab9:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105abd:	55                   	push   %ebp
  pushl %ebx
80105abe:	53                   	push   %ebx
  pushl %esi
80105abf:	56                   	push   %esi
  pushl %edi
80105ac0:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105ac1:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105ac3:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105ac5:	5f                   	pop    %edi
  popl %esi
80105ac6:	5e                   	pop    %esi
  popl %ebx
80105ac7:	5b                   	pop    %ebx
  popl %ebp
80105ac8:	5d                   	pop    %ebp
  ret
80105ac9:	c3                   	ret    

80105aca <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105aca:	f3 0f 1e fb          	endbr32 
80105ace:	55                   	push   %ebp
80105acf:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105ad1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ad7:	8b 00                	mov    (%eax),%eax
80105ad9:	39 45 08             	cmp    %eax,0x8(%ebp)
80105adc:	73 12                	jae    80105af0 <fetchint+0x26>
80105ade:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae1:	8d 50 04             	lea    0x4(%eax),%edx
80105ae4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aea:	8b 00                	mov    (%eax),%eax
80105aec:	39 c2                	cmp    %eax,%edx
80105aee:	76 07                	jbe    80105af7 <fetchint+0x2d>
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af5:	eb 0f                	jmp    80105b06 <fetchint+0x3c>
  *ip = *(int*)(addr);
80105af7:	8b 45 08             	mov    0x8(%ebp),%eax
80105afa:	8b 10                	mov    (%eax),%edx
80105afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aff:	89 10                	mov    %edx,(%eax)
  return 0;
80105b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b06:	5d                   	pop    %ebp
80105b07:	c3                   	ret    

80105b08 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105b08:	f3 0f 1e fb          	endbr32 
80105b0c:	55                   	push   %ebp
80105b0d:	89 e5                	mov    %esp,%ebp
80105b0f:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105b12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b18:	8b 00                	mov    (%eax),%eax
80105b1a:	39 45 08             	cmp    %eax,0x8(%ebp)
80105b1d:	72 07                	jb     80105b26 <fetchstr+0x1e>
    return -1;
80105b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b24:	eb 46                	jmp    80105b6c <fetchstr+0x64>
  *pp = (char*)addr;
80105b26:	8b 55 08             	mov    0x8(%ebp),%edx
80105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b2c:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105b2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b34:	8b 00                	mov    (%eax),%eax
80105b36:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105b39:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b3c:	8b 00                	mov    (%eax),%eax
80105b3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105b41:	eb 1c                	jmp    80105b5f <fetchstr+0x57>
    if(*s == 0)
80105b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b46:	0f b6 00             	movzbl (%eax),%eax
80105b49:	84 c0                	test   %al,%al
80105b4b:	75 0e                	jne    80105b5b <fetchstr+0x53>
      return s - *pp;
80105b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b50:	8b 00                	mov    (%eax),%eax
80105b52:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b55:	29 c2                	sub    %eax,%edx
80105b57:	89 d0                	mov    %edx,%eax
80105b59:	eb 11                	jmp    80105b6c <fetchstr+0x64>
  for(s = *pp; s < ep; s++)
80105b5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b65:	72 dc                	jb     80105b43 <fetchstr+0x3b>
  return -1;
80105b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b6c:	c9                   	leave  
80105b6d:	c3                   	ret    

80105b6e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b6e:	f3 0f 1e fb          	endbr32 
80105b72:	55                   	push   %ebp
80105b73:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105b75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b7b:	8b 40 18             	mov    0x18(%eax),%eax
80105b7e:	8b 40 44             	mov    0x44(%eax),%eax
80105b81:	8b 55 08             	mov    0x8(%ebp),%edx
80105b84:	c1 e2 02             	shl    $0x2,%edx
80105b87:	01 d0                	add    %edx,%eax
80105b89:	83 c0 04             	add    $0x4,%eax
80105b8c:	ff 75 0c             	pushl  0xc(%ebp)
80105b8f:	50                   	push   %eax
80105b90:	e8 35 ff ff ff       	call   80105aca <fetchint>
80105b95:	83 c4 08             	add    $0x8,%esp
}
80105b98:	c9                   	leave  
80105b99:	c3                   	ret    

80105b9a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b9a:	f3 0f 1e fb          	endbr32 
80105b9e:	55                   	push   %ebp
80105b9f:	89 e5                	mov    %esp,%ebp
80105ba1:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105ba4:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105ba7:	50                   	push   %eax
80105ba8:	ff 75 08             	pushl  0x8(%ebp)
80105bab:	e8 be ff ff ff       	call   80105b6e <argint>
80105bb0:	83 c4 08             	add    $0x8,%esp
80105bb3:	85 c0                	test   %eax,%eax
80105bb5:	79 07                	jns    80105bbe <argptr+0x24>
    return -1;
80105bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bbc:	eb 3b                	jmp    80105bf9 <argptr+0x5f>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105bbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bc4:	8b 00                	mov    (%eax),%eax
80105bc6:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bc9:	39 d0                	cmp    %edx,%eax
80105bcb:	76 16                	jbe    80105be3 <argptr+0x49>
80105bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bd0:	89 c2                	mov    %eax,%edx
80105bd2:	8b 45 10             	mov    0x10(%ebp),%eax
80105bd5:	01 c2                	add    %eax,%edx
80105bd7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bdd:	8b 00                	mov    (%eax),%eax
80105bdf:	39 c2                	cmp    %eax,%edx
80105be1:	76 07                	jbe    80105bea <argptr+0x50>
    return -1;
80105be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be8:	eb 0f                	jmp    80105bf9 <argptr+0x5f>
  *pp = (char*)i;
80105bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bed:	89 c2                	mov    %eax,%edx
80105bef:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bf2:	89 10                	mov    %edx,(%eax)
  return 0;
80105bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bf9:	c9                   	leave  
80105bfa:	c3                   	ret    

80105bfb <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bfb:	f3 0f 1e fb          	endbr32 
80105bff:	55                   	push   %ebp
80105c00:	89 e5                	mov    %esp,%ebp
80105c02:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105c05:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105c08:	50                   	push   %eax
80105c09:	ff 75 08             	pushl  0x8(%ebp)
80105c0c:	e8 5d ff ff ff       	call   80105b6e <argint>
80105c11:	83 c4 08             	add    $0x8,%esp
80105c14:	85 c0                	test   %eax,%eax
80105c16:	79 07                	jns    80105c1f <argstr+0x24>
    return -1;
80105c18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1d:	eb 0f                	jmp    80105c2e <argstr+0x33>
  return fetchstr(addr, pp);
80105c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c22:	ff 75 0c             	pushl  0xc(%ebp)
80105c25:	50                   	push   %eax
80105c26:	e8 dd fe ff ff       	call   80105b08 <fetchstr>
80105c2b:	83 c4 08             	add    $0x8,%esp
}
80105c2e:	c9                   	leave  
80105c2f:	c3                   	ret    

80105c30 <syscall>:
[SYS_wait_stat] sys_wait_stat,
};

void
syscall(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	83 ec 18             	sub    $0x18,%esp
  int num;

  num = proc->tf->eax;
80105c3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c40:	8b 40 18             	mov    0x18(%eax),%eax
80105c43:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c4d:	7e 32                	jle    80105c81 <syscall+0x51>
80105c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c52:	83 f8 16             	cmp    $0x16,%eax
80105c55:	77 2a                	ja     80105c81 <syscall+0x51>
80105c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5a:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c61:	85 c0                	test   %eax,%eax
80105c63:	74 1c                	je     80105c81 <syscall+0x51>
    proc->tf->eax = syscalls[num]();
80105c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c68:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c6f:	ff d0                	call   *%eax
80105c71:	89 c2                	mov    %eax,%edx
80105c73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c79:	8b 40 18             	mov    0x18(%eax),%eax
80105c7c:	89 50 1c             	mov    %edx,0x1c(%eax)
80105c7f:	eb 35                	jmp    80105cb6 <syscall+0x86>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105c81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c87:	8d 50 6c             	lea    0x6c(%eax),%edx
80105c8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105c90:	8b 40 10             	mov    0x10(%eax),%eax
80105c93:	ff 75 f4             	pushl  -0xc(%ebp)
80105c96:	52                   	push   %edx
80105c97:	50                   	push   %eax
80105c98:	68 c7 90 10 80       	push   $0x801090c7
80105c9d:	e8 3c a7 ff ff       	call   801003de <cprintf>
80105ca2:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
80105ca5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cab:	8b 40 18             	mov    0x18(%eax),%eax
80105cae:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105cb5:	90                   	nop
80105cb6:	90                   	nop
80105cb7:	c9                   	leave  
80105cb8:	c3                   	ret    

80105cb9 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105cb9:	f3 0f 1e fb          	endbr32 
80105cbd:	55                   	push   %ebp
80105cbe:	89 e5                	mov    %esp,%ebp
80105cc0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105cc3:	83 ec 08             	sub    $0x8,%esp
80105cc6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc9:	50                   	push   %eax
80105cca:	ff 75 08             	pushl  0x8(%ebp)
80105ccd:	e8 9c fe ff ff       	call   80105b6e <argint>
80105cd2:	83 c4 10             	add    $0x10,%esp
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	79 07                	jns    80105ce0 <argfd+0x27>
    return -1;
80105cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cde:	eb 50                	jmp    80105d30 <argfd+0x77>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce3:	85 c0                	test   %eax,%eax
80105ce5:	78 21                	js     80105d08 <argfd+0x4f>
80105ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cea:	83 f8 0f             	cmp    $0xf,%eax
80105ced:	7f 19                	jg     80105d08 <argfd+0x4f>
80105cef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cf8:	83 c2 08             	add    $0x8,%edx
80105cfb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d06:	75 07                	jne    80105d0f <argfd+0x56>
    return -1;
80105d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0d:	eb 21                	jmp    80105d30 <argfd+0x77>
  if(pfd)
80105d0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d13:	74 08                	je     80105d1d <argfd+0x64>
    *pfd = fd;
80105d15:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d18:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d1b:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d21:	74 08                	je     80105d2b <argfd+0x72>
    *pf = f;
80105d23:	8b 45 10             	mov    0x10(%ebp),%eax
80105d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d29:	89 10                	mov    %edx,(%eax)
  return 0;
80105d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d30:	c9                   	leave  
80105d31:	c3                   	ret    

80105d32 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105d32:	f3 0f 1e fb          	endbr32 
80105d36:	55                   	push   %ebp
80105d37:	89 e5                	mov    %esp,%ebp
80105d39:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d43:	eb 30                	jmp    80105d75 <fdalloc+0x43>
    if(proc->ofile[fd] == 0){
80105d45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d4e:	83 c2 08             	add    $0x8,%edx
80105d51:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d55:	85 c0                	test   %eax,%eax
80105d57:	75 18                	jne    80105d71 <fdalloc+0x3f>
      proc->ofile[fd] = f;
80105d59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d62:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d65:	8b 55 08             	mov    0x8(%ebp),%edx
80105d68:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d6f:	eb 0f                	jmp    80105d80 <fdalloc+0x4e>
  for(fd = 0; fd < NOFILE; fd++){
80105d71:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105d75:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105d79:	7e ca                	jle    80105d45 <fdalloc+0x13>
    }
  }
  return -1;
80105d7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d80:	c9                   	leave  
80105d81:	c3                   	ret    

80105d82 <sys_dup>:

int
sys_dup(void)
{
80105d82:	f3 0f 1e fb          	endbr32 
80105d86:	55                   	push   %ebp
80105d87:	89 e5                	mov    %esp,%ebp
80105d89:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105d8c:	83 ec 04             	sub    $0x4,%esp
80105d8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d92:	50                   	push   %eax
80105d93:	6a 00                	push   $0x0
80105d95:	6a 00                	push   $0x0
80105d97:	e8 1d ff ff ff       	call   80105cb9 <argfd>
80105d9c:	83 c4 10             	add    $0x10,%esp
80105d9f:	85 c0                	test   %eax,%eax
80105da1:	79 07                	jns    80105daa <sys_dup+0x28>
    return -1;
80105da3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da8:	eb 31                	jmp    80105ddb <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	50                   	push   %eax
80105db1:	e8 7c ff ff ff       	call   80105d32 <fdalloc>
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dc0:	79 07                	jns    80105dc9 <sys_dup+0x47>
    return -1;
80105dc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc7:	eb 12                	jmp    80105ddb <sys_dup+0x59>
  filedup(f);
80105dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcc:	83 ec 0c             	sub    $0xc,%esp
80105dcf:	50                   	push   %eax
80105dd0:	e8 9a b2 ff ff       	call   8010106f <filedup>
80105dd5:	83 c4 10             	add    $0x10,%esp
  return fd;
80105dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ddb:	c9                   	leave  
80105ddc:	c3                   	ret    

80105ddd <sys_read>:

int
sys_read(void)
{
80105ddd:	f3 0f 1e fb          	endbr32 
80105de1:	55                   	push   %ebp
80105de2:	89 e5                	mov    %esp,%ebp
80105de4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105de7:	83 ec 04             	sub    $0x4,%esp
80105dea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ded:	50                   	push   %eax
80105dee:	6a 00                	push   $0x0
80105df0:	6a 00                	push   $0x0
80105df2:	e8 c2 fe ff ff       	call   80105cb9 <argfd>
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	85 c0                	test   %eax,%eax
80105dfc:	78 2e                	js     80105e2c <sys_read+0x4f>
80105dfe:	83 ec 08             	sub    $0x8,%esp
80105e01:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e04:	50                   	push   %eax
80105e05:	6a 02                	push   $0x2
80105e07:	e8 62 fd ff ff       	call   80105b6e <argint>
80105e0c:	83 c4 10             	add    $0x10,%esp
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	78 19                	js     80105e2c <sys_read+0x4f>
80105e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e16:	83 ec 04             	sub    $0x4,%esp
80105e19:	50                   	push   %eax
80105e1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e1d:	50                   	push   %eax
80105e1e:	6a 01                	push   $0x1
80105e20:	e8 75 fd ff ff       	call   80105b9a <argptr>
80105e25:	83 c4 10             	add    $0x10,%esp
80105e28:	85 c0                	test   %eax,%eax
80105e2a:	79 07                	jns    80105e33 <sys_read+0x56>
    return -1;
80105e2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e31:	eb 17                	jmp    80105e4a <sys_read+0x6d>
  return fileread(f, p, n);
80105e33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e36:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3c:	83 ec 04             	sub    $0x4,%esp
80105e3f:	51                   	push   %ecx
80105e40:	52                   	push   %edx
80105e41:	50                   	push   %eax
80105e42:	e8 c4 b3 ff ff       	call   8010120b <fileread>
80105e47:	83 c4 10             	add    $0x10,%esp
}
80105e4a:	c9                   	leave  
80105e4b:	c3                   	ret    

80105e4c <sys_write>:

int
sys_write(void)
{
80105e4c:	f3 0f 1e fb          	endbr32 
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e56:	83 ec 04             	sub    $0x4,%esp
80105e59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e5c:	50                   	push   %eax
80105e5d:	6a 00                	push   $0x0
80105e5f:	6a 00                	push   $0x0
80105e61:	e8 53 fe ff ff       	call   80105cb9 <argfd>
80105e66:	83 c4 10             	add    $0x10,%esp
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	78 2e                	js     80105e9b <sys_write+0x4f>
80105e6d:	83 ec 08             	sub    $0x8,%esp
80105e70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e73:	50                   	push   %eax
80105e74:	6a 02                	push   $0x2
80105e76:	e8 f3 fc ff ff       	call   80105b6e <argint>
80105e7b:	83 c4 10             	add    $0x10,%esp
80105e7e:	85 c0                	test   %eax,%eax
80105e80:	78 19                	js     80105e9b <sys_write+0x4f>
80105e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e85:	83 ec 04             	sub    $0x4,%esp
80105e88:	50                   	push   %eax
80105e89:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e8c:	50                   	push   %eax
80105e8d:	6a 01                	push   $0x1
80105e8f:	e8 06 fd ff ff       	call   80105b9a <argptr>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	79 07                	jns    80105ea2 <sys_write+0x56>
    return -1;
80105e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea0:	eb 17                	jmp    80105eb9 <sys_write+0x6d>
  return filewrite(f, p, n);
80105ea2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ea5:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eab:	83 ec 04             	sub    $0x4,%esp
80105eae:	51                   	push   %ecx
80105eaf:	52                   	push   %edx
80105eb0:	50                   	push   %eax
80105eb1:	e8 11 b4 ff ff       	call   801012c7 <filewrite>
80105eb6:	83 c4 10             	add    $0x10,%esp
}
80105eb9:	c9                   	leave  
80105eba:	c3                   	ret    

80105ebb <sys_close>:

int
sys_close(void)
{
80105ebb:	f3 0f 1e fb          	endbr32 
80105ebf:	55                   	push   %ebp
80105ec0:	89 e5                	mov    %esp,%ebp
80105ec2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105ec5:	83 ec 04             	sub    $0x4,%esp
80105ec8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ecb:	50                   	push   %eax
80105ecc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ecf:	50                   	push   %eax
80105ed0:	6a 00                	push   $0x0
80105ed2:	e8 e2 fd ff ff       	call   80105cb9 <argfd>
80105ed7:	83 c4 10             	add    $0x10,%esp
80105eda:	85 c0                	test   %eax,%eax
80105edc:	79 07                	jns    80105ee5 <sys_close+0x2a>
    return -1;
80105ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee3:	eb 28                	jmp    80105f0d <sys_close+0x52>
  proc->ofile[fd] = 0;
80105ee5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105eee:	83 c2 08             	add    $0x8,%edx
80105ef1:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105ef8:	00 
  fileclose(f);
80105ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105efc:	83 ec 0c             	sub    $0xc,%esp
80105eff:	50                   	push   %eax
80105f00:	e8 bf b1 ff ff       	call   801010c4 <fileclose>
80105f05:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f0d:	c9                   	leave  
80105f0e:	c3                   	ret    

80105f0f <sys_fstat>:

int
sys_fstat(void)
{
80105f0f:	f3 0f 1e fb          	endbr32 
80105f13:	55                   	push   %ebp
80105f14:	89 e5                	mov    %esp,%ebp
80105f16:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f19:	83 ec 04             	sub    $0x4,%esp
80105f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f1f:	50                   	push   %eax
80105f20:	6a 00                	push   $0x0
80105f22:	6a 00                	push   $0x0
80105f24:	e8 90 fd ff ff       	call   80105cb9 <argfd>
80105f29:	83 c4 10             	add    $0x10,%esp
80105f2c:	85 c0                	test   %eax,%eax
80105f2e:	78 17                	js     80105f47 <sys_fstat+0x38>
80105f30:	83 ec 04             	sub    $0x4,%esp
80105f33:	6a 14                	push   $0x14
80105f35:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f38:	50                   	push   %eax
80105f39:	6a 01                	push   $0x1
80105f3b:	e8 5a fc ff ff       	call   80105b9a <argptr>
80105f40:	83 c4 10             	add    $0x10,%esp
80105f43:	85 c0                	test   %eax,%eax
80105f45:	79 07                	jns    80105f4e <sys_fstat+0x3f>
    return -1;
80105f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f4c:	eb 13                	jmp    80105f61 <sys_fstat+0x52>
  return filestat(f, st);
80105f4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f54:	83 ec 08             	sub    $0x8,%esp
80105f57:	52                   	push   %edx
80105f58:	50                   	push   %eax
80105f59:	e8 52 b2 ff ff       	call   801011b0 <filestat>
80105f5e:	83 c4 10             	add    $0x10,%esp
}
80105f61:	c9                   	leave  
80105f62:	c3                   	ret    

80105f63 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105f63:	f3 0f 1e fb          	endbr32 
80105f67:	55                   	push   %ebp
80105f68:	89 e5                	mov    %esp,%ebp
80105f6a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f6d:	83 ec 08             	sub    $0x8,%esp
80105f70:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f73:	50                   	push   %eax
80105f74:	6a 00                	push   $0x0
80105f76:	e8 80 fc ff ff       	call   80105bfb <argstr>
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	78 15                	js     80105f97 <sys_link+0x34>
80105f82:	83 ec 08             	sub    $0x8,%esp
80105f85:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f88:	50                   	push   %eax
80105f89:	6a 01                	push   $0x1
80105f8b:	e8 6b fc ff ff       	call   80105bfb <argstr>
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	85 c0                	test   %eax,%eax
80105f95:	79 0a                	jns    80105fa1 <sys_link+0x3e>
    return -1;
80105f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9c:	e9 68 01 00 00       	jmp    80106109 <sys_link+0x1a6>

  begin_op();
80105fa1:	e8 f7 d6 ff ff       	call   8010369d <begin_op>
  if((ip = namei(old)) == 0){
80105fa6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fa9:	83 ec 0c             	sub    $0xc,%esp
80105fac:	50                   	push   %eax
80105fad:	e8 48 c6 ff ff       	call   801025fa <namei>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fbc:	75 0f                	jne    80105fcd <sys_link+0x6a>
    end_op();
80105fbe:	e8 6a d7 ff ff       	call   8010372d <end_op>
    return -1;
80105fc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc8:	e9 3c 01 00 00       	jmp    80106109 <sys_link+0x1a6>
  }

  ilock(ip);
80105fcd:	83 ec 0c             	sub    $0xc,%esp
80105fd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd3:	e8 39 ba ff ff       	call   80101a11 <ilock>
80105fd8:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fde:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105fe2:	66 83 f8 01          	cmp    $0x1,%ax
80105fe6:	75 1d                	jne    80106005 <sys_link+0xa2>
    iunlockput(ip);
80105fe8:	83 ec 0c             	sub    $0xc,%esp
80105feb:	ff 75 f4             	pushl  -0xc(%ebp)
80105fee:	e8 ea bc ff ff       	call   80101cdd <iunlockput>
80105ff3:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ff6:	e8 32 d7 ff ff       	call   8010372d <end_op>
    return -1;
80105ffb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106000:	e9 04 01 00 00       	jmp    80106109 <sys_link+0x1a6>
  }

  ip->nlink++;
80106005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106008:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010600c:	83 c0 01             	add    $0x1,%eax
8010600f:	89 c2                	mov    %eax,%edx
80106011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106014:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	ff 75 f4             	pushl  -0xc(%ebp)
8010601e:	e8 08 b8 ff ff       	call   8010182b <iupdate>
80106023:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106026:	83 ec 0c             	sub    $0xc,%esp
80106029:	ff 75 f4             	pushl  -0xc(%ebp)
8010602c:	e8 42 bb ff ff       	call   80101b73 <iunlock>
80106031:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106034:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106037:	83 ec 08             	sub    $0x8,%esp
8010603a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010603d:	52                   	push   %edx
8010603e:	50                   	push   %eax
8010603f:	e8 d6 c5 ff ff       	call   8010261a <nameiparent>
80106044:	83 c4 10             	add    $0x10,%esp
80106047:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010604a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010604e:	74 71                	je     801060c1 <sys_link+0x15e>
    goto bad;
  ilock(dp);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	ff 75 f0             	pushl  -0x10(%ebp)
80106056:	e8 b6 b9 ff ff       	call   80101a11 <ilock>
8010605b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010605e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106061:	8b 10                	mov    (%eax),%edx
80106063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106066:	8b 00                	mov    (%eax),%eax
80106068:	39 c2                	cmp    %eax,%edx
8010606a:	75 1d                	jne    80106089 <sys_link+0x126>
8010606c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606f:	8b 40 04             	mov    0x4(%eax),%eax
80106072:	83 ec 04             	sub    $0x4,%esp
80106075:	50                   	push   %eax
80106076:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106079:	50                   	push   %eax
8010607a:	ff 75 f0             	pushl  -0x10(%ebp)
8010607d:	e8 d4 c2 ff ff       	call   80102356 <dirlink>
80106082:	83 c4 10             	add    $0x10,%esp
80106085:	85 c0                	test   %eax,%eax
80106087:	79 10                	jns    80106099 <sys_link+0x136>
    iunlockput(dp);
80106089:	83 ec 0c             	sub    $0xc,%esp
8010608c:	ff 75 f0             	pushl  -0x10(%ebp)
8010608f:	e8 49 bc ff ff       	call   80101cdd <iunlockput>
80106094:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106097:	eb 29                	jmp    801060c2 <sys_link+0x15f>
  }
  iunlockput(dp);
80106099:	83 ec 0c             	sub    $0xc,%esp
8010609c:	ff 75 f0             	pushl  -0x10(%ebp)
8010609f:	e8 39 bc ff ff       	call   80101cdd <iunlockput>
801060a4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801060a7:	83 ec 0c             	sub    $0xc,%esp
801060aa:	ff 75 f4             	pushl  -0xc(%ebp)
801060ad:	e8 37 bb ff ff       	call   80101be9 <iput>
801060b2:	83 c4 10             	add    $0x10,%esp

  end_op();
801060b5:	e8 73 d6 ff ff       	call   8010372d <end_op>

  return 0;
801060ba:	b8 00 00 00 00       	mov    $0x0,%eax
801060bf:	eb 48                	jmp    80106109 <sys_link+0x1a6>
    goto bad;
801060c1:	90                   	nop

bad:
  ilock(ip);
801060c2:	83 ec 0c             	sub    $0xc,%esp
801060c5:	ff 75 f4             	pushl  -0xc(%ebp)
801060c8:	e8 44 b9 ff ff       	call   80101a11 <ilock>
801060cd:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801060d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060d7:	83 e8 01             	sub    $0x1,%eax
801060da:	89 c2                	mov    %eax,%edx
801060dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060df:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801060e3:	83 ec 0c             	sub    $0xc,%esp
801060e6:	ff 75 f4             	pushl  -0xc(%ebp)
801060e9:	e8 3d b7 ff ff       	call   8010182b <iupdate>
801060ee:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801060f1:	83 ec 0c             	sub    $0xc,%esp
801060f4:	ff 75 f4             	pushl  -0xc(%ebp)
801060f7:	e8 e1 bb ff ff       	call   80101cdd <iunlockput>
801060fc:	83 c4 10             	add    $0x10,%esp
  end_op();
801060ff:	e8 29 d6 ff ff       	call   8010372d <end_op>
  return -1;
80106104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106109:	c9                   	leave  
8010610a:	c3                   	ret    

8010610b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010610b:	f3 0f 1e fb          	endbr32 
8010610f:	55                   	push   %ebp
80106110:	89 e5                	mov    %esp,%ebp
80106112:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106115:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010611c:	eb 40                	jmp    8010615e <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010611e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106121:	6a 10                	push   $0x10
80106123:	50                   	push   %eax
80106124:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106127:	50                   	push   %eax
80106128:	ff 75 08             	pushl  0x8(%ebp)
8010612b:	e8 66 be ff ff       	call   80101f96 <readi>
80106130:	83 c4 10             	add    $0x10,%esp
80106133:	83 f8 10             	cmp    $0x10,%eax
80106136:	74 0d                	je     80106145 <isdirempty+0x3a>
      panic("isdirempty: readi");
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	68 e3 90 10 80       	push   $0x801090e3
80106140:	e8 52 a4 ff ff       	call   80100597 <panic>
    if(de.inum != 0)
80106145:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106149:	66 85 c0             	test   %ax,%ax
8010614c:	74 07                	je     80106155 <isdirempty+0x4a>
      return 0;
8010614e:	b8 00 00 00 00       	mov    $0x0,%eax
80106153:	eb 1b                	jmp    80106170 <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106158:	83 c0 10             	add    $0x10,%eax
8010615b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010615e:	8b 45 08             	mov    0x8(%ebp),%eax
80106161:	8b 50 18             	mov    0x18(%eax),%edx
80106164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106167:	39 c2                	cmp    %eax,%edx
80106169:	77 b3                	ja     8010611e <isdirempty+0x13>
  }
  return 1;
8010616b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106170:	c9                   	leave  
80106171:	c3                   	ret    

80106172 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106172:	f3 0f 1e fb          	endbr32 
80106176:	55                   	push   %ebp
80106177:	89 e5                	mov    %esp,%ebp
80106179:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010617c:	83 ec 08             	sub    $0x8,%esp
8010617f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106182:	50                   	push   %eax
80106183:	6a 00                	push   $0x0
80106185:	e8 71 fa ff ff       	call   80105bfb <argstr>
8010618a:	83 c4 10             	add    $0x10,%esp
8010618d:	85 c0                	test   %eax,%eax
8010618f:	79 0a                	jns    8010619b <sys_unlink+0x29>
    return -1;
80106191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106196:	e9 bf 01 00 00       	jmp    8010635a <sys_unlink+0x1e8>

  begin_op();
8010619b:	e8 fd d4 ff ff       	call   8010369d <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801061a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
801061a3:	83 ec 08             	sub    $0x8,%esp
801061a6:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801061a9:	52                   	push   %edx
801061aa:	50                   	push   %eax
801061ab:	e8 6a c4 ff ff       	call   8010261a <nameiparent>
801061b0:	83 c4 10             	add    $0x10,%esp
801061b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061ba:	75 0f                	jne    801061cb <sys_unlink+0x59>
    end_op();
801061bc:	e8 6c d5 ff ff       	call   8010372d <end_op>
    return -1;
801061c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c6:	e9 8f 01 00 00       	jmp    8010635a <sys_unlink+0x1e8>
  }

  ilock(dp);
801061cb:	83 ec 0c             	sub    $0xc,%esp
801061ce:	ff 75 f4             	pushl  -0xc(%ebp)
801061d1:	e8 3b b8 ff ff       	call   80101a11 <ilock>
801061d6:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801061d9:	83 ec 08             	sub    $0x8,%esp
801061dc:	68 f5 90 10 80       	push   $0x801090f5
801061e1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061e4:	50                   	push   %eax
801061e5:	e8 8f c0 ff ff       	call   80102279 <namecmp>
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	85 c0                	test   %eax,%eax
801061ef:	0f 84 49 01 00 00    	je     8010633e <sys_unlink+0x1cc>
801061f5:	83 ec 08             	sub    $0x8,%esp
801061f8:	68 f7 90 10 80       	push   $0x801090f7
801061fd:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106200:	50                   	push   %eax
80106201:	e8 73 c0 ff ff       	call   80102279 <namecmp>
80106206:	83 c4 10             	add    $0x10,%esp
80106209:	85 c0                	test   %eax,%eax
8010620b:	0f 84 2d 01 00 00    	je     8010633e <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106211:	83 ec 04             	sub    $0x4,%esp
80106214:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106217:	50                   	push   %eax
80106218:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010621b:	50                   	push   %eax
8010621c:	ff 75 f4             	pushl  -0xc(%ebp)
8010621f:	e8 74 c0 ff ff       	call   80102298 <dirlookup>
80106224:	83 c4 10             	add    $0x10,%esp
80106227:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010622a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010622e:	0f 84 0d 01 00 00    	je     80106341 <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80106234:	83 ec 0c             	sub    $0xc,%esp
80106237:	ff 75 f0             	pushl  -0x10(%ebp)
8010623a:	e8 d2 b7 ff ff       	call   80101a11 <ilock>
8010623f:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106242:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106245:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106249:	66 85 c0             	test   %ax,%ax
8010624c:	7f 0d                	jg     8010625b <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
8010624e:	83 ec 0c             	sub    $0xc,%esp
80106251:	68 fa 90 10 80       	push   $0x801090fa
80106256:	e8 3c a3 ff ff       	call   80100597 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010625b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106262:	66 83 f8 01          	cmp    $0x1,%ax
80106266:	75 25                	jne    8010628d <sys_unlink+0x11b>
80106268:	83 ec 0c             	sub    $0xc,%esp
8010626b:	ff 75 f0             	pushl  -0x10(%ebp)
8010626e:	e8 98 fe ff ff       	call   8010610b <isdirempty>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	85 c0                	test   %eax,%eax
80106278:	75 13                	jne    8010628d <sys_unlink+0x11b>
    iunlockput(ip);
8010627a:	83 ec 0c             	sub    $0xc,%esp
8010627d:	ff 75 f0             	pushl  -0x10(%ebp)
80106280:	e8 58 ba ff ff       	call   80101cdd <iunlockput>
80106285:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106288:	e9 b5 00 00 00       	jmp    80106342 <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
8010628d:	83 ec 04             	sub    $0x4,%esp
80106290:	6a 10                	push   $0x10
80106292:	6a 00                	push   $0x0
80106294:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106297:	50                   	push   %eax
80106298:	e8 84 f5 ff ff       	call   80105821 <memset>
8010629d:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801062a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801062a3:	6a 10                	push   $0x10
801062a5:	50                   	push   %eax
801062a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062a9:	50                   	push   %eax
801062aa:	ff 75 f4             	pushl  -0xc(%ebp)
801062ad:	e8 3d be ff ff       	call   801020ef <writei>
801062b2:	83 c4 10             	add    $0x10,%esp
801062b5:	83 f8 10             	cmp    $0x10,%eax
801062b8:	74 0d                	je     801062c7 <sys_unlink+0x155>
    panic("unlink: writei");
801062ba:	83 ec 0c             	sub    $0xc,%esp
801062bd:	68 0c 91 10 80       	push   $0x8010910c
801062c2:	e8 d0 a2 ff ff       	call   80100597 <panic>
  if(ip->type == T_DIR){
801062c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062ce:	66 83 f8 01          	cmp    $0x1,%ax
801062d2:	75 21                	jne    801062f5 <sys_unlink+0x183>
    dp->nlink--;
801062d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062db:	83 e8 01             	sub    $0x1,%eax
801062de:	89 c2                	mov    %eax,%edx
801062e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e3:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801062e7:	83 ec 0c             	sub    $0xc,%esp
801062ea:	ff 75 f4             	pushl  -0xc(%ebp)
801062ed:	e8 39 b5 ff ff       	call   8010182b <iupdate>
801062f2:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801062f5:	83 ec 0c             	sub    $0xc,%esp
801062f8:	ff 75 f4             	pushl  -0xc(%ebp)
801062fb:	e8 dd b9 ff ff       	call   80101cdd <iunlockput>
80106300:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106303:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106306:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010630a:	83 e8 01             	sub    $0x1,%eax
8010630d:	89 c2                	mov    %eax,%edx
8010630f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106312:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106316:	83 ec 0c             	sub    $0xc,%esp
80106319:	ff 75 f0             	pushl  -0x10(%ebp)
8010631c:	e8 0a b5 ff ff       	call   8010182b <iupdate>
80106321:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106324:	83 ec 0c             	sub    $0xc,%esp
80106327:	ff 75 f0             	pushl  -0x10(%ebp)
8010632a:	e8 ae b9 ff ff       	call   80101cdd <iunlockput>
8010632f:	83 c4 10             	add    $0x10,%esp

  end_op();
80106332:	e8 f6 d3 ff ff       	call   8010372d <end_op>

  return 0;
80106337:	b8 00 00 00 00       	mov    $0x0,%eax
8010633c:	eb 1c                	jmp    8010635a <sys_unlink+0x1e8>
    goto bad;
8010633e:	90                   	nop
8010633f:	eb 01                	jmp    80106342 <sys_unlink+0x1d0>
    goto bad;
80106341:	90                   	nop

bad:
  iunlockput(dp);
80106342:	83 ec 0c             	sub    $0xc,%esp
80106345:	ff 75 f4             	pushl  -0xc(%ebp)
80106348:	e8 90 b9 ff ff       	call   80101cdd <iunlockput>
8010634d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106350:	e8 d8 d3 ff ff       	call   8010372d <end_op>
  return -1;
80106355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010635a:	c9                   	leave  
8010635b:	c3                   	ret    

8010635c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010635c:	f3 0f 1e fb          	endbr32 
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	83 ec 38             	sub    $0x38,%esp
80106366:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106369:	8b 55 10             	mov    0x10(%ebp),%edx
8010636c:	8b 45 14             	mov    0x14(%ebp),%eax
8010636f:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106373:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106377:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010637b:	83 ec 08             	sub    $0x8,%esp
8010637e:	8d 45 de             	lea    -0x22(%ebp),%eax
80106381:	50                   	push   %eax
80106382:	ff 75 08             	pushl  0x8(%ebp)
80106385:	e8 90 c2 ff ff       	call   8010261a <nameiparent>
8010638a:	83 c4 10             	add    $0x10,%esp
8010638d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106394:	75 0a                	jne    801063a0 <create+0x44>
    return 0;
80106396:	b8 00 00 00 00       	mov    $0x0,%eax
8010639b:	e9 90 01 00 00       	jmp    80106530 <create+0x1d4>
  ilock(dp);
801063a0:	83 ec 0c             	sub    $0xc,%esp
801063a3:	ff 75 f4             	pushl  -0xc(%ebp)
801063a6:	e8 66 b6 ff ff       	call   80101a11 <ilock>
801063ab:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801063ae:	83 ec 04             	sub    $0x4,%esp
801063b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063b4:	50                   	push   %eax
801063b5:	8d 45 de             	lea    -0x22(%ebp),%eax
801063b8:	50                   	push   %eax
801063b9:	ff 75 f4             	pushl  -0xc(%ebp)
801063bc:	e8 d7 be ff ff       	call   80102298 <dirlookup>
801063c1:	83 c4 10             	add    $0x10,%esp
801063c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063cb:	74 50                	je     8010641d <create+0xc1>
    iunlockput(dp);
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	ff 75 f4             	pushl  -0xc(%ebp)
801063d3:	e8 05 b9 ff ff       	call   80101cdd <iunlockput>
801063d8:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801063db:	83 ec 0c             	sub    $0xc,%esp
801063de:	ff 75 f0             	pushl  -0x10(%ebp)
801063e1:	e8 2b b6 ff ff       	call   80101a11 <ilock>
801063e6:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801063e9:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801063ee:	75 15                	jne    80106405 <create+0xa9>
801063f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063f7:	66 83 f8 02          	cmp    $0x2,%ax
801063fb:	75 08                	jne    80106405 <create+0xa9>
      return ip;
801063fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106400:	e9 2b 01 00 00       	jmp    80106530 <create+0x1d4>
    iunlockput(ip);
80106405:	83 ec 0c             	sub    $0xc,%esp
80106408:	ff 75 f0             	pushl  -0x10(%ebp)
8010640b:	e8 cd b8 ff ff       	call   80101cdd <iunlockput>
80106410:	83 c4 10             	add    $0x10,%esp
    return 0;
80106413:	b8 00 00 00 00       	mov    $0x0,%eax
80106418:	e9 13 01 00 00       	jmp    80106530 <create+0x1d4>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010641d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106424:	8b 00                	mov    (%eax),%eax
80106426:	83 ec 08             	sub    $0x8,%esp
80106429:	52                   	push   %edx
8010642a:	50                   	push   %eax
8010642b:	e8 20 b3 ff ff       	call   80101750 <ialloc>
80106430:	83 c4 10             	add    $0x10,%esp
80106433:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010643a:	75 0d                	jne    80106449 <create+0xed>
    panic("create: ialloc");
8010643c:	83 ec 0c             	sub    $0xc,%esp
8010643f:	68 1b 91 10 80       	push   $0x8010911b
80106444:	e8 4e a1 ff ff       	call   80100597 <panic>

  ilock(ip);
80106449:	83 ec 0c             	sub    $0xc,%esp
8010644c:	ff 75 f0             	pushl  -0x10(%ebp)
8010644f:	e8 bd b5 ff ff       	call   80101a11 <ilock>
80106454:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106457:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010645a:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010645e:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106465:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106469:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010646d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106470:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106476:	83 ec 0c             	sub    $0xc,%esp
80106479:	ff 75 f0             	pushl  -0x10(%ebp)
8010647c:	e8 aa b3 ff ff       	call   8010182b <iupdate>
80106481:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106484:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106489:	75 6a                	jne    801064f5 <create+0x199>
    dp->nlink++;  // for ".."
8010648b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106492:	83 c0 01             	add    $0x1,%eax
80106495:	89 c2                	mov    %eax,%edx
80106497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010649a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010649e:	83 ec 0c             	sub    $0xc,%esp
801064a1:	ff 75 f4             	pushl  -0xc(%ebp)
801064a4:	e8 82 b3 ff ff       	call   8010182b <iupdate>
801064a9:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801064ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064af:	8b 40 04             	mov    0x4(%eax),%eax
801064b2:	83 ec 04             	sub    $0x4,%esp
801064b5:	50                   	push   %eax
801064b6:	68 f5 90 10 80       	push   $0x801090f5
801064bb:	ff 75 f0             	pushl  -0x10(%ebp)
801064be:	e8 93 be ff ff       	call   80102356 <dirlink>
801064c3:	83 c4 10             	add    $0x10,%esp
801064c6:	85 c0                	test   %eax,%eax
801064c8:	78 1e                	js     801064e8 <create+0x18c>
801064ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064cd:	8b 40 04             	mov    0x4(%eax),%eax
801064d0:	83 ec 04             	sub    $0x4,%esp
801064d3:	50                   	push   %eax
801064d4:	68 f7 90 10 80       	push   $0x801090f7
801064d9:	ff 75 f0             	pushl  -0x10(%ebp)
801064dc:	e8 75 be ff ff       	call   80102356 <dirlink>
801064e1:	83 c4 10             	add    $0x10,%esp
801064e4:	85 c0                	test   %eax,%eax
801064e6:	79 0d                	jns    801064f5 <create+0x199>
      panic("create dots");
801064e8:	83 ec 0c             	sub    $0xc,%esp
801064eb:	68 2a 91 10 80       	push   $0x8010912a
801064f0:	e8 a2 a0 ff ff       	call   80100597 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801064f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f8:	8b 40 04             	mov    0x4(%eax),%eax
801064fb:	83 ec 04             	sub    $0x4,%esp
801064fe:	50                   	push   %eax
801064ff:	8d 45 de             	lea    -0x22(%ebp),%eax
80106502:	50                   	push   %eax
80106503:	ff 75 f4             	pushl  -0xc(%ebp)
80106506:	e8 4b be ff ff       	call   80102356 <dirlink>
8010650b:	83 c4 10             	add    $0x10,%esp
8010650e:	85 c0                	test   %eax,%eax
80106510:	79 0d                	jns    8010651f <create+0x1c3>
    panic("create: dirlink");
80106512:	83 ec 0c             	sub    $0xc,%esp
80106515:	68 36 91 10 80       	push   $0x80109136
8010651a:	e8 78 a0 ff ff       	call   80100597 <panic>

  iunlockput(dp);
8010651f:	83 ec 0c             	sub    $0xc,%esp
80106522:	ff 75 f4             	pushl  -0xc(%ebp)
80106525:	e8 b3 b7 ff ff       	call   80101cdd <iunlockput>
8010652a:	83 c4 10             	add    $0x10,%esp

  return ip;
8010652d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106530:	c9                   	leave  
80106531:	c3                   	ret    

80106532 <sys_open>:

int
sys_open(void)
{
80106532:	f3 0f 1e fb          	endbr32 
80106536:	55                   	push   %ebp
80106537:	89 e5                	mov    %esp,%ebp
80106539:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010653c:	83 ec 08             	sub    $0x8,%esp
8010653f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106542:	50                   	push   %eax
80106543:	6a 00                	push   $0x0
80106545:	e8 b1 f6 ff ff       	call   80105bfb <argstr>
8010654a:	83 c4 10             	add    $0x10,%esp
8010654d:	85 c0                	test   %eax,%eax
8010654f:	78 15                	js     80106566 <sys_open+0x34>
80106551:	83 ec 08             	sub    $0x8,%esp
80106554:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106557:	50                   	push   %eax
80106558:	6a 01                	push   $0x1
8010655a:	e8 0f f6 ff ff       	call   80105b6e <argint>
8010655f:	83 c4 10             	add    $0x10,%esp
80106562:	85 c0                	test   %eax,%eax
80106564:	79 0a                	jns    80106570 <sys_open+0x3e>
    return -1;
80106566:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010656b:	e9 61 01 00 00       	jmp    801066d1 <sys_open+0x19f>

  begin_op();
80106570:	e8 28 d1 ff ff       	call   8010369d <begin_op>

  if(omode & O_CREATE){
80106575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106578:	25 00 02 00 00       	and    $0x200,%eax
8010657d:	85 c0                	test   %eax,%eax
8010657f:	74 2a                	je     801065ab <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
80106581:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106584:	6a 00                	push   $0x0
80106586:	6a 00                	push   $0x0
80106588:	6a 02                	push   $0x2
8010658a:	50                   	push   %eax
8010658b:	e8 cc fd ff ff       	call   8010635c <create>
80106590:	83 c4 10             	add    $0x10,%esp
80106593:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010659a:	75 75                	jne    80106611 <sys_open+0xdf>
      end_op();
8010659c:	e8 8c d1 ff ff       	call   8010372d <end_op>
      return -1;
801065a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a6:	e9 26 01 00 00       	jmp    801066d1 <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
801065ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065ae:	83 ec 0c             	sub    $0xc,%esp
801065b1:	50                   	push   %eax
801065b2:	e8 43 c0 ff ff       	call   801025fa <namei>
801065b7:	83 c4 10             	add    $0x10,%esp
801065ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065c1:	75 0f                	jne    801065d2 <sys_open+0xa0>
      end_op();
801065c3:	e8 65 d1 ff ff       	call   8010372d <end_op>
      return -1;
801065c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cd:	e9 ff 00 00 00       	jmp    801066d1 <sys_open+0x19f>
    }
    ilock(ip);
801065d2:	83 ec 0c             	sub    $0xc,%esp
801065d5:	ff 75 f4             	pushl  -0xc(%ebp)
801065d8:	e8 34 b4 ff ff       	call   80101a11 <ilock>
801065dd:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801065e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065e7:	66 83 f8 01          	cmp    $0x1,%ax
801065eb:	75 24                	jne    80106611 <sys_open+0xdf>
801065ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065f0:	85 c0                	test   %eax,%eax
801065f2:	74 1d                	je     80106611 <sys_open+0xdf>
      iunlockput(ip);
801065f4:	83 ec 0c             	sub    $0xc,%esp
801065f7:	ff 75 f4             	pushl  -0xc(%ebp)
801065fa:	e8 de b6 ff ff       	call   80101cdd <iunlockput>
801065ff:	83 c4 10             	add    $0x10,%esp
      end_op();
80106602:	e8 26 d1 ff ff       	call   8010372d <end_op>
      return -1;
80106607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660c:	e9 c0 00 00 00       	jmp    801066d1 <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106611:	e8 e8 a9 ff ff       	call   80100ffe <filealloc>
80106616:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106619:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010661d:	74 17                	je     80106636 <sys_open+0x104>
8010661f:	83 ec 0c             	sub    $0xc,%esp
80106622:	ff 75 f0             	pushl  -0x10(%ebp)
80106625:	e8 08 f7 ff ff       	call   80105d32 <fdalloc>
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106630:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106634:	79 2e                	jns    80106664 <sys_open+0x132>
    if(f)
80106636:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010663a:	74 0e                	je     8010664a <sys_open+0x118>
      fileclose(f);
8010663c:	83 ec 0c             	sub    $0xc,%esp
8010663f:	ff 75 f0             	pushl  -0x10(%ebp)
80106642:	e8 7d aa ff ff       	call   801010c4 <fileclose>
80106647:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010664a:	83 ec 0c             	sub    $0xc,%esp
8010664d:	ff 75 f4             	pushl  -0xc(%ebp)
80106650:	e8 88 b6 ff ff       	call   80101cdd <iunlockput>
80106655:	83 c4 10             	add    $0x10,%esp
    end_op();
80106658:	e8 d0 d0 ff ff       	call   8010372d <end_op>
    return -1;
8010665d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106662:	eb 6d                	jmp    801066d1 <sys_open+0x19f>
  }
  iunlock(ip);
80106664:	83 ec 0c             	sub    $0xc,%esp
80106667:	ff 75 f4             	pushl  -0xc(%ebp)
8010666a:	e8 04 b5 ff ff       	call   80101b73 <iunlock>
8010666f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106672:	e8 b6 d0 ff ff       	call   8010372d <end_op>

  f->type = FD_INODE;
80106677:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010667a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106680:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106683:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106686:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106689:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010668c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106696:	83 e0 01             	and    $0x1,%eax
80106699:	85 c0                	test   %eax,%eax
8010669b:	0f 94 c0             	sete   %al
8010669e:	89 c2                	mov    %eax,%edx
801066a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a3:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801066a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066a9:	83 e0 01             	and    $0x1,%eax
801066ac:	85 c0                	test   %eax,%eax
801066ae:	75 0a                	jne    801066ba <sys_open+0x188>
801066b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066b3:	83 e0 02             	and    $0x2,%eax
801066b6:	85 c0                	test   %eax,%eax
801066b8:	74 07                	je     801066c1 <sys_open+0x18f>
801066ba:	b8 01 00 00 00       	mov    $0x1,%eax
801066bf:	eb 05                	jmp    801066c6 <sys_open+0x194>
801066c1:	b8 00 00 00 00       	mov    $0x0,%eax
801066c6:	89 c2                	mov    %eax,%edx
801066c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066cb:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801066ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801066d1:	c9                   	leave  
801066d2:	c3                   	ret    

801066d3 <sys_mkdir>:

int
sys_mkdir(void)
{
801066d3:	f3 0f 1e fb          	endbr32 
801066d7:	55                   	push   %ebp
801066d8:	89 e5                	mov    %esp,%ebp
801066da:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801066dd:	e8 bb cf ff ff       	call   8010369d <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801066e2:	83 ec 08             	sub    $0x8,%esp
801066e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066e8:	50                   	push   %eax
801066e9:	6a 00                	push   $0x0
801066eb:	e8 0b f5 ff ff       	call   80105bfb <argstr>
801066f0:	83 c4 10             	add    $0x10,%esp
801066f3:	85 c0                	test   %eax,%eax
801066f5:	78 1b                	js     80106712 <sys_mkdir+0x3f>
801066f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066fa:	6a 00                	push   $0x0
801066fc:	6a 00                	push   $0x0
801066fe:	6a 01                	push   $0x1
80106700:	50                   	push   %eax
80106701:	e8 56 fc ff ff       	call   8010635c <create>
80106706:	83 c4 10             	add    $0x10,%esp
80106709:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010670c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106710:	75 0c                	jne    8010671e <sys_mkdir+0x4b>
    end_op();
80106712:	e8 16 d0 ff ff       	call   8010372d <end_op>
    return -1;
80106717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671c:	eb 18                	jmp    80106736 <sys_mkdir+0x63>
  }
  iunlockput(ip);
8010671e:	83 ec 0c             	sub    $0xc,%esp
80106721:	ff 75 f4             	pushl  -0xc(%ebp)
80106724:	e8 b4 b5 ff ff       	call   80101cdd <iunlockput>
80106729:	83 c4 10             	add    $0x10,%esp
  end_op();
8010672c:	e8 fc cf ff ff       	call   8010372d <end_op>
  return 0;
80106731:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106736:	c9                   	leave  
80106737:	c3                   	ret    

80106738 <sys_mknod>:

int
sys_mknod(void)
{
80106738:	f3 0f 1e fb          	endbr32 
8010673c:	55                   	push   %ebp
8010673d:	89 e5                	mov    %esp,%ebp
8010673f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106742:	e8 56 cf ff ff       	call   8010369d <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106747:	83 ec 08             	sub    $0x8,%esp
8010674a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010674d:	50                   	push   %eax
8010674e:	6a 00                	push   $0x0
80106750:	e8 a6 f4 ff ff       	call   80105bfb <argstr>
80106755:	83 c4 10             	add    $0x10,%esp
80106758:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010675b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010675f:	78 4f                	js     801067b0 <sys_mknod+0x78>
     argint(1, &major) < 0 ||
80106761:	83 ec 08             	sub    $0x8,%esp
80106764:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106767:	50                   	push   %eax
80106768:	6a 01                	push   $0x1
8010676a:	e8 ff f3 ff ff       	call   80105b6e <argint>
8010676f:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
80106772:	85 c0                	test   %eax,%eax
80106774:	78 3a                	js     801067b0 <sys_mknod+0x78>
     argint(2, &minor) < 0 ||
80106776:	83 ec 08             	sub    $0x8,%esp
80106779:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010677c:	50                   	push   %eax
8010677d:	6a 02                	push   $0x2
8010677f:	e8 ea f3 ff ff       	call   80105b6e <argint>
80106784:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106787:	85 c0                	test   %eax,%eax
80106789:	78 25                	js     801067b0 <sys_mknod+0x78>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010678b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010678e:	0f bf c8             	movswl %ax,%ecx
80106791:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106794:	0f bf d0             	movswl %ax,%edx
80106797:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010679a:	51                   	push   %ecx
8010679b:	52                   	push   %edx
8010679c:	6a 03                	push   $0x3
8010679e:	50                   	push   %eax
8010679f:	e8 b8 fb ff ff       	call   8010635c <create>
801067a4:	83 c4 10             	add    $0x10,%esp
801067a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     argint(2, &minor) < 0 ||
801067aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067ae:	75 0c                	jne    801067bc <sys_mknod+0x84>
    end_op();
801067b0:	e8 78 cf ff ff       	call   8010372d <end_op>
    return -1;
801067b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ba:	eb 18                	jmp    801067d4 <sys_mknod+0x9c>
  }
  iunlockput(ip);
801067bc:	83 ec 0c             	sub    $0xc,%esp
801067bf:	ff 75 f0             	pushl  -0x10(%ebp)
801067c2:	e8 16 b5 ff ff       	call   80101cdd <iunlockput>
801067c7:	83 c4 10             	add    $0x10,%esp
  end_op();
801067ca:	e8 5e cf ff ff       	call   8010372d <end_op>
  return 0;
801067cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067d4:	c9                   	leave  
801067d5:	c3                   	ret    

801067d6 <sys_chdir>:

int
sys_chdir(void)
{
801067d6:	f3 0f 1e fb          	endbr32 
801067da:	55                   	push   %ebp
801067db:	89 e5                	mov    %esp,%ebp
801067dd:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801067e0:	e8 b8 ce ff ff       	call   8010369d <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801067e5:	83 ec 08             	sub    $0x8,%esp
801067e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067eb:	50                   	push   %eax
801067ec:	6a 00                	push   $0x0
801067ee:	e8 08 f4 ff ff       	call   80105bfb <argstr>
801067f3:	83 c4 10             	add    $0x10,%esp
801067f6:	85 c0                	test   %eax,%eax
801067f8:	78 18                	js     80106812 <sys_chdir+0x3c>
801067fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067fd:	83 ec 0c             	sub    $0xc,%esp
80106800:	50                   	push   %eax
80106801:	e8 f4 bd ff ff       	call   801025fa <namei>
80106806:	83 c4 10             	add    $0x10,%esp
80106809:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010680c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106810:	75 0c                	jne    8010681e <sys_chdir+0x48>
    end_op();
80106812:	e8 16 cf ff ff       	call   8010372d <end_op>
    return -1;
80106817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681c:	eb 6e                	jmp    8010688c <sys_chdir+0xb6>
  }
  ilock(ip);
8010681e:	83 ec 0c             	sub    $0xc,%esp
80106821:	ff 75 f4             	pushl  -0xc(%ebp)
80106824:	e8 e8 b1 ff ff       	call   80101a11 <ilock>
80106829:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010682c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010682f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106833:	66 83 f8 01          	cmp    $0x1,%ax
80106837:	74 1a                	je     80106853 <sys_chdir+0x7d>
    iunlockput(ip);
80106839:	83 ec 0c             	sub    $0xc,%esp
8010683c:	ff 75 f4             	pushl  -0xc(%ebp)
8010683f:	e8 99 b4 ff ff       	call   80101cdd <iunlockput>
80106844:	83 c4 10             	add    $0x10,%esp
    end_op();
80106847:	e8 e1 ce ff ff       	call   8010372d <end_op>
    return -1;
8010684c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106851:	eb 39                	jmp    8010688c <sys_chdir+0xb6>
  }
  iunlock(ip);
80106853:	83 ec 0c             	sub    $0xc,%esp
80106856:	ff 75 f4             	pushl  -0xc(%ebp)
80106859:	e8 15 b3 ff ff       	call   80101b73 <iunlock>
8010685e:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106861:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106867:	8b 40 68             	mov    0x68(%eax),%eax
8010686a:	83 ec 0c             	sub    $0xc,%esp
8010686d:	50                   	push   %eax
8010686e:	e8 76 b3 ff ff       	call   80101be9 <iput>
80106873:	83 c4 10             	add    $0x10,%esp
  end_op();
80106876:	e8 b2 ce ff ff       	call   8010372d <end_op>
  proc->cwd = ip;
8010687b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106881:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106884:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106887:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010688c:	c9                   	leave  
8010688d:	c3                   	ret    

8010688e <sys_exec>:

int
sys_exec(void)
{
8010688e:	f3 0f 1e fb          	endbr32 
80106892:	55                   	push   %ebp
80106893:	89 e5                	mov    %esp,%ebp
80106895:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010689b:	83 ec 08             	sub    $0x8,%esp
8010689e:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068a1:	50                   	push   %eax
801068a2:	6a 00                	push   $0x0
801068a4:	e8 52 f3 ff ff       	call   80105bfb <argstr>
801068a9:	83 c4 10             	add    $0x10,%esp
801068ac:	85 c0                	test   %eax,%eax
801068ae:	78 18                	js     801068c8 <sys_exec+0x3a>
801068b0:	83 ec 08             	sub    $0x8,%esp
801068b3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801068b9:	50                   	push   %eax
801068ba:	6a 01                	push   $0x1
801068bc:	e8 ad f2 ff ff       	call   80105b6e <argint>
801068c1:	83 c4 10             	add    $0x10,%esp
801068c4:	85 c0                	test   %eax,%eax
801068c6:	79 0a                	jns    801068d2 <sys_exec+0x44>
    return -1;
801068c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068cd:	e9 c6 00 00 00       	jmp    80106998 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
801068d2:	83 ec 04             	sub    $0x4,%esp
801068d5:	68 80 00 00 00       	push   $0x80
801068da:	6a 00                	push   $0x0
801068dc:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801068e2:	50                   	push   %eax
801068e3:	e8 39 ef ff ff       	call   80105821 <memset>
801068e8:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801068eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801068f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f5:	83 f8 1f             	cmp    $0x1f,%eax
801068f8:	76 0a                	jbe    80106904 <sys_exec+0x76>
      return -1;
801068fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ff:	e9 94 00 00 00       	jmp    80106998 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106907:	c1 e0 02             	shl    $0x2,%eax
8010690a:	89 c2                	mov    %eax,%edx
8010690c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106912:	01 c2                	add    %eax,%edx
80106914:	83 ec 08             	sub    $0x8,%esp
80106917:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010691d:	50                   	push   %eax
8010691e:	52                   	push   %edx
8010691f:	e8 a6 f1 ff ff       	call   80105aca <fetchint>
80106924:	83 c4 10             	add    $0x10,%esp
80106927:	85 c0                	test   %eax,%eax
80106929:	79 07                	jns    80106932 <sys_exec+0xa4>
      return -1;
8010692b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106930:	eb 66                	jmp    80106998 <sys_exec+0x10a>
    if(uarg == 0){
80106932:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106938:	85 c0                	test   %eax,%eax
8010693a:	75 27                	jne    80106963 <sys_exec+0xd5>
      argv[i] = 0;
8010693c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010693f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106946:	00 00 00 00 
      break;
8010694a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010694b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010694e:	83 ec 08             	sub    $0x8,%esp
80106951:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106957:	52                   	push   %edx
80106958:	50                   	push   %eax
80106959:	e8 76 a2 ff ff       	call   80100bd4 <exec>
8010695e:	83 c4 10             	add    $0x10,%esp
80106961:	eb 35                	jmp    80106998 <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
80106963:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106969:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010696c:	c1 e2 02             	shl    $0x2,%edx
8010696f:	01 c2                	add    %eax,%edx
80106971:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106977:	83 ec 08             	sub    $0x8,%esp
8010697a:	52                   	push   %edx
8010697b:	50                   	push   %eax
8010697c:	e8 87 f1 ff ff       	call   80105b08 <fetchstr>
80106981:	83 c4 10             	add    $0x10,%esp
80106984:	85 c0                	test   %eax,%eax
80106986:	79 07                	jns    8010698f <sys_exec+0x101>
      return -1;
80106988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010698d:	eb 09                	jmp    80106998 <sys_exec+0x10a>
  for(i=0;; i++){
8010698f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106993:	e9 5a ff ff ff       	jmp    801068f2 <sys_exec+0x64>
}
80106998:	c9                   	leave  
80106999:	c3                   	ret    

8010699a <sys_pipe>:

int
sys_pipe(void)
{
8010699a:	f3 0f 1e fb          	endbr32 
8010699e:	55                   	push   %ebp
8010699f:	89 e5                	mov    %esp,%ebp
801069a1:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801069a4:	83 ec 04             	sub    $0x4,%esp
801069a7:	6a 08                	push   $0x8
801069a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069ac:	50                   	push   %eax
801069ad:	6a 00                	push   $0x0
801069af:	e8 e6 f1 ff ff       	call   80105b9a <argptr>
801069b4:	83 c4 10             	add    $0x10,%esp
801069b7:	85 c0                	test   %eax,%eax
801069b9:	79 0a                	jns    801069c5 <sys_pipe+0x2b>
    return -1;
801069bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c0:	e9 af 00 00 00       	jmp    80106a74 <sys_pipe+0xda>
  if(pipealloc(&rf, &wf) < 0)
801069c5:	83 ec 08             	sub    $0x8,%esp
801069c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069cb:	50                   	push   %eax
801069cc:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069cf:	50                   	push   %eax
801069d0:	e8 22 d8 ff ff       	call   801041f7 <pipealloc>
801069d5:	83 c4 10             	add    $0x10,%esp
801069d8:	85 c0                	test   %eax,%eax
801069da:	79 0a                	jns    801069e6 <sys_pipe+0x4c>
    return -1;
801069dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069e1:	e9 8e 00 00 00       	jmp    80106a74 <sys_pipe+0xda>
  fd0 = -1;
801069e6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069f0:	83 ec 0c             	sub    $0xc,%esp
801069f3:	50                   	push   %eax
801069f4:	e8 39 f3 ff ff       	call   80105d32 <fdalloc>
801069f9:	83 c4 10             	add    $0x10,%esp
801069fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a03:	78 18                	js     80106a1d <sys_pipe+0x83>
80106a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a08:	83 ec 0c             	sub    $0xc,%esp
80106a0b:	50                   	push   %eax
80106a0c:	e8 21 f3 ff ff       	call   80105d32 <fdalloc>
80106a11:	83 c4 10             	add    $0x10,%esp
80106a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a1b:	79 3f                	jns    80106a5c <sys_pipe+0xc2>
    if(fd0 >= 0)
80106a1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a21:	78 14                	js     80106a37 <sys_pipe+0x9d>
      proc->ofile[fd0] = 0;
80106a23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a2c:	83 c2 08             	add    $0x8,%edx
80106a2f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a36:	00 
    fileclose(rf);
80106a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a3a:	83 ec 0c             	sub    $0xc,%esp
80106a3d:	50                   	push   %eax
80106a3e:	e8 81 a6 ff ff       	call   801010c4 <fileclose>
80106a43:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a49:	83 ec 0c             	sub    $0xc,%esp
80106a4c:	50                   	push   %eax
80106a4d:	e8 72 a6 ff ff       	call   801010c4 <fileclose>
80106a52:	83 c4 10             	add    $0x10,%esp
    return -1;
80106a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a5a:	eb 18                	jmp    80106a74 <sys_pipe+0xda>
  }
  fd[0] = fd0;
80106a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a62:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a67:	8d 50 04             	lea    0x4(%eax),%edx
80106a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a6d:	89 02                	mov    %eax,(%edx)
  return 0;
80106a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a74:	c9                   	leave  
80106a75:	c3                   	ret    

80106a76 <sys_fork>:
#include "proc.h"


int
sys_fork(void)
{
80106a76:	f3 0f 1e fb          	endbr32 
80106a7a:	55                   	push   %ebp
80106a7b:	89 e5                	mov    %esp,%ebp
80106a7d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106a80:	e8 f3 de ff ff       	call   80104978 <fork>
}
80106a85:	c9                   	leave  
80106a86:	c3                   	ret    

80106a87 <sys_exit>:

int
sys_exit(void)
{
80106a87:	f3 0f 1e fb          	endbr32 
80106a8b:	55                   	push   %ebp
80106a8c:	89 e5                	mov    %esp,%ebp
80106a8e:	83 ec 08             	sub    $0x8,%esp
  exit();
80106a91:	e8 73 e0 ff ff       	call   80104b09 <exit>
  return 0;  // not reached
80106a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a9b:	c9                   	leave  
80106a9c:	c3                   	ret    

80106a9d <sys_wait>:

int
sys_wait(void)
{
80106a9d:	f3 0f 1e fb          	endbr32 
80106aa1:	55                   	push   %ebp
80106aa2:	89 e5                	mov    %esp,%ebp
80106aa4:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106aa7:	e8 ce e1 ff ff       	call   80104c7a <wait>
}
80106aac:	c9                   	leave  
80106aad:	c3                   	ret    

80106aae <sys_wait_stat>:

// presenting stats to user
int
sys_wait_stat(void)
{
80106aae:	f3 0f 1e fb          	endbr32 
80106ab2:	55                   	push   %ebp
80106ab3:	89 e5                	mov    %esp,%ebp
80106ab5:	53                   	push   %ebx
80106ab6:	83 ec 14             	sub    $0x14,%esp
  int* wtime; // wait time
  int* rtime; // run time
  int* iotime; // clock ticks in which it was waiting for io
  int* status; // status
// scheduler
  if(argptr(0, (void*)&wtime, sizeof(wtime)) < 0)
80106ab9:	83 ec 04             	sub    $0x4,%esp
80106abc:	6a 04                	push   $0x4
80106abe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ac1:	50                   	push   %eax
80106ac2:	6a 00                	push   $0x0
80106ac4:	e8 d1 f0 ff ff       	call   80105b9a <argptr>
80106ac9:	83 c4 10             	add    $0x10,%esp
80106acc:	85 c0                	test   %eax,%eax
80106ace:	79 07                	jns    80106ad7 <sys_wait_stat+0x29>
    return -1;
80106ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ad5:	eb 72                	jmp    80106b49 <sys_wait_stat+0x9b>
  if(argptr(1, (void*)&rtime, sizeof(rtime)) < 0)
80106ad7:	83 ec 04             	sub    $0x4,%esp
80106ada:	6a 04                	push   $0x4
80106adc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106adf:	50                   	push   %eax
80106ae0:	6a 01                	push   $0x1
80106ae2:	e8 b3 f0 ff ff       	call   80105b9a <argptr>
80106ae7:	83 c4 10             	add    $0x10,%esp
80106aea:	85 c0                	test   %eax,%eax
80106aec:	79 07                	jns    80106af5 <sys_wait_stat+0x47>
    return -1;
80106aee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af3:	eb 54                	jmp    80106b49 <sys_wait_stat+0x9b>
  if(argptr(2, (void*)&iotime, sizeof(iotime)) < 0)
80106af5:	83 ec 04             	sub    $0x4,%esp
80106af8:	6a 04                	push   $0x4
80106afa:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106afd:	50                   	push   %eax
80106afe:	6a 02                	push   $0x2
80106b00:	e8 95 f0 ff ff       	call   80105b9a <argptr>
80106b05:	83 c4 10             	add    $0x10,%esp
80106b08:	85 c0                	test   %eax,%eax
80106b0a:	79 07                	jns    80106b13 <sys_wait_stat+0x65>
    return -1;
80106b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b11:	eb 36                	jmp    80106b49 <sys_wait_stat+0x9b>
  if(argptr(3, (void*)&status, sizeof(status)) < 0)
80106b13:	83 ec 04             	sub    $0x4,%esp
80106b16:	6a 04                	push   $0x4
80106b18:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b1b:	50                   	push   %eax
80106b1c:	6a 03                	push   $0x3
80106b1e:	e8 77 f0 ff ff       	call   80105b9a <argptr>
80106b23:	83 c4 10             	add    $0x10,%esp
80106b26:	85 c0                	test   %eax,%eax
80106b28:	79 07                	jns    80106b31 <sys_wait_stat+0x83>
    return -1;
80106b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b2f:	eb 18                	jmp    80106b49 <sys_wait_stat+0x9b>
  return wait_stat((int*)wtime, (int*)rtime, (int*)iotime, (int*)status);
80106b31:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80106b34:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106b37:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b3d:	53                   	push   %ebx
80106b3e:	51                   	push   %ecx
80106b3f:	52                   	push   %edx
80106b40:	50                   	push   %eax
80106b41:	e8 53 e8 ff ff       	call   80105399 <wait_stat>
80106b46:	83 c4 10             	add    $0x10,%esp
}
80106b49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b4c:	c9                   	leave  
80106b4d:	c3                   	ret    

80106b4e <sys_kill>:


int
sys_kill(void)
{
80106b4e:	f3 0f 1e fb          	endbr32 
80106b52:	55                   	push   %ebp
80106b53:	89 e5                	mov    %esp,%ebp
80106b55:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b58:	83 ec 08             	sub    $0x8,%esp
80106b5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b5e:	50                   	push   %eax
80106b5f:	6a 00                	push   $0x0
80106b61:	e8 08 f0 ff ff       	call   80105b6e <argint>
80106b66:	83 c4 10             	add    $0x10,%esp
80106b69:	85 c0                	test   %eax,%eax
80106b6b:	79 07                	jns    80106b74 <sys_kill+0x26>
    return -1;
80106b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b72:	eb 0f                	jmp    80106b83 <sys_kill+0x35>
  return kill(pid);
80106b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b77:	83 ec 0c             	sub    $0xc,%esp
80106b7a:	50                   	push   %eax
80106b7b:	e8 b4 e5 ff ff       	call   80105134 <kill>
80106b80:	83 c4 10             	add    $0x10,%esp
}
80106b83:	c9                   	leave  
80106b84:	c3                   	ret    

80106b85 <sys_getpid>:

int
sys_getpid(void)
{
80106b85:	f3 0f 1e fb          	endbr32 
80106b89:	55                   	push   %ebp
80106b8a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b92:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b95:	5d                   	pop    %ebp
80106b96:	c3                   	ret    

80106b97 <sys_sbrk>:

int
sys_sbrk(void)
{
80106b97:	f3 0f 1e fb          	endbr32 
80106b9b:	55                   	push   %ebp
80106b9c:	89 e5                	mov    %esp,%ebp
80106b9e:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106ba1:	83 ec 08             	sub    $0x8,%esp
80106ba4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ba7:	50                   	push   %eax
80106ba8:	6a 00                	push   $0x0
80106baa:	e8 bf ef ff ff       	call   80105b6e <argint>
80106baf:	83 c4 10             	add    $0x10,%esp
80106bb2:	85 c0                	test   %eax,%eax
80106bb4:	79 07                	jns    80106bbd <sys_sbrk+0x26>
    return -1;
80106bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bbb:	eb 28                	jmp    80106be5 <sys_sbrk+0x4e>
  addr = proc->sz;
80106bbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bc3:	8b 00                	mov    (%eax),%eax
80106bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bcb:	83 ec 0c             	sub    $0xc,%esp
80106bce:	50                   	push   %eax
80106bcf:	e8 fd dc ff ff       	call   801048d1 <growproc>
80106bd4:	83 c4 10             	add    $0x10,%esp
80106bd7:	85 c0                	test   %eax,%eax
80106bd9:	79 07                	jns    80106be2 <sys_sbrk+0x4b>
    return -1;
80106bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be0:	eb 03                	jmp    80106be5 <sys_sbrk+0x4e>
  return addr;
80106be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106be5:	c9                   	leave  
80106be6:	c3                   	ret    

80106be7 <sys_sleep>:

int
sys_sleep(void)
{
80106be7:	f3 0f 1e fb          	endbr32 
80106beb:	55                   	push   %ebp
80106bec:	89 e5                	mov    %esp,%ebp
80106bee:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106bf1:	83 ec 08             	sub    $0x8,%esp
80106bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bf7:	50                   	push   %eax
80106bf8:	6a 00                	push   $0x0
80106bfa:	e8 6f ef ff ff       	call   80105b6e <argint>
80106bff:	83 c4 10             	add    $0x10,%esp
80106c02:	85 c0                	test   %eax,%eax
80106c04:	79 07                	jns    80106c0d <sys_sleep+0x26>
    return -1;
80106c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c0b:	eb 77                	jmp    80106c84 <sys_sleep+0x9d>
  acquire(&tickslock);
80106c0d:	83 ec 0c             	sub    $0xc,%esp
80106c10:	68 a0 5d 11 80       	push   $0x80115da0
80106c15:	e8 8b e9 ff ff       	call   801055a5 <acquire>
80106c1a:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106c1d:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106c25:	eb 39                	jmp    80106c60 <sys_sleep+0x79>
    if(proc->killed){
80106c27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c2d:	8b 40 24             	mov    0x24(%eax),%eax
80106c30:	85 c0                	test   %eax,%eax
80106c32:	74 17                	je     80106c4b <sys_sleep+0x64>
      release(&tickslock);
80106c34:	83 ec 0c             	sub    $0xc,%esp
80106c37:	68 a0 5d 11 80       	push   $0x80115da0
80106c3c:	e8 cf e9 ff ff       	call   80105610 <release>
80106c41:	83 c4 10             	add    $0x10,%esp
      return -1;
80106c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c49:	eb 39                	jmp    80106c84 <sys_sleep+0x9d>
    }
    sleep(&ticks, &tickslock);
80106c4b:	83 ec 08             	sub    $0x8,%esp
80106c4e:	68 a0 5d 11 80       	push   $0x80115da0
80106c53:	68 e0 65 11 80       	push   $0x801165e0
80106c58:	e8 a5 e3 ff ff       	call   80105002 <sleep>
80106c5d:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106c60:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106c65:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c6b:	39 d0                	cmp    %edx,%eax
80106c6d:	72 b8                	jb     80106c27 <sys_sleep+0x40>
  }
  release(&tickslock);
80106c6f:	83 ec 0c             	sub    $0xc,%esp
80106c72:	68 a0 5d 11 80       	push   $0x80115da0
80106c77:	e8 94 e9 ff ff       	call   80105610 <release>
80106c7c:	83 c4 10             	add    $0x10,%esp
  return 0;
80106c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c84:	c9                   	leave  
80106c85:	c3                   	ret    

80106c86 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c86:	f3 0f 1e fb          	endbr32 
80106c8a:	55                   	push   %ebp
80106c8b:	89 e5                	mov    %esp,%ebp
80106c8d:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c90:	83 ec 0c             	sub    $0xc,%esp
80106c93:	68 a0 5d 11 80       	push   $0x80115da0
80106c98:	e8 08 e9 ff ff       	call   801055a5 <acquire>
80106c9d:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106ca0:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106ca8:	83 ec 0c             	sub    $0xc,%esp
80106cab:	68 a0 5d 11 80       	push   $0x80115da0
80106cb0:	e8 5b e9 ff ff       	call   80105610 <release>
80106cb5:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106cbb:	c9                   	leave  
80106cbc:	c3                   	ret    

80106cbd <outb>:
{
80106cbd:	55                   	push   %ebp
80106cbe:	89 e5                	mov    %esp,%ebp
80106cc0:	83 ec 08             	sub    $0x8,%esp
80106cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cc9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106ccd:	89 d0                	mov    %edx,%eax
80106ccf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106cd2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106cd6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106cda:	ee                   	out    %al,(%dx)
}
80106cdb:	90                   	nop
80106cdc:	c9                   	leave  
80106cdd:	c3                   	ret    

80106cde <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106cde:	f3 0f 1e fb          	endbr32 
80106ce2:	55                   	push   %ebp
80106ce3:	89 e5                	mov    %esp,%ebp
80106ce5:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106ce8:	6a 34                	push   $0x34
80106cea:	6a 43                	push   $0x43
80106cec:	e8 cc ff ff ff       	call   80106cbd <outb>
80106cf1:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106cf4:	68 9c 00 00 00       	push   $0x9c
80106cf9:	6a 40                	push   $0x40
80106cfb:	e8 bd ff ff ff       	call   80106cbd <outb>
80106d00:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106d03:	6a 2e                	push   $0x2e
80106d05:	6a 40                	push   $0x40
80106d07:	e8 b1 ff ff ff       	call   80106cbd <outb>
80106d0c:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106d0f:	83 ec 0c             	sub    $0xc,%esp
80106d12:	6a 00                	push   $0x0
80106d14:	e8 c0 d3 ff ff       	call   801040d9 <picenable>
80106d19:	83 c4 10             	add    $0x10,%esp
}
80106d1c:	90                   	nop
80106d1d:	c9                   	leave  
80106d1e:	c3                   	ret    

80106d1f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d1f:	1e                   	push   %ds
  pushl %es
80106d20:	06                   	push   %es
  pushl %fs
80106d21:	0f a0                	push   %fs
  pushl %gs
80106d23:	0f a8                	push   %gs
  pushal
80106d25:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106d26:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d2a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d2c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106d2e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d32:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d34:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d36:	54                   	push   %esp
  call trap
80106d37:	e8 df 01 00 00       	call   80106f1b <trap>
  addl $4, %esp
80106d3c:	83 c4 04             	add    $0x4,%esp

80106d3f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d3f:	61                   	popa   
  popl %gs
80106d40:	0f a9                	pop    %gs
  popl %fs
80106d42:	0f a1                	pop    %fs
  popl %es
80106d44:	07                   	pop    %es
  popl %ds
80106d45:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d46:	83 c4 08             	add    $0x8,%esp
  iret
80106d49:	cf                   	iret   

80106d4a <lidt>:
{
80106d4a:	55                   	push   %ebp
80106d4b:	89 e5                	mov    %esp,%ebp
80106d4d:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106d50:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d53:	83 e8 01             	sub    $0x1,%eax
80106d56:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d61:	8b 45 08             	mov    0x8(%ebp),%eax
80106d64:	c1 e8 10             	shr    $0x10,%eax
80106d67:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106d6b:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d6e:	0f 01 18             	lidtl  (%eax)
}
80106d71:	90                   	nop
80106d72:	c9                   	leave  
80106d73:	c3                   	ret    

80106d74 <rcr2>:

static inline uint
rcr2(void)
{
80106d74:	55                   	push   %ebp
80106d75:	89 e5                	mov    %esp,%ebp
80106d77:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d7a:	0f 20 d0             	mov    %cr2,%eax
80106d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d83:	c9                   	leave  
80106d84:	c3                   	ret    

80106d85 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106d85:	f3 0f 1e fb          	endbr32 
80106d89:	55                   	push   %ebp
80106d8a:	89 e5                	mov    %esp,%ebp
80106d8c:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d96:	e9 c3 00 00 00       	jmp    80106e5e <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d9e:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
80106da5:	89 c2                	mov    %eax,%edx
80106da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106daa:	66 89 14 c5 e0 5d 11 	mov    %dx,-0x7feea220(,%eax,8)
80106db1:	80 
80106db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db5:	66 c7 04 c5 e2 5d 11 	movw   $0x8,-0x7feea21e(,%eax,8)
80106dbc:	80 08 00 
80106dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc2:	0f b6 14 c5 e4 5d 11 	movzbl -0x7feea21c(,%eax,8),%edx
80106dc9:	80 
80106dca:	83 e2 e0             	and    $0xffffffe0,%edx
80106dcd:	88 14 c5 e4 5d 11 80 	mov    %dl,-0x7feea21c(,%eax,8)
80106dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dd7:	0f b6 14 c5 e4 5d 11 	movzbl -0x7feea21c(,%eax,8),%edx
80106dde:	80 
80106ddf:	83 e2 1f             	and    $0x1f,%edx
80106de2:	88 14 c5 e4 5d 11 80 	mov    %dl,-0x7feea21c(,%eax,8)
80106de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dec:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
80106df3:	80 
80106df4:	83 e2 f0             	and    $0xfffffff0,%edx
80106df7:	83 ca 0e             	or     $0xe,%edx
80106dfa:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
80106e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e04:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
80106e0b:	80 
80106e0c:	83 e2 ef             	and    $0xffffffef,%edx
80106e0f:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
80106e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e19:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
80106e20:	80 
80106e21:	83 e2 9f             	and    $0xffffff9f,%edx
80106e24:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
80106e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e2e:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
80106e35:	80 
80106e36:	83 ca 80             	or     $0xffffff80,%edx
80106e39:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
80106e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e43:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
80106e4a:	c1 e8 10             	shr    $0x10,%eax
80106e4d:	89 c2                	mov    %eax,%edx
80106e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e52:	66 89 14 c5 e6 5d 11 	mov    %dx,-0x7feea21a(,%eax,8)
80106e59:	80 
  for(i = 0; i < 256; i++)
80106e5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e5e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106e65:	0f 8e 30 ff ff ff    	jle    80106d9b <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e6b:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
80106e70:	66 a3 e0 5f 11 80    	mov    %ax,0x80115fe0
80106e76:	66 c7 05 e2 5f 11 80 	movw   $0x8,0x80115fe2
80106e7d:	08 00 
80106e7f:	0f b6 05 e4 5f 11 80 	movzbl 0x80115fe4,%eax
80106e86:	83 e0 e0             	and    $0xffffffe0,%eax
80106e89:	a2 e4 5f 11 80       	mov    %al,0x80115fe4
80106e8e:	0f b6 05 e4 5f 11 80 	movzbl 0x80115fe4,%eax
80106e95:	83 e0 1f             	and    $0x1f,%eax
80106e98:	a2 e4 5f 11 80       	mov    %al,0x80115fe4
80106e9d:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
80106ea4:	83 c8 0f             	or     $0xf,%eax
80106ea7:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
80106eac:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
80106eb3:	83 e0 ef             	and    $0xffffffef,%eax
80106eb6:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
80106ebb:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
80106ec2:	83 c8 60             	or     $0x60,%eax
80106ec5:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
80106eca:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
80106ed1:	83 c8 80             	or     $0xffffff80,%eax
80106ed4:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
80106ed9:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
80106ede:	c1 e8 10             	shr    $0x10,%eax
80106ee1:	66 a3 e6 5f 11 80    	mov    %ax,0x80115fe6
  
  initlock(&tickslock, "time");
80106ee7:	83 ec 08             	sub    $0x8,%esp
80106eea:	68 48 91 10 80       	push   $0x80109148
80106eef:	68 a0 5d 11 80       	push   $0x80115da0
80106ef4:	e8 86 e6 ff ff       	call   8010557f <initlock>
80106ef9:	83 c4 10             	add    $0x10,%esp
}
80106efc:	90                   	nop
80106efd:	c9                   	leave  
80106efe:	c3                   	ret    

80106eff <idtinit>:

void
idtinit(void)
{
80106eff:	f3 0f 1e fb          	endbr32 
80106f03:	55                   	push   %ebp
80106f04:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106f06:	68 00 08 00 00       	push   $0x800
80106f0b:	68 e0 5d 11 80       	push   $0x80115de0
80106f10:	e8 35 fe ff ff       	call   80106d4a <lidt>
80106f15:	83 c4 08             	add    $0x8,%esp
}
80106f18:	90                   	nop
80106f19:	c9                   	leave  
80106f1a:	c3                   	ret    

80106f1b <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106f1b:	f3 0f 1e fb          	endbr32 
80106f1f:	55                   	push   %ebp
80106f20:	89 e5                	mov    %esp,%ebp
80106f22:	57                   	push   %edi
80106f23:	56                   	push   %esi
80106f24:	53                   	push   %ebx
80106f25:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106f28:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2b:	8b 40 30             	mov    0x30(%eax),%eax
80106f2e:	83 f8 40             	cmp    $0x40,%eax
80106f31:	75 3e                	jne    80106f71 <trap+0x56>
    if(proc->killed)
80106f33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f39:	8b 40 24             	mov    0x24(%eax),%eax
80106f3c:	85 c0                	test   %eax,%eax
80106f3e:	74 05                	je     80106f45 <trap+0x2a>
      exit();
80106f40:	e8 c4 db ff ff       	call   80104b09 <exit>
    proc->tf = tf;
80106f45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f4b:	8b 55 08             	mov    0x8(%ebp),%edx
80106f4e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f51:	e8 da ec ff ff       	call   80105c30 <syscall>
    if(proc->killed)
80106f56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f5c:	8b 40 24             	mov    0x24(%eax),%eax
80106f5f:	85 c0                	test   %eax,%eax
80106f61:	0f 84 22 02 00 00    	je     80107189 <trap+0x26e>
      exit();
80106f67:	e8 9d db ff ff       	call   80104b09 <exit>
    return;
80106f6c:	e9 18 02 00 00       	jmp    80107189 <trap+0x26e>
  }

  switch(tf->trapno){
80106f71:	8b 45 08             	mov    0x8(%ebp),%eax
80106f74:	8b 40 30             	mov    0x30(%eax),%eax
80106f77:	83 e8 20             	sub    $0x20,%eax
80106f7a:	83 f8 1f             	cmp    $0x1f,%eax
80106f7d:	0f 87 c6 00 00 00    	ja     80107049 <trap+0x12e>
80106f83:	8b 04 85 f0 91 10 80 	mov    -0x7fef6e10(,%eax,4),%eax
80106f8a:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106f8d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f93:	0f b6 00             	movzbl (%eax),%eax
80106f96:	84 c0                	test   %al,%al
80106f98:	75 42                	jne    80106fdc <trap+0xc1>
      acquire(&tickslock);
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	68 a0 5d 11 80       	push   $0x80115da0
80106fa2:	e8 fe e5 ff ff       	call   801055a5 <acquire>
80106fa7:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106faa:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106faf:	83 c0 01             	add    $0x1,%eax
80106fb2:	a3 e0 65 11 80       	mov    %eax,0x801165e0
      update_stat(); //updateing stuff every clock tick
80106fb7:	e8 33 e3 ff ff       	call   801052ef <update_stat>
      wakeup(&ticks);
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	68 e0 65 11 80       	push   $0x801165e0
80106fc4:	e8 30 e1 ff ff       	call   801050f9 <wakeup>
80106fc9:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106fcc:	83 ec 0c             	sub    $0xc,%esp
80106fcf:	68 a0 5d 11 80       	push   $0x80115da0
80106fd4:	e8 37 e6 ff ff       	call   80105610 <release>
80106fd9:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106fdc:	e8 70 c1 ff ff       	call   80103151 <lapiceoi>
    break;
80106fe1:	e9 1d 01 00 00       	jmp    80107103 <trap+0x1e8>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106fe6:	e8 35 b9 ff ff       	call   80102920 <ideintr>
    lapiceoi();
80106feb:	e8 61 c1 ff ff       	call   80103151 <lapiceoi>
    break;
80106ff0:	e9 0e 01 00 00       	jmp    80107103 <trap+0x1e8>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106ff5:	e8 46 bf ff ff       	call   80102f40 <kbdintr>
    lapiceoi();
80106ffa:	e8 52 c1 ff ff       	call   80103151 <lapiceoi>
    break;
80106fff:	e9 ff 00 00 00       	jmp    80107103 <trap+0x1e8>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107004:	e8 6f 03 00 00       	call   80107378 <uartintr>
    lapiceoi();
80107009:	e8 43 c1 ff ff       	call   80103151 <lapiceoi>
    break;
8010700e:	e9 f0 00 00 00       	jmp    80107103 <trap+0x1e8>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107013:	8b 45 08             	mov    0x8(%ebp),%eax
80107016:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107019:	8b 45 08             	mov    0x8(%ebp),%eax
8010701c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107020:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107023:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107029:	0f b6 00             	movzbl (%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010702c:	0f b6 c0             	movzbl %al,%eax
8010702f:	51                   	push   %ecx
80107030:	52                   	push   %edx
80107031:	50                   	push   %eax
80107032:	68 50 91 10 80       	push   $0x80109150
80107037:	e8 a2 93 ff ff       	call   801003de <cprintf>
8010703c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010703f:	e8 0d c1 ff ff       	call   80103151 <lapiceoi>
    break;
80107044:	e9 ba 00 00 00       	jmp    80107103 <trap+0x1e8>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107049:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010704f:	85 c0                	test   %eax,%eax
80107051:	74 11                	je     80107064 <trap+0x149>
80107053:	8b 45 08             	mov    0x8(%ebp),%eax
80107056:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010705a:	0f b7 c0             	movzwl %ax,%eax
8010705d:	83 e0 03             	and    $0x3,%eax
80107060:	85 c0                	test   %eax,%eax
80107062:	75 3f                	jne    801070a3 <trap+0x188>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107064:	e8 0b fd ff ff       	call   80106d74 <rcr2>
80107069:	8b 55 08             	mov    0x8(%ebp),%edx
8010706c:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010706f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107076:	0f b6 12             	movzbl (%edx),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107079:	0f b6 ca             	movzbl %dl,%ecx
8010707c:	8b 55 08             	mov    0x8(%ebp),%edx
8010707f:	8b 52 30             	mov    0x30(%edx),%edx
80107082:	83 ec 0c             	sub    $0xc,%esp
80107085:	50                   	push   %eax
80107086:	53                   	push   %ebx
80107087:	51                   	push   %ecx
80107088:	52                   	push   %edx
80107089:	68 74 91 10 80       	push   $0x80109174
8010708e:	e8 4b 93 ff ff       	call   801003de <cprintf>
80107093:	83 c4 20             	add    $0x20,%esp
      panic("trap");
80107096:	83 ec 0c             	sub    $0xc,%esp
80107099:	68 a6 91 10 80       	push   $0x801091a6
8010709e:	e8 f4 94 ff ff       	call   80100597 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070a3:	e8 cc fc ff ff       	call   80106d74 <rcr2>
801070a8:	89 c2                	mov    %eax,%edx
801070aa:	8b 45 08             	mov    0x8(%ebp),%eax
801070ad:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070b6:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070b9:	0f b6 f0             	movzbl %al,%esi
801070bc:	8b 45 08             	mov    0x8(%ebp),%eax
801070bf:	8b 58 34             	mov    0x34(%eax),%ebx
801070c2:	8b 45 08             	mov    0x8(%ebp),%eax
801070c5:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070ce:	83 c0 6c             	add    $0x6c,%eax
801070d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070da:	8b 40 10             	mov    0x10(%eax),%eax
801070dd:	52                   	push   %edx
801070de:	57                   	push   %edi
801070df:	56                   	push   %esi
801070e0:	53                   	push   %ebx
801070e1:	51                   	push   %ecx
801070e2:	ff 75 e4             	pushl  -0x1c(%ebp)
801070e5:	50                   	push   %eax
801070e6:	68 ac 91 10 80       	push   $0x801091ac
801070eb:	e8 ee 92 ff ff       	call   801003de <cprintf>
801070f0:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
801070f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107100:	eb 01                	jmp    80107103 <trap+0x1e8>
    break;
80107102:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107103:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107109:	85 c0                	test   %eax,%eax
8010710b:	74 24                	je     80107131 <trap+0x216>
8010710d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107113:	8b 40 24             	mov    0x24(%eax),%eax
80107116:	85 c0                	test   %eax,%eax
80107118:	74 17                	je     80107131 <trap+0x216>
8010711a:	8b 45 08             	mov    0x8(%ebp),%eax
8010711d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107121:	0f b7 c0             	movzwl %ax,%eax
80107124:	83 e0 03             	and    $0x3,%eax
80107127:	83 f8 03             	cmp    $0x3,%eax
8010712a:	75 05                	jne    80107131 <trap+0x216>
    exit();
8010712c:	e8 d8 d9 ff ff       	call   80104b09 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107131:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107137:	85 c0                	test   %eax,%eax
80107139:	74 1e                	je     80107159 <trap+0x23e>
8010713b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107141:	8b 40 0c             	mov    0xc(%eax),%eax
80107144:	83 f8 04             	cmp    $0x4,%eax
80107147:	75 10                	jne    80107159 <trap+0x23e>
80107149:	8b 45 08             	mov    0x8(%ebp),%eax
8010714c:	8b 40 30             	mov    0x30(%eax),%eax
8010714f:	83 f8 20             	cmp    $0x20,%eax
80107152:	75 05                	jne    80107159 <trap+0x23e>
    yield();
80107154:	e8 20 de ff ff       	call   80104f79 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107159:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010715f:	85 c0                	test   %eax,%eax
80107161:	74 27                	je     8010718a <trap+0x26f>
80107163:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107169:	8b 40 24             	mov    0x24(%eax),%eax
8010716c:	85 c0                	test   %eax,%eax
8010716e:	74 1a                	je     8010718a <trap+0x26f>
80107170:	8b 45 08             	mov    0x8(%ebp),%eax
80107173:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107177:	0f b7 c0             	movzwl %ax,%eax
8010717a:	83 e0 03             	and    $0x3,%eax
8010717d:	83 f8 03             	cmp    $0x3,%eax
80107180:	75 08                	jne    8010718a <trap+0x26f>
    exit();
80107182:	e8 82 d9 ff ff       	call   80104b09 <exit>
80107187:	eb 01                	jmp    8010718a <trap+0x26f>
    return;
80107189:	90                   	nop
}
8010718a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010718d:	5b                   	pop    %ebx
8010718e:	5e                   	pop    %esi
8010718f:	5f                   	pop    %edi
80107190:	5d                   	pop    %ebp
80107191:	c3                   	ret    

80107192 <inb>:
{
80107192:	55                   	push   %ebp
80107193:	89 e5                	mov    %esp,%ebp
80107195:	83 ec 14             	sub    $0x14,%esp
80107198:	8b 45 08             	mov    0x8(%ebp),%eax
8010719b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010719f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801071a3:	89 c2                	mov    %eax,%edx
801071a5:	ec                   	in     (%dx),%al
801071a6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801071a9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801071ad:	c9                   	leave  
801071ae:	c3                   	ret    

801071af <outb>:
{
801071af:	55                   	push   %ebp
801071b0:	89 e5                	mov    %esp,%ebp
801071b2:	83 ec 08             	sub    $0x8,%esp
801071b5:	8b 45 08             	mov    0x8(%ebp),%eax
801071b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071bb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801071bf:	89 d0                	mov    %edx,%eax
801071c1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801071c4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801071c8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801071cc:	ee                   	out    %al,(%dx)
}
801071cd:	90                   	nop
801071ce:	c9                   	leave  
801071cf:	c3                   	ret    

801071d0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801071d0:	f3 0f 1e fb          	endbr32 
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801071da:	6a 00                	push   $0x0
801071dc:	68 fa 03 00 00       	push   $0x3fa
801071e1:	e8 c9 ff ff ff       	call   801071af <outb>
801071e6:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801071e9:	68 80 00 00 00       	push   $0x80
801071ee:	68 fb 03 00 00       	push   $0x3fb
801071f3:	e8 b7 ff ff ff       	call   801071af <outb>
801071f8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801071fb:	6a 0c                	push   $0xc
801071fd:	68 f8 03 00 00       	push   $0x3f8
80107202:	e8 a8 ff ff ff       	call   801071af <outb>
80107207:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
8010720a:	6a 00                	push   $0x0
8010720c:	68 f9 03 00 00       	push   $0x3f9
80107211:	e8 99 ff ff ff       	call   801071af <outb>
80107216:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107219:	6a 03                	push   $0x3
8010721b:	68 fb 03 00 00       	push   $0x3fb
80107220:	e8 8a ff ff ff       	call   801071af <outb>
80107225:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107228:	6a 00                	push   $0x0
8010722a:	68 fc 03 00 00       	push   $0x3fc
8010722f:	e8 7b ff ff ff       	call   801071af <outb>
80107234:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107237:	6a 01                	push   $0x1
80107239:	68 f9 03 00 00       	push   $0x3f9
8010723e:	e8 6c ff ff ff       	call   801071af <outb>
80107243:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107246:	68 fd 03 00 00       	push   $0x3fd
8010724b:	e8 42 ff ff ff       	call   80107192 <inb>
80107250:	83 c4 04             	add    $0x4,%esp
80107253:	3c ff                	cmp    $0xff,%al
80107255:	74 6e                	je     801072c5 <uartinit+0xf5>
    return;
  uart = 1;
80107257:	c7 05 4c c6 10 80 01 	movl   $0x1,0x8010c64c
8010725e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107261:	68 fa 03 00 00       	push   $0x3fa
80107266:	e8 27 ff ff ff       	call   80107192 <inb>
8010726b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010726e:	68 f8 03 00 00       	push   $0x3f8
80107273:	e8 1a ff ff ff       	call   80107192 <inb>
80107278:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010727b:	83 ec 0c             	sub    $0xc,%esp
8010727e:	6a 04                	push   $0x4
80107280:	e8 54 ce ff ff       	call   801040d9 <picenable>
80107285:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107288:	83 ec 08             	sub    $0x8,%esp
8010728b:	6a 00                	push   $0x0
8010728d:	6a 04                	push   $0x4
8010728f:	e8 42 b9 ff ff       	call   80102bd6 <ioapicenable>
80107294:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107297:	c7 45 f4 70 92 10 80 	movl   $0x80109270,-0xc(%ebp)
8010729e:	eb 19                	jmp    801072b9 <uartinit+0xe9>
    uartputc(*p);
801072a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a3:	0f b6 00             	movzbl (%eax),%eax
801072a6:	0f be c0             	movsbl %al,%eax
801072a9:	83 ec 0c             	sub    $0xc,%esp
801072ac:	50                   	push   %eax
801072ad:	e8 16 00 00 00       	call   801072c8 <uartputc>
801072b2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801072b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801072b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072bc:	0f b6 00             	movzbl (%eax),%eax
801072bf:	84 c0                	test   %al,%al
801072c1:	75 dd                	jne    801072a0 <uartinit+0xd0>
801072c3:	eb 01                	jmp    801072c6 <uartinit+0xf6>
    return;
801072c5:	90                   	nop
}
801072c6:	c9                   	leave  
801072c7:	c3                   	ret    

801072c8 <uartputc>:

void
uartputc(int c)
{
801072c8:	f3 0f 1e fb          	endbr32 
801072cc:	55                   	push   %ebp
801072cd:	89 e5                	mov    %esp,%ebp
801072cf:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801072d2:	a1 4c c6 10 80       	mov    0x8010c64c,%eax
801072d7:	85 c0                	test   %eax,%eax
801072d9:	74 53                	je     8010732e <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801072e2:	eb 11                	jmp    801072f5 <uartputc+0x2d>
    microdelay(10);
801072e4:	83 ec 0c             	sub    $0xc,%esp
801072e7:	6a 0a                	push   $0xa
801072e9:	e8 82 be ff ff       	call   80103170 <microdelay>
801072ee:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801072f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801072f5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801072f9:	7f 1a                	jg     80107315 <uartputc+0x4d>
801072fb:	83 ec 0c             	sub    $0xc,%esp
801072fe:	68 fd 03 00 00       	push   $0x3fd
80107303:	e8 8a fe ff ff       	call   80107192 <inb>
80107308:	83 c4 10             	add    $0x10,%esp
8010730b:	0f b6 c0             	movzbl %al,%eax
8010730e:	83 e0 20             	and    $0x20,%eax
80107311:	85 c0                	test   %eax,%eax
80107313:	74 cf                	je     801072e4 <uartputc+0x1c>
  outb(COM1+0, c);
80107315:	8b 45 08             	mov    0x8(%ebp),%eax
80107318:	0f b6 c0             	movzbl %al,%eax
8010731b:	83 ec 08             	sub    $0x8,%esp
8010731e:	50                   	push   %eax
8010731f:	68 f8 03 00 00       	push   $0x3f8
80107324:	e8 86 fe ff ff       	call   801071af <outb>
80107329:	83 c4 10             	add    $0x10,%esp
8010732c:	eb 01                	jmp    8010732f <uartputc+0x67>
    return;
8010732e:	90                   	nop
}
8010732f:	c9                   	leave  
80107330:	c3                   	ret    

80107331 <uartgetc>:

static int
uartgetc(void)
{
80107331:	f3 0f 1e fb          	endbr32 
80107335:	55                   	push   %ebp
80107336:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107338:	a1 4c c6 10 80       	mov    0x8010c64c,%eax
8010733d:	85 c0                	test   %eax,%eax
8010733f:	75 07                	jne    80107348 <uartgetc+0x17>
    return -1;
80107341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107346:	eb 2e                	jmp    80107376 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
80107348:	68 fd 03 00 00       	push   $0x3fd
8010734d:	e8 40 fe ff ff       	call   80107192 <inb>
80107352:	83 c4 04             	add    $0x4,%esp
80107355:	0f b6 c0             	movzbl %al,%eax
80107358:	83 e0 01             	and    $0x1,%eax
8010735b:	85 c0                	test   %eax,%eax
8010735d:	75 07                	jne    80107366 <uartgetc+0x35>
    return -1;
8010735f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107364:	eb 10                	jmp    80107376 <uartgetc+0x45>
  return inb(COM1+0);
80107366:	68 f8 03 00 00       	push   $0x3f8
8010736b:	e8 22 fe ff ff       	call   80107192 <inb>
80107370:	83 c4 04             	add    $0x4,%esp
80107373:	0f b6 c0             	movzbl %al,%eax
}
80107376:	c9                   	leave  
80107377:	c3                   	ret    

80107378 <uartintr>:

void
uartintr(void)
{
80107378:	f3 0f 1e fb          	endbr32 
8010737c:	55                   	push   %ebp
8010737d:	89 e5                	mov    %esp,%ebp
8010737f:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107382:	83 ec 0c             	sub    $0xc,%esp
80107385:	68 31 73 10 80       	push   $0x80107331
8010738a:	e8 af 94 ff ff       	call   8010083e <consoleintr>
8010738f:	83 c4 10             	add    $0x10,%esp
}
80107392:	90                   	nop
80107393:	c9                   	leave  
80107394:	c3                   	ret    

80107395 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107395:	6a 00                	push   $0x0
  pushl $0
80107397:	6a 00                	push   $0x0
  jmp alltraps
80107399:	e9 81 f9 ff ff       	jmp    80106d1f <alltraps>

8010739e <vector1>:
.globl vector1
vector1:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $1
801073a0:	6a 01                	push   $0x1
  jmp alltraps
801073a2:	e9 78 f9 ff ff       	jmp    80106d1f <alltraps>

801073a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $2
801073a9:	6a 02                	push   $0x2
  jmp alltraps
801073ab:	e9 6f f9 ff ff       	jmp    80106d1f <alltraps>

801073b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801073b0:	6a 00                	push   $0x0
  pushl $3
801073b2:	6a 03                	push   $0x3
  jmp alltraps
801073b4:	e9 66 f9 ff ff       	jmp    80106d1f <alltraps>

801073b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801073b9:	6a 00                	push   $0x0
  pushl $4
801073bb:	6a 04                	push   $0x4
  jmp alltraps
801073bd:	e9 5d f9 ff ff       	jmp    80106d1f <alltraps>

801073c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $5
801073c4:	6a 05                	push   $0x5
  jmp alltraps
801073c6:	e9 54 f9 ff ff       	jmp    80106d1f <alltraps>

801073cb <vector6>:
.globl vector6
vector6:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $6
801073cd:	6a 06                	push   $0x6
  jmp alltraps
801073cf:	e9 4b f9 ff ff       	jmp    80106d1f <alltraps>

801073d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801073d4:	6a 00                	push   $0x0
  pushl $7
801073d6:	6a 07                	push   $0x7
  jmp alltraps
801073d8:	e9 42 f9 ff ff       	jmp    80106d1f <alltraps>

801073dd <vector8>:
.globl vector8
vector8:
  pushl $8
801073dd:	6a 08                	push   $0x8
  jmp alltraps
801073df:	e9 3b f9 ff ff       	jmp    80106d1f <alltraps>

801073e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $9
801073e6:	6a 09                	push   $0x9
  jmp alltraps
801073e8:	e9 32 f9 ff ff       	jmp    80106d1f <alltraps>

801073ed <vector10>:
.globl vector10
vector10:
  pushl $10
801073ed:	6a 0a                	push   $0xa
  jmp alltraps
801073ef:	e9 2b f9 ff ff       	jmp    80106d1f <alltraps>

801073f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801073f4:	6a 0b                	push   $0xb
  jmp alltraps
801073f6:	e9 24 f9 ff ff       	jmp    80106d1f <alltraps>

801073fb <vector12>:
.globl vector12
vector12:
  pushl $12
801073fb:	6a 0c                	push   $0xc
  jmp alltraps
801073fd:	e9 1d f9 ff ff       	jmp    80106d1f <alltraps>

80107402 <vector13>:
.globl vector13
vector13:
  pushl $13
80107402:	6a 0d                	push   $0xd
  jmp alltraps
80107404:	e9 16 f9 ff ff       	jmp    80106d1f <alltraps>

80107409 <vector14>:
.globl vector14
vector14:
  pushl $14
80107409:	6a 0e                	push   $0xe
  jmp alltraps
8010740b:	e9 0f f9 ff ff       	jmp    80106d1f <alltraps>

80107410 <vector15>:
.globl vector15
vector15:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $15
80107412:	6a 0f                	push   $0xf
  jmp alltraps
80107414:	e9 06 f9 ff ff       	jmp    80106d1f <alltraps>

80107419 <vector16>:
.globl vector16
vector16:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $16
8010741b:	6a 10                	push   $0x10
  jmp alltraps
8010741d:	e9 fd f8 ff ff       	jmp    80106d1f <alltraps>

80107422 <vector17>:
.globl vector17
vector17:
  pushl $17
80107422:	6a 11                	push   $0x11
  jmp alltraps
80107424:	e9 f6 f8 ff ff       	jmp    80106d1f <alltraps>

80107429 <vector18>:
.globl vector18
vector18:
  pushl $0
80107429:	6a 00                	push   $0x0
  pushl $18
8010742b:	6a 12                	push   $0x12
  jmp alltraps
8010742d:	e9 ed f8 ff ff       	jmp    80106d1f <alltraps>

80107432 <vector19>:
.globl vector19
vector19:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $19
80107434:	6a 13                	push   $0x13
  jmp alltraps
80107436:	e9 e4 f8 ff ff       	jmp    80106d1f <alltraps>

8010743b <vector20>:
.globl vector20
vector20:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $20
8010743d:	6a 14                	push   $0x14
  jmp alltraps
8010743f:	e9 db f8 ff ff       	jmp    80106d1f <alltraps>

80107444 <vector21>:
.globl vector21
vector21:
  pushl $0
80107444:	6a 00                	push   $0x0
  pushl $21
80107446:	6a 15                	push   $0x15
  jmp alltraps
80107448:	e9 d2 f8 ff ff       	jmp    80106d1f <alltraps>

8010744d <vector22>:
.globl vector22
vector22:
  pushl $0
8010744d:	6a 00                	push   $0x0
  pushl $22
8010744f:	6a 16                	push   $0x16
  jmp alltraps
80107451:	e9 c9 f8 ff ff       	jmp    80106d1f <alltraps>

80107456 <vector23>:
.globl vector23
vector23:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $23
80107458:	6a 17                	push   $0x17
  jmp alltraps
8010745a:	e9 c0 f8 ff ff       	jmp    80106d1f <alltraps>

8010745f <vector24>:
.globl vector24
vector24:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $24
80107461:	6a 18                	push   $0x18
  jmp alltraps
80107463:	e9 b7 f8 ff ff       	jmp    80106d1f <alltraps>

80107468 <vector25>:
.globl vector25
vector25:
  pushl $0
80107468:	6a 00                	push   $0x0
  pushl $25
8010746a:	6a 19                	push   $0x19
  jmp alltraps
8010746c:	e9 ae f8 ff ff       	jmp    80106d1f <alltraps>

80107471 <vector26>:
.globl vector26
vector26:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $26
80107473:	6a 1a                	push   $0x1a
  jmp alltraps
80107475:	e9 a5 f8 ff ff       	jmp    80106d1f <alltraps>

8010747a <vector27>:
.globl vector27
vector27:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $27
8010747c:	6a 1b                	push   $0x1b
  jmp alltraps
8010747e:	e9 9c f8 ff ff       	jmp    80106d1f <alltraps>

80107483 <vector28>:
.globl vector28
vector28:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $28
80107485:	6a 1c                	push   $0x1c
  jmp alltraps
80107487:	e9 93 f8 ff ff       	jmp    80106d1f <alltraps>

8010748c <vector29>:
.globl vector29
vector29:
  pushl $0
8010748c:	6a 00                	push   $0x0
  pushl $29
8010748e:	6a 1d                	push   $0x1d
  jmp alltraps
80107490:	e9 8a f8 ff ff       	jmp    80106d1f <alltraps>

80107495 <vector30>:
.globl vector30
vector30:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $30
80107497:	6a 1e                	push   $0x1e
  jmp alltraps
80107499:	e9 81 f8 ff ff       	jmp    80106d1f <alltraps>

8010749e <vector31>:
.globl vector31
vector31:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $31
801074a0:	6a 1f                	push   $0x1f
  jmp alltraps
801074a2:	e9 78 f8 ff ff       	jmp    80106d1f <alltraps>

801074a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $32
801074a9:	6a 20                	push   $0x20
  jmp alltraps
801074ab:	e9 6f f8 ff ff       	jmp    80106d1f <alltraps>

801074b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801074b0:	6a 00                	push   $0x0
  pushl $33
801074b2:	6a 21                	push   $0x21
  jmp alltraps
801074b4:	e9 66 f8 ff ff       	jmp    80106d1f <alltraps>

801074b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $34
801074bb:	6a 22                	push   $0x22
  jmp alltraps
801074bd:	e9 5d f8 ff ff       	jmp    80106d1f <alltraps>

801074c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $35
801074c4:	6a 23                	push   $0x23
  jmp alltraps
801074c6:	e9 54 f8 ff ff       	jmp    80106d1f <alltraps>

801074cb <vector36>:
.globl vector36
vector36:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $36
801074cd:	6a 24                	push   $0x24
  jmp alltraps
801074cf:	e9 4b f8 ff ff       	jmp    80106d1f <alltraps>

801074d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801074d4:	6a 00                	push   $0x0
  pushl $37
801074d6:	6a 25                	push   $0x25
  jmp alltraps
801074d8:	e9 42 f8 ff ff       	jmp    80106d1f <alltraps>

801074dd <vector38>:
.globl vector38
vector38:
  pushl $0
801074dd:	6a 00                	push   $0x0
  pushl $38
801074df:	6a 26                	push   $0x26
  jmp alltraps
801074e1:	e9 39 f8 ff ff       	jmp    80106d1f <alltraps>

801074e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $39
801074e8:	6a 27                	push   $0x27
  jmp alltraps
801074ea:	e9 30 f8 ff ff       	jmp    80106d1f <alltraps>

801074ef <vector40>:
.globl vector40
vector40:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $40
801074f1:	6a 28                	push   $0x28
  jmp alltraps
801074f3:	e9 27 f8 ff ff       	jmp    80106d1f <alltraps>

801074f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801074f8:	6a 00                	push   $0x0
  pushl $41
801074fa:	6a 29                	push   $0x29
  jmp alltraps
801074fc:	e9 1e f8 ff ff       	jmp    80106d1f <alltraps>

80107501 <vector42>:
.globl vector42
vector42:
  pushl $0
80107501:	6a 00                	push   $0x0
  pushl $42
80107503:	6a 2a                	push   $0x2a
  jmp alltraps
80107505:	e9 15 f8 ff ff       	jmp    80106d1f <alltraps>

8010750a <vector43>:
.globl vector43
vector43:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $43
8010750c:	6a 2b                	push   $0x2b
  jmp alltraps
8010750e:	e9 0c f8 ff ff       	jmp    80106d1f <alltraps>

80107513 <vector44>:
.globl vector44
vector44:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $44
80107515:	6a 2c                	push   $0x2c
  jmp alltraps
80107517:	e9 03 f8 ff ff       	jmp    80106d1f <alltraps>

8010751c <vector45>:
.globl vector45
vector45:
  pushl $0
8010751c:	6a 00                	push   $0x0
  pushl $45
8010751e:	6a 2d                	push   $0x2d
  jmp alltraps
80107520:	e9 fa f7 ff ff       	jmp    80106d1f <alltraps>

80107525 <vector46>:
.globl vector46
vector46:
  pushl $0
80107525:	6a 00                	push   $0x0
  pushl $46
80107527:	6a 2e                	push   $0x2e
  jmp alltraps
80107529:	e9 f1 f7 ff ff       	jmp    80106d1f <alltraps>

8010752e <vector47>:
.globl vector47
vector47:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $47
80107530:	6a 2f                	push   $0x2f
  jmp alltraps
80107532:	e9 e8 f7 ff ff       	jmp    80106d1f <alltraps>

80107537 <vector48>:
.globl vector48
vector48:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $48
80107539:	6a 30                	push   $0x30
  jmp alltraps
8010753b:	e9 df f7 ff ff       	jmp    80106d1f <alltraps>

80107540 <vector49>:
.globl vector49
vector49:
  pushl $0
80107540:	6a 00                	push   $0x0
  pushl $49
80107542:	6a 31                	push   $0x31
  jmp alltraps
80107544:	e9 d6 f7 ff ff       	jmp    80106d1f <alltraps>

80107549 <vector50>:
.globl vector50
vector50:
  pushl $0
80107549:	6a 00                	push   $0x0
  pushl $50
8010754b:	6a 32                	push   $0x32
  jmp alltraps
8010754d:	e9 cd f7 ff ff       	jmp    80106d1f <alltraps>

80107552 <vector51>:
.globl vector51
vector51:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $51
80107554:	6a 33                	push   $0x33
  jmp alltraps
80107556:	e9 c4 f7 ff ff       	jmp    80106d1f <alltraps>

8010755b <vector52>:
.globl vector52
vector52:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $52
8010755d:	6a 34                	push   $0x34
  jmp alltraps
8010755f:	e9 bb f7 ff ff       	jmp    80106d1f <alltraps>

80107564 <vector53>:
.globl vector53
vector53:
  pushl $0
80107564:	6a 00                	push   $0x0
  pushl $53
80107566:	6a 35                	push   $0x35
  jmp alltraps
80107568:	e9 b2 f7 ff ff       	jmp    80106d1f <alltraps>

8010756d <vector54>:
.globl vector54
vector54:
  pushl $0
8010756d:	6a 00                	push   $0x0
  pushl $54
8010756f:	6a 36                	push   $0x36
  jmp alltraps
80107571:	e9 a9 f7 ff ff       	jmp    80106d1f <alltraps>

80107576 <vector55>:
.globl vector55
vector55:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $55
80107578:	6a 37                	push   $0x37
  jmp alltraps
8010757a:	e9 a0 f7 ff ff       	jmp    80106d1f <alltraps>

8010757f <vector56>:
.globl vector56
vector56:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $56
80107581:	6a 38                	push   $0x38
  jmp alltraps
80107583:	e9 97 f7 ff ff       	jmp    80106d1f <alltraps>

80107588 <vector57>:
.globl vector57
vector57:
  pushl $0
80107588:	6a 00                	push   $0x0
  pushl $57
8010758a:	6a 39                	push   $0x39
  jmp alltraps
8010758c:	e9 8e f7 ff ff       	jmp    80106d1f <alltraps>

80107591 <vector58>:
.globl vector58
vector58:
  pushl $0
80107591:	6a 00                	push   $0x0
  pushl $58
80107593:	6a 3a                	push   $0x3a
  jmp alltraps
80107595:	e9 85 f7 ff ff       	jmp    80106d1f <alltraps>

8010759a <vector59>:
.globl vector59
vector59:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $59
8010759c:	6a 3b                	push   $0x3b
  jmp alltraps
8010759e:	e9 7c f7 ff ff       	jmp    80106d1f <alltraps>

801075a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $60
801075a5:	6a 3c                	push   $0x3c
  jmp alltraps
801075a7:	e9 73 f7 ff ff       	jmp    80106d1f <alltraps>

801075ac <vector61>:
.globl vector61
vector61:
  pushl $0
801075ac:	6a 00                	push   $0x0
  pushl $61
801075ae:	6a 3d                	push   $0x3d
  jmp alltraps
801075b0:	e9 6a f7 ff ff       	jmp    80106d1f <alltraps>

801075b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801075b5:	6a 00                	push   $0x0
  pushl $62
801075b7:	6a 3e                	push   $0x3e
  jmp alltraps
801075b9:	e9 61 f7 ff ff       	jmp    80106d1f <alltraps>

801075be <vector63>:
.globl vector63
vector63:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $63
801075c0:	6a 3f                	push   $0x3f
  jmp alltraps
801075c2:	e9 58 f7 ff ff       	jmp    80106d1f <alltraps>

801075c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $64
801075c9:	6a 40                	push   $0x40
  jmp alltraps
801075cb:	e9 4f f7 ff ff       	jmp    80106d1f <alltraps>

801075d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801075d0:	6a 00                	push   $0x0
  pushl $65
801075d2:	6a 41                	push   $0x41
  jmp alltraps
801075d4:	e9 46 f7 ff ff       	jmp    80106d1f <alltraps>

801075d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801075d9:	6a 00                	push   $0x0
  pushl $66
801075db:	6a 42                	push   $0x42
  jmp alltraps
801075dd:	e9 3d f7 ff ff       	jmp    80106d1f <alltraps>

801075e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $67
801075e4:	6a 43                	push   $0x43
  jmp alltraps
801075e6:	e9 34 f7 ff ff       	jmp    80106d1f <alltraps>

801075eb <vector68>:
.globl vector68
vector68:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $68
801075ed:	6a 44                	push   $0x44
  jmp alltraps
801075ef:	e9 2b f7 ff ff       	jmp    80106d1f <alltraps>

801075f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801075f4:	6a 00                	push   $0x0
  pushl $69
801075f6:	6a 45                	push   $0x45
  jmp alltraps
801075f8:	e9 22 f7 ff ff       	jmp    80106d1f <alltraps>

801075fd <vector70>:
.globl vector70
vector70:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $70
801075ff:	6a 46                	push   $0x46
  jmp alltraps
80107601:	e9 19 f7 ff ff       	jmp    80106d1f <alltraps>

80107606 <vector71>:
.globl vector71
vector71:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $71
80107608:	6a 47                	push   $0x47
  jmp alltraps
8010760a:	e9 10 f7 ff ff       	jmp    80106d1f <alltraps>

8010760f <vector72>:
.globl vector72
vector72:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $72
80107611:	6a 48                	push   $0x48
  jmp alltraps
80107613:	e9 07 f7 ff ff       	jmp    80106d1f <alltraps>

80107618 <vector73>:
.globl vector73
vector73:
  pushl $0
80107618:	6a 00                	push   $0x0
  pushl $73
8010761a:	6a 49                	push   $0x49
  jmp alltraps
8010761c:	e9 fe f6 ff ff       	jmp    80106d1f <alltraps>

80107621 <vector74>:
.globl vector74
vector74:
  pushl $0
80107621:	6a 00                	push   $0x0
  pushl $74
80107623:	6a 4a                	push   $0x4a
  jmp alltraps
80107625:	e9 f5 f6 ff ff       	jmp    80106d1f <alltraps>

8010762a <vector75>:
.globl vector75
vector75:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $75
8010762c:	6a 4b                	push   $0x4b
  jmp alltraps
8010762e:	e9 ec f6 ff ff       	jmp    80106d1f <alltraps>

80107633 <vector76>:
.globl vector76
vector76:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $76
80107635:	6a 4c                	push   $0x4c
  jmp alltraps
80107637:	e9 e3 f6 ff ff       	jmp    80106d1f <alltraps>

8010763c <vector77>:
.globl vector77
vector77:
  pushl $0
8010763c:	6a 00                	push   $0x0
  pushl $77
8010763e:	6a 4d                	push   $0x4d
  jmp alltraps
80107640:	e9 da f6 ff ff       	jmp    80106d1f <alltraps>

80107645 <vector78>:
.globl vector78
vector78:
  pushl $0
80107645:	6a 00                	push   $0x0
  pushl $78
80107647:	6a 4e                	push   $0x4e
  jmp alltraps
80107649:	e9 d1 f6 ff ff       	jmp    80106d1f <alltraps>

8010764e <vector79>:
.globl vector79
vector79:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $79
80107650:	6a 4f                	push   $0x4f
  jmp alltraps
80107652:	e9 c8 f6 ff ff       	jmp    80106d1f <alltraps>

80107657 <vector80>:
.globl vector80
vector80:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $80
80107659:	6a 50                	push   $0x50
  jmp alltraps
8010765b:	e9 bf f6 ff ff       	jmp    80106d1f <alltraps>

80107660 <vector81>:
.globl vector81
vector81:
  pushl $0
80107660:	6a 00                	push   $0x0
  pushl $81
80107662:	6a 51                	push   $0x51
  jmp alltraps
80107664:	e9 b6 f6 ff ff       	jmp    80106d1f <alltraps>

80107669 <vector82>:
.globl vector82
vector82:
  pushl $0
80107669:	6a 00                	push   $0x0
  pushl $82
8010766b:	6a 52                	push   $0x52
  jmp alltraps
8010766d:	e9 ad f6 ff ff       	jmp    80106d1f <alltraps>

80107672 <vector83>:
.globl vector83
vector83:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $83
80107674:	6a 53                	push   $0x53
  jmp alltraps
80107676:	e9 a4 f6 ff ff       	jmp    80106d1f <alltraps>

8010767b <vector84>:
.globl vector84
vector84:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $84
8010767d:	6a 54                	push   $0x54
  jmp alltraps
8010767f:	e9 9b f6 ff ff       	jmp    80106d1f <alltraps>

80107684 <vector85>:
.globl vector85
vector85:
  pushl $0
80107684:	6a 00                	push   $0x0
  pushl $85
80107686:	6a 55                	push   $0x55
  jmp alltraps
80107688:	e9 92 f6 ff ff       	jmp    80106d1f <alltraps>

8010768d <vector86>:
.globl vector86
vector86:
  pushl $0
8010768d:	6a 00                	push   $0x0
  pushl $86
8010768f:	6a 56                	push   $0x56
  jmp alltraps
80107691:	e9 89 f6 ff ff       	jmp    80106d1f <alltraps>

80107696 <vector87>:
.globl vector87
vector87:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $87
80107698:	6a 57                	push   $0x57
  jmp alltraps
8010769a:	e9 80 f6 ff ff       	jmp    80106d1f <alltraps>

8010769f <vector88>:
.globl vector88
vector88:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $88
801076a1:	6a 58                	push   $0x58
  jmp alltraps
801076a3:	e9 77 f6 ff ff       	jmp    80106d1f <alltraps>

801076a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801076a8:	6a 00                	push   $0x0
  pushl $89
801076aa:	6a 59                	push   $0x59
  jmp alltraps
801076ac:	e9 6e f6 ff ff       	jmp    80106d1f <alltraps>

801076b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801076b1:	6a 00                	push   $0x0
  pushl $90
801076b3:	6a 5a                	push   $0x5a
  jmp alltraps
801076b5:	e9 65 f6 ff ff       	jmp    80106d1f <alltraps>

801076ba <vector91>:
.globl vector91
vector91:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $91
801076bc:	6a 5b                	push   $0x5b
  jmp alltraps
801076be:	e9 5c f6 ff ff       	jmp    80106d1f <alltraps>

801076c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $92
801076c5:	6a 5c                	push   $0x5c
  jmp alltraps
801076c7:	e9 53 f6 ff ff       	jmp    80106d1f <alltraps>

801076cc <vector93>:
.globl vector93
vector93:
  pushl $0
801076cc:	6a 00                	push   $0x0
  pushl $93
801076ce:	6a 5d                	push   $0x5d
  jmp alltraps
801076d0:	e9 4a f6 ff ff       	jmp    80106d1f <alltraps>

801076d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801076d5:	6a 00                	push   $0x0
  pushl $94
801076d7:	6a 5e                	push   $0x5e
  jmp alltraps
801076d9:	e9 41 f6 ff ff       	jmp    80106d1f <alltraps>

801076de <vector95>:
.globl vector95
vector95:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $95
801076e0:	6a 5f                	push   $0x5f
  jmp alltraps
801076e2:	e9 38 f6 ff ff       	jmp    80106d1f <alltraps>

801076e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $96
801076e9:	6a 60                	push   $0x60
  jmp alltraps
801076eb:	e9 2f f6 ff ff       	jmp    80106d1f <alltraps>

801076f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801076f0:	6a 00                	push   $0x0
  pushl $97
801076f2:	6a 61                	push   $0x61
  jmp alltraps
801076f4:	e9 26 f6 ff ff       	jmp    80106d1f <alltraps>

801076f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801076f9:	6a 00                	push   $0x0
  pushl $98
801076fb:	6a 62                	push   $0x62
  jmp alltraps
801076fd:	e9 1d f6 ff ff       	jmp    80106d1f <alltraps>

80107702 <vector99>:
.globl vector99
vector99:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $99
80107704:	6a 63                	push   $0x63
  jmp alltraps
80107706:	e9 14 f6 ff ff       	jmp    80106d1f <alltraps>

8010770b <vector100>:
.globl vector100
vector100:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $100
8010770d:	6a 64                	push   $0x64
  jmp alltraps
8010770f:	e9 0b f6 ff ff       	jmp    80106d1f <alltraps>

80107714 <vector101>:
.globl vector101
vector101:
  pushl $0
80107714:	6a 00                	push   $0x0
  pushl $101
80107716:	6a 65                	push   $0x65
  jmp alltraps
80107718:	e9 02 f6 ff ff       	jmp    80106d1f <alltraps>

8010771d <vector102>:
.globl vector102
vector102:
  pushl $0
8010771d:	6a 00                	push   $0x0
  pushl $102
8010771f:	6a 66                	push   $0x66
  jmp alltraps
80107721:	e9 f9 f5 ff ff       	jmp    80106d1f <alltraps>

80107726 <vector103>:
.globl vector103
vector103:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $103
80107728:	6a 67                	push   $0x67
  jmp alltraps
8010772a:	e9 f0 f5 ff ff       	jmp    80106d1f <alltraps>

8010772f <vector104>:
.globl vector104
vector104:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $104
80107731:	6a 68                	push   $0x68
  jmp alltraps
80107733:	e9 e7 f5 ff ff       	jmp    80106d1f <alltraps>

80107738 <vector105>:
.globl vector105
vector105:
  pushl $0
80107738:	6a 00                	push   $0x0
  pushl $105
8010773a:	6a 69                	push   $0x69
  jmp alltraps
8010773c:	e9 de f5 ff ff       	jmp    80106d1f <alltraps>

80107741 <vector106>:
.globl vector106
vector106:
  pushl $0
80107741:	6a 00                	push   $0x0
  pushl $106
80107743:	6a 6a                	push   $0x6a
  jmp alltraps
80107745:	e9 d5 f5 ff ff       	jmp    80106d1f <alltraps>

8010774a <vector107>:
.globl vector107
vector107:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $107
8010774c:	6a 6b                	push   $0x6b
  jmp alltraps
8010774e:	e9 cc f5 ff ff       	jmp    80106d1f <alltraps>

80107753 <vector108>:
.globl vector108
vector108:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $108
80107755:	6a 6c                	push   $0x6c
  jmp alltraps
80107757:	e9 c3 f5 ff ff       	jmp    80106d1f <alltraps>

8010775c <vector109>:
.globl vector109
vector109:
  pushl $0
8010775c:	6a 00                	push   $0x0
  pushl $109
8010775e:	6a 6d                	push   $0x6d
  jmp alltraps
80107760:	e9 ba f5 ff ff       	jmp    80106d1f <alltraps>

80107765 <vector110>:
.globl vector110
vector110:
  pushl $0
80107765:	6a 00                	push   $0x0
  pushl $110
80107767:	6a 6e                	push   $0x6e
  jmp alltraps
80107769:	e9 b1 f5 ff ff       	jmp    80106d1f <alltraps>

8010776e <vector111>:
.globl vector111
vector111:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $111
80107770:	6a 6f                	push   $0x6f
  jmp alltraps
80107772:	e9 a8 f5 ff ff       	jmp    80106d1f <alltraps>

80107777 <vector112>:
.globl vector112
vector112:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $112
80107779:	6a 70                	push   $0x70
  jmp alltraps
8010777b:	e9 9f f5 ff ff       	jmp    80106d1f <alltraps>

80107780 <vector113>:
.globl vector113
vector113:
  pushl $0
80107780:	6a 00                	push   $0x0
  pushl $113
80107782:	6a 71                	push   $0x71
  jmp alltraps
80107784:	e9 96 f5 ff ff       	jmp    80106d1f <alltraps>

80107789 <vector114>:
.globl vector114
vector114:
  pushl $0
80107789:	6a 00                	push   $0x0
  pushl $114
8010778b:	6a 72                	push   $0x72
  jmp alltraps
8010778d:	e9 8d f5 ff ff       	jmp    80106d1f <alltraps>

80107792 <vector115>:
.globl vector115
vector115:
  pushl $0
80107792:	6a 00                	push   $0x0
  pushl $115
80107794:	6a 73                	push   $0x73
  jmp alltraps
80107796:	e9 84 f5 ff ff       	jmp    80106d1f <alltraps>

8010779b <vector116>:
.globl vector116
vector116:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $116
8010779d:	6a 74                	push   $0x74
  jmp alltraps
8010779f:	e9 7b f5 ff ff       	jmp    80106d1f <alltraps>

801077a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801077a4:	6a 00                	push   $0x0
  pushl $117
801077a6:	6a 75                	push   $0x75
  jmp alltraps
801077a8:	e9 72 f5 ff ff       	jmp    80106d1f <alltraps>

801077ad <vector118>:
.globl vector118
vector118:
  pushl $0
801077ad:	6a 00                	push   $0x0
  pushl $118
801077af:	6a 76                	push   $0x76
  jmp alltraps
801077b1:	e9 69 f5 ff ff       	jmp    80106d1f <alltraps>

801077b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801077b6:	6a 00                	push   $0x0
  pushl $119
801077b8:	6a 77                	push   $0x77
  jmp alltraps
801077ba:	e9 60 f5 ff ff       	jmp    80106d1f <alltraps>

801077bf <vector120>:
.globl vector120
vector120:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $120
801077c1:	6a 78                	push   $0x78
  jmp alltraps
801077c3:	e9 57 f5 ff ff       	jmp    80106d1f <alltraps>

801077c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801077c8:	6a 00                	push   $0x0
  pushl $121
801077ca:	6a 79                	push   $0x79
  jmp alltraps
801077cc:	e9 4e f5 ff ff       	jmp    80106d1f <alltraps>

801077d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801077d1:	6a 00                	push   $0x0
  pushl $122
801077d3:	6a 7a                	push   $0x7a
  jmp alltraps
801077d5:	e9 45 f5 ff ff       	jmp    80106d1f <alltraps>

801077da <vector123>:
.globl vector123
vector123:
  pushl $0
801077da:	6a 00                	push   $0x0
  pushl $123
801077dc:	6a 7b                	push   $0x7b
  jmp alltraps
801077de:	e9 3c f5 ff ff       	jmp    80106d1f <alltraps>

801077e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $124
801077e5:	6a 7c                	push   $0x7c
  jmp alltraps
801077e7:	e9 33 f5 ff ff       	jmp    80106d1f <alltraps>

801077ec <vector125>:
.globl vector125
vector125:
  pushl $0
801077ec:	6a 00                	push   $0x0
  pushl $125
801077ee:	6a 7d                	push   $0x7d
  jmp alltraps
801077f0:	e9 2a f5 ff ff       	jmp    80106d1f <alltraps>

801077f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801077f5:	6a 00                	push   $0x0
  pushl $126
801077f7:	6a 7e                	push   $0x7e
  jmp alltraps
801077f9:	e9 21 f5 ff ff       	jmp    80106d1f <alltraps>

801077fe <vector127>:
.globl vector127
vector127:
  pushl $0
801077fe:	6a 00                	push   $0x0
  pushl $127
80107800:	6a 7f                	push   $0x7f
  jmp alltraps
80107802:	e9 18 f5 ff ff       	jmp    80106d1f <alltraps>

80107807 <vector128>:
.globl vector128
vector128:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $128
80107809:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010780e:	e9 0c f5 ff ff       	jmp    80106d1f <alltraps>

80107813 <vector129>:
.globl vector129
vector129:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $129
80107815:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010781a:	e9 00 f5 ff ff       	jmp    80106d1f <alltraps>

8010781f <vector130>:
.globl vector130
vector130:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $130
80107821:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107826:	e9 f4 f4 ff ff       	jmp    80106d1f <alltraps>

8010782b <vector131>:
.globl vector131
vector131:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $131
8010782d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107832:	e9 e8 f4 ff ff       	jmp    80106d1f <alltraps>

80107837 <vector132>:
.globl vector132
vector132:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $132
80107839:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010783e:	e9 dc f4 ff ff       	jmp    80106d1f <alltraps>

80107843 <vector133>:
.globl vector133
vector133:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $133
80107845:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010784a:	e9 d0 f4 ff ff       	jmp    80106d1f <alltraps>

8010784f <vector134>:
.globl vector134
vector134:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $134
80107851:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107856:	e9 c4 f4 ff ff       	jmp    80106d1f <alltraps>

8010785b <vector135>:
.globl vector135
vector135:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $135
8010785d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107862:	e9 b8 f4 ff ff       	jmp    80106d1f <alltraps>

80107867 <vector136>:
.globl vector136
vector136:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $136
80107869:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010786e:	e9 ac f4 ff ff       	jmp    80106d1f <alltraps>

80107873 <vector137>:
.globl vector137
vector137:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $137
80107875:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010787a:	e9 a0 f4 ff ff       	jmp    80106d1f <alltraps>

8010787f <vector138>:
.globl vector138
vector138:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $138
80107881:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107886:	e9 94 f4 ff ff       	jmp    80106d1f <alltraps>

8010788b <vector139>:
.globl vector139
vector139:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $139
8010788d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107892:	e9 88 f4 ff ff       	jmp    80106d1f <alltraps>

80107897 <vector140>:
.globl vector140
vector140:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $140
80107899:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010789e:	e9 7c f4 ff ff       	jmp    80106d1f <alltraps>

801078a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $141
801078a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801078aa:	e9 70 f4 ff ff       	jmp    80106d1f <alltraps>

801078af <vector142>:
.globl vector142
vector142:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $142
801078b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801078b6:	e9 64 f4 ff ff       	jmp    80106d1f <alltraps>

801078bb <vector143>:
.globl vector143
vector143:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $143
801078bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801078c2:	e9 58 f4 ff ff       	jmp    80106d1f <alltraps>

801078c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $144
801078c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801078ce:	e9 4c f4 ff ff       	jmp    80106d1f <alltraps>

801078d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $145
801078d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801078da:	e9 40 f4 ff ff       	jmp    80106d1f <alltraps>

801078df <vector146>:
.globl vector146
vector146:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $146
801078e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801078e6:	e9 34 f4 ff ff       	jmp    80106d1f <alltraps>

801078eb <vector147>:
.globl vector147
vector147:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $147
801078ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801078f2:	e9 28 f4 ff ff       	jmp    80106d1f <alltraps>

801078f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $148
801078f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801078fe:	e9 1c f4 ff ff       	jmp    80106d1f <alltraps>

80107903 <vector149>:
.globl vector149
vector149:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $149
80107905:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010790a:	e9 10 f4 ff ff       	jmp    80106d1f <alltraps>

8010790f <vector150>:
.globl vector150
vector150:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $150
80107911:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107916:	e9 04 f4 ff ff       	jmp    80106d1f <alltraps>

8010791b <vector151>:
.globl vector151
vector151:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $151
8010791d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107922:	e9 f8 f3 ff ff       	jmp    80106d1f <alltraps>

80107927 <vector152>:
.globl vector152
vector152:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $152
80107929:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010792e:	e9 ec f3 ff ff       	jmp    80106d1f <alltraps>

80107933 <vector153>:
.globl vector153
vector153:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $153
80107935:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010793a:	e9 e0 f3 ff ff       	jmp    80106d1f <alltraps>

8010793f <vector154>:
.globl vector154
vector154:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $154
80107941:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107946:	e9 d4 f3 ff ff       	jmp    80106d1f <alltraps>

8010794b <vector155>:
.globl vector155
vector155:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $155
8010794d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107952:	e9 c8 f3 ff ff       	jmp    80106d1f <alltraps>

80107957 <vector156>:
.globl vector156
vector156:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $156
80107959:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010795e:	e9 bc f3 ff ff       	jmp    80106d1f <alltraps>

80107963 <vector157>:
.globl vector157
vector157:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $157
80107965:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010796a:	e9 b0 f3 ff ff       	jmp    80106d1f <alltraps>

8010796f <vector158>:
.globl vector158
vector158:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $158
80107971:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107976:	e9 a4 f3 ff ff       	jmp    80106d1f <alltraps>

8010797b <vector159>:
.globl vector159
vector159:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $159
8010797d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107982:	e9 98 f3 ff ff       	jmp    80106d1f <alltraps>

80107987 <vector160>:
.globl vector160
vector160:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $160
80107989:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010798e:	e9 8c f3 ff ff       	jmp    80106d1f <alltraps>

80107993 <vector161>:
.globl vector161
vector161:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $161
80107995:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010799a:	e9 80 f3 ff ff       	jmp    80106d1f <alltraps>

8010799f <vector162>:
.globl vector162
vector162:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $162
801079a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801079a6:	e9 74 f3 ff ff       	jmp    80106d1f <alltraps>

801079ab <vector163>:
.globl vector163
vector163:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $163
801079ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801079b2:	e9 68 f3 ff ff       	jmp    80106d1f <alltraps>

801079b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $164
801079b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801079be:	e9 5c f3 ff ff       	jmp    80106d1f <alltraps>

801079c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $165
801079c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801079ca:	e9 50 f3 ff ff       	jmp    80106d1f <alltraps>

801079cf <vector166>:
.globl vector166
vector166:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $166
801079d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801079d6:	e9 44 f3 ff ff       	jmp    80106d1f <alltraps>

801079db <vector167>:
.globl vector167
vector167:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $167
801079dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801079e2:	e9 38 f3 ff ff       	jmp    80106d1f <alltraps>

801079e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $168
801079e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801079ee:	e9 2c f3 ff ff       	jmp    80106d1f <alltraps>

801079f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $169
801079f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801079fa:	e9 20 f3 ff ff       	jmp    80106d1f <alltraps>

801079ff <vector170>:
.globl vector170
vector170:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $170
80107a01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a06:	e9 14 f3 ff ff       	jmp    80106d1f <alltraps>

80107a0b <vector171>:
.globl vector171
vector171:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $171
80107a0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107a12:	e9 08 f3 ff ff       	jmp    80106d1f <alltraps>

80107a17 <vector172>:
.globl vector172
vector172:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $172
80107a19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107a1e:	e9 fc f2 ff ff       	jmp    80106d1f <alltraps>

80107a23 <vector173>:
.globl vector173
vector173:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $173
80107a25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107a2a:	e9 f0 f2 ff ff       	jmp    80106d1f <alltraps>

80107a2f <vector174>:
.globl vector174
vector174:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $174
80107a31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107a36:	e9 e4 f2 ff ff       	jmp    80106d1f <alltraps>

80107a3b <vector175>:
.globl vector175
vector175:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $175
80107a3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107a42:	e9 d8 f2 ff ff       	jmp    80106d1f <alltraps>

80107a47 <vector176>:
.globl vector176
vector176:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $176
80107a49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107a4e:	e9 cc f2 ff ff       	jmp    80106d1f <alltraps>

80107a53 <vector177>:
.globl vector177
vector177:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $177
80107a55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107a5a:	e9 c0 f2 ff ff       	jmp    80106d1f <alltraps>

80107a5f <vector178>:
.globl vector178
vector178:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $178
80107a61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107a66:	e9 b4 f2 ff ff       	jmp    80106d1f <alltraps>

80107a6b <vector179>:
.globl vector179
vector179:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $179
80107a6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107a72:	e9 a8 f2 ff ff       	jmp    80106d1f <alltraps>

80107a77 <vector180>:
.globl vector180
vector180:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $180
80107a79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107a7e:	e9 9c f2 ff ff       	jmp    80106d1f <alltraps>

80107a83 <vector181>:
.globl vector181
vector181:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $181
80107a85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107a8a:	e9 90 f2 ff ff       	jmp    80106d1f <alltraps>

80107a8f <vector182>:
.globl vector182
vector182:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $182
80107a91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107a96:	e9 84 f2 ff ff       	jmp    80106d1f <alltraps>

80107a9b <vector183>:
.globl vector183
vector183:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $183
80107a9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107aa2:	e9 78 f2 ff ff       	jmp    80106d1f <alltraps>

80107aa7 <vector184>:
.globl vector184
vector184:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $184
80107aa9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107aae:	e9 6c f2 ff ff       	jmp    80106d1f <alltraps>

80107ab3 <vector185>:
.globl vector185
vector185:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $185
80107ab5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107aba:	e9 60 f2 ff ff       	jmp    80106d1f <alltraps>

80107abf <vector186>:
.globl vector186
vector186:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $186
80107ac1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107ac6:	e9 54 f2 ff ff       	jmp    80106d1f <alltraps>

80107acb <vector187>:
.globl vector187
vector187:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $187
80107acd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107ad2:	e9 48 f2 ff ff       	jmp    80106d1f <alltraps>

80107ad7 <vector188>:
.globl vector188
vector188:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $188
80107ad9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107ade:	e9 3c f2 ff ff       	jmp    80106d1f <alltraps>

80107ae3 <vector189>:
.globl vector189
vector189:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $189
80107ae5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107aea:	e9 30 f2 ff ff       	jmp    80106d1f <alltraps>

80107aef <vector190>:
.globl vector190
vector190:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $190
80107af1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107af6:	e9 24 f2 ff ff       	jmp    80106d1f <alltraps>

80107afb <vector191>:
.globl vector191
vector191:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $191
80107afd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b02:	e9 18 f2 ff ff       	jmp    80106d1f <alltraps>

80107b07 <vector192>:
.globl vector192
vector192:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $192
80107b09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107b0e:	e9 0c f2 ff ff       	jmp    80106d1f <alltraps>

80107b13 <vector193>:
.globl vector193
vector193:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $193
80107b15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107b1a:	e9 00 f2 ff ff       	jmp    80106d1f <alltraps>

80107b1f <vector194>:
.globl vector194
vector194:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $194
80107b21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107b26:	e9 f4 f1 ff ff       	jmp    80106d1f <alltraps>

80107b2b <vector195>:
.globl vector195
vector195:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $195
80107b2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107b32:	e9 e8 f1 ff ff       	jmp    80106d1f <alltraps>

80107b37 <vector196>:
.globl vector196
vector196:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $196
80107b39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107b3e:	e9 dc f1 ff ff       	jmp    80106d1f <alltraps>

80107b43 <vector197>:
.globl vector197
vector197:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $197
80107b45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107b4a:	e9 d0 f1 ff ff       	jmp    80106d1f <alltraps>

80107b4f <vector198>:
.globl vector198
vector198:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $198
80107b51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107b56:	e9 c4 f1 ff ff       	jmp    80106d1f <alltraps>

80107b5b <vector199>:
.globl vector199
vector199:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $199
80107b5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107b62:	e9 b8 f1 ff ff       	jmp    80106d1f <alltraps>

80107b67 <vector200>:
.globl vector200
vector200:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $200
80107b69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107b6e:	e9 ac f1 ff ff       	jmp    80106d1f <alltraps>

80107b73 <vector201>:
.globl vector201
vector201:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $201
80107b75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107b7a:	e9 a0 f1 ff ff       	jmp    80106d1f <alltraps>

80107b7f <vector202>:
.globl vector202
vector202:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $202
80107b81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107b86:	e9 94 f1 ff ff       	jmp    80106d1f <alltraps>

80107b8b <vector203>:
.globl vector203
vector203:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $203
80107b8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107b92:	e9 88 f1 ff ff       	jmp    80106d1f <alltraps>

80107b97 <vector204>:
.globl vector204
vector204:
  pushl $0
80107b97:	6a 00                	push   $0x0
  pushl $204
80107b99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107b9e:	e9 7c f1 ff ff       	jmp    80106d1f <alltraps>

80107ba3 <vector205>:
.globl vector205
vector205:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $205
80107ba5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107baa:	e9 70 f1 ff ff       	jmp    80106d1f <alltraps>

80107baf <vector206>:
.globl vector206
vector206:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $206
80107bb1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107bb6:	e9 64 f1 ff ff       	jmp    80106d1f <alltraps>

80107bbb <vector207>:
.globl vector207
vector207:
  pushl $0
80107bbb:	6a 00                	push   $0x0
  pushl $207
80107bbd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107bc2:	e9 58 f1 ff ff       	jmp    80106d1f <alltraps>

80107bc7 <vector208>:
.globl vector208
vector208:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $208
80107bc9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107bce:	e9 4c f1 ff ff       	jmp    80106d1f <alltraps>

80107bd3 <vector209>:
.globl vector209
vector209:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $209
80107bd5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107bda:	e9 40 f1 ff ff       	jmp    80106d1f <alltraps>

80107bdf <vector210>:
.globl vector210
vector210:
  pushl $0
80107bdf:	6a 00                	push   $0x0
  pushl $210
80107be1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107be6:	e9 34 f1 ff ff       	jmp    80106d1f <alltraps>

80107beb <vector211>:
.globl vector211
vector211:
  pushl $0
80107beb:	6a 00                	push   $0x0
  pushl $211
80107bed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107bf2:	e9 28 f1 ff ff       	jmp    80106d1f <alltraps>

80107bf7 <vector212>:
.globl vector212
vector212:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $212
80107bf9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107bfe:	e9 1c f1 ff ff       	jmp    80106d1f <alltraps>

80107c03 <vector213>:
.globl vector213
vector213:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $213
80107c05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107c0a:	e9 10 f1 ff ff       	jmp    80106d1f <alltraps>

80107c0f <vector214>:
.globl vector214
vector214:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $214
80107c11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107c16:	e9 04 f1 ff ff       	jmp    80106d1f <alltraps>

80107c1b <vector215>:
.globl vector215
vector215:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $215
80107c1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107c22:	e9 f8 f0 ff ff       	jmp    80106d1f <alltraps>

80107c27 <vector216>:
.globl vector216
vector216:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $216
80107c29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107c2e:	e9 ec f0 ff ff       	jmp    80106d1f <alltraps>

80107c33 <vector217>:
.globl vector217
vector217:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $217
80107c35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107c3a:	e9 e0 f0 ff ff       	jmp    80106d1f <alltraps>

80107c3f <vector218>:
.globl vector218
vector218:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $218
80107c41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107c46:	e9 d4 f0 ff ff       	jmp    80106d1f <alltraps>

80107c4b <vector219>:
.globl vector219
vector219:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $219
80107c4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107c52:	e9 c8 f0 ff ff       	jmp    80106d1f <alltraps>

80107c57 <vector220>:
.globl vector220
vector220:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $220
80107c59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107c5e:	e9 bc f0 ff ff       	jmp    80106d1f <alltraps>

80107c63 <vector221>:
.globl vector221
vector221:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $221
80107c65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107c6a:	e9 b0 f0 ff ff       	jmp    80106d1f <alltraps>

80107c6f <vector222>:
.globl vector222
vector222:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $222
80107c71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107c76:	e9 a4 f0 ff ff       	jmp    80106d1f <alltraps>

80107c7b <vector223>:
.globl vector223
vector223:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $223
80107c7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107c82:	e9 98 f0 ff ff       	jmp    80106d1f <alltraps>

80107c87 <vector224>:
.globl vector224
vector224:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $224
80107c89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107c8e:	e9 8c f0 ff ff       	jmp    80106d1f <alltraps>

80107c93 <vector225>:
.globl vector225
vector225:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $225
80107c95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107c9a:	e9 80 f0 ff ff       	jmp    80106d1f <alltraps>

80107c9f <vector226>:
.globl vector226
vector226:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $226
80107ca1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107ca6:	e9 74 f0 ff ff       	jmp    80106d1f <alltraps>

80107cab <vector227>:
.globl vector227
vector227:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $227
80107cad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107cb2:	e9 68 f0 ff ff       	jmp    80106d1f <alltraps>

80107cb7 <vector228>:
.globl vector228
vector228:
  pushl $0
80107cb7:	6a 00                	push   $0x0
  pushl $228
80107cb9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107cbe:	e9 5c f0 ff ff       	jmp    80106d1f <alltraps>

80107cc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $229
80107cc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107cca:	e9 50 f0 ff ff       	jmp    80106d1f <alltraps>

80107ccf <vector230>:
.globl vector230
vector230:
  pushl $0
80107ccf:	6a 00                	push   $0x0
  pushl $230
80107cd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107cd6:	e9 44 f0 ff ff       	jmp    80106d1f <alltraps>

80107cdb <vector231>:
.globl vector231
vector231:
  pushl $0
80107cdb:	6a 00                	push   $0x0
  pushl $231
80107cdd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107ce2:	e9 38 f0 ff ff       	jmp    80106d1f <alltraps>

80107ce7 <vector232>:
.globl vector232
vector232:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $232
80107ce9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107cee:	e9 2c f0 ff ff       	jmp    80106d1f <alltraps>

80107cf3 <vector233>:
.globl vector233
vector233:
  pushl $0
80107cf3:	6a 00                	push   $0x0
  pushl $233
80107cf5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107cfa:	e9 20 f0 ff ff       	jmp    80106d1f <alltraps>

80107cff <vector234>:
.globl vector234
vector234:
  pushl $0
80107cff:	6a 00                	push   $0x0
  pushl $234
80107d01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d06:	e9 14 f0 ff ff       	jmp    80106d1f <alltraps>

80107d0b <vector235>:
.globl vector235
vector235:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $235
80107d0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107d12:	e9 08 f0 ff ff       	jmp    80106d1f <alltraps>

80107d17 <vector236>:
.globl vector236
vector236:
  pushl $0
80107d17:	6a 00                	push   $0x0
  pushl $236
80107d19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107d1e:	e9 fc ef ff ff       	jmp    80106d1f <alltraps>

80107d23 <vector237>:
.globl vector237
vector237:
  pushl $0
80107d23:	6a 00                	push   $0x0
  pushl $237
80107d25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107d2a:	e9 f0 ef ff ff       	jmp    80106d1f <alltraps>

80107d2f <vector238>:
.globl vector238
vector238:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $238
80107d31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107d36:	e9 e4 ef ff ff       	jmp    80106d1f <alltraps>

80107d3b <vector239>:
.globl vector239
vector239:
  pushl $0
80107d3b:	6a 00                	push   $0x0
  pushl $239
80107d3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107d42:	e9 d8 ef ff ff       	jmp    80106d1f <alltraps>

80107d47 <vector240>:
.globl vector240
vector240:
  pushl $0
80107d47:	6a 00                	push   $0x0
  pushl $240
80107d49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107d4e:	e9 cc ef ff ff       	jmp    80106d1f <alltraps>

80107d53 <vector241>:
.globl vector241
vector241:
  pushl $0
80107d53:	6a 00                	push   $0x0
  pushl $241
80107d55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107d5a:	e9 c0 ef ff ff       	jmp    80106d1f <alltraps>

80107d5f <vector242>:
.globl vector242
vector242:
  pushl $0
80107d5f:	6a 00                	push   $0x0
  pushl $242
80107d61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107d66:	e9 b4 ef ff ff       	jmp    80106d1f <alltraps>

80107d6b <vector243>:
.globl vector243
vector243:
  pushl $0
80107d6b:	6a 00                	push   $0x0
  pushl $243
80107d6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107d72:	e9 a8 ef ff ff       	jmp    80106d1f <alltraps>

80107d77 <vector244>:
.globl vector244
vector244:
  pushl $0
80107d77:	6a 00                	push   $0x0
  pushl $244
80107d79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107d7e:	e9 9c ef ff ff       	jmp    80106d1f <alltraps>

80107d83 <vector245>:
.globl vector245
vector245:
  pushl $0
80107d83:	6a 00                	push   $0x0
  pushl $245
80107d85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107d8a:	e9 90 ef ff ff       	jmp    80106d1f <alltraps>

80107d8f <vector246>:
.globl vector246
vector246:
  pushl $0
80107d8f:	6a 00                	push   $0x0
  pushl $246
80107d91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107d96:	e9 84 ef ff ff       	jmp    80106d1f <alltraps>

80107d9b <vector247>:
.globl vector247
vector247:
  pushl $0
80107d9b:	6a 00                	push   $0x0
  pushl $247
80107d9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107da2:	e9 78 ef ff ff       	jmp    80106d1f <alltraps>

80107da7 <vector248>:
.globl vector248
vector248:
  pushl $0
80107da7:	6a 00                	push   $0x0
  pushl $248
80107da9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107dae:	e9 6c ef ff ff       	jmp    80106d1f <alltraps>

80107db3 <vector249>:
.globl vector249
vector249:
  pushl $0
80107db3:	6a 00                	push   $0x0
  pushl $249
80107db5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107dba:	e9 60 ef ff ff       	jmp    80106d1f <alltraps>

80107dbf <vector250>:
.globl vector250
vector250:
  pushl $0
80107dbf:	6a 00                	push   $0x0
  pushl $250
80107dc1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107dc6:	e9 54 ef ff ff       	jmp    80106d1f <alltraps>

80107dcb <vector251>:
.globl vector251
vector251:
  pushl $0
80107dcb:	6a 00                	push   $0x0
  pushl $251
80107dcd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107dd2:	e9 48 ef ff ff       	jmp    80106d1f <alltraps>

80107dd7 <vector252>:
.globl vector252
vector252:
  pushl $0
80107dd7:	6a 00                	push   $0x0
  pushl $252
80107dd9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107dde:	e9 3c ef ff ff       	jmp    80106d1f <alltraps>

80107de3 <vector253>:
.globl vector253
vector253:
  pushl $0
80107de3:	6a 00                	push   $0x0
  pushl $253
80107de5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107dea:	e9 30 ef ff ff       	jmp    80106d1f <alltraps>

80107def <vector254>:
.globl vector254
vector254:
  pushl $0
80107def:	6a 00                	push   $0x0
  pushl $254
80107df1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107df6:	e9 24 ef ff ff       	jmp    80106d1f <alltraps>

80107dfb <vector255>:
.globl vector255
vector255:
  pushl $0
80107dfb:	6a 00                	push   $0x0
  pushl $255
80107dfd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e02:	e9 18 ef ff ff       	jmp    80106d1f <alltraps>

80107e07 <lgdt>:
{
80107e07:	55                   	push   %ebp
80107e08:	89 e5                	mov    %esp,%ebp
80107e0a:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e10:	83 e8 01             	sub    $0x1,%eax
80107e13:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e17:	8b 45 08             	mov    0x8(%ebp),%eax
80107e1a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e21:	c1 e8 10             	shr    $0x10,%eax
80107e24:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107e28:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e2b:	0f 01 10             	lgdtl  (%eax)
}
80107e2e:	90                   	nop
80107e2f:	c9                   	leave  
80107e30:	c3                   	ret    

80107e31 <ltr>:
{
80107e31:	55                   	push   %ebp
80107e32:	89 e5                	mov    %esp,%ebp
80107e34:	83 ec 04             	sub    $0x4,%esp
80107e37:	8b 45 08             	mov    0x8(%ebp),%eax
80107e3a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107e3e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107e42:	0f 00 d8             	ltr    %ax
}
80107e45:	90                   	nop
80107e46:	c9                   	leave  
80107e47:	c3                   	ret    

80107e48 <loadgs>:
{
80107e48:	55                   	push   %ebp
80107e49:	89 e5                	mov    %esp,%ebp
80107e4b:	83 ec 04             	sub    $0x4,%esp
80107e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e51:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107e55:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107e59:	8e e8                	mov    %eax,%gs
}
80107e5b:	90                   	nop
80107e5c:	c9                   	leave  
80107e5d:	c3                   	ret    

80107e5e <lcr3>:

static inline void
lcr3(uint val) 
{
80107e5e:	55                   	push   %ebp
80107e5f:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e61:	8b 45 08             	mov    0x8(%ebp),%eax
80107e64:	0f 22 d8             	mov    %eax,%cr3
}
80107e67:	90                   	nop
80107e68:	5d                   	pop    %ebp
80107e69:	c3                   	ret    

80107e6a <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107e6a:	55                   	push   %ebp
80107e6b:	89 e5                	mov    %esp,%ebp
80107e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e70:	05 00 00 00 80       	add    $0x80000000,%eax
80107e75:	5d                   	pop    %ebp
80107e76:	c3                   	ret    

80107e77 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107e77:	55                   	push   %ebp
80107e78:	89 e5                	mov    %esp,%ebp
80107e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7d:	05 00 00 00 80       	add    $0x80000000,%eax
80107e82:	5d                   	pop    %ebp
80107e83:	c3                   	ret    

80107e84 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107e84:	f3 0f 1e fb          	endbr32 
80107e88:	55                   	push   %ebp
80107e89:	89 e5                	mov    %esp,%ebp
80107e8b:	53                   	push   %ebx
80107e8c:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107e8f:	e8 60 b2 ff ff       	call   801030f4 <cpunum>
80107e94:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107e9a:	05 60 33 11 80       	add    $0x80113360,%eax
80107e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea5:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eae:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb7:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebe:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ec2:	83 e2 f0             	and    $0xfffffff0,%edx
80107ec5:	83 ca 0a             	or     $0xa,%edx
80107ec8:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ece:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ed2:	83 ca 10             	or     $0x10,%edx
80107ed5:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107edf:	83 e2 9f             	and    $0xffffff9f,%edx
80107ee2:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107eec:	83 ca 80             	or     $0xffffff80,%edx
80107eef:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ef9:	83 ca 0f             	or     $0xf,%edx
80107efc:	88 50 7e             	mov    %dl,0x7e(%eax)
80107eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f02:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f06:	83 e2 ef             	and    $0xffffffef,%edx
80107f09:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f13:	83 e2 df             	and    $0xffffffdf,%edx
80107f16:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f20:	83 ca 40             	or     $0x40,%edx
80107f23:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f29:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f2d:	83 ca 80             	or     $0xffffff80,%edx
80107f30:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f36:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107f44:	ff ff 
80107f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f49:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107f50:	00 00 
80107f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f55:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f66:	83 e2 f0             	and    $0xfffffff0,%edx
80107f69:	83 ca 02             	or     $0x2,%edx
80107f6c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f75:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f7c:	83 ca 10             	or     $0x10,%edx
80107f7f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f88:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f8f:	83 e2 9f             	and    $0xffffff9f,%edx
80107f92:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fa2:	83 ca 80             	or     $0xffffff80,%edx
80107fa5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fae:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fb5:	83 ca 0f             	or     $0xf,%edx
80107fb8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fc8:	83 e2 ef             	and    $0xffffffef,%edx
80107fcb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fdb:	83 e2 df             	and    $0xffffffdf,%edx
80107fde:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fee:	83 ca 40             	or     $0x40,%edx
80107ff1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffa:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108001:	83 ca 80             	or     $0xffffff80,%edx
80108004:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010800a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108017:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010801e:	ff ff 
80108020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108023:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010802a:	00 00 
8010802c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108039:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108040:	83 e2 f0             	and    $0xfffffff0,%edx
80108043:	83 ca 0a             	or     $0xa,%edx
80108046:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010804c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108056:	83 ca 10             	or     $0x10,%edx
80108059:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108069:	83 ca 60             	or     $0x60,%edx
8010806c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108075:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010807c:	83 ca 80             	or     $0xffffff80,%edx
8010807f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108088:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010808f:	83 ca 0f             	or     $0xf,%edx
80108092:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080a2:	83 e2 ef             	and    $0xffffffef,%edx
801080a5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ae:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080b5:	83 e2 df             	and    $0xffffffdf,%edx
801080b8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080c8:	83 ca 40             	or     $0x40,%edx
801080cb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080db:	83 ca 80             	or     $0xffffff80,%edx
801080de:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801080e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e7:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801080ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f1:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801080f8:	ff ff 
801080fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fd:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108104:	00 00 
80108106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108109:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108113:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010811a:	83 e2 f0             	and    $0xfffffff0,%edx
8010811d:	83 ca 02             	or     $0x2,%edx
80108120:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108129:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108130:	83 ca 10             	or     $0x10,%edx
80108133:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108143:	83 ca 60             	or     $0x60,%edx
80108146:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010814c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108156:	83 ca 80             	or     $0xffffff80,%edx
80108159:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010815f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108162:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108169:	83 ca 0f             	or     $0xf,%edx
8010816c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108175:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010817c:	83 e2 ef             	and    $0xffffffef,%edx
8010817f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108188:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010818f:	83 e2 df             	and    $0xffffffdf,%edx
80108192:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801081a2:	83 ca 40             	or     $0x40,%edx
801081a5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ae:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801081b5:	83 ca 80             	or     $0xffffff80,%edx
801081b8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c1:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cb:	05 b4 00 00 00       	add    $0xb4,%eax
801081d0:	89 c3                	mov    %eax,%ebx
801081d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d5:	05 b4 00 00 00       	add    $0xb4,%eax
801081da:	c1 e8 10             	shr    $0x10,%eax
801081dd:	89 c2                	mov    %eax,%edx
801081df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e2:	05 b4 00 00 00       	add    $0xb4,%eax
801081e7:	c1 e8 18             	shr    $0x18,%eax
801081ea:	89 c1                	mov    %eax,%ecx
801081ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ef:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801081f6:	00 00 
801081f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fb:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108205:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010820b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108215:	83 e2 f0             	and    $0xfffffff0,%edx
80108218:	83 ca 02             	or     $0x2,%edx
8010821b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108224:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010822b:	83 ca 10             	or     $0x10,%edx
8010822e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108237:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010823e:	83 e2 9f             	and    $0xffffff9f,%edx
80108241:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010824a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108251:	83 ca 80             	or     $0xffffff80,%edx
80108254:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010825a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108264:	83 e2 f0             	and    $0xfffffff0,%edx
80108267:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108270:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108277:	83 e2 ef             	and    $0xffffffef,%edx
8010827a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108283:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010828a:	83 e2 df             	and    $0xffffffdf,%edx
8010828d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108296:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010829d:	83 ca 40             	or     $0x40,%edx
801082a0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801082a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801082b0:	83 ca 80             	or     $0xffffff80,%edx
801082b3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801082b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bc:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801082c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c5:	83 c0 70             	add    $0x70,%eax
801082c8:	83 ec 08             	sub    $0x8,%esp
801082cb:	6a 38                	push   $0x38
801082cd:	50                   	push   %eax
801082ce:	e8 34 fb ff ff       	call   80107e07 <lgdt>
801082d3:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801082d6:	83 ec 0c             	sub    $0xc,%esp
801082d9:	6a 18                	push   $0x18
801082db:	e8 68 fb ff ff       	call   80107e48 <loadgs>
801082e0:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801082e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e6:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801082ec:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801082f3:	00 00 00 00 
}
801082f7:	90                   	nop
801082f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082fb:	c9                   	leave  
801082fc:	c3                   	ret    

801082fd <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801082fd:	f3 0f 1e fb          	endbr32 
80108301:	55                   	push   %ebp
80108302:	89 e5                	mov    %esp,%ebp
80108304:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108307:	8b 45 0c             	mov    0xc(%ebp),%eax
8010830a:	c1 e8 16             	shr    $0x16,%eax
8010830d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108314:	8b 45 08             	mov    0x8(%ebp),%eax
80108317:	01 d0                	add    %edx,%eax
80108319:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010831c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010831f:	8b 00                	mov    (%eax),%eax
80108321:	83 e0 01             	and    $0x1,%eax
80108324:	85 c0                	test   %eax,%eax
80108326:	74 18                	je     80108340 <walkpgdir+0x43>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108328:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010832b:	8b 00                	mov    (%eax),%eax
8010832d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108332:	50                   	push   %eax
80108333:	e8 3f fb ff ff       	call   80107e77 <p2v>
80108338:	83 c4 04             	add    $0x4,%esp
8010833b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010833e:	eb 48                	jmp    80108388 <walkpgdir+0x8b>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108340:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108344:	74 0e                	je     80108354 <walkpgdir+0x57>
80108346:	e8 2c aa ff ff       	call   80102d77 <kalloc>
8010834b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010834e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108352:	75 07                	jne    8010835b <walkpgdir+0x5e>
      return 0;
80108354:	b8 00 00 00 00       	mov    $0x0,%eax
80108359:	eb 44                	jmp    8010839f <walkpgdir+0xa2>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010835b:	83 ec 04             	sub    $0x4,%esp
8010835e:	68 00 10 00 00       	push   $0x1000
80108363:	6a 00                	push   $0x0
80108365:	ff 75 f4             	pushl  -0xc(%ebp)
80108368:	e8 b4 d4 ff ff       	call   80105821 <memset>
8010836d:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108370:	83 ec 0c             	sub    $0xc,%esp
80108373:	ff 75 f4             	pushl  -0xc(%ebp)
80108376:	e8 ef fa ff ff       	call   80107e6a <v2p>
8010837b:	83 c4 10             	add    $0x10,%esp
8010837e:	83 c8 07             	or     $0x7,%eax
80108381:	89 c2                	mov    %eax,%edx
80108383:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108386:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108388:	8b 45 0c             	mov    0xc(%ebp),%eax
8010838b:	c1 e8 0c             	shr    $0xc,%eax
8010838e:	25 ff 03 00 00       	and    $0x3ff,%eax
80108393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010839a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839d:	01 d0                	add    %edx,%eax
}
8010839f:	c9                   	leave  
801083a0:	c3                   	ret    

801083a1 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801083a1:	f3 0f 1e fb          	endbr32 
801083a5:	55                   	push   %ebp
801083a6:	89 e5                	mov    %esp,%ebp
801083a8:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801083ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801083ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801083b6:	8b 55 0c             	mov    0xc(%ebp),%edx
801083b9:	8b 45 10             	mov    0x10(%ebp),%eax
801083bc:	01 d0                	add    %edx,%eax
801083be:	83 e8 01             	sub    $0x1,%eax
801083c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801083c9:	83 ec 04             	sub    $0x4,%esp
801083cc:	6a 01                	push   $0x1
801083ce:	ff 75 f4             	pushl  -0xc(%ebp)
801083d1:	ff 75 08             	pushl  0x8(%ebp)
801083d4:	e8 24 ff ff ff       	call   801082fd <walkpgdir>
801083d9:	83 c4 10             	add    $0x10,%esp
801083dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801083df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083e3:	75 07                	jne    801083ec <mappages+0x4b>
      return -1;
801083e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083ea:	eb 47                	jmp    80108433 <mappages+0x92>
    if(*pte & PTE_P)
801083ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083ef:	8b 00                	mov    (%eax),%eax
801083f1:	83 e0 01             	and    $0x1,%eax
801083f4:	85 c0                	test   %eax,%eax
801083f6:	74 0d                	je     80108405 <mappages+0x64>
      panic("remap");
801083f8:	83 ec 0c             	sub    $0xc,%esp
801083fb:	68 78 92 10 80       	push   $0x80109278
80108400:	e8 92 81 ff ff       	call   80100597 <panic>
    *pte = pa | perm | PTE_P;
80108405:	8b 45 18             	mov    0x18(%ebp),%eax
80108408:	0b 45 14             	or     0x14(%ebp),%eax
8010840b:	83 c8 01             	or     $0x1,%eax
8010840e:	89 c2                	mov    %eax,%edx
80108410:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108413:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108418:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010841b:	74 10                	je     8010842d <mappages+0x8c>
      break;
    a += PGSIZE;
8010841d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108424:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010842b:	eb 9c                	jmp    801083c9 <mappages+0x28>
      break;
8010842d:	90                   	nop
  }
  return 0;
8010842e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108433:	c9                   	leave  
80108434:	c3                   	ret    

80108435 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108435:	f3 0f 1e fb          	endbr32 
80108439:	55                   	push   %ebp
8010843a:	89 e5                	mov    %esp,%ebp
8010843c:	53                   	push   %ebx
8010843d:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108440:	e8 32 a9 ff ff       	call   80102d77 <kalloc>
80108445:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108448:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010844c:	75 0a                	jne    80108458 <setupkvm+0x23>
    return 0;
8010844e:	b8 00 00 00 00       	mov    $0x0,%eax
80108453:	e9 8e 00 00 00       	jmp    801084e6 <setupkvm+0xb1>
  memset(pgdir, 0, PGSIZE);
80108458:	83 ec 04             	sub    $0x4,%esp
8010845b:	68 00 10 00 00       	push   $0x1000
80108460:	6a 00                	push   $0x0
80108462:	ff 75 f0             	pushl  -0x10(%ebp)
80108465:	e8 b7 d3 ff ff       	call   80105821 <memset>
8010846a:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010846d:	83 ec 0c             	sub    $0xc,%esp
80108470:	68 00 00 00 0e       	push   $0xe000000
80108475:	e8 fd f9 ff ff       	call   80107e77 <p2v>
8010847a:	83 c4 10             	add    $0x10,%esp
8010847d:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108482:	76 0d                	jbe    80108491 <setupkvm+0x5c>
    panic("PHYSTOP too high");
80108484:	83 ec 0c             	sub    $0xc,%esp
80108487:	68 7e 92 10 80       	push   $0x8010927e
8010848c:	e8 06 81 ff ff       	call   80100597 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108491:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
80108498:	eb 40                	jmp    801084da <setupkvm+0xa5>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010849a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010849d:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801084a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a3:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801084a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a9:	8b 58 08             	mov    0x8(%eax),%ebx
801084ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084af:	8b 40 04             	mov    0x4(%eax),%eax
801084b2:	29 c3                	sub    %eax,%ebx
801084b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b7:	8b 00                	mov    (%eax),%eax
801084b9:	83 ec 0c             	sub    $0xc,%esp
801084bc:	51                   	push   %ecx
801084bd:	52                   	push   %edx
801084be:	53                   	push   %ebx
801084bf:	50                   	push   %eax
801084c0:	ff 75 f0             	pushl  -0x10(%ebp)
801084c3:	e8 d9 fe ff ff       	call   801083a1 <mappages>
801084c8:	83 c4 20             	add    $0x20,%esp
801084cb:	85 c0                	test   %eax,%eax
801084cd:	79 07                	jns    801084d6 <setupkvm+0xa1>
      return 0;
801084cf:	b8 00 00 00 00       	mov    $0x0,%eax
801084d4:	eb 10                	jmp    801084e6 <setupkvm+0xb1>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801084d6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801084da:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
801084e1:	72 b7                	jb     8010849a <setupkvm+0x65>
  return pgdir;
801084e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801084e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801084e9:	c9                   	leave  
801084ea:	c3                   	ret    

801084eb <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801084eb:	f3 0f 1e fb          	endbr32 
801084ef:	55                   	push   %ebp
801084f0:	89 e5                	mov    %esp,%ebp
801084f2:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801084f5:	e8 3b ff ff ff       	call   80108435 <setupkvm>
801084fa:	a3 38 66 11 80       	mov    %eax,0x80116638
  switchkvm();
801084ff:	e8 03 00 00 00       	call   80108507 <switchkvm>
}
80108504:	90                   	nop
80108505:	c9                   	leave  
80108506:	c3                   	ret    

80108507 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108507:	f3 0f 1e fb          	endbr32 
8010850b:	55                   	push   %ebp
8010850c:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010850e:	a1 38 66 11 80       	mov    0x80116638,%eax
80108513:	50                   	push   %eax
80108514:	e8 51 f9 ff ff       	call   80107e6a <v2p>
80108519:	83 c4 04             	add    $0x4,%esp
8010851c:	50                   	push   %eax
8010851d:	e8 3c f9 ff ff       	call   80107e5e <lcr3>
80108522:	83 c4 04             	add    $0x4,%esp
}
80108525:	90                   	nop
80108526:	c9                   	leave  
80108527:	c3                   	ret    

80108528 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108528:	f3 0f 1e fb          	endbr32 
8010852c:	55                   	push   %ebp
8010852d:	89 e5                	mov    %esp,%ebp
8010852f:	56                   	push   %esi
80108530:	53                   	push   %ebx
  pushcli();
80108531:	e8 dd d1 ff ff       	call   80105713 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108536:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010853c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108543:	83 c2 08             	add    $0x8,%edx
80108546:	89 d6                	mov    %edx,%esi
80108548:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010854f:	83 c2 08             	add    $0x8,%edx
80108552:	c1 ea 10             	shr    $0x10,%edx
80108555:	89 d3                	mov    %edx,%ebx
80108557:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010855e:	83 c2 08             	add    $0x8,%edx
80108561:	c1 ea 18             	shr    $0x18,%edx
80108564:	89 d1                	mov    %edx,%ecx
80108566:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010856d:	67 00 
8010856f:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108576:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010857c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108583:	83 e2 f0             	and    $0xfffffff0,%edx
80108586:	83 ca 09             	or     $0x9,%edx
80108589:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010858f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108596:	83 ca 10             	or     $0x10,%edx
80108599:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010859f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801085a6:	83 e2 9f             	and    $0xffffff9f,%edx
801085a9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801085af:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801085b6:	83 ca 80             	or     $0xffffff80,%edx
801085b9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801085bf:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085c6:	83 e2 f0             	and    $0xfffffff0,%edx
801085c9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085cf:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085d6:	83 e2 ef             	and    $0xffffffef,%edx
801085d9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085df:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085e6:	83 e2 df             	and    $0xffffffdf,%edx
801085e9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085ef:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801085f6:	83 ca 40             	or     $0x40,%edx
801085f9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801085ff:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108606:	83 e2 7f             	and    $0x7f,%edx
80108609:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010860f:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108615:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010861b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108622:	83 e2 ef             	and    $0xffffffef,%edx
80108625:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010862b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108631:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108637:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010863d:	8b 40 08             	mov    0x8(%eax),%eax
80108640:	89 c2                	mov    %eax,%edx
80108642:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108648:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010864e:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108651:	83 ec 0c             	sub    $0xc,%esp
80108654:	6a 30                	push   $0x30
80108656:	e8 d6 f7 ff ff       	call   80107e31 <ltr>
8010865b:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010865e:	8b 45 08             	mov    0x8(%ebp),%eax
80108661:	8b 40 04             	mov    0x4(%eax),%eax
80108664:	85 c0                	test   %eax,%eax
80108666:	75 0d                	jne    80108675 <switchuvm+0x14d>
    panic("switchuvm: no pgdir");
80108668:	83 ec 0c             	sub    $0xc,%esp
8010866b:	68 8f 92 10 80       	push   $0x8010928f
80108670:	e8 22 7f ff ff       	call   80100597 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108675:	8b 45 08             	mov    0x8(%ebp),%eax
80108678:	8b 40 04             	mov    0x4(%eax),%eax
8010867b:	83 ec 0c             	sub    $0xc,%esp
8010867e:	50                   	push   %eax
8010867f:	e8 e6 f7 ff ff       	call   80107e6a <v2p>
80108684:	83 c4 10             	add    $0x10,%esp
80108687:	83 ec 0c             	sub    $0xc,%esp
8010868a:	50                   	push   %eax
8010868b:	e8 ce f7 ff ff       	call   80107e5e <lcr3>
80108690:	83 c4 10             	add    $0x10,%esp
  popcli();
80108693:	e8 c4 d0 ff ff       	call   8010575c <popcli>
}
80108698:	90                   	nop
80108699:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010869c:	5b                   	pop    %ebx
8010869d:	5e                   	pop    %esi
8010869e:	5d                   	pop    %ebp
8010869f:	c3                   	ret    

801086a0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801086a0:	f3 0f 1e fb          	endbr32 
801086a4:	55                   	push   %ebp
801086a5:	89 e5                	mov    %esp,%ebp
801086a7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801086aa:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801086b1:	76 0d                	jbe    801086c0 <inituvm+0x20>
    panic("inituvm: more than a page");
801086b3:	83 ec 0c             	sub    $0xc,%esp
801086b6:	68 a3 92 10 80       	push   $0x801092a3
801086bb:	e8 d7 7e ff ff       	call   80100597 <panic>
  mem = kalloc();
801086c0:	e8 b2 a6 ff ff       	call   80102d77 <kalloc>
801086c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801086c8:	83 ec 04             	sub    $0x4,%esp
801086cb:	68 00 10 00 00       	push   $0x1000
801086d0:	6a 00                	push   $0x0
801086d2:	ff 75 f4             	pushl  -0xc(%ebp)
801086d5:	e8 47 d1 ff ff       	call   80105821 <memset>
801086da:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801086dd:	83 ec 0c             	sub    $0xc,%esp
801086e0:	ff 75 f4             	pushl  -0xc(%ebp)
801086e3:	e8 82 f7 ff ff       	call   80107e6a <v2p>
801086e8:	83 c4 10             	add    $0x10,%esp
801086eb:	83 ec 0c             	sub    $0xc,%esp
801086ee:	6a 06                	push   $0x6
801086f0:	50                   	push   %eax
801086f1:	68 00 10 00 00       	push   $0x1000
801086f6:	6a 00                	push   $0x0
801086f8:	ff 75 08             	pushl  0x8(%ebp)
801086fb:	e8 a1 fc ff ff       	call   801083a1 <mappages>
80108700:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108703:	83 ec 04             	sub    $0x4,%esp
80108706:	ff 75 10             	pushl  0x10(%ebp)
80108709:	ff 75 0c             	pushl  0xc(%ebp)
8010870c:	ff 75 f4             	pushl  -0xc(%ebp)
8010870f:	e8 d4 d1 ff ff       	call   801058e8 <memmove>
80108714:	83 c4 10             	add    $0x10,%esp
}
80108717:	90                   	nop
80108718:	c9                   	leave  
80108719:	c3                   	ret    

8010871a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010871a:	f3 0f 1e fb          	endbr32 
8010871e:	55                   	push   %ebp
8010871f:	89 e5                	mov    %esp,%ebp
80108721:	53                   	push   %ebx
80108722:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108725:	8b 45 0c             	mov    0xc(%ebp),%eax
80108728:	25 ff 0f 00 00       	and    $0xfff,%eax
8010872d:	85 c0                	test   %eax,%eax
8010872f:	74 0d                	je     8010873e <loaduvm+0x24>
    panic("loaduvm: addr must be page aligned");
80108731:	83 ec 0c             	sub    $0xc,%esp
80108734:	68 c0 92 10 80       	push   $0x801092c0
80108739:	e8 59 7e ff ff       	call   80100597 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010873e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108745:	e9 95 00 00 00       	jmp    801087df <loaduvm+0xc5>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010874a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010874d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108750:	01 d0                	add    %edx,%eax
80108752:	83 ec 04             	sub    $0x4,%esp
80108755:	6a 00                	push   $0x0
80108757:	50                   	push   %eax
80108758:	ff 75 08             	pushl  0x8(%ebp)
8010875b:	e8 9d fb ff ff       	call   801082fd <walkpgdir>
80108760:	83 c4 10             	add    $0x10,%esp
80108763:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010876a:	75 0d                	jne    80108779 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
8010876c:	83 ec 0c             	sub    $0xc,%esp
8010876f:	68 e3 92 10 80       	push   $0x801092e3
80108774:	e8 1e 7e ff ff       	call   80100597 <panic>
    pa = PTE_ADDR(*pte);
80108779:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010877c:	8b 00                	mov    (%eax),%eax
8010877e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108783:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108786:	8b 45 18             	mov    0x18(%ebp),%eax
80108789:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010878c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108791:	77 0b                	ja     8010879e <loaduvm+0x84>
      n = sz - i;
80108793:	8b 45 18             	mov    0x18(%ebp),%eax
80108796:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108799:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010879c:	eb 07                	jmp    801087a5 <loaduvm+0x8b>
    else
      n = PGSIZE;
8010879e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801087a5:	8b 55 14             	mov    0x14(%ebp),%edx
801087a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ab:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801087ae:	83 ec 0c             	sub    $0xc,%esp
801087b1:	ff 75 e8             	pushl  -0x18(%ebp)
801087b4:	e8 be f6 ff ff       	call   80107e77 <p2v>
801087b9:	83 c4 10             	add    $0x10,%esp
801087bc:	ff 75 f0             	pushl  -0x10(%ebp)
801087bf:	53                   	push   %ebx
801087c0:	50                   	push   %eax
801087c1:	ff 75 10             	pushl  0x10(%ebp)
801087c4:	e8 cd 97 ff ff       	call   80101f96 <readi>
801087c9:	83 c4 10             	add    $0x10,%esp
801087cc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801087cf:	74 07                	je     801087d8 <loaduvm+0xbe>
      return -1;
801087d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087d6:	eb 18                	jmp    801087f0 <loaduvm+0xd6>
  for(i = 0; i < sz; i += PGSIZE){
801087d8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801087df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e2:	3b 45 18             	cmp    0x18(%ebp),%eax
801087e5:	0f 82 5f ff ff ff    	jb     8010874a <loaduvm+0x30>
  }
  return 0;
801087eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801087f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801087f3:	c9                   	leave  
801087f4:	c3                   	ret    

801087f5 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801087f5:	f3 0f 1e fb          	endbr32 
801087f9:	55                   	push   %ebp
801087fa:	89 e5                	mov    %esp,%ebp
801087fc:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801087ff:	8b 45 10             	mov    0x10(%ebp),%eax
80108802:	85 c0                	test   %eax,%eax
80108804:	79 0a                	jns    80108810 <allocuvm+0x1b>
    return 0;
80108806:	b8 00 00 00 00       	mov    $0x0,%eax
8010880b:	e9 ae 00 00 00       	jmp    801088be <allocuvm+0xc9>
  if(newsz < oldsz)
80108810:	8b 45 10             	mov    0x10(%ebp),%eax
80108813:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108816:	73 08                	jae    80108820 <allocuvm+0x2b>
    return oldsz;
80108818:	8b 45 0c             	mov    0xc(%ebp),%eax
8010881b:	e9 9e 00 00 00       	jmp    801088be <allocuvm+0xc9>

  a = PGROUNDUP(oldsz);
80108820:	8b 45 0c             	mov    0xc(%ebp),%eax
80108823:	05 ff 0f 00 00       	add    $0xfff,%eax
80108828:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010882d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108830:	eb 7d                	jmp    801088af <allocuvm+0xba>
    mem = kalloc();
80108832:	e8 40 a5 ff ff       	call   80102d77 <kalloc>
80108837:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010883a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010883e:	75 2b                	jne    8010886b <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108840:	83 ec 0c             	sub    $0xc,%esp
80108843:	68 01 93 10 80       	push   $0x80109301
80108848:	e8 91 7b ff ff       	call   801003de <cprintf>
8010884d:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108850:	83 ec 04             	sub    $0x4,%esp
80108853:	ff 75 0c             	pushl  0xc(%ebp)
80108856:	ff 75 10             	pushl  0x10(%ebp)
80108859:	ff 75 08             	pushl  0x8(%ebp)
8010885c:	e8 5f 00 00 00       	call   801088c0 <deallocuvm>
80108861:	83 c4 10             	add    $0x10,%esp
      return 0;
80108864:	b8 00 00 00 00       	mov    $0x0,%eax
80108869:	eb 53                	jmp    801088be <allocuvm+0xc9>
    }
    memset(mem, 0, PGSIZE);
8010886b:	83 ec 04             	sub    $0x4,%esp
8010886e:	68 00 10 00 00       	push   $0x1000
80108873:	6a 00                	push   $0x0
80108875:	ff 75 f0             	pushl  -0x10(%ebp)
80108878:	e8 a4 cf ff ff       	call   80105821 <memset>
8010887d:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108880:	83 ec 0c             	sub    $0xc,%esp
80108883:	ff 75 f0             	pushl  -0x10(%ebp)
80108886:	e8 df f5 ff ff       	call   80107e6a <v2p>
8010888b:	83 c4 10             	add    $0x10,%esp
8010888e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108891:	83 ec 0c             	sub    $0xc,%esp
80108894:	6a 06                	push   $0x6
80108896:	50                   	push   %eax
80108897:	68 00 10 00 00       	push   $0x1000
8010889c:	52                   	push   %edx
8010889d:	ff 75 08             	pushl  0x8(%ebp)
801088a0:	e8 fc fa ff ff       	call   801083a1 <mappages>
801088a5:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
801088a8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b2:	3b 45 10             	cmp    0x10(%ebp),%eax
801088b5:	0f 82 77 ff ff ff    	jb     80108832 <allocuvm+0x3d>
  }
  return newsz;
801088bb:	8b 45 10             	mov    0x10(%ebp),%eax
}
801088be:	c9                   	leave  
801088bf:	c3                   	ret    

801088c0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801088c0:	f3 0f 1e fb          	endbr32 
801088c4:	55                   	push   %ebp
801088c5:	89 e5                	mov    %esp,%ebp
801088c7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801088ca:	8b 45 10             	mov    0x10(%ebp),%eax
801088cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088d0:	72 08                	jb     801088da <deallocuvm+0x1a>
    return oldsz;
801088d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801088d5:	e9 a5 00 00 00       	jmp    8010897f <deallocuvm+0xbf>

  a = PGROUNDUP(newsz);
801088da:	8b 45 10             	mov    0x10(%ebp),%eax
801088dd:	05 ff 0f 00 00       	add    $0xfff,%eax
801088e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801088ea:	e9 81 00 00 00       	jmp    80108970 <deallocuvm+0xb0>
    pte = walkpgdir(pgdir, (char*)a, 0);
801088ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f2:	83 ec 04             	sub    $0x4,%esp
801088f5:	6a 00                	push   $0x0
801088f7:	50                   	push   %eax
801088f8:	ff 75 08             	pushl  0x8(%ebp)
801088fb:	e8 fd f9 ff ff       	call   801082fd <walkpgdir>
80108900:	83 c4 10             	add    $0x10,%esp
80108903:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010890a:	75 09                	jne    80108915 <deallocuvm+0x55>
      a += (NPTENTRIES - 1) * PGSIZE;
8010890c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108913:	eb 54                	jmp    80108969 <deallocuvm+0xa9>
    else if((*pte & PTE_P) != 0){
80108915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108918:	8b 00                	mov    (%eax),%eax
8010891a:	83 e0 01             	and    $0x1,%eax
8010891d:	85 c0                	test   %eax,%eax
8010891f:	74 48                	je     80108969 <deallocuvm+0xa9>
      pa = PTE_ADDR(*pte);
80108921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108924:	8b 00                	mov    (%eax),%eax
80108926:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010892b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010892e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108932:	75 0d                	jne    80108941 <deallocuvm+0x81>
        panic("kfree");
80108934:	83 ec 0c             	sub    $0xc,%esp
80108937:	68 19 93 10 80       	push   $0x80109319
8010893c:	e8 56 7c ff ff       	call   80100597 <panic>
      char *v = p2v(pa);
80108941:	83 ec 0c             	sub    $0xc,%esp
80108944:	ff 75 ec             	pushl  -0x14(%ebp)
80108947:	e8 2b f5 ff ff       	call   80107e77 <p2v>
8010894c:	83 c4 10             	add    $0x10,%esp
8010894f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108952:	83 ec 0c             	sub    $0xc,%esp
80108955:	ff 75 e8             	pushl  -0x18(%ebp)
80108958:	e8 79 a3 ff ff       	call   80102cd6 <kfree>
8010895d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108969:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108973:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108976:	0f 82 73 ff ff ff    	jb     801088ef <deallocuvm+0x2f>
    }
  }
  return newsz;
8010897c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010897f:	c9                   	leave  
80108980:	c3                   	ret    

80108981 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108981:	f3 0f 1e fb          	endbr32 
80108985:	55                   	push   %ebp
80108986:	89 e5                	mov    %esp,%ebp
80108988:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010898b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010898f:	75 0d                	jne    8010899e <freevm+0x1d>
    panic("freevm: no pgdir");
80108991:	83 ec 0c             	sub    $0xc,%esp
80108994:	68 1f 93 10 80       	push   $0x8010931f
80108999:	e8 f9 7b ff ff       	call   80100597 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010899e:	83 ec 04             	sub    $0x4,%esp
801089a1:	6a 00                	push   $0x0
801089a3:	68 00 00 00 80       	push   $0x80000000
801089a8:	ff 75 08             	pushl  0x8(%ebp)
801089ab:	e8 10 ff ff ff       	call   801088c0 <deallocuvm>
801089b0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801089b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801089ba:	eb 4f                	jmp    80108a0b <freevm+0x8a>
    if(pgdir[i] & PTE_P){
801089bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089c6:	8b 45 08             	mov    0x8(%ebp),%eax
801089c9:	01 d0                	add    %edx,%eax
801089cb:	8b 00                	mov    (%eax),%eax
801089cd:	83 e0 01             	and    $0x1,%eax
801089d0:	85 c0                	test   %eax,%eax
801089d2:	74 33                	je     80108a07 <freevm+0x86>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801089d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089de:	8b 45 08             	mov    0x8(%ebp),%eax
801089e1:	01 d0                	add    %edx,%eax
801089e3:	8b 00                	mov    (%eax),%eax
801089e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089ea:	83 ec 0c             	sub    $0xc,%esp
801089ed:	50                   	push   %eax
801089ee:	e8 84 f4 ff ff       	call   80107e77 <p2v>
801089f3:	83 c4 10             	add    $0x10,%esp
801089f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801089f9:	83 ec 0c             	sub    $0xc,%esp
801089fc:	ff 75 f0             	pushl  -0x10(%ebp)
801089ff:	e8 d2 a2 ff ff       	call   80102cd6 <kfree>
80108a04:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108a07:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108a0b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108a12:	76 a8                	jbe    801089bc <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
80108a14:	83 ec 0c             	sub    $0xc,%esp
80108a17:	ff 75 08             	pushl  0x8(%ebp)
80108a1a:	e8 b7 a2 ff ff       	call   80102cd6 <kfree>
80108a1f:	83 c4 10             	add    $0x10,%esp
}
80108a22:	90                   	nop
80108a23:	c9                   	leave  
80108a24:	c3                   	ret    

80108a25 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a25:	f3 0f 1e fb          	endbr32 
80108a29:	55                   	push   %ebp
80108a2a:	89 e5                	mov    %esp,%ebp
80108a2c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a2f:	83 ec 04             	sub    $0x4,%esp
80108a32:	6a 00                	push   $0x0
80108a34:	ff 75 0c             	pushl  0xc(%ebp)
80108a37:	ff 75 08             	pushl  0x8(%ebp)
80108a3a:	e8 be f8 ff ff       	call   801082fd <walkpgdir>
80108a3f:	83 c4 10             	add    $0x10,%esp
80108a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108a49:	75 0d                	jne    80108a58 <clearpteu+0x33>
    panic("clearpteu");
80108a4b:	83 ec 0c             	sub    $0xc,%esp
80108a4e:	68 30 93 10 80       	push   $0x80109330
80108a53:	e8 3f 7b ff ff       	call   80100597 <panic>
  *pte &= ~PTE_U;
80108a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a5b:	8b 00                	mov    (%eax),%eax
80108a5d:	83 e0 fb             	and    $0xfffffffb,%eax
80108a60:	89 c2                	mov    %eax,%edx
80108a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a65:	89 10                	mov    %edx,(%eax)
}
80108a67:	90                   	nop
80108a68:	c9                   	leave  
80108a69:	c3                   	ret    

80108a6a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108a6a:	f3 0f 1e fb          	endbr32 
80108a6e:	55                   	push   %ebp
80108a6f:	89 e5                	mov    %esp,%ebp
80108a71:	53                   	push   %ebx
80108a72:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108a75:	e8 bb f9 ff ff       	call   80108435 <setupkvm>
80108a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a81:	75 0a                	jne    80108a8d <copyuvm+0x23>
    return 0;
80108a83:	b8 00 00 00 00       	mov    $0x0,%eax
80108a88:	e9 f6 00 00 00       	jmp    80108b83 <copyuvm+0x119>
  for(i = 0; i < sz; i += PGSIZE){
80108a8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a94:	e9 c2 00 00 00       	jmp    80108b5b <copyuvm+0xf1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a9c:	83 ec 04             	sub    $0x4,%esp
80108a9f:	6a 00                	push   $0x0
80108aa1:	50                   	push   %eax
80108aa2:	ff 75 08             	pushl  0x8(%ebp)
80108aa5:	e8 53 f8 ff ff       	call   801082fd <walkpgdir>
80108aaa:	83 c4 10             	add    $0x10,%esp
80108aad:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108ab0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ab4:	75 0d                	jne    80108ac3 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108ab6:	83 ec 0c             	sub    $0xc,%esp
80108ab9:	68 3a 93 10 80       	push   $0x8010933a
80108abe:	e8 d4 7a ff ff       	call   80100597 <panic>
    if(!(*pte & PTE_P))
80108ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ac6:	8b 00                	mov    (%eax),%eax
80108ac8:	83 e0 01             	and    $0x1,%eax
80108acb:	85 c0                	test   %eax,%eax
80108acd:	75 0d                	jne    80108adc <copyuvm+0x72>
      panic("copyuvm: page not present");
80108acf:	83 ec 0c             	sub    $0xc,%esp
80108ad2:	68 54 93 10 80       	push   $0x80109354
80108ad7:	e8 bb 7a ff ff       	call   80100597 <panic>
    pa = PTE_ADDR(*pte);
80108adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108adf:	8b 00                	mov    (%eax),%eax
80108ae1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aec:	8b 00                	mov    (%eax),%eax
80108aee:	25 ff 0f 00 00       	and    $0xfff,%eax
80108af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108af6:	e8 7c a2 ff ff       	call   80102d77 <kalloc>
80108afb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108afe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108b02:	74 68                	je     80108b6c <copyuvm+0x102>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108b04:	83 ec 0c             	sub    $0xc,%esp
80108b07:	ff 75 e8             	pushl  -0x18(%ebp)
80108b0a:	e8 68 f3 ff ff       	call   80107e77 <p2v>
80108b0f:	83 c4 10             	add    $0x10,%esp
80108b12:	83 ec 04             	sub    $0x4,%esp
80108b15:	68 00 10 00 00       	push   $0x1000
80108b1a:	50                   	push   %eax
80108b1b:	ff 75 e0             	pushl  -0x20(%ebp)
80108b1e:	e8 c5 cd ff ff       	call   801058e8 <memmove>
80108b23:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108b26:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108b29:	83 ec 0c             	sub    $0xc,%esp
80108b2c:	ff 75 e0             	pushl  -0x20(%ebp)
80108b2f:	e8 36 f3 ff ff       	call   80107e6a <v2p>
80108b34:	83 c4 10             	add    $0x10,%esp
80108b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108b3a:	83 ec 0c             	sub    $0xc,%esp
80108b3d:	53                   	push   %ebx
80108b3e:	50                   	push   %eax
80108b3f:	68 00 10 00 00       	push   $0x1000
80108b44:	52                   	push   %edx
80108b45:	ff 75 f0             	pushl  -0x10(%ebp)
80108b48:	e8 54 f8 ff ff       	call   801083a1 <mappages>
80108b4d:	83 c4 20             	add    $0x20,%esp
80108b50:	85 c0                	test   %eax,%eax
80108b52:	78 1b                	js     80108b6f <copyuvm+0x105>
  for(i = 0; i < sz; i += PGSIZE){
80108b54:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b61:	0f 82 32 ff ff ff    	jb     80108a99 <copyuvm+0x2f>
      goto bad;
  }
  return d;
80108b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b6a:	eb 17                	jmp    80108b83 <copyuvm+0x119>
      goto bad;
80108b6c:	90                   	nop
80108b6d:	eb 01                	jmp    80108b70 <copyuvm+0x106>
      goto bad;
80108b6f:	90                   	nop

bad:
  freevm(d);
80108b70:	83 ec 0c             	sub    $0xc,%esp
80108b73:	ff 75 f0             	pushl  -0x10(%ebp)
80108b76:	e8 06 fe ff ff       	call   80108981 <freevm>
80108b7b:	83 c4 10             	add    $0x10,%esp
  return 0;
80108b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108b83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108b86:	c9                   	leave  
80108b87:	c3                   	ret    

80108b88 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108b88:	f3 0f 1e fb          	endbr32 
80108b8c:	55                   	push   %ebp
80108b8d:	89 e5                	mov    %esp,%ebp
80108b8f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b92:	83 ec 04             	sub    $0x4,%esp
80108b95:	6a 00                	push   $0x0
80108b97:	ff 75 0c             	pushl  0xc(%ebp)
80108b9a:	ff 75 08             	pushl  0x8(%ebp)
80108b9d:	e8 5b f7 ff ff       	call   801082fd <walkpgdir>
80108ba2:	83 c4 10             	add    $0x10,%esp
80108ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bab:	8b 00                	mov    (%eax),%eax
80108bad:	83 e0 01             	and    $0x1,%eax
80108bb0:	85 c0                	test   %eax,%eax
80108bb2:	75 07                	jne    80108bbb <uva2ka+0x33>
    return 0;
80108bb4:	b8 00 00 00 00       	mov    $0x0,%eax
80108bb9:	eb 2a                	jmp    80108be5 <uva2ka+0x5d>
  if((*pte & PTE_U) == 0)
80108bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bbe:	8b 00                	mov    (%eax),%eax
80108bc0:	83 e0 04             	and    $0x4,%eax
80108bc3:	85 c0                	test   %eax,%eax
80108bc5:	75 07                	jne    80108bce <uva2ka+0x46>
    return 0;
80108bc7:	b8 00 00 00 00       	mov    $0x0,%eax
80108bcc:	eb 17                	jmp    80108be5 <uva2ka+0x5d>
  return (char*)p2v(PTE_ADDR(*pte));
80108bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd1:	8b 00                	mov    (%eax),%eax
80108bd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bd8:	83 ec 0c             	sub    $0xc,%esp
80108bdb:	50                   	push   %eax
80108bdc:	e8 96 f2 ff ff       	call   80107e77 <p2v>
80108be1:	83 c4 10             	add    $0x10,%esp
80108be4:	90                   	nop
}
80108be5:	c9                   	leave  
80108be6:	c3                   	ret    

80108be7 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108be7:	f3 0f 1e fb          	endbr32 
80108beb:	55                   	push   %ebp
80108bec:	89 e5                	mov    %esp,%ebp
80108bee:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108bf1:	8b 45 10             	mov    0x10(%ebp),%eax
80108bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108bf7:	eb 7f                	jmp    80108c78 <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
80108bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c01:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c07:	83 ec 08             	sub    $0x8,%esp
80108c0a:	50                   	push   %eax
80108c0b:	ff 75 08             	pushl  0x8(%ebp)
80108c0e:	e8 75 ff ff ff       	call   80108b88 <uva2ka>
80108c13:	83 c4 10             	add    $0x10,%esp
80108c16:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108c19:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108c1d:	75 07                	jne    80108c26 <copyout+0x3f>
      return -1;
80108c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c24:	eb 61                	jmp    80108c87 <copyout+0xa0>
    n = PGSIZE - (va - va0);
80108c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c29:	2b 45 0c             	sub    0xc(%ebp),%eax
80108c2c:	05 00 10 00 00       	add    $0x1000,%eax
80108c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c37:	3b 45 14             	cmp    0x14(%ebp),%eax
80108c3a:	76 06                	jbe    80108c42 <copyout+0x5b>
      n = len;
80108c3c:	8b 45 14             	mov    0x14(%ebp),%eax
80108c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c45:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108c48:	89 c2                	mov    %eax,%edx
80108c4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c4d:	01 d0                	add    %edx,%eax
80108c4f:	83 ec 04             	sub    $0x4,%esp
80108c52:	ff 75 f0             	pushl  -0x10(%ebp)
80108c55:	ff 75 f4             	pushl  -0xc(%ebp)
80108c58:	50                   	push   %eax
80108c59:	e8 8a cc ff ff       	call   801058e8 <memmove>
80108c5e:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c64:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c6a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c70:	05 00 10 00 00       	add    $0x1000,%eax
80108c75:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108c78:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108c7c:	0f 85 77 ff ff ff    	jne    80108bf9 <copyout+0x12>
  }
  return 0;
80108c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c87:	c9                   	leave  
80108c88:	c3                   	ret    
