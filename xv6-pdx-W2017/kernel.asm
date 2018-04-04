
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 90 e6 10 80       	mov    $0x8010e690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 99 3d 10 80       	mov    $0x80103d99,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 e8 a1 10 80       	push   $0x8010a1e8
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 5f 68 00 00       	call   801068ab <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 25 11 80 a4 	movl   $0x801125a4,0x801125b0
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 25 11 80 a4 	movl   $0x801125a4,0x801125b4
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 e6 10 80 	movl   $0x8010e6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 25 11 80       	mov    %eax,0x801125b4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 25 11 80       	mov    $0x801125a4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 a0 e6 10 80       	push   $0x8010e6a0
801000c1:	e8 07 68 00 00       	call   801068cd <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 a0 e6 10 80       	push   $0x8010e6a0
8010010c:	e8 23 68 00 00       	call   80106934 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 fe 5a 00 00       	call   80105c2a <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 25 11 80       	mov    0x801125b0,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 a0 e6 10 80       	push   $0x8010e6a0
80100188:	e8 a7 67 00 00       	call   80106934 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 ef a1 10 80       	push   $0x8010a1ef
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 30 2c 00 00       	call   80102e17 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 00 a2 10 80       	push   $0x8010a200
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 ef 2b 00 00       	call   80102e17 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 07 a2 10 80       	push   $0x8010a207
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 73 66 00 00       	call   801068cd <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 25 11 80       	mov    %eax,0x801125b4

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 44 5b 00 00       	call   80105e02 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 66 66 00 00       	call   80106934 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 34 d6 10 80       	mov    0x8010d634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 d6 10 80       	push   $0x8010d600
801003e2:	e8 e6 64 00 00       	call   801068cd <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 0e a2 10 80       	push   $0x8010a20e
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 17 a2 10 80 	movl   $0x8010a217,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 00 d6 10 80       	push   $0x8010d600
8010055b:	e8 d4 63 00 00       	call   80106934 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 34 d6 10 80 00 	movl   $0x0,0x8010d634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 1e a2 10 80       	push   $0x8010a21e
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 2d a2 10 80       	push   $0x8010a22d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 bf 63 00 00       	call   80106986 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 2f a2 10 80       	push   $0x8010a22f
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 33 a2 10 80       	push   $0x8010a233
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 f3 64 00 00       	call   80106bef <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 0a 64 00 00       	call   80106b30 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 b0 80 00 00       	call   8010886b <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 a3 80 00 00       	call   8010886b <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 96 80 00 00       	call   8010886b <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 86 80 00 00       	call   8010886b <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump= 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int dofreedump = 0;
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int doreadydump = 0;
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int dozombiedump = 0;
80100814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int dosleepdump = 0;
8010081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  acquire(&cons.lock);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	68 00 d6 10 80       	push   $0x8010d600
8010082a:	e8 9e 60 00 00       	call   801068cd <acquire>
8010082f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100832:	e9 9a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    switch(c){
80100837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010083a:	83 f8 12             	cmp    $0x12,%eax
8010083d:	74 5c                	je     8010089b <consoleintr+0xa2>
8010083f:	83 f8 12             	cmp    $0x12,%eax
80100842:	7f 18                	jg     8010085c <consoleintr+0x63>
80100844:	83 f8 08             	cmp    $0x8,%eax
80100847:	0f 84 bd 00 00 00    	je     8010090a <consoleintr+0x111>
8010084d:	83 f8 10             	cmp    $0x10,%eax
80100850:	74 31                	je     80100883 <consoleintr+0x8a>
80100852:	83 f8 06             	cmp    $0x6,%eax
80100855:	74 38                	je     8010088f <consoleintr+0x96>
80100857:	e9 e3 00 00 00       	jmp    8010093f <consoleintr+0x146>
8010085c:	83 f8 15             	cmp    $0x15,%eax
8010085f:	74 7b                	je     801008dc <consoleintr+0xe3>
80100861:	83 f8 15             	cmp    $0x15,%eax
80100864:	7f 0a                	jg     80100870 <consoleintr+0x77>
80100866:	83 f8 13             	cmp    $0x13,%eax
80100869:	74 3c                	je     801008a7 <consoleintr+0xae>
8010086b:	e9 cf 00 00 00       	jmp    8010093f <consoleintr+0x146>
80100870:	83 f8 1a             	cmp    $0x1a,%eax
80100873:	74 3e                	je     801008b3 <consoleintr+0xba>
80100875:	83 f8 7f             	cmp    $0x7f,%eax
80100878:	0f 84 8c 00 00 00    	je     8010090a <consoleintr+0x111>
8010087e:	e9 bc 00 00 00       	jmp    8010093f <consoleintr+0x146>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100883:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010088a:	e9 42 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('F'):
      dofreedump = 1;
8010088f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
80100896:	e9 36 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('R'):
      doreadydump = 1;
8010089b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
801008a2:	e9 2a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('S'):
      dosleepdump = 1;
801008a7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
801008ae:	e9 1e 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('Z'):
      dozombiedump = 1;
801008b3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
801008ba:	e9 12 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008bf:	a1 48 28 11 80       	mov    0x80112848,%eax
801008c4:	83 e8 01             	sub    $0x1,%eax
801008c7:	a3 48 28 11 80       	mov    %eax,0x80112848
        consputc(BACKSPACE);
801008cc:	83 ec 0c             	sub    $0xc,%esp
801008cf:	68 00 01 00 00       	push   $0x100
801008d4:	e8 b9 fe ff ff       	call   80100792 <consputc>
801008d9:	83 c4 10             	add    $0x10,%esp
      break;
    case C('Z'):
      dozombiedump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008dc:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008e2:	a1 44 28 11 80       	mov    0x80112844,%eax
801008e7:	39 c2                	cmp    %eax,%edx
801008e9:	0f 84 e2 00 00 00    	je     801009d1 <consoleintr+0x1d8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ef:	a1 48 28 11 80       	mov    0x80112848,%eax
801008f4:	83 e8 01             	sub    $0x1,%eax
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
      break;
    case C('Z'):
      dozombiedump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100901:	3c 0a                	cmp    $0xa,%al
80100903:	75 ba                	jne    801008bf <consoleintr+0xc6>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100905:	e9 c7 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010090a:	8b 15 48 28 11 80    	mov    0x80112848,%edx
80100910:	a1 44 28 11 80       	mov    0x80112844,%eax
80100915:	39 c2                	cmp    %eax,%edx
80100917:	0f 84 b4 00 00 00    	je     801009d1 <consoleintr+0x1d8>
        input.e--;
8010091d:	a1 48 28 11 80       	mov    0x80112848,%eax
80100922:	83 e8 01             	sub    $0x1,%eax
80100925:	a3 48 28 11 80       	mov    %eax,0x80112848
        consputc(BACKSPACE);
8010092a:	83 ec 0c             	sub    $0xc,%esp
8010092d:	68 00 01 00 00       	push   $0x100
80100932:	e8 5b fe ff ff       	call   80100792 <consputc>
80100937:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010093a:	e9 92 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100943:	0f 84 87 00 00 00    	je     801009d0 <consoleintr+0x1d7>
80100949:	8b 15 48 28 11 80    	mov    0x80112848,%edx
8010094f:	a1 40 28 11 80       	mov    0x80112840,%eax
80100954:	29 c2                	sub    %eax,%edx
80100956:	89 d0                	mov    %edx,%eax
80100958:	83 f8 7f             	cmp    $0x7f,%eax
8010095b:	77 73                	ja     801009d0 <consoleintr+0x1d7>
        c = (c == '\r') ? '\n' : c;
8010095d:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
80100961:	74 05                	je     80100968 <consoleintr+0x16f>
80100963:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100966:	eb 05                	jmp    8010096d <consoleintr+0x174>
80100968:	b8 0a 00 00 00       	mov    $0xa,%eax
8010096d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100970:	a1 48 28 11 80       	mov    0x80112848,%eax
80100975:	8d 50 01             	lea    0x1(%eax),%edx
80100978:	89 15 48 28 11 80    	mov    %edx,0x80112848
8010097e:	83 e0 7f             	and    $0x7f,%eax
80100981:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100984:	88 90 c0 27 11 80    	mov    %dl,-0x7feed840(%eax)
        consputc(c);
8010098a:	83 ec 0c             	sub    $0xc,%esp
8010098d:	ff 75 e0             	pushl  -0x20(%ebp)
80100990:	e8 fd fd ff ff       	call   80100792 <consputc>
80100995:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100998:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
8010099c:	74 18                	je     801009b6 <consoleintr+0x1bd>
8010099e:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009a2:	74 12                	je     801009b6 <consoleintr+0x1bd>
801009a4:	a1 48 28 11 80       	mov    0x80112848,%eax
801009a9:	8b 15 40 28 11 80    	mov    0x80112840,%edx
801009af:	83 ea 80             	sub    $0xffffff80,%edx
801009b2:	39 d0                	cmp    %edx,%eax
801009b4:	75 1a                	jne    801009d0 <consoleintr+0x1d7>
          input.w = input.e;
801009b6:	a1 48 28 11 80       	mov    0x80112848,%eax
801009bb:	a3 44 28 11 80       	mov    %eax,0x80112844
          wakeup(&input.r);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 40 28 11 80       	push   $0x80112840
801009c8:	e8 35 54 00 00       	call   80105e02 <wakeup>
801009cd:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009d0:	90                   	nop
  int dofreedump = 0;
  int doreadydump = 0;
  int dozombiedump = 0;
  int dosleepdump = 0;
  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009d1:	8b 45 08             	mov    0x8(%ebp),%eax
801009d4:	ff d0                	call   *%eax
801009d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009dd:	0f 89 54 fe ff ff    	jns    80100837 <consoleintr+0x3e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	68 00 d6 10 80       	push   $0x8010d600
801009eb:	e8 44 5f 00 00       	call   80106934 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009f7:	74 07                	je     80100a00 <consoleintr+0x207>
    procdump();  // now call procdump() wo. cons.lock held
801009f9:	e8 c3 55 00 00       	call   80105fc1 <procdump>
    readydump();
  }
  else if(dozombiedump){
    zombiedump();
  }
}
801009fe:	eb 32                	jmp    80100a32 <consoleintr+0x239>
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
  else if(dofreedump){
80100a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a04:	74 07                	je     80100a0d <consoleintr+0x214>
    freedump();
80100a06:	e8 1c 5a 00 00       	call   80106427 <freedump>
    readydump();
  }
  else if(dozombiedump){
    zombiedump();
  }
}
80100a0b:	eb 25                	jmp    80100a32 <consoleintr+0x239>
    procdump();  // now call procdump() wo. cons.lock held
  }
  else if(dofreedump){
    freedump();
  }
  else if(dosleepdump){
80100a0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a11:	74 07                	je     80100a1a <consoleintr+0x221>
    sleepdump();
80100a13:	e8 72 5a 00 00       	call   8010648a <sleepdump>
    readydump();
  }
  else if(dozombiedump){
    zombiedump();
  }
}
80100a18:	eb 18                	jmp    80100a32 <consoleintr+0x239>
    freedump();
  }
  else if(dosleepdump){
    sleepdump();
  }
  else if(doreadydump){
80100a1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a1e:	74 07                	je     80100a27 <consoleintr+0x22e>
    readydump();
80100a20:	e8 e1 5a 00 00       	call   80106506 <readydump>
  }
  else if(dozombiedump){
    zombiedump();
  }
}
80100a25:	eb 0b                	jmp    80100a32 <consoleintr+0x239>
    sleepdump();
  }
  else if(doreadydump){
    readydump();
  }
  else if(dozombiedump){
80100a27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a2b:	74 05                	je     80100a32 <consoleintr+0x239>
    zombiedump();
80100a2d:	e8 91 5b 00 00       	call   801065c3 <zombiedump>
  }
}
80100a32:	90                   	nop
80100a33:	c9                   	leave  
80100a34:	c3                   	ret    

80100a35 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a35:	55                   	push   %ebp
80100a36:	89 e5                	mov    %esp,%ebp
80100a38:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	ff 75 08             	pushl  0x8(%ebp)
80100a41:	e8 60 15 00 00       	call   80101fa6 <iunlock>
80100a46:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a49:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4f:	83 ec 0c             	sub    $0xc,%esp
80100a52:	68 00 d6 10 80       	push   $0x8010d600
80100a57:	e8 71 5e 00 00       	call   801068cd <acquire>
80100a5c:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a5f:	e9 ac 00 00 00       	jmp    80100b10 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a6a:	8b 40 2c             	mov    0x2c(%eax),%eax
80100a6d:	85 c0                	test   %eax,%eax
80100a6f:	74 28                	je     80100a99 <consoleread+0x64>
        release(&cons.lock);
80100a71:	83 ec 0c             	sub    $0xc,%esp
80100a74:	68 00 d6 10 80       	push   $0x8010d600
80100a79:	e8 b6 5e 00 00       	call   80106934 <release>
80100a7e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	ff 75 08             	pushl  0x8(%ebp)
80100a87:	e8 46 12 00 00       	call   80101cd2 <ilock>
80100a8c:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a94:	e9 ab 00 00 00       	jmp    80100b44 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a99:	83 ec 08             	sub    $0x8,%esp
80100a9c:	68 00 d6 10 80       	push   $0x8010d600
80100aa1:	68 40 28 11 80       	push   $0x80112840
80100aa6:	e8 7f 51 00 00       	call   80105c2a <sleep>
80100aab:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aae:	8b 15 40 28 11 80    	mov    0x80112840,%edx
80100ab4:	a1 44 28 11 80       	mov    0x80112844,%eax
80100ab9:	39 c2                	cmp    %eax,%edx
80100abb:	74 a7                	je     80100a64 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abd:	a1 40 28 11 80       	mov    0x80112840,%eax
80100ac2:	8d 50 01             	lea    0x1(%eax),%edx
80100ac5:	89 15 40 28 11 80    	mov    %edx,0x80112840
80100acb:	83 e0 7f             	and    $0x7f,%eax
80100ace:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
80100ad5:	0f be c0             	movsbl %al,%eax
80100ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100adb:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100adf:	75 17                	jne    80100af8 <consoleread+0xc3>
      if(n < target){
80100ae1:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100ae7:	73 2f                	jae    80100b18 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ae9:	a1 40 28 11 80       	mov    0x80112840,%eax
80100aee:	83 e8 01             	sub    $0x1,%eax
80100af1:	a3 40 28 11 80       	mov    %eax,0x80112840
      }
      break;
80100af6:	eb 20                	jmp    80100b18 <consoleread+0xe3>
    }
    *dst++ = c;
80100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afb:	8d 50 01             	lea    0x1(%eax),%edx
80100afe:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b01:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b04:	88 10                	mov    %dl,(%eax)
    --n;
80100b06:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b0a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b0e:	74 0b                	je     80100b1b <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b14:	7f 98                	jg     80100aae <consoleread+0x79>
80100b16:	eb 04                	jmp    80100b1c <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b18:	90                   	nop
80100b19:	eb 01                	jmp    80100b1c <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b1b:	90                   	nop
  }
  release(&cons.lock);
80100b1c:	83 ec 0c             	sub    $0xc,%esp
80100b1f:	68 00 d6 10 80       	push   $0x8010d600
80100b24:	e8 0b 5e 00 00       	call   80106934 <release>
80100b29:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 9b 11 00 00       	call   80101cd2 <ilock>
80100b37:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b3a:	8b 45 10             	mov    0x10(%ebp),%eax
80100b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b40:	29 c2                	sub    %eax,%edx
80100b42:	89 d0                	mov    %edx,%eax
}
80100b44:	c9                   	leave  
80100b45:	c3                   	ret    

80100b46 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b46:	55                   	push   %ebp
80100b47:	89 e5                	mov    %esp,%ebp
80100b49:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b4c:	83 ec 0c             	sub    $0xc,%esp
80100b4f:	ff 75 08             	pushl  0x8(%ebp)
80100b52:	e8 4f 14 00 00       	call   80101fa6 <iunlock>
80100b57:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b5a:	83 ec 0c             	sub    $0xc,%esp
80100b5d:	68 00 d6 10 80       	push   $0x8010d600
80100b62:	e8 66 5d 00 00       	call   801068cd <acquire>
80100b67:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b71:	eb 21                	jmp    80100b94 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b79:	01 d0                	add    %edx,%eax
80100b7b:	0f b6 00             	movzbl (%eax),%eax
80100b7e:	0f be c0             	movsbl %al,%eax
80100b81:	0f b6 c0             	movzbl %al,%eax
80100b84:	83 ec 0c             	sub    $0xc,%esp
80100b87:	50                   	push   %eax
80100b88:	e8 05 fc ff ff       	call   80100792 <consputc>
80100b8d:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b97:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b9a:	7c d7                	jl     80100b73 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b9c:	83 ec 0c             	sub    $0xc,%esp
80100b9f:	68 00 d6 10 80       	push   $0x8010d600
80100ba4:	e8 8b 5d 00 00       	call   80106934 <release>
80100ba9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bac:	83 ec 0c             	sub    $0xc,%esp
80100baf:	ff 75 08             	pushl  0x8(%ebp)
80100bb2:	e8 1b 11 00 00       	call   80101cd2 <ilock>
80100bb7:	83 c4 10             	add    $0x10,%esp

  return n;
80100bba:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bbd:	c9                   	leave  
80100bbe:	c3                   	ret    

80100bbf <consoleinit>:

void
consoleinit(void)
{
80100bbf:	55                   	push   %ebp
80100bc0:	89 e5                	mov    %esp,%ebp
80100bc2:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bc5:	83 ec 08             	sub    $0x8,%esp
80100bc8:	68 46 a2 10 80       	push   $0x8010a246
80100bcd:	68 00 d6 10 80       	push   $0x8010d600
80100bd2:	e8 d4 5c 00 00       	call   801068ab <initlock>
80100bd7:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bda:	c7 05 0c 32 11 80 46 	movl   $0x80100b46,0x8011320c
80100be1:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be4:	c7 05 08 32 11 80 35 	movl   $0x80100a35,0x80113208
80100beb:	0a 10 80 
  cons.locking = 1;
80100bee:	c7 05 34 d6 10 80 01 	movl   $0x1,0x8010d634
80100bf5:	00 00 00 

  picenable(IRQ_KBD);
80100bf8:	83 ec 0c             	sub    $0xc,%esp
80100bfb:	6a 01                	push   $0x1
80100bfd:	e8 33 38 00 00       	call   80104435 <picenable>
80100c02:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c05:	83 ec 08             	sub    $0x8,%esp
80100c08:	6a 00                	push   $0x0
80100c0a:	6a 01                	push   $0x1
80100c0c:	e8 d3 23 00 00       	call   80102fe4 <ioapicenable>
80100c11:	83 c4 10             	add    $0x10,%esp
}
80100c14:	90                   	nop
80100c15:	c9                   	leave  
80100c16:	c3                   	ret    

80100c17 <exec>:
#include "file.h"
#include "fs.h"

int
exec(char *path, char **argv)
{
80100c17:	55                   	push   %ebp
80100c18:	89 e5                	mov    %esp,%ebp
80100c1a:	81 ec 28 01 00 00    	sub    $0x128,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  #ifdef CS333_P5
  int copy_uid = 0;
80100c20:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  int check_uid_bit = 0;
80100c27:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  #endif

  begin_op();
80100c2e:	e8 24 2e 00 00       	call   80103a57 <begin_op>
  if((ip = namei(path)) == 0){
80100c33:	83 ec 0c             	sub    $0xc,%esp
80100c36:	ff 75 08             	pushl  0x8(%ebp)
80100c39:	e8 f4 1d 00 00       	call   80102a32 <namei>
80100c3e:	83 c4 10             	add    $0x10,%esp
80100c41:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c44:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c48:	75 0f                	jne    80100c59 <exec+0x42>
    end_op();
80100c4a:	e8 94 2e 00 00       	call   80103ae3 <end_op>
    return -1;
80100c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c54:	e9 5e 04 00 00       	jmp    801010b7 <exec+0x4a0>
  }
  ilock(ip);
80100c59:	83 ec 0c             	sub    $0xc,%esp
80100c5c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c5f:	e8 6e 10 00 00       	call   80101cd2 <ilock>
80100c64:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c67:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  #ifdef CS333_P5
  if (ip->uid == proc->uid && ip->mode.flags.u_x);
80100c6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c71:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80100c75:	0f b7 d0             	movzwl %ax,%edx
80100c78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c7e:	8b 40 14             	mov    0x14(%eax),%eax
80100c81:	39 c2                	cmp    %eax,%edx
80100c83:	75 0e                	jne    80100c93 <exec+0x7c>
80100c85:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c88:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80100c8c:	83 e0 40             	and    $0x40,%eax
80100c8f:	84 c0                	test   %al,%al
80100c91:	75 37                	jne    80100cca <exec+0xb3>
  else if (ip->gid == proc->gid && ip->mode.flags.g_x);
80100c93:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c96:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80100c9a:	0f b7 d0             	movzwl %ax,%edx
80100c9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ca3:	8b 40 18             	mov    0x18(%eax),%eax
80100ca6:	39 c2                	cmp    %eax,%edx
80100ca8:	75 0e                	jne    80100cb8 <exec+0xa1>
80100caa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cad:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80100cb1:	83 e0 08             	and    $0x8,%eax
80100cb4:	84 c0                	test   %al,%al
80100cb6:	75 12                	jne    80100cca <exec+0xb3>
  else if (ip->mode.flags.o_x);
80100cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cbb:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80100cbf:	83 e0 01             	and    $0x1,%eax
80100cc2:	84 c0                	test   %al,%al
80100cc4:	0f 84 99 03 00 00    	je     80101063 <exec+0x44c>
  else goto bad;
  copy_uid = ip->uid;
80100cca:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ccd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80100cd1:	0f b7 c0             	movzwl %ax,%eax
80100cd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  check_uid_bit = ip->mode.flags.setuid;
80100cd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cda:	0f b6 40 15          	movzbl 0x15(%eax),%eax
80100cde:	d0 e8                	shr    %al
80100ce0:	83 e0 01             	and    $0x1,%eax
80100ce3:	0f b6 c0             	movzbl %al,%eax
80100ce6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  #endif
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ce9:	6a 34                	push   $0x34
80100ceb:	6a 00                	push   $0x0
80100ced:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100cf3:	50                   	push   %eax
80100cf4:	ff 75 d8             	pushl  -0x28(%ebp)
80100cf7:	e8 e6 16 00 00       	call   801023e2 <readi>
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	83 f8 33             	cmp    $0x33,%eax
80100d02:	0f 86 5e 03 00 00    	jbe    80101066 <exec+0x44f>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100d08:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
80100d0e:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d13:	0f 85 50 03 00 00    	jne    80101069 <exec+0x452>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100d19:	e8 a2 8c 00 00       	call   801099c0 <setupkvm>
80100d1e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d21:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d25:	0f 84 41 03 00 00    	je     8010106c <exec+0x455>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d32:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d39:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
80100d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d42:	e9 ab 00 00 00       	jmp    80100df2 <exec+0x1db>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d4a:	6a 20                	push   $0x20
80100d4c:	50                   	push   %eax
80100d4d:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
80100d53:	50                   	push   %eax
80100d54:	ff 75 d8             	pushl  -0x28(%ebp)
80100d57:	e8 86 16 00 00       	call   801023e2 <readi>
80100d5c:	83 c4 10             	add    $0x10,%esp
80100d5f:	83 f8 20             	cmp    $0x20,%eax
80100d62:	0f 85 07 03 00 00    	jne    8010106f <exec+0x458>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d68:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100d6e:	83 f8 01             	cmp    $0x1,%eax
80100d71:	75 71                	jne    80100de4 <exec+0x1cd>
      continue;
    if(ph.memsz < ph.filesz)
80100d73:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d79:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d7f:	39 c2                	cmp    %eax,%edx
80100d81:	0f 82 eb 02 00 00    	jb     80101072 <exec+0x45b>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d87:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100d8d:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d93:	01 d0                	add    %edx,%eax
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	50                   	push   %eax
80100d99:	ff 75 e0             	pushl  -0x20(%ebp)
80100d9c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d9f:	e8 c3 8f 00 00       	call   80109d67 <allocuvm>
80100da4:	83 c4 10             	add    $0x10,%esp
80100da7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100daa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dae:	0f 84 c1 02 00 00    	je     80101075 <exec+0x45e>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100db4:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100dba:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100dc0:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100dc6:	83 ec 0c             	sub    $0xc,%esp
80100dc9:	52                   	push   %edx
80100dca:	50                   	push   %eax
80100dcb:	ff 75 d8             	pushl  -0x28(%ebp)
80100dce:	51                   	push   %ecx
80100dcf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dd2:	e8 b9 8e 00 00       	call   80109c90 <loaduvm>
80100dd7:	83 c4 20             	add    $0x20,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	0f 88 96 02 00 00    	js     80101078 <exec+0x461>
80100de2:	eb 01                	jmp    80100de5 <exec+0x1ce>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100de4:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dec:	83 c0 20             	add    $0x20,%eax
80100def:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100df2:	0f b7 85 30 ff ff ff 	movzwl -0xd0(%ebp),%eax
80100df9:	0f b7 c0             	movzwl %ax,%eax
80100dfc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100dff:	0f 8f 42 ff ff ff    	jg     80100d47 <exec+0x130>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100e05:	83 ec 0c             	sub    $0xc,%esp
80100e08:	ff 75 d8             	pushl  -0x28(%ebp)
80100e0b:	e8 f8 12 00 00       	call   80102108 <iunlockput>
80100e10:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e13:	e8 cb 2c 00 00       	call   80103ae3 <end_op>
  ip = 0;
80100e18:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e22:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e32:	05 00 20 00 00       	add    $0x2000,%eax
80100e37:	83 ec 04             	sub    $0x4,%esp
80100e3a:	50                   	push   %eax
80100e3b:	ff 75 e0             	pushl  -0x20(%ebp)
80100e3e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e41:	e8 21 8f 00 00       	call   80109d67 <allocuvm>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e50:	0f 84 25 02 00 00    	je     8010107b <exec+0x464>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e59:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e5e:	83 ec 08             	sub    $0x8,%esp
80100e61:	50                   	push   %eax
80100e62:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e65:	e8 23 91 00 00       	call   80109f8d <clearpteu>
80100e6a:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e70:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e7a:	e9 96 00 00 00       	jmp    80100f15 <exec+0x2fe>
    if(argc >= MAXARG)
80100e7f:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e83:	0f 87 f5 01 00 00    	ja     8010107e <exec+0x467>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e96:	01 d0                	add    %edx,%eax
80100e98:	8b 00                	mov    (%eax),%eax
80100e9a:	83 ec 0c             	sub    $0xc,%esp
80100e9d:	50                   	push   %eax
80100e9e:	e8 da 5e 00 00       	call   80106d7d <strlen>
80100ea3:	83 c4 10             	add    $0x10,%esp
80100ea6:	89 c2                	mov    %eax,%edx
80100ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100eab:	29 d0                	sub    %edx,%eax
80100ead:	83 e8 01             	sub    $0x1,%eax
80100eb0:	83 e0 fc             	and    $0xfffffffc,%eax
80100eb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ec3:	01 d0                	add    %edx,%eax
80100ec5:	8b 00                	mov    (%eax),%eax
80100ec7:	83 ec 0c             	sub    $0xc,%esp
80100eca:	50                   	push   %eax
80100ecb:	e8 ad 5e 00 00       	call   80106d7d <strlen>
80100ed0:	83 c4 10             	add    $0x10,%esp
80100ed3:	83 c0 01             	add    $0x1,%eax
80100ed6:	89 c1                	mov    %eax,%ecx
80100ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ee5:	01 d0                	add    %edx,%eax
80100ee7:	8b 00                	mov    (%eax),%eax
80100ee9:	51                   	push   %ecx
80100eea:	50                   	push   %eax
80100eeb:	ff 75 dc             	pushl  -0x24(%ebp)
80100eee:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ef1:	e8 4e 92 00 00       	call   8010a144 <copyout>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	85 c0                	test   %eax,%eax
80100efb:	0f 88 80 01 00 00    	js     80101081 <exec+0x46a>
      goto bad;
    ustack[3+argc] = sp;
80100f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f04:	8d 50 03             	lea    0x3(%eax),%edx
80100f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f0a:	89 84 95 38 ff ff ff 	mov    %eax,-0xc8(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f11:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f22:	01 d0                	add    %edx,%eax
80100f24:	8b 00                	mov    (%eax),%eax
80100f26:	85 c0                	test   %eax,%eax
80100f28:	0f 85 51 ff ff ff    	jne    80100e7f <exec+0x268>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f31:	83 c0 03             	add    $0x3,%eax
80100f34:	c7 84 85 38 ff ff ff 	movl   $0x0,-0xc8(%ebp,%eax,4)
80100f3b:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f3f:	c7 85 38 ff ff ff ff 	movl   $0xffffffff,-0xc8(%ebp)
80100f46:	ff ff ff 
  ustack[1] = argc;
80100f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4c:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f55:	83 c0 01             	add    $0x1,%eax
80100f58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f62:	29 d0                	sub    %edx,%eax
80100f64:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

  sp -= (3+argc+1) * 4;
80100f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f6d:	83 c0 04             	add    $0x4,%eax
80100f70:	c1 e0 02             	shl    $0x2,%eax
80100f73:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f79:	83 c0 04             	add    $0x4,%eax
80100f7c:	c1 e0 02             	shl    $0x2,%eax
80100f7f:	50                   	push   %eax
80100f80:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
80100f86:	50                   	push   %eax
80100f87:	ff 75 dc             	pushl  -0x24(%ebp)
80100f8a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f8d:	e8 b2 91 00 00       	call   8010a144 <copyout>
80100f92:	83 c4 10             	add    $0x10,%esp
80100f95:	85 c0                	test   %eax,%eax
80100f97:	0f 88 e7 00 00 00    	js     80101084 <exec+0x46d>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100fa9:	eb 17                	jmp    80100fc2 <exec+0x3ab>
    if(*s == '/')
80100fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fae:	0f b6 00             	movzbl (%eax),%eax
80100fb1:	3c 2f                	cmp    $0x2f,%al
80100fb3:	75 09                	jne    80100fbe <exec+0x3a7>
      last = s+1;
80100fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb8:	83 c0 01             	add    $0x1,%eax
80100fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fbe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc5:	0f b6 00             	movzbl (%eax),%eax
80100fc8:	84 c0                	test   %al,%al
80100fca:	75 df                	jne    80100fab <exec+0x394>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100fcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fd2:	83 c0 74             	add    $0x74,%eax
80100fd5:	83 ec 04             	sub    $0x4,%esp
80100fd8:	6a 10                	push   $0x10
80100fda:	ff 75 f0             	pushl  -0x10(%ebp)
80100fdd:	50                   	push   %eax
80100fde:	e8 50 5d 00 00       	call   80106d33 <safestrcpy>
80100fe3:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P5
  if(check_uid_bit)
80100fe6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80100fea:	74 0c                	je     80100ff8 <exec+0x3e1>
	proc->uid = copy_uid;
80100fec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ff2:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100ff5:	89 50 14             	mov    %edx,0x14(%eax)
  #endif
  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ff8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	89 45 c8             	mov    %eax,-0x38(%ebp)
  proc->pgdir = pgdir;
80101004:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010100a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010100d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80101010:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101016:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101019:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
8010101b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101021:	8b 40 20             	mov    0x20(%eax),%eax
80101024:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
8010102a:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
8010102d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101033:	8b 40 20             	mov    0x20(%eax),%eax
80101036:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101039:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
8010103c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101042:	83 ec 0c             	sub    $0xc,%esp
80101045:	50                   	push   %eax
80101046:	e8 5c 8a 00 00       	call   80109aa7 <switchuvm>
8010104b:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
8010104e:	83 ec 0c             	sub    $0xc,%esp
80101051:	ff 75 c8             	pushl  -0x38(%ebp)
80101054:	e8 94 8e 00 00       	call   80109eed <freevm>
80101059:	83 c4 10             	add    $0x10,%esp
  return 0;
8010105c:	b8 00 00 00 00       	mov    $0x0,%eax
80101061:	eb 54                	jmp    801010b7 <exec+0x4a0>
  pgdir = 0;
  #ifdef CS333_P5
  if (ip->uid == proc->uid && ip->mode.flags.u_x);
  else if (ip->gid == proc->gid && ip->mode.flags.g_x);
  else if (ip->mode.flags.o_x);
  else goto bad;
80101063:	90                   	nop
80101064:	eb 1f                	jmp    80101085 <exec+0x46e>
  copy_uid = ip->uid;
  check_uid_bit = ip->mode.flags.setuid;
  #endif
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101066:	90                   	nop
80101067:	eb 1c                	jmp    80101085 <exec+0x46e>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101069:	90                   	nop
8010106a:	eb 19                	jmp    80101085 <exec+0x46e>

  if((pgdir = setupkvm()) == 0)
    goto bad;
8010106c:	90                   	nop
8010106d:	eb 16                	jmp    80101085 <exec+0x46e>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010106f:	90                   	nop
80101070:	eb 13                	jmp    80101085 <exec+0x46e>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80101072:	90                   	nop
80101073:	eb 10                	jmp    80101085 <exec+0x46e>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101075:	90                   	nop
80101076:	eb 0d                	jmp    80101085 <exec+0x46e>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101078:	90                   	nop
80101079:	eb 0a                	jmp    80101085 <exec+0x46e>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
8010107b:	90                   	nop
8010107c:	eb 07                	jmp    80101085 <exec+0x46e>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010107e:	90                   	nop
8010107f:	eb 04                	jmp    80101085 <exec+0x46e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80101081:	90                   	nop
80101082:	eb 01                	jmp    80101085 <exec+0x46e>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101084:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101085:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101089:	74 0e                	je     80101099 <exec+0x482>
    freevm(pgdir);
8010108b:	83 ec 0c             	sub    $0xc,%esp
8010108e:	ff 75 d4             	pushl  -0x2c(%ebp)
80101091:	e8 57 8e 00 00       	call   80109eed <freevm>
80101096:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101099:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010109d:	74 13                	je     801010b2 <exec+0x49b>
    iunlockput(ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 75 d8             	pushl  -0x28(%ebp)
801010a5:	e8 5e 10 00 00       	call   80102108 <iunlockput>
801010aa:	83 c4 10             	add    $0x10,%esp
    end_op();
801010ad:	e8 31 2a 00 00       	call   80103ae3 <end_op>
  }
  return -1;
801010b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b7:	c9                   	leave  
801010b8:	c3                   	ret    

801010b9 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010b9:	55                   	push   %ebp
801010ba:	89 e5                	mov    %esp,%ebp
801010bc:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010bf:	83 ec 08             	sub    $0x8,%esp
801010c2:	68 4e a2 10 80       	push   $0x8010a24e
801010c7:	68 60 28 11 80       	push   $0x80112860
801010cc:	e8 da 57 00 00       	call   801068ab <initlock>
801010d1:	83 c4 10             	add    $0x10,%esp
}
801010d4:	90                   	nop
801010d5:	c9                   	leave  
801010d6:	c3                   	ret    

801010d7 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010d7:	55                   	push   %ebp
801010d8:	89 e5                	mov    %esp,%ebp
801010da:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010dd:	83 ec 0c             	sub    $0xc,%esp
801010e0:	68 60 28 11 80       	push   $0x80112860
801010e5:	e8 e3 57 00 00       	call   801068cd <acquire>
801010ea:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010ed:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
801010f4:	eb 2d                	jmp    80101123 <filealloc+0x4c>
    if(f->ref == 0){
801010f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010f9:	8b 40 04             	mov    0x4(%eax),%eax
801010fc:	85 c0                	test   %eax,%eax
801010fe:	75 1f                	jne    8010111f <filealloc+0x48>
      f->ref = 1;
80101100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101103:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010110a:	83 ec 0c             	sub    $0xc,%esp
8010110d:	68 60 28 11 80       	push   $0x80112860
80101112:	e8 1d 58 00 00       	call   80106934 <release>
80101117:	83 c4 10             	add    $0x10,%esp
      return f;
8010111a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010111d:	eb 23                	jmp    80101142 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010111f:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101123:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
80101128:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010112b:	72 c9                	jb     801010f6 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010112d:	83 ec 0c             	sub    $0xc,%esp
80101130:	68 60 28 11 80       	push   $0x80112860
80101135:	e8 fa 57 00 00       	call   80106934 <release>
8010113a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010113d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101142:	c9                   	leave  
80101143:	c3                   	ret    

80101144 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101144:	55                   	push   %ebp
80101145:	89 e5                	mov    %esp,%ebp
80101147:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010114a:	83 ec 0c             	sub    $0xc,%esp
8010114d:	68 60 28 11 80       	push   $0x80112860
80101152:	e8 76 57 00 00       	call   801068cd <acquire>
80101157:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010115a:	8b 45 08             	mov    0x8(%ebp),%eax
8010115d:	8b 40 04             	mov    0x4(%eax),%eax
80101160:	85 c0                	test   %eax,%eax
80101162:	7f 0d                	jg     80101171 <filedup+0x2d>
    panic("filedup");
80101164:	83 ec 0c             	sub    $0xc,%esp
80101167:	68 55 a2 10 80       	push   $0x8010a255
8010116c:	e8 f5 f3 ff ff       	call   80100566 <panic>
  f->ref++;
80101171:	8b 45 08             	mov    0x8(%ebp),%eax
80101174:	8b 40 04             	mov    0x4(%eax),%eax
80101177:	8d 50 01             	lea    0x1(%eax),%edx
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	68 60 28 11 80       	push   $0x80112860
80101188:	e8 a7 57 00 00       	call   80106934 <release>
8010118d:	83 c4 10             	add    $0x10,%esp
  return f;
80101190:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101193:	c9                   	leave  
80101194:	c3                   	ret    

80101195 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101195:	55                   	push   %ebp
80101196:	89 e5                	mov    %esp,%ebp
80101198:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010119b:	83 ec 0c             	sub    $0xc,%esp
8010119e:	68 60 28 11 80       	push   $0x80112860
801011a3:	e8 25 57 00 00       	call   801068cd <acquire>
801011a8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	8b 40 04             	mov    0x4(%eax),%eax
801011b1:	85 c0                	test   %eax,%eax
801011b3:	7f 0d                	jg     801011c2 <fileclose+0x2d>
    panic("fileclose");
801011b5:	83 ec 0c             	sub    $0xc,%esp
801011b8:	68 5d a2 10 80       	push   $0x8010a25d
801011bd:	e8 a4 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801011c2:	8b 45 08             	mov    0x8(%ebp),%eax
801011c5:	8b 40 04             	mov    0x4(%eax),%eax
801011c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	89 50 04             	mov    %edx,0x4(%eax)
801011d1:	8b 45 08             	mov    0x8(%ebp),%eax
801011d4:	8b 40 04             	mov    0x4(%eax),%eax
801011d7:	85 c0                	test   %eax,%eax
801011d9:	7e 15                	jle    801011f0 <fileclose+0x5b>
    release(&ftable.lock);
801011db:	83 ec 0c             	sub    $0xc,%esp
801011de:	68 60 28 11 80       	push   $0x80112860
801011e3:	e8 4c 57 00 00       	call   80106934 <release>
801011e8:	83 c4 10             	add    $0x10,%esp
801011eb:	e9 8b 00 00 00       	jmp    8010127b <fileclose+0xe6>
    return;
  }
  ff = *f;
801011f0:	8b 45 08             	mov    0x8(%ebp),%eax
801011f3:	8b 10                	mov    (%eax),%edx
801011f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
801011f8:	8b 50 04             	mov    0x4(%eax),%edx
801011fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801011fe:	8b 50 08             	mov    0x8(%eax),%edx
80101201:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101204:	8b 50 0c             	mov    0xc(%eax),%edx
80101207:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010120a:	8b 50 10             	mov    0x10(%eax),%edx
8010120d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101210:	8b 40 14             	mov    0x14(%eax),%eax
80101213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101220:	8b 45 08             	mov    0x8(%ebp),%eax
80101223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101229:	83 ec 0c             	sub    $0xc,%esp
8010122c:	68 60 28 11 80       	push   $0x80112860
80101231:	e8 fe 56 00 00       	call   80106934 <release>
80101236:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101239:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010123c:	83 f8 01             	cmp    $0x1,%eax
8010123f:	75 19                	jne    8010125a <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101241:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101245:	0f be d0             	movsbl %al,%edx
80101248:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010124b:	83 ec 08             	sub    $0x8,%esp
8010124e:	52                   	push   %edx
8010124f:	50                   	push   %eax
80101250:	e8 49 34 00 00       	call   8010469e <pipeclose>
80101255:	83 c4 10             	add    $0x10,%esp
80101258:	eb 21                	jmp    8010127b <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010125a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010125d:	83 f8 02             	cmp    $0x2,%eax
80101260:	75 19                	jne    8010127b <fileclose+0xe6>
    begin_op();
80101262:	e8 f0 27 00 00       	call   80103a57 <begin_op>
    iput(ff.ip);
80101267:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010126a:	83 ec 0c             	sub    $0xc,%esp
8010126d:	50                   	push   %eax
8010126e:	e8 a5 0d 00 00       	call   80102018 <iput>
80101273:	83 c4 10             	add    $0x10,%esp
    end_op();
80101276:	e8 68 28 00 00       	call   80103ae3 <end_op>
  }
}
8010127b:	c9                   	leave  
8010127c:	c3                   	ret    

8010127d <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010127d:	55                   	push   %ebp
8010127e:	89 e5                	mov    %esp,%ebp
80101280:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101283:	8b 45 08             	mov    0x8(%ebp),%eax
80101286:	8b 00                	mov    (%eax),%eax
80101288:	83 f8 02             	cmp    $0x2,%eax
8010128b:	75 40                	jne    801012cd <filestat+0x50>
    ilock(f->ip);
8010128d:	8b 45 08             	mov    0x8(%ebp),%eax
80101290:	8b 40 10             	mov    0x10(%eax),%eax
80101293:	83 ec 0c             	sub    $0xc,%esp
80101296:	50                   	push   %eax
80101297:	e8 36 0a 00 00       	call   80101cd2 <ilock>
8010129c:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010129f:	8b 45 08             	mov    0x8(%ebp),%eax
801012a2:	8b 40 10             	mov    0x10(%eax),%eax
801012a5:	83 ec 08             	sub    $0x8,%esp
801012a8:	ff 75 0c             	pushl  0xc(%ebp)
801012ab:	50                   	push   %eax
801012ac:	e8 bf 10 00 00       	call   80102370 <stati>
801012b1:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012b4:	8b 45 08             	mov    0x8(%ebp),%eax
801012b7:	8b 40 10             	mov    0x10(%eax),%eax
801012ba:	83 ec 0c             	sub    $0xc,%esp
801012bd:	50                   	push   %eax
801012be:	e8 e3 0c 00 00       	call   80101fa6 <iunlock>
801012c3:	83 c4 10             	add    $0x10,%esp
    return 0;
801012c6:	b8 00 00 00 00       	mov    $0x0,%eax
801012cb:	eb 05                	jmp    801012d2 <filestat+0x55>
  }
  return -1;
801012cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012d2:	c9                   	leave  
801012d3:	c3                   	ret    

801012d4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012d4:	55                   	push   %ebp
801012d5:	89 e5                	mov    %esp,%ebp
801012d7:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012da:	8b 45 08             	mov    0x8(%ebp),%eax
801012dd:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012e1:	84 c0                	test   %al,%al
801012e3:	75 0a                	jne    801012ef <fileread+0x1b>
    return -1;
801012e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ea:	e9 9b 00 00 00       	jmp    8010138a <fileread+0xb6>
  if(f->type == FD_PIPE)
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 00                	mov    (%eax),%eax
801012f4:	83 f8 01             	cmp    $0x1,%eax
801012f7:	75 1a                	jne    80101313 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801012f9:	8b 45 08             	mov    0x8(%ebp),%eax
801012fc:	8b 40 0c             	mov    0xc(%eax),%eax
801012ff:	83 ec 04             	sub    $0x4,%esp
80101302:	ff 75 10             	pushl  0x10(%ebp)
80101305:	ff 75 0c             	pushl  0xc(%ebp)
80101308:	50                   	push   %eax
80101309:	e8 38 35 00 00       	call   80104846 <piperead>
8010130e:	83 c4 10             	add    $0x10,%esp
80101311:	eb 77                	jmp    8010138a <fileread+0xb6>
  if(f->type == FD_INODE){
80101313:	8b 45 08             	mov    0x8(%ebp),%eax
80101316:	8b 00                	mov    (%eax),%eax
80101318:	83 f8 02             	cmp    $0x2,%eax
8010131b:	75 60                	jne    8010137d <fileread+0xa9>
    ilock(f->ip);
8010131d:	8b 45 08             	mov    0x8(%ebp),%eax
80101320:	8b 40 10             	mov    0x10(%eax),%eax
80101323:	83 ec 0c             	sub    $0xc,%esp
80101326:	50                   	push   %eax
80101327:	e8 a6 09 00 00       	call   80101cd2 <ilock>
8010132c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010132f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101332:	8b 45 08             	mov    0x8(%ebp),%eax
80101335:	8b 50 14             	mov    0x14(%eax),%edx
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	8b 40 10             	mov    0x10(%eax),%eax
8010133e:	51                   	push   %ecx
8010133f:	52                   	push   %edx
80101340:	ff 75 0c             	pushl  0xc(%ebp)
80101343:	50                   	push   %eax
80101344:	e8 99 10 00 00       	call   801023e2 <readi>
80101349:	83 c4 10             	add    $0x10,%esp
8010134c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010134f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101353:	7e 11                	jle    80101366 <fileread+0x92>
      f->off += r;
80101355:	8b 45 08             	mov    0x8(%ebp),%eax
80101358:	8b 50 14             	mov    0x14(%eax),%edx
8010135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135e:	01 c2                	add    %eax,%edx
80101360:	8b 45 08             	mov    0x8(%ebp),%eax
80101363:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	8b 40 10             	mov    0x10(%eax),%eax
8010136c:	83 ec 0c             	sub    $0xc,%esp
8010136f:	50                   	push   %eax
80101370:	e8 31 0c 00 00       	call   80101fa6 <iunlock>
80101375:	83 c4 10             	add    $0x10,%esp
    return r;
80101378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137b:	eb 0d                	jmp    8010138a <fileread+0xb6>
  }
  panic("fileread");
8010137d:	83 ec 0c             	sub    $0xc,%esp
80101380:	68 67 a2 10 80       	push   $0x8010a267
80101385:	e8 dc f1 ff ff       	call   80100566 <panic>
}
8010138a:	c9                   	leave  
8010138b:	c3                   	ret    

8010138c <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010138c:	55                   	push   %ebp
8010138d:	89 e5                	mov    %esp,%ebp
8010138f:	53                   	push   %ebx
80101390:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101393:	8b 45 08             	mov    0x8(%ebp),%eax
80101396:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010139a:	84 c0                	test   %al,%al
8010139c:	75 0a                	jne    801013a8 <filewrite+0x1c>
    return -1;
8010139e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013a3:	e9 1b 01 00 00       	jmp    801014c3 <filewrite+0x137>
  if(f->type == FD_PIPE)
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	8b 00                	mov    (%eax),%eax
801013ad:	83 f8 01             	cmp    $0x1,%eax
801013b0:	75 1d                	jne    801013cf <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801013b2:	8b 45 08             	mov    0x8(%ebp),%eax
801013b5:	8b 40 0c             	mov    0xc(%eax),%eax
801013b8:	83 ec 04             	sub    $0x4,%esp
801013bb:	ff 75 10             	pushl  0x10(%ebp)
801013be:	ff 75 0c             	pushl  0xc(%ebp)
801013c1:	50                   	push   %eax
801013c2:	e8 81 33 00 00       	call   80104748 <pipewrite>
801013c7:	83 c4 10             	add    $0x10,%esp
801013ca:	e9 f4 00 00 00       	jmp    801014c3 <filewrite+0x137>
  if(f->type == FD_INODE){
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	8b 00                	mov    (%eax),%eax
801013d4:	83 f8 02             	cmp    $0x2,%eax
801013d7:	0f 85 d9 00 00 00    	jne    801014b6 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013dd:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013eb:	e9 a3 00 00 00       	jmp    80101493 <filewrite+0x107>
      int n1 = n - i;
801013f0:	8b 45 10             	mov    0x10(%ebp),%eax
801013f3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801013f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801013f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801013ff:	7e 06                	jle    80101407 <filewrite+0x7b>
        n1 = max;
80101401:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101404:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101407:	e8 4b 26 00 00       	call   80103a57 <begin_op>
      ilock(f->ip);
8010140c:	8b 45 08             	mov    0x8(%ebp),%eax
8010140f:	8b 40 10             	mov    0x10(%eax),%eax
80101412:	83 ec 0c             	sub    $0xc,%esp
80101415:	50                   	push   %eax
80101416:	e8 b7 08 00 00       	call   80101cd2 <ilock>
8010141b:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010141e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101421:	8b 45 08             	mov    0x8(%ebp),%eax
80101424:	8b 50 14             	mov    0x14(%eax),%edx
80101427:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010142a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010142d:	01 c3                	add    %eax,%ebx
8010142f:	8b 45 08             	mov    0x8(%ebp),%eax
80101432:	8b 40 10             	mov    0x10(%eax),%eax
80101435:	51                   	push   %ecx
80101436:	52                   	push   %edx
80101437:	53                   	push   %ebx
80101438:	50                   	push   %eax
80101439:	e8 fb 10 00 00       	call   80102539 <writei>
8010143e:	83 c4 10             	add    $0x10,%esp
80101441:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101444:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101448:	7e 11                	jle    8010145b <filewrite+0xcf>
        f->off += r;
8010144a:	8b 45 08             	mov    0x8(%ebp),%eax
8010144d:	8b 50 14             	mov    0x14(%eax),%edx
80101450:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101453:	01 c2                	add    %eax,%edx
80101455:	8b 45 08             	mov    0x8(%ebp),%eax
80101458:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010145b:	8b 45 08             	mov    0x8(%ebp),%eax
8010145e:	8b 40 10             	mov    0x10(%eax),%eax
80101461:	83 ec 0c             	sub    $0xc,%esp
80101464:	50                   	push   %eax
80101465:	e8 3c 0b 00 00       	call   80101fa6 <iunlock>
8010146a:	83 c4 10             	add    $0x10,%esp
      end_op();
8010146d:	e8 71 26 00 00       	call   80103ae3 <end_op>

      if(r < 0)
80101472:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101476:	78 29                	js     801014a1 <filewrite+0x115>
        break;
      if(r != n1)
80101478:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010147b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010147e:	74 0d                	je     8010148d <filewrite+0x101>
        panic("short filewrite");
80101480:	83 ec 0c             	sub    $0xc,%esp
80101483:	68 70 a2 10 80       	push   $0x8010a270
80101488:	e8 d9 f0 ff ff       	call   80100566 <panic>
      i += r;
8010148d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101490:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101496:	3b 45 10             	cmp    0x10(%ebp),%eax
80101499:	0f 8c 51 ff ff ff    	jl     801013f0 <filewrite+0x64>
8010149f:	eb 01                	jmp    801014a2 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801014a1:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a5:	3b 45 10             	cmp    0x10(%ebp),%eax
801014a8:	75 05                	jne    801014af <filewrite+0x123>
801014aa:	8b 45 10             	mov    0x10(%ebp),%eax
801014ad:	eb 14                	jmp    801014c3 <filewrite+0x137>
801014af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014b4:	eb 0d                	jmp    801014c3 <filewrite+0x137>
  }
  panic("filewrite");
801014b6:	83 ec 0c             	sub    $0xc,%esp
801014b9:	68 80 a2 10 80       	push   $0x8010a280
801014be:	e8 a3 f0 ff ff       	call   80100566 <panic>
}
801014c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014c6:	c9                   	leave  
801014c7:	c3                   	ret    

801014c8 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014c8:	55                   	push   %ebp
801014c9:	89 e5                	mov    %esp,%ebp
801014cb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801014ce:	8b 45 08             	mov    0x8(%ebp),%eax
801014d1:	83 ec 08             	sub    $0x8,%esp
801014d4:	6a 01                	push   $0x1
801014d6:	50                   	push   %eax
801014d7:	e8 da ec ff ff       	call   801001b6 <bread>
801014dc:	83 c4 10             	add    $0x10,%esp
801014df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e5:	83 c0 18             	add    $0x18,%eax
801014e8:	83 ec 04             	sub    $0x4,%esp
801014eb:	6a 1c                	push   $0x1c
801014ed:	50                   	push   %eax
801014ee:	ff 75 0c             	pushl  0xc(%ebp)
801014f1:	e8 f9 56 00 00       	call   80106bef <memmove>
801014f6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014f9:	83 ec 0c             	sub    $0xc,%esp
801014fc:	ff 75 f4             	pushl  -0xc(%ebp)
801014ff:	e8 2a ed ff ff       	call   8010022e <brelse>
80101504:	83 c4 10             	add    $0x10,%esp
}
80101507:	90                   	nop
80101508:	c9                   	leave  
80101509:	c3                   	ret    

8010150a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010150a:	55                   	push   %ebp
8010150b:	89 e5                	mov    %esp,%ebp
8010150d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101510:	8b 55 0c             	mov    0xc(%ebp),%edx
80101513:	8b 45 08             	mov    0x8(%ebp),%eax
80101516:	83 ec 08             	sub    $0x8,%esp
80101519:	52                   	push   %edx
8010151a:	50                   	push   %eax
8010151b:	e8 96 ec ff ff       	call   801001b6 <bread>
80101520:	83 c4 10             	add    $0x10,%esp
80101523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101529:	83 c0 18             	add    $0x18,%eax
8010152c:	83 ec 04             	sub    $0x4,%esp
8010152f:	68 00 02 00 00       	push   $0x200
80101534:	6a 00                	push   $0x0
80101536:	50                   	push   %eax
80101537:	e8 f4 55 00 00       	call   80106b30 <memset>
8010153c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010153f:	83 ec 0c             	sub    $0xc,%esp
80101542:	ff 75 f4             	pushl  -0xc(%ebp)
80101545:	e8 45 27 00 00       	call   80103c8f <log_write>
8010154a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010154d:	83 ec 0c             	sub    $0xc,%esp
80101550:	ff 75 f4             	pushl  -0xc(%ebp)
80101553:	e8 d6 ec ff ff       	call   8010022e <brelse>
80101558:	83 c4 10             	add    $0x10,%esp
}
8010155b:	90                   	nop
8010155c:	c9                   	leave  
8010155d:	c3                   	ret    

8010155e <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010155e:	55                   	push   %ebp
8010155f:	89 e5                	mov    %esp,%ebp
80101561:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010156b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101572:	e9 13 01 00 00       	jmp    8010168a <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010157a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101580:	85 c0                	test   %eax,%eax
80101582:	0f 48 c2             	cmovs  %edx,%eax
80101585:	c1 f8 0c             	sar    $0xc,%eax
80101588:	89 c2                	mov    %eax,%edx
8010158a:	a1 78 32 11 80       	mov    0x80113278,%eax
8010158f:	01 d0                	add    %edx,%eax
80101591:	83 ec 08             	sub    $0x8,%esp
80101594:	50                   	push   %eax
80101595:	ff 75 08             	pushl  0x8(%ebp)
80101598:	e8 19 ec ff ff       	call   801001b6 <bread>
8010159d:	83 c4 10             	add    $0x10,%esp
801015a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015aa:	e9 a6 00 00 00       	jmp    80101655 <balloc+0xf7>
      m = 1 << (bi % 8);
801015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b2:	99                   	cltd   
801015b3:	c1 ea 1d             	shr    $0x1d,%edx
801015b6:	01 d0                	add    %edx,%eax
801015b8:	83 e0 07             	and    $0x7,%eax
801015bb:	29 d0                	sub    %edx,%eax
801015bd:	ba 01 00 00 00       	mov    $0x1,%edx
801015c2:	89 c1                	mov    %eax,%ecx
801015c4:	d3 e2                	shl    %cl,%edx
801015c6:	89 d0                	mov    %edx,%eax
801015c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ce:	8d 50 07             	lea    0x7(%eax),%edx
801015d1:	85 c0                	test   %eax,%eax
801015d3:	0f 48 c2             	cmovs  %edx,%eax
801015d6:	c1 f8 03             	sar    $0x3,%eax
801015d9:	89 c2                	mov    %eax,%edx
801015db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015de:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015e3:	0f b6 c0             	movzbl %al,%eax
801015e6:	23 45 e8             	and    -0x18(%ebp),%eax
801015e9:	85 c0                	test   %eax,%eax
801015eb:	75 64                	jne    80101651 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f0:	8d 50 07             	lea    0x7(%eax),%edx
801015f3:	85 c0                	test   %eax,%eax
801015f5:	0f 48 c2             	cmovs  %edx,%eax
801015f8:	c1 f8 03             	sar    $0x3,%eax
801015fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015fe:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101603:	89 d1                	mov    %edx,%ecx
80101605:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101608:	09 ca                	or     %ecx,%edx
8010160a:	89 d1                	mov    %edx,%ecx
8010160c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160f:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101613:	83 ec 0c             	sub    $0xc,%esp
80101616:	ff 75 ec             	pushl  -0x14(%ebp)
80101619:	e8 71 26 00 00       	call   80103c8f <log_write>
8010161e:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101621:	83 ec 0c             	sub    $0xc,%esp
80101624:	ff 75 ec             	pushl  -0x14(%ebp)
80101627:	e8 02 ec ff ff       	call   8010022e <brelse>
8010162c:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010162f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101632:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101635:	01 c2                	add    %eax,%edx
80101637:	8b 45 08             	mov    0x8(%ebp),%eax
8010163a:	83 ec 08             	sub    $0x8,%esp
8010163d:	52                   	push   %edx
8010163e:	50                   	push   %eax
8010163f:	e8 c6 fe ff ff       	call   8010150a <bzero>
80101644:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101647:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164d:	01 d0                	add    %edx,%eax
8010164f:	eb 57                	jmp    801016a8 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101651:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101655:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010165c:	7f 17                	jg     80101675 <balloc+0x117>
8010165e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101664:	01 d0                	add    %edx,%eax
80101666:	89 c2                	mov    %eax,%edx
80101668:	a1 60 32 11 80       	mov    0x80113260,%eax
8010166d:	39 c2                	cmp    %eax,%edx
8010166f:	0f 82 3a ff ff ff    	jb     801015af <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101675:	83 ec 0c             	sub    $0xc,%esp
80101678:	ff 75 ec             	pushl  -0x14(%ebp)
8010167b:	e8 ae eb ff ff       	call   8010022e <brelse>
80101680:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101683:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010168a:	8b 15 60 32 11 80    	mov    0x80113260,%edx
80101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101693:	39 c2                	cmp    %eax,%edx
80101695:	0f 87 dc fe ff ff    	ja     80101577 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010169b:	83 ec 0c             	sub    $0xc,%esp
8010169e:	68 8c a2 10 80       	push   $0x8010a28c
801016a3:	e8 be ee ff ff       	call   80100566 <panic>
}
801016a8:	c9                   	leave  
801016a9:	c3                   	ret    

801016aa <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016aa:	55                   	push   %ebp
801016ab:	89 e5                	mov    %esp,%ebp
801016ad:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016b0:	83 ec 08             	sub    $0x8,%esp
801016b3:	68 60 32 11 80       	push   $0x80113260
801016b8:	ff 75 08             	pushl  0x8(%ebp)
801016bb:	e8 08 fe ff ff       	call   801014c8 <readsb>
801016c0:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801016c6:	c1 e8 0c             	shr    $0xc,%eax
801016c9:	89 c2                	mov    %eax,%edx
801016cb:	a1 78 32 11 80       	mov    0x80113278,%eax
801016d0:	01 c2                	add    %eax,%edx
801016d2:	8b 45 08             	mov    0x8(%ebp),%eax
801016d5:	83 ec 08             	sub    $0x8,%esp
801016d8:	52                   	push   %edx
801016d9:	50                   	push   %eax
801016da:	e8 d7 ea ff ff       	call   801001b6 <bread>
801016df:	83 c4 10             	add    $0x10,%esp
801016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801016e8:	25 ff 0f 00 00       	and    $0xfff,%eax
801016ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f3:	99                   	cltd   
801016f4:	c1 ea 1d             	shr    $0x1d,%edx
801016f7:	01 d0                	add    %edx,%eax
801016f9:	83 e0 07             	and    $0x7,%eax
801016fc:	29 d0                	sub    %edx,%eax
801016fe:	ba 01 00 00 00       	mov    $0x1,%edx
80101703:	89 c1                	mov    %eax,%ecx
80101705:	d3 e2                	shl    %cl,%edx
80101707:	89 d0                	mov    %edx,%eax
80101709:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170f:	8d 50 07             	lea    0x7(%eax),%edx
80101712:	85 c0                	test   %eax,%eax
80101714:	0f 48 c2             	cmovs  %edx,%eax
80101717:	c1 f8 03             	sar    $0x3,%eax
8010171a:	89 c2                	mov    %eax,%edx
8010171c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171f:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101724:	0f b6 c0             	movzbl %al,%eax
80101727:	23 45 ec             	and    -0x14(%ebp),%eax
8010172a:	85 c0                	test   %eax,%eax
8010172c:	75 0d                	jne    8010173b <bfree+0x91>
    panic("freeing free block");
8010172e:	83 ec 0c             	sub    $0xc,%esp
80101731:	68 a2 a2 10 80       	push   $0x8010a2a2
80101736:	e8 2b ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
8010173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173e:	8d 50 07             	lea    0x7(%eax),%edx
80101741:	85 c0                	test   %eax,%eax
80101743:	0f 48 c2             	cmovs  %edx,%eax
80101746:	c1 f8 03             	sar    $0x3,%eax
80101749:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010174c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101751:	89 d1                	mov    %edx,%ecx
80101753:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101756:	f7 d2                	not    %edx
80101758:	21 ca                	and    %ecx,%edx
8010175a:	89 d1                	mov    %edx,%ecx
8010175c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010175f:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101763:	83 ec 0c             	sub    $0xc,%esp
80101766:	ff 75 f4             	pushl  -0xc(%ebp)
80101769:	e8 21 25 00 00       	call   80103c8f <log_write>
8010176e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101771:	83 ec 0c             	sub    $0xc,%esp
80101774:	ff 75 f4             	pushl  -0xc(%ebp)
80101777:	e8 b2 ea ff ff       	call   8010022e <brelse>
8010177c:	83 c4 10             	add    $0x10,%esp
}
8010177f:	90                   	nop
80101780:	c9                   	leave  
80101781:	c3                   	ret    

80101782 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101782:	55                   	push   %ebp
80101783:	89 e5                	mov    %esp,%ebp
80101785:	57                   	push   %edi
80101786:	56                   	push   %esi
80101787:	53                   	push   %ebx
80101788:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010178b:	83 ec 08             	sub    $0x8,%esp
8010178e:	68 b5 a2 10 80       	push   $0x8010a2b5
80101793:	68 80 32 11 80       	push   $0x80113280
80101798:	e8 0e 51 00 00       	call   801068ab <initlock>
8010179d:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801017a0:	83 ec 08             	sub    $0x8,%esp
801017a3:	68 60 32 11 80       	push   $0x80113260
801017a8:	ff 75 08             	pushl  0x8(%ebp)
801017ab:	e8 18 fd ff ff       	call   801014c8 <readsb>
801017b0:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801017b3:	a1 78 32 11 80       	mov    0x80113278,%eax
801017b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017bb:	8b 3d 74 32 11 80    	mov    0x80113274,%edi
801017c1:	8b 35 70 32 11 80    	mov    0x80113270,%esi
801017c7:	8b 1d 6c 32 11 80    	mov    0x8011326c,%ebx
801017cd:	8b 0d 68 32 11 80    	mov    0x80113268,%ecx
801017d3:	8b 15 64 32 11 80    	mov    0x80113264,%edx
801017d9:	a1 60 32 11 80       	mov    0x80113260,%eax
801017de:	ff 75 e4             	pushl  -0x1c(%ebp)
801017e1:	57                   	push   %edi
801017e2:	56                   	push   %esi
801017e3:	53                   	push   %ebx
801017e4:	51                   	push   %ecx
801017e5:	52                   	push   %edx
801017e6:	50                   	push   %eax
801017e7:	68 bc a2 10 80       	push   $0x8010a2bc
801017ec:	e8 d5 eb ff ff       	call   801003c6 <cprintf>
801017f1:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801017f4:	90                   	nop
801017f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f8:	5b                   	pop    %ebx
801017f9:	5e                   	pop    %esi
801017fa:	5f                   	pop    %edi
801017fb:	5d                   	pop    %ebp
801017fc:	c3                   	ret    

801017fd <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801017fd:	55                   	push   %ebp
801017fe:	89 e5                	mov    %esp,%ebp
80101800:	83 ec 28             	sub    $0x28,%esp
80101803:	8b 45 0c             	mov    0xc(%ebp),%eax
80101806:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010180a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101811:	e9 40 01 00 00       	jmp    80101956 <ialloc+0x159>
    bp = bread(dev, IBLOCK(inum, sb));
80101816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101819:	c1 e8 03             	shr    $0x3,%eax
8010181c:	89 c2                	mov    %eax,%edx
8010181e:	a1 74 32 11 80       	mov    0x80113274,%eax
80101823:	01 d0                	add    %edx,%eax
80101825:	83 ec 08             	sub    $0x8,%esp
80101828:	50                   	push   %eax
80101829:	ff 75 08             	pushl  0x8(%ebp)
8010182c:	e8 85 e9 ff ff       	call   801001b6 <bread>
80101831:	83 c4 10             	add    $0x10,%esp
80101834:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101837:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183a:	8d 50 18             	lea    0x18(%eax),%edx
8010183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101840:	83 e0 07             	and    $0x7,%eax
80101843:	c1 e0 06             	shl    $0x6,%eax
80101846:	01 d0                	add    %edx,%eax
80101848:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010184b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010184e:	0f b7 00             	movzwl (%eax),%eax
80101851:	66 85 c0             	test   %ax,%ax
80101854:	0f 85 ea 00 00 00    	jne    80101944 <ialloc+0x147>
      memset(dip, 0, sizeof(*dip));
8010185a:	83 ec 04             	sub    $0x4,%esp
8010185d:	6a 40                	push   $0x40
8010185f:	6a 00                	push   $0x0
80101861:	ff 75 ec             	pushl  -0x14(%ebp)
80101864:	e8 c7 52 00 00       	call   80106b30 <memset>
80101869:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
8010186c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010186f:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101873:	66 89 10             	mov    %dx,(%eax)
      #ifdef CS333_P5
      dip->uid = DEFAULT_UID;
80101876:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101879:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
      dip->gid = DEFAULT_UID;
8010187f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101882:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
      dip->mode.asInt = DEFAULT_MODE;
80101888:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010188b:	c7 40 0c ed 01 00 00 	movl   $0x1ed,0xc(%eax)
      dip->mode.flags.setuid = 0;
80101892:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101895:	0f b6 50 0d          	movzbl 0xd(%eax),%edx
80101899:	83 e2 fd             	and    $0xfffffffd,%edx
8010189c:	88 50 0d             	mov    %dl,0xd(%eax)
      dip->mode.flags.o_x = 1;
8010189f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018a2:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018a6:	83 ca 01             	or     $0x1,%edx
801018a9:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.o_w = 0;
801018ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018af:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018b3:	83 e2 fd             	and    $0xfffffffd,%edx
801018b6:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.o_r = 1;
801018b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018bc:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018c0:	83 ca 04             	or     $0x4,%edx
801018c3:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.g_x = 1;
801018c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018c9:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018cd:	83 ca 08             	or     $0x8,%edx
801018d0:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.g_w = 0;
801018d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018d6:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018da:	83 e2 ef             	and    $0xffffffef,%edx
801018dd:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.g_r = 1;
801018e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018e3:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018e7:	83 ca 20             	or     $0x20,%edx
801018ea:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.u_x = 1;
801018ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018f0:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
801018f4:	83 ca 40             	or     $0x40,%edx
801018f7:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.u_w = 1;
801018fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018fd:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
80101901:	83 ca 80             	or     $0xffffff80,%edx
80101904:	88 50 0c             	mov    %dl,0xc(%eax)
      dip->mode.flags.u_r = 1;
80101907:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010190a:	0f b6 50 0d          	movzbl 0xd(%eax),%edx
8010190e:	83 ca 01             	or     $0x1,%edx
80101911:	88 50 0d             	mov    %dl,0xd(%eax)
      #endif
      log_write(bp);   // mark it allocated on the disk
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	ff 75 f0             	pushl  -0x10(%ebp)
8010191a:	e8 70 23 00 00       	call   80103c8f <log_write>
8010191f:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101922:	83 ec 0c             	sub    $0xc,%esp
80101925:	ff 75 f0             	pushl  -0x10(%ebp)
80101928:	e8 01 e9 ff ff       	call   8010022e <brelse>
8010192d:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101933:	83 ec 08             	sub    $0x8,%esp
80101936:	50                   	push   %eax
80101937:	ff 75 08             	pushl  0x8(%ebp)
8010193a:	e8 7a 02 00 00       	call   80101bb9 <iget>
8010193f:	83 c4 10             	add    $0x10,%esp
80101942:	eb 30                	jmp    80101974 <ialloc+0x177>
    }
    brelse(bp);
80101944:	83 ec 0c             	sub    $0xc,%esp
80101947:	ff 75 f0             	pushl  -0x10(%ebp)
8010194a:	e8 df e8 ff ff       	call   8010022e <brelse>
8010194f:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101952:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101956:	8b 15 68 32 11 80    	mov    0x80113268,%edx
8010195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195f:	39 c2                	cmp    %eax,%edx
80101961:	0f 87 af fe ff ff    	ja     80101816 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101967:	83 ec 0c             	sub    $0xc,%esp
8010196a:	68 0f a3 10 80       	push   $0x8010a30f
8010196f:	e8 f2 eb ff ff       	call   80100566 <panic>
}
80101974:	c9                   	leave  
80101975:	c3                   	ret    

80101976 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101976:	55                   	push   %ebp
80101977:	89 e5                	mov    %esp,%ebp
80101979:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	8b 40 04             	mov    0x4(%eax),%eax
80101982:	c1 e8 03             	shr    $0x3,%eax
80101985:	89 c2                	mov    %eax,%edx
80101987:	a1 74 32 11 80       	mov    0x80113274,%eax
8010198c:	01 c2                	add    %eax,%edx
8010198e:	8b 45 08             	mov    0x8(%ebp),%eax
80101991:	8b 00                	mov    (%eax),%eax
80101993:	83 ec 08             	sub    $0x8,%esp
80101996:	52                   	push   %edx
80101997:	50                   	push   %eax
80101998:	e8 19 e8 ff ff       	call   801001b6 <bread>
8010199d:	83 c4 10             	add    $0x10,%esp
801019a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a6:	8d 50 18             	lea    0x18(%eax),%edx
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 40 04             	mov    0x4(%eax),%eax
801019af:	83 e0 07             	and    $0x7,%eax
801019b2:	c1 e0 06             	shl    $0x6,%eax
801019b5:	01 d0                	add    %edx,%eax
801019b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801019ba:	8b 45 08             	mov    0x8(%ebp),%eax
801019bd:	0f b7 50 18          	movzwl 0x18(%eax),%edx
801019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c4:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
801019ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d1:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801019d5:	8b 45 08             	mov    0x8(%ebp),%eax
801019d8:	0f b7 50 1c          	movzwl 0x1c(%eax),%edx
801019dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019df:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801019e3:	8b 45 08             	mov    0x8(%ebp),%eax
801019e6:	0f b7 50 1e          	movzwl 0x1e(%eax),%edx
801019ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ed:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801019f1:	8b 45 08             	mov    0x8(%ebp),%eax
801019f4:	8b 50 20             	mov    0x20(%eax),%edx
801019f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019fa:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P5
  dip->uid = ip->uid;
801019fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101a00:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a07:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
80101a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0e:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a15:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 50 14             	mov    0x14(%eax),%edx
80101a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a22:	89 50 0c             	mov    %edx,0xc(%eax)
  dip->mode.flags.setuid = ip->mode.flags.setuid;
80101a25:	8b 45 08             	mov    0x8(%ebp),%eax
80101a28:	0f b6 40 15          	movzbl 0x15(%eax),%eax
80101a2c:	d0 e8                	shr    %al
80101a2e:	83 e0 01             	and    $0x1,%eax
80101a31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a34:	83 e0 01             	and    $0x1,%eax
80101a37:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
80101a3a:	0f b6 42 0d          	movzbl 0xd(%edx),%eax
80101a3e:	83 e0 fd             	and    $0xfffffffd,%eax
80101a41:	09 c8                	or     %ecx,%eax
80101a43:	88 42 0d             	mov    %al,0xd(%edx)
  dip->mode.flags.o_x = ip->mode.flags.o_x;
80101a46:	8b 45 08             	mov    0x8(%ebp),%eax
80101a49:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101a4d:	83 e0 01             	and    $0x1,%eax
80101a50:	89 c2                	mov    %eax,%edx
80101a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a55:	89 d1                	mov    %edx,%ecx
80101a57:	83 e1 01             	and    $0x1,%ecx
80101a5a:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
80101a5e:	83 e2 fe             	and    $0xfffffffe,%edx
80101a61:	09 ca                	or     %ecx,%edx
80101a63:	88 50 0c             	mov    %dl,0xc(%eax)
  dip->mode.flags.o_w = ip->mode.flags.o_w;
80101a66:	8b 45 08             	mov    0x8(%ebp),%eax
80101a69:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101a6d:	d0 e8                	shr    %al
80101a6f:	83 e0 01             	and    $0x1,%eax
80101a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a75:	83 e0 01             	and    $0x1,%eax
80101a78:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
80101a7b:	0f b6 42 0c          	movzbl 0xc(%edx),%eax
80101a7f:	83 e0 fd             	and    $0xfffffffd,%eax
80101a82:	09 c8                	or     %ecx,%eax
80101a84:	88 42 0c             	mov    %al,0xc(%edx)
  dip->mode.flags.o_r = ip->mode.flags.o_r;
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101a8e:	c0 e8 02             	shr    $0x2,%al
80101a91:	83 e0 01             	and    $0x1,%eax
80101a94:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101a97:	83 e0 01             	and    $0x1,%eax
80101a9a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80101aa1:	0f b6 42 0c          	movzbl 0xc(%edx),%eax
80101aa5:	83 e0 fb             	and    $0xfffffffb,%eax
80101aa8:	09 c8                	or     %ecx,%eax
80101aaa:	88 42 0c             	mov    %al,0xc(%edx)
  dip->mode.flags.g_x = ip->mode.flags.g_x;
80101aad:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab0:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101ab4:	c0 e8 03             	shr    $0x3,%al
80101ab7:	83 e0 01             	and    $0x1,%eax
80101aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101abd:	83 e0 01             	and    $0x1,%eax
80101ac0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80101ac7:	0f b6 42 0c          	movzbl 0xc(%edx),%eax
80101acb:	83 e0 f7             	and    $0xfffffff7,%eax
80101ace:	09 c8                	or     %ecx,%eax
80101ad0:	88 42 0c             	mov    %al,0xc(%edx)
  dip->mode.flags.g_w = ip->mode.flags.g_w;
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101ada:	c0 e8 04             	shr    $0x4,%al
80101add:	83 e0 01             	and    $0x1,%eax
80101ae0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101ae3:	83 e0 01             	and    $0x1,%eax
80101ae6:	c1 e0 04             	shl    $0x4,%eax
80101ae9:	89 c1                	mov    %eax,%ecx
80101aeb:	0f b6 42 0c          	movzbl 0xc(%edx),%eax
80101aef:	83 e0 ef             	and    $0xffffffef,%eax
80101af2:	09 c8                	or     %ecx,%eax
80101af4:	88 42 0c             	mov    %al,0xc(%edx)
  dip->mode.flags.g_r = ip->mode.flags.g_r;
80101af7:	8b 45 08             	mov    0x8(%ebp),%eax
80101afa:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101afe:	c0 e8 05             	shr    $0x5,%al
80101b01:	83 e0 01             	and    $0x1,%eax
80101b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101b07:	83 e0 01             	and    $0x1,%eax
80101b0a:	c1 e0 05             	shl    $0x5,%eax
80101b0d:	89 c1                	mov    %eax,%ecx
80101b0f:	0f b6 42 0c          	movzbl 0xc(%edx),%eax
80101b13:	83 e0 df             	and    $0xffffffdf,%eax
80101b16:	09 c8                	or     %ecx,%eax
80101b18:	88 42 0c             	mov    %al,0xc(%edx)
  dip->mode.flags.u_x = ip->mode.flags.u_x;
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101b22:	c0 e8 06             	shr    $0x6,%al
80101b25:	83 e0 01             	and    $0x1,%eax
80101b28:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101b2b:	83 e0 01             	and    $0x1,%eax
80101b2e:	c1 e0 06             	shl    $0x6,%eax
80101b31:	89 c1                	mov    %eax,%ecx
80101b33:	0f b6 42 0c          	movzbl 0xc(%edx),%eax
80101b37:	83 e0 bf             	and    $0xffffffbf,%eax
80101b3a:	09 c8                	or     %ecx,%eax
80101b3c:	88 42 0c             	mov    %al,0xc(%edx)
  dip->mode.flags.u_w = ip->mode.flags.u_w;
80101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b42:	0f b6 40 14          	movzbl 0x14(%eax),%eax
80101b46:	c0 e8 07             	shr    $0x7,%al
80101b49:	89 c2                	mov    %eax,%edx
80101b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b4e:	89 d1                	mov    %edx,%ecx
80101b50:	c1 e1 07             	shl    $0x7,%ecx
80101b53:	0f b6 50 0c          	movzbl 0xc(%eax),%edx
80101b57:	83 e2 7f             	and    $0x7f,%edx
80101b5a:	09 ca                	or     %ecx,%edx
80101b5c:	88 50 0c             	mov    %dl,0xc(%eax)
  dip->mode.flags.u_r = ip->mode.flags.u_r;
80101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b62:	0f b6 40 15          	movzbl 0x15(%eax),%eax
80101b66:	83 e0 01             	and    $0x1,%eax
80101b69:	89 c2                	mov    %eax,%edx
80101b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b6e:	89 d1                	mov    %edx,%ecx
80101b70:	83 e1 01             	and    $0x1,%ecx
80101b73:	0f b6 50 0d          	movzbl 0xd(%eax),%edx
80101b77:	83 e2 fe             	and    $0xfffffffe,%edx
80101b7a:	09 ca                	or     %ecx,%edx
80101b7c:	88 50 0d             	mov    %dl,0xd(%eax)
  #endif
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b82:	8d 50 24             	lea    0x24(%eax),%edx
80101b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b88:	83 c0 14             	add    $0x14,%eax
80101b8b:	83 ec 04             	sub    $0x4,%esp
80101b8e:	6a 2c                	push   $0x2c
80101b90:	52                   	push   %edx
80101b91:	50                   	push   %eax
80101b92:	e8 58 50 00 00       	call   80106bef <memmove>
80101b97:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	ff 75 f4             	pushl  -0xc(%ebp)
80101ba0:	e8 ea 20 00 00       	call   80103c8f <log_write>
80101ba5:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101ba8:	83 ec 0c             	sub    $0xc,%esp
80101bab:	ff 75 f4             	pushl  -0xc(%ebp)
80101bae:	e8 7b e6 ff ff       	call   8010022e <brelse>
80101bb3:	83 c4 10             	add    $0x10,%esp
}
80101bb6:	90                   	nop
80101bb7:	c9                   	leave  
80101bb8:	c3                   	ret    

80101bb9 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101bb9:	55                   	push   %ebp
80101bba:	89 e5                	mov    %esp,%ebp
80101bbc:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	68 80 32 11 80       	push   $0x80113280
80101bc7:	e8 01 4d 00 00       	call   801068cd <acquire>
80101bcc:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101bcf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bd6:	c7 45 f4 b4 32 11 80 	movl   $0x801132b4,-0xc(%ebp)
80101bdd:	eb 5d                	jmp    80101c3c <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be2:	8b 40 08             	mov    0x8(%eax),%eax
80101be5:	85 c0                	test   %eax,%eax
80101be7:	7e 39                	jle    80101c22 <iget+0x69>
80101be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bec:	8b 00                	mov    (%eax),%eax
80101bee:	3b 45 08             	cmp    0x8(%ebp),%eax
80101bf1:	75 2f                	jne    80101c22 <iget+0x69>
80101bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf6:	8b 40 04             	mov    0x4(%eax),%eax
80101bf9:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101bfc:	75 24                	jne    80101c22 <iget+0x69>
      ip->ref++;
80101bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c01:	8b 40 08             	mov    0x8(%eax),%eax
80101c04:	8d 50 01             	lea    0x1(%eax),%edx
80101c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c0a:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101c0d:	83 ec 0c             	sub    $0xc,%esp
80101c10:	68 80 32 11 80       	push   $0x80113280
80101c15:	e8 1a 4d 00 00       	call   80106934 <release>
80101c1a:	83 c4 10             	add    $0x10,%esp
      return ip;
80101c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c20:	eb 74                	jmp    80101c96 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101c22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101c26:	75 10                	jne    80101c38 <iget+0x7f>
80101c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2b:	8b 40 08             	mov    0x8(%eax),%eax
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 06                	jne    80101c38 <iget+0x7f>
      empty = ip;
80101c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c35:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c38:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101c3c:	81 7d f4 54 42 11 80 	cmpl   $0x80114254,-0xc(%ebp)
80101c43:	72 9a                	jb     80101bdf <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101c45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101c49:	75 0d                	jne    80101c58 <iget+0x9f>
    panic("iget: no inodes");
80101c4b:	83 ec 0c             	sub    $0xc,%esp
80101c4e:	68 21 a3 10 80       	push   $0x8010a321
80101c53:	e8 0e e9 ff ff       	call   80100566 <panic>

  ip = empty;
80101c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c61:	8b 55 08             	mov    0x8(%ebp),%edx
80101c64:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c69:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c6c:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c72:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101c83:	83 ec 0c             	sub    $0xc,%esp
80101c86:	68 80 32 11 80       	push   $0x80113280
80101c8b:	e8 a4 4c 00 00       	call   80106934 <release>
80101c90:	83 c4 10             	add    $0x10,%esp

  return ip;
80101c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101c96:	c9                   	leave  
80101c97:	c3                   	ret    

80101c98 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101c98:	55                   	push   %ebp
80101c99:	89 e5                	mov    %esp,%ebp
80101c9b:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101c9e:	83 ec 0c             	sub    $0xc,%esp
80101ca1:	68 80 32 11 80       	push   $0x80113280
80101ca6:	e8 22 4c 00 00       	call   801068cd <acquire>
80101cab:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 40 08             	mov    0x8(%eax),%eax
80101cb4:	8d 50 01             	lea    0x1(%eax),%edx
80101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cba:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cbd:	83 ec 0c             	sub    $0xc,%esp
80101cc0:	68 80 32 11 80       	push   $0x80113280
80101cc5:	e8 6a 4c 00 00       	call   80106934 <release>
80101cca:	83 c4 10             	add    $0x10,%esp
  return ip;
80101ccd:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101cd0:	c9                   	leave  
80101cd1:	c3                   	ret    

80101cd2 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101cd2:	55                   	push   %ebp
80101cd3:	89 e5                	mov    %esp,%ebp
80101cd5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101cd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101cdc:	74 0a                	je     80101ce8 <ilock+0x16>
80101cde:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce1:	8b 40 08             	mov    0x8(%eax),%eax
80101ce4:	85 c0                	test   %eax,%eax
80101ce6:	7f 0d                	jg     80101cf5 <ilock+0x23>
    panic("ilock");
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	68 31 a3 10 80       	push   $0x8010a331
80101cf0:	e8 71 e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101cf5:	83 ec 0c             	sub    $0xc,%esp
80101cf8:	68 80 32 11 80       	push   $0x80113280
80101cfd:	e8 cb 4b 00 00       	call   801068cd <acquire>
80101d02:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101d05:	eb 13                	jmp    80101d1a <ilock+0x48>
    sleep(ip, &icache.lock);
80101d07:	83 ec 08             	sub    $0x8,%esp
80101d0a:	68 80 32 11 80       	push   $0x80113280
80101d0f:	ff 75 08             	pushl  0x8(%ebp)
80101d12:	e8 13 3f 00 00       	call   80105c2a <sleep>
80101d17:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1d:	8b 40 0c             	mov    0xc(%eax),%eax
80101d20:	83 e0 01             	and    $0x1,%eax
80101d23:	85 c0                	test   %eax,%eax
80101d25:	75 e0                	jne    80101d07 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	8b 40 0c             	mov    0xc(%eax),%eax
80101d2d:	83 c8 01             	or     $0x1,%eax
80101d30:	89 c2                	mov    %eax,%edx
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	68 80 32 11 80       	push   $0x80113280
80101d40:	e8 ef 4b 00 00       	call   80106934 <release>
80101d45:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 40 0c             	mov    0xc(%eax),%eax
80101d4e:	83 e0 02             	and    $0x2,%eax
80101d51:	85 c0                	test   %eax,%eax
80101d53:	0f 85 4a 02 00 00    	jne    80101fa3 <ilock+0x2d1>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d59:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5c:	8b 40 04             	mov    0x4(%eax),%eax
80101d5f:	c1 e8 03             	shr    $0x3,%eax
80101d62:	89 c2                	mov    %eax,%edx
80101d64:	a1 74 32 11 80       	mov    0x80113274,%eax
80101d69:	01 c2                	add    %eax,%edx
80101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6e:	8b 00                	mov    (%eax),%eax
80101d70:	83 ec 08             	sub    $0x8,%esp
80101d73:	52                   	push   %edx
80101d74:	50                   	push   %eax
80101d75:	e8 3c e4 ff ff       	call   801001b6 <bread>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d83:	8d 50 18             	lea    0x18(%eax),%edx
80101d86:	8b 45 08             	mov    0x8(%ebp),%eax
80101d89:	8b 40 04             	mov    0x4(%eax),%eax
80101d8c:	83 e0 07             	and    $0x7,%eax
80101d8f:	c1 e0 06             	shl    $0x6,%eax
80101d92:	01 d0                	add    %edx,%eax
80101d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d9a:	0f b7 10             	movzwl (%eax),%edx
80101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101da0:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->major = dip->major;
80101da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da7:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101dab:	8b 45 08             	mov    0x8(%ebp),%eax
80101dae:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->minor = dip->minor;
80101db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db5:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101db9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbc:	66 89 50 1c          	mov    %dx,0x1c(%eax)
    ip->nlink = dip->nlink;
80101dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dc3:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dca:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    ip->size = dip->size;
80101dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd1:	8b 50 10             	mov    0x10(%eax),%edx
80101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd7:	89 50 20             	mov    %edx,0x20(%eax)
    #ifdef CS333_P5
    ip->uid = dip->uid;
80101dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ddd:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101de1:	8b 45 08             	mov    0x8(%ebp),%eax
80101de4:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->gid = dip->gid;
80101de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101deb:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->mode.flags.setuid = dip->mode.flags.setuid;
80101df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df9:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80101dfd:	d0 e8                	shr    %al
80101dff:	83 e0 01             	and    $0x1,%eax
80101e02:	8b 55 08             	mov    0x8(%ebp),%edx
80101e05:	83 e0 01             	and    $0x1,%eax
80101e08:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
80101e0b:	0f b6 42 15          	movzbl 0x15(%edx),%eax
80101e0f:	83 e0 fd             	and    $0xfffffffd,%eax
80101e12:	09 c8                	or     %ecx,%eax
80101e14:	88 42 15             	mov    %al,0x15(%edx)
    ip->mode.flags.o_x = dip->mode.flags.o_x;
80101e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101e1e:	83 e0 01             	and    $0x1,%eax
80101e21:	89 c2                	mov    %eax,%edx
80101e23:	8b 45 08             	mov    0x8(%ebp),%eax
80101e26:	89 d1                	mov    %edx,%ecx
80101e28:	83 e1 01             	and    $0x1,%ecx
80101e2b:	0f b6 50 14          	movzbl 0x14(%eax),%edx
80101e2f:	83 e2 fe             	and    $0xfffffffe,%edx
80101e32:	09 ca                	or     %ecx,%edx
80101e34:	88 50 14             	mov    %dl,0x14(%eax)
    ip->mode.flags.o_w = dip->mode.flags.o_w;
80101e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e3a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101e3e:	d0 e8                	shr    %al
80101e40:	83 e0 01             	and    $0x1,%eax
80101e43:	8b 55 08             	mov    0x8(%ebp),%edx
80101e46:	83 e0 01             	and    $0x1,%eax
80101e49:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
80101e4c:	0f b6 42 14          	movzbl 0x14(%edx),%eax
80101e50:	83 e0 fd             	and    $0xfffffffd,%eax
80101e53:	09 c8                	or     %ecx,%eax
80101e55:	88 42 14             	mov    %al,0x14(%edx)
    ip->mode.flags.o_r = dip->mode.flags.o_r;
80101e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e5b:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101e5f:	c0 e8 02             	shr    $0x2,%al
80101e62:	83 e0 01             	and    $0x1,%eax
80101e65:	8b 55 08             	mov    0x8(%ebp),%edx
80101e68:	83 e0 01             	and    $0x1,%eax
80101e6b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80101e72:	0f b6 42 14          	movzbl 0x14(%edx),%eax
80101e76:	83 e0 fb             	and    $0xfffffffb,%eax
80101e79:	09 c8                	or     %ecx,%eax
80101e7b:	88 42 14             	mov    %al,0x14(%edx)
    ip->mode.flags.g_x = dip->mode.flags.g_x;
80101e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e81:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101e85:	c0 e8 03             	shr    $0x3,%al
80101e88:	83 e0 01             	and    $0x1,%eax
80101e8b:	8b 55 08             	mov    0x8(%ebp),%edx
80101e8e:	83 e0 01             	and    $0x1,%eax
80101e91:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80101e98:	0f b6 42 14          	movzbl 0x14(%edx),%eax
80101e9c:	83 e0 f7             	and    $0xfffffff7,%eax
80101e9f:	09 c8                	or     %ecx,%eax
80101ea1:	88 42 14             	mov    %al,0x14(%edx)
    ip->mode.flags.g_w = dip->mode.flags.g_w;
80101ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea7:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101eab:	c0 e8 04             	shr    $0x4,%al
80101eae:	83 e0 01             	and    $0x1,%eax
80101eb1:	8b 55 08             	mov    0x8(%ebp),%edx
80101eb4:	83 e0 01             	and    $0x1,%eax
80101eb7:	c1 e0 04             	shl    $0x4,%eax
80101eba:	89 c1                	mov    %eax,%ecx
80101ebc:	0f b6 42 14          	movzbl 0x14(%edx),%eax
80101ec0:	83 e0 ef             	and    $0xffffffef,%eax
80101ec3:	09 c8                	or     %ecx,%eax
80101ec5:	88 42 14             	mov    %al,0x14(%edx)
    ip->mode.flags.g_r = dip->mode.flags.g_r;
80101ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ecb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101ecf:	c0 e8 05             	shr    $0x5,%al
80101ed2:	83 e0 01             	and    $0x1,%eax
80101ed5:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed8:	83 e0 01             	and    $0x1,%eax
80101edb:	c1 e0 05             	shl    $0x5,%eax
80101ede:	89 c1                	mov    %eax,%ecx
80101ee0:	0f b6 42 14          	movzbl 0x14(%edx),%eax
80101ee4:	83 e0 df             	and    $0xffffffdf,%eax
80101ee7:	09 c8                	or     %ecx,%eax
80101ee9:	88 42 14             	mov    %al,0x14(%edx)
    ip->mode.flags.u_x = dip->mode.flags.u_x;
80101eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eef:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101ef3:	c0 e8 06             	shr    $0x6,%al
80101ef6:	83 e0 01             	and    $0x1,%eax
80101ef9:	8b 55 08             	mov    0x8(%ebp),%edx
80101efc:	83 e0 01             	and    $0x1,%eax
80101eff:	c1 e0 06             	shl    $0x6,%eax
80101f02:	89 c1                	mov    %eax,%ecx
80101f04:	0f b6 42 14          	movzbl 0x14(%edx),%eax
80101f08:	83 e0 bf             	and    $0xffffffbf,%eax
80101f0b:	09 c8                	or     %ecx,%eax
80101f0d:	88 42 14             	mov    %al,0x14(%edx)
    ip->mode.flags.u_w = dip->mode.flags.u_w;
80101f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f13:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80101f17:	c0 e8 07             	shr    $0x7,%al
80101f1a:	89 c2                	mov    %eax,%edx
80101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1f:	89 d1                	mov    %edx,%ecx
80101f21:	c1 e1 07             	shl    $0x7,%ecx
80101f24:	0f b6 50 14          	movzbl 0x14(%eax),%edx
80101f28:	83 e2 7f             	and    $0x7f,%edx
80101f2b:	09 ca                	or     %ecx,%edx
80101f2d:	88 50 14             	mov    %dl,0x14(%eax)
    ip->mode.flags.u_r = dip->mode.flags.u_r;
80101f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f33:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80101f37:	83 e0 01             	and    $0x1,%eax
80101f3a:	89 c2                	mov    %eax,%edx
80101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3f:	89 d1                	mov    %edx,%ecx
80101f41:	83 e1 01             	and    $0x1,%ecx
80101f44:	0f b6 50 15          	movzbl 0x15(%eax),%edx
80101f48:	83 e2 fe             	and    $0xfffffffe,%edx
80101f4b:	09 ca                	or     %ecx,%edx
80101f4d:	88 50 15             	mov    %dl,0x15(%eax)
    #endif
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f53:	8d 50 14             	lea    0x14(%eax),%edx
80101f56:	8b 45 08             	mov    0x8(%ebp),%eax
80101f59:	83 c0 24             	add    $0x24,%eax
80101f5c:	83 ec 04             	sub    $0x4,%esp
80101f5f:	6a 2c                	push   $0x2c
80101f61:	52                   	push   %edx
80101f62:	50                   	push   %eax
80101f63:	e8 87 4c 00 00       	call   80106bef <memmove>
80101f68:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f6b:	83 ec 0c             	sub    $0xc,%esp
80101f6e:	ff 75 f4             	pushl  -0xc(%ebp)
80101f71:	e8 b8 e2 ff ff       	call   8010022e <brelse>
80101f76:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	8b 40 0c             	mov    0xc(%eax),%eax
80101f7f:	83 c8 02             	or     $0x2,%eax
80101f82:	89 c2                	mov    %eax,%edx
80101f84:	8b 45 08             	mov    0x8(%ebp),%eax
80101f87:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8d:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80101f91:	66 85 c0             	test   %ax,%ax
80101f94:	75 0d                	jne    80101fa3 <ilock+0x2d1>
      panic("ilock: no type");
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	68 37 a3 10 80       	push   $0x8010a337
80101f9e:	e8 c3 e5 ff ff       	call   80100566 <panic>
  }
}
80101fa3:	90                   	nop
80101fa4:	c9                   	leave  
80101fa5:	c3                   	ret    

80101fa6 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101fa6:	55                   	push   %ebp
80101fa7:	89 e5                	mov    %esp,%ebp
80101fa9:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101fac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101fb0:	74 17                	je     80101fc9 <iunlock+0x23>
80101fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb5:	8b 40 0c             	mov    0xc(%eax),%eax
80101fb8:	83 e0 01             	and    $0x1,%eax
80101fbb:	85 c0                	test   %eax,%eax
80101fbd:	74 0a                	je     80101fc9 <iunlock+0x23>
80101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc2:	8b 40 08             	mov    0x8(%eax),%eax
80101fc5:	85 c0                	test   %eax,%eax
80101fc7:	7f 0d                	jg     80101fd6 <iunlock+0x30>
    panic("iunlock");
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	68 46 a3 10 80       	push   $0x8010a346
80101fd1:	e8 90 e5 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101fd6:	83 ec 0c             	sub    $0xc,%esp
80101fd9:	68 80 32 11 80       	push   $0x80113280
80101fde:	e8 ea 48 00 00       	call   801068cd <acquire>
80101fe3:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe9:	8b 40 0c             	mov    0xc(%eax),%eax
80101fec:	83 e0 fe             	and    $0xfffffffe,%eax
80101fef:	89 c2                	mov    %eax,%edx
80101ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff4:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101ff7:	83 ec 0c             	sub    $0xc,%esp
80101ffa:	ff 75 08             	pushl  0x8(%ebp)
80101ffd:	e8 00 3e 00 00       	call   80105e02 <wakeup>
80102002:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	68 80 32 11 80       	push   $0x80113280
8010200d:	e8 22 49 00 00       	call   80106934 <release>
80102012:	83 c4 10             	add    $0x10,%esp
}
80102015:	90                   	nop
80102016:	c9                   	leave  
80102017:	c3                   	ret    

80102018 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80102018:	55                   	push   %ebp
80102019:	89 e5                	mov    %esp,%ebp
8010201b:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	68 80 32 11 80       	push   $0x80113280
80102026:	e8 a2 48 00 00       	call   801068cd <acquire>
8010202b:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
8010202e:	8b 45 08             	mov    0x8(%ebp),%eax
80102031:	8b 40 08             	mov    0x8(%eax),%eax
80102034:	83 f8 01             	cmp    $0x1,%eax
80102037:	0f 85 a9 00 00 00    	jne    801020e6 <iput+0xce>
8010203d:	8b 45 08             	mov    0x8(%ebp),%eax
80102040:	8b 40 0c             	mov    0xc(%eax),%eax
80102043:	83 e0 02             	and    $0x2,%eax
80102046:	85 c0                	test   %eax,%eax
80102048:	0f 84 98 00 00 00    	je     801020e6 <iput+0xce>
8010204e:	8b 45 08             	mov    0x8(%ebp),%eax
80102051:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
80102055:	66 85 c0             	test   %ax,%ax
80102058:	0f 85 88 00 00 00    	jne    801020e6 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
8010205e:	8b 45 08             	mov    0x8(%ebp),%eax
80102061:	8b 40 0c             	mov    0xc(%eax),%eax
80102064:	83 e0 01             	and    $0x1,%eax
80102067:	85 c0                	test   %eax,%eax
80102069:	74 0d                	je     80102078 <iput+0x60>
      panic("iput busy");
8010206b:	83 ec 0c             	sub    $0xc,%esp
8010206e:	68 4e a3 10 80       	push   $0x8010a34e
80102073:	e8 ee e4 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80102078:	8b 45 08             	mov    0x8(%ebp),%eax
8010207b:	8b 40 0c             	mov    0xc(%eax),%eax
8010207e:	83 c8 01             	or     $0x1,%eax
80102081:	89 c2                	mov    %eax,%edx
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80102089:	83 ec 0c             	sub    $0xc,%esp
8010208c:	68 80 32 11 80       	push   $0x80113280
80102091:	e8 9e 48 00 00       	call   80106934 <release>
80102096:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80102099:	83 ec 0c             	sub    $0xc,%esp
8010209c:	ff 75 08             	pushl  0x8(%ebp)
8010209f:	e8 a8 01 00 00       	call   8010224c <itrunc>
801020a4:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
801020a7:	8b 45 08             	mov    0x8(%ebp),%eax
801020aa:	66 c7 40 18 00 00    	movw   $0x0,0x18(%eax)
    iupdate(ip);
801020b0:	83 ec 0c             	sub    $0xc,%esp
801020b3:	ff 75 08             	pushl  0x8(%ebp)
801020b6:	e8 bb f8 ff ff       	call   80101976 <iupdate>
801020bb:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
801020be:	83 ec 0c             	sub    $0xc,%esp
801020c1:	68 80 32 11 80       	push   $0x80113280
801020c6:	e8 02 48 00 00       	call   801068cd <acquire>
801020cb:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
801020ce:	8b 45 08             	mov    0x8(%ebp),%eax
801020d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	ff 75 08             	pushl  0x8(%ebp)
801020de:	e8 1f 3d 00 00       	call   80105e02 <wakeup>
801020e3:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
801020e6:	8b 45 08             	mov    0x8(%ebp),%eax
801020e9:	8b 40 08             	mov    0x8(%eax),%eax
801020ec:	8d 50 ff             	lea    -0x1(%eax),%edx
801020ef:	8b 45 08             	mov    0x8(%ebp),%eax
801020f2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	68 80 32 11 80       	push   $0x80113280
801020fd:	e8 32 48 00 00       	call   80106934 <release>
80102102:	83 c4 10             	add    $0x10,%esp
}
80102105:	90                   	nop
80102106:	c9                   	leave  
80102107:	c3                   	ret    

80102108 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80102108:	55                   	push   %ebp
80102109:	89 e5                	mov    %esp,%ebp
8010210b:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
8010210e:	83 ec 0c             	sub    $0xc,%esp
80102111:	ff 75 08             	pushl  0x8(%ebp)
80102114:	e8 8d fe ff ff       	call   80101fa6 <iunlock>
80102119:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010211c:	83 ec 0c             	sub    $0xc,%esp
8010211f:	ff 75 08             	pushl  0x8(%ebp)
80102122:	e8 f1 fe ff ff       	call   80102018 <iput>
80102127:	83 c4 10             	add    $0x10,%esp
}
8010212a:	90                   	nop
8010212b:	c9                   	leave  
8010212c:	c3                   	ret    

8010212d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8010212d:	55                   	push   %ebp
8010212e:	89 e5                	mov    %esp,%ebp
80102130:	53                   	push   %ebx
80102131:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80102134:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80102138:	77 42                	ja     8010217c <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
8010213a:	8b 45 08             	mov    0x8(%ebp),%eax
8010213d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102140:	83 c2 08             	add    $0x8,%edx
80102143:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102147:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010214a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010214e:	75 24                	jne    80102174 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	8b 00                	mov    (%eax),%eax
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	50                   	push   %eax
80102159:	e8 00 f4 ff ff       	call   8010155e <balloc>
8010215e:	83 c4 10             	add    $0x10,%esp
80102161:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102164:	8b 45 08             	mov    0x8(%ebp),%eax
80102167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010216a:	8d 4a 08             	lea    0x8(%edx),%ecx
8010216d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102170:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80102174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102177:	e9 cb 00 00 00       	jmp    80102247 <bmap+0x11a>
  }
  bn -= NDIRECT;
8010217c:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80102180:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80102184:	0f 87 b0 00 00 00    	ja     8010223a <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010218a:	8b 45 08             	mov    0x8(%ebp),%eax
8010218d:	8b 40 4c             	mov    0x4c(%eax),%eax
80102190:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102197:	75 1d                	jne    801021b6 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80102199:	8b 45 08             	mov    0x8(%ebp),%eax
8010219c:	8b 00                	mov    (%eax),%eax
8010219e:	83 ec 0c             	sub    $0xc,%esp
801021a1:	50                   	push   %eax
801021a2:	e8 b7 f3 ff ff       	call   8010155e <balloc>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021ad:	8b 45 08             	mov    0x8(%ebp),%eax
801021b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021b3:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
801021b6:	8b 45 08             	mov    0x8(%ebp),%eax
801021b9:	8b 00                	mov    (%eax),%eax
801021bb:	83 ec 08             	sub    $0x8,%esp
801021be:	ff 75 f4             	pushl  -0xc(%ebp)
801021c1:	50                   	push   %eax
801021c2:	e8 ef df ff ff       	call   801001b6 <bread>
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
801021cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021d0:	83 c0 18             	add    $0x18,%eax
801021d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
801021d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801021d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021e3:	01 d0                	add    %edx,%eax
801021e5:	8b 00                	mov    (%eax),%eax
801021e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801021ee:	75 37                	jne    80102227 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
801021f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801021f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801021fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021fd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80102200:	8b 45 08             	mov    0x8(%ebp),%eax
80102203:	8b 00                	mov    (%eax),%eax
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	50                   	push   %eax
80102209:	e8 50 f3 ff ff       	call   8010155e <balloc>
8010220e:	83 c4 10             	add    $0x10,%esp
80102211:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102217:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80102219:	83 ec 0c             	sub    $0xc,%esp
8010221c:	ff 75 f0             	pushl  -0x10(%ebp)
8010221f:	e8 6b 1a 00 00       	call   80103c8f <log_write>
80102224:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	ff 75 f0             	pushl  -0x10(%ebp)
8010222d:	e8 fc df ff ff       	call   8010022e <brelse>
80102232:	83 c4 10             	add    $0x10,%esp
    return addr;
80102235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102238:	eb 0d                	jmp    80102247 <bmap+0x11a>
  }

  panic("bmap: out of range");
8010223a:	83 ec 0c             	sub    $0xc,%esp
8010223d:	68 58 a3 10 80       	push   $0x8010a358
80102242:	e8 1f e3 ff ff       	call   80100566 <panic>
}
80102247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010224a:	c9                   	leave  
8010224b:	c3                   	ret    

8010224c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
8010224c:	55                   	push   %ebp
8010224d:	89 e5                	mov    %esp,%ebp
8010224f:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102259:	eb 45                	jmp    801022a0 <itrunc+0x54>
    if(ip->addrs[i]){
8010225b:	8b 45 08             	mov    0x8(%ebp),%eax
8010225e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102261:	83 c2 08             	add    $0x8,%edx
80102264:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102268:	85 c0                	test   %eax,%eax
8010226a:	74 30                	je     8010229c <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
8010226c:	8b 45 08             	mov    0x8(%ebp),%eax
8010226f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102272:	83 c2 08             	add    $0x8,%edx
80102275:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102279:	8b 55 08             	mov    0x8(%ebp),%edx
8010227c:	8b 12                	mov    (%edx),%edx
8010227e:	83 ec 08             	sub    $0x8,%esp
80102281:	50                   	push   %eax
80102282:	52                   	push   %edx
80102283:	e8 22 f4 ff ff       	call   801016aa <bfree>
80102288:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
8010228b:	8b 45 08             	mov    0x8(%ebp),%eax
8010228e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102291:	83 c2 08             	add    $0x8,%edx
80102294:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
8010229b:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010229c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801022a0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801022a4:	7e b5                	jle    8010225b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
801022a6:	8b 45 08             	mov    0x8(%ebp),%eax
801022a9:	8b 40 4c             	mov    0x4c(%eax),%eax
801022ac:	85 c0                	test   %eax,%eax
801022ae:	0f 84 a1 00 00 00    	je     80102355 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801022b4:	8b 45 08             	mov    0x8(%ebp),%eax
801022b7:	8b 50 4c             	mov    0x4c(%eax),%edx
801022ba:	8b 45 08             	mov    0x8(%ebp),%eax
801022bd:	8b 00                	mov    (%eax),%eax
801022bf:	83 ec 08             	sub    $0x8,%esp
801022c2:	52                   	push   %edx
801022c3:	50                   	push   %eax
801022c4:	e8 ed de ff ff       	call   801001b6 <bread>
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
801022cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022d2:	83 c0 18             	add    $0x18,%eax
801022d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801022d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801022df:	eb 3c                	jmp    8010231d <itrunc+0xd1>
      if(a[j])
801022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801022eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801022ee:	01 d0                	add    %edx,%eax
801022f0:	8b 00                	mov    (%eax),%eax
801022f2:	85 c0                	test   %eax,%eax
801022f4:	74 23                	je     80102319 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
801022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102300:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102303:	01 d0                	add    %edx,%eax
80102305:	8b 00                	mov    (%eax),%eax
80102307:	8b 55 08             	mov    0x8(%ebp),%edx
8010230a:	8b 12                	mov    (%edx),%edx
8010230c:	83 ec 08             	sub    $0x8,%esp
8010230f:	50                   	push   %eax
80102310:	52                   	push   %edx
80102311:	e8 94 f3 ff ff       	call   801016aa <bfree>
80102316:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80102319:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102320:	83 f8 7f             	cmp    $0x7f,%eax
80102323:	76 bc                	jbe    801022e1 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80102325:	83 ec 0c             	sub    $0xc,%esp
80102328:	ff 75 ec             	pushl  -0x14(%ebp)
8010232b:	e8 fe de ff ff       	call   8010022e <brelse>
80102330:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102333:	8b 45 08             	mov    0x8(%ebp),%eax
80102336:	8b 40 4c             	mov    0x4c(%eax),%eax
80102339:	8b 55 08             	mov    0x8(%ebp),%edx
8010233c:	8b 12                	mov    (%edx),%edx
8010233e:	83 ec 08             	sub    $0x8,%esp
80102341:	50                   	push   %eax
80102342:	52                   	push   %edx
80102343:	e8 62 f3 ff ff       	call   801016aa <bfree>
80102348:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
8010234b:	8b 45 08             	mov    0x8(%ebp),%eax
8010234e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
80102358:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
8010235f:	83 ec 0c             	sub    $0xc,%esp
80102362:	ff 75 08             	pushl  0x8(%ebp)
80102365:	e8 0c f6 ff ff       	call   80101976 <iupdate>
8010236a:	83 c4 10             	add    $0x10,%esp
}
8010236d:	90                   	nop
8010236e:	c9                   	leave  
8010236f:	c3                   	ret    

80102370 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102373:	8b 45 08             	mov    0x8(%ebp),%eax
80102376:	8b 00                	mov    (%eax),%eax
80102378:	89 c2                	mov    %eax,%edx
8010237a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010237d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102380:	8b 45 08             	mov    0x8(%ebp),%eax
80102383:	8b 50 04             	mov    0x4(%eax),%edx
80102386:	8b 45 0c             	mov    0xc(%ebp),%eax
80102389:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010238c:	8b 45 08             	mov    0x8(%ebp),%eax
8010238f:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80102393:	8b 45 0c             	mov    0xc(%ebp),%eax
80102396:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	0f b7 50 1e          	movzwl 0x1e(%eax),%edx
801023a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801023a3:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
801023a7:	8b 45 08             	mov    0x8(%ebp),%eax
801023aa:	8b 50 20             	mov    0x20(%eax),%edx
801023ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801023b0:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P5
  st->uid = ip->uid;
801023b3:	8b 45 08             	mov    0x8(%ebp),%eax
801023b6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023ba:	0f b7 d0             	movzwl %ax,%edx
801023bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801023c0:	89 50 14             	mov    %edx,0x14(%eax)
  st->gid = ip->gid;
801023c3:	8b 45 08             	mov    0x8(%ebp),%eax
801023c6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801023ca:	0f b7 d0             	movzwl %ax,%edx
801023cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801023d0:	89 50 18             	mov    %edx,0x18(%eax)
  st->mode.asInt = ip->mode.asInt;
801023d3:	8b 45 08             	mov    0x8(%ebp),%eax
801023d6:	8b 50 14             	mov    0x14(%eax),%edx
801023d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801023dc:	89 50 1c             	mov    %edx,0x1c(%eax)
  #endif
}
801023df:	90                   	nop
801023e0:	5d                   	pop    %ebp
801023e1:	c3                   	ret    

801023e2 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801023e2:	55                   	push   %ebp
801023e3:	89 e5                	mov    %esp,%ebp
801023e5:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023e8:	8b 45 08             	mov    0x8(%ebp),%eax
801023eb:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801023ef:	66 83 f8 03          	cmp    $0x3,%ax
801023f3:	75 5c                	jne    80102451 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801023f5:	8b 45 08             	mov    0x8(%ebp),%eax
801023f8:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
801023fc:	66 85 c0             	test   %ax,%ax
801023ff:	78 20                	js     80102421 <readi+0x3f>
80102401:	8b 45 08             	mov    0x8(%ebp),%eax
80102404:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102408:	66 83 f8 09          	cmp    $0x9,%ax
8010240c:	7f 13                	jg     80102421 <readi+0x3f>
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102415:	98                   	cwtl   
80102416:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
8010241d:	85 c0                	test   %eax,%eax
8010241f:	75 0a                	jne    8010242b <readi+0x49>
      return -1;
80102421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102426:	e9 0c 01 00 00       	jmp    80102537 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
8010242b:	8b 45 08             	mov    0x8(%ebp),%eax
8010242e:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102432:	98                   	cwtl   
80102433:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
8010243a:	8b 55 14             	mov    0x14(%ebp),%edx
8010243d:	83 ec 04             	sub    $0x4,%esp
80102440:	52                   	push   %edx
80102441:	ff 75 0c             	pushl  0xc(%ebp)
80102444:	ff 75 08             	pushl  0x8(%ebp)
80102447:	ff d0                	call   *%eax
80102449:	83 c4 10             	add    $0x10,%esp
8010244c:	e9 e6 00 00 00       	jmp    80102537 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80102451:	8b 45 08             	mov    0x8(%ebp),%eax
80102454:	8b 40 20             	mov    0x20(%eax),%eax
80102457:	3b 45 10             	cmp    0x10(%ebp),%eax
8010245a:	72 0d                	jb     80102469 <readi+0x87>
8010245c:	8b 55 10             	mov    0x10(%ebp),%edx
8010245f:	8b 45 14             	mov    0x14(%ebp),%eax
80102462:	01 d0                	add    %edx,%eax
80102464:	3b 45 10             	cmp    0x10(%ebp),%eax
80102467:	73 0a                	jae    80102473 <readi+0x91>
    return -1;
80102469:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010246e:	e9 c4 00 00 00       	jmp    80102537 <readi+0x155>
  if(off + n > ip->size)
80102473:	8b 55 10             	mov    0x10(%ebp),%edx
80102476:	8b 45 14             	mov    0x14(%ebp),%eax
80102479:	01 c2                	add    %eax,%edx
8010247b:	8b 45 08             	mov    0x8(%ebp),%eax
8010247e:	8b 40 20             	mov    0x20(%eax),%eax
80102481:	39 c2                	cmp    %eax,%edx
80102483:	76 0c                	jbe    80102491 <readi+0xaf>
    n = ip->size - off;
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
80102488:	8b 40 20             	mov    0x20(%eax),%eax
8010248b:	2b 45 10             	sub    0x10(%ebp),%eax
8010248e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102491:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102498:	e9 8b 00 00 00       	jmp    80102528 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010249d:	8b 45 10             	mov    0x10(%ebp),%eax
801024a0:	c1 e8 09             	shr    $0x9,%eax
801024a3:	83 ec 08             	sub    $0x8,%esp
801024a6:	50                   	push   %eax
801024a7:	ff 75 08             	pushl  0x8(%ebp)
801024aa:	e8 7e fc ff ff       	call   8010212d <bmap>
801024af:	83 c4 10             	add    $0x10,%esp
801024b2:	89 c2                	mov    %eax,%edx
801024b4:	8b 45 08             	mov    0x8(%ebp),%eax
801024b7:	8b 00                	mov    (%eax),%eax
801024b9:	83 ec 08             	sub    $0x8,%esp
801024bc:	52                   	push   %edx
801024bd:	50                   	push   %eax
801024be:	e8 f3 dc ff ff       	call   801001b6 <bread>
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801024c9:	8b 45 10             	mov    0x10(%ebp),%eax
801024cc:	25 ff 01 00 00       	and    $0x1ff,%eax
801024d1:	ba 00 02 00 00       	mov    $0x200,%edx
801024d6:	29 c2                	sub    %eax,%edx
801024d8:	8b 45 14             	mov    0x14(%ebp),%eax
801024db:	2b 45 f4             	sub    -0xc(%ebp),%eax
801024de:	39 c2                	cmp    %eax,%edx
801024e0:	0f 46 c2             	cmovbe %edx,%eax
801024e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024e9:	8d 50 18             	lea    0x18(%eax),%edx
801024ec:	8b 45 10             	mov    0x10(%ebp),%eax
801024ef:	25 ff 01 00 00       	and    $0x1ff,%eax
801024f4:	01 d0                	add    %edx,%eax
801024f6:	83 ec 04             	sub    $0x4,%esp
801024f9:	ff 75 ec             	pushl  -0x14(%ebp)
801024fc:	50                   	push   %eax
801024fd:	ff 75 0c             	pushl  0xc(%ebp)
80102500:	e8 ea 46 00 00       	call   80106bef <memmove>
80102505:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102508:	83 ec 0c             	sub    $0xc,%esp
8010250b:	ff 75 f0             	pushl  -0x10(%ebp)
8010250e:	e8 1b dd ff ff       	call   8010022e <brelse>
80102513:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102516:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102519:	01 45 f4             	add    %eax,-0xc(%ebp)
8010251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010251f:	01 45 10             	add    %eax,0x10(%ebp)
80102522:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102525:	01 45 0c             	add    %eax,0xc(%ebp)
80102528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010252b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010252e:	0f 82 69 ff ff ff    	jb     8010249d <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102534:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102537:	c9                   	leave  
80102538:	c3                   	ret    

80102539 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102539:	55                   	push   %ebp
8010253a:	89 e5                	mov    %esp,%ebp
8010253c:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010253f:	8b 45 08             	mov    0x8(%ebp),%eax
80102542:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80102546:	66 83 f8 03          	cmp    $0x3,%ax
8010254a:	75 5c                	jne    801025a8 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010254c:	8b 45 08             	mov    0x8(%ebp),%eax
8010254f:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102553:	66 85 c0             	test   %ax,%ax
80102556:	78 20                	js     80102578 <writei+0x3f>
80102558:	8b 45 08             	mov    0x8(%ebp),%eax
8010255b:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
8010255f:	66 83 f8 09          	cmp    $0x9,%ax
80102563:	7f 13                	jg     80102578 <writei+0x3f>
80102565:	8b 45 08             	mov    0x8(%ebp),%eax
80102568:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
8010256c:	98                   	cwtl   
8010256d:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102574:	85 c0                	test   %eax,%eax
80102576:	75 0a                	jne    80102582 <writei+0x49>
      return -1;
80102578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010257d:	e9 3d 01 00 00       	jmp    801026bf <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102582:	8b 45 08             	mov    0x8(%ebp),%eax
80102585:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80102589:	98                   	cwtl   
8010258a:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102591:	8b 55 14             	mov    0x14(%ebp),%edx
80102594:	83 ec 04             	sub    $0x4,%esp
80102597:	52                   	push   %edx
80102598:	ff 75 0c             	pushl  0xc(%ebp)
8010259b:	ff 75 08             	pushl  0x8(%ebp)
8010259e:	ff d0                	call   *%eax
801025a0:	83 c4 10             	add    $0x10,%esp
801025a3:	e9 17 01 00 00       	jmp    801026bf <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801025a8:	8b 45 08             	mov    0x8(%ebp),%eax
801025ab:	8b 40 20             	mov    0x20(%eax),%eax
801025ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801025b1:	72 0d                	jb     801025c0 <writei+0x87>
801025b3:	8b 55 10             	mov    0x10(%ebp),%edx
801025b6:	8b 45 14             	mov    0x14(%ebp),%eax
801025b9:	01 d0                	add    %edx,%eax
801025bb:	3b 45 10             	cmp    0x10(%ebp),%eax
801025be:	73 0a                	jae    801025ca <writei+0x91>
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025c5:	e9 f5 00 00 00       	jmp    801026bf <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801025ca:	8b 55 10             	mov    0x10(%ebp),%edx
801025cd:	8b 45 14             	mov    0x14(%ebp),%eax
801025d0:	01 d0                	add    %edx,%eax
801025d2:	3d 00 14 01 00       	cmp    $0x11400,%eax
801025d7:	76 0a                	jbe    801025e3 <writei+0xaa>
    return -1;
801025d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025de:	e9 dc 00 00 00       	jmp    801026bf <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801025e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025ea:	e9 99 00 00 00       	jmp    80102688 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801025ef:	8b 45 10             	mov    0x10(%ebp),%eax
801025f2:	c1 e8 09             	shr    $0x9,%eax
801025f5:	83 ec 08             	sub    $0x8,%esp
801025f8:	50                   	push   %eax
801025f9:	ff 75 08             	pushl  0x8(%ebp)
801025fc:	e8 2c fb ff ff       	call   8010212d <bmap>
80102601:	83 c4 10             	add    $0x10,%esp
80102604:	89 c2                	mov    %eax,%edx
80102606:	8b 45 08             	mov    0x8(%ebp),%eax
80102609:	8b 00                	mov    (%eax),%eax
8010260b:	83 ec 08             	sub    $0x8,%esp
8010260e:	52                   	push   %edx
8010260f:	50                   	push   %eax
80102610:	e8 a1 db ff ff       	call   801001b6 <bread>
80102615:	83 c4 10             	add    $0x10,%esp
80102618:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010261b:	8b 45 10             	mov    0x10(%ebp),%eax
8010261e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102623:	ba 00 02 00 00       	mov    $0x200,%edx
80102628:	29 c2                	sub    %eax,%edx
8010262a:	8b 45 14             	mov    0x14(%ebp),%eax
8010262d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102630:	39 c2                	cmp    %eax,%edx
80102632:	0f 46 c2             	cmovbe %edx,%eax
80102635:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102638:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010263b:	8d 50 18             	lea    0x18(%eax),%edx
8010263e:	8b 45 10             	mov    0x10(%ebp),%eax
80102641:	25 ff 01 00 00       	and    $0x1ff,%eax
80102646:	01 d0                	add    %edx,%eax
80102648:	83 ec 04             	sub    $0x4,%esp
8010264b:	ff 75 ec             	pushl  -0x14(%ebp)
8010264e:	ff 75 0c             	pushl  0xc(%ebp)
80102651:	50                   	push   %eax
80102652:	e8 98 45 00 00       	call   80106bef <memmove>
80102657:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010265a:	83 ec 0c             	sub    $0xc,%esp
8010265d:	ff 75 f0             	pushl  -0x10(%ebp)
80102660:	e8 2a 16 00 00       	call   80103c8f <log_write>
80102665:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102668:	83 ec 0c             	sub    $0xc,%esp
8010266b:	ff 75 f0             	pushl  -0x10(%ebp)
8010266e:	e8 bb db ff ff       	call   8010022e <brelse>
80102673:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102676:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102679:	01 45 f4             	add    %eax,-0xc(%ebp)
8010267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010267f:	01 45 10             	add    %eax,0x10(%ebp)
80102682:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102685:	01 45 0c             	add    %eax,0xc(%ebp)
80102688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010268b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010268e:	0f 82 5b ff ff ff    	jb     801025ef <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102694:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102698:	74 22                	je     801026bc <writei+0x183>
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
8010269d:	8b 40 20             	mov    0x20(%eax),%eax
801026a0:	3b 45 10             	cmp    0x10(%ebp),%eax
801026a3:	73 17                	jae    801026bc <writei+0x183>
    ip->size = off;
801026a5:	8b 45 08             	mov    0x8(%ebp),%eax
801026a8:	8b 55 10             	mov    0x10(%ebp),%edx
801026ab:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
801026ae:	83 ec 0c             	sub    $0xc,%esp
801026b1:	ff 75 08             	pushl  0x8(%ebp)
801026b4:	e8 bd f2 ff ff       	call   80101976 <iupdate>
801026b9:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801026bc:	8b 45 14             	mov    0x14(%ebp),%eax
}
801026bf:	c9                   	leave  
801026c0:	c3                   	ret    

801026c1 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801026c1:	55                   	push   %ebp
801026c2:	89 e5                	mov    %esp,%ebp
801026c4:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801026c7:	83 ec 04             	sub    $0x4,%esp
801026ca:	6a 0e                	push   $0xe
801026cc:	ff 75 0c             	pushl  0xc(%ebp)
801026cf:	ff 75 08             	pushl  0x8(%ebp)
801026d2:	e8 ae 45 00 00       	call   80106c85 <strncmp>
801026d7:	83 c4 10             	add    $0x10,%esp
}
801026da:	c9                   	leave  
801026db:	c3                   	ret    

801026dc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801026dc:	55                   	push   %ebp
801026dd:	89 e5                	mov    %esp,%ebp
801026df:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801026e2:	8b 45 08             	mov    0x8(%ebp),%eax
801026e5:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801026e9:	66 83 f8 01          	cmp    $0x1,%ax
801026ed:	74 0d                	je     801026fc <dirlookup+0x20>
    panic("dirlookup not DIR");
801026ef:	83 ec 0c             	sub    $0xc,%esp
801026f2:	68 6b a3 10 80       	push   $0x8010a36b
801026f7:	e8 6a de ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801026fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102703:	eb 7b                	jmp    80102780 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102705:	6a 10                	push   $0x10
80102707:	ff 75 f4             	pushl  -0xc(%ebp)
8010270a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010270d:	50                   	push   %eax
8010270e:	ff 75 08             	pushl  0x8(%ebp)
80102711:	e8 cc fc ff ff       	call   801023e2 <readi>
80102716:	83 c4 10             	add    $0x10,%esp
80102719:	83 f8 10             	cmp    $0x10,%eax
8010271c:	74 0d                	je     8010272b <dirlookup+0x4f>
      panic("dirlink read");
8010271e:	83 ec 0c             	sub    $0xc,%esp
80102721:	68 7d a3 10 80       	push   $0x8010a37d
80102726:	e8 3b de ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010272b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010272f:	66 85 c0             	test   %ax,%ax
80102732:	74 47                	je     8010277b <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102734:	83 ec 08             	sub    $0x8,%esp
80102737:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010273a:	83 c0 02             	add    $0x2,%eax
8010273d:	50                   	push   %eax
8010273e:	ff 75 0c             	pushl  0xc(%ebp)
80102741:	e8 7b ff ff ff       	call   801026c1 <namecmp>
80102746:	83 c4 10             	add    $0x10,%esp
80102749:	85 c0                	test   %eax,%eax
8010274b:	75 2f                	jne    8010277c <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010274d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102751:	74 08                	je     8010275b <dirlookup+0x7f>
        *poff = off;
80102753:	8b 45 10             	mov    0x10(%ebp),%eax
80102756:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102759:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010275b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010275f:	0f b7 c0             	movzwl %ax,%eax
80102762:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102765:	8b 45 08             	mov    0x8(%ebp),%eax
80102768:	8b 00                	mov    (%eax),%eax
8010276a:	83 ec 08             	sub    $0x8,%esp
8010276d:	ff 75 f0             	pushl  -0x10(%ebp)
80102770:	50                   	push   %eax
80102771:	e8 43 f4 ff ff       	call   80101bb9 <iget>
80102776:	83 c4 10             	add    $0x10,%esp
80102779:	eb 19                	jmp    80102794 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010277b:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010277c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102780:	8b 45 08             	mov    0x8(%ebp),%eax
80102783:	8b 40 20             	mov    0x20(%eax),%eax
80102786:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102789:	0f 87 76 ff ff ff    	ja     80102705 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010278f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102794:	c9                   	leave  
80102795:	c3                   	ret    

80102796 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102796:	55                   	push   %ebp
80102797:	89 e5                	mov    %esp,%ebp
80102799:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010279c:	83 ec 04             	sub    $0x4,%esp
8010279f:	6a 00                	push   $0x0
801027a1:	ff 75 0c             	pushl  0xc(%ebp)
801027a4:	ff 75 08             	pushl  0x8(%ebp)
801027a7:	e8 30 ff ff ff       	call   801026dc <dirlookup>
801027ac:	83 c4 10             	add    $0x10,%esp
801027af:	89 45 f0             	mov    %eax,-0x10(%ebp)
801027b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801027b6:	74 18                	je     801027d0 <dirlink+0x3a>
    iput(ip);
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	ff 75 f0             	pushl  -0x10(%ebp)
801027be:	e8 55 f8 ff ff       	call   80102018 <iput>
801027c3:	83 c4 10             	add    $0x10,%esp
    return -1;
801027c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027cb:	e9 9c 00 00 00       	jmp    8010286c <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801027d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027d7:	eb 39                	jmp    80102812 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027dc:	6a 10                	push   $0x10
801027de:	50                   	push   %eax
801027df:	8d 45 e0             	lea    -0x20(%ebp),%eax
801027e2:	50                   	push   %eax
801027e3:	ff 75 08             	pushl  0x8(%ebp)
801027e6:	e8 f7 fb ff ff       	call   801023e2 <readi>
801027eb:	83 c4 10             	add    $0x10,%esp
801027ee:	83 f8 10             	cmp    $0x10,%eax
801027f1:	74 0d                	je     80102800 <dirlink+0x6a>
      panic("dirlink read");
801027f3:	83 ec 0c             	sub    $0xc,%esp
801027f6:	68 7d a3 10 80       	push   $0x8010a37d
801027fb:	e8 66 dd ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102800:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102804:	66 85 c0             	test   %ax,%ax
80102807:	74 18                	je     80102821 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280c:	83 c0 10             	add    $0x10,%eax
8010280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102812:	8b 45 08             	mov    0x8(%ebp),%eax
80102815:	8b 50 20             	mov    0x20(%eax),%edx
80102818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010281b:	39 c2                	cmp    %eax,%edx
8010281d:	77 ba                	ja     801027d9 <dirlink+0x43>
8010281f:	eb 01                	jmp    80102822 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102821:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102822:	83 ec 04             	sub    $0x4,%esp
80102825:	6a 0e                	push   $0xe
80102827:	ff 75 0c             	pushl  0xc(%ebp)
8010282a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010282d:	83 c0 02             	add    $0x2,%eax
80102830:	50                   	push   %eax
80102831:	e8 a5 44 00 00       	call   80106cdb <strncpy>
80102836:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102839:	8b 45 10             	mov    0x10(%ebp),%eax
8010283c:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102843:	6a 10                	push   $0x10
80102845:	50                   	push   %eax
80102846:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102849:	50                   	push   %eax
8010284a:	ff 75 08             	pushl  0x8(%ebp)
8010284d:	e8 e7 fc ff ff       	call   80102539 <writei>
80102852:	83 c4 10             	add    $0x10,%esp
80102855:	83 f8 10             	cmp    $0x10,%eax
80102858:	74 0d                	je     80102867 <dirlink+0xd1>
    panic("dirlink");
8010285a:	83 ec 0c             	sub    $0xc,%esp
8010285d:	68 8a a3 10 80       	push   $0x8010a38a
80102862:	e8 ff dc ff ff       	call   80100566 <panic>
  
  return 0;
80102867:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010286c:	c9                   	leave  
8010286d:	c3                   	ret    

8010286e <skipelem>:

//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010286e:	55                   	push   %ebp
8010286f:	89 e5                	mov    %esp,%ebp
80102871:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102874:	eb 04                	jmp    8010287a <skipelem+0xc>
    path++;
80102876:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010287a:	8b 45 08             	mov    0x8(%ebp),%eax
8010287d:	0f b6 00             	movzbl (%eax),%eax
80102880:	3c 2f                	cmp    $0x2f,%al
80102882:	74 f2                	je     80102876 <skipelem+0x8>
    path++;
  if(*path == 0)
80102884:	8b 45 08             	mov    0x8(%ebp),%eax
80102887:	0f b6 00             	movzbl (%eax),%eax
8010288a:	84 c0                	test   %al,%al
8010288c:	75 07                	jne    80102895 <skipelem+0x27>
    return 0;
8010288e:	b8 00 00 00 00       	mov    $0x0,%eax
80102893:	eb 7b                	jmp    80102910 <skipelem+0xa2>
  s = path;
80102895:	8b 45 08             	mov    0x8(%ebp),%eax
80102898:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010289b:	eb 04                	jmp    801028a1 <skipelem+0x33>
    path++;
8010289d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801028a1:	8b 45 08             	mov    0x8(%ebp),%eax
801028a4:	0f b6 00             	movzbl (%eax),%eax
801028a7:	3c 2f                	cmp    $0x2f,%al
801028a9:	74 0a                	je     801028b5 <skipelem+0x47>
801028ab:	8b 45 08             	mov    0x8(%ebp),%eax
801028ae:	0f b6 00             	movzbl (%eax),%eax
801028b1:	84 c0                	test   %al,%al
801028b3:	75 e8                	jne    8010289d <skipelem+0x2f>
    path++;
  len = path - s;
801028b5:	8b 55 08             	mov    0x8(%ebp),%edx
801028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028bb:	29 c2                	sub    %eax,%edx
801028bd:	89 d0                	mov    %edx,%eax
801028bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801028c2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801028c6:	7e 15                	jle    801028dd <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801028c8:	83 ec 04             	sub    $0x4,%esp
801028cb:	6a 0e                	push   $0xe
801028cd:	ff 75 f4             	pushl  -0xc(%ebp)
801028d0:	ff 75 0c             	pushl  0xc(%ebp)
801028d3:	e8 17 43 00 00       	call   80106bef <memmove>
801028d8:	83 c4 10             	add    $0x10,%esp
801028db:	eb 26                	jmp    80102903 <skipelem+0x95>
  else {
    memmove(name, s, len);
801028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028e0:	83 ec 04             	sub    $0x4,%esp
801028e3:	50                   	push   %eax
801028e4:	ff 75 f4             	pushl  -0xc(%ebp)
801028e7:	ff 75 0c             	pushl  0xc(%ebp)
801028ea:	e8 00 43 00 00       	call   80106bef <memmove>
801028ef:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801028f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801028f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801028f8:	01 d0                	add    %edx,%eax
801028fa:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801028fd:	eb 04                	jmp    80102903 <skipelem+0x95>
    path++;
801028ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102903:	8b 45 08             	mov    0x8(%ebp),%eax
80102906:	0f b6 00             	movzbl (%eax),%eax
80102909:	3c 2f                	cmp    $0x2f,%al
8010290b:	74 f2                	je     801028ff <skipelem+0x91>
    path++;
  return path;
8010290d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102910:	c9                   	leave  
80102911:	c3                   	ret    

80102912 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102912:	55                   	push   %ebp
80102913:	89 e5                	mov    %esp,%ebp
80102915:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102918:	8b 45 08             	mov    0x8(%ebp),%eax
8010291b:	0f b6 00             	movzbl (%eax),%eax
8010291e:	3c 2f                	cmp    $0x2f,%al
80102920:	75 17                	jne    80102939 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102922:	83 ec 08             	sub    $0x8,%esp
80102925:	6a 01                	push   $0x1
80102927:	6a 01                	push   $0x1
80102929:	e8 8b f2 ff ff       	call   80101bb9 <iget>
8010292e:	83 c4 10             	add    $0x10,%esp
80102931:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102934:	e9 bb 00 00 00       	jmp    801029f4 <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102939:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010293f:	8b 40 70             	mov    0x70(%eax),%eax
80102942:	83 ec 0c             	sub    $0xc,%esp
80102945:	50                   	push   %eax
80102946:	e8 4d f3 ff ff       	call   80101c98 <idup>
8010294b:	83 c4 10             	add    $0x10,%esp
8010294e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102951:	e9 9e 00 00 00       	jmp    801029f4 <namex+0xe2>
    ilock(ip);
80102956:	83 ec 0c             	sub    $0xc,%esp
80102959:	ff 75 f4             	pushl  -0xc(%ebp)
8010295c:	e8 71 f3 ff ff       	call   80101cd2 <ilock>
80102961:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102967:	0f b7 40 18          	movzwl 0x18(%eax),%eax
8010296b:	66 83 f8 01          	cmp    $0x1,%ax
8010296f:	74 18                	je     80102989 <namex+0x77>
      iunlockput(ip);
80102971:	83 ec 0c             	sub    $0xc,%esp
80102974:	ff 75 f4             	pushl  -0xc(%ebp)
80102977:	e8 8c f7 ff ff       	call   80102108 <iunlockput>
8010297c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010297f:	b8 00 00 00 00       	mov    $0x0,%eax
80102984:	e9 a7 00 00 00       	jmp    80102a30 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102989:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010298d:	74 20                	je     801029af <namex+0x9d>
8010298f:	8b 45 08             	mov    0x8(%ebp),%eax
80102992:	0f b6 00             	movzbl (%eax),%eax
80102995:	84 c0                	test   %al,%al
80102997:	75 16                	jne    801029af <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	ff 75 f4             	pushl  -0xc(%ebp)
8010299f:	e8 02 f6 ff ff       	call   80101fa6 <iunlock>
801029a4:	83 c4 10             	add    $0x10,%esp
      return ip;
801029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029aa:	e9 81 00 00 00       	jmp    80102a30 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801029af:	83 ec 04             	sub    $0x4,%esp
801029b2:	6a 00                	push   $0x0
801029b4:	ff 75 10             	pushl  0x10(%ebp)
801029b7:	ff 75 f4             	pushl  -0xc(%ebp)
801029ba:	e8 1d fd ff ff       	call   801026dc <dirlookup>
801029bf:	83 c4 10             	add    $0x10,%esp
801029c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801029c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801029c9:	75 15                	jne    801029e0 <namex+0xce>
      iunlockput(ip);
801029cb:	83 ec 0c             	sub    $0xc,%esp
801029ce:	ff 75 f4             	pushl  -0xc(%ebp)
801029d1:	e8 32 f7 ff ff       	call   80102108 <iunlockput>
801029d6:	83 c4 10             	add    $0x10,%esp
      return 0;
801029d9:	b8 00 00 00 00       	mov    $0x0,%eax
801029de:	eb 50                	jmp    80102a30 <namex+0x11e>
    }
    iunlockput(ip);
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	ff 75 f4             	pushl  -0xc(%ebp)
801029e6:	e8 1d f7 ff ff       	call   80102108 <iunlockput>
801029eb:	83 c4 10             	add    $0x10,%esp
    ip = next;
801029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801029f4:	83 ec 08             	sub    $0x8,%esp
801029f7:	ff 75 10             	pushl  0x10(%ebp)
801029fa:	ff 75 08             	pushl  0x8(%ebp)
801029fd:	e8 6c fe ff ff       	call   8010286e <skipelem>
80102a02:	83 c4 10             	add    $0x10,%esp
80102a05:	89 45 08             	mov    %eax,0x8(%ebp)
80102a08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102a0c:	0f 85 44 ff ff ff    	jne    80102956 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102a12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102a16:	74 15                	je     80102a2d <namex+0x11b>
    iput(ip);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	ff 75 f4             	pushl  -0xc(%ebp)
80102a1e:	e8 f5 f5 ff ff       	call   80102018 <iput>
80102a23:	83 c4 10             	add    $0x10,%esp
    return 0;
80102a26:	b8 00 00 00 00       	mov    $0x0,%eax
80102a2b:	eb 03                	jmp    80102a30 <namex+0x11e>
  }
  return ip;
80102a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102a30:	c9                   	leave  
80102a31:	c3                   	ret    

80102a32 <namei>:

struct inode*
namei(char *path)
{
80102a32:	55                   	push   %ebp
80102a33:	89 e5                	mov    %esp,%ebp
80102a35:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102a38:	83 ec 04             	sub    $0x4,%esp
80102a3b:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102a3e:	50                   	push   %eax
80102a3f:	6a 00                	push   $0x0
80102a41:	ff 75 08             	pushl  0x8(%ebp)
80102a44:	e8 c9 fe ff ff       	call   80102912 <namex>
80102a49:	83 c4 10             	add    $0x10,%esp
}
80102a4c:	c9                   	leave  
80102a4d:	c3                   	ret    

80102a4e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102a54:	83 ec 04             	sub    $0x4,%esp
80102a57:	ff 75 0c             	pushl  0xc(%ebp)
80102a5a:	6a 01                	push   $0x1
80102a5c:	ff 75 08             	pushl  0x8(%ebp)
80102a5f:	e8 ae fe ff ff       	call   80102912 <namex>
80102a64:	83 c4 10             	add    $0x10,%esp
}
80102a67:	c9                   	leave  
80102a68:	c3                   	ret    

80102a69 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102a69:	55                   	push   %ebp
80102a6a:	89 e5                	mov    %esp,%ebp
80102a6c:	83 ec 14             	sub    $0x14,%esp
80102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a72:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102a7a:	89 c2                	mov    %eax,%edx
80102a7c:	ec                   	in     (%dx),%al
80102a7d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102a80:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102a84:	c9                   	leave  
80102a85:	c3                   	ret    

80102a86 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102a86:	55                   	push   %ebp
80102a87:	89 e5                	mov    %esp,%ebp
80102a89:	57                   	push   %edi
80102a8a:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102a8b:	8b 55 08             	mov    0x8(%ebp),%edx
80102a8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a91:	8b 45 10             	mov    0x10(%ebp),%eax
80102a94:	89 cb                	mov    %ecx,%ebx
80102a96:	89 df                	mov    %ebx,%edi
80102a98:	89 c1                	mov    %eax,%ecx
80102a9a:	fc                   	cld    
80102a9b:	f3 6d                	rep insl (%dx),%es:(%edi)
80102a9d:	89 c8                	mov    %ecx,%eax
80102a9f:	89 fb                	mov    %edi,%ebx
80102aa1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102aa4:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102aa7:	90                   	nop
80102aa8:	5b                   	pop    %ebx
80102aa9:	5f                   	pop    %edi
80102aaa:	5d                   	pop    %ebp
80102aab:	c3                   	ret    

80102aac <outb>:

static inline void
outb(ushort port, uchar data)
{
80102aac:	55                   	push   %ebp
80102aad:	89 e5                	mov    %esp,%ebp
80102aaf:	83 ec 08             	sub    $0x8,%esp
80102ab2:	8b 55 08             	mov    0x8(%ebp),%edx
80102ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ab8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102abc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ac3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ac7:	ee                   	out    %al,(%dx)
}
80102ac8:	90                   	nop
80102ac9:	c9                   	leave  
80102aca:	c3                   	ret    

80102acb <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102acb:	55                   	push   %ebp
80102acc:	89 e5                	mov    %esp,%ebp
80102ace:	56                   	push   %esi
80102acf:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102ad0:	8b 55 08             	mov    0x8(%ebp),%edx
80102ad3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ad6:	8b 45 10             	mov    0x10(%ebp),%eax
80102ad9:	89 cb                	mov    %ecx,%ebx
80102adb:	89 de                	mov    %ebx,%esi
80102add:	89 c1                	mov    %eax,%ecx
80102adf:	fc                   	cld    
80102ae0:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102ae2:	89 c8                	mov    %ecx,%eax
80102ae4:	89 f3                	mov    %esi,%ebx
80102ae6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102ae9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102aec:	90                   	nop
80102aed:	5b                   	pop    %ebx
80102aee:	5e                   	pop    %esi
80102aef:	5d                   	pop    %ebp
80102af0:	c3                   	ret    

80102af1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102af1:	55                   	push   %ebp
80102af2:	89 e5                	mov    %esp,%ebp
80102af4:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102af7:	90                   	nop
80102af8:	68 f7 01 00 00       	push   $0x1f7
80102afd:	e8 67 ff ff ff       	call   80102a69 <inb>
80102b02:	83 c4 04             	add    $0x4,%esp
80102b05:	0f b6 c0             	movzbl %al,%eax
80102b08:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b0e:	25 c0 00 00 00       	and    $0xc0,%eax
80102b13:	83 f8 40             	cmp    $0x40,%eax
80102b16:	75 e0                	jne    80102af8 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102b1c:	74 11                	je     80102b2f <idewait+0x3e>
80102b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b21:	83 e0 21             	and    $0x21,%eax
80102b24:	85 c0                	test   %eax,%eax
80102b26:	74 07                	je     80102b2f <idewait+0x3e>
    return -1;
80102b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b2d:	eb 05                	jmp    80102b34 <idewait+0x43>
  return 0;
80102b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102b34:	c9                   	leave  
80102b35:	c3                   	ret    

80102b36 <ideinit>:

void
ideinit(void)
{
80102b36:	55                   	push   %ebp
80102b37:	89 e5                	mov    %esp,%ebp
80102b39:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102b3c:	83 ec 08             	sub    $0x8,%esp
80102b3f:	68 92 a3 10 80       	push   $0x8010a392
80102b44:	68 40 d6 10 80       	push   $0x8010d640
80102b49:	e8 5d 3d 00 00       	call   801068ab <initlock>
80102b4e:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102b51:	83 ec 0c             	sub    $0xc,%esp
80102b54:	6a 0e                	push   $0xe
80102b56:	e8 da 18 00 00       	call   80104435 <picenable>
80102b5b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102b5e:	a1 80 49 11 80       	mov    0x80114980,%eax
80102b63:	83 e8 01             	sub    $0x1,%eax
80102b66:	83 ec 08             	sub    $0x8,%esp
80102b69:	50                   	push   %eax
80102b6a:	6a 0e                	push   $0xe
80102b6c:	e8 73 04 00 00       	call   80102fe4 <ioapicenable>
80102b71:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102b74:	83 ec 0c             	sub    $0xc,%esp
80102b77:	6a 00                	push   $0x0
80102b79:	e8 73 ff ff ff       	call   80102af1 <idewait>
80102b7e:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102b81:	83 ec 08             	sub    $0x8,%esp
80102b84:	68 f0 00 00 00       	push   $0xf0
80102b89:	68 f6 01 00 00       	push   $0x1f6
80102b8e:	e8 19 ff ff ff       	call   80102aac <outb>
80102b93:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102b96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b9d:	eb 24                	jmp    80102bc3 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102b9f:	83 ec 0c             	sub    $0xc,%esp
80102ba2:	68 f7 01 00 00       	push   $0x1f7
80102ba7:	e8 bd fe ff ff       	call   80102a69 <inb>
80102bac:	83 c4 10             	add    $0x10,%esp
80102baf:	84 c0                	test   %al,%al
80102bb1:	74 0c                	je     80102bbf <ideinit+0x89>
      havedisk1 = 1;
80102bb3:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
80102bba:	00 00 00 
      break;
80102bbd:	eb 0d                	jmp    80102bcc <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102bc3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102bca:	7e d3                	jle    80102b9f <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102bcc:	83 ec 08             	sub    $0x8,%esp
80102bcf:	68 e0 00 00 00       	push   $0xe0
80102bd4:	68 f6 01 00 00       	push   $0x1f6
80102bd9:	e8 ce fe ff ff       	call   80102aac <outb>
80102bde:	83 c4 10             	add    $0x10,%esp
}
80102be1:	90                   	nop
80102be2:	c9                   	leave  
80102be3:	c3                   	ret    

80102be4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102be4:	55                   	push   %ebp
80102be5:	89 e5                	mov    %esp,%ebp
80102be7:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102bee:	75 0d                	jne    80102bfd <idestart+0x19>
    panic("idestart");
80102bf0:	83 ec 0c             	sub    $0xc,%esp
80102bf3:	68 96 a3 10 80       	push   $0x8010a396
80102bf8:	e8 69 d9 ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80102c00:	8b 40 08             	mov    0x8(%eax),%eax
80102c03:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102c08:	76 0d                	jbe    80102c17 <idestart+0x33>
    panic("incorrect blockno");
80102c0a:	83 ec 0c             	sub    $0xc,%esp
80102c0d:	68 9f a3 10 80       	push   $0x8010a39f
80102c12:	e8 4f d9 ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102c17:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80102c21:	8b 50 08             	mov    0x8(%eax),%edx
80102c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c27:	0f af c2             	imul   %edx,%eax
80102c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102c2d:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102c31:	7e 0d                	jle    80102c40 <idestart+0x5c>
80102c33:	83 ec 0c             	sub    $0xc,%esp
80102c36:	68 96 a3 10 80       	push   $0x8010a396
80102c3b:	e8 26 d9 ff ff       	call   80100566 <panic>
  
  idewait(0);
80102c40:	83 ec 0c             	sub    $0xc,%esp
80102c43:	6a 00                	push   $0x0
80102c45:	e8 a7 fe ff ff       	call   80102af1 <idewait>
80102c4a:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102c4d:	83 ec 08             	sub    $0x8,%esp
80102c50:	6a 00                	push   $0x0
80102c52:	68 f6 03 00 00       	push   $0x3f6
80102c57:	e8 50 fe ff ff       	call   80102aac <outb>
80102c5c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c62:	0f b6 c0             	movzbl %al,%eax
80102c65:	83 ec 08             	sub    $0x8,%esp
80102c68:	50                   	push   %eax
80102c69:	68 f2 01 00 00       	push   $0x1f2
80102c6e:	e8 39 fe ff ff       	call   80102aac <outb>
80102c73:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102c79:	0f b6 c0             	movzbl %al,%eax
80102c7c:	83 ec 08             	sub    $0x8,%esp
80102c7f:	50                   	push   %eax
80102c80:	68 f3 01 00 00       	push   $0x1f3
80102c85:	e8 22 fe ff ff       	call   80102aac <outb>
80102c8a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102c90:	c1 f8 08             	sar    $0x8,%eax
80102c93:	0f b6 c0             	movzbl %al,%eax
80102c96:	83 ec 08             	sub    $0x8,%esp
80102c99:	50                   	push   %eax
80102c9a:	68 f4 01 00 00       	push   $0x1f4
80102c9f:	e8 08 fe ff ff       	call   80102aac <outb>
80102ca4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102caa:	c1 f8 10             	sar    $0x10,%eax
80102cad:	0f b6 c0             	movzbl %al,%eax
80102cb0:	83 ec 08             	sub    $0x8,%esp
80102cb3:	50                   	push   %eax
80102cb4:	68 f5 01 00 00       	push   $0x1f5
80102cb9:	e8 ee fd ff ff       	call   80102aac <outb>
80102cbe:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc4:	8b 40 04             	mov    0x4(%eax),%eax
80102cc7:	83 e0 01             	and    $0x1,%eax
80102cca:	c1 e0 04             	shl    $0x4,%eax
80102ccd:	89 c2                	mov    %eax,%edx
80102ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102cd2:	c1 f8 18             	sar    $0x18,%eax
80102cd5:	83 e0 0f             	and    $0xf,%eax
80102cd8:	09 d0                	or     %edx,%eax
80102cda:	83 c8 e0             	or     $0xffffffe0,%eax
80102cdd:	0f b6 c0             	movzbl %al,%eax
80102ce0:	83 ec 08             	sub    $0x8,%esp
80102ce3:	50                   	push   %eax
80102ce4:	68 f6 01 00 00       	push   $0x1f6
80102ce9:	e8 be fd ff ff       	call   80102aac <outb>
80102cee:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf4:	8b 00                	mov    (%eax),%eax
80102cf6:	83 e0 04             	and    $0x4,%eax
80102cf9:	85 c0                	test   %eax,%eax
80102cfb:	74 30                	je     80102d2d <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102cfd:	83 ec 08             	sub    $0x8,%esp
80102d00:	6a 30                	push   $0x30
80102d02:	68 f7 01 00 00       	push   $0x1f7
80102d07:	e8 a0 fd ff ff       	call   80102aac <outb>
80102d0c:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d12:	83 c0 18             	add    $0x18,%eax
80102d15:	83 ec 04             	sub    $0x4,%esp
80102d18:	68 80 00 00 00       	push   $0x80
80102d1d:	50                   	push   %eax
80102d1e:	68 f0 01 00 00       	push   $0x1f0
80102d23:	e8 a3 fd ff ff       	call   80102acb <outsl>
80102d28:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102d2b:	eb 12                	jmp    80102d3f <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102d2d:	83 ec 08             	sub    $0x8,%esp
80102d30:	6a 20                	push   $0x20
80102d32:	68 f7 01 00 00       	push   $0x1f7
80102d37:	e8 70 fd ff ff       	call   80102aac <outb>
80102d3c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d3f:	90                   	nop
80102d40:	c9                   	leave  
80102d41:	c3                   	ret    

80102d42 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102d42:	55                   	push   %ebp
80102d43:	89 e5                	mov    %esp,%ebp
80102d45:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 40 d6 10 80       	push   $0x8010d640
80102d50:	e8 78 3b 00 00       	call   801068cd <acquire>
80102d55:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102d58:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d64:	75 15                	jne    80102d7b <ideintr+0x39>
    release(&idelock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	68 40 d6 10 80       	push   $0x8010d640
80102d6e:	e8 c1 3b 00 00       	call   80106934 <release>
80102d73:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102d76:	e9 9a 00 00 00       	jmp    80102e15 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d7e:	8b 40 14             	mov    0x14(%eax),%eax
80102d81:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d89:	8b 00                	mov    (%eax),%eax
80102d8b:	83 e0 04             	and    $0x4,%eax
80102d8e:	85 c0                	test   %eax,%eax
80102d90:	75 2d                	jne    80102dbf <ideintr+0x7d>
80102d92:	83 ec 0c             	sub    $0xc,%esp
80102d95:	6a 01                	push   $0x1
80102d97:	e8 55 fd ff ff       	call   80102af1 <idewait>
80102d9c:	83 c4 10             	add    $0x10,%esp
80102d9f:	85 c0                	test   %eax,%eax
80102da1:	78 1c                	js     80102dbf <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da6:	83 c0 18             	add    $0x18,%eax
80102da9:	83 ec 04             	sub    $0x4,%esp
80102dac:	68 80 00 00 00       	push   $0x80
80102db1:	50                   	push   %eax
80102db2:	68 f0 01 00 00       	push   $0x1f0
80102db7:	e8 ca fc ff ff       	call   80102a86 <insl>
80102dbc:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dc2:	8b 00                	mov    (%eax),%eax
80102dc4:	83 c8 02             	or     $0x2,%eax
80102dc7:	89 c2                	mov    %eax,%edx
80102dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dcc:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd1:	8b 00                	mov    (%eax),%eax
80102dd3:	83 e0 fb             	and    $0xfffffffb,%eax
80102dd6:	89 c2                	mov    %eax,%edx
80102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ddb:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102ddd:	83 ec 0c             	sub    $0xc,%esp
80102de0:	ff 75 f4             	pushl  -0xc(%ebp)
80102de3:	e8 1a 30 00 00       	call   80105e02 <wakeup>
80102de8:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102deb:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102df0:	85 c0                	test   %eax,%eax
80102df2:	74 11                	je     80102e05 <ideintr+0xc3>
    idestart(idequeue);
80102df4:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102df9:	83 ec 0c             	sub    $0xc,%esp
80102dfc:	50                   	push   %eax
80102dfd:	e8 e2 fd ff ff       	call   80102be4 <idestart>
80102e02:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102e05:	83 ec 0c             	sub    $0xc,%esp
80102e08:	68 40 d6 10 80       	push   $0x8010d640
80102e0d:	e8 22 3b 00 00       	call   80106934 <release>
80102e12:	83 c4 10             	add    $0x10,%esp
}
80102e15:	c9                   	leave  
80102e16:	c3                   	ret    

80102e17 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102e17:	55                   	push   %ebp
80102e18:	89 e5                	mov    %esp,%ebp
80102e1a:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80102e20:	8b 00                	mov    (%eax),%eax
80102e22:	83 e0 01             	and    $0x1,%eax
80102e25:	85 c0                	test   %eax,%eax
80102e27:	75 0d                	jne    80102e36 <iderw+0x1f>
    panic("iderw: buf not busy");
80102e29:	83 ec 0c             	sub    $0xc,%esp
80102e2c:	68 b1 a3 10 80       	push   $0x8010a3b1
80102e31:	e8 30 d7 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102e36:	8b 45 08             	mov    0x8(%ebp),%eax
80102e39:	8b 00                	mov    (%eax),%eax
80102e3b:	83 e0 06             	and    $0x6,%eax
80102e3e:	83 f8 02             	cmp    $0x2,%eax
80102e41:	75 0d                	jne    80102e50 <iderw+0x39>
    panic("iderw: nothing to do");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 c5 a3 10 80       	push   $0x8010a3c5
80102e4b:	e8 16 d7 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102e50:	8b 45 08             	mov    0x8(%ebp),%eax
80102e53:	8b 40 04             	mov    0x4(%eax),%eax
80102e56:	85 c0                	test   %eax,%eax
80102e58:	74 16                	je     80102e70 <iderw+0x59>
80102e5a:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102e5f:	85 c0                	test   %eax,%eax
80102e61:	75 0d                	jne    80102e70 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 da a3 10 80       	push   $0x8010a3da
80102e6b:	e8 f6 d6 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102e70:	83 ec 0c             	sub    $0xc,%esp
80102e73:	68 40 d6 10 80       	push   $0x8010d640
80102e78:	e8 50 3a 00 00       	call   801068cd <acquire>
80102e7d:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102e80:	8b 45 08             	mov    0x8(%ebp),%eax
80102e83:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102e8a:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102e91:	eb 0b                	jmp    80102e9e <iderw+0x87>
80102e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e96:	8b 00                	mov    (%eax),%eax
80102e98:	83 c0 14             	add    $0x14,%eax
80102e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ea1:	8b 00                	mov    (%eax),%eax
80102ea3:	85 c0                	test   %eax,%eax
80102ea5:	75 ec                	jne    80102e93 <iderw+0x7c>
    ;
  *pp = b;
80102ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eaa:	8b 55 08             	mov    0x8(%ebp),%edx
80102ead:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102eaf:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102eb4:	3b 45 08             	cmp    0x8(%ebp),%eax
80102eb7:	75 23                	jne    80102edc <iderw+0xc5>
    idestart(b);
80102eb9:	83 ec 0c             	sub    $0xc,%esp
80102ebc:	ff 75 08             	pushl  0x8(%ebp)
80102ebf:	e8 20 fd ff ff       	call   80102be4 <idestart>
80102ec4:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ec7:	eb 13                	jmp    80102edc <iderw+0xc5>
    sleep(b, &idelock);
80102ec9:	83 ec 08             	sub    $0x8,%esp
80102ecc:	68 40 d6 10 80       	push   $0x8010d640
80102ed1:	ff 75 08             	pushl  0x8(%ebp)
80102ed4:	e8 51 2d 00 00       	call   80105c2a <sleep>
80102ed9:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102edc:	8b 45 08             	mov    0x8(%ebp),%eax
80102edf:	8b 00                	mov    (%eax),%eax
80102ee1:	83 e0 06             	and    $0x6,%eax
80102ee4:	83 f8 02             	cmp    $0x2,%eax
80102ee7:	75 e0                	jne    80102ec9 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102ee9:	83 ec 0c             	sub    $0xc,%esp
80102eec:	68 40 d6 10 80       	push   $0x8010d640
80102ef1:	e8 3e 3a 00 00       	call   80106934 <release>
80102ef6:	83 c4 10             	add    $0x10,%esp
}
80102ef9:	90                   	nop
80102efa:	c9                   	leave  
80102efb:	c3                   	ret    

80102efc <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102efc:	55                   	push   %ebp
80102efd:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102eff:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f04:	8b 55 08             	mov    0x8(%ebp),%edx
80102f07:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102f09:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f0e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102f11:	5d                   	pop    %ebp
80102f12:	c3                   	ret    

80102f13 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102f13:	55                   	push   %ebp
80102f14:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102f16:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f1b:	8b 55 08             	mov    0x8(%ebp),%edx
80102f1e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102f20:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f25:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f28:	89 50 10             	mov    %edx,0x10(%eax)
}
80102f2b:	90                   	nop
80102f2c:	5d                   	pop    %ebp
80102f2d:	c3                   	ret    

80102f2e <ioapicinit>:

void
ioapicinit(void)
{
80102f2e:	55                   	push   %ebp
80102f2f:	89 e5                	mov    %esp,%ebp
80102f31:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102f34:	a1 84 43 11 80       	mov    0x80114384,%eax
80102f39:	85 c0                	test   %eax,%eax
80102f3b:	0f 84 a0 00 00 00    	je     80102fe1 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102f41:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102f48:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102f4b:	6a 01                	push   $0x1
80102f4d:	e8 aa ff ff ff       	call   80102efc <ioapicread>
80102f52:	83 c4 04             	add    $0x4,%esp
80102f55:	c1 e8 10             	shr    $0x10,%eax
80102f58:	25 ff 00 00 00       	and    $0xff,%eax
80102f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102f60:	6a 00                	push   $0x0
80102f62:	e8 95 ff ff ff       	call   80102efc <ioapicread>
80102f67:	83 c4 04             	add    $0x4,%esp
80102f6a:	c1 e8 18             	shr    $0x18,%eax
80102f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102f70:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102f77:	0f b6 c0             	movzbl %al,%eax
80102f7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102f7d:	74 10                	je     80102f8f <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102f7f:	83 ec 0c             	sub    $0xc,%esp
80102f82:	68 f8 a3 10 80       	push   $0x8010a3f8
80102f87:	e8 3a d4 ff ff       	call   801003c6 <cprintf>
80102f8c:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102f8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f96:	eb 3f                	jmp    80102fd7 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f9b:	83 c0 20             	add    $0x20,%eax
80102f9e:	0d 00 00 01 00       	or     $0x10000,%eax
80102fa3:	89 c2                	mov    %eax,%edx
80102fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fa8:	83 c0 08             	add    $0x8,%eax
80102fab:	01 c0                	add    %eax,%eax
80102fad:	83 ec 08             	sub    $0x8,%esp
80102fb0:	52                   	push   %edx
80102fb1:	50                   	push   %eax
80102fb2:	e8 5c ff ff ff       	call   80102f13 <ioapicwrite>
80102fb7:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fbd:	83 c0 08             	add    $0x8,%eax
80102fc0:	01 c0                	add    %eax,%eax
80102fc2:	83 c0 01             	add    $0x1,%eax
80102fc5:	83 ec 08             	sub    $0x8,%esp
80102fc8:	6a 00                	push   $0x0
80102fca:	50                   	push   %eax
80102fcb:	e8 43 ff ff ff       	call   80102f13 <ioapicwrite>
80102fd0:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102fd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fda:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102fdd:	7e b9                	jle    80102f98 <ioapicinit+0x6a>
80102fdf:	eb 01                	jmp    80102fe2 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102fe1:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102fe2:	c9                   	leave  
80102fe3:	c3                   	ret    

80102fe4 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102fe4:	55                   	push   %ebp
80102fe5:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102fe7:	a1 84 43 11 80       	mov    0x80114384,%eax
80102fec:	85 c0                	test   %eax,%eax
80102fee:	74 39                	je     80103029 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ff3:	83 c0 20             	add    $0x20,%eax
80102ff6:	89 c2                	mov    %eax,%edx
80102ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80102ffb:	83 c0 08             	add    $0x8,%eax
80102ffe:	01 c0                	add    %eax,%eax
80103000:	52                   	push   %edx
80103001:	50                   	push   %eax
80103002:	e8 0c ff ff ff       	call   80102f13 <ioapicwrite>
80103007:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010300a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010300d:	c1 e0 18             	shl    $0x18,%eax
80103010:	89 c2                	mov    %eax,%edx
80103012:	8b 45 08             	mov    0x8(%ebp),%eax
80103015:	83 c0 08             	add    $0x8,%eax
80103018:	01 c0                	add    %eax,%eax
8010301a:	83 c0 01             	add    $0x1,%eax
8010301d:	52                   	push   %edx
8010301e:	50                   	push   %eax
8010301f:	e8 ef fe ff ff       	call   80102f13 <ioapicwrite>
80103024:	83 c4 08             	add    $0x8,%esp
80103027:	eb 01                	jmp    8010302a <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80103029:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
8010302a:	c9                   	leave  
8010302b:	c3                   	ret    

8010302c <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010302c:	55                   	push   %ebp
8010302d:	89 e5                	mov    %esp,%ebp
8010302f:	8b 45 08             	mov    0x8(%ebp),%eax
80103032:	05 00 00 00 80       	add    $0x80000000,%eax
80103037:	5d                   	pop    %ebp
80103038:	c3                   	ret    

80103039 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80103039:	55                   	push   %ebp
8010303a:	89 e5                	mov    %esp,%ebp
8010303c:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 2a a4 10 80       	push   $0x8010a42a
80103047:	68 60 42 11 80       	push   $0x80114260
8010304c:	e8 5a 38 00 00       	call   801068ab <initlock>
80103051:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103054:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
8010305b:	00 00 00 
  freerange(vstart, vend);
8010305e:	83 ec 08             	sub    $0x8,%esp
80103061:	ff 75 0c             	pushl  0xc(%ebp)
80103064:	ff 75 08             	pushl  0x8(%ebp)
80103067:	e8 2a 00 00 00       	call   80103096 <freerange>
8010306c:	83 c4 10             	add    $0x10,%esp
}
8010306f:	90                   	nop
80103070:	c9                   	leave  
80103071:	c3                   	ret    

80103072 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80103072:	55                   	push   %ebp
80103073:	89 e5                	mov    %esp,%ebp
80103075:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80103078:	83 ec 08             	sub    $0x8,%esp
8010307b:	ff 75 0c             	pushl  0xc(%ebp)
8010307e:	ff 75 08             	pushl  0x8(%ebp)
80103081:	e8 10 00 00 00       	call   80103096 <freerange>
80103086:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80103089:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
80103090:	00 00 00 
}
80103093:	90                   	nop
80103094:	c9                   	leave  
80103095:	c3                   	ret    

80103096 <freerange>:

void
freerange(void *vstart, void *vend)
{
80103096:	55                   	push   %ebp
80103097:	89 e5                	mov    %esp,%ebp
80103099:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010309c:	8b 45 08             	mov    0x8(%ebp),%eax
8010309f:	05 ff 0f 00 00       	add    $0xfff,%eax
801030a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801030a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030ac:	eb 15                	jmp    801030c3 <freerange+0x2d>
    kfree(p);
801030ae:	83 ec 0c             	sub    $0xc,%esp
801030b1:	ff 75 f4             	pushl  -0xc(%ebp)
801030b4:	e8 1a 00 00 00       	call   801030d3 <kfree>
801030b9:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030c6:	05 00 10 00 00       	add    $0x1000,%eax
801030cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801030ce:	76 de                	jbe    801030ae <freerange+0x18>
    kfree(p);
}
801030d0:	90                   	nop
801030d1:	c9                   	leave  
801030d2:	c3                   	ret    

801030d3 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801030d3:	55                   	push   %ebp
801030d4:	89 e5                	mov    %esp,%ebp
801030d6:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801030d9:	8b 45 08             	mov    0x8(%ebp),%eax
801030dc:	25 ff 0f 00 00       	and    $0xfff,%eax
801030e1:	85 c0                	test   %eax,%eax
801030e3:	75 1b                	jne    80103100 <kfree+0x2d>
801030e5:	81 7d 08 5c 79 11 80 	cmpl   $0x8011795c,0x8(%ebp)
801030ec:	72 12                	jb     80103100 <kfree+0x2d>
801030ee:	ff 75 08             	pushl  0x8(%ebp)
801030f1:	e8 36 ff ff ff       	call   8010302c <v2p>
801030f6:	83 c4 04             	add    $0x4,%esp
801030f9:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801030fe:	76 0d                	jbe    8010310d <kfree+0x3a>
    panic("kfree");
80103100:	83 ec 0c             	sub    $0xc,%esp
80103103:	68 2f a4 10 80       	push   $0x8010a42f
80103108:	e8 59 d4 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010310d:	83 ec 04             	sub    $0x4,%esp
80103110:	68 00 10 00 00       	push   $0x1000
80103115:	6a 01                	push   $0x1
80103117:	ff 75 08             	pushl  0x8(%ebp)
8010311a:	e8 11 3a 00 00       	call   80106b30 <memset>
8010311f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80103122:	a1 94 42 11 80       	mov    0x80114294,%eax
80103127:	85 c0                	test   %eax,%eax
80103129:	74 10                	je     8010313b <kfree+0x68>
    acquire(&kmem.lock);
8010312b:	83 ec 0c             	sub    $0xc,%esp
8010312e:	68 60 42 11 80       	push   $0x80114260
80103133:	e8 95 37 00 00       	call   801068cd <acquire>
80103138:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
8010313b:	8b 45 08             	mov    0x8(%ebp),%eax
8010313e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80103141:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80103147:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010314a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
8010314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010314f:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80103154:	a1 94 42 11 80       	mov    0x80114294,%eax
80103159:	85 c0                	test   %eax,%eax
8010315b:	74 10                	je     8010316d <kfree+0x9a>
    release(&kmem.lock);
8010315d:	83 ec 0c             	sub    $0xc,%esp
80103160:	68 60 42 11 80       	push   $0x80114260
80103165:	e8 ca 37 00 00       	call   80106934 <release>
8010316a:	83 c4 10             	add    $0x10,%esp
}
8010316d:	90                   	nop
8010316e:	c9                   	leave  
8010316f:	c3                   	ret    

80103170 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80103176:	a1 94 42 11 80       	mov    0x80114294,%eax
8010317b:	85 c0                	test   %eax,%eax
8010317d:	74 10                	je     8010318f <kalloc+0x1f>
    acquire(&kmem.lock);
8010317f:	83 ec 0c             	sub    $0xc,%esp
80103182:	68 60 42 11 80       	push   $0x80114260
80103187:	e8 41 37 00 00       	call   801068cd <acquire>
8010318c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
8010318f:	a1 98 42 11 80       	mov    0x80114298,%eax
80103194:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80103197:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010319b:	74 0a                	je     801031a7 <kalloc+0x37>
    kmem.freelist = r->next;
8010319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031a0:	8b 00                	mov    (%eax),%eax
801031a2:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
801031a7:	a1 94 42 11 80       	mov    0x80114294,%eax
801031ac:	85 c0                	test   %eax,%eax
801031ae:	74 10                	je     801031c0 <kalloc+0x50>
    release(&kmem.lock);
801031b0:	83 ec 0c             	sub    $0xc,%esp
801031b3:	68 60 42 11 80       	push   $0x80114260
801031b8:	e8 77 37 00 00       	call   80106934 <release>
801031bd:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801031c3:	c9                   	leave  
801031c4:	c3                   	ret    

801031c5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801031c5:	55                   	push   %ebp
801031c6:	89 e5                	mov    %esp,%ebp
801031c8:	83 ec 14             	sub    $0x14,%esp
801031cb:	8b 45 08             	mov    0x8(%ebp),%eax
801031ce:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801031d6:	89 c2                	mov    %eax,%edx
801031d8:	ec                   	in     (%dx),%al
801031d9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801031dc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801031e0:	c9                   	leave  
801031e1:	c3                   	ret    

801031e2 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801031e2:	55                   	push   %ebp
801031e3:	89 e5                	mov    %esp,%ebp
801031e5:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
801031e8:	6a 64                	push   $0x64
801031ea:	e8 d6 ff ff ff       	call   801031c5 <inb>
801031ef:	83 c4 04             	add    $0x4,%esp
801031f2:	0f b6 c0             	movzbl %al,%eax
801031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
801031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031fb:	83 e0 01             	and    $0x1,%eax
801031fe:	85 c0                	test   %eax,%eax
80103200:	75 0a                	jne    8010320c <kbdgetc+0x2a>
    return -1;
80103202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103207:	e9 23 01 00 00       	jmp    8010332f <kbdgetc+0x14d>
  data = inb(KBDATAP);
8010320c:	6a 60                	push   $0x60
8010320e:	e8 b2 ff ff ff       	call   801031c5 <inb>
80103213:	83 c4 04             	add    $0x4,%esp
80103216:	0f b6 c0             	movzbl %al,%eax
80103219:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
8010321c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80103223:	75 17                	jne    8010323c <kbdgetc+0x5a>
    shift |= E0ESC;
80103225:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010322a:	83 c8 40             	or     $0x40,%eax
8010322d:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103232:	b8 00 00 00 00       	mov    $0x0,%eax
80103237:	e9 f3 00 00 00       	jmp    8010332f <kbdgetc+0x14d>
  } else if(data & 0x80){
8010323c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010323f:	25 80 00 00 00       	and    $0x80,%eax
80103244:	85 c0                	test   %eax,%eax
80103246:	74 45                	je     8010328d <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103248:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010324d:	83 e0 40             	and    $0x40,%eax
80103250:	85 c0                	test   %eax,%eax
80103252:	75 08                	jne    8010325c <kbdgetc+0x7a>
80103254:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103257:	83 e0 7f             	and    $0x7f,%eax
8010325a:	eb 03                	jmp    8010325f <kbdgetc+0x7d>
8010325c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010325f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80103262:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103265:	05 20 b0 10 80       	add    $0x8010b020,%eax
8010326a:	0f b6 00             	movzbl (%eax),%eax
8010326d:	83 c8 40             	or     $0x40,%eax
80103270:	0f b6 c0             	movzbl %al,%eax
80103273:	f7 d0                	not    %eax
80103275:	89 c2                	mov    %eax,%edx
80103277:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010327c:	21 d0                	and    %edx,%eax
8010327e:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103283:	b8 00 00 00 00       	mov    $0x0,%eax
80103288:	e9 a2 00 00 00       	jmp    8010332f <kbdgetc+0x14d>
  } else if(shift & E0ESC){
8010328d:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103292:	83 e0 40             	and    $0x40,%eax
80103295:	85 c0                	test   %eax,%eax
80103297:	74 14                	je     801032ad <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103299:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801032a0:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032a5:	83 e0 bf             	and    $0xffffffbf,%eax
801032a8:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
801032ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801032b0:	05 20 b0 10 80       	add    $0x8010b020,%eax
801032b5:	0f b6 00             	movzbl (%eax),%eax
801032b8:	0f b6 d0             	movzbl %al,%edx
801032bb:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032c0:	09 d0                	or     %edx,%eax
801032c2:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
801032c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801032ca:	05 20 b1 10 80       	add    $0x8010b120,%eax
801032cf:	0f b6 00             	movzbl (%eax),%eax
801032d2:	0f b6 d0             	movzbl %al,%edx
801032d5:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032da:	31 d0                	xor    %edx,%eax
801032dc:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
801032e1:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032e6:	83 e0 03             	and    $0x3,%eax
801032e9:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
801032f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801032f3:	01 d0                	add    %edx,%eax
801032f5:	0f b6 00             	movzbl (%eax),%eax
801032f8:	0f b6 c0             	movzbl %al,%eax
801032fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
801032fe:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103303:	83 e0 08             	and    $0x8,%eax
80103306:	85 c0                	test   %eax,%eax
80103308:	74 22                	je     8010332c <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010330a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010330e:	76 0c                	jbe    8010331c <kbdgetc+0x13a>
80103310:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80103314:	77 06                	ja     8010331c <kbdgetc+0x13a>
      c += 'A' - 'a';
80103316:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010331a:	eb 10                	jmp    8010332c <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010331c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80103320:	76 0a                	jbe    8010332c <kbdgetc+0x14a>
80103322:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80103326:	77 04                	ja     8010332c <kbdgetc+0x14a>
      c += 'a' - 'A';
80103328:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
8010332c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010332f:	c9                   	leave  
80103330:	c3                   	ret    

80103331 <kbdintr>:

void
kbdintr(void)
{
80103331:	55                   	push   %ebp
80103332:	89 e5                	mov    %esp,%ebp
80103334:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103337:	83 ec 0c             	sub    $0xc,%esp
8010333a:	68 e2 31 10 80       	push   $0x801031e2
8010333f:	e8 b5 d4 ff ff       	call   801007f9 <consoleintr>
80103344:	83 c4 10             	add    $0x10,%esp
}
80103347:	90                   	nop
80103348:	c9                   	leave  
80103349:	c3                   	ret    

8010334a <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010334a:	55                   	push   %ebp
8010334b:	89 e5                	mov    %esp,%ebp
8010334d:	83 ec 14             	sub    $0x14,%esp
80103350:	8b 45 08             	mov    0x8(%ebp),%eax
80103353:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103357:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010335b:	89 c2                	mov    %eax,%edx
8010335d:	ec                   	in     (%dx),%al
8010335e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103361:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103365:	c9                   	leave  
80103366:	c3                   	ret    

80103367 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103367:	55                   	push   %ebp
80103368:	89 e5                	mov    %esp,%ebp
8010336a:	83 ec 08             	sub    $0x8,%esp
8010336d:	8b 55 08             	mov    0x8(%ebp),%edx
80103370:	8b 45 0c             	mov    0xc(%ebp),%eax
80103373:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103377:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010337e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103382:	ee                   	out    %al,(%dx)
}
80103383:	90                   	nop
80103384:	c9                   	leave  
80103385:	c3                   	ret    

80103386 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103386:	55                   	push   %ebp
80103387:	89 e5                	mov    %esp,%ebp
80103389:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010338c:	9c                   	pushf  
8010338d:	58                   	pop    %eax
8010338e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103391:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103394:	c9                   	leave  
80103395:	c3                   	ret    

80103396 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103396:	55                   	push   %ebp
80103397:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103399:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010339e:	8b 55 08             	mov    0x8(%ebp),%edx
801033a1:	c1 e2 02             	shl    $0x2,%edx
801033a4:	01 c2                	add    %eax,%edx
801033a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801033a9:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801033ab:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801033b0:	83 c0 20             	add    $0x20,%eax
801033b3:	8b 00                	mov    (%eax),%eax
}
801033b5:	90                   	nop
801033b6:	5d                   	pop    %ebp
801033b7:	c3                   	ret    

801033b8 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
801033b8:	55                   	push   %ebp
801033b9:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801033bb:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801033c0:	85 c0                	test   %eax,%eax
801033c2:	0f 84 0b 01 00 00    	je     801034d3 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801033c8:	68 3f 01 00 00       	push   $0x13f
801033cd:	6a 3c                	push   $0x3c
801033cf:	e8 c2 ff ff ff       	call   80103396 <lapicw>
801033d4:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801033d7:	6a 0b                	push   $0xb
801033d9:	68 f8 00 00 00       	push   $0xf8
801033de:	e8 b3 ff ff ff       	call   80103396 <lapicw>
801033e3:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801033e6:	68 20 00 02 00       	push   $0x20020
801033eb:	68 c8 00 00 00       	push   $0xc8
801033f0:	e8 a1 ff ff ff       	call   80103396 <lapicw>
801033f5:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
801033f8:	68 80 96 98 00       	push   $0x989680
801033fd:	68 e0 00 00 00       	push   $0xe0
80103402:	e8 8f ff ff ff       	call   80103396 <lapicw>
80103407:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010340a:	68 00 00 01 00       	push   $0x10000
8010340f:	68 d4 00 00 00       	push   $0xd4
80103414:	e8 7d ff ff ff       	call   80103396 <lapicw>
80103419:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010341c:	68 00 00 01 00       	push   $0x10000
80103421:	68 d8 00 00 00       	push   $0xd8
80103426:	e8 6b ff ff ff       	call   80103396 <lapicw>
8010342b:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010342e:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103433:	83 c0 30             	add    $0x30,%eax
80103436:	8b 00                	mov    (%eax),%eax
80103438:	c1 e8 10             	shr    $0x10,%eax
8010343b:	0f b6 c0             	movzbl %al,%eax
8010343e:	83 f8 03             	cmp    $0x3,%eax
80103441:	76 12                	jbe    80103455 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103443:	68 00 00 01 00       	push   $0x10000
80103448:	68 d0 00 00 00       	push   $0xd0
8010344d:	e8 44 ff ff ff       	call   80103396 <lapicw>
80103452:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103455:	6a 33                	push   $0x33
80103457:	68 dc 00 00 00       	push   $0xdc
8010345c:	e8 35 ff ff ff       	call   80103396 <lapicw>
80103461:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103464:	6a 00                	push   $0x0
80103466:	68 a0 00 00 00       	push   $0xa0
8010346b:	e8 26 ff ff ff       	call   80103396 <lapicw>
80103470:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103473:	6a 00                	push   $0x0
80103475:	68 a0 00 00 00       	push   $0xa0
8010347a:	e8 17 ff ff ff       	call   80103396 <lapicw>
8010347f:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103482:	6a 00                	push   $0x0
80103484:	6a 2c                	push   $0x2c
80103486:	e8 0b ff ff ff       	call   80103396 <lapicw>
8010348b:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010348e:	6a 00                	push   $0x0
80103490:	68 c4 00 00 00       	push   $0xc4
80103495:	e8 fc fe ff ff       	call   80103396 <lapicw>
8010349a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010349d:	68 00 85 08 00       	push   $0x88500
801034a2:	68 c0 00 00 00       	push   $0xc0
801034a7:	e8 ea fe ff ff       	call   80103396 <lapicw>
801034ac:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801034af:	90                   	nop
801034b0:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801034b5:	05 00 03 00 00       	add    $0x300,%eax
801034ba:	8b 00                	mov    (%eax),%eax
801034bc:	25 00 10 00 00       	and    $0x1000,%eax
801034c1:	85 c0                	test   %eax,%eax
801034c3:	75 eb                	jne    801034b0 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801034c5:	6a 00                	push   $0x0
801034c7:	6a 20                	push   $0x20
801034c9:	e8 c8 fe ff ff       	call   80103396 <lapicw>
801034ce:	83 c4 08             	add    $0x8,%esp
801034d1:	eb 01                	jmp    801034d4 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
801034d3:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801034d4:	c9                   	leave  
801034d5:	c3                   	ret    

801034d6 <cpunum>:

int
cpunum(void)
{
801034d6:	55                   	push   %ebp
801034d7:	89 e5                	mov    %esp,%ebp
801034d9:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801034dc:	e8 a5 fe ff ff       	call   80103386 <readeflags>
801034e1:	25 00 02 00 00       	and    $0x200,%eax
801034e6:	85 c0                	test   %eax,%eax
801034e8:	74 26                	je     80103510 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
801034ea:	a1 80 d6 10 80       	mov    0x8010d680,%eax
801034ef:	8d 50 01             	lea    0x1(%eax),%edx
801034f2:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
801034f8:	85 c0                	test   %eax,%eax
801034fa:	75 14                	jne    80103510 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
801034fc:	8b 45 04             	mov    0x4(%ebp),%eax
801034ff:	83 ec 08             	sub    $0x8,%esp
80103502:	50                   	push   %eax
80103503:	68 38 a4 10 80       	push   $0x8010a438
80103508:	e8 b9 ce ff ff       	call   801003c6 <cprintf>
8010350d:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103510:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103515:	85 c0                	test   %eax,%eax
80103517:	74 0f                	je     80103528 <cpunum+0x52>
    return lapic[ID]>>24;
80103519:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010351e:	83 c0 20             	add    $0x20,%eax
80103521:	8b 00                	mov    (%eax),%eax
80103523:	c1 e8 18             	shr    $0x18,%eax
80103526:	eb 05                	jmp    8010352d <cpunum+0x57>
  return 0;
80103528:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010352d:	c9                   	leave  
8010352e:	c3                   	ret    

8010352f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010352f:	55                   	push   %ebp
80103530:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103532:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103537:	85 c0                	test   %eax,%eax
80103539:	74 0c                	je     80103547 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010353b:	6a 00                	push   $0x0
8010353d:	6a 2c                	push   $0x2c
8010353f:	e8 52 fe ff ff       	call   80103396 <lapicw>
80103544:	83 c4 08             	add    $0x8,%esp
}
80103547:	90                   	nop
80103548:	c9                   	leave  
80103549:	c3                   	ret    

8010354a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010354a:	55                   	push   %ebp
8010354b:	89 e5                	mov    %esp,%ebp
}
8010354d:	90                   	nop
8010354e:	5d                   	pop    %ebp
8010354f:	c3                   	ret    

80103550 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 14             	sub    $0x14,%esp
80103556:	8b 45 08             	mov    0x8(%ebp),%eax
80103559:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010355c:	6a 0f                	push   $0xf
8010355e:	6a 70                	push   $0x70
80103560:	e8 02 fe ff ff       	call   80103367 <outb>
80103565:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103568:	6a 0a                	push   $0xa
8010356a:	6a 71                	push   $0x71
8010356c:	e8 f6 fd ff ff       	call   80103367 <outb>
80103571:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103574:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010357b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010357e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103583:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103586:	83 c0 02             	add    $0x2,%eax
80103589:	8b 55 0c             	mov    0xc(%ebp),%edx
8010358c:	c1 ea 04             	shr    $0x4,%edx
8010358f:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103592:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103596:	c1 e0 18             	shl    $0x18,%eax
80103599:	50                   	push   %eax
8010359a:	68 c4 00 00 00       	push   $0xc4
8010359f:	e8 f2 fd ff ff       	call   80103396 <lapicw>
801035a4:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801035a7:	68 00 c5 00 00       	push   $0xc500
801035ac:	68 c0 00 00 00       	push   $0xc0
801035b1:	e8 e0 fd ff ff       	call   80103396 <lapicw>
801035b6:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801035b9:	68 c8 00 00 00       	push   $0xc8
801035be:	e8 87 ff ff ff       	call   8010354a <microdelay>
801035c3:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801035c6:	68 00 85 00 00       	push   $0x8500
801035cb:	68 c0 00 00 00       	push   $0xc0
801035d0:	e8 c1 fd ff ff       	call   80103396 <lapicw>
801035d5:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801035d8:	6a 64                	push   $0x64
801035da:	e8 6b ff ff ff       	call   8010354a <microdelay>
801035df:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801035e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801035e9:	eb 3d                	jmp    80103628 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801035eb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801035ef:	c1 e0 18             	shl    $0x18,%eax
801035f2:	50                   	push   %eax
801035f3:	68 c4 00 00 00       	push   $0xc4
801035f8:	e8 99 fd ff ff       	call   80103396 <lapicw>
801035fd:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
80103603:	c1 e8 0c             	shr    $0xc,%eax
80103606:	80 cc 06             	or     $0x6,%ah
80103609:	50                   	push   %eax
8010360a:	68 c0 00 00 00       	push   $0xc0
8010360f:	e8 82 fd ff ff       	call   80103396 <lapicw>
80103614:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103617:	68 c8 00 00 00       	push   $0xc8
8010361c:	e8 29 ff ff ff       	call   8010354a <microdelay>
80103621:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103624:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103628:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010362c:	7e bd                	jle    801035eb <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010362e:	90                   	nop
8010362f:	c9                   	leave  
80103630:	c3                   	ret    

80103631 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103631:	55                   	push   %ebp
80103632:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103634:	8b 45 08             	mov    0x8(%ebp),%eax
80103637:	0f b6 c0             	movzbl %al,%eax
8010363a:	50                   	push   %eax
8010363b:	6a 70                	push   $0x70
8010363d:	e8 25 fd ff ff       	call   80103367 <outb>
80103642:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103645:	68 c8 00 00 00       	push   $0xc8
8010364a:	e8 fb fe ff ff       	call   8010354a <microdelay>
8010364f:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103652:	6a 71                	push   $0x71
80103654:	e8 f1 fc ff ff       	call   8010334a <inb>
80103659:	83 c4 04             	add    $0x4,%esp
8010365c:	0f b6 c0             	movzbl %al,%eax
}
8010365f:	c9                   	leave  
80103660:	c3                   	ret    

80103661 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103661:	55                   	push   %ebp
80103662:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103664:	6a 00                	push   $0x0
80103666:	e8 c6 ff ff ff       	call   80103631 <cmos_read>
8010366b:	83 c4 04             	add    $0x4,%esp
8010366e:	89 c2                	mov    %eax,%edx
80103670:	8b 45 08             	mov    0x8(%ebp),%eax
80103673:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103675:	6a 02                	push   $0x2
80103677:	e8 b5 ff ff ff       	call   80103631 <cmos_read>
8010367c:	83 c4 04             	add    $0x4,%esp
8010367f:	89 c2                	mov    %eax,%edx
80103681:	8b 45 08             	mov    0x8(%ebp),%eax
80103684:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103687:	6a 04                	push   $0x4
80103689:	e8 a3 ff ff ff       	call   80103631 <cmos_read>
8010368e:	83 c4 04             	add    $0x4,%esp
80103691:	89 c2                	mov    %eax,%edx
80103693:	8b 45 08             	mov    0x8(%ebp),%eax
80103696:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103699:	6a 07                	push   $0x7
8010369b:	e8 91 ff ff ff       	call   80103631 <cmos_read>
801036a0:	83 c4 04             	add    $0x4,%esp
801036a3:	89 c2                	mov    %eax,%edx
801036a5:	8b 45 08             	mov    0x8(%ebp),%eax
801036a8:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801036ab:	6a 08                	push   $0x8
801036ad:	e8 7f ff ff ff       	call   80103631 <cmos_read>
801036b2:	83 c4 04             	add    $0x4,%esp
801036b5:	89 c2                	mov    %eax,%edx
801036b7:	8b 45 08             	mov    0x8(%ebp),%eax
801036ba:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801036bd:	6a 09                	push   $0x9
801036bf:	e8 6d ff ff ff       	call   80103631 <cmos_read>
801036c4:	83 c4 04             	add    $0x4,%esp
801036c7:	89 c2                	mov    %eax,%edx
801036c9:	8b 45 08             	mov    0x8(%ebp),%eax
801036cc:	89 50 14             	mov    %edx,0x14(%eax)
}
801036cf:	90                   	nop
801036d0:	c9                   	leave  
801036d1:	c3                   	ret    

801036d2 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801036d2:	55                   	push   %ebp
801036d3:	89 e5                	mov    %esp,%ebp
801036d5:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801036d8:	6a 0b                	push   $0xb
801036da:	e8 52 ff ff ff       	call   80103631 <cmos_read>
801036df:	83 c4 04             	add    $0x4,%esp
801036e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e8:	83 e0 04             	and    $0x4,%eax
801036eb:	85 c0                	test   %eax,%eax
801036ed:	0f 94 c0             	sete   %al
801036f0:	0f b6 c0             	movzbl %al,%eax
801036f3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801036f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801036f9:	50                   	push   %eax
801036fa:	e8 62 ff ff ff       	call   80103661 <fill_rtcdate>
801036ff:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103702:	6a 0a                	push   $0xa
80103704:	e8 28 ff ff ff       	call   80103631 <cmos_read>
80103709:	83 c4 04             	add    $0x4,%esp
8010370c:	25 80 00 00 00       	and    $0x80,%eax
80103711:	85 c0                	test   %eax,%eax
80103713:	75 27                	jne    8010373c <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103715:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103718:	50                   	push   %eax
80103719:	e8 43 ff ff ff       	call   80103661 <fill_rtcdate>
8010371e:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103721:	83 ec 04             	sub    $0x4,%esp
80103724:	6a 18                	push   $0x18
80103726:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103729:	50                   	push   %eax
8010372a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010372d:	50                   	push   %eax
8010372e:	e8 64 34 00 00       	call   80106b97 <memcmp>
80103733:	83 c4 10             	add    $0x10,%esp
80103736:	85 c0                	test   %eax,%eax
80103738:	74 05                	je     8010373f <cmostime+0x6d>
8010373a:	eb ba                	jmp    801036f6 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010373c:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010373d:	eb b7                	jmp    801036f6 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010373f:	90                   	nop
  }

  // convert
  if (bcd) {
80103740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103744:	0f 84 b4 00 00 00    	je     801037fe <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010374a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010374d:	c1 e8 04             	shr    $0x4,%eax
80103750:	89 c2                	mov    %eax,%edx
80103752:	89 d0                	mov    %edx,%eax
80103754:	c1 e0 02             	shl    $0x2,%eax
80103757:	01 d0                	add    %edx,%eax
80103759:	01 c0                	add    %eax,%eax
8010375b:	89 c2                	mov    %eax,%edx
8010375d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103760:	83 e0 0f             	and    $0xf,%eax
80103763:	01 d0                	add    %edx,%eax
80103765:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103768:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010376b:	c1 e8 04             	shr    $0x4,%eax
8010376e:	89 c2                	mov    %eax,%edx
80103770:	89 d0                	mov    %edx,%eax
80103772:	c1 e0 02             	shl    $0x2,%eax
80103775:	01 d0                	add    %edx,%eax
80103777:	01 c0                	add    %eax,%eax
80103779:	89 c2                	mov    %eax,%edx
8010377b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010377e:	83 e0 0f             	and    $0xf,%eax
80103781:	01 d0                	add    %edx,%eax
80103783:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103786:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103789:	c1 e8 04             	shr    $0x4,%eax
8010378c:	89 c2                	mov    %eax,%edx
8010378e:	89 d0                	mov    %edx,%eax
80103790:	c1 e0 02             	shl    $0x2,%eax
80103793:	01 d0                	add    %edx,%eax
80103795:	01 c0                	add    %eax,%eax
80103797:	89 c2                	mov    %eax,%edx
80103799:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010379c:	83 e0 0f             	and    $0xf,%eax
8010379f:	01 d0                	add    %edx,%eax
801037a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801037a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801037a7:	c1 e8 04             	shr    $0x4,%eax
801037aa:	89 c2                	mov    %eax,%edx
801037ac:	89 d0                	mov    %edx,%eax
801037ae:	c1 e0 02             	shl    $0x2,%eax
801037b1:	01 d0                	add    %edx,%eax
801037b3:	01 c0                	add    %eax,%eax
801037b5:	89 c2                	mov    %eax,%edx
801037b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801037ba:	83 e0 0f             	and    $0xf,%eax
801037bd:	01 d0                	add    %edx,%eax
801037bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801037c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801037c5:	c1 e8 04             	shr    $0x4,%eax
801037c8:	89 c2                	mov    %eax,%edx
801037ca:	89 d0                	mov    %edx,%eax
801037cc:	c1 e0 02             	shl    $0x2,%eax
801037cf:	01 d0                	add    %edx,%eax
801037d1:	01 c0                	add    %eax,%eax
801037d3:	89 c2                	mov    %eax,%edx
801037d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801037d8:	83 e0 0f             	and    $0xf,%eax
801037db:	01 d0                	add    %edx,%eax
801037dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801037e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037e3:	c1 e8 04             	shr    $0x4,%eax
801037e6:	89 c2                	mov    %eax,%edx
801037e8:	89 d0                	mov    %edx,%eax
801037ea:	c1 e0 02             	shl    $0x2,%eax
801037ed:	01 d0                	add    %edx,%eax
801037ef:	01 c0                	add    %eax,%eax
801037f1:	89 c2                	mov    %eax,%edx
801037f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037f6:	83 e0 0f             	and    $0xf,%eax
801037f9:	01 d0                	add    %edx,%eax
801037fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801037fe:	8b 45 08             	mov    0x8(%ebp),%eax
80103801:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103804:	89 10                	mov    %edx,(%eax)
80103806:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103809:	89 50 04             	mov    %edx,0x4(%eax)
8010380c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010380f:	89 50 08             	mov    %edx,0x8(%eax)
80103812:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103815:	89 50 0c             	mov    %edx,0xc(%eax)
80103818:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010381b:	89 50 10             	mov    %edx,0x10(%eax)
8010381e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103821:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103824:	8b 45 08             	mov    0x8(%ebp),%eax
80103827:	8b 40 14             	mov    0x14(%eax),%eax
8010382a:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103830:	8b 45 08             	mov    0x8(%ebp),%eax
80103833:	89 50 14             	mov    %edx,0x14(%eax)
}
80103836:	90                   	nop
80103837:	c9                   	leave  
80103838:	c3                   	ret    

80103839 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103839:	55                   	push   %ebp
8010383a:	89 e5                	mov    %esp,%ebp
8010383c:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010383f:	83 ec 08             	sub    $0x8,%esp
80103842:	68 64 a4 10 80       	push   $0x8010a464
80103847:	68 a0 42 11 80       	push   $0x801142a0
8010384c:	e8 5a 30 00 00       	call   801068ab <initlock>
80103851:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103854:	83 ec 08             	sub    $0x8,%esp
80103857:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010385a:	50                   	push   %eax
8010385b:	ff 75 08             	pushl  0x8(%ebp)
8010385e:	e8 65 dc ff ff       	call   801014c8 <readsb>
80103863:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103866:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103869:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
8010386e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103871:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
80103876:	8b 45 08             	mov    0x8(%ebp),%eax
80103879:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
8010387e:	e8 b2 01 00 00       	call   80103a35 <recover_from_log>
}
80103883:	90                   	nop
80103884:	c9                   	leave  
80103885:	c3                   	ret    

80103886 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103886:	55                   	push   %ebp
80103887:	89 e5                	mov    %esp,%ebp
80103889:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010388c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103893:	e9 95 00 00 00       	jmp    8010392d <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103898:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
8010389e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038a1:	01 d0                	add    %edx,%eax
801038a3:	83 c0 01             	add    $0x1,%eax
801038a6:	89 c2                	mov    %eax,%edx
801038a8:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801038ad:	83 ec 08             	sub    $0x8,%esp
801038b0:	52                   	push   %edx
801038b1:	50                   	push   %eax
801038b2:	e8 ff c8 ff ff       	call   801001b6 <bread>
801038b7:	83 c4 10             	add    $0x10,%esp
801038ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801038bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c0:	83 c0 10             	add    $0x10,%eax
801038c3:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801038ca:	89 c2                	mov    %eax,%edx
801038cc:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801038d1:	83 ec 08             	sub    $0x8,%esp
801038d4:	52                   	push   %edx
801038d5:	50                   	push   %eax
801038d6:	e8 db c8 ff ff       	call   801001b6 <bread>
801038db:	83 c4 10             	add    $0x10,%esp
801038de:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801038e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038e4:	8d 50 18             	lea    0x18(%eax),%edx
801038e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038ea:	83 c0 18             	add    $0x18,%eax
801038ed:	83 ec 04             	sub    $0x4,%esp
801038f0:	68 00 02 00 00       	push   $0x200
801038f5:	52                   	push   %edx
801038f6:	50                   	push   %eax
801038f7:	e8 f3 32 00 00       	call   80106bef <memmove>
801038fc:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801038ff:	83 ec 0c             	sub    $0xc,%esp
80103902:	ff 75 ec             	pushl  -0x14(%ebp)
80103905:	e8 e5 c8 ff ff       	call   801001ef <bwrite>
8010390a:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010390d:	83 ec 0c             	sub    $0xc,%esp
80103910:	ff 75 f0             	pushl  -0x10(%ebp)
80103913:	e8 16 c9 ff ff       	call   8010022e <brelse>
80103918:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010391b:	83 ec 0c             	sub    $0xc,%esp
8010391e:	ff 75 ec             	pushl  -0x14(%ebp)
80103921:	e8 08 c9 ff ff       	call   8010022e <brelse>
80103926:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103929:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010392d:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103932:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103935:	0f 8f 5d ff ff ff    	jg     80103898 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010393b:	90                   	nop
8010393c:	c9                   	leave  
8010393d:	c3                   	ret    

8010393e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010393e:	55                   	push   %ebp
8010393f:	89 e5                	mov    %esp,%ebp
80103941:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103944:	a1 d4 42 11 80       	mov    0x801142d4,%eax
80103949:	89 c2                	mov    %eax,%edx
8010394b:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103950:	83 ec 08             	sub    $0x8,%esp
80103953:	52                   	push   %edx
80103954:	50                   	push   %eax
80103955:	e8 5c c8 ff ff       	call   801001b6 <bread>
8010395a:	83 c4 10             	add    $0x10,%esp
8010395d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103963:	83 c0 18             	add    $0x18,%eax
80103966:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103969:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010396c:	8b 00                	mov    (%eax),%eax
8010396e:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
80103973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010397a:	eb 1b                	jmp    80103997 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010397c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010397f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103982:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103986:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103989:	83 c2 10             	add    $0x10,%edx
8010398c:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103993:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103997:	a1 e8 42 11 80       	mov    0x801142e8,%eax
8010399c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010399f:	7f db                	jg     8010397c <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801039a1:	83 ec 0c             	sub    $0xc,%esp
801039a4:	ff 75 f0             	pushl  -0x10(%ebp)
801039a7:	e8 82 c8 ff ff       	call   8010022e <brelse>
801039ac:	83 c4 10             	add    $0x10,%esp
}
801039af:	90                   	nop
801039b0:	c9                   	leave  
801039b1:	c3                   	ret    

801039b2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801039b2:	55                   	push   %ebp
801039b3:	89 e5                	mov    %esp,%ebp
801039b5:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801039b8:	a1 d4 42 11 80       	mov    0x801142d4,%eax
801039bd:	89 c2                	mov    %eax,%edx
801039bf:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801039c4:	83 ec 08             	sub    $0x8,%esp
801039c7:	52                   	push   %edx
801039c8:	50                   	push   %eax
801039c9:	e8 e8 c7 ff ff       	call   801001b6 <bread>
801039ce:	83 c4 10             	add    $0x10,%esp
801039d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801039d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d7:	83 c0 18             	add    $0x18,%eax
801039da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801039dd:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
801039e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039e6:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801039e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039ef:	eb 1b                	jmp    80103a0c <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f4:	83 c0 10             	add    $0x10,%eax
801039f7:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
801039fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a04:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103a08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a0c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a11:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a14:	7f db                	jg     801039f1 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103a16:	83 ec 0c             	sub    $0xc,%esp
80103a19:	ff 75 f0             	pushl  -0x10(%ebp)
80103a1c:	e8 ce c7 ff ff       	call   801001ef <bwrite>
80103a21:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103a24:	83 ec 0c             	sub    $0xc,%esp
80103a27:	ff 75 f0             	pushl  -0x10(%ebp)
80103a2a:	e8 ff c7 ff ff       	call   8010022e <brelse>
80103a2f:	83 c4 10             	add    $0x10,%esp
}
80103a32:	90                   	nop
80103a33:	c9                   	leave  
80103a34:	c3                   	ret    

80103a35 <recover_from_log>:

static void
recover_from_log(void)
{
80103a35:	55                   	push   %ebp
80103a36:	89 e5                	mov    %esp,%ebp
80103a38:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103a3b:	e8 fe fe ff ff       	call   8010393e <read_head>
  install_trans(); // if committed, copy from log to disk
80103a40:	e8 41 fe ff ff       	call   80103886 <install_trans>
  log.lh.n = 0;
80103a45:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103a4c:	00 00 00 
  write_head(); // clear the log
80103a4f:	e8 5e ff ff ff       	call   801039b2 <write_head>
}
80103a54:	90                   	nop
80103a55:	c9                   	leave  
80103a56:	c3                   	ret    

80103a57 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103a57:	55                   	push   %ebp
80103a58:	89 e5                	mov    %esp,%ebp
80103a5a:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103a5d:	83 ec 0c             	sub    $0xc,%esp
80103a60:	68 a0 42 11 80       	push   $0x801142a0
80103a65:	e8 63 2e 00 00       	call   801068cd <acquire>
80103a6a:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103a6d:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103a72:	85 c0                	test   %eax,%eax
80103a74:	74 17                	je     80103a8d <begin_op+0x36>
      sleep(&log, &log.lock);
80103a76:	83 ec 08             	sub    $0x8,%esp
80103a79:	68 a0 42 11 80       	push   $0x801142a0
80103a7e:	68 a0 42 11 80       	push   $0x801142a0
80103a83:	e8 a2 21 00 00       	call   80105c2a <sleep>
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	eb e0                	jmp    80103a6d <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103a8d:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
80103a93:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103a98:	8d 50 01             	lea    0x1(%eax),%edx
80103a9b:	89 d0                	mov    %edx,%eax
80103a9d:	c1 e0 02             	shl    $0x2,%eax
80103aa0:	01 d0                	add    %edx,%eax
80103aa2:	01 c0                	add    %eax,%eax
80103aa4:	01 c8                	add    %ecx,%eax
80103aa6:	83 f8 1e             	cmp    $0x1e,%eax
80103aa9:	7e 17                	jle    80103ac2 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103aab:	83 ec 08             	sub    $0x8,%esp
80103aae:	68 a0 42 11 80       	push   $0x801142a0
80103ab3:	68 a0 42 11 80       	push   $0x801142a0
80103ab8:	e8 6d 21 00 00       	call   80105c2a <sleep>
80103abd:	83 c4 10             	add    $0x10,%esp
80103ac0:	eb ab                	jmp    80103a6d <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103ac2:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103ac7:	83 c0 01             	add    $0x1,%eax
80103aca:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
80103acf:	83 ec 0c             	sub    $0xc,%esp
80103ad2:	68 a0 42 11 80       	push   $0x801142a0
80103ad7:	e8 58 2e 00 00       	call   80106934 <release>
80103adc:	83 c4 10             	add    $0x10,%esp
      break;
80103adf:	90                   	nop
    }
  }
}
80103ae0:	90                   	nop
80103ae1:	c9                   	leave  
80103ae2:	c3                   	ret    

80103ae3 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103ae3:	55                   	push   %ebp
80103ae4:	89 e5                	mov    %esp,%ebp
80103ae6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	68 a0 42 11 80       	push   $0x801142a0
80103af8:	e8 d0 2d 00 00       	call   801068cd <acquire>
80103afd:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103b00:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103b05:	83 e8 01             	sub    $0x1,%eax
80103b08:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
80103b0d:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103b12:	85 c0                	test   %eax,%eax
80103b14:	74 0d                	je     80103b23 <end_op+0x40>
    panic("log.committing");
80103b16:	83 ec 0c             	sub    $0xc,%esp
80103b19:	68 68 a4 10 80       	push   $0x8010a468
80103b1e:	e8 43 ca ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103b23:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103b28:	85 c0                	test   %eax,%eax
80103b2a:	75 13                	jne    80103b3f <end_op+0x5c>
    do_commit = 1;
80103b2c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103b33:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
80103b3a:	00 00 00 
80103b3d:	eb 10                	jmp    80103b4f <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103b3f:	83 ec 0c             	sub    $0xc,%esp
80103b42:	68 a0 42 11 80       	push   $0x801142a0
80103b47:	e8 b6 22 00 00       	call   80105e02 <wakeup>
80103b4c:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103b4f:	83 ec 0c             	sub    $0xc,%esp
80103b52:	68 a0 42 11 80       	push   $0x801142a0
80103b57:	e8 d8 2d 00 00       	call   80106934 <release>
80103b5c:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103b5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b63:	74 3f                	je     80103ba4 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103b65:	e8 f5 00 00 00       	call   80103c5f <commit>
    acquire(&log.lock);
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	68 a0 42 11 80       	push   $0x801142a0
80103b72:	e8 56 2d 00 00       	call   801068cd <acquire>
80103b77:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103b7a:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
80103b81:	00 00 00 
    wakeup(&log);
80103b84:	83 ec 0c             	sub    $0xc,%esp
80103b87:	68 a0 42 11 80       	push   $0x801142a0
80103b8c:	e8 71 22 00 00       	call   80105e02 <wakeup>
80103b91:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103b94:	83 ec 0c             	sub    $0xc,%esp
80103b97:	68 a0 42 11 80       	push   $0x801142a0
80103b9c:	e8 93 2d 00 00       	call   80106934 <release>
80103ba1:	83 c4 10             	add    $0x10,%esp
  }
}
80103ba4:	90                   	nop
80103ba5:	c9                   	leave  
80103ba6:	c3                   	ret    

80103ba7 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103ba7:	55                   	push   %ebp
80103ba8:	89 e5                	mov    %esp,%ebp
80103baa:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103bad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103bb4:	e9 95 00 00 00       	jmp    80103c4e <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103bb9:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
80103bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc2:	01 d0                	add    %edx,%eax
80103bc4:	83 c0 01             	add    $0x1,%eax
80103bc7:	89 c2                	mov    %eax,%edx
80103bc9:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103bce:	83 ec 08             	sub    $0x8,%esp
80103bd1:	52                   	push   %edx
80103bd2:	50                   	push   %eax
80103bd3:	e8 de c5 ff ff       	call   801001b6 <bread>
80103bd8:	83 c4 10             	add    $0x10,%esp
80103bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be1:	83 c0 10             	add    $0x10,%eax
80103be4:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103beb:	89 c2                	mov    %eax,%edx
80103bed:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103bf2:	83 ec 08             	sub    $0x8,%esp
80103bf5:	52                   	push   %edx
80103bf6:	50                   	push   %eax
80103bf7:	e8 ba c5 ff ff       	call   801001b6 <bread>
80103bfc:	83 c4 10             	add    $0x10,%esp
80103bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c05:	8d 50 18             	lea    0x18(%eax),%edx
80103c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c0b:	83 c0 18             	add    $0x18,%eax
80103c0e:	83 ec 04             	sub    $0x4,%esp
80103c11:	68 00 02 00 00       	push   $0x200
80103c16:	52                   	push   %edx
80103c17:	50                   	push   %eax
80103c18:	e8 d2 2f 00 00       	call   80106bef <memmove>
80103c1d:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	ff 75 f0             	pushl  -0x10(%ebp)
80103c26:	e8 c4 c5 ff ff       	call   801001ef <bwrite>
80103c2b:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103c2e:	83 ec 0c             	sub    $0xc,%esp
80103c31:	ff 75 ec             	pushl  -0x14(%ebp)
80103c34:	e8 f5 c5 ff ff       	call   8010022e <brelse>
80103c39:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103c3c:	83 ec 0c             	sub    $0xc,%esp
80103c3f:	ff 75 f0             	pushl  -0x10(%ebp)
80103c42:	e8 e7 c5 ff ff       	call   8010022e <brelse>
80103c47:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103c4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103c4e:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103c53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103c56:	0f 8f 5d ff ff ff    	jg     80103bb9 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103c5c:	90                   	nop
80103c5d:	c9                   	leave  
80103c5e:	c3                   	ret    

80103c5f <commit>:

static void
commit()
{
80103c5f:	55                   	push   %ebp
80103c60:	89 e5                	mov    %esp,%ebp
80103c62:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103c65:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	7e 1e                	jle    80103c8c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103c6e:	e8 34 ff ff ff       	call   80103ba7 <write_log>
    write_head();    // Write header to disk -- the real commit
80103c73:	e8 3a fd ff ff       	call   801039b2 <write_head>
    install_trans(); // Now install writes to home locations
80103c78:	e8 09 fc ff ff       	call   80103886 <install_trans>
    log.lh.n = 0; 
80103c7d:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103c84:	00 00 00 
    write_head();    // Erase the transaction from the log
80103c87:	e8 26 fd ff ff       	call   801039b2 <write_head>
  }
}
80103c8c:	90                   	nop
80103c8d:	c9                   	leave  
80103c8e:	c3                   	ret    

80103c8f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103c8f:	55                   	push   %ebp
80103c90:	89 e5                	mov    %esp,%ebp
80103c92:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103c95:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103c9a:	83 f8 1d             	cmp    $0x1d,%eax
80103c9d:	7f 12                	jg     80103cb1 <log_write+0x22>
80103c9f:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103ca4:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
80103caa:	83 ea 01             	sub    $0x1,%edx
80103cad:	39 d0                	cmp    %edx,%eax
80103caf:	7c 0d                	jl     80103cbe <log_write+0x2f>
    panic("too big a transaction");
80103cb1:	83 ec 0c             	sub    $0xc,%esp
80103cb4:	68 77 a4 10 80       	push   $0x8010a477
80103cb9:	e8 a8 c8 ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103cbe:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103cc3:	85 c0                	test   %eax,%eax
80103cc5:	7f 0d                	jg     80103cd4 <log_write+0x45>
    panic("log_write outside of trans");
80103cc7:	83 ec 0c             	sub    $0xc,%esp
80103cca:	68 8d a4 10 80       	push   $0x8010a48d
80103ccf:	e8 92 c8 ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 a0 42 11 80       	push   $0x801142a0
80103cdc:	e8 ec 2b 00 00       	call   801068cd <acquire>
80103ce1:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103ce4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ceb:	eb 1d                	jmp    80103d0a <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf0:	83 c0 10             	add    $0x10,%eax
80103cf3:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103cfa:	89 c2                	mov    %eax,%edx
80103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cff:	8b 40 08             	mov    0x8(%eax),%eax
80103d02:	39 c2                	cmp    %eax,%edx
80103d04:	74 10                	je     80103d16 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103d06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103d0a:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103d0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d12:	7f d9                	jg     80103ced <log_write+0x5e>
80103d14:	eb 01                	jmp    80103d17 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103d16:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103d17:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1a:	8b 40 08             	mov    0x8(%eax),%eax
80103d1d:	89 c2                	mov    %eax,%edx
80103d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d22:	83 c0 10             	add    $0x10,%eax
80103d25:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103d2c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103d31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d34:	75 0d                	jne    80103d43 <log_write+0xb4>
    log.lh.n++;
80103d36:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103d3b:	83 c0 01             	add    $0x1,%eax
80103d3e:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103d43:	8b 45 08             	mov    0x8(%ebp),%eax
80103d46:	8b 00                	mov    (%eax),%eax
80103d48:	83 c8 04             	or     $0x4,%eax
80103d4b:	89 c2                	mov    %eax,%edx
80103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d50:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103d52:	83 ec 0c             	sub    $0xc,%esp
80103d55:	68 a0 42 11 80       	push   $0x801142a0
80103d5a:	e8 d5 2b 00 00       	call   80106934 <release>
80103d5f:	83 c4 10             	add    $0x10,%esp
}
80103d62:	90                   	nop
80103d63:	c9                   	leave  
80103d64:	c3                   	ret    

80103d65 <v2p>:
80103d65:	55                   	push   %ebp
80103d66:	89 e5                	mov    %esp,%ebp
80103d68:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6b:	05 00 00 00 80       	add    $0x80000000,%eax
80103d70:	5d                   	pop    %ebp
80103d71:	c3                   	ret    

80103d72 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103d72:	55                   	push   %ebp
80103d73:	89 e5                	mov    %esp,%ebp
80103d75:	8b 45 08             	mov    0x8(%ebp),%eax
80103d78:	05 00 00 00 80       	add    $0x80000000,%eax
80103d7d:	5d                   	pop    %ebp
80103d7e:	c3                   	ret    

80103d7f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103d7f:	55                   	push   %ebp
80103d80:	89 e5                	mov    %esp,%ebp
80103d82:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103d85:	8b 55 08             	mov    0x8(%ebp),%edx
80103d88:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103d8e:	f0 87 02             	lock xchg %eax,(%edx)
80103d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103d97:	c9                   	leave  
80103d98:	c3                   	ret    

80103d99 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103d99:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103d9d:	83 e4 f0             	and    $0xfffffff0,%esp
80103da0:	ff 71 fc             	pushl  -0x4(%ecx)
80103da3:	55                   	push   %ebp
80103da4:	89 e5                	mov    %esp,%ebp
80103da6:	51                   	push   %ecx
80103da7:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103daa:	83 ec 08             	sub    $0x8,%esp
80103dad:	68 00 00 40 80       	push   $0x80400000
80103db2:	68 5c 79 11 80       	push   $0x8011795c
80103db7:	e8 7d f2 ff ff       	call   80103039 <kinit1>
80103dbc:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103dbf:	e8 ae 5c 00 00       	call   80109a72 <kvmalloc>
  mpinit();        // collect info about this machine
80103dc4:	e8 43 04 00 00       	call   8010420c <mpinit>
  lapicinit();
80103dc9:	e8 ea f5 ff ff       	call   801033b8 <lapicinit>
  seginit();       // set up segments
80103dce:	e8 48 56 00 00       	call   8010941b <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103dd3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103dd9:	0f b6 00             	movzbl (%eax),%eax
80103ddc:	0f b6 c0             	movzbl %al,%eax
80103ddf:	83 ec 08             	sub    $0x8,%esp
80103de2:	50                   	push   %eax
80103de3:	68 a8 a4 10 80       	push   $0x8010a4a8
80103de8:	e8 d9 c5 ff ff       	call   801003c6 <cprintf>
80103ded:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103df0:	e8 6d 06 00 00       	call   80104462 <picinit>
  ioapicinit();    // another interrupt controller
80103df5:	e8 34 f1 ff ff       	call   80102f2e <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103dfa:	e8 c0 cd ff ff       	call   80100bbf <consoleinit>
  uartinit();      // serial port
80103dff:	e8 73 49 00 00       	call   80108777 <uartinit>
  pinit();         // process table
80103e04:	e8 5d 0b 00 00       	call   80104966 <pinit>
  tvinit();        // trap vectors
80103e09:	e8 65 45 00 00       	call   80108373 <tvinit>
  binit();         // buffer cache
80103e0e:	e8 21 c2 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103e13:	e8 a1 d2 ff ff       	call   801010b9 <fileinit>
  ideinit();       // disk
80103e18:	e8 19 ed ff ff       	call   80102b36 <ideinit>
  if(!ismp)
80103e1d:	a1 84 43 11 80       	mov    0x80114384,%eax
80103e22:	85 c0                	test   %eax,%eax
80103e24:	75 05                	jne    80103e2b <main+0x92>
    timerinit();   // uniprocessor timer
80103e26:	e8 99 44 00 00       	call   801082c4 <timerinit>
  startothers();   // start other processors
80103e2b:	e8 7f 00 00 00       	call   80103eaf <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103e30:	83 ec 08             	sub    $0x8,%esp
80103e33:	68 00 00 00 8e       	push   $0x8e000000
80103e38:	68 00 00 40 80       	push   $0x80400000
80103e3d:	e8 30 f2 ff ff       	call   80103072 <kinit2>
80103e42:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103e45:	e8 4b 10 00 00       	call   80104e95 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103e4a:	e8 1a 00 00 00       	call   80103e69 <mpmain>

80103e4f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103e4f:	55                   	push   %ebp
80103e50:	89 e5                	mov    %esp,%ebp
80103e52:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103e55:	e8 30 5c 00 00       	call   80109a8a <switchkvm>
  seginit();
80103e5a:	e8 bc 55 00 00       	call   8010941b <seginit>
  lapicinit();
80103e5f:	e8 54 f5 ff ff       	call   801033b8 <lapicinit>
  mpmain();
80103e64:	e8 00 00 00 00       	call   80103e69 <mpmain>

80103e69 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103e69:	55                   	push   %ebp
80103e6a:	89 e5                	mov    %esp,%ebp
80103e6c:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103e6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103e75:	0f b6 00             	movzbl (%eax),%eax
80103e78:	0f b6 c0             	movzbl %al,%eax
80103e7b:	83 ec 08             	sub    $0x8,%esp
80103e7e:	50                   	push   %eax
80103e7f:	68 bf a4 10 80       	push   $0x8010a4bf
80103e84:	e8 3d c5 ff ff       	call   801003c6 <cprintf>
80103e89:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103e8c:	e8 43 46 00 00       	call   801084d4 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103e91:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103e97:	05 a8 00 00 00       	add    $0xa8,%eax
80103e9c:	83 ec 08             	sub    $0x8,%esp
80103e9f:	6a 01                	push   $0x1
80103ea1:	50                   	push   %eax
80103ea2:	e8 d8 fe ff ff       	call   80103d7f <xchg>
80103ea7:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103eaa:	e8 4f 19 00 00       	call   801057fe <scheduler>

80103eaf <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103eaf:	55                   	push   %ebp
80103eb0:	89 e5                	mov    %esp,%ebp
80103eb2:	53                   	push   %ebx
80103eb3:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103eb6:	68 00 70 00 00       	push   $0x7000
80103ebb:	e8 b2 fe ff ff       	call   80103d72 <p2v>
80103ec0:	83 c4 04             	add    $0x4,%esp
80103ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103ec6:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103ecb:	83 ec 04             	sub    $0x4,%esp
80103ece:	50                   	push   %eax
80103ecf:	68 4c d5 10 80       	push   $0x8010d54c
80103ed4:	ff 75 f0             	pushl  -0x10(%ebp)
80103ed7:	e8 13 2d 00 00       	call   80106bef <memmove>
80103edc:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103edf:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103ee6:	e9 90 00 00 00       	jmp    80103f7b <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103eeb:	e8 e6 f5 ff ff       	call   801034d6 <cpunum>
80103ef0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ef6:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103efb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103efe:	74 73                	je     80103f73 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103f00:	e8 6b f2 ff ff       	call   80103170 <kalloc>
80103f05:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f0b:	83 e8 04             	sub    $0x4,%eax
80103f0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103f11:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103f17:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f1c:	83 e8 08             	sub    $0x8,%eax
80103f1f:	c7 00 4f 3e 10 80    	movl   $0x80103e4f,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f28:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103f2b:	83 ec 0c             	sub    $0xc,%esp
80103f2e:	68 00 c0 10 80       	push   $0x8010c000
80103f33:	e8 2d fe ff ff       	call   80103d65 <v2p>
80103f38:	83 c4 10             	add    $0x10,%esp
80103f3b:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103f3d:	83 ec 0c             	sub    $0xc,%esp
80103f40:	ff 75 f0             	pushl  -0x10(%ebp)
80103f43:	e8 1d fe ff ff       	call   80103d65 <v2p>
80103f48:	83 c4 10             	add    $0x10,%esp
80103f4b:	89 c2                	mov    %eax,%edx
80103f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f50:	0f b6 00             	movzbl (%eax),%eax
80103f53:	0f b6 c0             	movzbl %al,%eax
80103f56:	83 ec 08             	sub    $0x8,%esp
80103f59:	52                   	push   %edx
80103f5a:	50                   	push   %eax
80103f5b:	e8 f0 f5 ff ff       	call   80103550 <lapicstartap>
80103f60:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103f63:	90                   	nop
80103f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f67:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103f6d:	85 c0                	test   %eax,%eax
80103f6f:	74 f3                	je     80103f64 <startothers+0xb5>
80103f71:	eb 01                	jmp    80103f74 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103f73:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103f74:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103f7b:	a1 80 49 11 80       	mov    0x80114980,%eax
80103f80:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f86:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103f8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103f8e:	0f 87 57 ff ff ff    	ja     80103eeb <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103f94:	90                   	nop
80103f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f98:	c9                   	leave  
80103f99:	c3                   	ret    

80103f9a <p2v>:
80103f9a:	55                   	push   %ebp
80103f9b:	89 e5                	mov    %esp,%ebp
80103f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa0:	05 00 00 00 80       	add    $0x80000000,%eax
80103fa5:	5d                   	pop    %ebp
80103fa6:	c3                   	ret    

80103fa7 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103fa7:	55                   	push   %ebp
80103fa8:	89 e5                	mov    %esp,%ebp
80103faa:	83 ec 14             	sub    $0x14,%esp
80103fad:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fb4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103fb8:	89 c2                	mov    %eax,%edx
80103fba:	ec                   	in     (%dx),%al
80103fbb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103fbe:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103fc2:	c9                   	leave  
80103fc3:	c3                   	ret    

80103fc4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
80103fc7:	83 ec 08             	sub    $0x8,%esp
80103fca:	8b 55 08             	mov    0x8(%ebp),%edx
80103fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103fd4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fd7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103fdb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103fdf:	ee                   	out    %al,(%dx)
}
80103fe0:	90                   	nop
80103fe1:	c9                   	leave  
80103fe2:	c3                   	ret    

80103fe3 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103fe3:	55                   	push   %ebp
80103fe4:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103fe6:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80103feb:	89 c2                	mov    %eax,%edx
80103fed:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
80103ff2:	29 c2                	sub    %eax,%edx
80103ff4:	89 d0                	mov    %edx,%eax
80103ff6:	c1 f8 02             	sar    $0x2,%eax
80103ff9:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103fff:	5d                   	pop    %ebp
80104000:	c3                   	ret    

80104001 <sum>:

static uchar
sum(uchar *addr, int len)
{
80104001:	55                   	push   %ebp
80104002:	89 e5                	mov    %esp,%ebp
80104004:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80104007:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010400e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104015:	eb 15                	jmp    8010402c <sum+0x2b>
    sum += addr[i];
80104017:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010401a:	8b 45 08             	mov    0x8(%ebp),%eax
8010401d:	01 d0                	add    %edx,%eax
8010401f:	0f b6 00             	movzbl (%eax),%eax
80104022:	0f b6 c0             	movzbl %al,%eax
80104025:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80104028:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010402c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010402f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80104032:	7c e3                	jl     80104017 <sum+0x16>
    sum += addr[i];
  return sum;
80104034:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104037:	c9                   	leave  
80104038:	c3                   	ret    

80104039 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104039:	55                   	push   %ebp
8010403a:	89 e5                	mov    %esp,%ebp
8010403c:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010403f:	ff 75 08             	pushl  0x8(%ebp)
80104042:	e8 53 ff ff ff       	call   80103f9a <p2v>
80104047:	83 c4 04             	add    $0x4,%esp
8010404a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
8010404d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104050:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104053:	01 d0                	add    %edx,%eax
80104055:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80104058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010405b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010405e:	eb 36                	jmp    80104096 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104060:	83 ec 04             	sub    $0x4,%esp
80104063:	6a 04                	push   $0x4
80104065:	68 d0 a4 10 80       	push   $0x8010a4d0
8010406a:	ff 75 f4             	pushl  -0xc(%ebp)
8010406d:	e8 25 2b 00 00       	call   80106b97 <memcmp>
80104072:	83 c4 10             	add    $0x10,%esp
80104075:	85 c0                	test   %eax,%eax
80104077:	75 19                	jne    80104092 <mpsearch1+0x59>
80104079:	83 ec 08             	sub    $0x8,%esp
8010407c:	6a 10                	push   $0x10
8010407e:	ff 75 f4             	pushl  -0xc(%ebp)
80104081:	e8 7b ff ff ff       	call   80104001 <sum>
80104086:	83 c4 10             	add    $0x10,%esp
80104089:	84 c0                	test   %al,%al
8010408b:	75 05                	jne    80104092 <mpsearch1+0x59>
      return (struct mp*)p;
8010408d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104090:	eb 11                	jmp    801040a3 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80104092:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80104096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104099:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010409c:	72 c2                	jb     80104060 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
8010409e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040a3:	c9                   	leave  
801040a4:	c3                   	ret    

801040a5 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801040a5:	55                   	push   %ebp
801040a6:	89 e5                	mov    %esp,%ebp
801040a8:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801040ab:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801040b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b5:	83 c0 0f             	add    $0xf,%eax
801040b8:	0f b6 00             	movzbl (%eax),%eax
801040bb:	0f b6 c0             	movzbl %al,%eax
801040be:	c1 e0 08             	shl    $0x8,%eax
801040c1:	89 c2                	mov    %eax,%edx
801040c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c6:	83 c0 0e             	add    $0xe,%eax
801040c9:	0f b6 00             	movzbl (%eax),%eax
801040cc:	0f b6 c0             	movzbl %al,%eax
801040cf:	09 d0                	or     %edx,%eax
801040d1:	c1 e0 04             	shl    $0x4,%eax
801040d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801040d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801040db:	74 21                	je     801040fe <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
801040dd:	83 ec 08             	sub    $0x8,%esp
801040e0:	68 00 04 00 00       	push   $0x400
801040e5:	ff 75 f0             	pushl  -0x10(%ebp)
801040e8:	e8 4c ff ff ff       	call   80104039 <mpsearch1>
801040ed:	83 c4 10             	add    $0x10,%esp
801040f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801040f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801040f7:	74 51                	je     8010414a <mpsearch+0xa5>
      return mp;
801040f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040fc:	eb 61                	jmp    8010415f <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801040fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104101:	83 c0 14             	add    $0x14,%eax
80104104:	0f b6 00             	movzbl (%eax),%eax
80104107:	0f b6 c0             	movzbl %al,%eax
8010410a:	c1 e0 08             	shl    $0x8,%eax
8010410d:	89 c2                	mov    %eax,%edx
8010410f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104112:	83 c0 13             	add    $0x13,%eax
80104115:	0f b6 00             	movzbl (%eax),%eax
80104118:	0f b6 c0             	movzbl %al,%eax
8010411b:	09 d0                	or     %edx,%eax
8010411d:	c1 e0 0a             	shl    $0xa,%eax
80104120:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80104123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104126:	2d 00 04 00 00       	sub    $0x400,%eax
8010412b:	83 ec 08             	sub    $0x8,%esp
8010412e:	68 00 04 00 00       	push   $0x400
80104133:	50                   	push   %eax
80104134:	e8 00 ff ff ff       	call   80104039 <mpsearch1>
80104139:	83 c4 10             	add    $0x10,%esp
8010413c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010413f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104143:	74 05                	je     8010414a <mpsearch+0xa5>
      return mp;
80104145:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104148:	eb 15                	jmp    8010415f <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
8010414a:	83 ec 08             	sub    $0x8,%esp
8010414d:	68 00 00 01 00       	push   $0x10000
80104152:	68 00 00 0f 00       	push   $0xf0000
80104157:	e8 dd fe ff ff       	call   80104039 <mpsearch1>
8010415c:	83 c4 10             	add    $0x10,%esp
}
8010415f:	c9                   	leave  
80104160:	c3                   	ret    

80104161 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80104161:	55                   	push   %ebp
80104162:	89 e5                	mov    %esp,%ebp
80104164:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104167:	e8 39 ff ff ff       	call   801040a5 <mpsearch>
8010416c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010416f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104173:	74 0a                	je     8010417f <mpconfig+0x1e>
80104175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104178:	8b 40 04             	mov    0x4(%eax),%eax
8010417b:	85 c0                	test   %eax,%eax
8010417d:	75 0a                	jne    80104189 <mpconfig+0x28>
    return 0;
8010417f:	b8 00 00 00 00       	mov    $0x0,%eax
80104184:	e9 81 00 00 00       	jmp    8010420a <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80104189:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418c:	8b 40 04             	mov    0x4(%eax),%eax
8010418f:	83 ec 0c             	sub    $0xc,%esp
80104192:	50                   	push   %eax
80104193:	e8 02 fe ff ff       	call   80103f9a <p2v>
80104198:	83 c4 10             	add    $0x10,%esp
8010419b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010419e:	83 ec 04             	sub    $0x4,%esp
801041a1:	6a 04                	push   $0x4
801041a3:	68 d5 a4 10 80       	push   $0x8010a4d5
801041a8:	ff 75 f0             	pushl  -0x10(%ebp)
801041ab:	e8 e7 29 00 00       	call   80106b97 <memcmp>
801041b0:	83 c4 10             	add    $0x10,%esp
801041b3:	85 c0                	test   %eax,%eax
801041b5:	74 07                	je     801041be <mpconfig+0x5d>
    return 0;
801041b7:	b8 00 00 00 00       	mov    $0x0,%eax
801041bc:	eb 4c                	jmp    8010420a <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
801041be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041c1:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801041c5:	3c 01                	cmp    $0x1,%al
801041c7:	74 12                	je     801041db <mpconfig+0x7a>
801041c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041cc:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801041d0:	3c 04                	cmp    $0x4,%al
801041d2:	74 07                	je     801041db <mpconfig+0x7a>
    return 0;
801041d4:	b8 00 00 00 00       	mov    $0x0,%eax
801041d9:	eb 2f                	jmp    8010420a <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
801041db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041de:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801041e2:	0f b7 c0             	movzwl %ax,%eax
801041e5:	83 ec 08             	sub    $0x8,%esp
801041e8:	50                   	push   %eax
801041e9:	ff 75 f0             	pushl  -0x10(%ebp)
801041ec:	e8 10 fe ff ff       	call   80104001 <sum>
801041f1:	83 c4 10             	add    $0x10,%esp
801041f4:	84 c0                	test   %al,%al
801041f6:	74 07                	je     801041ff <mpconfig+0x9e>
    return 0;
801041f8:	b8 00 00 00 00       	mov    $0x0,%eax
801041fd:	eb 0b                	jmp    8010420a <mpconfig+0xa9>
  *pmp = mp;
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104205:	89 10                	mov    %edx,(%eax)
  return conf;
80104207:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010420a:	c9                   	leave  
8010420b:	c3                   	ret    

8010420c <mpinit>:

void
mpinit(void)
{
8010420c:	55                   	push   %ebp
8010420d:	89 e5                	mov    %esp,%ebp
8010420f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80104212:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80104219:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
8010421c:	83 ec 0c             	sub    $0xc,%esp
8010421f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104222:	50                   	push   %eax
80104223:	e8 39 ff ff ff       	call   80104161 <mpconfig>
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010422e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104232:	0f 84 96 01 00 00    	je     801043ce <mpinit+0x1c2>
    return;
  ismp = 1;
80104238:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
8010423f:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104242:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104245:	8b 40 24             	mov    0x24(%eax),%eax
80104248:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010424d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104250:	83 c0 2c             	add    $0x2c,%eax
80104253:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104259:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010425d:	0f b7 d0             	movzwl %ax,%edx
80104260:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104263:	01 d0                	add    %edx,%eax
80104265:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104268:	e9 f2 00 00 00       	jmp    8010435f <mpinit+0x153>
    switch(*p){
8010426d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104270:	0f b6 00             	movzbl (%eax),%eax
80104273:	0f b6 c0             	movzbl %al,%eax
80104276:	83 f8 04             	cmp    $0x4,%eax
80104279:	0f 87 bc 00 00 00    	ja     8010433b <mpinit+0x12f>
8010427f:	8b 04 85 18 a5 10 80 	mov    -0x7fef5ae8(,%eax,4),%eax
80104286:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010428e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104291:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104295:	0f b6 d0             	movzbl %al,%edx
80104298:	a1 80 49 11 80       	mov    0x80114980,%eax
8010429d:	39 c2                	cmp    %eax,%edx
8010429f:	74 2b                	je     801042cc <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801042a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042a4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801042a8:	0f b6 d0             	movzbl %al,%edx
801042ab:	a1 80 49 11 80       	mov    0x80114980,%eax
801042b0:	83 ec 04             	sub    $0x4,%esp
801042b3:	52                   	push   %edx
801042b4:	50                   	push   %eax
801042b5:	68 da a4 10 80       	push   $0x8010a4da
801042ba:	e8 07 c1 ff ff       	call   801003c6 <cprintf>
801042bf:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
801042c2:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
801042c9:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801042cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042cf:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801042d3:	0f b6 c0             	movzbl %al,%eax
801042d6:	83 e0 02             	and    $0x2,%eax
801042d9:	85 c0                	test   %eax,%eax
801042db:	74 15                	je     801042f2 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
801042dd:	a1 80 49 11 80       	mov    0x80114980,%eax
801042e2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801042e8:	05 a0 43 11 80       	add    $0x801143a0,%eax
801042ed:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
801042f2:	a1 80 49 11 80       	mov    0x80114980,%eax
801042f7:	8b 15 80 49 11 80    	mov    0x80114980,%edx
801042fd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104303:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104308:	88 10                	mov    %dl,(%eax)
      ncpu++;
8010430a:	a1 80 49 11 80       	mov    0x80114980,%eax
8010430f:	83 c0 01             	add    $0x1,%eax
80104312:	a3 80 49 11 80       	mov    %eax,0x80114980
      p += sizeof(struct mpproc);
80104317:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010431b:	eb 42                	jmp    8010435f <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010431d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104326:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010432a:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
8010432f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104333:	eb 2a                	jmp    8010435f <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104335:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104339:	eb 24                	jmp    8010435f <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433e:	0f b6 00             	movzbl (%eax),%eax
80104341:	0f b6 c0             	movzbl %al,%eax
80104344:	83 ec 08             	sub    $0x8,%esp
80104347:	50                   	push   %eax
80104348:	68 f8 a4 10 80       	push   $0x8010a4f8
8010434d:	e8 74 c0 ff ff       	call   801003c6 <cprintf>
80104352:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104355:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
8010435c:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104362:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104365:	0f 82 02 ff ff ff    	jb     8010426d <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
8010436b:	a1 84 43 11 80       	mov    0x80114384,%eax
80104370:	85 c0                	test   %eax,%eax
80104372:	75 1d                	jne    80104391 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104374:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
8010437b:	00 00 00 
    lapic = 0;
8010437e:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
80104385:	00 00 00 
    ioapicid = 0;
80104388:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
8010438f:	eb 3e                	jmp    801043cf <mpinit+0x1c3>
  }

  if(mp->imcrp){
80104391:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104394:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104398:	84 c0                	test   %al,%al
8010439a:	74 33                	je     801043cf <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010439c:	83 ec 08             	sub    $0x8,%esp
8010439f:	6a 70                	push   $0x70
801043a1:	6a 22                	push   $0x22
801043a3:	e8 1c fc ff ff       	call   80103fc4 <outb>
801043a8:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	6a 23                	push   $0x23
801043b0:	e8 f2 fb ff ff       	call   80103fa7 <inb>
801043b5:	83 c4 10             	add    $0x10,%esp
801043b8:	83 c8 01             	or     $0x1,%eax
801043bb:	0f b6 c0             	movzbl %al,%eax
801043be:	83 ec 08             	sub    $0x8,%esp
801043c1:	50                   	push   %eax
801043c2:	6a 23                	push   $0x23
801043c4:	e8 fb fb ff ff       	call   80103fc4 <outb>
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	eb 01                	jmp    801043cf <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801043ce:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801043cf:	c9                   	leave  
801043d0:	c3                   	ret    

801043d1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801043d1:	55                   	push   %ebp
801043d2:	89 e5                	mov    %esp,%ebp
801043d4:	83 ec 08             	sub    $0x8,%esp
801043d7:	8b 55 08             	mov    0x8(%ebp),%edx
801043da:	8b 45 0c             	mov    0xc(%ebp),%eax
801043dd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801043e1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801043e4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801043e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801043ec:	ee                   	out    %al,(%dx)
}
801043ed:	90                   	nop
801043ee:	c9                   	leave  
801043ef:	c3                   	ret    

801043f0 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	83 ec 04             	sub    $0x4,%esp
801043f6:	8b 45 08             	mov    0x8(%ebp),%eax
801043f9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801043fd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104401:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104407:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010440b:	0f b6 c0             	movzbl %al,%eax
8010440e:	50                   	push   %eax
8010440f:	6a 21                	push   $0x21
80104411:	e8 bb ff ff ff       	call   801043d1 <outb>
80104416:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104419:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010441d:	66 c1 e8 08          	shr    $0x8,%ax
80104421:	0f b6 c0             	movzbl %al,%eax
80104424:	50                   	push   %eax
80104425:	68 a1 00 00 00       	push   $0xa1
8010442a:	e8 a2 ff ff ff       	call   801043d1 <outb>
8010442f:	83 c4 08             	add    $0x8,%esp
}
80104432:	90                   	nop
80104433:	c9                   	leave  
80104434:	c3                   	ret    

80104435 <picenable>:

void
picenable(int irq)
{
80104435:	55                   	push   %ebp
80104436:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104438:	8b 45 08             	mov    0x8(%ebp),%eax
8010443b:	ba 01 00 00 00       	mov    $0x1,%edx
80104440:	89 c1                	mov    %eax,%ecx
80104442:	d3 e2                	shl    %cl,%edx
80104444:	89 d0                	mov    %edx,%eax
80104446:	f7 d0                	not    %eax
80104448:	89 c2                	mov    %eax,%edx
8010444a:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104451:	21 d0                	and    %edx,%eax
80104453:	0f b7 c0             	movzwl %ax,%eax
80104456:	50                   	push   %eax
80104457:	e8 94 ff ff ff       	call   801043f0 <picsetmask>
8010445c:	83 c4 04             	add    $0x4,%esp
}
8010445f:	90                   	nop
80104460:	c9                   	leave  
80104461:	c3                   	ret    

80104462 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104462:	55                   	push   %ebp
80104463:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104465:	68 ff 00 00 00       	push   $0xff
8010446a:	6a 21                	push   $0x21
8010446c:	e8 60 ff ff ff       	call   801043d1 <outb>
80104471:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104474:	68 ff 00 00 00       	push   $0xff
80104479:	68 a1 00 00 00       	push   $0xa1
8010447e:	e8 4e ff ff ff       	call   801043d1 <outb>
80104483:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104486:	6a 11                	push   $0x11
80104488:	6a 20                	push   $0x20
8010448a:	e8 42 ff ff ff       	call   801043d1 <outb>
8010448f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104492:	6a 20                	push   $0x20
80104494:	6a 21                	push   $0x21
80104496:	e8 36 ff ff ff       	call   801043d1 <outb>
8010449b:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010449e:	6a 04                	push   $0x4
801044a0:	6a 21                	push   $0x21
801044a2:	e8 2a ff ff ff       	call   801043d1 <outb>
801044a7:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801044aa:	6a 03                	push   $0x3
801044ac:	6a 21                	push   $0x21
801044ae:	e8 1e ff ff ff       	call   801043d1 <outb>
801044b3:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801044b6:	6a 11                	push   $0x11
801044b8:	68 a0 00 00 00       	push   $0xa0
801044bd:	e8 0f ff ff ff       	call   801043d1 <outb>
801044c2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801044c5:	6a 28                	push   $0x28
801044c7:	68 a1 00 00 00       	push   $0xa1
801044cc:	e8 00 ff ff ff       	call   801043d1 <outb>
801044d1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801044d4:	6a 02                	push   $0x2
801044d6:	68 a1 00 00 00       	push   $0xa1
801044db:	e8 f1 fe ff ff       	call   801043d1 <outb>
801044e0:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801044e3:	6a 03                	push   $0x3
801044e5:	68 a1 00 00 00       	push   $0xa1
801044ea:	e8 e2 fe ff ff       	call   801043d1 <outb>
801044ef:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801044f2:	6a 68                	push   $0x68
801044f4:	6a 20                	push   $0x20
801044f6:	e8 d6 fe ff ff       	call   801043d1 <outb>
801044fb:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801044fe:	6a 0a                	push   $0xa
80104500:	6a 20                	push   $0x20
80104502:	e8 ca fe ff ff       	call   801043d1 <outb>
80104507:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010450a:	6a 68                	push   $0x68
8010450c:	68 a0 00 00 00       	push   $0xa0
80104511:	e8 bb fe ff ff       	call   801043d1 <outb>
80104516:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104519:	6a 0a                	push   $0xa
8010451b:	68 a0 00 00 00       	push   $0xa0
80104520:	e8 ac fe ff ff       	call   801043d1 <outb>
80104525:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104528:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010452f:	66 83 f8 ff          	cmp    $0xffff,%ax
80104533:	74 13                	je     80104548 <picinit+0xe6>
    picsetmask(irqmask);
80104535:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010453c:	0f b7 c0             	movzwl %ax,%eax
8010453f:	50                   	push   %eax
80104540:	e8 ab fe ff ff       	call   801043f0 <picsetmask>
80104545:	83 c4 04             	add    $0x4,%esp
}
80104548:	90                   	nop
80104549:	c9                   	leave  
8010454a:	c3                   	ret    

8010454b <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010454b:	55                   	push   %ebp
8010454c:	89 e5                	mov    %esp,%ebp
8010454e:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104558:	8b 45 0c             	mov    0xc(%ebp),%eax
8010455b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104561:	8b 45 0c             	mov    0xc(%ebp),%eax
80104564:	8b 10                	mov    (%eax),%edx
80104566:	8b 45 08             	mov    0x8(%ebp),%eax
80104569:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010456b:	e8 67 cb ff ff       	call   801010d7 <filealloc>
80104570:	89 c2                	mov    %eax,%edx
80104572:	8b 45 08             	mov    0x8(%ebp),%eax
80104575:	89 10                	mov    %edx,(%eax)
80104577:	8b 45 08             	mov    0x8(%ebp),%eax
8010457a:	8b 00                	mov    (%eax),%eax
8010457c:	85 c0                	test   %eax,%eax
8010457e:	0f 84 cb 00 00 00    	je     8010464f <pipealloc+0x104>
80104584:	e8 4e cb ff ff       	call   801010d7 <filealloc>
80104589:	89 c2                	mov    %eax,%edx
8010458b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010458e:	89 10                	mov    %edx,(%eax)
80104590:	8b 45 0c             	mov    0xc(%ebp),%eax
80104593:	8b 00                	mov    (%eax),%eax
80104595:	85 c0                	test   %eax,%eax
80104597:	0f 84 b2 00 00 00    	je     8010464f <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010459d:	e8 ce eb ff ff       	call   80103170 <kalloc>
801045a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045a9:	0f 84 9f 00 00 00    	je     8010464e <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b2:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801045b9:	00 00 00 
  p->writeopen = 1;
801045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bf:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801045c6:	00 00 00 
  p->nwrite = 0;
801045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cc:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801045d3:	00 00 00 
  p->nread = 0;
801045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801045e0:	00 00 00 
  initlock(&p->lock, "pipe");
801045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e6:	83 ec 08             	sub    $0x8,%esp
801045e9:	68 2c a5 10 80       	push   $0x8010a52c
801045ee:	50                   	push   %eax
801045ef:	e8 b7 22 00 00       	call   801068ab <initlock>
801045f4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801045f7:	8b 45 08             	mov    0x8(%ebp),%eax
801045fa:	8b 00                	mov    (%eax),%eax
801045fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104602:	8b 45 08             	mov    0x8(%ebp),%eax
80104605:	8b 00                	mov    (%eax),%eax
80104607:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010460b:	8b 45 08             	mov    0x8(%ebp),%eax
8010460e:	8b 00                	mov    (%eax),%eax
80104610:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104614:	8b 45 08             	mov    0x8(%ebp),%eax
80104617:	8b 00                	mov    (%eax),%eax
80104619:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010461c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010461f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104622:	8b 00                	mov    (%eax),%eax
80104624:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010462a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010462d:	8b 00                	mov    (%eax),%eax
8010462f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104633:	8b 45 0c             	mov    0xc(%ebp),%eax
80104636:	8b 00                	mov    (%eax),%eax
80104638:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010463c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463f:	8b 00                	mov    (%eax),%eax
80104641:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104644:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104647:	b8 00 00 00 00       	mov    $0x0,%eax
8010464c:	eb 4e                	jmp    8010469c <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010464e:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
8010464f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104653:	74 0e                	je     80104663 <pipealloc+0x118>
    kfree((char*)p);
80104655:	83 ec 0c             	sub    $0xc,%esp
80104658:	ff 75 f4             	pushl  -0xc(%ebp)
8010465b:	e8 73 ea ff ff       	call   801030d3 <kfree>
80104660:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104663:	8b 45 08             	mov    0x8(%ebp),%eax
80104666:	8b 00                	mov    (%eax),%eax
80104668:	85 c0                	test   %eax,%eax
8010466a:	74 11                	je     8010467d <pipealloc+0x132>
    fileclose(*f0);
8010466c:	8b 45 08             	mov    0x8(%ebp),%eax
8010466f:	8b 00                	mov    (%eax),%eax
80104671:	83 ec 0c             	sub    $0xc,%esp
80104674:	50                   	push   %eax
80104675:	e8 1b cb ff ff       	call   80101195 <fileclose>
8010467a:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010467d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104680:	8b 00                	mov    (%eax),%eax
80104682:	85 c0                	test   %eax,%eax
80104684:	74 11                	je     80104697 <pipealloc+0x14c>
    fileclose(*f1);
80104686:	8b 45 0c             	mov    0xc(%ebp),%eax
80104689:	8b 00                	mov    (%eax),%eax
8010468b:	83 ec 0c             	sub    $0xc,%esp
8010468e:	50                   	push   %eax
8010468f:	e8 01 cb ff ff       	call   80101195 <fileclose>
80104694:	83 c4 10             	add    $0x10,%esp
  return -1;
80104697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010469c:	c9                   	leave  
8010469d:	c3                   	ret    

8010469e <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010469e:	55                   	push   %ebp
8010469f:	89 e5                	mov    %esp,%ebp
801046a1:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801046a4:	8b 45 08             	mov    0x8(%ebp),%eax
801046a7:	83 ec 0c             	sub    $0xc,%esp
801046aa:	50                   	push   %eax
801046ab:	e8 1d 22 00 00       	call   801068cd <acquire>
801046b0:	83 c4 10             	add    $0x10,%esp
  if(writable){
801046b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801046b7:	74 23                	je     801046dc <pipeclose+0x3e>
    p->writeopen = 0;
801046b9:	8b 45 08             	mov    0x8(%ebp),%eax
801046bc:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801046c3:	00 00 00 
    wakeup(&p->nread);
801046c6:	8b 45 08             	mov    0x8(%ebp),%eax
801046c9:	05 34 02 00 00       	add    $0x234,%eax
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	50                   	push   %eax
801046d2:	e8 2b 17 00 00       	call   80105e02 <wakeup>
801046d7:	83 c4 10             	add    $0x10,%esp
801046da:	eb 21                	jmp    801046fd <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801046dc:	8b 45 08             	mov    0x8(%ebp),%eax
801046df:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801046e6:	00 00 00 
    wakeup(&p->nwrite);
801046e9:	8b 45 08             	mov    0x8(%ebp),%eax
801046ec:	05 38 02 00 00       	add    $0x238,%eax
801046f1:	83 ec 0c             	sub    $0xc,%esp
801046f4:	50                   	push   %eax
801046f5:	e8 08 17 00 00       	call   80105e02 <wakeup>
801046fa:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801046fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104700:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104706:	85 c0                	test   %eax,%eax
80104708:	75 2c                	jne    80104736 <pipeclose+0x98>
8010470a:	8b 45 08             	mov    0x8(%ebp),%eax
8010470d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104713:	85 c0                	test   %eax,%eax
80104715:	75 1f                	jne    80104736 <pipeclose+0x98>
    release(&p->lock);
80104717:	8b 45 08             	mov    0x8(%ebp),%eax
8010471a:	83 ec 0c             	sub    $0xc,%esp
8010471d:	50                   	push   %eax
8010471e:	e8 11 22 00 00       	call   80106934 <release>
80104723:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104726:	83 ec 0c             	sub    $0xc,%esp
80104729:	ff 75 08             	pushl  0x8(%ebp)
8010472c:	e8 a2 e9 ff ff       	call   801030d3 <kfree>
80104731:	83 c4 10             	add    $0x10,%esp
80104734:	eb 0f                	jmp    80104745 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104736:	8b 45 08             	mov    0x8(%ebp),%eax
80104739:	83 ec 0c             	sub    $0xc,%esp
8010473c:	50                   	push   %eax
8010473d:	e8 f2 21 00 00       	call   80106934 <release>
80104742:	83 c4 10             	add    $0x10,%esp
}
80104745:	90                   	nop
80104746:	c9                   	leave  
80104747:	c3                   	ret    

80104748 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104748:	55                   	push   %ebp
80104749:	89 e5                	mov    %esp,%ebp
8010474b:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010474e:	8b 45 08             	mov    0x8(%ebp),%eax
80104751:	83 ec 0c             	sub    $0xc,%esp
80104754:	50                   	push   %eax
80104755:	e8 73 21 00 00       	call   801068cd <acquire>
8010475a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010475d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104764:	e9 ad 00 00 00       	jmp    80104816 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104769:	8b 45 08             	mov    0x8(%ebp),%eax
8010476c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104772:	85 c0                	test   %eax,%eax
80104774:	74 0d                	je     80104783 <pipewrite+0x3b>
80104776:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477c:	8b 40 2c             	mov    0x2c(%eax),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	74 19                	je     8010479c <pipewrite+0x54>
        release(&p->lock);
80104783:	8b 45 08             	mov    0x8(%ebp),%eax
80104786:	83 ec 0c             	sub    $0xc,%esp
80104789:	50                   	push   %eax
8010478a:	e8 a5 21 00 00       	call   80106934 <release>
8010478f:	83 c4 10             	add    $0x10,%esp
        return -1;
80104792:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104797:	e9 a8 00 00 00       	jmp    80104844 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
8010479c:	8b 45 08             	mov    0x8(%ebp),%eax
8010479f:	05 34 02 00 00       	add    $0x234,%eax
801047a4:	83 ec 0c             	sub    $0xc,%esp
801047a7:	50                   	push   %eax
801047a8:	e8 55 16 00 00       	call   80105e02 <wakeup>
801047ad:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801047b0:	8b 45 08             	mov    0x8(%ebp),%eax
801047b3:	8b 55 08             	mov    0x8(%ebp),%edx
801047b6:	81 c2 38 02 00 00    	add    $0x238,%edx
801047bc:	83 ec 08             	sub    $0x8,%esp
801047bf:	50                   	push   %eax
801047c0:	52                   	push   %edx
801047c1:	e8 64 14 00 00       	call   80105c2a <sleep>
801047c6:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801047c9:	8b 45 08             	mov    0x8(%ebp),%eax
801047cc:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801047d2:	8b 45 08             	mov    0x8(%ebp),%eax
801047d5:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801047db:	05 00 02 00 00       	add    $0x200,%eax
801047e0:	39 c2                	cmp    %eax,%edx
801047e2:	74 85                	je     80104769 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801047e4:	8b 45 08             	mov    0x8(%ebp),%eax
801047e7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801047ed:	8d 48 01             	lea    0x1(%eax),%ecx
801047f0:	8b 55 08             	mov    0x8(%ebp),%edx
801047f3:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801047f9:	25 ff 01 00 00       	and    $0x1ff,%eax
801047fe:	89 c1                	mov    %eax,%ecx
80104800:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104803:	8b 45 0c             	mov    0xc(%ebp),%eax
80104806:	01 d0                	add    %edx,%eax
80104808:	0f b6 10             	movzbl (%eax),%edx
8010480b:	8b 45 08             	mov    0x8(%ebp),%eax
8010480e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104812:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104819:	3b 45 10             	cmp    0x10(%ebp),%eax
8010481c:	7c ab                	jl     801047c9 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010481e:	8b 45 08             	mov    0x8(%ebp),%eax
80104821:	05 34 02 00 00       	add    $0x234,%eax
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	50                   	push   %eax
8010482a:	e8 d3 15 00 00       	call   80105e02 <wakeup>
8010482f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104832:	8b 45 08             	mov    0x8(%ebp),%eax
80104835:	83 ec 0c             	sub    $0xc,%esp
80104838:	50                   	push   %eax
80104839:	e8 f6 20 00 00       	call   80106934 <release>
8010483e:	83 c4 10             	add    $0x10,%esp
  return n;
80104841:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104844:	c9                   	leave  
80104845:	c3                   	ret    

80104846 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104846:	55                   	push   %ebp
80104847:	89 e5                	mov    %esp,%ebp
80104849:	53                   	push   %ebx
8010484a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010484d:	8b 45 08             	mov    0x8(%ebp),%eax
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	50                   	push   %eax
80104854:	e8 74 20 00 00       	call   801068cd <acquire>
80104859:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010485c:	eb 3f                	jmp    8010489d <piperead+0x57>
    if(proc->killed){
8010485e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104864:	8b 40 2c             	mov    0x2c(%eax),%eax
80104867:	85 c0                	test   %eax,%eax
80104869:	74 19                	je     80104884 <piperead+0x3e>
      release(&p->lock);
8010486b:	8b 45 08             	mov    0x8(%ebp),%eax
8010486e:	83 ec 0c             	sub    $0xc,%esp
80104871:	50                   	push   %eax
80104872:	e8 bd 20 00 00       	call   80106934 <release>
80104877:	83 c4 10             	add    $0x10,%esp
      return -1;
8010487a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010487f:	e9 bf 00 00 00       	jmp    80104943 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104884:	8b 45 08             	mov    0x8(%ebp),%eax
80104887:	8b 55 08             	mov    0x8(%ebp),%edx
8010488a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104890:	83 ec 08             	sub    $0x8,%esp
80104893:	50                   	push   %eax
80104894:	52                   	push   %edx
80104895:	e8 90 13 00 00       	call   80105c2a <sleep>
8010489a:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010489d:	8b 45 08             	mov    0x8(%ebp),%eax
801048a0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801048a6:	8b 45 08             	mov    0x8(%ebp),%eax
801048a9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801048af:	39 c2                	cmp    %eax,%edx
801048b1:	75 0d                	jne    801048c0 <piperead+0x7a>
801048b3:	8b 45 08             	mov    0x8(%ebp),%eax
801048b6:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801048bc:	85 c0                	test   %eax,%eax
801048be:	75 9e                	jne    8010485e <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801048c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801048c7:	eb 49                	jmp    80104912 <piperead+0xcc>
    if(p->nread == p->nwrite)
801048c9:	8b 45 08             	mov    0x8(%ebp),%eax
801048cc:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801048d2:	8b 45 08             	mov    0x8(%ebp),%eax
801048d5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801048db:	39 c2                	cmp    %eax,%edx
801048dd:	74 3d                	je     8010491c <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801048df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801048e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801048e8:	8b 45 08             	mov    0x8(%ebp),%eax
801048eb:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801048f1:	8d 48 01             	lea    0x1(%eax),%ecx
801048f4:	8b 55 08             	mov    0x8(%ebp),%edx
801048f7:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801048fd:	25 ff 01 00 00       	and    $0x1ff,%eax
80104902:	89 c2                	mov    %eax,%edx
80104904:	8b 45 08             	mov    0x8(%ebp),%eax
80104907:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010490c:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010490e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104915:	3b 45 10             	cmp    0x10(%ebp),%eax
80104918:	7c af                	jl     801048c9 <piperead+0x83>
8010491a:	eb 01                	jmp    8010491d <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010491c:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010491d:	8b 45 08             	mov    0x8(%ebp),%eax
80104920:	05 38 02 00 00       	add    $0x238,%eax
80104925:	83 ec 0c             	sub    $0xc,%esp
80104928:	50                   	push   %eax
80104929:	e8 d4 14 00 00       	call   80105e02 <wakeup>
8010492e:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104931:	8b 45 08             	mov    0x8(%ebp),%eax
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	50                   	push   %eax
80104938:	e8 f7 1f 00 00       	call   80106934 <release>
8010493d:	83 c4 10             	add    $0x10,%esp
  return i;
80104940:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104946:	c9                   	leave  
80104947:	c3                   	ret    

80104948 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
80104948:	55                   	push   %ebp
80104949:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
8010494b:	f4                   	hlt    
}
8010494c:	90                   	nop
8010494d:	5d                   	pop    %ebp
8010494e:	c3                   	ret    

8010494f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010494f:	55                   	push   %ebp
80104950:	89 e5                	mov    %esp,%ebp
80104952:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104955:	9c                   	pushf  
80104956:	58                   	pop    %eax
80104957:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010495a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010495d:	c9                   	leave  
8010495e:	c3                   	ret    

8010495f <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010495f:	55                   	push   %ebp
80104960:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104962:	fb                   	sti    
}
80104963:	90                   	nop
80104964:	5d                   	pop    %ebp
80104965:	c3                   	ret    

80104966 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104966:	55                   	push   %ebp
80104967:	89 e5                	mov    %esp,%ebp
80104969:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010496c:	83 ec 08             	sub    $0x8,%esp
8010496f:	68 38 a5 10 80       	push   $0x8010a538
80104974:	68 a4 49 11 80       	push   $0x801149a4
80104979:	e8 2d 1f 00 00       	call   801068ab <initlock>
8010497e:	83 c4 10             	add    $0x10,%esp
}
80104981:	90                   	nop
80104982:	c9                   	leave  
80104983:	c3                   	ret    

80104984 <assertState>:
// state required to run in the kernel.
// Otherwise return 0.

void
assertState(struct proc * p, enum procstate state)
{
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	83 ec 08             	sub    $0x8,%esp
	if(p->state != state){
8010498a:	8b 45 08             	mov    0x8(%ebp),%eax
8010498d:	8b 40 0c             	mov    0xc(%eax),%eax
80104990:	3b 45 0c             	cmp    0xc(%ebp),%eax
80104993:	74 0d                	je     801049a2 <assertState+0x1e>
		panic("ERROR: Process of state is not of the correct state");
80104995:	83 ec 0c             	sub    $0xc,%esp
80104998:	68 40 a5 10 80       	push   $0x8010a540
8010499d:	e8 c4 bb ff ff       	call   80100566 <panic>
	}
}
801049a2:	90                   	nop
801049a3:	c9                   	leave  
801049a4:	c3                   	ret    

801049a5 <removeFromStateList>:

int
removeFromStateList(struct proc ** sList, enum procstate state, struct proc *p)
{
801049a5:	55                   	push   %ebp
801049a6:	89 e5                	mov    %esp,%ebp
801049a8:	83 ec 18             	sub    $0x18,%esp
	if(*sList == 0) return 0;
801049ab:	8b 45 08             	mov    0x8(%ebp),%eax
801049ae:	8b 00                	mov    (%eax),%eax
801049b0:	85 c0                	test   %eax,%eax
801049b2:	75 0a                	jne    801049be <removeFromStateList+0x19>
801049b4:	b8 00 00 00 00       	mov    $0x0,%eax
801049b9:	e9 bd 00 00 00       	jmp    80104a7b <removeFromStateList+0xd6>
        struct proc * current;
        if(*sList == p)
801049be:	8b 45 08             	mov    0x8(%ebp),%eax
801049c1:	8b 00                	mov    (%eax),%eax
801049c3:	3b 45 10             	cmp    0x10(%ebp),%eax
801049c6:	75 40                	jne    80104a08 <removeFromStateList+0x63>
        {
		assertState(*sList,state);
801049c8:	8b 45 08             	mov    0x8(%ebp),%eax
801049cb:	8b 00                	mov    (%eax),%eax
801049cd:	83 ec 08             	sub    $0x8,%esp
801049d0:	ff 75 0c             	pushl  0xc(%ebp)
801049d3:	50                   	push   %eax
801049d4:	e8 ab ff ff ff       	call   80104984 <assertState>
801049d9:	83 c4 10             	add    $0x10,%esp
		current = *sList;
801049dc:	8b 45 08             	mov    0x8(%ebp),%eax
801049df:	8b 00                	mov    (%eax),%eax
801049e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
                *sList = (*sList)->next;
801049e4:	8b 45 08             	mov    0x8(%ebp),%eax
801049e7:	8b 00                	mov    (%eax),%eax
801049e9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801049ef:	8b 45 08             	mov    0x8(%ebp),%eax
801049f2:	89 10                	mov    %edx,(%eax)
		current->next = 0;
801049f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f7:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801049fe:	00 00 00 
                return 1;
80104a01:	b8 01 00 00 00       	mov    $0x1,%eax
80104a06:	eb 73                	jmp    80104a7b <removeFromStateList+0xd6>
        }
        current = *sList;
80104a08:	8b 45 08             	mov    0x8(%ebp),%eax
80104a0b:	8b 00                	mov    (%eax),%eax
80104a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while(current->next)
80104a10:	eb 57                	jmp    80104a69 <removeFromStateList+0xc4>
        {
                if(current->next == p)
80104a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a15:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a1b:	3b 45 10             	cmp    0x10(%ebp),%eax
80104a1e:	75 3d                	jne    80104a5d <removeFromStateList+0xb8>
                {
			assertState(p,state);
80104a20:	83 ec 08             	sub    $0x8,%esp
80104a23:	ff 75 0c             	pushl  0xc(%ebp)
80104a26:	ff 75 10             	pushl  0x10(%ebp)
80104a29:	e8 56 ff ff ff       	call   80104984 <assertState>
80104a2e:	83 c4 10             	add    $0x10,%esp
                        current->next = current->next->next;
80104a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a34:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a3a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80104a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a43:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
			p->next = 0;
80104a49:	8b 45 10             	mov    0x10(%ebp),%eax
80104a4c:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104a53:	00 00 00 
                        return 1;
80104a56:	b8 01 00 00 00       	mov    $0x1,%eax
80104a5b:	eb 1e                	jmp    80104a7b <removeFromStateList+0xd6>
                }
		else current = current->next;
80104a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a60:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
                *sList = (*sList)->next;
		current->next = 0;
                return 1;
        }
        current = *sList;
        while(current->next)
80104a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a72:	85 c0                	test   %eax,%eax
80104a74:	75 9c                	jne    80104a12 <removeFromStateList+0x6d>
			p->next = 0;
                        return 1;
                }
		else current = current->next;
        }
        return 0;
80104a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a7b:	c9                   	leave  
80104a7c:	c3                   	ret    

80104a7d <insertRoundRobin>:

int
insertRoundRobin(struct proc **sList, enum procstate state, struct proc *p)
{
80104a7d:	55                   	push   %ebp
80104a7e:	89 e5                	mov    %esp,%ebp
80104a80:	83 ec 18             	sub    $0x18,%esp
	assertState(p,state);
80104a83:	83 ec 08             	sub    $0x8,%esp
80104a86:	ff 75 0c             	pushl  0xc(%ebp)
80104a89:	ff 75 10             	pushl  0x10(%ebp)
80104a8c:	e8 f3 fe ff ff       	call   80104984 <assertState>
80104a91:	83 c4 10             	add    $0x10,%esp
	struct proc * current;
	if(*sList== 0)
80104a94:	8b 45 08             	mov    0x8(%ebp),%eax
80104a97:	8b 00                	mov    (%eax),%eax
80104a99:	85 c0                	test   %eax,%eax
80104a9b:	75 1c                	jne    80104ab9 <insertRoundRobin+0x3c>
	{
		p->next = 0;
80104a9d:	8b 45 10             	mov    0x10(%ebp),%eax
80104aa0:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104aa7:	00 00 00 
		*sList = p;
80104aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80104aad:	8b 55 10             	mov    0x10(%ebp),%edx
80104ab0:	89 10                	mov    %edx,(%eax)
		return 1;
80104ab2:	b8 01 00 00 00       	mov    $0x1,%eax
80104ab7:	eb 41                	jmp    80104afa <insertRoundRobin+0x7d>
	}
	current = *sList;
80104ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80104abc:	8b 00                	mov    (%eax),%eax
80104abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	while(current->next)
80104ac1:	eb 0c                	jmp    80104acf <insertRoundRobin+0x52>
	{
		current = current->next;
80104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p->next = 0;
		*sList = p;
		return 1;
	}
	current = *sList;
	while(current->next)
80104acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104ad8:	85 c0                	test   %eax,%eax
80104ada:	75 e7                	jne    80104ac3 <insertRoundRobin+0x46>
	{
		current = current->next;
	}
	p->next = 0;
80104adc:	8b 45 10             	mov    0x10(%ebp),%eax
80104adf:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104ae6:	00 00 00 
	current->next = p;
80104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aec:	8b 55 10             	mov    0x10(%ebp),%edx
80104aef:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
	return 1;
80104af5:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104afa:	c9                   	leave  
80104afb:	c3                   	ret    

80104afc <insertAtHead>:

int
insertAtHead(struct proc ** sList,enum procstate state, struct proc * p)
{
80104afc:	55                   	push   %ebp
80104afd:	89 e5                	mov    %esp,%ebp
80104aff:	83 ec 08             	sub    $0x8,%esp
	assertState(p,state);
80104b02:	83 ec 08             	sub    $0x8,%esp
80104b05:	ff 75 0c             	pushl  0xc(%ebp)
80104b08:	ff 75 10             	pushl  0x10(%ebp)
80104b0b:	e8 74 fe ff ff       	call   80104984 <assertState>
80104b10:	83 c4 10             	add    $0x10,%esp
	p->next = *sList;
80104b13:	8b 45 08             	mov    0x8(%ebp),%eax
80104b16:	8b 10                	mov    (%eax),%edx
80104b18:	8b 45 10             	mov    0x10(%ebp),%eax
80104b1b:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
	*sList = p;
80104b21:	8b 45 08             	mov    0x8(%ebp),%eax
80104b24:	8b 55 10             	mov    0x10(%ebp),%edx
80104b27:	89 10                	mov    %edx,(%eax)
	return 1;
80104b29:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104b2e:	c9                   	leave  
80104b2f:	c3                   	ret    

80104b30 <killState>:

void
killState(struct proc ** sList, enum procstate state, int pid)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 10             	sub    $0x10,%esp
	struct proc * current = *sList;
80104b36:	8b 45 08             	mov    0x8(%ebp),%eax
80104b39:	8b 00                	mov    (%eax),%eax
80104b3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(current){
80104b3e:	eb 31                	jmp    80104b71 <killState+0x41>
  	  if(current->pid == pid){
80104b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b43:	8b 50 10             	mov    0x10(%eax),%edx
80104b46:	8b 45 10             	mov    0x10(%ebp),%eax
80104b49:	39 c2                	cmp    %eax,%edx
80104b4b:	75 18                	jne    80104b65 <killState+0x35>
  	    current->killed = 1;
80104b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b50:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
  	    current = current->next;
80104b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b5a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104b60:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104b63:	eb 0c                	jmp    80104b71 <killState+0x41>
  	  }
  	  else current = current->next;
80104b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b68:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104b6e:	89 45 fc             	mov    %eax,-0x4(%ebp)

void
killState(struct proc ** sList, enum procstate state, int pid)
{
	struct proc * current = *sList;
	while(current){
80104b71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104b75:	75 c9                	jne    80104b40 <killState+0x10>
  	    current = current->next;
  	  }
  	  else current = current->next;
  	}

}
80104b77:	90                   	nop
80104b78:	c9                   	leave  
80104b79:	c3                   	ret    

80104b7a <clipToBack>:

int
clipToBack(struct proc ** sList1, struct proc ** sList2)
{
80104b7a:	55                   	push   %ebp
80104b7b:	89 e5                	mov    %esp,%ebp
80104b7d:	83 ec 10             	sub    $0x10,%esp
	if(!*sList1)
80104b80:	8b 45 08             	mov    0x8(%ebp),%eax
80104b83:	8b 00                	mov    (%eax),%eax
80104b85:	85 c0                	test   %eax,%eax
80104b87:	75 11                	jne    80104b9a <clipToBack+0x20>
	{
		*sList1 = *sList2;
80104b89:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8c:	8b 10                	mov    (%eax),%edx
80104b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b91:	89 10                	mov    %edx,(%eax)
		return 1;
80104b93:	b8 01 00 00 00       	mov    $0x1,%eax
80104b98:	eb 36                	jmp    80104bd0 <clipToBack+0x56>
	}
	struct proc * current = *sList1;
80104b9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104b9d:	8b 00                	mov    (%eax),%eax
80104b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(current->next)
80104ba2:	eb 0c                	jmp    80104bb0 <clipToBack+0x36>
	{
		current = current->next;
80104ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ba7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		*sList1 = *sList2;
		return 1;
	}
	struct proc * current = *sList1;
	while(current->next)
80104bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bb3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104bb9:	85 c0                	test   %eax,%eax
80104bbb:	75 e7                	jne    80104ba4 <clipToBack+0x2a>
	{
		current = current->next;
	}
	current->next = *sList2;
80104bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc0:	8b 10                	mov    (%eax),%edx
80104bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bc5:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
	return 1;
80104bcb:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104bd0:	c9                   	leave  
80104bd1:	c3                   	ret    

80104bd2 <setPrioBudgetList>:

int
setPrioBudgetList(struct proc ** sList, int toSet)
{
80104bd2:	55                   	push   %ebp
80104bd3:	89 e5                	mov    %esp,%ebp
80104bd5:	83 ec 10             	sub    $0x10,%esp
	struct proc * current;
	if(!*sList)return 0;
80104bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bdb:	8b 00                	mov    (%eax),%eax
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	75 07                	jne    80104be8 <setPrioBudgetList+0x16>
80104be1:	b8 00 00 00 00       	mov    $0x0,%eax
80104be6:	eb 3a                	jmp    80104c22 <setPrioBudgetList+0x50>
	current = *sList;
80104be8:	8b 45 08             	mov    0x8(%ebp),%eax
80104beb:	8b 00                	mov    (%eax),%eax
80104bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(current)
80104bf0:	eb 25                	jmp    80104c17 <setPrioBudgetList+0x45>
	{
		current->prio = toSet;
80104bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bf8:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
		current->budget = BUDGET_MAX;
80104bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c01:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
80104c08:	01 00 00 
		current = current->next;
80104c0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c0e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104c14:	89 45 fc             	mov    %eax,-0x4(%ebp)
setPrioBudgetList(struct proc ** sList, int toSet)
{
	struct proc * current;
	if(!*sList)return 0;
	current = *sList;
	while(current)
80104c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104c1b:	75 d5                	jne    80104bf2 <setPrioBudgetList+0x20>
	{
		current->prio = toSet;
		current->budget = BUDGET_MAX;
		current = current->next;
	}
	return 1;
80104c1d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104c22:	c9                   	leave  
80104c23:	c3                   	ret    

80104c24 <findPid>:

struct proc*
findPid(struct proc ** sList, int pid)
{
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	83 ec 10             	sub    $0x10,%esp
	if(!*sList) return 0;
80104c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2d:	8b 00                	mov    (%eax),%eax
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	75 07                	jne    80104c3a <findPid+0x16>
80104c33:	b8 00 00 00 00       	mov    $0x0,%eax
80104c38:	eb 33                	jmp    80104c6d <findPid+0x49>
	struct proc * current = *sList;
80104c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3d:	8b 00                	mov    (%eax),%eax
80104c3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(current){
80104c42:	eb 1e                	jmp    80104c62 <findPid+0x3e>
		if(current->pid == pid)
80104c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c47:	8b 50 10             	mov    0x10(%eax),%edx
80104c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4d:	39 c2                	cmp    %eax,%edx
80104c4f:	75 05                	jne    80104c56 <findPid+0x32>
			return current;
80104c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c54:	eb 17                	jmp    80104c6d <findPid+0x49>
		current = current->next;
80104c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c59:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
struct proc*
findPid(struct proc ** sList, int pid)
{
	if(!*sList) return 0;
	struct proc * current = *sList;
	while(current){
80104c62:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104c66:	75 dc                	jne    80104c44 <findPid+0x20>
		if(current->pid == pid)
			return current;
		current = current->next;
	}
	return 0;
80104c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c6d:	c9                   	leave  
80104c6e:	c3                   	ret    

80104c6f <findReadyPid>:

struct proc*
findReadyPid(int pid)
{
80104c6f:	55                   	push   %ebp
80104c70:	89 e5                	mov    %esp,%ebp
80104c72:	83 ec 10             	sub    $0x10,%esp
	struct proc * current;
	for(int i = 0; i < MAX; ++i)
80104c75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104c7c:	eb 3c                	jmp    80104cba <findReadyPid+0x4b>
	{
		current = ptable.pLists.ready[i];
80104c7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c81:	05 cc 09 00 00       	add    $0x9cc,%eax
80104c86:	8b 04 85 a8 49 11 80 	mov    -0x7feeb658(,%eax,4),%eax
80104c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
		while(current)
80104c90:	eb 1e                	jmp    80104cb0 <findReadyPid+0x41>
		{
			if (current->pid == pid)
80104c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c95:	8b 50 10             	mov    0x10(%eax),%edx
80104c98:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9b:	39 c2                	cmp    %eax,%edx
80104c9d:	75 05                	jne    80104ca4 <findReadyPid+0x35>
				return current;
80104c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ca2:	eb 21                	jmp    80104cc5 <findReadyPid+0x56>
			current = current->next;
80104ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ca7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
	struct proc * current;
	for(int i = 0; i < MAX; ++i)
	{
		current = ptable.pLists.ready[i];
		while(current)
80104cb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104cb4:	75 dc                	jne    80104c92 <findReadyPid+0x23>

struct proc*
findReadyPid(int pid)
{
	struct proc * current;
	for(int i = 0; i < MAX; ++i)
80104cb6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104cba:	83 7d f8 02          	cmpl   $0x2,-0x8(%ebp)
80104cbe:	7e be                	jle    80104c7e <findReadyPid+0xf>
				return current;
			current = current->next;
		}
		
	}
	return 0;
80104cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    

80104cc7 <allocproc>:

static struct proc*
allocproc(void)
{
80104cc7:	55                   	push   %ebp
80104cc8:	89 e5                	mov    %esp,%ebp
80104cca:	83 ec 18             	sub    $0x18,%esp
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  #else
  acquire(&ptable.lock);
80104ccd:	83 ec 0c             	sub    $0xc,%esp
80104cd0:	68 a4 49 11 80       	push   $0x801149a4
80104cd5:	e8 f3 1b 00 00       	call   801068cd <acquire>
80104cda:	83 c4 10             	add    $0x10,%esp
  if(ptable.pLists.free)
80104cdd:	a1 e4 70 11 80       	mov    0x801170e4,%eax
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	0f 84 91 00 00 00    	je     80104d7b <allocproc+0xb4>
  {
	assertState(ptable.pLists.free,UNUSED);
80104cea:	a1 e4 70 11 80       	mov    0x801170e4,%eax
80104cef:	83 ec 08             	sub    $0x8,%esp
80104cf2:	6a 00                	push   $0x0
80104cf4:	50                   	push   %eax
80104cf5:	e8 8a fc ff ff       	call   80104984 <assertState>
80104cfa:	83 c4 10             	add    $0x10,%esp
	p = ptable.pLists.free;
80104cfd:	a1 e4 70 11 80       	mov    0x801170e4,%eax
80104d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	goto found;
80104d05:	90                   	nop
  release(&ptable.lock);
  return 0;
  #endif
found:
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.free,UNUSED,p);
80104d06:	83 ec 04             	sub    $0x4,%esp
80104d09:	ff 75 f4             	pushl  -0xc(%ebp)
80104d0c:	6a 00                	push   $0x0
80104d0e:	68 e4 70 11 80       	push   $0x801170e4
80104d13:	e8 8d fc ff ff       	call   801049a5 <removeFromStateList>
80104d18:	83 c4 10             	add    $0x10,%esp
  #endif
  p->state = EMBRYO;
80104d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d1e:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104d25:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104d2a:	8d 50 01             	lea    0x1(%eax),%edx
80104d2d:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104d33:	89 c2                	mov    %eax,%edx
80104d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d38:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P3P4
  p->next = ptable.pLists.embryo;
80104d3b:	8b 15 f4 70 11 80    	mov    0x801170f4,%edx
80104d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d44:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  ptable.pLists.embryo = p;
80104d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d4d:	a3 f4 70 11 80       	mov    %eax,0x801170f4
  #endif
  release(&ptable.lock);
80104d52:	83 ec 0c             	sub    $0xc,%esp
80104d55:	68 a4 49 11 80       	push   $0x801149a4
80104d5a:	e8 d5 1b 00 00       	call   80106934 <release>
80104d5f:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104d62:	e8 09 e4 ff ff       	call   80103170 <kalloc>
80104d67:	89 c2                	mov    %eax,%edx
80104d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6c:	89 50 08             	mov    %edx,0x8(%eax)
80104d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d72:	8b 40 08             	mov    0x8(%eax),%eax
80104d75:	85 c0                	test   %eax,%eax
80104d77:	75 7a                	jne    80104df3 <allocproc+0x12c>
80104d79:	eb 1a                	jmp    80104d95 <allocproc+0xce>
  {
	assertState(ptable.pLists.free,UNUSED);
	p = ptable.pLists.free;
	goto found;
  }
  release(&ptable.lock);
80104d7b:	83 ec 0c             	sub    $0xc,%esp
80104d7e:	68 a4 49 11 80       	push   $0x801149a4
80104d83:	e8 ac 1b 00 00       	call   80106934 <release>
80104d88:	83 c4 10             	add    $0x10,%esp
  return 0;
80104d8b:	b8 00 00 00 00       	mov    $0x0,%eax
80104d90:	e9 fe 00 00 00       	jmp    80104e93 <allocproc+0x1cc>
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104d95:	83 ec 0c             	sub    $0xc,%esp
80104d98:	68 a4 49 11 80       	push   $0x801149a4
80104d9d:	e8 2b 1b 00 00       	call   801068cd <acquire>
80104da2:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo,EMBRYO,p);
80104da5:	83 ec 04             	sub    $0x4,%esp
80104da8:	ff 75 f4             	pushl  -0xc(%ebp)
80104dab:	6a 01                	push   $0x1
80104dad:	68 f4 70 11 80       	push   $0x801170f4
80104db2:	e8 ee fb ff ff       	call   801049a5 <removeFromStateList>
80104db7:	83 c4 10             	add    $0x10,%esp
    p->state = UNUSED;
80104dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free,UNUSED,p);
80104dc4:	83 ec 04             	sub    $0x4,%esp
80104dc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dca:	6a 00                	push   $0x0
80104dcc:	68 e4 70 11 80       	push   $0x801170e4
80104dd1:	e8 26 fd ff ff       	call   80104afc <insertAtHead>
80104dd6:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104dd9:	83 ec 0c             	sub    $0xc,%esp
80104ddc:	68 a4 49 11 80       	push   $0x801149a4
80104de1:	e8 4e 1b 00 00       	call   80106934 <release>
80104de6:	83 c4 10             	add    $0x10,%esp
    #else
    p->state = UNUSED;
    #endif
    return 0;
80104de9:	b8 00 00 00 00       	mov    $0x0,%eax
80104dee:	e9 a0 00 00 00       	jmp    80104e93 <allocproc+0x1cc>
  }
  sp = p->kstack + KSTACKSIZE;
80104df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df6:	8b 40 08             	mov    0x8(%eax),%eax
80104df9:	05 00 10 00 00       	add    $0x1000,%eax
80104dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104e01:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e08:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e0b:	89 50 20             	mov    %edx,0x20(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104e0e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104e12:	ba 21 83 10 80       	mov    $0x80108321,%edx
80104e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e1a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104e1c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e23:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e26:	89 50 24             	mov    %edx,0x24(%eax)
  memset(p->context, 0, sizeof *p->context);
80104e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2c:	8b 40 24             	mov    0x24(%eax),%eax
80104e2f:	83 ec 04             	sub    $0x4,%esp
80104e32:	6a 14                	push   $0x14
80104e34:	6a 00                	push   $0x0
80104e36:	50                   	push   %eax
80104e37:	e8 f4 1c 00 00       	call   80106b30 <memset>
80104e3c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e42:	8b 40 24             	mov    0x24(%eax),%eax
80104e45:	ba e4 5b 10 80       	mov    $0x80105be4,%edx
80104e4a:	89 50 10             	mov    %edx,0x10(%eax)
  p->start_ticks = ticks;
80104e4d:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80104e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e56:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  p->cpu_ticks_total = 0;
80104e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5f:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104e66:	00 00 00 
  p->cpu_ticks_in = 0;
80104e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6c:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104e73:	00 00 00 
  p->prio = 0;
80104e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e79:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80104e80:	00 00 00 
  p->budget = 0;
80104e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e86:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104e8d:	00 00 00 
  return p;
80104e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104e93:	c9                   	leave  
80104e94:	c3                   	ret    

80104e95 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104e95:	55                   	push   %ebp
80104e96:	89 e5                	mov    %esp,%ebp
80104e98:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
80104e9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	68 a4 49 11 80       	push   $0x801149a4
80104eaa:	e8 1e 1a 00 00       	call   801068cd <acquire>
80104eaf:	83 c4 10             	add    $0x10,%esp
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; 
80104eb2:	a1 00 79 11 80       	mov    0x80117900,%eax
80104eb7:	05 2c 01 00 00       	add    $0x12c,%eax
80104ebc:	a3 a0 49 11 80       	mov    %eax,0x801149a0
  ptable.pLists.free = 0;
80104ec1:	c7 05 e4 70 11 80 00 	movl   $0x0,0x801170e4
80104ec8:	00 00 00 
  ptable.pLists.sleep = 0;
80104ecb:	c7 05 e8 70 11 80 00 	movl   $0x0,0x801170e8
80104ed2:	00 00 00 
  ptable.pLists.zombie = 0;
80104ed5:	c7 05 ec 70 11 80 00 	movl   $0x0,0x801170ec
80104edc:	00 00 00 
  ptable.pLists.running = 0;
80104edf:	c7 05 f0 70 11 80 00 	movl   $0x0,0x801170f0
80104ee6:	00 00 00 
  ptable.pLists.embryo = 0;
80104ee9:	c7 05 f4 70 11 80 00 	movl   $0x0,0x801170f4
80104ef0:	00 00 00 
  for(i = 0; i < MAX; ++i)
80104ef3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104efa:	eb 17                	jmp    80104f13 <userinit+0x7e>
  	ptable.pLists.ready[i] = 0;
80104efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eff:	05 cc 09 00 00       	add    $0x9cc,%eax
80104f04:	c7 04 85 a8 49 11 80 	movl   $0x0,-0x7feeb658(,%eax,4)
80104f0b:	00 00 00 00 
  ptable.pLists.free = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;
  for(i = 0; i < MAX; ++i)
80104f0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f13:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
80104f17:	7e e3                	jle    80104efc <userinit+0x67>
  	ptable.pLists.ready[i] = 0;
  struct proc *temp = 0;
80104f19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(temp = ptable.proc; temp < &ptable.proc[NPROC];++temp)
80104f20:	c7 45 f0 d8 49 11 80 	movl   $0x801149d8,-0x10(%ebp)
80104f27:	eb 1c                	jmp    80104f45 <userinit+0xb0>
  {
	insertAtHead(&ptable.pLists.free,UNUSED,temp);
80104f29:	83 ec 04             	sub    $0x4,%esp
80104f2c:	ff 75 f0             	pushl  -0x10(%ebp)
80104f2f:	6a 00                	push   $0x0
80104f31:	68 e4 70 11 80       	push   $0x801170e4
80104f36:	e8 c1 fb ff ff       	call   80104afc <insertAtHead>
80104f3b:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;
  for(i = 0; i < MAX; ++i)
  	ptable.pLists.ready[i] = 0;
  struct proc *temp = 0;
  for(temp = ptable.proc; temp < &ptable.proc[NPROC];++temp)
80104f3e:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80104f45:	81 7d f0 d8 70 11 80 	cmpl   $0x801170d8,-0x10(%ebp)
80104f4c:	72 db                	jb     80104f29 <userinit+0x94>
  {
	insertAtHead(&ptable.pLists.free,UNUSED,temp);
  }
  release(&ptable.lock);
80104f4e:	83 ec 0c             	sub    $0xc,%esp
80104f51:	68 a4 49 11 80       	push   $0x801149a4
80104f56:	e8 d9 19 00 00       	call   80106934 <release>
80104f5b:	83 c4 10             	add    $0x10,%esp
  #endif
  p = allocproc();
80104f5e:	e8 64 fd ff ff       	call   80104cc7 <allocproc>
80104f63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  initproc = p;
80104f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f69:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
80104f6e:	e8 4d 4a 00 00       	call   801099c0 <setupkvm>
80104f73:	89 c2                	mov    %eax,%edx
80104f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f78:	89 50 04             	mov    %edx,0x4(%eax)
80104f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f7e:	8b 40 04             	mov    0x4(%eax),%eax
80104f81:	85 c0                	test   %eax,%eax
80104f83:	75 0d                	jne    80104f92 <userinit+0xfd>
    panic("userinit: out of memory?");
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	68 74 a5 10 80       	push   $0x8010a574
80104f8d:	e8 d4 b5 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104f92:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f9a:	8b 40 04             	mov    0x4(%eax),%eax
80104f9d:	83 ec 04             	sub    $0x4,%esp
80104fa0:	52                   	push   %edx
80104fa1:	68 20 d5 10 80       	push   $0x8010d520
80104fa6:	50                   	push   %eax
80104fa7:	e8 6e 4c 00 00       	call   80109c1a <inituvm>
80104fac:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fb2:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fbb:	8b 40 20             	mov    0x20(%eax),%eax
80104fbe:	83 ec 04             	sub    $0x4,%esp
80104fc1:	6a 4c                	push   $0x4c
80104fc3:	6a 00                	push   $0x0
80104fc5:	50                   	push   %eax
80104fc6:	e8 65 1b 00 00       	call   80106b30 <memset>
80104fcb:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fd1:	8b 40 20             	mov    0x20(%eax),%eax
80104fd4:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fdd:	8b 40 20             	mov    0x20(%eax),%eax
80104fe0:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fe9:	8b 40 20             	mov    0x20(%eax),%eax
80104fec:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104fef:	8b 52 20             	mov    0x20(%edx),%edx
80104ff2:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104ff6:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ffd:	8b 40 20             	mov    0x20(%eax),%eax
80105000:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105003:	8b 52 20             	mov    0x20(%edx),%edx
80105006:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010500a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010500e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105011:	8b 40 20             	mov    0x20(%eax),%eax
80105014:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010501b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010501e:	8b 40 20             	mov    0x20(%eax),%eax
80105021:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->uid = UID;
80105028:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010502b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->gid = GID;
80105032:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105035:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  p->budget = BUDGET_MAX;
8010503c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010503f:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
80105046:	01 00 00 
  p->tf->eip = 0;  // beginning of initcode.S
80105049:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010504c:	8b 40 20             	mov    0x20(%eax),%eax
8010504f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80105056:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105059:	83 c0 74             	add    $0x74,%eax
8010505c:	83 ec 04             	sub    $0x4,%esp
8010505f:	6a 10                	push   $0x10
80105061:	68 8d a5 10 80       	push   $0x8010a58d
80105066:	50                   	push   %eax
80105067:	e8 c7 1c 00 00       	call   80106d33 <safestrcpy>
8010506c:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	68 96 a5 10 80       	push   $0x8010a596
80105077:	e8 b6 d9 ff ff       	call   80102a32 <namei>
8010507c:	83 c4 10             	add    $0x10,%esp
8010507f:	89 c2                	mov    %eax,%edx
80105081:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105084:	89 50 70             	mov    %edx,0x70(%eax)
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	68 a4 49 11 80       	push   $0x801149a4
8010508f:	e8 39 18 00 00       	call   801068cd <acquire>
80105094:	83 c4 10             	add    $0x10,%esp
  removeFromStateList(&ptable.pLists.embryo, EMBRYO, p);
80105097:	83 ec 04             	sub    $0x4,%esp
8010509a:	ff 75 ec             	pushl  -0x14(%ebp)
8010509d:	6a 01                	push   $0x1
8010509f:	68 f4 70 11 80       	push   $0x801170f4
801050a4:	e8 fc f8 ff ff       	call   801049a5 <removeFromStateList>
801050a9:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
801050ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insertRoundRobin(&ptable.pLists.ready[0],RUNNABLE,p);
801050b6:	83 ec 04             	sub    $0x4,%esp
801050b9:	ff 75 ec             	pushl  -0x14(%ebp)
801050bc:	6a 03                	push   $0x3
801050be:	68 d8 70 11 80       	push   $0x801170d8
801050c3:	e8 b5 f9 ff ff       	call   80104a7d <insertRoundRobin>
801050c8:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.ready[0]->next = 0;
801050cb:	a1 d8 70 11 80       	mov    0x801170d8,%eax
801050d0:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801050d7:	00 00 00 
  release(&ptable.lock);
801050da:	83 ec 0c             	sub    $0xc,%esp
801050dd:	68 a4 49 11 80       	push   $0x801149a4
801050e2:	e8 4d 18 00 00       	call   80106934 <release>
801050e7:	83 c4 10             	add    $0x10,%esp
  #else
  p->state = RUNNABLE;
  #endif
}
801050ea:	90                   	nop
801050eb:	c9                   	leave  
801050ec:	c3                   	ret    

801050ed <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801050ed:	55                   	push   %ebp
801050ee:	89 e5                	mov    %esp,%ebp
801050f0:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801050f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f9:	8b 00                	mov    (%eax),%eax
801050fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801050fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105102:	7e 31                	jle    80105135 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80105104:	8b 55 08             	mov    0x8(%ebp),%edx
80105107:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010510a:	01 c2                	add    %eax,%edx
8010510c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105112:	8b 40 04             	mov    0x4(%eax),%eax
80105115:	83 ec 04             	sub    $0x4,%esp
80105118:	52                   	push   %edx
80105119:	ff 75 f4             	pushl  -0xc(%ebp)
8010511c:	50                   	push   %eax
8010511d:	e8 45 4c 00 00       	call   80109d67 <allocuvm>
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010512c:	75 3e                	jne    8010516c <growproc+0x7f>
      return -1;
8010512e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105133:	eb 59                	jmp    8010518e <growproc+0xa1>
  } else if(n < 0){
80105135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105139:	79 31                	jns    8010516c <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010513b:	8b 55 08             	mov    0x8(%ebp),%edx
8010513e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105141:	01 c2                	add    %eax,%edx
80105143:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105149:	8b 40 04             	mov    0x4(%eax),%eax
8010514c:	83 ec 04             	sub    $0x4,%esp
8010514f:	52                   	push   %edx
80105150:	ff 75 f4             	pushl  -0xc(%ebp)
80105153:	50                   	push   %eax
80105154:	e8 d7 4c 00 00       	call   80109e30 <deallocuvm>
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010515f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105163:	75 07                	jne    8010516c <growproc+0x7f>
      return -1;
80105165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516a:	eb 22                	jmp    8010518e <growproc+0xa1>
  }
  proc->sz = sz;
8010516c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105172:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105175:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80105177:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	50                   	push   %eax
80105181:	e8 21 49 00 00       	call   80109aa7 <switchuvm>
80105186:	83 c4 10             	add    $0x10,%esp
  return 0;
80105189:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010518e:	c9                   	leave  
8010518f:	c3                   	ret    

80105190 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
80105196:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80105199:	e8 29 fb ff ff       	call   80104cc7 <allocproc>
8010519e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801051a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801051a5:	75 0a                	jne    801051b1 <fork+0x21>
    return -1;
801051a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ac:	e9 04 02 00 00       	jmp    801053b5 <fork+0x225>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801051b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b7:	8b 10                	mov    (%eax),%edx
801051b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051bf:	8b 40 04             	mov    0x4(%eax),%eax
801051c2:	83 ec 08             	sub    $0x8,%esp
801051c5:	52                   	push   %edx
801051c6:	50                   	push   %eax
801051c7:	e8 02 4e 00 00       	call   80109fce <copyuvm>
801051cc:	83 c4 10             	add    $0x10,%esp
801051cf:	89 c2                	mov    %eax,%edx
801051d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051d4:	89 50 04             	mov    %edx,0x4(%eax)
801051d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051da:	8b 40 04             	mov    0x4(%eax),%eax
801051dd:	85 c0                	test   %eax,%eax
801051df:	75 7a                	jne    8010525b <fork+0xcb>
    kfree(np->kstack);
801051e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051e4:	8b 40 08             	mov    0x8(%eax),%eax
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	50                   	push   %eax
801051eb:	e8 e3 de ff ff       	call   801030d3 <kfree>
801051f0:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801051f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
801051fd:	83 ec 0c             	sub    $0xc,%esp
80105200:	68 a4 49 11 80       	push   $0x801149a4
80105205:	e8 c3 16 00 00       	call   801068cd <acquire>
8010520a:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo,EMBRYO,np);
8010520d:	83 ec 04             	sub    $0x4,%esp
80105210:	ff 75 e0             	pushl  -0x20(%ebp)
80105213:	6a 01                	push   $0x1
80105215:	68 f4 70 11 80       	push   $0x801170f4
8010521a:	e8 86 f7 ff ff       	call   801049a5 <removeFromStateList>
8010521f:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80105222:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105225:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free,UNUSED,np);
8010522c:	83 ec 04             	sub    $0x4,%esp
8010522f:	ff 75 e0             	pushl  -0x20(%ebp)
80105232:	6a 00                	push   $0x0
80105234:	68 e4 70 11 80       	push   $0x801170e4
80105239:	e8 be f8 ff ff       	call   80104afc <insertAtHead>
8010523e:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	68 a4 49 11 80       	push   $0x801149a4
80105249:	e8 e6 16 00 00       	call   80106934 <release>
8010524e:	83 c4 10             	add    $0x10,%esp
    #else
    np->state = UNUSED;
    #endif
    return -1;
80105251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105256:	e9 5a 01 00 00       	jmp    801053b5 <fork+0x225>
  }
  np->sz = proc->sz;
8010525b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105261:	8b 10                	mov    (%eax),%edx
80105263:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105266:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80105268:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010526f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105272:	89 50 1c             	mov    %edx,0x1c(%eax)
  *np->tf = *proc->tf;
80105275:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105278:	8b 50 20             	mov    0x20(%eax),%edx
8010527b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105281:	8b 40 20             	mov    0x20(%eax),%eax
80105284:	89 c3                	mov    %eax,%ebx
80105286:	b8 13 00 00 00       	mov    $0x13,%eax
8010528b:	89 d7                	mov    %edx,%edi
8010528d:	89 de                	mov    %ebx,%esi
8010528f:	89 c1                	mov    %eax,%ecx
80105291:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80105293:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105296:	8b 40 20             	mov    0x20(%eax),%eax
80105299:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  np->uid = proc->uid;
801052a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a6:	8b 50 14             	mov    0x14(%eax),%edx
801052a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052ac:	89 50 14             	mov    %edx,0x14(%eax)
  np->gid = proc->gid;
801052af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b5:	8b 50 18             	mov    0x18(%eax),%edx
801052b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052bb:	89 50 18             	mov    %edx,0x18(%eax)
  np->budget = BUDGET_MAX;
801052be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052c1:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
801052c8:	01 00 00 
  for(i = 0; i < NOFILE; i++)
801052cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801052d2:	eb 40                	jmp    80105314 <fork+0x184>
    if(proc->ofile[i])
801052d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052dd:	83 c2 0c             	add    $0xc,%edx
801052e0:	8b 04 90             	mov    (%eax,%edx,4),%eax
801052e3:	85 c0                	test   %eax,%eax
801052e5:	74 29                	je     80105310 <fork+0x180>
      np->ofile[i] = filedup(proc->ofile[i]);
801052e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052f0:	83 c2 0c             	add    $0xc,%edx
801052f3:	8b 04 90             	mov    (%eax,%edx,4),%eax
801052f6:	83 ec 0c             	sub    $0xc,%esp
801052f9:	50                   	push   %eax
801052fa:	e8 45 be ff ff       	call   80101144 <filedup>
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	89 c1                	mov    %eax,%ecx
80105304:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105307:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010530a:	83 c2 0c             	add    $0xc,%edx
8010530d:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  np->uid = proc->uid;
  np->gid = proc->gid;
  np->budget = BUDGET_MAX;
  for(i = 0; i < NOFILE; i++)
80105310:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105314:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80105318:	7e ba                	jle    801052d4 <fork+0x144>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010531a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105320:	8b 40 70             	mov    0x70(%eax),%eax
80105323:	83 ec 0c             	sub    $0xc,%esp
80105326:	50                   	push   %eax
80105327:	e8 6c c9 ff ff       	call   80101c98 <idup>
8010532c:	83 c4 10             	add    $0x10,%esp
8010532f:	89 c2                	mov    %eax,%edx
80105331:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105334:	89 50 70             	mov    %edx,0x70(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80105337:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010533d:	8d 50 74             	lea    0x74(%eax),%edx
80105340:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105343:	83 c0 74             	add    $0x74,%eax
80105346:	83 ec 04             	sub    $0x4,%esp
80105349:	6a 10                	push   $0x10
8010534b:	52                   	push   %edx
8010534c:	50                   	push   %eax
8010534d:	e8 e1 19 00 00       	call   80106d33 <safestrcpy>
80105352:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80105355:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105358:	8b 40 10             	mov    0x10(%eax),%eax
8010535b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010535e:	83 ec 0c             	sub    $0xc,%esp
80105361:	68 a4 49 11 80       	push   $0x801149a4
80105366:	e8 62 15 00 00       	call   801068cd <acquire>
8010536b:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.embryo,EMBRYO,np);
8010536e:	83 ec 04             	sub    $0x4,%esp
80105371:	ff 75 e0             	pushl  -0x20(%ebp)
80105374:	6a 01                	push   $0x1
80105376:	68 f4 70 11 80       	push   $0x801170f4
8010537b:	e8 25 f6 ff ff       	call   801049a5 <removeFromStateList>
80105380:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80105383:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105386:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insertRoundRobin(&ptable.pLists.ready[0],RUNNABLE,np);
8010538d:	83 ec 04             	sub    $0x4,%esp
80105390:	ff 75 e0             	pushl  -0x20(%ebp)
80105393:	6a 03                	push   $0x3
80105395:	68 d8 70 11 80       	push   $0x801170d8
8010539a:	e8 de f6 ff ff       	call   80104a7d <insertRoundRobin>
8010539f:	83 c4 10             	add    $0x10,%esp
  #else
  np->state = RUNNABLE;
  #endif
  release(&ptable.lock);
801053a2:	83 ec 0c             	sub    $0xc,%esp
801053a5:	68 a4 49 11 80       	push   $0x801149a4
801053aa:	e8 85 15 00 00       	call   80106934 <release>
801053af:	83 c4 10             	add    $0x10,%esp
  //proc->start_ticks = ticks;
  return pid;
801053b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801053b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b8:	5b                   	pop    %ebx
801053b9:	5e                   	pop    %esi
801053ba:	5f                   	pop    %edi
801053bb:	5d                   	pop    %ebp
801053bc:	c3                   	ret    

801053bd <switchParent>:
}
#else

int
switchParent(struct proc ** sList)
{
801053bd:	55                   	push   %ebp
801053be:	89 e5                	mov    %esp,%ebp
801053c0:	83 ec 10             	sub    $0x10,%esp
	if(!*sList) return 0;
801053c3:	8b 45 08             	mov    0x8(%ebp),%eax
801053c6:	8b 00                	mov    (%eax),%eax
801053c8:	85 c0                	test   %eax,%eax
801053ca:	75 07                	jne    801053d3 <switchParent+0x16>
801053cc:	b8 00 00 00 00       	mov    $0x0,%eax
801053d1:	eb 43                	jmp    80105416 <switchParent+0x59>
	struct proc * current = *sList;
801053d3:	8b 45 08             	mov    0x8(%ebp),%eax
801053d6:	8b 00                	mov    (%eax),%eax
801053d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct proc * p;
  	while(current){
801053db:	eb 2e                	jmp    8010540b <switchParent+0x4e>
        	p = current;
801053dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        	current = current->next;
801053e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801053ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
        	if(p->parent == proc){
801053ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053f2:	8b 50 1c             	mov    0x1c(%eax),%edx
801053f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053fb:	39 c2                	cmp    %eax,%edx
801053fd:	75 0c                	jne    8010540b <switchParent+0x4e>
        	  p->parent = initproc;
801053ff:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80105405:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105408:	89 50 1c             	mov    %edx,0x1c(%eax)
switchParent(struct proc ** sList)
{
	if(!*sList) return 0;
	struct proc * current = *sList;
	struct proc * p;
  	while(current){
8010540b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010540f:	75 cc                	jne    801053dd <switchParent+0x20>
        	current = current->next;
        	if(p->parent == proc){
        	  p->parent = initproc;
        	}
  	}
	return 1;
80105411:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105416:	c9                   	leave  
80105417:	c3                   	ret    

80105418 <exit>:

void
exit(void)
{
80105418:	55                   	push   %ebp
80105419:	89 e5                	mov    %esp,%ebp
8010541b:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
8010541e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int fd;
  if(proc == initproc)
80105425:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010542c:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80105431:	39 c2                	cmp    %eax,%edx
80105433:	75 0d                	jne    80105442 <exit+0x2a>
    panic("init exiting");
80105435:	83 ec 0c             	sub    $0xc,%esp
80105438:	68 98 a5 10 80       	push   $0x8010a598
8010543d:	e8 24 b1 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80105442:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105449:	eb 45                	jmp    80105490 <exit+0x78>
    if(proc->ofile[fd]){
8010544b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105451:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105454:	83 c2 0c             	add    $0xc,%edx
80105457:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010545a:	85 c0                	test   %eax,%eax
8010545c:	74 2e                	je     8010548c <exit+0x74>
      fileclose(proc->ofile[fd]);
8010545e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105464:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105467:	83 c2 0c             	add    $0xc,%edx
8010546a:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	50                   	push   %eax
80105471:	e8 1f bd ff ff       	call   80101195 <fileclose>
80105476:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80105479:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105482:	83 c2 0c             	add    $0xc,%edx
80105485:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
  int fd;
  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010548c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105490:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105494:	7e b5                	jle    8010544b <exit+0x33>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80105496:	e8 bc e5 ff ff       	call   80103a57 <begin_op>
  iput(proc->cwd);
8010549b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a1:	8b 40 70             	mov    0x70(%eax),%eax
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	50                   	push   %eax
801054a8:	e8 6b cb ff ff       	call   80102018 <iput>
801054ad:	83 c4 10             	add    $0x10,%esp
  end_op();
801054b0:	e8 2e e6 ff ff       	call   80103ae3 <end_op>
  proc->cwd = 0;
801054b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054bb:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)

  acquire(&ptable.lock);
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	68 a4 49 11 80       	push   $0x801149a4
801054ca:	e8 fe 13 00 00       	call   801068cd <acquire>
801054cf:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801054d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d8:	8b 40 1c             	mov    0x1c(%eax),%eax
801054db:	83 ec 0c             	sub    $0xc,%esp
801054de:	50                   	push   %eax
801054df:	e8 91 08 00 00       	call   80105d75 <wakeup1>
801054e4:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for (i = 0;i < MAX; ++i)
801054e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801054ee:	eb 23                	jmp    80105513 <exit+0xfb>
  	switchParent(&ptable.pLists.ready[i]);
801054f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f3:	05 cc 09 00 00       	add    $0x9cc,%eax
801054f8:	c1 e0 02             	shl    $0x2,%eax
801054fb:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105500:	83 c0 08             	add    $0x8,%eax
80105503:	83 ec 0c             	sub    $0xc,%esp
80105506:	50                   	push   %eax
80105507:	e8 b1 fe ff ff       	call   801053bd <switchParent>
8010550c:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for (i = 0;i < MAX; ++i)
8010550f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105513:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
80105517:	7e d7                	jle    801054f0 <exit+0xd8>
  	switchParent(&ptable.pLists.ready[i]);
  switchParent(&ptable.pLists.sleep);
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	68 e8 70 11 80       	push   $0x801170e8
80105521:	e8 97 fe ff ff       	call   801053bd <switchParent>
80105526:	83 c4 10             	add    $0x10,%esp
  switchParent(&ptable.pLists.running);
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	68 f0 70 11 80       	push   $0x801170f0
80105531:	e8 87 fe ff ff       	call   801053bd <switchParent>
80105536:	83 c4 10             	add    $0x10,%esp
  switchParent(&ptable.pLists.embryo);
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	68 f4 70 11 80       	push   $0x801170f4
80105541:	e8 77 fe ff ff       	call   801053bd <switchParent>
80105546:	83 c4 10             	add    $0x10,%esp
  switchParent(&ptable.pLists.zombie);
80105549:	83 ec 0c             	sub    $0xc,%esp
8010554c:	68 ec 70 11 80       	push   $0x801170ec
80105551:	e8 67 fe ff ff       	call   801053bd <switchParent>
80105556:	83 c4 10             	add    $0x10,%esp
  // Jump into the scheduler, never to return.
  removeFromStateList(&ptable.pLists.running,RUNNING,proc);
80105559:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010555f:	83 ec 04             	sub    $0x4,%esp
80105562:	50                   	push   %eax
80105563:	6a 04                	push   $0x4
80105565:	68 f0 70 11 80       	push   $0x801170f0
8010556a:	e8 36 f4 ff ff       	call   801049a5 <removeFromStateList>
8010556f:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80105572:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105578:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  insertAtHead(&ptable.pLists.zombie,ZOMBIE,proc);
8010557f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105585:	83 ec 04             	sub    $0x4,%esp
80105588:	50                   	push   %eax
80105589:	6a 05                	push   $0x5
8010558b:	68 ec 70 11 80       	push   $0x801170ec
80105590:	e8 67 f5 ff ff       	call   80104afc <insertAtHead>
80105595:	83 c4 10             	add    $0x10,%esp
  sched();
80105598:	e8 48 04 00 00       	call   801059e5 <sched>
  panic("zombie exit");
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	68 a5 a5 10 80       	push   $0x8010a5a5
801055a5:	e8 bc af ff ff       	call   80100566 <panic>

801055aa <findKids>:
// Return -1 if this process has no children.
#ifdef CS333_P3P4

int
findKids(struct proc ** sList)
{
801055aa:	55                   	push   %ebp
801055ab:	89 e5                	mov    %esp,%ebp
801055ad:	83 ec 10             	sub    $0x10,%esp
	int havekids = 0;
801055b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	struct proc * p;
	struct proc * current = *sList;
801055b7:	8b 45 08             	mov    0x8(%ebp),%eax
801055ba:	8b 00                	mov    (%eax),%eax
801055bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(!*sList)return 0;
801055bf:	8b 45 08             	mov    0x8(%ebp),%eax
801055c2:	8b 00                	mov    (%eax),%eax
801055c4:	85 c0                	test   %eax,%eax
801055c6:	75 3e                	jne    80105606 <findKids+0x5c>
801055c8:	b8 00 00 00 00       	mov    $0x0,%eax
801055cd:	eb 40                	jmp    8010560f <findKids+0x65>
	while(current){
   	   p = current;
801055cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
   	   if(p->parent != proc){
801055d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d8:	8b 50 1c             	mov    0x1c(%eax),%edx
801055db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e1:	39 c2                	cmp    %eax,%edx
801055e3:	74 0e                	je     801055f3 <findKids+0x49>
   	     current = current->next;
801055e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055e8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801055ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
   	     continue;
801055f1:	eb 13                	jmp    80105606 <findKids+0x5c>
   	   }
   	   havekids = 1;
801055f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
   	   current = current->next;
801055fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055fd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105603:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
	int havekids = 0;
	struct proc * p;
	struct proc * current = *sList;
	if(!*sList)return 0;
	while(current){
80105606:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
8010560a:	75 c3                	jne    801055cf <findKids+0x25>
   	     continue;
   	   }
   	   havekids = 1;
   	   current = current->next;
   	}
	return havekids;
8010560c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010560f:	c9                   	leave  
80105610:	c3                   	ret    

80105611 <wait>:

int
wait(void)
{
80105611:	55                   	push   %ebp
80105612:	89 e5                	mov    %esp,%ebp
80105614:	83 ec 28             	sub    $0x28,%esp
  int i = 0;
80105617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  int havekids, pid;
  acquire(&ptable.lock);
8010561e:	83 ec 0c             	sub    $0xc,%esp
80105621:	68 a4 49 11 80       	push   $0x801149a4
80105626:	e8 a2 12 00 00       	call   801068cd <acquire>
8010562b:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010562e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    struct proc * current = ptable.pLists.zombie;
80105635:	a1 ec 70 11 80       	mov    0x801170ec,%eax
8010563a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while(current){
8010563d:	e9 fc 00 00 00       	jmp    8010573e <wait+0x12d>
      p = current;
80105642:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105645:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(p->parent != proc){
80105648:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010564b:	8b 50 1c             	mov    0x1c(%eax),%edx
8010564e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105654:	39 c2                	cmp    %eax,%edx
80105656:	74 11                	je     80105669 <wait+0x58>
	current = current->next;
80105658:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010565b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105661:	89 45 ec             	mov    %eax,-0x14(%ebp)
        continue;
80105664:	e9 d5 00 00 00       	jmp    8010573e <wait+0x12d>
      }
      havekids = 1;
80105669:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      current = current->next;
80105670:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105673:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105679:	89 45 ec             	mov    %eax,-0x14(%ebp)
      // Found one.
      pid = p->pid;
8010567c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010567f:	8b 40 10             	mov    0x10(%eax),%eax
80105682:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(p->kstack);
80105685:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105688:	8b 40 08             	mov    0x8(%eax),%eax
8010568b:	83 ec 0c             	sub    $0xc,%esp
8010568e:	50                   	push   %eax
8010568f:	e8 3f da ff ff       	call   801030d3 <kfree>
80105694:	83 c4 10             	add    $0x10,%esp
      p->kstack = 0;
80105697:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010569a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      freevm(p->pgdir);
801056a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056a4:	8b 40 04             	mov    0x4(%eax),%eax
801056a7:	83 ec 0c             	sub    $0xc,%esp
801056aa:	50                   	push   %eax
801056ab:	e8 3d 48 00 00       	call   80109eed <freevm>
801056b0:	83 c4 10             	add    $0x10,%esp
      p->pid = 0;
801056b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056b6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      p->parent = 0;
801056bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056c0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
      p->name[0] = 0;
801056c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056ca:	c6 40 74 00          	movb   $0x0,0x74(%eax)
      p->killed = 0;
801056ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056d1:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
      p->budget = 0;
801056d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056db:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801056e2:	00 00 00 
      p->prio = 0;
801056e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801056e8:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801056ef:	00 00 00 
      removeFromStateList(&ptable.pLists.zombie,ZOMBIE,p);
801056f2:	83 ec 04             	sub    $0x4,%esp
801056f5:	ff 75 e8             	pushl  -0x18(%ebp)
801056f8:	6a 05                	push   $0x5
801056fa:	68 ec 70 11 80       	push   $0x801170ec
801056ff:	e8 a1 f2 ff ff       	call   801049a5 <removeFromStateList>
80105704:	83 c4 10             	add    $0x10,%esp
      p->state = UNUSED;
80105707:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010570a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
      insertAtHead(&ptable.pLists.free,UNUSED,p);
80105711:	83 ec 04             	sub    $0x4,%esp
80105714:	ff 75 e8             	pushl  -0x18(%ebp)
80105717:	6a 00                	push   $0x0
80105719:	68 e4 70 11 80       	push   $0x801170e4
8010571e:	e8 d9 f3 ff ff       	call   80104afc <insertAtHead>
80105723:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
80105726:	83 ec 0c             	sub    $0xc,%esp
80105729:	68 a4 49 11 80       	push   $0x801149a4
8010572e:	e8 01 12 00 00       	call   80106934 <release>
80105733:	83 c4 10             	add    $0x10,%esp
      return pid;
80105736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105739:	e9 be 00 00 00       	jmp    801057fc <wait+0x1eb>
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    struct proc * current = ptable.pLists.zombie;
    while(current){
8010573e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105742:	0f 85 fa fe ff ff    	jne    80105642 <wait+0x31>
      p->state = UNUSED;
      insertAtHead(&ptable.pLists.free,UNUSED,p);
      release(&ptable.lock);
      return pid;
    }
    for(i = 0; i < MAX; i++)
80105748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010574f:	eb 26                	jmp    80105777 <wait+0x166>
    	havekids += findKids(&ptable.pLists.ready[i]);
80105751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105754:	05 cc 09 00 00       	add    $0x9cc,%eax
80105759:	c1 e0 02             	shl    $0x2,%eax
8010575c:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105761:	83 c0 08             	add    $0x8,%eax
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	50                   	push   %eax
80105768:	e8 3d fe ff ff       	call   801055aa <findKids>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	01 45 f0             	add    %eax,-0x10(%ebp)
      p->state = UNUSED;
      insertAtHead(&ptable.pLists.free,UNUSED,p);
      release(&ptable.lock);
      return pid;
    }
    for(i = 0; i < MAX; i++)
80105773:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105777:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
8010577b:	7e d4                	jle    80105751 <wait+0x140>
    	havekids += findKids(&ptable.pLists.ready[i]);
    havekids += findKids(&ptable.pLists.sleep);
8010577d:	83 ec 0c             	sub    $0xc,%esp
80105780:	68 e8 70 11 80       	push   $0x801170e8
80105785:	e8 20 fe ff ff       	call   801055aa <findKids>
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	01 45 f0             	add    %eax,-0x10(%ebp)
    havekids += findKids(&ptable.pLists.embryo);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 f4 70 11 80       	push   $0x801170f4
80105798:	e8 0d fe ff ff       	call   801055aa <findKids>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	01 45 f0             	add    %eax,-0x10(%ebp)
    havekids += findKids(&ptable.pLists.running);
801057a3:	83 ec 0c             	sub    $0xc,%esp
801057a6:	68 f0 70 11 80       	push   $0x801170f0
801057ab:	e8 fa fd ff ff       	call   801055aa <findKids>
801057b0:	83 c4 10             	add    $0x10,%esp
801057b3:	01 45 f0             	add    %eax,-0x10(%ebp)
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801057b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057ba:	74 0d                	je     801057c9 <wait+0x1b8>
801057bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057c2:	8b 40 2c             	mov    0x2c(%eax),%eax
801057c5:	85 c0                	test   %eax,%eax
801057c7:	74 17                	je     801057e0 <wait+0x1cf>
      release(&ptable.lock);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	68 a4 49 11 80       	push   $0x801149a4
801057d1:	e8 5e 11 00 00       	call   80106934 <release>
801057d6:	83 c4 10             	add    $0x10,%esp
      return -1;
801057d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057de:	eb 1c                	jmp    801057fc <wait+0x1eb>
    }

    // Wait for children to exit.  (See wakeup1gcall in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801057e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057e6:	83 ec 08             	sub    $0x8,%esp
801057e9:	68 a4 49 11 80       	push   $0x801149a4
801057ee:	50                   	push   %eax
801057ef:	e8 36 04 00 00       	call   80105c2a <sleep>
801057f4:	83 c4 10             	add    $0x10,%esp
  }
801057f7:	e9 32 fe ff ff       	jmp    8010562e <wait+0x1d>
}
801057fc:	c9                   	leave  
801057fd:	c3                   	ret    

801057fe <scheduler>:
}

#else
void
scheduler(void)
{
801057fe:	55                   	push   %ebp
801057ff:	89 e5                	mov    %esp,%ebp
80105801:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle
  int i = 0;
80105804:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Enable interrupts on this processor.
    sti();
8010580b:	e8 4f f1 ff ff       	call   8010495f <sti>

    idle = 1;  // assume idle unless we schedule a process
80105810:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80105817:	83 ec 0c             	sub    $0xc,%esp
8010581a:	68 a4 49 11 80       	push   $0x801149a4
8010581f:	e8 a9 10 00 00       	call   801068cd <acquire>
80105824:	83 c4 10             	add    $0x10,%esp
    for(i = 0; i < MAX; ++i){
80105827:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010582e:	e9 7f 01 00 00       	jmp    801059b2 <scheduler+0x1b4>
    	if(ptable.pLists.ready[i]){
80105833:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105836:	05 cc 09 00 00       	add    $0x9cc,%eax
8010583b:	8b 04 85 a8 49 11 80 	mov    -0x7feeb658(,%eax,4),%eax
80105842:	85 c0                	test   %eax,%eax
80105844:	0f 84 64 01 00 00    	je     801059ae <scheduler+0x1b0>
    	  p= ptable.pLists.ready[i];
8010584a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584d:	05 cc 09 00 00       	add    $0x9cc,%eax
80105852:	8b 04 85 a8 49 11 80 	mov    -0x7feeb658(,%eax,4),%eax
80105859:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	  removeFromStateList(&ptable.pLists.ready[i],RUNNABLE,p);
8010585c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010585f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105862:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105868:	c1 e2 02             	shl    $0x2,%edx
8010586b:	81 c2 a0 49 11 80    	add    $0x801149a0,%edx
80105871:	83 c2 08             	add    $0x8,%edx
80105874:	83 ec 04             	sub    $0x4,%esp
80105877:	50                   	push   %eax
80105878:	6a 03                	push   $0x3
8010587a:	52                   	push   %edx
8010587b:	e8 25 f1 ff ff       	call   801049a5 <removeFromStateList>
80105880:	83 c4 10             	add    $0x10,%esp
    	  // Switch to chosen process.  It is the process's job
    	  // to release ptable.lock and then reacquire it
    	  // before jumping back to us.
    	  idle = 0;  // not idle this timeslice
80105883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	  proc = p;
8010588a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010588d:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
    	  switchuvm(p);
80105893:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105896:	83 ec 0c             	sub    $0xc,%esp
80105899:	50                   	push   %eax
8010589a:	e8 08 42 00 00       	call   80109aa7 <switchuvm>
8010589f:	83 c4 10             	add    $0x10,%esp
    	  p->state = RUNNING;
801058a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058a5:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    	  insertAtHead(&ptable.pLists.running,RUNNING,p);
801058ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058af:	83 ec 04             	sub    $0x4,%esp
801058b2:	50                   	push   %eax
801058b3:	6a 04                	push   $0x4
801058b5:	68 f0 70 11 80       	push   $0x801170f0
801058ba:	e8 3d f2 ff ff       	call   80104afc <insertAtHead>
801058bf:	83 c4 10             	add    $0x10,%esp
    	  p->cpu_ticks_in = ticks;
801058c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058c5:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801058cb:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    	  swtch(&cpu->scheduler, proc->context);
801058d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d7:	8b 40 24             	mov    0x24(%eax),%eax
801058da:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801058e1:	83 c2 04             	add    $0x4,%edx
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	50                   	push   %eax
801058e8:	52                   	push   %edx
801058e9:	e8 b6 14 00 00       	call   80106da4 <swtch>
801058ee:	83 c4 10             	add    $0x10,%esp
    	  switchkvm();
801058f1:	e8 94 41 00 00       	call   80109a8a <switchkvm>
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  proc = 0;
801058f6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801058fd:	00 00 00 00 
	  if(ptable.PromoteAtTime <= ticks){
80105901:	8b 15 a0 49 11 80    	mov    0x801149a0,%edx
80105907:	a1 00 79 11 80       	mov    0x80117900,%eax
8010590c:	39 c2                	cmp    %eax,%edx
8010590e:	0f 87 93 00 00 00    	ja     801059a7 <scheduler+0x1a9>
	  	for(i = 1;i < MAX;++i){
80105914:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
8010591b:	eb 75                	jmp    80105992 <scheduler+0x194>
			setPrioBudgetList(&ptable.pLists.ready[i],i-1);
8010591d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105920:	8d 50 ff             	lea    -0x1(%eax),%edx
80105923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105926:	05 cc 09 00 00       	add    $0x9cc,%eax
8010592b:	c1 e0 02             	shl    $0x2,%eax
8010592e:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105933:	83 c0 08             	add    $0x8,%eax
80105936:	83 ec 08             	sub    $0x8,%esp
80105939:	52                   	push   %edx
8010593a:	50                   	push   %eax
8010593b:	e8 92 f2 ff ff       	call   80104bd2 <setPrioBudgetList>
80105940:	83 c4 10             	add    $0x10,%esp
			p = ptable.pLists.ready[i];
80105943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105946:	05 cc 09 00 00       	add    $0x9cc,%eax
8010594b:	8b 04 85 a8 49 11 80 	mov    -0x7feeb658(,%eax,4),%eax
80105952:	89 45 ec             	mov    %eax,-0x14(%ebp)
			ptable.pLists.ready[i] = 0;
80105955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105958:	05 cc 09 00 00       	add    $0x9cc,%eax
8010595d:	c7 04 85 a8 49 11 80 	movl   $0x0,-0x7feeb658(,%eax,4)
80105964:	00 00 00 00 
			clipToBack(&ptable.pLists.ready[i-1],&p);
80105968:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010596b:	83 e8 01             	sub    $0x1,%eax
8010596e:	05 cc 09 00 00       	add    $0x9cc,%eax
80105973:	c1 e0 02             	shl    $0x2,%eax
80105976:	05 a0 49 11 80       	add    $0x801149a0,%eax
8010597b:	8d 50 08             	lea    0x8(%eax),%edx
8010597e:	83 ec 08             	sub    $0x8,%esp
80105981:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105984:	50                   	push   %eax
80105985:	52                   	push   %edx
80105986:	e8 ef f1 ff ff       	call   80104b7a <clipToBack>
8010598b:	83 c4 10             	add    $0x10,%esp
    	  switchkvm();
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  proc = 0;
	  if(ptable.PromoteAtTime <= ticks){
	  	for(i = 1;i < MAX;++i){
8010598e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105992:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80105996:	7e 85                	jle    8010591d <scheduler+0x11f>
			setPrioBudgetList(&ptable.pLists.ready[i],i-1);
			p = ptable.pLists.ready[i];
			ptable.pLists.ready[i] = 0;
			clipToBack(&ptable.pLists.ready[i-1],&p);
		}
		ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; 
80105998:	a1 00 79 11 80       	mov    0x80117900,%eax
8010599d:	05 2c 01 00 00       	add    $0x12c,%eax
801059a2:	a3 a0 49 11 80       	mov    %eax,0x801149a0
	  }
	  i = MAX;
801059a7:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(i = 0; i < MAX; ++i){
801059ae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801059b2:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
801059b6:	0f 8e 77 fe ff ff    	jle    80105833 <scheduler+0x35>
		ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE; 
	  }
	  i = MAX;
    	}
    }
    release(&ptable.lock);
801059bc:	83 ec 0c             	sub    $0xc,%esp
801059bf:	68 a4 49 11 80       	push   $0x801149a4
801059c4:	e8 6b 0f 00 00       	call   80106934 <release>
801059c9:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
801059cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059d0:	0f 84 35 fe ff ff    	je     8010580b <scheduler+0xd>
      sti();
801059d6:	e8 84 ef ff ff       	call   8010495f <sti>
      hlt();
801059db:	e8 68 ef ff ff       	call   80104948 <hlt>
    }
  }
801059e0:	e9 26 fe ff ff       	jmp    8010580b <scheduler+0xd>

801059e5 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801059e5:	55                   	push   %ebp
801059e6:	89 e5                	mov    %esp,%ebp
801059e8:	53                   	push   %ebx
801059e9:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
801059ec:	83 ec 0c             	sub    $0xc,%esp
801059ef:	68 a4 49 11 80       	push   $0x801149a4
801059f4:	e8 07 10 00 00       	call   80106a00 <holding>
801059f9:	83 c4 10             	add    $0x10,%esp
801059fc:	85 c0                	test   %eax,%eax
801059fe:	75 0d                	jne    80105a0d <sched+0x28>
    panic("sched ptable.lock");
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	68 b1 a5 10 80       	push   $0x8010a5b1
80105a08:	e8 59 ab ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105a0d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a13:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105a19:	83 f8 01             	cmp    $0x1,%eax
80105a1c:	74 0d                	je     80105a2b <sched+0x46>
    panic("sched locks");
80105a1e:	83 ec 0c             	sub    $0xc,%esp
80105a21:	68 c3 a5 10 80       	push   $0x8010a5c3
80105a26:	e8 3b ab ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105a2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a31:	8b 40 0c             	mov    0xc(%eax),%eax
80105a34:	83 f8 04             	cmp    $0x4,%eax
80105a37:	75 0d                	jne    80105a46 <sched+0x61>
    panic("sched running");
80105a39:	83 ec 0c             	sub    $0xc,%esp
80105a3c:	68 cf a5 10 80       	push   $0x8010a5cf
80105a41:	e8 20 ab ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105a46:	e8 04 ef ff ff       	call   8010494f <readeflags>
80105a4b:	25 00 02 00 00       	and    $0x200,%eax
80105a50:	85 c0                	test   %eax,%eax
80105a52:	74 0d                	je     80105a61 <sched+0x7c>
    panic("sched interruptible");
80105a54:	83 ec 0c             	sub    $0xc,%esp
80105a57:	68 dd a5 10 80       	push   $0x8010a5dd
80105a5c:	e8 05 ab ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80105a61:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105a67:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total = proc->cpu_ticks_total + (ticks - proc->cpu_ticks_in);
80105a70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a76:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105a7d:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105a83:	8b 1d 00 79 11 80    	mov    0x80117900,%ebx
80105a89:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105a90:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80105a96:	29 d3                	sub    %edx,%ebx
80105a98:	89 da                	mov    %ebx,%edx
80105a9a:	01 ca                	add    %ecx,%edx
80105a9c:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80105aa2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105aa8:	8b 40 04             	mov    0x4(%eax),%eax
80105aab:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105ab2:	83 c2 24             	add    $0x24,%edx
80105ab5:	83 ec 08             	sub    $0x8,%esp
80105ab8:	50                   	push   %eax
80105ab9:	52                   	push   %edx
80105aba:	e8 e5 12 00 00       	call   80106da4 <swtch>
80105abf:	83 c4 10             	add    $0x10,%esp
  
  cpu->intena = intena;
80105ac2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105acb:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105ad1:	90                   	nop
80105ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    

80105ad7 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105ad7:	55                   	push   %ebp
80105ad8:	89 e5                	mov    %esp,%ebp
80105ada:	53                   	push   %ebx
80105adb:	83 ec 04             	sub    $0x4,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105ade:	83 ec 0c             	sub    $0xc,%esp
80105ae1:	68 a4 49 11 80       	push   $0x801149a4
80105ae6:	e8 e2 0d 00 00       	call   801068cd <acquire>
80105aeb:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.running,RUNNING,proc);
80105aee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105af4:	83 ec 04             	sub    $0x4,%esp
80105af7:	50                   	push   %eax
80105af8:	6a 04                	push   $0x4
80105afa:	68 f0 70 11 80       	push   $0x801170f0
80105aff:	e8 a1 ee ff ff       	call   801049a5 <removeFromStateList>
80105b04:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80105b07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b0d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
80105b14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105b21:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105b27:	89 d3                	mov    %edx,%ebx
80105b29:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105b30:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105b36:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80105b3c:	29 d1                	sub    %edx,%ecx
80105b3e:	89 ca                	mov    %ecx,%edx
80105b40:	01 da                	add    %ebx,%edx
80105b42:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if(proc->budget <= 0 ){
80105b48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b4e:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105b54:	85 c0                	test   %eax,%eax
80105b56:	7f 3d                	jg     80105b95 <yield+0xbe>
	if(proc->prio < MAX-1)
80105b58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105b64:	83 f8 01             	cmp    $0x1,%eax
80105b67:	77 1c                	ja     80105b85 <yield+0xae>
		proc->prio = proc->prio + 1;
80105b69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b6f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105b76:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105b7c:	83 c2 01             	add    $0x1,%edx
80105b7f:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
	proc->budget = BUDGET_MAX;
80105b85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b8b:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
80105b92:	01 00 00 
  }
  insertRoundRobin(&ptable.pLists.ready[proc->prio],RUNNABLE,proc);
80105b95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b9b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105ba2:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105ba8:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105bae:	c1 e2 02             	shl    $0x2,%edx
80105bb1:	81 c2 a0 49 11 80    	add    $0x801149a0,%edx
80105bb7:	83 c2 08             	add    $0x8,%edx
80105bba:	83 ec 04             	sub    $0x4,%esp
80105bbd:	50                   	push   %eax
80105bbe:	6a 03                	push   $0x3
80105bc0:	52                   	push   %edx
80105bc1:	e8 b7 ee ff ff       	call   80104a7d <insertRoundRobin>
80105bc6:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = RUNNABLE;
  #endif
  sched();
80105bc9:	e8 17 fe ff ff       	call   801059e5 <sched>
  release(&ptable.lock);
80105bce:	83 ec 0c             	sub    $0xc,%esp
80105bd1:	68 a4 49 11 80       	push   $0x801149a4
80105bd6:	e8 59 0d 00 00       	call   80106934 <release>
80105bdb:	83 c4 10             	add    $0x10,%esp
}
80105bde:	90                   	nop
80105bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be2:	c9                   	leave  
80105be3:	c3                   	ret    

80105be4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105bea:	83 ec 0c             	sub    $0xc,%esp
80105bed:	68 a4 49 11 80       	push   $0x801149a4
80105bf2:	e8 3d 0d 00 00       	call   80106934 <release>
80105bf7:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105bfa:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105bff:	85 c0                	test   %eax,%eax
80105c01:	74 24                	je     80105c27 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105c03:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105c0a:	00 00 00 
    iinit(ROOTDEV);
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	6a 01                	push   $0x1
80105c12:	e8 6b bb ff ff       	call   80101782 <iinit>
80105c17:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105c1a:	83 ec 0c             	sub    $0xc,%esp
80105c1d:	6a 01                	push   $0x1
80105c1f:	e8 15 dc ff ff       	call   80103839 <initlog>
80105c24:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105c27:	90                   	nop
80105c28:	c9                   	leave  
80105c29:	c3                   	ret    

80105c2a <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105c2a:	55                   	push   %ebp
80105c2b:	89 e5                	mov    %esp,%ebp
80105c2d:	53                   	push   %ebx
80105c2e:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
80105c31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c37:	85 c0                	test   %eax,%eax
80105c39:	75 0d                	jne    80105c48 <sleep+0x1e>
    panic("sleep");
80105c3b:	83 ec 0c             	sub    $0xc,%esp
80105c3e:	68 f1 a5 10 80       	push   $0x8010a5f1
80105c43:	e8 1e a9 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105c48:	81 7d 0c a4 49 11 80 	cmpl   $0x801149a4,0xc(%ebp)
80105c4f:	74 24                	je     80105c75 <sleep+0x4b>
    acquire(&ptable.lock);
80105c51:	83 ec 0c             	sub    $0xc,%esp
80105c54:	68 a4 49 11 80       	push   $0x801149a4
80105c59:	e8 6f 0c 00 00       	call   801068cd <acquire>
80105c5e:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c65:	74 0e                	je     80105c75 <sleep+0x4b>
80105c67:	83 ec 0c             	sub    $0xc,%esp
80105c6a:	ff 75 0c             	pushl  0xc(%ebp)
80105c6d:	e8 c2 0c 00 00       	call   80106934 <release>
80105c72:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105c75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7b:	8b 55 08             	mov    0x8(%ebp),%edx
80105c7e:	89 50 28             	mov    %edx,0x28(%eax)
  #ifdef CS333_P3P4
  removeFromStateList(&ptable.pLists.running,RUNNING,proc);
80105c81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c87:	83 ec 04             	sub    $0x4,%esp
80105c8a:	50                   	push   %eax
80105c8b:	6a 04                	push   $0x4
80105c8d:	68 f0 70 11 80       	push   $0x801170f0
80105c92:	e8 0e ed ff ff       	call   801049a5 <removeFromStateList>
80105c97:	83 c4 10             	add    $0x10,%esp
  proc->state = SLEEPING;
80105c9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
80105ca7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cad:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105cb4:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105cba:	89 d3                	mov    %edx,%ebx
80105cbc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105cc3:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105cc9:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80105ccf:	29 d1                	sub    %edx,%ecx
80105cd1:	89 ca                	mov    %ecx,%edx
80105cd3:	01 da                	add    %ebx,%edx
80105cd5:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if(proc->budget <= 0){
80105cdb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ce1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105ce7:	85 c0                	test   %eax,%eax
80105ce9:	7f 2c                	jg     80105d17 <sleep+0xed>
	if(proc->prio >= 0)
		proc->prio = proc->prio + 1;
80105ceb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cf1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105cf8:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105cfe:	83 c2 01             	add    $0x1,%edx
80105d01:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
	proc->budget = BUDGET_MAX;
80105d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d0d:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
80105d14:	01 00 00 
  }
  insertAtHead(&ptable.pLists.sleep,SLEEPING,proc);
80105d17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d1d:	83 ec 04             	sub    $0x4,%esp
80105d20:	50                   	push   %eax
80105d21:	6a 02                	push   $0x2
80105d23:	68 e8 70 11 80       	push   $0x801170e8
80105d28:	e8 cf ed ff ff       	call   80104afc <insertAtHead>
80105d2d:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = SLEEPING;
  #endif
  sched();
80105d30:	e8 b0 fc ff ff       	call   801059e5 <sched>

  // Tidy up.
  proc->chan = 0;
80105d35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d3b:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105d42:	81 7d 0c a4 49 11 80 	cmpl   $0x801149a4,0xc(%ebp)
80105d49:	74 24                	je     80105d6f <sleep+0x145>
    release(&ptable.lock);
80105d4b:	83 ec 0c             	sub    $0xc,%esp
80105d4e:	68 a4 49 11 80       	push   $0x801149a4
80105d53:	e8 dc 0b 00 00       	call   80106934 <release>
80105d58:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105d5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d5f:	74 0e                	je     80105d6f <sleep+0x145>
80105d61:	83 ec 0c             	sub    $0xc,%esp
80105d64:	ff 75 0c             	pushl  0xc(%ebp)
80105d67:	e8 61 0b 00 00       	call   801068cd <acquire>
80105d6c:	83 c4 10             	add    $0x10,%esp
  }
}
80105d6f:	90                   	nop
80105d70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d73:	c9                   	leave  
80105d74:	c3                   	ret    

80105d75 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct proc * current =ptable.pLists.sleep;
80105d7b:	a1 e8 70 11 80       	mov    0x801170e8,%eax
80105d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(current){
80105d83:	eb 74                	jmp    80105df9 <wakeup1+0x84>
    p = current;
80105d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(p->chan == chan){
80105d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8e:	8b 40 28             	mov    0x28(%eax),%eax
80105d91:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d94:	75 57                	jne    80105ded <wakeup1+0x78>
        current = current->next;
80105d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d99:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	removeFromStateList(&ptable.pLists.sleep,SLEEPING,p);
80105da2:	83 ec 04             	sub    $0x4,%esp
80105da5:	ff 75 f0             	pushl  -0x10(%ebp)
80105da8:	6a 02                	push   $0x2
80105daa:	68 e8 70 11 80       	push   $0x801170e8
80105daf:	e8 f1 eb ff ff       	call   801049a5 <removeFromStateList>
80105db4:	83 c4 10             	add    $0x10,%esp
      	p->state = RUNNABLE;
80105db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	insertRoundRobin(&ptable.pLists.ready[p->prio],RUNNABLE,p);
80105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc4:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105dca:	05 cc 09 00 00       	add    $0x9cc,%eax
80105dcf:	c1 e0 02             	shl    $0x2,%eax
80105dd2:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105dd7:	83 c0 08             	add    $0x8,%eax
80105dda:	83 ec 04             	sub    $0x4,%esp
80105ddd:	ff 75 f0             	pushl  -0x10(%ebp)
80105de0:	6a 03                	push   $0x3
80105de2:	50                   	push   %eax
80105de3:	e8 95 ec ff ff       	call   80104a7d <insertRoundRobin>
80105de8:	83 c4 10             	add    $0x10,%esp
80105deb:	eb 0c                	jmp    80105df9 <wakeup1+0x84>
      }
    else
    {
	current = current->next;
80105ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
static void
wakeup1(void *chan)
{
  struct proc *p;
  struct proc * current =ptable.pLists.sleep;
  while(current){
80105df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dfd:	75 86                	jne    80105d85 <wakeup1+0x10>
    else
    {
	current = current->next;
    }
  }
}
80105dff:	90                   	nop
80105e00:	c9                   	leave  
80105e01:	c3                   	ret    

80105e02 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105e02:	55                   	push   %ebp
80105e03:	89 e5                	mov    %esp,%ebp
80105e05:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105e08:	83 ec 0c             	sub    $0xc,%esp
80105e0b:	68 a4 49 11 80       	push   $0x801149a4
80105e10:	e8 b8 0a 00 00       	call   801068cd <acquire>
80105e15:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105e18:	83 ec 0c             	sub    $0xc,%esp
80105e1b:	ff 75 08             	pushl  0x8(%ebp)
80105e1e:	e8 52 ff ff ff       	call   80105d75 <wakeup1>
80105e23:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105e26:	83 ec 0c             	sub    $0xc,%esp
80105e29:	68 a4 49 11 80       	push   $0x801149a4
80105e2e:	e8 01 0b 00 00       	call   80106934 <release>
80105e33:	83 c4 10             	add    $0x10,%esp
}
80105e36:	90                   	nop
80105e37:	c9                   	leave  
80105e38:	c3                   	ret    

80105e39 <kill>:
  return -1;
}
#else
int
kill(int pid)
{
80105e39:	55                   	push   %ebp
80105e3a:	89 e5                	mov    %esp,%ebp
80105e3c:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
80105e3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  struct proc *current;
  acquire(&ptable.lock);
80105e46:	83 ec 0c             	sub    $0xc,%esp
80105e49:	68 a4 49 11 80       	push   $0x801149a4
80105e4e:	e8 7a 0a 00 00       	call   801068cd <acquire>
80105e53:	83 c4 10             	add    $0x10,%esp
  killState(&ptable.pLists.running,RUNNING,pid);
80105e56:	83 ec 04             	sub    $0x4,%esp
80105e59:	ff 75 08             	pushl  0x8(%ebp)
80105e5c:	6a 04                	push   $0x4
80105e5e:	68 f0 70 11 80       	push   $0x801170f0
80105e63:	e8 c8 ec ff ff       	call   80104b30 <killState>
80105e68:	83 c4 10             	add    $0x10,%esp
  killState(&ptable.pLists.embryo,EMBRYO,pid);
80105e6b:	83 ec 04             	sub    $0x4,%esp
80105e6e:	ff 75 08             	pushl  0x8(%ebp)
80105e71:	6a 01                	push   $0x1
80105e73:	68 f4 70 11 80       	push   $0x801170f4
80105e78:	e8 b3 ec ff ff       	call   80104b30 <killState>
80105e7d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < MAX; i++)
80105e80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105e87:	eb 28                	jmp    80105eb1 <kill+0x78>
  	killState(&ptable.pLists.ready[i],RUNNABLE,pid);
80105e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8c:	05 cc 09 00 00       	add    $0x9cc,%eax
80105e91:	c1 e0 02             	shl    $0x2,%eax
80105e94:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105e99:	83 c0 08             	add    $0x8,%eax
80105e9c:	83 ec 04             	sub    $0x4,%esp
80105e9f:	ff 75 08             	pushl  0x8(%ebp)
80105ea2:	6a 03                	push   $0x3
80105ea4:	50                   	push   %eax
80105ea5:	e8 86 ec ff ff       	call   80104b30 <killState>
80105eaa:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  struct proc *current;
  acquire(&ptable.lock);
  killState(&ptable.pLists.running,RUNNING,pid);
  killState(&ptable.pLists.embryo,EMBRYO,pid);
  for(i = 0; i < MAX; i++)
80105ead:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105eb1:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
80105eb5:	7e d2                	jle    80105e89 <kill+0x50>
  	killState(&ptable.pLists.ready[i],RUNNABLE,pid);
  current = ptable.pLists.sleep;
80105eb7:	a1 e8 70 11 80       	mov    0x801170e8,%eax
80105ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(current){
80105ebf:	e9 95 00 00 00       	jmp    80105f59 <kill+0x120>
    p = current;
80105ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->pid == pid){
80105eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ecd:	8b 50 10             	mov    0x10(%eax),%edx
80105ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ed3:	39 c2                	cmp    %eax,%edx
80105ed5:	75 76                	jne    80105f4d <kill+0x114>
      p->killed = 1;
80105ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105eda:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
      // Wake process from sleep if necessary.
      current = current->next;
80105ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105eea:	89 45 f0             	mov    %eax,-0x10(%ebp)
      removeFromStateList(&ptable.pLists.sleep,SLEEPING,p);
80105eed:	83 ec 04             	sub    $0x4,%esp
80105ef0:	ff 75 ec             	pushl  -0x14(%ebp)
80105ef3:	6a 02                	push   $0x2
80105ef5:	68 e8 70 11 80       	push   $0x801170e8
80105efa:	e8 a6 ea ff ff       	call   801049a5 <removeFromStateList>
80105eff:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
80105f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      insertRoundRobin(&ptable.pLists.ready[p->prio],RUNNABLE,p);
80105f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f0f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105f15:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f1a:	c1 e0 02             	shl    $0x2,%eax
80105f1d:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105f22:	83 c0 08             	add    $0x8,%eax
80105f25:	83 ec 04             	sub    $0x4,%esp
80105f28:	ff 75 ec             	pushl  -0x14(%ebp)
80105f2b:	6a 03                	push   $0x3
80105f2d:	50                   	push   %eax
80105f2e:	e8 4a eb ff ff       	call   80104a7d <insertRoundRobin>
80105f33:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
80105f36:	83 ec 0c             	sub    $0xc,%esp
80105f39:	68 a4 49 11 80       	push   $0x801149a4
80105f3e:	e8 f1 09 00 00       	call   80106934 <release>
80105f43:	83 c4 10             	add    $0x10,%esp
      return 0;
80105f46:	b8 00 00 00 00       	mov    $0x0,%eax
80105f4b:	eb 2b                	jmp    80105f78 <kill+0x13f>
    }
    else current = current->next;
80105f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f50:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  killState(&ptable.pLists.running,RUNNING,pid);
  killState(&ptable.pLists.embryo,EMBRYO,pid);
  for(i = 0; i < MAX; i++)
  	killState(&ptable.pLists.ready[i],RUNNABLE,pid);
  current = ptable.pLists.sleep;
  while(current){
80105f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f5d:	0f 85 61 ff ff ff    	jne    80105ec4 <kill+0x8b>
      release(&ptable.lock);
      return 0;
    }
    else current = current->next;
  }
  release(&ptable.lock);
80105f63:	83 ec 0c             	sub    $0xc,%esp
80105f66:	68 a4 49 11 80       	push   $0x801149a4
80105f6b:	e8 c4 09 00 00       	call   80106934 <release>
80105f70:	83 c4 10             	add    $0x10,%esp
  return -1;
80105f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80105f78:	c9                   	leave  
80105f79:	c3                   	ret    

80105f7a <spacehelper>:
  [ZOMBIE]    "zombie"
};

int
spacehelper(int curstring,int largeststring)
{
80105f7a:	55                   	push   %ebp
80105f7b:	89 e5                	mov    %esp,%ebp
80105f7d:	83 ec 18             	sub    $0x18,%esp
	int i = 0;
80105f80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if(curstring > largeststring)
80105f87:	8b 45 08             	mov    0x8(%ebp),%eax
80105f8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105f8d:	7e 05                	jle    80105f94 <spacehelper+0x1a>
		return curstring;
80105f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80105f92:	eb 2b                	jmp    80105fbf <spacehelper+0x45>
	else{
		for(i = 0; i < (largeststring - curstring);++i)
80105f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f9b:	eb 14                	jmp    80105fb1 <spacehelper+0x37>
			cprintf(" ");
80105f9d:	83 ec 0c             	sub    $0xc,%esp
80105fa0:	68 21 a6 10 80       	push   $0x8010a621
80105fa5:	e8 1c a4 ff ff       	call   801003c6 <cprintf>
80105faa:	83 c4 10             	add    $0x10,%esp
{
	int i = 0;
	if(curstring > largeststring)
		return curstring;
	else{
		for(i = 0; i < (largeststring - curstring);++i)
80105fad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fb4:	2b 45 08             	sub    0x8(%ebp),%eax
80105fb7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fba:	7f e1                	jg     80105f9d <spacehelper+0x23>
			cprintf(" ");
		return largeststring;
80105fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
	}
}
80105fbf:	c9                   	leave  
80105fc0:	c3                   	ret    

80105fc1 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105fc1:	55                   	push   %ebp
80105fc2:	89 e5                	mov    %esp,%ebp
80105fc4:	53                   	push   %ebx
80105fc5:	83 ec 74             	sub    $0x74,%esp
  uint sec;
  uint millisec;
  uint cpusec;
  uint cpumillisec;
  uint pc[10];
  cprintf("\nPID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size	PCs\n");
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	68 24 a6 10 80       	push   $0x8010a624
80105fd0:	e8 f1 a3 ff ff       	call   801003c6 <cprintf>
80105fd5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105fd8:	c7 45 f0 d8 49 11 80 	movl   $0x801149d8,-0x10(%ebp)
80105fdf:	e9 1d 02 00 00       	jmp    80106201 <procdump+0x240>
    if(p->state == UNUSED)
80105fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe7:	8b 40 0c             	mov    0xc(%eax),%eax
80105fea:	85 c0                	test   %eax,%eax
80105fec:	0f 84 07 02 00 00    	je     801061f9 <procdump+0x238>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff5:	8b 40 0c             	mov    0xc(%eax),%eax
80105ff8:	83 f8 05             	cmp    $0x5,%eax
80105ffb:	77 23                	ja     80106020 <procdump+0x5f>
80105ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106000:	8b 40 0c             	mov    0xc(%eax),%eax
80106003:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010600a:	85 c0                	test   %eax,%eax
8010600c:	74 12                	je     80106020 <procdump+0x5f>
      state = states[p->state];
8010600e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106011:	8b 40 0c             	mov    0xc(%eax),%eax
80106014:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010601b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010601e:	eb 07                	jmp    80106027 <procdump+0x66>
    else
      state = "???";
80106020:	c7 45 ec 5c a6 10 80 	movl   $0x8010a65c,-0x14(%ebp)
      overalltime = ticks - p-> start_ticks;
80106027:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010602d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106030:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106036:	29 c2                	sub    %eax,%edx
80106038:	89 d0                	mov    %edx,%eax
8010603a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      sec = 0.01 * overalltime;
8010603d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106040:	ba 00 00 00 00       	mov    $0x0,%edx
80106045:	89 45 88             	mov    %eax,-0x78(%ebp)
80106048:	89 55 8c             	mov    %edx,-0x74(%ebp)
8010604b:	df 6d 88             	fildll -0x78(%ebp)
8010604e:	dd 5d a0             	fstpl  -0x60(%ebp)
80106051:	dd 45 a0             	fldl   -0x60(%ebp)
80106054:	dd 05 90 a7 10 80    	fldl   0x8010a790
8010605a:	de c9                	fmulp  %st,%st(1)
8010605c:	d9 7d 9e             	fnstcw -0x62(%ebp)
8010605f:	0f b7 45 9e          	movzwl -0x62(%ebp),%eax
80106063:	b4 0c                	mov    $0xc,%ah
80106065:	66 89 45 9c          	mov    %ax,-0x64(%ebp)
80106069:	d9 6d 9c             	fldcw  -0x64(%ebp)
8010606c:	df 7d 90             	fistpll -0x70(%ebp)
8010606f:	d9 6d 9e             	fldcw  -0x62(%ebp)
80106072:	8b 45 90             	mov    -0x70(%ebp),%eax
80106075:	8b 55 94             	mov    -0x6c(%ebp),%edx
80106078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      millisec = overalltime % 100;
8010607b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
8010607e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80106083:	89 c8                	mov    %ecx,%eax
80106085:	f7 e2                	mul    %edx
80106087:	89 d0                	mov    %edx,%eax
80106089:	c1 e8 05             	shr    $0x5,%eax
8010608c:	6b c0 64             	imul   $0x64,%eax,%eax
8010608f:	29 c1                	sub    %eax,%ecx
80106091:	89 c8                	mov    %ecx,%eax
80106093:	89 45 e0             	mov    %eax,-0x20(%ebp)
      cpusec = p->cpu_ticks_total * 0.01;
80106096:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106099:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010609f:	89 45 88             	mov    %eax,-0x78(%ebp)
801060a2:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
801060a9:	df 6d 88             	fildll -0x78(%ebp)
801060ac:	dd 5d a0             	fstpl  -0x60(%ebp)
801060af:	dd 45 a0             	fldl   -0x60(%ebp)
801060b2:	dd 05 90 a7 10 80    	fldl   0x8010a790
801060b8:	de c9                	fmulp  %st,%st(1)
801060ba:	d9 6d 9c             	fldcw  -0x64(%ebp)
801060bd:	df 7d 90             	fistpll -0x70(%ebp)
801060c0:	d9 6d 9e             	fldcw  -0x62(%ebp)
801060c3:	8b 45 90             	mov    -0x70(%ebp),%eax
801060c6:	8b 55 94             	mov    -0x6c(%ebp),%edx
801060c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
      cpumillisec = p->cpu_ticks_total % 100;
801060cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cf:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
801060d5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801060da:	89 c8                	mov    %ecx,%eax
801060dc:	f7 e2                	mul    %edx
801060de:	89 d0                	mov    %edx,%eax
801060e0:	c1 e8 05             	shr    $0x5,%eax
801060e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
801060e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801060e9:	6b c0 64             	imul   $0x64,%eax,%eax
801060ec:	29 c1                	sub    %eax,%ecx
801060ee:	89 c8                	mov    %ecx,%eax
801060f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
      cprintf("%d   	%s	%d	%d	", p->pid, p->name,p->uid,p->gid);
801060f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f6:	8b 48 18             	mov    0x18(%eax),%ecx
801060f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060fc:	8b 50 14             	mov    0x14(%eax),%edx
801060ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106102:	8d 58 74             	lea    0x74(%eax),%ebx
80106105:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106108:	8b 40 10             	mov    0x10(%eax),%eax
8010610b:	83 ec 0c             	sub    $0xc,%esp
8010610e:	51                   	push   %ecx
8010610f:	52                   	push   %edx
80106110:	53                   	push   %ebx
80106111:	50                   	push   %eax
80106112:	68 60 a6 10 80       	push   $0x8010a660
80106117:	e8 aa a2 ff ff       	call   801003c6 <cprintf>
8010611c:	83 c4 20             	add    $0x20,%esp
      if(p->parent == 0)
8010611f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106122:	8b 40 1c             	mov    0x1c(%eax),%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	75 19                	jne    80106142 <procdump+0x181>
        cprintf("%d	", p->pid);
80106129:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612c:	8b 40 10             	mov    0x10(%eax),%eax
8010612f:	83 ec 08             	sub    $0x8,%esp
80106132:	50                   	push   %eax
80106133:	68 70 a6 10 80       	push   $0x8010a670
80106138:	e8 89 a2 ff ff       	call   801003c6 <cprintf>
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	eb 1a                	jmp    8010615c <procdump+0x19b>
      else 
	cprintf("%d	",p->parent->pid);
80106142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106145:	8b 40 1c             	mov    0x1c(%eax),%eax
80106148:	8b 40 10             	mov    0x10(%eax),%eax
8010614b:	83 ec 08             	sub    $0x8,%esp
8010614e:	50                   	push   %eax
8010614f:	68 70 a6 10 80       	push   $0x8010a670
80106154:	e8 6d a2 ff ff       	call   801003c6 <cprintf>
80106159:	83 c4 10             	add    $0x10,%esp
      cprintf("%d	%d.%d	%d.%d	%s	%d	",p->prio,sec, millisec,cpusec,cpumillisec,state,p->sz);
8010615c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615f:	8b 10                	mov    (%eax),%edx
80106161:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106164:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010616a:	52                   	push   %edx
8010616b:	ff 75 ec             	pushl  -0x14(%ebp)
8010616e:	ff 75 d8             	pushl  -0x28(%ebp)
80106171:	ff 75 dc             	pushl  -0x24(%ebp)
80106174:	ff 75 e0             	pushl  -0x20(%ebp)
80106177:	ff 75 e4             	pushl  -0x1c(%ebp)
8010617a:	50                   	push   %eax
8010617b:	68 74 a6 10 80       	push   $0x8010a674
80106180:	e8 41 a2 ff ff       	call   801003c6 <cprintf>
80106185:	83 c4 20             	add    $0x20,%esp
      
    if(p->state == SLEEPING){
80106188:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618b:	8b 40 0c             	mov    0xc(%eax),%eax
8010618e:	83 f8 02             	cmp    $0x2,%eax
80106191:	75 54                	jne    801061e7 <procdump+0x226>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80106193:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106196:	8b 40 24             	mov    0x24(%eax),%eax
80106199:	8b 40 0c             	mov    0xc(%eax),%eax
8010619c:	83 c0 08             	add    $0x8,%eax
8010619f:	89 c2                	mov    %eax,%edx
801061a1:	83 ec 08             	sub    $0x8,%esp
801061a4:	8d 45 b0             	lea    -0x50(%ebp),%eax
801061a7:	50                   	push   %eax
801061a8:	52                   	push   %edx
801061a9:	e8 d8 07 00 00       	call   80106986 <getcallerpcs>
801061ae:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801061b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061b8:	eb 1c                	jmp    801061d6 <procdump+0x215>
        cprintf(" %p", pc[i]);
801061ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061bd:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
801061c1:	83 ec 08             	sub    $0x8,%esp
801061c4:	50                   	push   %eax
801061c5:	68 8a a6 10 80       	push   $0x8010a68a
801061ca:	e8 f7 a1 ff ff       	call   801003c6 <cprintf>
801061cf:	83 c4 10             	add    $0x10,%esp
	cprintf("%d	",p->parent->pid);
      cprintf("%d	%d.%d	%d.%d	%s	%d	",p->prio,sec, millisec,cpusec,cpumillisec,state,p->sz);
      
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801061d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801061d6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801061da:	7f 0b                	jg     801061e7 <procdump+0x226>
801061dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061df:	8b 44 85 b0          	mov    -0x50(%ebp,%eax,4),%eax
801061e3:	85 c0                	test   %eax,%eax
801061e5:	75 d3                	jne    801061ba <procdump+0x1f9>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801061e7:	83 ec 0c             	sub    $0xc,%esp
801061ea:	68 8e a6 10 80       	push   $0x8010a68e
801061ef:	e8 d2 a1 ff ff       	call   801003c6 <cprintf>
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	eb 01                	jmp    801061fa <procdump+0x239>
  uint cpumillisec;
  uint pc[10];
  cprintf("\nPID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size	PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801061f9:	90                   	nop
  uint millisec;
  uint cpusec;
  uint cpumillisec;
  uint pc[10];
  cprintf("\nPID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size	PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801061fa:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80106201:	81 7d f0 d8 70 11 80 	cmpl   $0x801170d8,-0x10(%ebp)
80106208:	0f 82 d6 fd ff ff    	jb     80105fe4 <procdump+0x23>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010620e:	90                   	nop
8010620f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106212:	c9                   	leave  
80106213:	c3                   	ret    

80106214 <getprocs>:

int
getprocs(int max, struct uproc * table)
{
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	83 ec 18             	sub    $0x18,%esp
	int maxnumber = 0;
8010621a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc *p;
        acquire(&ptable.lock);
80106221:	83 ec 0c             	sub    $0xc,%esp
80106224:	68 a4 49 11 80       	push   $0x801149a4
80106229:	e8 9f 06 00 00       	call   801068cd <acquire>
8010622e:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++)
80106231:	c7 45 f0 d8 49 11 80 	movl   $0x801149d8,-0x10(%ebp)
80106238:	e9 c8 01 00 00       	jmp    80106405 <getprocs+0x1f1>
	{
		if(p->state == SLEEPING||p->state == RUNNABLE||p->state == RUNNING||p->state == ZOMBIE)
8010623d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106240:	8b 40 0c             	mov    0xc(%eax),%eax
80106243:	83 f8 02             	cmp    $0x2,%eax
80106246:	74 25                	je     8010626d <getprocs+0x59>
80106248:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624b:	8b 40 0c             	mov    0xc(%eax),%eax
8010624e:	83 f8 03             	cmp    $0x3,%eax
80106251:	74 1a                	je     8010626d <getprocs+0x59>
80106253:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106256:	8b 40 0c             	mov    0xc(%eax),%eax
80106259:	83 f8 04             	cmp    $0x4,%eax
8010625c:	74 0f                	je     8010626d <getprocs+0x59>
8010625e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106261:	8b 40 0c             	mov    0xc(%eax),%eax
80106264:	83 f8 05             	cmp    $0x5,%eax
80106267:	0f 85 91 01 00 00    	jne    801063fe <getprocs+0x1ea>
		{
			if(max <= maxnumber)
8010626d:	8b 45 08             	mov    0x8(%ebp),%eax
80106270:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106273:	7f 08                	jg     8010627d <getprocs+0x69>
				return max;
80106275:	8b 45 08             	mov    0x8(%ebp),%eax
80106278:	e9 a8 01 00 00       	jmp    80106425 <getprocs+0x211>
			table[maxnumber].prio = p->prio;
8010627d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106280:	89 d0                	mov    %edx,%eax
80106282:	01 c0                	add    %eax,%eax
80106284:	01 d0                	add    %edx,%eax
80106286:	c1 e0 05             	shl    $0x5,%eax
80106289:	89 c2                	mov    %eax,%edx
8010628b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010628e:	01 c2                	add    %eax,%edx
80106290:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106293:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106299:	89 42 5c             	mov    %eax,0x5c(%edx)
			table[maxnumber].pid = p->pid;
8010629c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010629f:	89 d0                	mov    %edx,%eax
801062a1:	01 c0                	add    %eax,%eax
801062a3:	01 d0                	add    %edx,%eax
801062a5:	c1 e0 05             	shl    $0x5,%eax
801062a8:	89 c2                	mov    %eax,%edx
801062aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801062ad:	01 c2                	add    %eax,%edx
801062af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062b2:	8b 40 10             	mov    0x10(%eax),%eax
801062b5:	89 02                	mov    %eax,(%edx)
			table[maxnumber].uid = p->uid;
801062b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062ba:	89 d0                	mov    %edx,%eax
801062bc:	01 c0                	add    %eax,%eax
801062be:	01 d0                	add    %edx,%eax
801062c0:	c1 e0 05             	shl    $0x5,%eax
801062c3:	89 c2                	mov    %eax,%edx
801062c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801062c8:	01 c2                	add    %eax,%edx
801062ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062cd:	8b 40 14             	mov    0x14(%eax),%eax
801062d0:	89 42 04             	mov    %eax,0x4(%edx)
			table[maxnumber].gid = p->gid;
801062d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062d6:	89 d0                	mov    %edx,%eax
801062d8:	01 c0                	add    %eax,%eax
801062da:	01 d0                	add    %edx,%eax
801062dc:	c1 e0 05             	shl    $0x5,%eax
801062df:	89 c2                	mov    %eax,%edx
801062e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801062e4:	01 c2                	add    %eax,%edx
801062e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e9:	8b 40 18             	mov    0x18(%eax),%eax
801062ec:	89 42 08             	mov    %eax,0x8(%edx)
			table[maxnumber].elapsed_ticks = ticks - p->start_ticks;
801062ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062f2:	89 d0                	mov    %edx,%eax
801062f4:	01 c0                	add    %eax,%eax
801062f6:	01 d0                	add    %edx,%eax
801062f8:	c1 e0 05             	shl    $0x5,%eax
801062fb:	89 c2                	mov    %eax,%edx
801062fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106300:	01 c2                	add    %eax,%edx
80106302:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
80106308:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106311:	29 c1                	sub    %eax,%ecx
80106313:	89 c8                	mov    %ecx,%eax
80106315:	89 42 10             	mov    %eax,0x10(%edx)
			table[maxnumber].CPU_total_ticks = p->cpu_ticks_total;
80106318:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010631b:	89 d0                	mov    %edx,%eax
8010631d:	01 c0                	add    %eax,%eax
8010631f:	01 d0                	add    %edx,%eax
80106321:	c1 e0 05             	shl    $0x5,%eax
80106324:	89 c2                	mov    %eax,%edx
80106326:	8b 45 0c             	mov    0xc(%ebp),%eax
80106329:	01 c2                	add    %eax,%edx
8010632b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010632e:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106334:	89 42 14             	mov    %eax,0x14(%edx)
			table[maxnumber].size = p->sz;
80106337:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010633a:	89 d0                	mov    %edx,%eax
8010633c:	01 c0                	add    %eax,%eax
8010633e:	01 d0                	add    %edx,%eax
80106340:	c1 e0 05             	shl    $0x5,%eax
80106343:	89 c2                	mov    %eax,%edx
80106345:	8b 45 0c             	mov    0xc(%ebp),%eax
80106348:	01 c2                	add    %eax,%edx
8010634a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634d:	8b 00                	mov    (%eax),%eax
8010634f:	89 42 38             	mov    %eax,0x38(%edx)
			safestrcpy(table[maxnumber].name,p->name,STRMAX);
80106352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106355:	8d 48 74             	lea    0x74(%eax),%ecx
80106358:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010635b:	89 d0                	mov    %edx,%eax
8010635d:	01 c0                	add    %eax,%eax
8010635f:	01 d0                	add    %edx,%eax
80106361:	c1 e0 05             	shl    $0x5,%eax
80106364:	89 c2                	mov    %eax,%edx
80106366:	8b 45 0c             	mov    0xc(%ebp),%eax
80106369:	01 d0                	add    %edx,%eax
8010636b:	83 c0 3c             	add    $0x3c,%eax
8010636e:	83 ec 04             	sub    $0x4,%esp
80106371:	6a 20                	push   $0x20
80106373:	51                   	push   %ecx
80106374:	50                   	push   %eax
80106375:	e8 b9 09 00 00       	call   80106d33 <safestrcpy>
8010637a:	83 c4 10             	add    $0x10,%esp
			safestrcpy(table[maxnumber].state,states[p->state],STRMAX);
8010637d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106380:	8b 40 0c             	mov    0xc(%eax),%eax
80106383:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
8010638a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010638d:	89 d0                	mov    %edx,%eax
8010638f:	01 c0                	add    %eax,%eax
80106391:	01 d0                	add    %edx,%eax
80106393:	c1 e0 05             	shl    $0x5,%eax
80106396:	89 c2                	mov    %eax,%edx
80106398:	8b 45 0c             	mov    0xc(%ebp),%eax
8010639b:	01 d0                	add    %edx,%eax
8010639d:	83 c0 18             	add    $0x18,%eax
801063a0:	83 ec 04             	sub    $0x4,%esp
801063a3:	6a 20                	push   $0x20
801063a5:	51                   	push   %ecx
801063a6:	50                   	push   %eax
801063a7:	e8 87 09 00 00       	call   80106d33 <safestrcpy>
801063ac:	83 c4 10             	add    $0x10,%esp
			if(p->parent->pid < 0 || p->parent->pid > 100)
801063af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b2:	8b 40 1c             	mov    0x1c(%eax),%eax
801063b5:	8b 40 10             	mov    0x10(%eax),%eax
801063b8:	83 f8 64             	cmp    $0x64,%eax
801063bb:	76 1e                	jbe    801063db <getprocs+0x1c7>
                	        table[maxnumber].ppid = p->pid;
801063bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063c0:	89 d0                	mov    %edx,%eax
801063c2:	01 c0                	add    %eax,%eax
801063c4:	01 d0                	add    %edx,%eax
801063c6:	c1 e0 05             	shl    $0x5,%eax
801063c9:	89 c2                	mov    %eax,%edx
801063cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801063ce:	01 c2                	add    %eax,%edx
801063d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d3:	8b 40 10             	mov    0x10(%eax),%eax
801063d6:	89 42 0c             	mov    %eax,0xc(%edx)
801063d9:	eb 1f                	jmp    801063fa <getprocs+0x1e6>
                	else table[maxnumber].ppid = p->parent->pid;
801063db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063de:	89 d0                	mov    %edx,%eax
801063e0:	01 c0                	add    %eax,%eax
801063e2:	01 d0                	add    %edx,%eax
801063e4:	c1 e0 05             	shl    $0x5,%eax
801063e7:	89 c2                	mov    %eax,%edx
801063e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801063ec:	01 c2                	add    %eax,%edx
801063ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f1:	8b 40 1c             	mov    0x1c(%eax),%eax
801063f4:	8b 40 10             	mov    0x10(%eax),%eax
801063f7:	89 42 0c             	mov    %eax,0xc(%edx)
			++maxnumber;
801063fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(int max, struct uproc * table)
{
	int maxnumber = 0;
        struct proc *p;
        acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++)
801063fe:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80106405:	81 7d f0 d8 70 11 80 	cmpl   $0x801170d8,-0x10(%ebp)
8010640c:	0f 82 2b fe ff ff    	jb     8010623d <getprocs+0x29>
                	        table[maxnumber].ppid = p->pid;
                	else table[maxnumber].ppid = p->parent->pid;
			++maxnumber;
		}
	}
	release(&ptable.lock);
80106412:	83 ec 0c             	sub    $0xc,%esp
80106415:	68 a4 49 11 80       	push   $0x801149a4
8010641a:	e8 15 05 00 00       	call   80106934 <release>
8010641f:	83 c4 10             	add    $0x10,%esp
	return maxnumber;
80106422:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    

80106427 <freedump>:

void
freedump(void)
{
80106427:	55                   	push   %ebp
80106428:	89 e5                	mov    %esp,%ebp
8010642a:	83 ec 18             	sub    $0x18,%esp
	int counter = 0;
8010642d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	struct proc * current;
	acquire(&ptable.lock);
80106434:	83 ec 0c             	sub    $0xc,%esp
80106437:	68 a4 49 11 80       	push   $0x801149a4
8010643c:	e8 8c 04 00 00       	call   801068cd <acquire>
80106441:	83 c4 10             	add    $0x10,%esp
	current = ptable.pLists.free;
80106444:	a1 e4 70 11 80       	mov    0x801170e4,%eax
80106449:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(current)
8010644c:	eb 10                	jmp    8010645e <freedump+0x37>
	{
		++counter;
8010644e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		current = current->next;
80106452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106455:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010645b:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	int counter = 0;
	struct proc * current;
	acquire(&ptable.lock);
	current = ptable.pLists.free;
	while(current)
8010645e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106462:	75 ea                	jne    8010644e <freedump+0x27>
	{
		++counter;
		current = current->next;
	}
	release(&ptable.lock);
80106464:	83 ec 0c             	sub    $0xc,%esp
80106467:	68 a4 49 11 80       	push   $0x801149a4
8010646c:	e8 c3 04 00 00       	call   80106934 <release>
80106471:	83 c4 10             	add    $0x10,%esp
	cprintf("Free List Size: %d  Processes\n", counter);
80106474:	83 ec 08             	sub    $0x8,%esp
80106477:	ff 75 f4             	pushl  -0xc(%ebp)
8010647a:	68 90 a6 10 80       	push   $0x8010a690
8010647f:	e8 42 9f ff ff       	call   801003c6 <cprintf>
80106484:	83 c4 10             	add    $0x10,%esp
}
80106487:	90                   	nop
80106488:	c9                   	leave  
80106489:	c3                   	ret    

8010648a <sleepdump>:

void
sleepdump(void)
{
8010648a:	55                   	push   %ebp
8010648b:	89 e5                	mov    %esp,%ebp
8010648d:	83 ec 18             	sub    $0x18,%esp
	struct proc * current = ptable.pLists.sleep;
80106490:	a1 e8 70 11 80       	mov    0x801170e8,%eax
80106495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("Sleep List Processes: \n");
80106498:	83 ec 0c             	sub    $0xc,%esp
8010649b:	68 af a6 10 80       	push   $0x8010a6af
801064a0:	e8 21 9f ff ff       	call   801003c6 <cprintf>
801064a5:	83 c4 10             	add    $0x10,%esp
	acquire(&ptable.lock);
801064a8:	83 ec 0c             	sub    $0xc,%esp
801064ab:	68 a4 49 11 80       	push   $0x801149a4
801064b0:	e8 18 04 00 00       	call   801068cd <acquire>
801064b5:	83 c4 10             	add    $0x10,%esp
	while(current)
801064b8:	eb 23                	jmp    801064dd <sleepdump+0x53>
	{
		cprintf("%d -> ", current->pid);
801064ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064bd:	8b 40 10             	mov    0x10(%eax),%eax
801064c0:	83 ec 08             	sub    $0x8,%esp
801064c3:	50                   	push   %eax
801064c4:	68 c7 a6 10 80       	push   $0x8010a6c7
801064c9:	e8 f8 9e ff ff       	call   801003c6 <cprintf>
801064ce:	83 c4 10             	add    $0x10,%esp
		current = current->next;
801064d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801064da:	89 45 f4             	mov    %eax,-0xc(%ebp)
sleepdump(void)
{
	struct proc * current = ptable.pLists.sleep;
	cprintf("Sleep List Processes: \n");
	acquire(&ptable.lock);
	while(current)
801064dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064e1:	75 d7                	jne    801064ba <sleepdump+0x30>
	{
		cprintf("%d -> ", current->pid);
		current = current->next;
	}
	release(&ptable.lock);
801064e3:	83 ec 0c             	sub    $0xc,%esp
801064e6:	68 a4 49 11 80       	push   $0x801149a4
801064eb:	e8 44 04 00 00       	call   80106934 <release>
801064f0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
801064f3:	83 ec 0c             	sub    $0xc,%esp
801064f6:	68 8e a6 10 80       	push   $0x8010a68e
801064fb:	e8 c6 9e ff ff       	call   801003c6 <cprintf>
80106500:	83 c4 10             	add    $0x10,%esp
}
80106503:	90                   	nop
80106504:	c9                   	leave  
80106505:	c3                   	ret    

80106506 <readydump>:
void
readydump(void)
{
80106506:	55                   	push   %ebp
80106507:	89 e5                	mov    %esp,%ebp
80106509:	83 ec 18             	sub    $0x18,%esp
	int i = 0;
8010650c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc * current;
        cprintf("Ready List Processes: \n");
80106513:	83 ec 0c             	sub    $0xc,%esp
80106516:	68 ce a6 10 80       	push   $0x8010a6ce
8010651b:	e8 a6 9e ff ff       	call   801003c6 <cprintf>
80106520:	83 c4 10             	add    $0x10,%esp
	acquire(&ptable.lock);
80106523:	83 ec 0c             	sub    $0xc,%esp
80106526:	68 a4 49 11 80       	push   $0x801149a4
8010652b:	e8 9d 03 00 00       	call   801068cd <acquire>
80106530:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < MAX; ++i){
80106533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010653a:	eb 6e                	jmp    801065aa <readydump+0xa4>
		current = ptable.pLists.ready[i];
8010653c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010653f:	05 cc 09 00 00       	add    $0x9cc,%eax
80106544:	8b 04 85 a8 49 11 80 	mov    -0x7feeb658(,%eax,4),%eax
8010654b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("%d: ", i);
8010654e:	83 ec 08             	sub    $0x8,%esp
80106551:	ff 75 f4             	pushl  -0xc(%ebp)
80106554:	68 e6 a6 10 80       	push   $0x8010a6e6
80106559:	e8 68 9e ff ff       	call   801003c6 <cprintf>
8010655e:	83 c4 10             	add    $0x10,%esp
        	while(current)
80106561:	eb 2d                	jmp    80106590 <readydump+0x8a>
        	{
        	        cprintf("(%d,%d) -> ", current->pid, current->budget);
80106563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106566:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010656c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010656f:	8b 40 10             	mov    0x10(%eax),%eax
80106572:	83 ec 04             	sub    $0x4,%esp
80106575:	52                   	push   %edx
80106576:	50                   	push   %eax
80106577:	68 eb a6 10 80       	push   $0x8010a6eb
8010657c:	e8 45 9e ff ff       	call   801003c6 <cprintf>
80106581:	83 c4 10             	add    $0x10,%esp
        	        current = current->next;
80106584:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106587:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010658d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        cprintf("Ready List Processes: \n");
	acquire(&ptable.lock);
	for(i = 0; i < MAX; ++i){
		current = ptable.pLists.ready[i];
		cprintf("%d: ", i);
        	while(current)
80106590:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106594:	75 cd                	jne    80106563 <readydump+0x5d>
        	{
        	        cprintf("(%d,%d) -> ", current->pid, current->budget);
        	        current = current->next;
        	}
        	cprintf("\n");
80106596:	83 ec 0c             	sub    $0xc,%esp
80106599:	68 8e a6 10 80       	push   $0x8010a68e
8010659e:	e8 23 9e ff ff       	call   801003c6 <cprintf>
801065a3:	83 c4 10             	add    $0x10,%esp
{
	int i = 0;
        struct proc * current;
        cprintf("Ready List Processes: \n");
	acquire(&ptable.lock);
	for(i = 0; i < MAX; ++i){
801065a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065aa:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
801065ae:	7e 8c                	jle    8010653c <readydump+0x36>
        	        cprintf("(%d,%d) -> ", current->pid, current->budget);
        	        current = current->next;
        	}
        	cprintf("\n");
	}
	release(&ptable.lock);
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	68 a4 49 11 80       	push   $0x801149a4
801065b8:	e8 77 03 00 00       	call   80106934 <release>
801065bd:	83 c4 10             	add    $0x10,%esp
}
801065c0:	90                   	nop
801065c1:	c9                   	leave  
801065c2:	c3                   	ret    

801065c3 <zombiedump>:

void
zombiedump(void)
{	
801065c3:	55                   	push   %ebp
801065c4:	89 e5                	mov    %esp,%ebp
801065c6:	83 ec 18             	sub    $0x18,%esp
	struct proc * current = ptable.pLists.zombie;
801065c9:	a1 ec 70 11 80       	mov    0x801170ec,%eax
801065ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("Zombie List Processes: \n");
801065d1:	83 ec 0c             	sub    $0xc,%esp
801065d4:	68 f7 a6 10 80       	push   $0x8010a6f7
801065d9:	e8 e8 9d ff ff       	call   801003c6 <cprintf>
801065de:	83 c4 10             	add    $0x10,%esp
	acquire(&ptable.lock);
801065e1:	83 ec 0c             	sub    $0xc,%esp
801065e4:	68 a4 49 11 80       	push   $0x801149a4
801065e9:	e8 df 02 00 00       	call   801068cd <acquire>
801065ee:	83 c4 10             	add    $0x10,%esp
        while(current)
801065f1:	eb 60                	jmp    80106653 <zombiedump+0x90>
        {
                cprintf("(%d,", current->pid);
801065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f6:	8b 40 10             	mov    0x10(%eax),%eax
801065f9:	83 ec 08             	sub    $0x8,%esp
801065fc:	50                   	push   %eax
801065fd:	68 10 a7 10 80       	push   $0x8010a710
80106602:	e8 bf 9d ff ff       	call   801003c6 <cprintf>
80106607:	83 c4 10             	add    $0x10,%esp
		if(!current->parent)
8010660a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660d:	8b 40 1c             	mov    0x1c(%eax),%eax
80106610:	85 c0                	test   %eax,%eax
80106612:	75 19                	jne    8010662d <zombiedump+0x6a>
			cprintf("%d) -> ", current->pid);
80106614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106617:	8b 40 10             	mov    0x10(%eax),%eax
8010661a:	83 ec 08             	sub    $0x8,%esp
8010661d:	50                   	push   %eax
8010661e:	68 15 a7 10 80       	push   $0x8010a715
80106623:	e8 9e 9d ff ff       	call   801003c6 <cprintf>
80106628:	83 c4 10             	add    $0x10,%esp
8010662b:	eb 1a                	jmp    80106647 <zombiedump+0x84>
		else
			cprintf("%d) -> ", current->parent->pid);
8010662d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106630:	8b 40 1c             	mov    0x1c(%eax),%eax
80106633:	8b 40 10             	mov    0x10(%eax),%eax
80106636:	83 ec 08             	sub    $0x8,%esp
80106639:	50                   	push   %eax
8010663a:	68 15 a7 10 80       	push   $0x8010a715
8010663f:	e8 82 9d ff ff       	call   801003c6 <cprintf>
80106644:	83 c4 10             	add    $0x10,%esp
                current = current->next;
80106647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106650:	89 45 f4             	mov    %eax,-0xc(%ebp)
zombiedump(void)
{	
	struct proc * current = ptable.pLists.zombie;
        cprintf("Zombie List Processes: \n");
	acquire(&ptable.lock);
        while(current)
80106653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106657:	75 9a                	jne    801065f3 <zombiedump+0x30>
			cprintf("%d) -> ", current->pid);
		else
			cprintf("%d) -> ", current->parent->pid);
                current = current->next;
        }
	release(&ptable.lock);
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	68 a4 49 11 80       	push   $0x801149a4
80106661:	e8 ce 02 00 00       	call   80106934 <release>
80106666:	83 c4 10             	add    $0x10,%esp
        cprintf("\n");
80106669:	83 ec 0c             	sub    $0xc,%esp
8010666c:	68 8e a6 10 80       	push   $0x8010a68e
80106671:	e8 50 9d ff ff       	call   801003c6 <cprintf>
80106676:	83 c4 10             	add    $0x10,%esp

}
80106679:	90                   	nop
8010667a:	c9                   	leave  
8010667b:	c3                   	ret    

8010667c <setpriority>:

int setpriority(int pid, int priority)
{
8010667c:	55                   	push   %ebp
8010667d:	89 e5                	mov    %esp,%ebp
8010667f:	83 ec 18             	sub    $0x18,%esp
	if(priority < 0 || priority >= MAX)
80106682:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106686:	78 06                	js     8010668e <setpriority+0x12>
80106688:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
8010668c:	7e 0a                	jle    80106698 <setpriority+0x1c>
		return -1;
8010668e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106693:	e9 d9 01 00 00       	jmp    80106871 <setpriority+0x1f5>
	if(pid < 0)
80106698:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010669c:	79 0a                	jns    801066a8 <setpriority+0x2c>
		return -2;
8010669e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801066a3:	e9 c9 01 00 00       	jmp    80106871 <setpriority+0x1f5>
	struct proc * p = 0;
801066a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	acquire(&ptable.lock);
801066af:	83 ec 0c             	sub    $0xc,%esp
801066b2:	68 a4 49 11 80       	push   $0x801149a4
801066b7:	e8 11 02 00 00       	call   801068cd <acquire>
801066bc:	83 c4 10             	add    $0x10,%esp
	p = findPid(&ptable.pLists.sleep,pid);
801066bf:	83 ec 08             	sub    $0x8,%esp
801066c2:	ff 75 08             	pushl  0x8(%ebp)
801066c5:	68 e8 70 11 80       	push   $0x801170e8
801066ca:	e8 55 e5 ff ff       	call   80104c24 <findPid>
801066cf:	83 c4 10             	add    $0x10,%esp
801066d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > 0){
801066d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066d9:	74 53                	je     8010672e <setpriority+0xb2>
		if(p->prio != priority){
801066db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066de:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801066e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801066e7:	39 c2                	cmp    %eax,%edx
801066e9:	74 29                	je     80106714 <setpriority+0x98>
			p->budget = BUDGET_MAX;
801066eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ee:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
801066f5:	01 00 00 
			p->prio = priority;
801066f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801066fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066fe:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
			cprintf("Sleeping process' priority changed");
80106704:	83 ec 0c             	sub    $0xc,%esp
80106707:	68 20 a7 10 80       	push   $0x8010a720
8010670c:	e8 b5 9c ff ff       	call   801003c6 <cprintf>
80106711:	83 c4 10             	add    $0x10,%esp
		}
		release(&ptable.lock);
80106714:	83 ec 0c             	sub    $0xc,%esp
80106717:	68 a4 49 11 80       	push   $0x801149a4
8010671c:	e8 13 02 00 00       	call   80106934 <release>
80106721:	83 c4 10             	add    $0x10,%esp
		return 0;
80106724:	b8 00 00 00 00       	mov    $0x0,%eax
80106729:	e9 43 01 00 00       	jmp    80106871 <setpriority+0x1f5>
	}
	p = findPid(&ptable.pLists.running,pid);
8010672e:	83 ec 08             	sub    $0x8,%esp
80106731:	ff 75 08             	pushl  0x8(%ebp)
80106734:	68 f0 70 11 80       	push   $0x801170f0
80106739:	e8 e6 e4 ff ff       	call   80104c24 <findPid>
8010673e:	83 c4 10             	add    $0x10,%esp
80106741:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > 0){
80106744:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106748:	74 53                	je     8010679d <setpriority+0x121>
		if(p->prio != priority){
8010674a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674d:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80106753:	8b 45 0c             	mov    0xc(%ebp),%eax
80106756:	39 c2                	cmp    %eax,%edx
80106758:	74 29                	je     80106783 <setpriority+0x107>
                        p->budget = BUDGET_MAX;
8010675a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675d:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
80106764:	01 00 00 
                        p->prio = priority;
80106767:	8b 55 0c             	mov    0xc(%ebp),%edx
8010676a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010676d:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
			cprintf("Running process' priority changed \n");
80106773:	83 ec 0c             	sub    $0xc,%esp
80106776:	68 44 a7 10 80       	push   $0x8010a744
8010677b:	e8 46 9c ff ff       	call   801003c6 <cprintf>
80106780:	83 c4 10             	add    $0x10,%esp
                }
		release(&ptable.lock);
80106783:	83 ec 0c             	sub    $0xc,%esp
80106786:	68 a4 49 11 80       	push   $0x801149a4
8010678b:	e8 a4 01 00 00       	call   80106934 <release>
80106790:	83 c4 10             	add    $0x10,%esp
                return 0;
80106793:	b8 00 00 00 00       	mov    $0x0,%eax
80106798:	e9 d4 00 00 00       	jmp    80106871 <setpriority+0x1f5>
	}
	p = findReadyPid(pid);
8010679d:	83 ec 0c             	sub    $0xc,%esp
801067a0:	ff 75 08             	pushl  0x8(%ebp)
801067a3:	e8 c7 e4 ff ff       	call   80104c6f <findReadyPid>
801067a8:	83 c4 10             	add    $0x10,%esp
801067ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > 0){
801067ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067b2:	0f 84 a4 00 00 00    	je     8010685c <setpriority+0x1e0>
		if(p->prio != priority){
801067b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067bb:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801067c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801067c4:	39 c2                	cmp    %eax,%edx
801067c6:	74 7d                	je     80106845 <setpriority+0x1c9>
                        p->budget = BUDGET_MAX;
801067c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067cb:	c7 80 94 00 00 00 90 	movl   $0x190,0x94(%eax)
801067d2:	01 00 00 
			removeFromStateList(&ptable.pLists.ready[p->prio],RUNNABLE, p);
801067d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d8:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801067de:	05 cc 09 00 00       	add    $0x9cc,%eax
801067e3:	c1 e0 02             	shl    $0x2,%eax
801067e6:	05 a0 49 11 80       	add    $0x801149a0,%eax
801067eb:	83 c0 08             	add    $0x8,%eax
801067ee:	83 ec 04             	sub    $0x4,%esp
801067f1:	ff 75 f4             	pushl  -0xc(%ebp)
801067f4:	6a 03                	push   $0x3
801067f6:	50                   	push   %eax
801067f7:	e8 a9 e1 ff ff       	call   801049a5 <removeFromStateList>
801067fc:	83 c4 10             	add    $0x10,%esp
			p->prio = priority;
801067ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80106802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106805:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
			insertRoundRobin(&ptable.pLists.ready[p->prio],RUNNABLE,p);
8010680b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010680e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106814:	05 cc 09 00 00       	add    $0x9cc,%eax
80106819:	c1 e0 02             	shl    $0x2,%eax
8010681c:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106821:	83 c0 08             	add    $0x8,%eax
80106824:	83 ec 04             	sub    $0x4,%esp
80106827:	ff 75 f4             	pushl  -0xc(%ebp)
8010682a:	6a 03                	push   $0x3
8010682c:	50                   	push   %eax
8010682d:	e8 4b e2 ff ff       	call   80104a7d <insertRoundRobin>
80106832:	83 c4 10             	add    $0x10,%esp
			cprintf("Ready process' priority changed \n");
80106835:	83 ec 0c             	sub    $0xc,%esp
80106838:	68 68 a7 10 80       	push   $0x8010a768
8010683d:	e8 84 9b ff ff       	call   801003c6 <cprintf>
80106842:	83 c4 10             	add    $0x10,%esp
                }
		release(&ptable.lock);
80106845:	83 ec 0c             	sub    $0xc,%esp
80106848:	68 a4 49 11 80       	push   $0x801149a4
8010684d:	e8 e2 00 00 00       	call   80106934 <release>
80106852:	83 c4 10             	add    $0x10,%esp
		return 1;
80106855:	b8 01 00 00 00       	mov    $0x1,%eax
8010685a:	eb 15                	jmp    80106871 <setpriority+0x1f5>
	}
	release(&ptable.lock);
8010685c:	83 ec 0c             	sub    $0xc,%esp
8010685f:	68 a4 49 11 80       	push   $0x801149a4
80106864:	e8 cb 00 00 00       	call   80106934 <release>
80106869:	83 c4 10             	add    $0x10,%esp
	return -2;
8010686c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80106871:	c9                   	leave  
80106872:	c3                   	ret    

80106873 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80106873:	55                   	push   %ebp
80106874:	89 e5                	mov    %esp,%ebp
80106876:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106879:	9c                   	pushf  
8010687a:	58                   	pop    %eax
8010687b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010687e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106881:	c9                   	leave  
80106882:	c3                   	ret    

80106883 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106883:	55                   	push   %ebp
80106884:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106886:	fa                   	cli    
}
80106887:	90                   	nop
80106888:	5d                   	pop    %ebp
80106889:	c3                   	ret    

8010688a <sti>:

static inline void
sti(void)
{
8010688a:	55                   	push   %ebp
8010688b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010688d:	fb                   	sti    
}
8010688e:	90                   	nop
8010688f:	5d                   	pop    %ebp
80106890:	c3                   	ret    

80106891 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106891:	55                   	push   %ebp
80106892:	89 e5                	mov    %esp,%ebp
80106894:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106897:	8b 55 08             	mov    0x8(%ebp),%edx
8010689a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010689d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801068a0:	f0 87 02             	lock xchg %eax,(%edx)
801068a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801068a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801068a9:	c9                   	leave  
801068aa:	c3                   	ret    

801068ab <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801068ab:	55                   	push   %ebp
801068ac:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801068ae:	8b 45 08             	mov    0x8(%ebp),%eax
801068b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801068b4:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801068b7:	8b 45 08             	mov    0x8(%ebp),%eax
801068ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801068c0:	8b 45 08             	mov    0x8(%ebp),%eax
801068c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801068ca:	90                   	nop
801068cb:	5d                   	pop    %ebp
801068cc:	c3                   	ret    

801068cd <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801068cd:	55                   	push   %ebp
801068ce:	89 e5                	mov    %esp,%ebp
801068d0:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801068d3:	e8 52 01 00 00       	call   80106a2a <pushcli>
  if(holding(lk))
801068d8:	8b 45 08             	mov    0x8(%ebp),%eax
801068db:	83 ec 0c             	sub    $0xc,%esp
801068de:	50                   	push   %eax
801068df:	e8 1c 01 00 00       	call   80106a00 <holding>
801068e4:	83 c4 10             	add    $0x10,%esp
801068e7:	85 c0                	test   %eax,%eax
801068e9:	74 0d                	je     801068f8 <acquire+0x2b>
    panic("acquire");
801068eb:	83 ec 0c             	sub    $0xc,%esp
801068ee:	68 98 a7 10 80       	push   $0x8010a798
801068f3:	e8 6e 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801068f8:	90                   	nop
801068f9:	8b 45 08             	mov    0x8(%ebp),%eax
801068fc:	83 ec 08             	sub    $0x8,%esp
801068ff:	6a 01                	push   $0x1
80106901:	50                   	push   %eax
80106902:	e8 8a ff ff ff       	call   80106891 <xchg>
80106907:	83 c4 10             	add    $0x10,%esp
8010690a:	85 c0                	test   %eax,%eax
8010690c:	75 eb                	jne    801068f9 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010690e:	8b 45 08             	mov    0x8(%ebp),%eax
80106911:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106918:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010691b:	8b 45 08             	mov    0x8(%ebp),%eax
8010691e:	83 c0 0c             	add    $0xc,%eax
80106921:	83 ec 08             	sub    $0x8,%esp
80106924:	50                   	push   %eax
80106925:	8d 45 08             	lea    0x8(%ebp),%eax
80106928:	50                   	push   %eax
80106929:	e8 58 00 00 00       	call   80106986 <getcallerpcs>
8010692e:	83 c4 10             	add    $0x10,%esp
}
80106931:	90                   	nop
80106932:	c9                   	leave  
80106933:	c3                   	ret    

80106934 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106934:	55                   	push   %ebp
80106935:	89 e5                	mov    %esp,%ebp
80106937:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010693a:	83 ec 0c             	sub    $0xc,%esp
8010693d:	ff 75 08             	pushl  0x8(%ebp)
80106940:	e8 bb 00 00 00       	call   80106a00 <holding>
80106945:	83 c4 10             	add    $0x10,%esp
80106948:	85 c0                	test   %eax,%eax
8010694a:	75 0d                	jne    80106959 <release+0x25>
    panic("release");
8010694c:	83 ec 0c             	sub    $0xc,%esp
8010694f:	68 a0 a7 10 80       	push   $0x8010a7a0
80106954:	e8 0d 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106959:	8b 45 08             	mov    0x8(%ebp),%eax
8010695c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106963:	8b 45 08             	mov    0x8(%ebp),%eax
80106966:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010696d:	8b 45 08             	mov    0x8(%ebp),%eax
80106970:	83 ec 08             	sub    $0x8,%esp
80106973:	6a 00                	push   $0x0
80106975:	50                   	push   %eax
80106976:	e8 16 ff ff ff       	call   80106891 <xchg>
8010697b:	83 c4 10             	add    $0x10,%esp

  popcli();
8010697e:	e8 ec 00 00 00       	call   80106a6f <popcli>
}
80106983:	90                   	nop
80106984:	c9                   	leave  
80106985:	c3                   	ret    

80106986 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106986:	55                   	push   %ebp
80106987:	89 e5                	mov    %esp,%ebp
80106989:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010698c:	8b 45 08             	mov    0x8(%ebp),%eax
8010698f:	83 e8 08             	sub    $0x8,%eax
80106992:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106995:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010699c:	eb 38                	jmp    801069d6 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010699e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801069a2:	74 53                	je     801069f7 <getcallerpcs+0x71>
801069a4:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801069ab:	76 4a                	jbe    801069f7 <getcallerpcs+0x71>
801069ad:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801069b1:	74 44                	je     801069f7 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801069b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801069c0:	01 c2                	add    %eax,%edx
801069c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069c5:	8b 40 04             	mov    0x4(%eax),%eax
801069c8:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801069ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069cd:	8b 00                	mov    (%eax),%eax
801069cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801069d2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069d6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069da:	7e c2                	jle    8010699e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069dc:	eb 19                	jmp    801069f7 <getcallerpcs+0x71>
    pcs[i] = 0;
801069de:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801069eb:	01 d0                	add    %edx,%eax
801069ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069f3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069f7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069fb:	7e e1                	jle    801069de <getcallerpcs+0x58>
    pcs[i] = 0;
}
801069fd:	90                   	nop
801069fe:	c9                   	leave  
801069ff:	c3                   	ret    

80106a00 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106a03:	8b 45 08             	mov    0x8(%ebp),%eax
80106a06:	8b 00                	mov    (%eax),%eax
80106a08:	85 c0                	test   %eax,%eax
80106a0a:	74 17                	je     80106a23 <holding+0x23>
80106a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a0f:	8b 50 08             	mov    0x8(%eax),%edx
80106a12:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a18:	39 c2                	cmp    %eax,%edx
80106a1a:	75 07                	jne    80106a23 <holding+0x23>
80106a1c:	b8 01 00 00 00       	mov    $0x1,%eax
80106a21:	eb 05                	jmp    80106a28 <holding+0x28>
80106a23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a28:	5d                   	pop    %ebp
80106a29:	c3                   	ret    

80106a2a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106a2a:	55                   	push   %ebp
80106a2b:	89 e5                	mov    %esp,%ebp
80106a2d:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106a30:	e8 3e fe ff ff       	call   80106873 <readeflags>
80106a35:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106a38:	e8 46 fe ff ff       	call   80106883 <cli>
  if(cpu->ncli++ == 0)
80106a3d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106a44:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106a4a:	8d 48 01             	lea    0x1(%eax),%ecx
80106a4d:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106a53:	85 c0                	test   %eax,%eax
80106a55:	75 15                	jne    80106a6c <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106a57:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a60:	81 e2 00 02 00 00    	and    $0x200,%edx
80106a66:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106a6c:	90                   	nop
80106a6d:	c9                   	leave  
80106a6e:	c3                   	ret    

80106a6f <popcli>:

void
popcli(void)
{
80106a6f:	55                   	push   %ebp
80106a70:	89 e5                	mov    %esp,%ebp
80106a72:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106a75:	e8 f9 fd ff ff       	call   80106873 <readeflags>
80106a7a:	25 00 02 00 00       	and    $0x200,%eax
80106a7f:	85 c0                	test   %eax,%eax
80106a81:	74 0d                	je     80106a90 <popcli+0x21>
    panic("popcli - interruptible");
80106a83:	83 ec 0c             	sub    $0xc,%esp
80106a86:	68 a8 a7 10 80       	push   $0x8010a7a8
80106a8b:	e8 d6 9a ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a90:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a96:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a9c:	83 ea 01             	sub    $0x1,%edx
80106a9f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106aa5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106aab:	85 c0                	test   %eax,%eax
80106aad:	79 0d                	jns    80106abc <popcli+0x4d>
    panic("popcli");
80106aaf:	83 ec 0c             	sub    $0xc,%esp
80106ab2:	68 bf a7 10 80       	push   $0x8010a7bf
80106ab7:	e8 aa 9a ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106abc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ac2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106ac8:	85 c0                	test   %eax,%eax
80106aca:	75 15                	jne    80106ae1 <popcli+0x72>
80106acc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ad2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106ad8:	85 c0                	test   %eax,%eax
80106ada:	74 05                	je     80106ae1 <popcli+0x72>
    sti();
80106adc:	e8 a9 fd ff ff       	call   8010688a <sti>
}
80106ae1:	90                   	nop
80106ae2:	c9                   	leave  
80106ae3:	c3                   	ret    

80106ae4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106ae4:	55                   	push   %ebp
80106ae5:	89 e5                	mov    %esp,%ebp
80106ae7:	57                   	push   %edi
80106ae8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106ae9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106aec:	8b 55 10             	mov    0x10(%ebp),%edx
80106aef:	8b 45 0c             	mov    0xc(%ebp),%eax
80106af2:	89 cb                	mov    %ecx,%ebx
80106af4:	89 df                	mov    %ebx,%edi
80106af6:	89 d1                	mov    %edx,%ecx
80106af8:	fc                   	cld    
80106af9:	f3 aa                	rep stos %al,%es:(%edi)
80106afb:	89 ca                	mov    %ecx,%edx
80106afd:	89 fb                	mov    %edi,%ebx
80106aff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106b02:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106b05:	90                   	nop
80106b06:	5b                   	pop    %ebx
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    

80106b0a <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106b0a:	55                   	push   %ebp
80106b0b:	89 e5                	mov    %esp,%ebp
80106b0d:	57                   	push   %edi
80106b0e:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106b12:	8b 55 10             	mov    0x10(%ebp),%edx
80106b15:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b18:	89 cb                	mov    %ecx,%ebx
80106b1a:	89 df                	mov    %ebx,%edi
80106b1c:	89 d1                	mov    %edx,%ecx
80106b1e:	fc                   	cld    
80106b1f:	f3 ab                	rep stos %eax,%es:(%edi)
80106b21:	89 ca                	mov    %ecx,%edx
80106b23:	89 fb                	mov    %edi,%ebx
80106b25:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106b28:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106b2b:	90                   	nop
80106b2c:	5b                   	pop    %ebx
80106b2d:	5f                   	pop    %edi
80106b2e:	5d                   	pop    %ebp
80106b2f:	c3                   	ret    

80106b30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106b33:	8b 45 08             	mov    0x8(%ebp),%eax
80106b36:	83 e0 03             	and    $0x3,%eax
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	75 43                	jne    80106b80 <memset+0x50>
80106b3d:	8b 45 10             	mov    0x10(%ebp),%eax
80106b40:	83 e0 03             	and    $0x3,%eax
80106b43:	85 c0                	test   %eax,%eax
80106b45:	75 39                	jne    80106b80 <memset+0x50>
    c &= 0xFF;
80106b47:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106b4e:	8b 45 10             	mov    0x10(%ebp),%eax
80106b51:	c1 e8 02             	shr    $0x2,%eax
80106b54:	89 c1                	mov    %eax,%ecx
80106b56:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b59:	c1 e0 18             	shl    $0x18,%eax
80106b5c:	89 c2                	mov    %eax,%edx
80106b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b61:	c1 e0 10             	shl    $0x10,%eax
80106b64:	09 c2                	or     %eax,%edx
80106b66:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b69:	c1 e0 08             	shl    $0x8,%eax
80106b6c:	09 d0                	or     %edx,%eax
80106b6e:	0b 45 0c             	or     0xc(%ebp),%eax
80106b71:	51                   	push   %ecx
80106b72:	50                   	push   %eax
80106b73:	ff 75 08             	pushl  0x8(%ebp)
80106b76:	e8 8f ff ff ff       	call   80106b0a <stosl>
80106b7b:	83 c4 0c             	add    $0xc,%esp
80106b7e:	eb 12                	jmp    80106b92 <memset+0x62>
  } else
    stosb(dst, c, n);
80106b80:	8b 45 10             	mov    0x10(%ebp),%eax
80106b83:	50                   	push   %eax
80106b84:	ff 75 0c             	pushl  0xc(%ebp)
80106b87:	ff 75 08             	pushl  0x8(%ebp)
80106b8a:	e8 55 ff ff ff       	call   80106ae4 <stosb>
80106b8f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b92:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b95:	c9                   	leave  
80106b96:	c3                   	ret    

80106b97 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b97:	55                   	push   %ebp
80106b98:	89 e5                	mov    %esp,%ebp
80106b9a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106ba9:	eb 30                	jmp    80106bdb <memcmp+0x44>
    if(*s1 != *s2)
80106bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bae:	0f b6 10             	movzbl (%eax),%edx
80106bb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bb4:	0f b6 00             	movzbl (%eax),%eax
80106bb7:	38 c2                	cmp    %al,%dl
80106bb9:	74 18                	je     80106bd3 <memcmp+0x3c>
      return *s1 - *s2;
80106bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bbe:	0f b6 00             	movzbl (%eax),%eax
80106bc1:	0f b6 d0             	movzbl %al,%edx
80106bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bc7:	0f b6 00             	movzbl (%eax),%eax
80106bca:	0f b6 c0             	movzbl %al,%eax
80106bcd:	29 c2                	sub    %eax,%edx
80106bcf:	89 d0                	mov    %edx,%eax
80106bd1:	eb 1a                	jmp    80106bed <memcmp+0x56>
    s1++, s2++;
80106bd3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106bd7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106bdb:	8b 45 10             	mov    0x10(%ebp),%eax
80106bde:	8d 50 ff             	lea    -0x1(%eax),%edx
80106be1:	89 55 10             	mov    %edx,0x10(%ebp)
80106be4:	85 c0                	test   %eax,%eax
80106be6:	75 c3                	jne    80106bab <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bed:	c9                   	leave  
80106bee:	c3                   	ret    

80106bef <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106bef:	55                   	push   %ebp
80106bf0:	89 e5                	mov    %esp,%ebp
80106bf2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106c07:	73 54                	jae    80106c5d <memmove+0x6e>
80106c09:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c0c:	8b 45 10             	mov    0x10(%ebp),%eax
80106c0f:	01 d0                	add    %edx,%eax
80106c11:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106c14:	76 47                	jbe    80106c5d <memmove+0x6e>
    s += n;
80106c16:	8b 45 10             	mov    0x10(%ebp),%eax
80106c19:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106c1c:	8b 45 10             	mov    0x10(%ebp),%eax
80106c1f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106c22:	eb 13                	jmp    80106c37 <memmove+0x48>
      *--d = *--s;
80106c24:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106c28:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c2f:	0f b6 10             	movzbl (%eax),%edx
80106c32:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c35:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106c37:	8b 45 10             	mov    0x10(%ebp),%eax
80106c3a:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c3d:	89 55 10             	mov    %edx,0x10(%ebp)
80106c40:	85 c0                	test   %eax,%eax
80106c42:	75 e0                	jne    80106c24 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106c44:	eb 24                	jmp    80106c6a <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106c46:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c49:	8d 50 01             	lea    0x1(%eax),%edx
80106c4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106c4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c52:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c55:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106c58:	0f b6 12             	movzbl (%edx),%edx
80106c5b:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106c5d:	8b 45 10             	mov    0x10(%ebp),%eax
80106c60:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c63:	89 55 10             	mov    %edx,0x10(%ebp)
80106c66:	85 c0                	test   %eax,%eax
80106c68:	75 dc                	jne    80106c46 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106c6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106c6d:	c9                   	leave  
80106c6e:	c3                   	ret    

80106c6f <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106c6f:	55                   	push   %ebp
80106c70:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106c72:	ff 75 10             	pushl  0x10(%ebp)
80106c75:	ff 75 0c             	pushl  0xc(%ebp)
80106c78:	ff 75 08             	pushl  0x8(%ebp)
80106c7b:	e8 6f ff ff ff       	call   80106bef <memmove>
80106c80:	83 c4 0c             	add    $0xc,%esp
}
80106c83:	c9                   	leave  
80106c84:	c3                   	ret    

80106c85 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c85:	55                   	push   %ebp
80106c86:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c88:	eb 0c                	jmp    80106c96 <strncmp+0x11>
    n--, p++, q++;
80106c8a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c92:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c9a:	74 1a                	je     80106cb6 <strncmp+0x31>
80106c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9f:	0f b6 00             	movzbl (%eax),%eax
80106ca2:	84 c0                	test   %al,%al
80106ca4:	74 10                	je     80106cb6 <strncmp+0x31>
80106ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca9:	0f b6 10             	movzbl (%eax),%edx
80106cac:	8b 45 0c             	mov    0xc(%ebp),%eax
80106caf:	0f b6 00             	movzbl (%eax),%eax
80106cb2:	38 c2                	cmp    %al,%dl
80106cb4:	74 d4                	je     80106c8a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cba:	75 07                	jne    80106cc3 <strncmp+0x3e>
    return 0;
80106cbc:	b8 00 00 00 00       	mov    $0x0,%eax
80106cc1:	eb 16                	jmp    80106cd9 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc6:	0f b6 00             	movzbl (%eax),%eax
80106cc9:	0f b6 d0             	movzbl %al,%edx
80106ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ccf:	0f b6 00             	movzbl (%eax),%eax
80106cd2:	0f b6 c0             	movzbl %al,%eax
80106cd5:	29 c2                	sub    %eax,%edx
80106cd7:	89 d0                	mov    %edx,%eax
}
80106cd9:	5d                   	pop    %ebp
80106cda:	c3                   	ret    

80106cdb <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106cdb:	55                   	push   %ebp
80106cdc:	89 e5                	mov    %esp,%ebp
80106cde:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106ce7:	90                   	nop
80106ce8:	8b 45 10             	mov    0x10(%ebp),%eax
80106ceb:	8d 50 ff             	lea    -0x1(%eax),%edx
80106cee:	89 55 10             	mov    %edx,0x10(%ebp)
80106cf1:	85 c0                	test   %eax,%eax
80106cf3:	7e 2c                	jle    80106d21 <strncpy+0x46>
80106cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf8:	8d 50 01             	lea    0x1(%eax),%edx
80106cfb:	89 55 08             	mov    %edx,0x8(%ebp)
80106cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d01:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d04:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d07:	0f b6 12             	movzbl (%edx),%edx
80106d0a:	88 10                	mov    %dl,(%eax)
80106d0c:	0f b6 00             	movzbl (%eax),%eax
80106d0f:	84 c0                	test   %al,%al
80106d11:	75 d5                	jne    80106ce8 <strncpy+0xd>
    ;
  while(n-- > 0)
80106d13:	eb 0c                	jmp    80106d21 <strncpy+0x46>
    *s++ = 0;
80106d15:	8b 45 08             	mov    0x8(%ebp),%eax
80106d18:	8d 50 01             	lea    0x1(%eax),%edx
80106d1b:	89 55 08             	mov    %edx,0x8(%ebp)
80106d1e:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106d21:	8b 45 10             	mov    0x10(%ebp),%eax
80106d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d27:	89 55 10             	mov    %edx,0x10(%ebp)
80106d2a:	85 c0                	test   %eax,%eax
80106d2c:	7f e7                	jg     80106d15 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d31:	c9                   	leave  
80106d32:	c3                   	ret    

80106d33 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106d33:	55                   	push   %ebp
80106d34:	89 e5                	mov    %esp,%ebp
80106d36:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106d39:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106d3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d43:	7f 05                	jg     80106d4a <safestrcpy+0x17>
    return os;
80106d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d48:	eb 31                	jmp    80106d7b <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106d4a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d52:	7e 1e                	jle    80106d72 <safestrcpy+0x3f>
80106d54:	8b 45 08             	mov    0x8(%ebp),%eax
80106d57:	8d 50 01             	lea    0x1(%eax),%edx
80106d5a:	89 55 08             	mov    %edx,0x8(%ebp)
80106d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d60:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d66:	0f b6 12             	movzbl (%edx),%edx
80106d69:	88 10                	mov    %dl,(%eax)
80106d6b:	0f b6 00             	movzbl (%eax),%eax
80106d6e:	84 c0                	test   %al,%al
80106d70:	75 d8                	jne    80106d4a <safestrcpy+0x17>
    ;
  *s = 0;
80106d72:	8b 45 08             	mov    0x8(%ebp),%eax
80106d75:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d7b:	c9                   	leave  
80106d7c:	c3                   	ret    

80106d7d <strlen>:

int
strlen(const char *s)
{
80106d7d:	55                   	push   %ebp
80106d7e:	89 e5                	mov    %esp,%ebp
80106d80:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d8a:	eb 04                	jmp    80106d90 <strlen+0x13>
80106d8c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d90:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d93:	8b 45 08             	mov    0x8(%ebp),%eax
80106d96:	01 d0                	add    %edx,%eax
80106d98:	0f b6 00             	movzbl (%eax),%eax
80106d9b:	84 c0                	test   %al,%al
80106d9d:	75 ed                	jne    80106d8c <strlen+0xf>
    ;
  return n;
80106d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106da2:	c9                   	leave  
80106da3:	c3                   	ret    

80106da4 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106da4:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106da8:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106dac:	55                   	push   %ebp
  pushl %ebx
80106dad:	53                   	push   %ebx
  pushl %esi
80106dae:	56                   	push   %esi
  pushl %edi
80106daf:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106db0:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106db2:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106db4:	5f                   	pop    %edi
  popl %esi
80106db5:	5e                   	pop    %esi
  popl %ebx
80106db6:	5b                   	pop    %ebx
  popl %ebp
80106db7:	5d                   	pop    %ebp
  ret
80106db8:	c3                   	ret    

80106db9 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106db9:	55                   	push   %ebp
80106dba:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106dbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc2:	8b 00                	mov    (%eax),%eax
80106dc4:	3b 45 08             	cmp    0x8(%ebp),%eax
80106dc7:	76 12                	jbe    80106ddb <fetchint+0x22>
80106dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dcc:	8d 50 04             	lea    0x4(%eax),%edx
80106dcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dd5:	8b 00                	mov    (%eax),%eax
80106dd7:	39 c2                	cmp    %eax,%edx
80106dd9:	76 07                	jbe    80106de2 <fetchint+0x29>
    return -1;
80106ddb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106de0:	eb 0f                	jmp    80106df1 <fetchint+0x38>
  *ip = *(int*)(addr);
80106de2:	8b 45 08             	mov    0x8(%ebp),%eax
80106de5:	8b 10                	mov    (%eax),%edx
80106de7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dea:	89 10                	mov    %edx,(%eax)
  return 0;
80106dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106df1:	5d                   	pop    %ebp
80106df2:	c3                   	ret    

80106df3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106df3:	55                   	push   %ebp
80106df4:	89 e5                	mov    %esp,%ebp
80106df6:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106df9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dff:	8b 00                	mov    (%eax),%eax
80106e01:	3b 45 08             	cmp    0x8(%ebp),%eax
80106e04:	77 07                	ja     80106e0d <fetchstr+0x1a>
    return -1;
80106e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e0b:	eb 46                	jmp    80106e53 <fetchstr+0x60>
  *pp = (char*)addr;
80106e0d:	8b 55 08             	mov    0x8(%ebp),%edx
80106e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e13:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106e15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e1b:	8b 00                	mov    (%eax),%eax
80106e1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106e20:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e23:	8b 00                	mov    (%eax),%eax
80106e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106e28:	eb 1c                	jmp    80106e46 <fetchstr+0x53>
    if(*s == 0)
80106e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e2d:	0f b6 00             	movzbl (%eax),%eax
80106e30:	84 c0                	test   %al,%al
80106e32:	75 0e                	jne    80106e42 <fetchstr+0x4f>
      return s - *pp;
80106e34:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e3a:	8b 00                	mov    (%eax),%eax
80106e3c:	29 c2                	sub    %eax,%edx
80106e3e:	89 d0                	mov    %edx,%eax
80106e40:	eb 11                	jmp    80106e53 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106e42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e4c:	72 dc                	jb     80106e2a <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e53:	c9                   	leave  
80106e54:	c3                   	ret    

80106e55 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106e55:	55                   	push   %ebp
80106e56:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e5e:	8b 40 20             	mov    0x20(%eax),%eax
80106e61:	8b 40 44             	mov    0x44(%eax),%eax
80106e64:	8b 55 08             	mov    0x8(%ebp),%edx
80106e67:	c1 e2 02             	shl    $0x2,%edx
80106e6a:	01 d0                	add    %edx,%eax
80106e6c:	83 c0 04             	add    $0x4,%eax
80106e6f:	ff 75 0c             	pushl  0xc(%ebp)
80106e72:	50                   	push   %eax
80106e73:	e8 41 ff ff ff       	call   80106db9 <fetchint>
80106e78:	83 c4 08             	add    $0x8,%esp
}
80106e7b:	c9                   	leave  
80106e7c:	c3                   	ret    

80106e7d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106e7d:	55                   	push   %ebp
80106e7e:	89 e5                	mov    %esp,%ebp
80106e80:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106e83:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e86:	50                   	push   %eax
80106e87:	ff 75 08             	pushl  0x8(%ebp)
80106e8a:	e8 c6 ff ff ff       	call   80106e55 <argint>
80106e8f:	83 c4 08             	add    $0x8,%esp
80106e92:	85 c0                	test   %eax,%eax
80106e94:	79 07                	jns    80106e9d <argptr+0x20>
    return -1;
80106e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e9b:	eb 3b                	jmp    80106ed8 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea3:	8b 00                	mov    (%eax),%eax
80106ea5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106ea8:	39 d0                	cmp    %edx,%eax
80106eaa:	76 16                	jbe    80106ec2 <argptr+0x45>
80106eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106eaf:	89 c2                	mov    %eax,%edx
80106eb1:	8b 45 10             	mov    0x10(%ebp),%eax
80106eb4:	01 c2                	add    %eax,%edx
80106eb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebc:	8b 00                	mov    (%eax),%eax
80106ebe:	39 c2                	cmp    %eax,%edx
80106ec0:	76 07                	jbe    80106ec9 <argptr+0x4c>
    return -1;
80106ec2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ec7:	eb 0f                	jmp    80106ed8 <argptr+0x5b>
  *pp = (char*)i;
80106ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ecc:	89 c2                	mov    %eax,%edx
80106ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ed1:	89 10                	mov    %edx,(%eax)
  return 0;
80106ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ed8:	c9                   	leave  
80106ed9:	c3                   	ret    

80106eda <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106eda:	55                   	push   %ebp
80106edb:	89 e5                	mov    %esp,%ebp
80106edd:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106ee0:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106ee3:	50                   	push   %eax
80106ee4:	ff 75 08             	pushl  0x8(%ebp)
80106ee7:	e8 69 ff ff ff       	call   80106e55 <argint>
80106eec:	83 c4 08             	add    $0x8,%esp
80106eef:	85 c0                	test   %eax,%eax
80106ef1:	79 07                	jns    80106efa <argstr+0x20>
    return -1;
80106ef3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ef8:	eb 0f                	jmp    80106f09 <argstr+0x2f>
  return fetchstr(addr, pp);
80106efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106efd:	ff 75 0c             	pushl  0xc(%ebp)
80106f00:	50                   	push   %eax
80106f01:	e8 ed fe ff ff       	call   80106df3 <fetchstr>
80106f06:	83 c4 08             	add    $0x8,%esp
}
80106f09:	c9                   	leave  
80106f0a:	c3                   	ret    

80106f0b <syscall>:



void
syscall(void)
{
80106f0b:	55                   	push   %ebp
80106f0c:	89 e5                	mov    %esp,%ebp
80106f0e:	53                   	push   %ebx
80106f0f:	83 ec 14             	sub    $0x14,%esp
  int num = 0;
80106f12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  num = proc->tf->eax;
80106f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1f:	8b 40 20             	mov    0x20(%eax),%eax
80106f22:	8b 40 1c             	mov    0x1c(%eax),%eax
80106f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f2c:	7e 30                	jle    80106f5e <syscall+0x53>
80106f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f31:	83 f8 22             	cmp    $0x22,%eax
80106f34:	77 28                	ja     80106f5e <syscall+0x53>
80106f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f39:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f40:	85 c0                	test   %eax,%eax
80106f42:	74 1a                	je     80106f5e <syscall+0x53>
    proc->tf->eax = syscalls[num]();
80106f44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f4a:	8b 58 20             	mov    0x20(%eax),%ebx
80106f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f50:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f57:	ff d0                	call   *%eax
80106f59:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106f5c:	eb 34                	jmp    80106f92 <syscall+0x87>
    cprintf("%s -> %d \n", syscallnames[num],ret);
    #endif
// some code goes here
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106f5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f64:	8d 50 74             	lea    0x74(%eax),%edx
80106f67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    ret = proc->tf->eax;
    cprintf("%s -> %d \n", syscallnames[num],ret);
    #endif
// some code goes here
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106f6d:	8b 40 10             	mov    0x10(%eax),%eax
80106f70:	ff 75 f4             	pushl  -0xc(%ebp)
80106f73:	52                   	push   %edx
80106f74:	50                   	push   %eax
80106f75:	68 c6 a7 10 80       	push   $0x8010a7c6
80106f7a:	e8 47 94 ff ff       	call   801003c6 <cprintf>
80106f7f:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106f82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f88:	8b 40 20             	mov    0x20(%eax),%eax
80106f8b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106f92:	90                   	nop
80106f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f96:	c9                   	leave  
80106f97:	c3                   	ret    

80106f98 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106f98:	55                   	push   %ebp
80106f99:	89 e5                	mov    %esp,%ebp
80106f9b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106f9e:	83 ec 08             	sub    $0x8,%esp
80106fa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fa4:	50                   	push   %eax
80106fa5:	ff 75 08             	pushl  0x8(%ebp)
80106fa8:	e8 a8 fe ff ff       	call   80106e55 <argint>
80106fad:	83 c4 10             	add    $0x10,%esp
80106fb0:	85 c0                	test   %eax,%eax
80106fb2:	79 07                	jns    80106fbb <argfd+0x23>
    return -1;
80106fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fb9:	eb 4f                	jmp    8010700a <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fbe:	85 c0                	test   %eax,%eax
80106fc0:	78 20                	js     80106fe2 <argfd+0x4a>
80106fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fc5:	83 f8 0f             	cmp    $0xf,%eax
80106fc8:	7f 18                	jg     80106fe2 <argfd+0x4a>
80106fca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fd3:	83 c2 0c             	add    $0xc,%edx
80106fd6:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fe0:	75 07                	jne    80106fe9 <argfd+0x51>
    return -1;
80106fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fe7:	eb 21                	jmp    8010700a <argfd+0x72>
  if(pfd)
80106fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106fed:	74 08                	je     80106ff7 <argfd+0x5f>
    *pfd = fd;
80106fef:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ff5:	89 10                	mov    %edx,(%eax)
  if(pf)
80106ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106ffb:	74 08                	je     80107005 <argfd+0x6d>
    *pf = f;
80106ffd:	8b 45 10             	mov    0x10(%ebp),%eax
80107000:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107003:	89 10                	mov    %edx,(%eax)
  return 0;
80107005:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010700a:	c9                   	leave  
8010700b:	c3                   	ret    

8010700c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010700c:	55                   	push   %ebp
8010700d:	89 e5                	mov    %esp,%ebp
8010700f:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80107012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107019:	eb 2e                	jmp    80107049 <fdalloc+0x3d>
    if(proc->ofile[fd] == 0){
8010701b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107021:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107024:	83 c2 0c             	add    $0xc,%edx
80107027:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010702a:	85 c0                	test   %eax,%eax
8010702c:	75 17                	jne    80107045 <fdalloc+0x39>
      proc->ofile[fd] = f;
8010702e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107034:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107037:	8d 4a 0c             	lea    0xc(%edx),%ecx
8010703a:	8b 55 08             	mov    0x8(%ebp),%edx
8010703d:	89 14 88             	mov    %edx,(%eax,%ecx,4)
      return fd;
80107040:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107043:	eb 0f                	jmp    80107054 <fdalloc+0x48>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80107045:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107049:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010704d:	7e cc                	jle    8010701b <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010704f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107054:	c9                   	leave  
80107055:	c3                   	ret    

80107056 <sys_dup>:

int
sys_dup(void)
{
80107056:	55                   	push   %ebp
80107057:	89 e5                	mov    %esp,%ebp
80107059:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010705c:	83 ec 04             	sub    $0x4,%esp
8010705f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107062:	50                   	push   %eax
80107063:	6a 00                	push   $0x0
80107065:	6a 00                	push   $0x0
80107067:	e8 2c ff ff ff       	call   80106f98 <argfd>
8010706c:	83 c4 10             	add    $0x10,%esp
8010706f:	85 c0                	test   %eax,%eax
80107071:	79 07                	jns    8010707a <sys_dup+0x24>
    return -1;
80107073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107078:	eb 31                	jmp    801070ab <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010707a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010707d:	83 ec 0c             	sub    $0xc,%esp
80107080:	50                   	push   %eax
80107081:	e8 86 ff ff ff       	call   8010700c <fdalloc>
80107086:	83 c4 10             	add    $0x10,%esp
80107089:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010708c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107090:	79 07                	jns    80107099 <sys_dup+0x43>
    return -1;
80107092:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107097:	eb 12                	jmp    801070ab <sys_dup+0x55>
  filedup(f);
80107099:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010709c:	83 ec 0c             	sub    $0xc,%esp
8010709f:	50                   	push   %eax
801070a0:	e8 9f a0 ff ff       	call   80101144 <filedup>
801070a5:	83 c4 10             	add    $0x10,%esp
  return fd;
801070a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801070ab:	c9                   	leave  
801070ac:	c3                   	ret    

801070ad <sys_read>:

int
sys_read(void)
{
801070ad:	55                   	push   %ebp
801070ae:	89 e5                	mov    %esp,%ebp
801070b0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801070b3:	83 ec 04             	sub    $0x4,%esp
801070b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070b9:	50                   	push   %eax
801070ba:	6a 00                	push   $0x0
801070bc:	6a 00                	push   $0x0
801070be:	e8 d5 fe ff ff       	call   80106f98 <argfd>
801070c3:	83 c4 10             	add    $0x10,%esp
801070c6:	85 c0                	test   %eax,%eax
801070c8:	78 2e                	js     801070f8 <sys_read+0x4b>
801070ca:	83 ec 08             	sub    $0x8,%esp
801070cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070d0:	50                   	push   %eax
801070d1:	6a 02                	push   $0x2
801070d3:	e8 7d fd ff ff       	call   80106e55 <argint>
801070d8:	83 c4 10             	add    $0x10,%esp
801070db:	85 c0                	test   %eax,%eax
801070dd:	78 19                	js     801070f8 <sys_read+0x4b>
801070df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070e2:	83 ec 04             	sub    $0x4,%esp
801070e5:	50                   	push   %eax
801070e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070e9:	50                   	push   %eax
801070ea:	6a 01                	push   $0x1
801070ec:	e8 8c fd ff ff       	call   80106e7d <argptr>
801070f1:	83 c4 10             	add    $0x10,%esp
801070f4:	85 c0                	test   %eax,%eax
801070f6:	79 07                	jns    801070ff <sys_read+0x52>
    return -1;
801070f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070fd:	eb 17                	jmp    80107116 <sys_read+0x69>
  return fileread(f, p, n);
801070ff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107102:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107108:	83 ec 04             	sub    $0x4,%esp
8010710b:	51                   	push   %ecx
8010710c:	52                   	push   %edx
8010710d:	50                   	push   %eax
8010710e:	e8 c1 a1 ff ff       	call   801012d4 <fileread>
80107113:	83 c4 10             	add    $0x10,%esp
}
80107116:	c9                   	leave  
80107117:	c3                   	ret    

80107118 <sys_write>:

int
sys_write(void)
{
80107118:	55                   	push   %ebp
80107119:	89 e5                	mov    %esp,%ebp
8010711b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010711e:	83 ec 04             	sub    $0x4,%esp
80107121:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107124:	50                   	push   %eax
80107125:	6a 00                	push   $0x0
80107127:	6a 00                	push   $0x0
80107129:	e8 6a fe ff ff       	call   80106f98 <argfd>
8010712e:	83 c4 10             	add    $0x10,%esp
80107131:	85 c0                	test   %eax,%eax
80107133:	78 2e                	js     80107163 <sys_write+0x4b>
80107135:	83 ec 08             	sub    $0x8,%esp
80107138:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010713b:	50                   	push   %eax
8010713c:	6a 02                	push   $0x2
8010713e:	e8 12 fd ff ff       	call   80106e55 <argint>
80107143:	83 c4 10             	add    $0x10,%esp
80107146:	85 c0                	test   %eax,%eax
80107148:	78 19                	js     80107163 <sys_write+0x4b>
8010714a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010714d:	83 ec 04             	sub    $0x4,%esp
80107150:	50                   	push   %eax
80107151:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107154:	50                   	push   %eax
80107155:	6a 01                	push   $0x1
80107157:	e8 21 fd ff ff       	call   80106e7d <argptr>
8010715c:	83 c4 10             	add    $0x10,%esp
8010715f:	85 c0                	test   %eax,%eax
80107161:	79 07                	jns    8010716a <sys_write+0x52>
    return -1;
80107163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107168:	eb 17                	jmp    80107181 <sys_write+0x69>
  return filewrite(f, p, n);
8010716a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010716d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107173:	83 ec 04             	sub    $0x4,%esp
80107176:	51                   	push   %ecx
80107177:	52                   	push   %edx
80107178:	50                   	push   %eax
80107179:	e8 0e a2 ff ff       	call   8010138c <filewrite>
8010717e:	83 c4 10             	add    $0x10,%esp
}
80107181:	c9                   	leave  
80107182:	c3                   	ret    

80107183 <sys_close>:

int
sys_close(void)
{
80107183:	55                   	push   %ebp
80107184:	89 e5                	mov    %esp,%ebp
80107186:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80107189:	83 ec 04             	sub    $0x4,%esp
8010718c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010718f:	50                   	push   %eax
80107190:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107193:	50                   	push   %eax
80107194:	6a 00                	push   $0x0
80107196:	e8 fd fd ff ff       	call   80106f98 <argfd>
8010719b:	83 c4 10             	add    $0x10,%esp
8010719e:	85 c0                	test   %eax,%eax
801071a0:	79 07                	jns    801071a9 <sys_close+0x26>
    return -1;
801071a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071a7:	eb 27                	jmp    801071d0 <sys_close+0x4d>
  proc->ofile[fd] = 0;
801071a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801071b2:	83 c2 0c             	add    $0xc,%edx
801071b5:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
  fileclose(f);
801071bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071bf:	83 ec 0c             	sub    $0xc,%esp
801071c2:	50                   	push   %eax
801071c3:	e8 cd 9f ff ff       	call   80101195 <fileclose>
801071c8:	83 c4 10             	add    $0x10,%esp
  return 0;
801071cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801071d0:	c9                   	leave  
801071d1:	c3                   	ret    

801071d2 <sys_fstat>:

int
sys_fstat(void)
{
801071d2:	55                   	push   %ebp
801071d3:	89 e5                	mov    %esp,%ebp
801071d5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801071d8:	83 ec 04             	sub    $0x4,%esp
801071db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071de:	50                   	push   %eax
801071df:	6a 00                	push   $0x0
801071e1:	6a 00                	push   $0x0
801071e3:	e8 b0 fd ff ff       	call   80106f98 <argfd>
801071e8:	83 c4 10             	add    $0x10,%esp
801071eb:	85 c0                	test   %eax,%eax
801071ed:	78 17                	js     80107206 <sys_fstat+0x34>
801071ef:	83 ec 04             	sub    $0x4,%esp
801071f2:	6a 20                	push   $0x20
801071f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071f7:	50                   	push   %eax
801071f8:	6a 01                	push   $0x1
801071fa:	e8 7e fc ff ff       	call   80106e7d <argptr>
801071ff:	83 c4 10             	add    $0x10,%esp
80107202:	85 c0                	test   %eax,%eax
80107204:	79 07                	jns    8010720d <sys_fstat+0x3b>
    return -1;
80107206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010720b:	eb 13                	jmp    80107220 <sys_fstat+0x4e>
  return filestat(f, st);
8010720d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107213:	83 ec 08             	sub    $0x8,%esp
80107216:	52                   	push   %edx
80107217:	50                   	push   %eax
80107218:	e8 60 a0 ff ff       	call   8010127d <filestat>
8010721d:	83 c4 10             	add    $0x10,%esp
}
80107220:	c9                   	leave  
80107221:	c3                   	ret    

80107222 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80107222:	55                   	push   %ebp
80107223:	89 e5                	mov    %esp,%ebp
80107225:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80107228:	83 ec 08             	sub    $0x8,%esp
8010722b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010722e:	50                   	push   %eax
8010722f:	6a 00                	push   $0x0
80107231:	e8 a4 fc ff ff       	call   80106eda <argstr>
80107236:	83 c4 10             	add    $0x10,%esp
80107239:	85 c0                	test   %eax,%eax
8010723b:	78 15                	js     80107252 <sys_link+0x30>
8010723d:	83 ec 08             	sub    $0x8,%esp
80107240:	8d 45 dc             	lea    -0x24(%ebp),%eax
80107243:	50                   	push   %eax
80107244:	6a 01                	push   $0x1
80107246:	e8 8f fc ff ff       	call   80106eda <argstr>
8010724b:	83 c4 10             	add    $0x10,%esp
8010724e:	85 c0                	test   %eax,%eax
80107250:	79 0a                	jns    8010725c <sys_link+0x3a>
    return -1;
80107252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107257:	e9 68 01 00 00       	jmp    801073c4 <sys_link+0x1a2>

  begin_op();
8010725c:	e8 f6 c7 ff ff       	call   80103a57 <begin_op>
  if((ip = namei(old)) == 0){
80107261:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107264:	83 ec 0c             	sub    $0xc,%esp
80107267:	50                   	push   %eax
80107268:	e8 c5 b7 ff ff       	call   80102a32 <namei>
8010726d:	83 c4 10             	add    $0x10,%esp
80107270:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107277:	75 0f                	jne    80107288 <sys_link+0x66>
    end_op();
80107279:	e8 65 c8 ff ff       	call   80103ae3 <end_op>
    return -1;
8010727e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107283:	e9 3c 01 00 00       	jmp    801073c4 <sys_link+0x1a2>
  }

  ilock(ip);
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	ff 75 f4             	pushl  -0xc(%ebp)
8010728e:	e8 3f aa ff ff       	call   80101cd2 <ilock>
80107293:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80107296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107299:	0f b7 40 18          	movzwl 0x18(%eax),%eax
8010729d:	66 83 f8 01          	cmp    $0x1,%ax
801072a1:	75 1d                	jne    801072c0 <sys_link+0x9e>
    iunlockput(ip);
801072a3:	83 ec 0c             	sub    $0xc,%esp
801072a6:	ff 75 f4             	pushl  -0xc(%ebp)
801072a9:	e8 5a ae ff ff       	call   80102108 <iunlockput>
801072ae:	83 c4 10             	add    $0x10,%esp
    end_op();
801072b1:	e8 2d c8 ff ff       	call   80103ae3 <end_op>
    return -1;
801072b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072bb:	e9 04 01 00 00       	jmp    801073c4 <sys_link+0x1a2>
  }

  ip->nlink++;
801072c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c3:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
801072c7:	83 c0 01             	add    $0x1,%eax
801072ca:	89 c2                	mov    %eax,%edx
801072cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cf:	66 89 50 1e          	mov    %dx,0x1e(%eax)
  iupdate(ip);
801072d3:	83 ec 0c             	sub    $0xc,%esp
801072d6:	ff 75 f4             	pushl  -0xc(%ebp)
801072d9:	e8 98 a6 ff ff       	call   80101976 <iupdate>
801072de:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801072e1:	83 ec 0c             	sub    $0xc,%esp
801072e4:	ff 75 f4             	pushl  -0xc(%ebp)
801072e7:	e8 ba ac ff ff       	call   80101fa6 <iunlock>
801072ec:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801072ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801072f2:	83 ec 08             	sub    $0x8,%esp
801072f5:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801072f8:	52                   	push   %edx
801072f9:	50                   	push   %eax
801072fa:	e8 4f b7 ff ff       	call   80102a4e <nameiparent>
801072ff:	83 c4 10             	add    $0x10,%esp
80107302:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107305:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107309:	74 71                	je     8010737c <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010730b:	83 ec 0c             	sub    $0xc,%esp
8010730e:	ff 75 f0             	pushl  -0x10(%ebp)
80107311:	e8 bc a9 ff ff       	call   80101cd2 <ilock>
80107316:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107319:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010731c:	8b 10                	mov    (%eax),%edx
8010731e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107321:	8b 00                	mov    (%eax),%eax
80107323:	39 c2                	cmp    %eax,%edx
80107325:	75 1d                	jne    80107344 <sys_link+0x122>
80107327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732a:	8b 40 04             	mov    0x4(%eax),%eax
8010732d:	83 ec 04             	sub    $0x4,%esp
80107330:	50                   	push   %eax
80107331:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80107334:	50                   	push   %eax
80107335:	ff 75 f0             	pushl  -0x10(%ebp)
80107338:	e8 59 b4 ff ff       	call   80102796 <dirlink>
8010733d:	83 c4 10             	add    $0x10,%esp
80107340:	85 c0                	test   %eax,%eax
80107342:	79 10                	jns    80107354 <sys_link+0x132>
    iunlockput(dp);
80107344:	83 ec 0c             	sub    $0xc,%esp
80107347:	ff 75 f0             	pushl  -0x10(%ebp)
8010734a:	e8 b9 ad ff ff       	call   80102108 <iunlockput>
8010734f:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107352:	eb 29                	jmp    8010737d <sys_link+0x15b>
  }
  iunlockput(dp);
80107354:	83 ec 0c             	sub    $0xc,%esp
80107357:	ff 75 f0             	pushl  -0x10(%ebp)
8010735a:	e8 a9 ad ff ff       	call   80102108 <iunlockput>
8010735f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80107362:	83 ec 0c             	sub    $0xc,%esp
80107365:	ff 75 f4             	pushl  -0xc(%ebp)
80107368:	e8 ab ac ff ff       	call   80102018 <iput>
8010736d:	83 c4 10             	add    $0x10,%esp

  end_op();
80107370:	e8 6e c7 ff ff       	call   80103ae3 <end_op>

  return 0;
80107375:	b8 00 00 00 00       	mov    $0x0,%eax
8010737a:	eb 48                	jmp    801073c4 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010737c:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
8010737d:	83 ec 0c             	sub    $0xc,%esp
80107380:	ff 75 f4             	pushl  -0xc(%ebp)
80107383:	e8 4a a9 ff ff       	call   80101cd2 <ilock>
80107388:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010738b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738e:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
80107392:	83 e8 01             	sub    $0x1,%eax
80107395:	89 c2                	mov    %eax,%edx
80107397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739a:	66 89 50 1e          	mov    %dx,0x1e(%eax)
  iupdate(ip);
8010739e:	83 ec 0c             	sub    $0xc,%esp
801073a1:	ff 75 f4             	pushl  -0xc(%ebp)
801073a4:	e8 cd a5 ff ff       	call   80101976 <iupdate>
801073a9:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801073ac:	83 ec 0c             	sub    $0xc,%esp
801073af:	ff 75 f4             	pushl  -0xc(%ebp)
801073b2:	e8 51 ad ff ff       	call   80102108 <iunlockput>
801073b7:	83 c4 10             	add    $0x10,%esp
  end_op();
801073ba:	e8 24 c7 ff ff       	call   80103ae3 <end_op>
  return -1;
801073bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073c4:	c9                   	leave  
801073c5:	c3                   	ret    

801073c6 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801073c6:	55                   	push   %ebp
801073c7:	89 e5                	mov    %esp,%ebp
801073c9:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801073cc:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801073d3:	eb 40                	jmp    80107415 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801073d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d8:	6a 10                	push   $0x10
801073da:	50                   	push   %eax
801073db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801073de:	50                   	push   %eax
801073df:	ff 75 08             	pushl  0x8(%ebp)
801073e2:	e8 fb af ff ff       	call   801023e2 <readi>
801073e7:	83 c4 10             	add    $0x10,%esp
801073ea:	83 f8 10             	cmp    $0x10,%eax
801073ed:	74 0d                	je     801073fc <isdirempty+0x36>
      panic("isdirempty: readi");
801073ef:	83 ec 0c             	sub    $0xc,%esp
801073f2:	68 e2 a7 10 80       	push   $0x8010a7e2
801073f7:	e8 6a 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801073fc:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107400:	66 85 c0             	test   %ax,%ax
80107403:	74 07                	je     8010740c <isdirempty+0x46>
      return 0;
80107405:	b8 00 00 00 00       	mov    $0x0,%eax
8010740a:	eb 1b                	jmp    80107427 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010740c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740f:	83 c0 10             	add    $0x10,%eax
80107412:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107415:	8b 45 08             	mov    0x8(%ebp),%eax
80107418:	8b 50 20             	mov    0x20(%eax),%edx
8010741b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741e:	39 c2                	cmp    %eax,%edx
80107420:	77 b3                	ja     801073d5 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80107422:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107427:	c9                   	leave  
80107428:	c3                   	ret    

80107429 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80107429:	55                   	push   %ebp
8010742a:	89 e5                	mov    %esp,%ebp
8010742c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010742f:	83 ec 08             	sub    $0x8,%esp
80107432:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107435:	50                   	push   %eax
80107436:	6a 00                	push   $0x0
80107438:	e8 9d fa ff ff       	call   80106eda <argstr>
8010743d:	83 c4 10             	add    $0x10,%esp
80107440:	85 c0                	test   %eax,%eax
80107442:	79 0a                	jns    8010744e <sys_unlink+0x25>
    return -1;
80107444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107449:	e9 bc 01 00 00       	jmp    8010760a <sys_unlink+0x1e1>

  begin_op();
8010744e:	e8 04 c6 ff ff       	call   80103a57 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80107453:	8b 45 cc             	mov    -0x34(%ebp),%eax
80107456:	83 ec 08             	sub    $0x8,%esp
80107459:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010745c:	52                   	push   %edx
8010745d:	50                   	push   %eax
8010745e:	e8 eb b5 ff ff       	call   80102a4e <nameiparent>
80107463:	83 c4 10             	add    $0x10,%esp
80107466:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010746d:	75 0f                	jne    8010747e <sys_unlink+0x55>
    end_op();
8010746f:	e8 6f c6 ff ff       	call   80103ae3 <end_op>
    return -1;
80107474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107479:	e9 8c 01 00 00       	jmp    8010760a <sys_unlink+0x1e1>
  }

  ilock(dp);
8010747e:	83 ec 0c             	sub    $0xc,%esp
80107481:	ff 75 f4             	pushl  -0xc(%ebp)
80107484:	e8 49 a8 ff ff       	call   80101cd2 <ilock>
80107489:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010748c:	83 ec 08             	sub    $0x8,%esp
8010748f:	68 f4 a7 10 80       	push   $0x8010a7f4
80107494:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107497:	50                   	push   %eax
80107498:	e8 24 b2 ff ff       	call   801026c1 <namecmp>
8010749d:	83 c4 10             	add    $0x10,%esp
801074a0:	85 c0                	test   %eax,%eax
801074a2:	0f 84 4a 01 00 00    	je     801075f2 <sys_unlink+0x1c9>
801074a8:	83 ec 08             	sub    $0x8,%esp
801074ab:	68 f6 a7 10 80       	push   $0x8010a7f6
801074b0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801074b3:	50                   	push   %eax
801074b4:	e8 08 b2 ff ff       	call   801026c1 <namecmp>
801074b9:	83 c4 10             	add    $0x10,%esp
801074bc:	85 c0                	test   %eax,%eax
801074be:	0f 84 2e 01 00 00    	je     801075f2 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801074c4:	83 ec 04             	sub    $0x4,%esp
801074c7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801074ca:	50                   	push   %eax
801074cb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801074ce:	50                   	push   %eax
801074cf:	ff 75 f4             	pushl  -0xc(%ebp)
801074d2:	e8 05 b2 ff ff       	call   801026dc <dirlookup>
801074d7:	83 c4 10             	add    $0x10,%esp
801074da:	89 45 f0             	mov    %eax,-0x10(%ebp)
801074dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801074e1:	0f 84 0a 01 00 00    	je     801075f1 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
801074e7:	83 ec 0c             	sub    $0xc,%esp
801074ea:	ff 75 f0             	pushl  -0x10(%ebp)
801074ed:	e8 e0 a7 ff ff       	call   80101cd2 <ilock>
801074f2:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801074f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074f8:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
801074fc:	66 85 c0             	test   %ax,%ax
801074ff:	7f 0d                	jg     8010750e <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80107501:	83 ec 0c             	sub    $0xc,%esp
80107504:	68 f9 a7 10 80       	push   $0x8010a7f9
80107509:	e8 58 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010750e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107511:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80107515:	66 83 f8 01          	cmp    $0x1,%ax
80107519:	75 25                	jne    80107540 <sys_unlink+0x117>
8010751b:	83 ec 0c             	sub    $0xc,%esp
8010751e:	ff 75 f0             	pushl  -0x10(%ebp)
80107521:	e8 a0 fe ff ff       	call   801073c6 <isdirempty>
80107526:	83 c4 10             	add    $0x10,%esp
80107529:	85 c0                	test   %eax,%eax
8010752b:	75 13                	jne    80107540 <sys_unlink+0x117>
    iunlockput(ip);
8010752d:	83 ec 0c             	sub    $0xc,%esp
80107530:	ff 75 f0             	pushl  -0x10(%ebp)
80107533:	e8 d0 ab ff ff       	call   80102108 <iunlockput>
80107538:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010753b:	e9 b2 00 00 00       	jmp    801075f2 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80107540:	83 ec 04             	sub    $0x4,%esp
80107543:	6a 10                	push   $0x10
80107545:	6a 00                	push   $0x0
80107547:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010754a:	50                   	push   %eax
8010754b:	e8 e0 f5 ff ff       	call   80106b30 <memset>
80107550:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107553:	8b 45 c8             	mov    -0x38(%ebp),%eax
80107556:	6a 10                	push   $0x10
80107558:	50                   	push   %eax
80107559:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010755c:	50                   	push   %eax
8010755d:	ff 75 f4             	pushl  -0xc(%ebp)
80107560:	e8 d4 af ff ff       	call   80102539 <writei>
80107565:	83 c4 10             	add    $0x10,%esp
80107568:	83 f8 10             	cmp    $0x10,%eax
8010756b:	74 0d                	je     8010757a <sys_unlink+0x151>
    panic("unlink: writei");
8010756d:	83 ec 0c             	sub    $0xc,%esp
80107570:	68 0b a8 10 80       	push   $0x8010a80b
80107575:	e8 ec 8f ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
8010757a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010757d:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80107581:	66 83 f8 01          	cmp    $0x1,%ax
80107585:	75 21                	jne    801075a8 <sys_unlink+0x17f>
    dp->nlink--;
80107587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758a:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
8010758e:	83 e8 01             	sub    $0x1,%eax
80107591:	89 c2                	mov    %eax,%edx
80107593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107596:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    iupdate(dp);
8010759a:	83 ec 0c             	sub    $0xc,%esp
8010759d:	ff 75 f4             	pushl  -0xc(%ebp)
801075a0:	e8 d1 a3 ff ff       	call   80101976 <iupdate>
801075a5:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801075a8:	83 ec 0c             	sub    $0xc,%esp
801075ab:	ff 75 f4             	pushl  -0xc(%ebp)
801075ae:	e8 55 ab ff ff       	call   80102108 <iunlockput>
801075b3:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801075b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075b9:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
801075bd:	83 e8 01             	sub    $0x1,%eax
801075c0:	89 c2                	mov    %eax,%edx
801075c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075c5:	66 89 50 1e          	mov    %dx,0x1e(%eax)
  iupdate(ip);
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	ff 75 f0             	pushl  -0x10(%ebp)
801075cf:	e8 a2 a3 ff ff       	call   80101976 <iupdate>
801075d4:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801075d7:	83 ec 0c             	sub    $0xc,%esp
801075da:	ff 75 f0             	pushl  -0x10(%ebp)
801075dd:	e8 26 ab ff ff       	call   80102108 <iunlockput>
801075e2:	83 c4 10             	add    $0x10,%esp

  end_op();
801075e5:	e8 f9 c4 ff ff       	call   80103ae3 <end_op>

  return 0;
801075ea:	b8 00 00 00 00       	mov    $0x0,%eax
801075ef:	eb 19                	jmp    8010760a <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801075f1:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801075f2:	83 ec 0c             	sub    $0xc,%esp
801075f5:	ff 75 f4             	pushl  -0xc(%ebp)
801075f8:	e8 0b ab ff ff       	call   80102108 <iunlockput>
801075fd:	83 c4 10             	add    $0x10,%esp
  end_op();
80107600:	e8 de c4 ff ff       	call   80103ae3 <end_op>
  return -1;
80107605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010760a:	c9                   	leave  
8010760b:	c3                   	ret    

8010760c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010760c:	55                   	push   %ebp
8010760d:	89 e5                	mov    %esp,%ebp
8010760f:	83 ec 38             	sub    $0x38,%esp
80107612:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107615:	8b 55 10             	mov    0x10(%ebp),%edx
80107618:	8b 45 14             	mov    0x14(%ebp),%eax
8010761b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010761f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107623:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107627:	83 ec 08             	sub    $0x8,%esp
8010762a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010762d:	50                   	push   %eax
8010762e:	ff 75 08             	pushl  0x8(%ebp)
80107631:	e8 18 b4 ff ff       	call   80102a4e <nameiparent>
80107636:	83 c4 10             	add    $0x10,%esp
80107639:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010763c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107640:	75 0a                	jne    8010764c <create+0x40>
    return 0;
80107642:	b8 00 00 00 00       	mov    $0x0,%eax
80107647:	e9 90 01 00 00       	jmp    801077dc <create+0x1d0>
  ilock(dp);
8010764c:	83 ec 0c             	sub    $0xc,%esp
8010764f:	ff 75 f4             	pushl  -0xc(%ebp)
80107652:	e8 7b a6 ff ff       	call   80101cd2 <ilock>
80107657:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010765a:	83 ec 04             	sub    $0x4,%esp
8010765d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107660:	50                   	push   %eax
80107661:	8d 45 de             	lea    -0x22(%ebp),%eax
80107664:	50                   	push   %eax
80107665:	ff 75 f4             	pushl  -0xc(%ebp)
80107668:	e8 6f b0 ff ff       	call   801026dc <dirlookup>
8010766d:	83 c4 10             	add    $0x10,%esp
80107670:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107673:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107677:	74 50                	je     801076c9 <create+0xbd>
    iunlockput(dp);
80107679:	83 ec 0c             	sub    $0xc,%esp
8010767c:	ff 75 f4             	pushl  -0xc(%ebp)
8010767f:	e8 84 aa ff ff       	call   80102108 <iunlockput>
80107684:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107687:	83 ec 0c             	sub    $0xc,%esp
8010768a:	ff 75 f0             	pushl  -0x10(%ebp)
8010768d:	e8 40 a6 ff ff       	call   80101cd2 <ilock>
80107692:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80107695:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010769a:	75 15                	jne    801076b1 <create+0xa5>
8010769c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010769f:	0f b7 40 18          	movzwl 0x18(%eax),%eax
801076a3:	66 83 f8 02          	cmp    $0x2,%ax
801076a7:	75 08                	jne    801076b1 <create+0xa5>
      return ip;
801076a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ac:	e9 2b 01 00 00       	jmp    801077dc <create+0x1d0>
    iunlockput(ip);
801076b1:	83 ec 0c             	sub    $0xc,%esp
801076b4:	ff 75 f0             	pushl  -0x10(%ebp)
801076b7:	e8 4c aa ff ff       	call   80102108 <iunlockput>
801076bc:	83 c4 10             	add    $0x10,%esp
    return 0;
801076bf:	b8 00 00 00 00       	mov    $0x0,%eax
801076c4:	e9 13 01 00 00       	jmp    801077dc <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801076c9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801076cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d0:	8b 00                	mov    (%eax),%eax
801076d2:	83 ec 08             	sub    $0x8,%esp
801076d5:	52                   	push   %edx
801076d6:	50                   	push   %eax
801076d7:	e8 21 a1 ff ff       	call   801017fd <ialloc>
801076dc:	83 c4 10             	add    $0x10,%esp
801076df:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076e6:	75 0d                	jne    801076f5 <create+0xe9>
    panic("create: ialloc");
801076e8:	83 ec 0c             	sub    $0xc,%esp
801076eb:	68 1a a8 10 80       	push   $0x8010a81a
801076f0:	e8 71 8e ff ff       	call   80100566 <panic>

  ilock(ip);
801076f5:	83 ec 0c             	sub    $0xc,%esp
801076f8:	ff 75 f0             	pushl  -0x10(%ebp)
801076fb:	e8 d2 a5 ff ff       	call   80101cd2 <ilock>
80107700:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107706:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010770a:	66 89 50 1a          	mov    %dx,0x1a(%eax)
  ip->minor = minor;
8010770e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107711:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107715:	66 89 50 1c          	mov    %dx,0x1c(%eax)
  ip->nlink = 1;
80107719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010771c:	66 c7 40 1e 01 00    	movw   $0x1,0x1e(%eax)
  iupdate(ip);
80107722:	83 ec 0c             	sub    $0xc,%esp
80107725:	ff 75 f0             	pushl  -0x10(%ebp)
80107728:	e8 49 a2 ff ff       	call   80101976 <iupdate>
8010772d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80107730:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107735:	75 6a                	jne    801077a1 <create+0x195>
    dp->nlink++;  // for ".."
80107737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773a:	0f b7 40 1e          	movzwl 0x1e(%eax),%eax
8010773e:	83 c0 01             	add    $0x1,%eax
80107741:	89 c2                	mov    %eax,%edx
80107743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107746:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    iupdate(dp);
8010774a:	83 ec 0c             	sub    $0xc,%esp
8010774d:	ff 75 f4             	pushl  -0xc(%ebp)
80107750:	e8 21 a2 ff ff       	call   80101976 <iupdate>
80107755:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010775b:	8b 40 04             	mov    0x4(%eax),%eax
8010775e:	83 ec 04             	sub    $0x4,%esp
80107761:	50                   	push   %eax
80107762:	68 f4 a7 10 80       	push   $0x8010a7f4
80107767:	ff 75 f0             	pushl  -0x10(%ebp)
8010776a:	e8 27 b0 ff ff       	call   80102796 <dirlink>
8010776f:	83 c4 10             	add    $0x10,%esp
80107772:	85 c0                	test   %eax,%eax
80107774:	78 1e                	js     80107794 <create+0x188>
80107776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107779:	8b 40 04             	mov    0x4(%eax),%eax
8010777c:	83 ec 04             	sub    $0x4,%esp
8010777f:	50                   	push   %eax
80107780:	68 f6 a7 10 80       	push   $0x8010a7f6
80107785:	ff 75 f0             	pushl  -0x10(%ebp)
80107788:	e8 09 b0 ff ff       	call   80102796 <dirlink>
8010778d:	83 c4 10             	add    $0x10,%esp
80107790:	85 c0                	test   %eax,%eax
80107792:	79 0d                	jns    801077a1 <create+0x195>
      panic("create dots");
80107794:	83 ec 0c             	sub    $0xc,%esp
80107797:	68 29 a8 10 80       	push   $0x8010a829
8010779c:	e8 c5 8d ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801077a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077a4:	8b 40 04             	mov    0x4(%eax),%eax
801077a7:	83 ec 04             	sub    $0x4,%esp
801077aa:	50                   	push   %eax
801077ab:	8d 45 de             	lea    -0x22(%ebp),%eax
801077ae:	50                   	push   %eax
801077af:	ff 75 f4             	pushl  -0xc(%ebp)
801077b2:	e8 df af ff ff       	call   80102796 <dirlink>
801077b7:	83 c4 10             	add    $0x10,%esp
801077ba:	85 c0                	test   %eax,%eax
801077bc:	79 0d                	jns    801077cb <create+0x1bf>
    panic("create: dirlink");
801077be:	83 ec 0c             	sub    $0xc,%esp
801077c1:	68 35 a8 10 80       	push   $0x8010a835
801077c6:	e8 9b 8d ff ff       	call   80100566 <panic>

  iunlockput(dp);
801077cb:	83 ec 0c             	sub    $0xc,%esp
801077ce:	ff 75 f4             	pushl  -0xc(%ebp)
801077d1:	e8 32 a9 ff ff       	call   80102108 <iunlockput>
801077d6:	83 c4 10             	add    $0x10,%esp

  return ip;
801077d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801077dc:	c9                   	leave  
801077dd:	c3                   	ret    

801077de <sys_open>:

int
sys_open(void)
{
801077de:	55                   	push   %ebp
801077df:	89 e5                	mov    %esp,%ebp
801077e1:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801077e4:	83 ec 08             	sub    $0x8,%esp
801077e7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801077ea:	50                   	push   %eax
801077eb:	6a 00                	push   $0x0
801077ed:	e8 e8 f6 ff ff       	call   80106eda <argstr>
801077f2:	83 c4 10             	add    $0x10,%esp
801077f5:	85 c0                	test   %eax,%eax
801077f7:	78 15                	js     8010780e <sys_open+0x30>
801077f9:	83 ec 08             	sub    $0x8,%esp
801077fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801077ff:	50                   	push   %eax
80107800:	6a 01                	push   $0x1
80107802:	e8 4e f6 ff ff       	call   80106e55 <argint>
80107807:	83 c4 10             	add    $0x10,%esp
8010780a:	85 c0                	test   %eax,%eax
8010780c:	79 0a                	jns    80107818 <sys_open+0x3a>
    return -1;
8010780e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107813:	e9 61 01 00 00       	jmp    80107979 <sys_open+0x19b>

  begin_op();
80107818:	e8 3a c2 ff ff       	call   80103a57 <begin_op>

  if(omode & O_CREATE){
8010781d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107820:	25 00 02 00 00       	and    $0x200,%eax
80107825:	85 c0                	test   %eax,%eax
80107827:	74 2a                	je     80107853 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107829:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010782c:	6a 00                	push   $0x0
8010782e:	6a 00                	push   $0x0
80107830:	6a 02                	push   $0x2
80107832:	50                   	push   %eax
80107833:	e8 d4 fd ff ff       	call   8010760c <create>
80107838:	83 c4 10             	add    $0x10,%esp
8010783b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010783e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107842:	75 75                	jne    801078b9 <sys_open+0xdb>
      end_op();
80107844:	e8 9a c2 ff ff       	call   80103ae3 <end_op>
      return -1;
80107849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010784e:	e9 26 01 00 00       	jmp    80107979 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107853:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107856:	83 ec 0c             	sub    $0xc,%esp
80107859:	50                   	push   %eax
8010785a:	e8 d3 b1 ff ff       	call   80102a32 <namei>
8010785f:	83 c4 10             	add    $0x10,%esp
80107862:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107869:	75 0f                	jne    8010787a <sys_open+0x9c>
      end_op();
8010786b:	e8 73 c2 ff ff       	call   80103ae3 <end_op>
      return -1;
80107870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107875:	e9 ff 00 00 00       	jmp    80107979 <sys_open+0x19b>
    }
    ilock(ip);
8010787a:	83 ec 0c             	sub    $0xc,%esp
8010787d:	ff 75 f4             	pushl  -0xc(%ebp)
80107880:	e8 4d a4 ff ff       	call   80101cd2 <ilock>
80107885:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788b:	0f b7 40 18          	movzwl 0x18(%eax),%eax
8010788f:	66 83 f8 01          	cmp    $0x1,%ax
80107893:	75 24                	jne    801078b9 <sys_open+0xdb>
80107895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107898:	85 c0                	test   %eax,%eax
8010789a:	74 1d                	je     801078b9 <sys_open+0xdb>
      iunlockput(ip);
8010789c:	83 ec 0c             	sub    $0xc,%esp
8010789f:	ff 75 f4             	pushl  -0xc(%ebp)
801078a2:	e8 61 a8 ff ff       	call   80102108 <iunlockput>
801078a7:	83 c4 10             	add    $0x10,%esp
      end_op();
801078aa:	e8 34 c2 ff ff       	call   80103ae3 <end_op>
      return -1;
801078af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078b4:	e9 c0 00 00 00       	jmp    80107979 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801078b9:	e8 19 98 ff ff       	call   801010d7 <filealloc>
801078be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078c5:	74 17                	je     801078de <sys_open+0x100>
801078c7:	83 ec 0c             	sub    $0xc,%esp
801078ca:	ff 75 f0             	pushl  -0x10(%ebp)
801078cd:	e8 3a f7 ff ff       	call   8010700c <fdalloc>
801078d2:	83 c4 10             	add    $0x10,%esp
801078d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801078d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078dc:	79 2e                	jns    8010790c <sys_open+0x12e>
    if(f)
801078de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078e2:	74 0e                	je     801078f2 <sys_open+0x114>
      fileclose(f);
801078e4:	83 ec 0c             	sub    $0xc,%esp
801078e7:	ff 75 f0             	pushl  -0x10(%ebp)
801078ea:	e8 a6 98 ff ff       	call   80101195 <fileclose>
801078ef:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801078f2:	83 ec 0c             	sub    $0xc,%esp
801078f5:	ff 75 f4             	pushl  -0xc(%ebp)
801078f8:	e8 0b a8 ff ff       	call   80102108 <iunlockput>
801078fd:	83 c4 10             	add    $0x10,%esp
    end_op();
80107900:	e8 de c1 ff ff       	call   80103ae3 <end_op>
    return -1;
80107905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010790a:	eb 6d                	jmp    80107979 <sys_open+0x19b>
  }
  iunlock(ip);
8010790c:	83 ec 0c             	sub    $0xc,%esp
8010790f:	ff 75 f4             	pushl  -0xc(%ebp)
80107912:	e8 8f a6 ff ff       	call   80101fa6 <iunlock>
80107917:	83 c4 10             	add    $0x10,%esp
  end_op();
8010791a:	e8 c4 c1 ff ff       	call   80103ae3 <end_op>

  f->type = FD_INODE;
8010791f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107922:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107928:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010792b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010792e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107931:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107934:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010793b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010793e:	83 e0 01             	and    $0x1,%eax
80107941:	85 c0                	test   %eax,%eax
80107943:	0f 94 c0             	sete   %al
80107946:	89 c2                	mov    %eax,%edx
80107948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010794b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010794e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107951:	83 e0 01             	and    $0x1,%eax
80107954:	85 c0                	test   %eax,%eax
80107956:	75 0a                	jne    80107962 <sys_open+0x184>
80107958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010795b:	83 e0 02             	and    $0x2,%eax
8010795e:	85 c0                	test   %eax,%eax
80107960:	74 07                	je     80107969 <sys_open+0x18b>
80107962:	b8 01 00 00 00       	mov    $0x1,%eax
80107967:	eb 05                	jmp    8010796e <sys_open+0x190>
80107969:	b8 00 00 00 00       	mov    $0x0,%eax
8010796e:	89 c2                	mov    %eax,%edx
80107970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107973:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80107976:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107979:	c9                   	leave  
8010797a:	c3                   	ret    

8010797b <sys_mkdir>:

int
sys_mkdir(void)
{
8010797b:	55                   	push   %ebp
8010797c:	89 e5                	mov    %esp,%ebp
8010797e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107981:	e8 d1 c0 ff ff       	call   80103a57 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107986:	83 ec 08             	sub    $0x8,%esp
80107989:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010798c:	50                   	push   %eax
8010798d:	6a 00                	push   $0x0
8010798f:	e8 46 f5 ff ff       	call   80106eda <argstr>
80107994:	83 c4 10             	add    $0x10,%esp
80107997:	85 c0                	test   %eax,%eax
80107999:	78 1b                	js     801079b6 <sys_mkdir+0x3b>
8010799b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010799e:	6a 00                	push   $0x0
801079a0:	6a 00                	push   $0x0
801079a2:	6a 01                	push   $0x1
801079a4:	50                   	push   %eax
801079a5:	e8 62 fc ff ff       	call   8010760c <create>
801079aa:	83 c4 10             	add    $0x10,%esp
801079ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079b4:	75 0c                	jne    801079c2 <sys_mkdir+0x47>
    end_op();
801079b6:	e8 28 c1 ff ff       	call   80103ae3 <end_op>
    return -1;
801079bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079c0:	eb 18                	jmp    801079da <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801079c2:	83 ec 0c             	sub    $0xc,%esp
801079c5:	ff 75 f4             	pushl  -0xc(%ebp)
801079c8:	e8 3b a7 ff ff       	call   80102108 <iunlockput>
801079cd:	83 c4 10             	add    $0x10,%esp
  end_op();
801079d0:	e8 0e c1 ff ff       	call   80103ae3 <end_op>
  return 0;
801079d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079da:	c9                   	leave  
801079db:	c3                   	ret    

801079dc <sys_mknod>:

int
sys_mknod(void)
{
801079dc:	55                   	push   %ebp
801079dd:	89 e5                	mov    %esp,%ebp
801079df:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801079e2:	e8 70 c0 ff ff       	call   80103a57 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801079e7:	83 ec 08             	sub    $0x8,%esp
801079ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
801079ed:	50                   	push   %eax
801079ee:	6a 00                	push   $0x0
801079f0:	e8 e5 f4 ff ff       	call   80106eda <argstr>
801079f5:	83 c4 10             	add    $0x10,%esp
801079f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079ff:	78 4f                	js     80107a50 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107a01:	83 ec 08             	sub    $0x8,%esp
80107a04:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107a07:	50                   	push   %eax
80107a08:	6a 01                	push   $0x1
80107a0a:	e8 46 f4 ff ff       	call   80106e55 <argint>
80107a0f:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107a12:	85 c0                	test   %eax,%eax
80107a14:	78 3a                	js     80107a50 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107a16:	83 ec 08             	sub    $0x8,%esp
80107a19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107a1c:	50                   	push   %eax
80107a1d:	6a 02                	push   $0x2
80107a1f:	e8 31 f4 ff ff       	call   80106e55 <argint>
80107a24:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107a27:	85 c0                	test   %eax,%eax
80107a29:	78 25                	js     80107a50 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a2e:	0f bf c8             	movswl %ax,%ecx
80107a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a34:	0f bf d0             	movswl %ax,%edx
80107a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107a3a:	51                   	push   %ecx
80107a3b:	52                   	push   %edx
80107a3c:	6a 03                	push   $0x3
80107a3e:	50                   	push   %eax
80107a3f:	e8 c8 fb ff ff       	call   8010760c <create>
80107a44:	83 c4 10             	add    $0x10,%esp
80107a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a4e:	75 0c                	jne    80107a5c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107a50:	e8 8e c0 ff ff       	call   80103ae3 <end_op>
    return -1;
80107a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a5a:	eb 18                	jmp    80107a74 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107a5c:	83 ec 0c             	sub    $0xc,%esp
80107a5f:	ff 75 f0             	pushl  -0x10(%ebp)
80107a62:	e8 a1 a6 ff ff       	call   80102108 <iunlockput>
80107a67:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a6a:	e8 74 c0 ff ff       	call   80103ae3 <end_op>
  return 0;
80107a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a74:	c9                   	leave  
80107a75:	c3                   	ret    

80107a76 <sys_chdir>:

int
sys_chdir(void)
{
80107a76:	55                   	push   %ebp
80107a77:	89 e5                	mov    %esp,%ebp
80107a79:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107a7c:	e8 d6 bf ff ff       	call   80103a57 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107a81:	83 ec 08             	sub    $0x8,%esp
80107a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a87:	50                   	push   %eax
80107a88:	6a 00                	push   $0x0
80107a8a:	e8 4b f4 ff ff       	call   80106eda <argstr>
80107a8f:	83 c4 10             	add    $0x10,%esp
80107a92:	85 c0                	test   %eax,%eax
80107a94:	78 18                	js     80107aae <sys_chdir+0x38>
80107a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a99:	83 ec 0c             	sub    $0xc,%esp
80107a9c:	50                   	push   %eax
80107a9d:	e8 90 af ff ff       	call   80102a32 <namei>
80107aa2:	83 c4 10             	add    $0x10,%esp
80107aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107aa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107aac:	75 0c                	jne    80107aba <sys_chdir+0x44>
    end_op();
80107aae:	e8 30 c0 ff ff       	call   80103ae3 <end_op>
    return -1;
80107ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ab8:	eb 6e                	jmp    80107b28 <sys_chdir+0xb2>
  }
  ilock(ip);
80107aba:	83 ec 0c             	sub    $0xc,%esp
80107abd:	ff 75 f4             	pushl  -0xc(%ebp)
80107ac0:	e8 0d a2 ff ff       	call   80101cd2 <ilock>
80107ac5:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acb:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80107acf:	66 83 f8 01          	cmp    $0x1,%ax
80107ad3:	74 1a                	je     80107aef <sys_chdir+0x79>
    iunlockput(ip);
80107ad5:	83 ec 0c             	sub    $0xc,%esp
80107ad8:	ff 75 f4             	pushl  -0xc(%ebp)
80107adb:	e8 28 a6 ff ff       	call   80102108 <iunlockput>
80107ae0:	83 c4 10             	add    $0x10,%esp
    end_op();
80107ae3:	e8 fb bf ff ff       	call   80103ae3 <end_op>
    return -1;
80107ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107aed:	eb 39                	jmp    80107b28 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107aef:	83 ec 0c             	sub    $0xc,%esp
80107af2:	ff 75 f4             	pushl  -0xc(%ebp)
80107af5:	e8 ac a4 ff ff       	call   80101fa6 <iunlock>
80107afa:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107afd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b03:	8b 40 70             	mov    0x70(%eax),%eax
80107b06:	83 ec 0c             	sub    $0xc,%esp
80107b09:	50                   	push   %eax
80107b0a:	e8 09 a5 ff ff       	call   80102018 <iput>
80107b0f:	83 c4 10             	add    $0x10,%esp
  end_op();
80107b12:	e8 cc bf ff ff       	call   80103ae3 <end_op>
  proc->cwd = ip;
80107b17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b20:	89 50 70             	mov    %edx,0x70(%eax)
  return 0;
80107b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b28:	c9                   	leave  
80107b29:	c3                   	ret    

80107b2a <sys_exec>:

int
sys_exec(void)
{
80107b2a:	55                   	push   %ebp
80107b2b:	89 e5                	mov    %esp,%ebp
80107b2d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107b33:	83 ec 08             	sub    $0x8,%esp
80107b36:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b39:	50                   	push   %eax
80107b3a:	6a 00                	push   $0x0
80107b3c:	e8 99 f3 ff ff       	call   80106eda <argstr>
80107b41:	83 c4 10             	add    $0x10,%esp
80107b44:	85 c0                	test   %eax,%eax
80107b46:	78 18                	js     80107b60 <sys_exec+0x36>
80107b48:	83 ec 08             	sub    $0x8,%esp
80107b4b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107b51:	50                   	push   %eax
80107b52:	6a 01                	push   $0x1
80107b54:	e8 fc f2 ff ff       	call   80106e55 <argint>
80107b59:	83 c4 10             	add    $0x10,%esp
80107b5c:	85 c0                	test   %eax,%eax
80107b5e:	79 0a                	jns    80107b6a <sys_exec+0x40>
    return -1;
80107b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b65:	e9 c6 00 00 00       	jmp    80107c30 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107b6a:	83 ec 04             	sub    $0x4,%esp
80107b6d:	68 80 00 00 00       	push   $0x80
80107b72:	6a 00                	push   $0x0
80107b74:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b7a:	50                   	push   %eax
80107b7b:	e8 b0 ef ff ff       	call   80106b30 <memset>
80107b80:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8d:	83 f8 1f             	cmp    $0x1f,%eax
80107b90:	76 0a                	jbe    80107b9c <sys_exec+0x72>
      return -1;
80107b92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b97:	e9 94 00 00 00       	jmp    80107c30 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9f:	c1 e0 02             	shl    $0x2,%eax
80107ba2:	89 c2                	mov    %eax,%edx
80107ba4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107baa:	01 c2                	add    %eax,%edx
80107bac:	83 ec 08             	sub    $0x8,%esp
80107baf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107bb5:	50                   	push   %eax
80107bb6:	52                   	push   %edx
80107bb7:	e8 fd f1 ff ff       	call   80106db9 <fetchint>
80107bbc:	83 c4 10             	add    $0x10,%esp
80107bbf:	85 c0                	test   %eax,%eax
80107bc1:	79 07                	jns    80107bca <sys_exec+0xa0>
      return -1;
80107bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bc8:	eb 66                	jmp    80107c30 <sys_exec+0x106>
    if(uarg == 0){
80107bca:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107bd0:	85 c0                	test   %eax,%eax
80107bd2:	75 27                	jne    80107bfb <sys_exec+0xd1>
      argv[i] = 0;
80107bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd7:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107bde:	00 00 00 00 
      break;
80107be2:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107be6:	83 ec 08             	sub    $0x8,%esp
80107be9:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107bef:	52                   	push   %edx
80107bf0:	50                   	push   %eax
80107bf1:	e8 21 90 ff ff       	call   80100c17 <exec>
80107bf6:	83 c4 10             	add    $0x10,%esp
80107bf9:	eb 35                	jmp    80107c30 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107bfb:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c04:	c1 e2 02             	shl    $0x2,%edx
80107c07:	01 c2                	add    %eax,%edx
80107c09:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107c0f:	83 ec 08             	sub    $0x8,%esp
80107c12:	52                   	push   %edx
80107c13:	50                   	push   %eax
80107c14:	e8 da f1 ff ff       	call   80106df3 <fetchstr>
80107c19:	83 c4 10             	add    $0x10,%esp
80107c1c:	85 c0                	test   %eax,%eax
80107c1e:	79 07                	jns    80107c27 <sys_exec+0xfd>
      return -1;
80107c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c25:	eb 09                	jmp    80107c30 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107c27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107c2b:	e9 5a ff ff ff       	jmp    80107b8a <sys_exec+0x60>
  return exec(path, argv);
}
80107c30:	c9                   	leave  
80107c31:	c3                   	ret    

80107c32 <sys_pipe>:

int
sys_pipe(void)
{
80107c32:	55                   	push   %ebp
80107c33:	89 e5                	mov    %esp,%ebp
80107c35:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107c38:	83 ec 04             	sub    $0x4,%esp
80107c3b:	6a 08                	push   $0x8
80107c3d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107c40:	50                   	push   %eax
80107c41:	6a 00                	push   $0x0
80107c43:	e8 35 f2 ff ff       	call   80106e7d <argptr>
80107c48:	83 c4 10             	add    $0x10,%esp
80107c4b:	85 c0                	test   %eax,%eax
80107c4d:	79 0a                	jns    80107c59 <sys_pipe+0x27>
    return -1;
80107c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c54:	e9 ae 00 00 00       	jmp    80107d07 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80107c59:	83 ec 08             	sub    $0x8,%esp
80107c5c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107c5f:	50                   	push   %eax
80107c60:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107c63:	50                   	push   %eax
80107c64:	e8 e2 c8 ff ff       	call   8010454b <pipealloc>
80107c69:	83 c4 10             	add    $0x10,%esp
80107c6c:	85 c0                	test   %eax,%eax
80107c6e:	79 0a                	jns    80107c7a <sys_pipe+0x48>
    return -1;
80107c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c75:	e9 8d 00 00 00       	jmp    80107d07 <sys_pipe+0xd5>
  fd0 = -1;
80107c7a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107c81:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c84:	83 ec 0c             	sub    $0xc,%esp
80107c87:	50                   	push   %eax
80107c88:	e8 7f f3 ff ff       	call   8010700c <fdalloc>
80107c8d:	83 c4 10             	add    $0x10,%esp
80107c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c97:	78 18                	js     80107cb1 <sys_pipe+0x7f>
80107c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c9c:	83 ec 0c             	sub    $0xc,%esp
80107c9f:	50                   	push   %eax
80107ca0:	e8 67 f3 ff ff       	call   8010700c <fdalloc>
80107ca5:	83 c4 10             	add    $0x10,%esp
80107ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107caf:	79 3e                	jns    80107cef <sys_pipe+0xbd>
    if(fd0 >= 0)
80107cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107cb5:	78 13                	js     80107cca <sys_pipe+0x98>
      proc->ofile[fd0] = 0;
80107cb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cc0:	83 c2 0c             	add    $0xc,%edx
80107cc3:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
    fileclose(rf);
80107cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ccd:	83 ec 0c             	sub    $0xc,%esp
80107cd0:	50                   	push   %eax
80107cd1:	e8 bf 94 ff ff       	call   80101195 <fileclose>
80107cd6:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cdc:	83 ec 0c             	sub    $0xc,%esp
80107cdf:	50                   	push   %eax
80107ce0:	e8 b0 94 ff ff       	call   80101195 <fileclose>
80107ce5:	83 c4 10             	add    $0x10,%esp
    return -1;
80107ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ced:	eb 18                	jmp    80107d07 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80107cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cf5:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cfa:	8d 50 04             	lea    0x4(%eax),%edx
80107cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d00:	89 02                	mov    %eax,(%edx)
  return 0;
80107d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d07:	c9                   	leave  
80107d08:	c3                   	ret    

80107d09 <sys_chmod>:


#ifdef CS333_P5
int
sys_chmod(void)
{
80107d09:	55                   	push   %ebp
80107d0a:	89 e5                	mov    %esp,%ebp
80107d0c:	83 ec 18             	sub    $0x18,%esp
        int mode;
        char * pathname;
	struct inode * ip;
	//int digit = 0;
        if (argstr(0,&pathname) < 0)
80107d0f:	83 ec 08             	sub    $0x8,%esp
80107d12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107d15:	50                   	push   %eax
80107d16:	6a 00                	push   $0x0
80107d18:	e8 bd f1 ff ff       	call   80106eda <argstr>
80107d1d:	83 c4 10             	add    $0x10,%esp
80107d20:	85 c0                	test   %eax,%eax
80107d22:	79 0a                	jns    80107d2e <sys_chmod+0x25>
                return -1;
80107d24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d29:	e9 9f 00 00 00       	jmp    80107dcd <sys_chmod+0xc4>
        if(argint(1,&mode)< 0)
80107d2e:	83 ec 08             	sub    $0x8,%esp
80107d31:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d34:	50                   	push   %eax
80107d35:	6a 01                	push   $0x1
80107d37:	e8 19 f1 ff ff       	call   80106e55 <argint>
80107d3c:	83 c4 10             	add    $0x10,%esp
80107d3f:	85 c0                	test   %eax,%eax
80107d41:	79 0a                	jns    80107d4d <sys_chmod+0x44>
                return -1;
80107d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d48:	e9 80 00 00 00       	jmp    80107dcd <sys_chmod+0xc4>
	if(mode < 0 || mode > 01777)
80107d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d50:	85 c0                	test   %eax,%eax
80107d52:	78 0a                	js     80107d5e <sys_chmod+0x55>
80107d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d57:	3d ff 03 00 00       	cmp    $0x3ff,%eax
80107d5c:	7e 07                	jle    80107d65 <sys_chmod+0x5c>
		return -1;
80107d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d63:	eb 68                	jmp    80107dcd <sys_chmod+0xc4>
	begin_op();
80107d65:	e8 ed bc ff ff       	call   80103a57 <begin_op>
        if((ip = namei(pathname)) == 0){
80107d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d6d:	83 ec 0c             	sub    $0xc,%esp
80107d70:	50                   	push   %eax
80107d71:	e8 bc ac ff ff       	call   80102a32 <namei>
80107d76:	83 c4 10             	add    $0x10,%esp
80107d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d80:	75 0c                	jne    80107d8e <sys_chmod+0x85>
                end_op();
80107d82:	e8 5c bd ff ff       	call   80103ae3 <end_op>
                return -1;
80107d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d8c:	eb 3f                	jmp    80107dcd <sys_chmod+0xc4>
        }
        ilock(ip);
80107d8e:	83 ec 0c             	sub    $0xc,%esp
80107d91:	ff 75 f4             	pushl  -0xc(%ebp)
80107d94:	e8 39 9f ff ff       	call   80101cd2 <ilock>
80107d99:	83 c4 10             	add    $0x10,%esp
	ip->mode.asInt = mode;
80107d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d9f:	89 c2                	mov    %eax,%edx
80107da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da4:	89 50 14             	mov    %edx,0x14(%eax)
        iupdate(ip);
80107da7:	83 ec 0c             	sub    $0xc,%esp
80107daa:	ff 75 f4             	pushl  -0xc(%ebp)
80107dad:	e8 c4 9b ff ff       	call   80101976 <iupdate>
80107db2:	83 c4 10             	add    $0x10,%esp
        iunlock(ip);
80107db5:	83 ec 0c             	sub    $0xc,%esp
80107db8:	ff 75 f4             	pushl  -0xc(%ebp)
80107dbb:	e8 e6 a1 ff ff       	call   80101fa6 <iunlock>
80107dc0:	83 c4 10             	add    $0x10,%esp
        end_op();
80107dc3:	e8 1b bd ff ff       	call   80103ae3 <end_op>

        return 0;
80107dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107dcd:	c9                   	leave  
80107dce:	c3                   	ret    

80107dcf <sys_chown>:
int
sys_chown(void)
{
80107dcf:	55                   	push   %ebp
80107dd0:	89 e5                	mov    %esp,%ebp
80107dd2:	83 ec 18             	sub    $0x18,%esp
        int owner;
        char * pathname;
        struct inode * ip;
        if (argstr(0,&pathname) < 0)
80107dd5:	83 ec 08             	sub    $0x8,%esp
80107dd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107ddb:	50                   	push   %eax
80107ddc:	6a 00                	push   $0x0
80107dde:	e8 f7 f0 ff ff       	call   80106eda <argstr>
80107de3:	83 c4 10             	add    $0x10,%esp
80107de6:	85 c0                	test   %eax,%eax
80107de8:	79 0a                	jns    80107df4 <sys_chown+0x25>
                return -1;
80107dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107def:	e9 93 00 00 00       	jmp    80107e87 <sys_chown+0xb8>
        if(argint(1,&owner)< 0)
80107df4:	83 ec 08             	sub    $0x8,%esp
80107df7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107dfa:	50                   	push   %eax
80107dfb:	6a 01                	push   $0x1
80107dfd:	e8 53 f0 ff ff       	call   80106e55 <argint>
80107e02:	83 c4 10             	add    $0x10,%esp
80107e05:	85 c0                	test   %eax,%eax
80107e07:	79 07                	jns    80107e10 <sys_chown+0x41>
                return -1;
80107e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e0e:	eb 77                	jmp    80107e87 <sys_chown+0xb8>
	if(owner < 0)
80107e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e13:	85 c0                	test   %eax,%eax
80107e15:	79 07                	jns    80107e1e <sys_chown+0x4f>
		return -1;
80107e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e1c:	eb 69                	jmp    80107e87 <sys_chown+0xb8>
        begin_op();
80107e1e:	e8 34 bc ff ff       	call   80103a57 <begin_op>
        if((ip = namei(pathname)) == 0){
80107e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e26:	83 ec 0c             	sub    $0xc,%esp
80107e29:	50                   	push   %eax
80107e2a:	e8 03 ac ff ff       	call   80102a32 <namei>
80107e2f:	83 c4 10             	add    $0x10,%esp
80107e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107e39:	75 0c                	jne    80107e47 <sys_chown+0x78>
                end_op();
80107e3b:	e8 a3 bc ff ff       	call   80103ae3 <end_op>
                return -1;
80107e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e45:	eb 40                	jmp    80107e87 <sys_chown+0xb8>
        }
        ilock(ip);
80107e47:	83 ec 0c             	sub    $0xc,%esp
80107e4a:	ff 75 f4             	pushl  -0xc(%ebp)
80107e4d:	e8 80 9e ff ff       	call   80101cd2 <ilock>
80107e52:	83 c4 10             	add    $0x10,%esp
        ip->uid = owner;
80107e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e58:	89 c2                	mov    %eax,%edx
80107e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5d:	66 89 50 10          	mov    %dx,0x10(%eax)
        iupdate(ip);
80107e61:	83 ec 0c             	sub    $0xc,%esp
80107e64:	ff 75 f4             	pushl  -0xc(%ebp)
80107e67:	e8 0a 9b ff ff       	call   80101976 <iupdate>
80107e6c:	83 c4 10             	add    $0x10,%esp
        iunlock(ip);
80107e6f:	83 ec 0c             	sub    $0xc,%esp
80107e72:	ff 75 f4             	pushl  -0xc(%ebp)
80107e75:	e8 2c a1 ff ff       	call   80101fa6 <iunlock>
80107e7a:	83 c4 10             	add    $0x10,%esp
        end_op();
80107e7d:	e8 61 bc ff ff       	call   80103ae3 <end_op>

        return 0;
80107e82:	b8 00 00 00 00       	mov    $0x0,%eax

}
80107e87:	c9                   	leave  
80107e88:	c3                   	ret    

80107e89 <sys_chgrp>:
int
sys_chgrp(void)
{
80107e89:	55                   	push   %ebp
80107e8a:	89 e5                	mov    %esp,%ebp
80107e8c:	83 ec 18             	sub    $0x18,%esp
        int owner;
        char * pathname;
	struct inode * ip;
        if (argstr(0,&pathname) < 0)
80107e8f:	83 ec 08             	sub    $0x8,%esp
80107e92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107e95:	50                   	push   %eax
80107e96:	6a 00                	push   $0x0
80107e98:	e8 3d f0 ff ff       	call   80106eda <argstr>
80107e9d:	83 c4 10             	add    $0x10,%esp
80107ea0:	85 c0                	test   %eax,%eax
80107ea2:	79 0a                	jns    80107eae <sys_chgrp+0x25>
                return -1;
80107ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ea9:	e9 93 00 00 00       	jmp    80107f41 <sys_chgrp+0xb8>
        if(argint(1,&owner)< 0)
80107eae:	83 ec 08             	sub    $0x8,%esp
80107eb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107eb4:	50                   	push   %eax
80107eb5:	6a 01                	push   $0x1
80107eb7:	e8 99 ef ff ff       	call   80106e55 <argint>
80107ebc:	83 c4 10             	add    $0x10,%esp
80107ebf:	85 c0                	test   %eax,%eax
80107ec1:	79 07                	jns    80107eca <sys_chgrp+0x41>
                return -1;
80107ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ec8:	eb 77                	jmp    80107f41 <sys_chgrp+0xb8>
	if(owner < 0)
80107eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ecd:	85 c0                	test   %eax,%eax
80107ecf:	79 07                	jns    80107ed8 <sys_chgrp+0x4f>
		return -1;
80107ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ed6:	eb 69                	jmp    80107f41 <sys_chgrp+0xb8>
	begin_op();
80107ed8:	e8 7a bb ff ff       	call   80103a57 <begin_op>
	if((ip = namei(pathname)) == 0){
80107edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ee0:	83 ec 0c             	sub    $0xc,%esp
80107ee3:	50                   	push   %eax
80107ee4:	e8 49 ab ff ff       	call   80102a32 <namei>
80107ee9:	83 c4 10             	add    $0x10,%esp
80107eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107eef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ef3:	75 0c                	jne    80107f01 <sys_chgrp+0x78>
		end_op();
80107ef5:	e8 e9 bb ff ff       	call   80103ae3 <end_op>
		return -1;
80107efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eff:	eb 40                	jmp    80107f41 <sys_chgrp+0xb8>
	}
	ilock(ip);
80107f01:	83 ec 0c             	sub    $0xc,%esp
80107f04:	ff 75 f4             	pushl  -0xc(%ebp)
80107f07:	e8 c6 9d ff ff       	call   80101cd2 <ilock>
80107f0c:	83 c4 10             	add    $0x10,%esp
	ip->gid = owner;
80107f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f12:	89 c2                	mov    %eax,%edx
80107f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f17:	66 89 50 12          	mov    %dx,0x12(%eax)
	iupdate(ip);
80107f1b:	83 ec 0c             	sub    $0xc,%esp
80107f1e:	ff 75 f4             	pushl  -0xc(%ebp)
80107f21:	e8 50 9a ff ff       	call   80101976 <iupdate>
80107f26:	83 c4 10             	add    $0x10,%esp
	iunlock(ip);
80107f29:	83 ec 0c             	sub    $0xc,%esp
80107f2c:	ff 75 f4             	pushl  -0xc(%ebp)
80107f2f:	e8 72 a0 ff ff       	call   80101fa6 <iunlock>
80107f34:	83 c4 10             	add    $0x10,%esp
	end_op();
80107f37:	e8 a7 bb ff ff       	call   80103ae3 <end_op>
	
        return 0;
80107f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f41:	c9                   	leave  
80107f42:	c3                   	ret    

80107f43 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107f43:	55                   	push   %ebp
80107f44:	89 e5                	mov    %esp,%ebp
80107f46:	83 ec 08             	sub    $0x8,%esp
80107f49:	8b 55 08             	mov    0x8(%ebp),%edx
80107f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f4f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107f53:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f57:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107f5b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f5f:	66 ef                	out    %ax,(%dx)
}
80107f61:	90                   	nop
80107f62:	c9                   	leave  
80107f63:	c3                   	ret    

80107f64 <sys_fork>:
#include "mmu.h"
#include "proc.h"
#include "uproc.h"
int
sys_fork(void)
{
80107f64:	55                   	push   %ebp
80107f65:	89 e5                	mov    %esp,%ebp
80107f67:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107f6a:	e8 21 d2 ff ff       	call   80105190 <fork>
}
80107f6f:	c9                   	leave  
80107f70:	c3                   	ret    

80107f71 <sys_exit>:

int
sys_exit(void)
{
80107f71:	55                   	push   %ebp
80107f72:	89 e5                	mov    %esp,%ebp
80107f74:	83 ec 08             	sub    $0x8,%esp
  exit();
80107f77:	e8 9c d4 ff ff       	call   80105418 <exit>
  return 0;  // not reached
80107f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f81:	c9                   	leave  
80107f82:	c3                   	ret    

80107f83 <sys_wait>:

int
sys_wait(void)
{
80107f83:	55                   	push   %ebp
80107f84:	89 e5                	mov    %esp,%ebp
80107f86:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107f89:	e8 83 d6 ff ff       	call   80105611 <wait>
}
80107f8e:	c9                   	leave  
80107f8f:	c3                   	ret    

80107f90 <sys_kill>:

int
sys_kill(void)
{
80107f90:	55                   	push   %ebp
80107f91:	89 e5                	mov    %esp,%ebp
80107f93:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107f96:	83 ec 08             	sub    $0x8,%esp
80107f99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f9c:	50                   	push   %eax
80107f9d:	6a 00                	push   $0x0
80107f9f:	e8 b1 ee ff ff       	call   80106e55 <argint>
80107fa4:	83 c4 10             	add    $0x10,%esp
80107fa7:	85 c0                	test   %eax,%eax
80107fa9:	79 07                	jns    80107fb2 <sys_kill+0x22>
    return -1;
80107fab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fb0:	eb 0f                	jmp    80107fc1 <sys_kill+0x31>
  return kill(pid);
80107fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb5:	83 ec 0c             	sub    $0xc,%esp
80107fb8:	50                   	push   %eax
80107fb9:	e8 7b de ff ff       	call   80105e39 <kill>
80107fbe:	83 c4 10             	add    $0x10,%esp
}
80107fc1:	c9                   	leave  
80107fc2:	c3                   	ret    

80107fc3 <sys_getpid>:

int
sys_getpid(void)
{
80107fc3:	55                   	push   %ebp
80107fc4:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107fc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fcc:	8b 40 10             	mov    0x10(%eax),%eax
}
80107fcf:	5d                   	pop    %ebp
80107fd0:	c3                   	ret    

80107fd1 <sys_sbrk>:

int
sys_sbrk(void)
{
80107fd1:	55                   	push   %ebp
80107fd2:	89 e5                	mov    %esp,%ebp
80107fd4:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107fd7:	83 ec 08             	sub    $0x8,%esp
80107fda:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107fdd:	50                   	push   %eax
80107fde:	6a 00                	push   $0x0
80107fe0:	e8 70 ee ff ff       	call   80106e55 <argint>
80107fe5:	83 c4 10             	add    $0x10,%esp
80107fe8:	85 c0                	test   %eax,%eax
80107fea:	79 07                	jns    80107ff3 <sys_sbrk+0x22>
    return -1;
80107fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ff1:	eb 28                	jmp    8010801b <sys_sbrk+0x4a>
  addr = proc->sz;
80107ff3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ff9:	8b 00                	mov    (%eax),%eax
80107ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108001:	83 ec 0c             	sub    $0xc,%esp
80108004:	50                   	push   %eax
80108005:	e8 e3 d0 ff ff       	call   801050ed <growproc>
8010800a:	83 c4 10             	add    $0x10,%esp
8010800d:	85 c0                	test   %eax,%eax
8010800f:	79 07                	jns    80108018 <sys_sbrk+0x47>
    return -1;
80108011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108016:	eb 03                	jmp    8010801b <sys_sbrk+0x4a>
  return addr;
80108018:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010801b:	c9                   	leave  
8010801c:	c3                   	ret    

8010801d <sys_sleep>:

int
sys_sleep(void)
{
8010801d:	55                   	push   %ebp
8010801e:	89 e5                	mov    %esp,%ebp
80108020:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80108023:	83 ec 08             	sub    $0x8,%esp
80108026:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108029:	50                   	push   %eax
8010802a:	6a 00                	push   $0x0
8010802c:	e8 24 ee ff ff       	call   80106e55 <argint>
80108031:	83 c4 10             	add    $0x10,%esp
80108034:	85 c0                	test   %eax,%eax
80108036:	79 07                	jns    8010803f <sys_sleep+0x22>
    return -1;
80108038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010803d:	eb 44                	jmp    80108083 <sys_sleep+0x66>
  ticks0 = ticks;
8010803f:	a1 00 79 11 80       	mov    0x80117900,%eax
80108044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80108047:	eb 26                	jmp    8010806f <sys_sleep+0x52>
    if(proc->killed){
80108049:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010804f:	8b 40 2c             	mov    0x2c(%eax),%eax
80108052:	85 c0                	test   %eax,%eax
80108054:	74 07                	je     8010805d <sys_sleep+0x40>
      return -1;
80108056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010805b:	eb 26                	jmp    80108083 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
8010805d:	83 ec 08             	sub    $0x8,%esp
80108060:	6a 00                	push   $0x0
80108062:	68 00 79 11 80       	push   $0x80117900
80108067:	e8 be db ff ff       	call   80105c2a <sleep>
8010806c:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010806f:	a1 00 79 11 80       	mov    0x80117900,%eax
80108074:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108077:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010807a:	39 d0                	cmp    %edx,%eax
8010807c:	72 cb                	jb     80108049 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
8010807e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108083:	c9                   	leave  
80108084:	c3                   	ret    

80108085 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80108085:	55                   	push   %ebp
80108086:	89 e5                	mov    %esp,%ebp
80108088:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
8010808b:	a1 00 79 11 80       	mov    0x80117900,%eax
80108090:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80108093:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108096:	c9                   	leave  
80108097:	c3                   	ret    

80108098 <sys_halt>:

//Turn of the computer
int 
sys_halt(void){
80108098:	55                   	push   %ebp
80108099:	89 e5                	mov    %esp,%ebp
8010809b:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
8010809e:	83 ec 0c             	sub    $0xc,%esp
801080a1:	68 45 a8 10 80       	push   $0x8010a845
801080a6:	e8 1b 83 ff ff       	call   801003c6 <cprintf>
801080ab:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
801080ae:	83 ec 08             	sub    $0x8,%esp
801080b1:	68 00 20 00 00       	push   $0x2000
801080b6:	68 04 06 00 00       	push   $0x604
801080bb:	e8 83 fe ff ff       	call   80107f43 <outw>
801080c0:	83 c4 10             	add    $0x10,%esp
  return 0;
801080c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080c8:	c9                   	leave  
801080c9:	c3                   	ret    

801080ca <sys_date>:

int
sys_date(void)
{
801080ca:	55                   	push   %ebp
801080cb:	89 e5                	mov    %esp,%ebp
801080cd:	83 ec 18             	sub    $0x18,%esp
	struct rtcdate *d;

	if(argptr(0,(void*)&d,sizeof(*d)) < 0)
801080d0:	83 ec 04             	sub    $0x4,%esp
801080d3:	6a 18                	push   $0x18
801080d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801080d8:	50                   	push   %eax
801080d9:	6a 00                	push   $0x0
801080db:	e8 9d ed ff ff       	call   80106e7d <argptr>
801080e0:	83 c4 10             	add    $0x10,%esp
801080e3:	85 c0                	test   %eax,%eax
801080e5:	79 07                	jns    801080ee <sys_date+0x24>
		return -1;
801080e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080ec:	eb 14                	jmp    80108102 <sys_date+0x38>
	cmostime(d);
801080ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f1:	83 ec 0c             	sub    $0xc,%esp
801080f4:	50                   	push   %eax
801080f5:	e8 d8 b5 ff ff       	call   801036d2 <cmostime>
801080fa:	83 c4 10             	add    $0x10,%esp
	return 0;
801080fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108102:	c9                   	leave  
80108103:	c3                   	ret    

80108104 <sys_getuid>:

int
sys_getuid(void)//p2
{
80108104:	55                   	push   %ebp
80108105:	89 e5                	mov    %esp,%ebp
	return proc->uid;
80108107:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010810d:	8b 40 14             	mov    0x14(%eax),%eax
}
80108110:	5d                   	pop    %ebp
80108111:	c3                   	ret    

80108112 <sys_getgid>:

int
sys_getgid(void)//p2
{
80108112:	55                   	push   %ebp
80108113:	89 e5                	mov    %esp,%ebp
        return proc->gid;
80108115:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010811b:	8b 40 18             	mov    0x18(%eax),%eax
}
8010811e:	5d                   	pop    %ebp
8010811f:	c3                   	ret    

80108120 <sys_getppid>:

int
sys_getppid(void)//p2
{
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
	if(proc->parent->pid <=0 || proc->parent->pid > 100)
80108123:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108129:	8b 40 1c             	mov    0x1c(%eax),%eax
8010812c:	8b 40 10             	mov    0x10(%eax),%eax
8010812f:	85 c0                	test   %eax,%eax
80108131:	74 11                	je     80108144 <sys_getppid+0x24>
80108133:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108139:	8b 40 1c             	mov    0x1c(%eax),%eax
8010813c:	8b 40 10             	mov    0x10(%eax),%eax
8010813f:	83 f8 64             	cmp    $0x64,%eax
80108142:	76 0b                	jbe    8010814f <sys_getppid+0x2f>
		return proc->pid;
80108144:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010814a:	8b 40 10             	mov    0x10(%eax),%eax
8010814d:	eb 0c                	jmp    8010815b <sys_getppid+0x3b>
	else return proc->parent->pid;
8010814f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108155:	8b 40 1c             	mov    0x1c(%eax),%eax
80108158:	8b 40 10             	mov    0x10(%eax),%eax
}
8010815b:	5d                   	pop    %ebp
8010815c:	c3                   	ret    

8010815d <sys_setuid>:

int
sys_setuid(void)//p2
{
8010815d:	55                   	push   %ebp
8010815e:	89 e5                	mov    %esp,%ebp
80108160:	83 ec 18             	sub    $0x18,%esp
	int uid;
        if(argint(0, &uid) < 0)
80108163:	83 ec 08             	sub    $0x8,%esp
80108166:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108169:	50                   	push   %eax
8010816a:	6a 00                	push   $0x0
8010816c:	e8 e4 ec ff ff       	call   80106e55 <argint>
80108171:	83 c4 10             	add    $0x10,%esp
80108174:	85 c0                	test   %eax,%eax
80108176:	79 07                	jns    8010817f <sys_setuid+0x22>
                return -1;
80108178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010817d:	eb 27                	jmp    801081a6 <sys_setuid+0x49>
	uint posuid = uid;
8010817f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108182:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (posuid < 0 ||posuid > 32767)
80108185:	81 7d f4 ff 7f 00 00 	cmpl   $0x7fff,-0xc(%ebp)
8010818c:	76 07                	jbe    80108195 <sys_setuid+0x38>
		return -1;
8010818e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108193:	eb 11                	jmp    801081a6 <sys_setuid+0x49>
        else{
	proc->uid = posuid;
80108195:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010819b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010819e:	89 50 14             	mov    %edx,0x14(%eax)
        return 0;}
801081a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081a6:	c9                   	leave  
801081a7:	c3                   	ret    

801081a8 <sys_setgid>:

int
sys_setgid(void)//p2
{
801081a8:	55                   	push   %ebp
801081a9:	89 e5                	mov    %esp,%ebp
801081ab:	83 ec 18             	sub    $0x18,%esp
	int gid;
        if(argint(0, &gid) < 0)
801081ae:	83 ec 08             	sub    $0x8,%esp
801081b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801081b4:	50                   	push   %eax
801081b5:	6a 00                	push   $0x0
801081b7:	e8 99 ec ff ff       	call   80106e55 <argint>
801081bc:	83 c4 10             	add    $0x10,%esp
801081bf:	85 c0                	test   %eax,%eax
801081c1:	79 07                	jns    801081ca <sys_setgid+0x22>
                return -1;
801081c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081c8:	eb 27                	jmp    801081f1 <sys_setgid+0x49>
	uint posgid = gid;
801081ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (posgid < 0 ||posgid > 32767)
801081d0:	81 7d f4 ff 7f 00 00 	cmpl   $0x7fff,-0xc(%ebp)
801081d7:	76 07                	jbe    801081e0 <sys_setgid+0x38>
		return -1;
801081d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081de:	eb 11                	jmp    801081f1 <sys_setgid+0x49>
	else{
        proc->gid = posgid;
801081e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081e9:	89 50 18             	mov    %edx,0x18(%eax)
        return 0;}
801081ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081f1:	c9                   	leave  
801081f2:	c3                   	ret    

801081f3 <sys_getprocs>:

int
sys_getprocs(void)
{
801081f3:	55                   	push   %ebp
801081f4:	89 e5                	mov    %esp,%ebp
801081f6:	83 ec 18             	sub    $0x18,%esp
	int max;
	struct uproc *table;
   	if(argint(0,&max) < 0)
801081f9:	83 ec 08             	sub    $0x8,%esp
801081fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801081ff:	50                   	push   %eax
80108200:	6a 00                	push   $0x0
80108202:	e8 4e ec ff ff       	call   80106e55 <argint>
80108207:	83 c4 10             	add    $0x10,%esp
8010820a:	85 c0                	test   %eax,%eax
8010820c:	79 07                	jns    80108215 <sys_getprocs+0x22>
		return -1;
8010820e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108213:	eb 31                	jmp    80108246 <sys_getprocs+0x53>
	if(argptr(1,(void*)&table,sizeof(*table)) < 0)
80108215:	83 ec 04             	sub    $0x4,%esp
80108218:	6a 60                	push   $0x60
8010821a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010821d:	50                   	push   %eax
8010821e:	6a 01                	push   $0x1
80108220:	e8 58 ec ff ff       	call   80106e7d <argptr>
80108225:	83 c4 10             	add    $0x10,%esp
80108228:	85 c0                	test   %eax,%eax
8010822a:	79 07                	jns    80108233 <sys_getprocs+0x40>
		return -1;
8010822c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108231:	eb 13                	jmp    80108246 <sys_getprocs+0x53>
	return getprocs(max,table);
80108233:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108239:	83 ec 08             	sub    $0x8,%esp
8010823c:	52                   	push   %edx
8010823d:	50                   	push   %eax
8010823e:	e8 d1 df ff ff       	call   80106214 <getprocs>
80108243:	83 c4 10             	add    $0x10,%esp
}
80108246:	c9                   	leave  
80108247:	c3                   	ret    

80108248 <sys_looper>:

int
sys_looper(void)
{
80108248:	55                   	push   %ebp
80108249:	89 e5                	mov    %esp,%ebp
	return 1;
8010824b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80108250:	5d                   	pop    %ebp
80108251:	c3                   	ret    

80108252 <sys_setpriority>:

int
sys_setpriority(void)
{
80108252:	55                   	push   %ebp
80108253:	89 e5                	mov    %esp,%ebp
80108255:	83 ec 18             	sub    $0x18,%esp
	int pid;
	int priority;
	if(argint(0,&pid) < 0)
80108258:	83 ec 08             	sub    $0x8,%esp
8010825b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010825e:	50                   	push   %eax
8010825f:	6a 00                	push   $0x0
80108261:	e8 ef eb ff ff       	call   80106e55 <argint>
80108266:	83 c4 10             	add    $0x10,%esp
80108269:	85 c0                	test   %eax,%eax
8010826b:	79 07                	jns    80108274 <sys_setpriority+0x22>
		return -1;
8010826d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108272:	eb 2f                	jmp    801082a3 <sys_setpriority+0x51>
	if(argint(1,&priority)< 0)
80108274:	83 ec 08             	sub    $0x8,%esp
80108277:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010827a:	50                   	push   %eax
8010827b:	6a 01                	push   $0x1
8010827d:	e8 d3 eb ff ff       	call   80106e55 <argint>
80108282:	83 c4 10             	add    $0x10,%esp
80108285:	85 c0                	test   %eax,%eax
80108287:	79 07                	jns    80108290 <sys_setpriority+0x3e>
		return -1;
80108289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010828e:	eb 13                	jmp    801082a3 <sys_setpriority+0x51>
	return setpriority(pid,priority);
80108290:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108296:	83 ec 08             	sub    $0x8,%esp
80108299:	52                   	push   %edx
8010829a:	50                   	push   %eax
8010829b:	e8 dc e3 ff ff       	call   8010667c <setpriority>
801082a0:	83 c4 10             	add    $0x10,%esp
}
801082a3:	c9                   	leave  
801082a4:	c3                   	ret    

801082a5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801082a5:	55                   	push   %ebp
801082a6:	89 e5                	mov    %esp,%ebp
801082a8:	83 ec 08             	sub    $0x8,%esp
801082ab:	8b 55 08             	mov    0x8(%ebp),%edx
801082ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801082b1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801082b5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801082b8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801082bc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801082c0:	ee                   	out    %al,(%dx)
}
801082c1:	90                   	nop
801082c2:	c9                   	leave  
801082c3:	c3                   	ret    

801082c4 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801082c4:	55                   	push   %ebp
801082c5:	89 e5                	mov    %esp,%ebp
801082c7:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801082ca:	6a 34                	push   $0x34
801082cc:	6a 43                	push   $0x43
801082ce:	e8 d2 ff ff ff       	call   801082a5 <outb>
801082d3:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801082d6:	68 9c 00 00 00       	push   $0x9c
801082db:	6a 40                	push   $0x40
801082dd:	e8 c3 ff ff ff       	call   801082a5 <outb>
801082e2:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801082e5:	6a 2e                	push   $0x2e
801082e7:	6a 40                	push   $0x40
801082e9:	e8 b7 ff ff ff       	call   801082a5 <outb>
801082ee:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801082f1:	83 ec 0c             	sub    $0xc,%esp
801082f4:	6a 00                	push   $0x0
801082f6:	e8 3a c1 ff ff       	call   80104435 <picenable>
801082fb:	83 c4 10             	add    $0x10,%esp
}
801082fe:	90                   	nop
801082ff:	c9                   	leave  
80108300:	c3                   	ret    

80108301 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80108301:	1e                   	push   %ds
  pushl %es
80108302:	06                   	push   %es
  pushl %fs
80108303:	0f a0                	push   %fs
  pushl %gs
80108305:	0f a8                	push   %gs
  pushal
80108307:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80108308:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010830c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010830e:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80108310:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80108314:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80108316:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80108318:	54                   	push   %esp
  call trap
80108319:	e8 ce 01 00 00       	call   801084ec <trap>
  addl $4, %esp
8010831e:	83 c4 04             	add    $0x4,%esp

80108321 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80108321:	61                   	popa   
  popl %gs
80108322:	0f a9                	pop    %gs
  popl %fs
80108324:	0f a1                	pop    %fs
  popl %es
80108326:	07                   	pop    %es
  popl %ds
80108327:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80108328:	83 c4 08             	add    $0x8,%esp
  iret
8010832b:	cf                   	iret   

8010832c <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
8010832c:	55                   	push   %ebp
8010832d:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
8010832f:	8b 45 08             	mov    0x8(%ebp),%eax
80108332:	f0 ff 00             	lock incl (%eax)
}
80108335:	90                   	nop
80108336:	5d                   	pop    %ebp
80108337:	c3                   	ret    

80108338 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80108338:	55                   	push   %ebp
80108339:	89 e5                	mov    %esp,%ebp
8010833b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010833e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108341:	83 e8 01             	sub    $0x1,%eax
80108344:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108348:	8b 45 08             	mov    0x8(%ebp),%eax
8010834b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010834f:	8b 45 08             	mov    0x8(%ebp),%eax
80108352:	c1 e8 10             	shr    $0x10,%eax
80108355:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80108359:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010835c:	0f 01 18             	lidtl  (%eax)
}
8010835f:	90                   	nop
80108360:	c9                   	leave  
80108361:	c3                   	ret    

80108362 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80108362:	55                   	push   %ebp
80108363:	89 e5                	mov    %esp,%ebp
80108365:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108368:	0f 20 d0             	mov    %cr2,%eax
8010836b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010836e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108371:	c9                   	leave  
80108372:	c3                   	ret    

80108373 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80108373:	55                   	push   %ebp
80108374:	89 e5                	mov    %esp,%ebp
80108376:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80108379:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108380:	e9 c3 00 00 00       	jmp    80108448 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80108385:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108388:	8b 04 85 cc d0 10 80 	mov    -0x7fef2f34(,%eax,4),%eax
8010838f:	89 c2                	mov    %eax,%edx
80108391:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108394:	66 89 14 c5 00 71 11 	mov    %dx,-0x7fee8f00(,%eax,8)
8010839b:	80 
8010839c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010839f:	66 c7 04 c5 02 71 11 	movw   $0x8,-0x7fee8efe(,%eax,8)
801083a6:	80 08 00 
801083a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083ac:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
801083b3:	80 
801083b4:	83 e2 e0             	and    $0xffffffe0,%edx
801083b7:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
801083be:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083c1:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
801083c8:	80 
801083c9:	83 e2 1f             	and    $0x1f,%edx
801083cc:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
801083d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083d6:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
801083dd:	80 
801083de:	83 e2 f0             	and    $0xfffffff0,%edx
801083e1:	83 ca 0e             	or     $0xe,%edx
801083e4:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
801083eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083ee:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
801083f5:	80 
801083f6:	83 e2 ef             	and    $0xffffffef,%edx
801083f9:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80108400:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108403:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
8010840a:	80 
8010840b:	83 e2 9f             	and    $0xffffff9f,%edx
8010840e:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80108415:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108418:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
8010841f:	80 
80108420:	83 ca 80             	or     $0xffffff80,%edx
80108423:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
8010842a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010842d:	8b 04 85 cc d0 10 80 	mov    -0x7fef2f34(,%eax,4),%eax
80108434:	c1 e8 10             	shr    $0x10,%eax
80108437:	89 c2                	mov    %eax,%edx
80108439:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010843c:	66 89 14 c5 06 71 11 	mov    %dx,-0x7fee8efa(,%eax,8)
80108443:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80108444:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80108448:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
8010844f:	0f 8e 30 ff ff ff    	jle    80108385 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80108455:	a1 cc d1 10 80       	mov    0x8010d1cc,%eax
8010845a:	66 a3 00 73 11 80    	mov    %ax,0x80117300
80108460:	66 c7 05 02 73 11 80 	movw   $0x8,0x80117302
80108467:	08 00 
80108469:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80108470:	83 e0 e0             	and    $0xffffffe0,%eax
80108473:	a2 04 73 11 80       	mov    %al,0x80117304
80108478:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
8010847f:	83 e0 1f             	and    $0x1f,%eax
80108482:	a2 04 73 11 80       	mov    %al,0x80117304
80108487:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
8010848e:	83 c8 0f             	or     $0xf,%eax
80108491:	a2 05 73 11 80       	mov    %al,0x80117305
80108496:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
8010849d:	83 e0 ef             	and    $0xffffffef,%eax
801084a0:	a2 05 73 11 80       	mov    %al,0x80117305
801084a5:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
801084ac:	83 c8 60             	or     $0x60,%eax
801084af:	a2 05 73 11 80       	mov    %al,0x80117305
801084b4:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
801084bb:	83 c8 80             	or     $0xffffff80,%eax
801084be:	a2 05 73 11 80       	mov    %al,0x80117305
801084c3:	a1 cc d1 10 80       	mov    0x8010d1cc,%eax
801084c8:	c1 e8 10             	shr    $0x10,%eax
801084cb:	66 a3 06 73 11 80    	mov    %ax,0x80117306
  
}
801084d1:	90                   	nop
801084d2:	c9                   	leave  
801084d3:	c3                   	ret    

801084d4 <idtinit>:

void
idtinit(void)
{
801084d4:	55                   	push   %ebp
801084d5:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801084d7:	68 00 08 00 00       	push   $0x800
801084dc:	68 00 71 11 80       	push   $0x80117100
801084e1:	e8 52 fe ff ff       	call   80108338 <lidt>
801084e6:	83 c4 08             	add    $0x8,%esp
}
801084e9:	90                   	nop
801084ea:	c9                   	leave  
801084eb:	c3                   	ret    

801084ec <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801084ec:	55                   	push   %ebp
801084ed:	89 e5                	mov    %esp,%ebp
801084ef:	57                   	push   %edi
801084f0:	56                   	push   %esi
801084f1:	53                   	push   %ebx
801084f2:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801084f5:	8b 45 08             	mov    0x8(%ebp),%eax
801084f8:	8b 40 30             	mov    0x30(%eax),%eax
801084fb:	83 f8 40             	cmp    $0x40,%eax
801084fe:	75 3e                	jne    8010853e <trap+0x52>
    if(proc->killed)
80108500:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108506:	8b 40 2c             	mov    0x2c(%eax),%eax
80108509:	85 c0                	test   %eax,%eax
8010850b:	74 05                	je     80108512 <trap+0x26>
      exit();
8010850d:	e8 06 cf ff ff       	call   80105418 <exit>
    proc->tf = tf;
80108512:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108518:	8b 55 08             	mov    0x8(%ebp),%edx
8010851b:	89 50 20             	mov    %edx,0x20(%eax)
    syscall();
8010851e:	e8 e8 e9 ff ff       	call   80106f0b <syscall>
    if(proc->killed)
80108523:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108529:	8b 40 2c             	mov    0x2c(%eax),%eax
8010852c:	85 c0                	test   %eax,%eax
8010852e:	0f 84 fe 01 00 00    	je     80108732 <trap+0x246>
      exit();
80108534:	e8 df ce ff ff       	call   80105418 <exit>
    return;
80108539:	e9 f4 01 00 00       	jmp    80108732 <trap+0x246>
  }

  switch(tf->trapno){
8010853e:	8b 45 08             	mov    0x8(%ebp),%eax
80108541:	8b 40 30             	mov    0x30(%eax),%eax
80108544:	83 e8 20             	sub    $0x20,%eax
80108547:	83 f8 1f             	cmp    $0x1f,%eax
8010854a:	0f 87 a3 00 00 00    	ja     801085f3 <trap+0x107>
80108550:	8b 04 85 f8 a8 10 80 	mov    -0x7fef5708(,%eax,4),%eax
80108557:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80108559:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010855f:	0f b6 00             	movzbl (%eax),%eax
80108562:	84 c0                	test   %al,%al
80108564:	75 20                	jne    80108586 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80108566:	83 ec 0c             	sub    $0xc,%esp
80108569:	68 00 79 11 80       	push   $0x80117900
8010856e:	e8 b9 fd ff ff       	call   8010832c <atom_inc>
80108573:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80108576:	83 ec 0c             	sub    $0xc,%esp
80108579:	68 00 79 11 80       	push   $0x80117900
8010857e:	e8 7f d8 ff ff       	call   80105e02 <wakeup>
80108583:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80108586:	e8 a4 af ff ff       	call   8010352f <lapiceoi>
    break;
8010858b:	e9 1c 01 00 00       	jmp    801086ac <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108590:	e8 ad a7 ff ff       	call   80102d42 <ideintr>
    lapiceoi();
80108595:	e8 95 af ff ff       	call   8010352f <lapiceoi>
    break;
8010859a:	e9 0d 01 00 00       	jmp    801086ac <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010859f:	e8 8d ad ff ff       	call   80103331 <kbdintr>
    lapiceoi();
801085a4:	e8 86 af ff ff       	call   8010352f <lapiceoi>
    break;
801085a9:	e9 fe 00 00 00       	jmp    801086ac <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801085ae:	e8 60 03 00 00       	call   80108913 <uartintr>
    lapiceoi();
801085b3:	e8 77 af ff ff       	call   8010352f <lapiceoi>
    break;
801085b8:	e9 ef 00 00 00       	jmp    801086ac <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801085bd:	8b 45 08             	mov    0x8(%ebp),%eax
801085c0:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801085c3:	8b 45 08             	mov    0x8(%ebp),%eax
801085c6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801085ca:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801085cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085d3:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801085d6:	0f b6 c0             	movzbl %al,%eax
801085d9:	51                   	push   %ecx
801085da:	52                   	push   %edx
801085db:	50                   	push   %eax
801085dc:	68 58 a8 10 80       	push   $0x8010a858
801085e1:	e8 e0 7d ff ff       	call   801003c6 <cprintf>
801085e6:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801085e9:	e8 41 af ff ff       	call   8010352f <lapiceoi>
    break;
801085ee:	e9 b9 00 00 00       	jmp    801086ac <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801085f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085f9:	85 c0                	test   %eax,%eax
801085fb:	74 11                	je     8010860e <trap+0x122>
801085fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108600:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108604:	0f b7 c0             	movzwl %ax,%eax
80108607:	83 e0 03             	and    $0x3,%eax
8010860a:	85 c0                	test   %eax,%eax
8010860c:	75 40                	jne    8010864e <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010860e:	e8 4f fd ff ff       	call   80108362 <rcr2>
80108613:	89 c3                	mov    %eax,%ebx
80108615:	8b 45 08             	mov    0x8(%ebp),%eax
80108618:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010861b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108621:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108624:	0f b6 d0             	movzbl %al,%edx
80108627:	8b 45 08             	mov    0x8(%ebp),%eax
8010862a:	8b 40 30             	mov    0x30(%eax),%eax
8010862d:	83 ec 0c             	sub    $0xc,%esp
80108630:	53                   	push   %ebx
80108631:	51                   	push   %ecx
80108632:	52                   	push   %edx
80108633:	50                   	push   %eax
80108634:	68 7c a8 10 80       	push   $0x8010a87c
80108639:	e8 88 7d ff ff       	call   801003c6 <cprintf>
8010863e:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80108641:	83 ec 0c             	sub    $0xc,%esp
80108644:	68 ae a8 10 80       	push   $0x8010a8ae
80108649:	e8 18 7f ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010864e:	e8 0f fd ff ff       	call   80108362 <rcr2>
80108653:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108656:	8b 45 08             	mov    0x8(%ebp),%eax
80108659:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010865c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108662:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108665:	0f b6 d8             	movzbl %al,%ebx
80108668:	8b 45 08             	mov    0x8(%ebp),%eax
8010866b:	8b 48 34             	mov    0x34(%eax),%ecx
8010866e:	8b 45 08             	mov    0x8(%ebp),%eax
80108671:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108674:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010867a:	8d 78 74             	lea    0x74(%eax),%edi
8010867d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108683:	8b 40 10             	mov    0x10(%eax),%eax
80108686:	ff 75 e4             	pushl  -0x1c(%ebp)
80108689:	56                   	push   %esi
8010868a:	53                   	push   %ebx
8010868b:	51                   	push   %ecx
8010868c:	52                   	push   %edx
8010868d:	57                   	push   %edi
8010868e:	50                   	push   %eax
8010868f:	68 b4 a8 10 80       	push   $0x8010a8b4
80108694:	e8 2d 7d ff ff       	call   801003c6 <cprintf>
80108699:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010869c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086a2:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
801086a9:	eb 01                	jmp    801086ac <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801086ab:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801086ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086b2:	85 c0                	test   %eax,%eax
801086b4:	74 24                	je     801086da <trap+0x1ee>
801086b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086bc:	8b 40 2c             	mov    0x2c(%eax),%eax
801086bf:	85 c0                	test   %eax,%eax
801086c1:	74 17                	je     801086da <trap+0x1ee>
801086c3:	8b 45 08             	mov    0x8(%ebp),%eax
801086c6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801086ca:	0f b7 c0             	movzwl %ax,%eax
801086cd:	83 e0 03             	and    $0x3,%eax
801086d0:	83 f8 03             	cmp    $0x3,%eax
801086d3:	75 05                	jne    801086da <trap+0x1ee>
    exit();
801086d5:	e8 3e cd ff ff       	call   80105418 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801086da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086e0:	85 c0                	test   %eax,%eax
801086e2:	74 1e                	je     80108702 <trap+0x216>
801086e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086ea:	8b 40 0c             	mov    0xc(%eax),%eax
801086ed:	83 f8 04             	cmp    $0x4,%eax
801086f0:	75 10                	jne    80108702 <trap+0x216>
801086f2:	8b 45 08             	mov    0x8(%ebp),%eax
801086f5:	8b 40 30             	mov    0x30(%eax),%eax
801086f8:	83 f8 20             	cmp    $0x20,%eax
801086fb:	75 05                	jne    80108702 <trap+0x216>
    yield();
801086fd:	e8 d5 d3 ff ff       	call   80105ad7 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108702:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108708:	85 c0                	test   %eax,%eax
8010870a:	74 27                	je     80108733 <trap+0x247>
8010870c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108712:	8b 40 2c             	mov    0x2c(%eax),%eax
80108715:	85 c0                	test   %eax,%eax
80108717:	74 1a                	je     80108733 <trap+0x247>
80108719:	8b 45 08             	mov    0x8(%ebp),%eax
8010871c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108720:	0f b7 c0             	movzwl %ax,%eax
80108723:	83 e0 03             	and    $0x3,%eax
80108726:	83 f8 03             	cmp    $0x3,%eax
80108729:	75 08                	jne    80108733 <trap+0x247>
    exit();
8010872b:	e8 e8 cc ff ff       	call   80105418 <exit>
80108730:	eb 01                	jmp    80108733 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80108732:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80108733:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108736:	5b                   	pop    %ebx
80108737:	5e                   	pop    %esi
80108738:	5f                   	pop    %edi
80108739:	5d                   	pop    %ebp
8010873a:	c3                   	ret    

8010873b <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010873b:	55                   	push   %ebp
8010873c:	89 e5                	mov    %esp,%ebp
8010873e:	83 ec 14             	sub    $0x14,%esp
80108741:	8b 45 08             	mov    0x8(%ebp),%eax
80108744:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108748:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010874c:	89 c2                	mov    %eax,%edx
8010874e:	ec                   	in     (%dx),%al
8010874f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108752:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80108756:	c9                   	leave  
80108757:	c3                   	ret    

80108758 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108758:	55                   	push   %ebp
80108759:	89 e5                	mov    %esp,%ebp
8010875b:	83 ec 08             	sub    $0x8,%esp
8010875e:	8b 55 08             	mov    0x8(%ebp),%edx
80108761:	8b 45 0c             	mov    0xc(%ebp),%eax
80108764:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108768:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010876b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010876f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108773:	ee                   	out    %al,(%dx)
}
80108774:	90                   	nop
80108775:	c9                   	leave  
80108776:	c3                   	ret    

80108777 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80108777:	55                   	push   %ebp
80108778:	89 e5                	mov    %esp,%ebp
8010877a:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010877d:	6a 00                	push   $0x0
8010877f:	68 fa 03 00 00       	push   $0x3fa
80108784:	e8 cf ff ff ff       	call   80108758 <outb>
80108789:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010878c:	68 80 00 00 00       	push   $0x80
80108791:	68 fb 03 00 00       	push   $0x3fb
80108796:	e8 bd ff ff ff       	call   80108758 <outb>
8010879b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010879e:	6a 0c                	push   $0xc
801087a0:	68 f8 03 00 00       	push   $0x3f8
801087a5:	e8 ae ff ff ff       	call   80108758 <outb>
801087aa:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801087ad:	6a 00                	push   $0x0
801087af:	68 f9 03 00 00       	push   $0x3f9
801087b4:	e8 9f ff ff ff       	call   80108758 <outb>
801087b9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801087bc:	6a 03                	push   $0x3
801087be:	68 fb 03 00 00       	push   $0x3fb
801087c3:	e8 90 ff ff ff       	call   80108758 <outb>
801087c8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801087cb:	6a 00                	push   $0x0
801087cd:	68 fc 03 00 00       	push   $0x3fc
801087d2:	e8 81 ff ff ff       	call   80108758 <outb>
801087d7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801087da:	6a 01                	push   $0x1
801087dc:	68 f9 03 00 00       	push   $0x3f9
801087e1:	e8 72 ff ff ff       	call   80108758 <outb>
801087e6:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801087e9:	68 fd 03 00 00       	push   $0x3fd
801087ee:	e8 48 ff ff ff       	call   8010873b <inb>
801087f3:	83 c4 04             	add    $0x4,%esp
801087f6:	3c ff                	cmp    $0xff,%al
801087f8:	74 6e                	je     80108868 <uartinit+0xf1>
    return;
  uart = 1;
801087fa:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
80108801:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108804:	68 fa 03 00 00       	push   $0x3fa
80108809:	e8 2d ff ff ff       	call   8010873b <inb>
8010880e:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80108811:	68 f8 03 00 00       	push   $0x3f8
80108816:	e8 20 ff ff ff       	call   8010873b <inb>
8010881b:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010881e:	83 ec 0c             	sub    $0xc,%esp
80108821:	6a 04                	push   $0x4
80108823:	e8 0d bc ff ff       	call   80104435 <picenable>
80108828:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010882b:	83 ec 08             	sub    $0x8,%esp
8010882e:	6a 00                	push   $0x0
80108830:	6a 04                	push   $0x4
80108832:	e8 ad a7 ff ff       	call   80102fe4 <ioapicenable>
80108837:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010883a:	c7 45 f4 78 a9 10 80 	movl   $0x8010a978,-0xc(%ebp)
80108841:	eb 19                	jmp    8010885c <uartinit+0xe5>
    uartputc(*p);
80108843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108846:	0f b6 00             	movzbl (%eax),%eax
80108849:	0f be c0             	movsbl %al,%eax
8010884c:	83 ec 0c             	sub    $0xc,%esp
8010884f:	50                   	push   %eax
80108850:	e8 16 00 00 00       	call   8010886b <uartputc>
80108855:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108858:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010885c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885f:	0f b6 00             	movzbl (%eax),%eax
80108862:	84 c0                	test   %al,%al
80108864:	75 dd                	jne    80108843 <uartinit+0xcc>
80108866:	eb 01                	jmp    80108869 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108868:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108869:	c9                   	leave  
8010886a:	c3                   	ret    

8010886b <uartputc>:

void
uartputc(int c)
{
8010886b:	55                   	push   %ebp
8010886c:	89 e5                	mov    %esp,%ebp
8010886e:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108871:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
80108876:	85 c0                	test   %eax,%eax
80108878:	74 53                	je     801088cd <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010887a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108881:	eb 11                	jmp    80108894 <uartputc+0x29>
    microdelay(10);
80108883:	83 ec 0c             	sub    $0xc,%esp
80108886:	6a 0a                	push   $0xa
80108888:	e8 bd ac ff ff       	call   8010354a <microdelay>
8010888d:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108890:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108894:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108898:	7f 1a                	jg     801088b4 <uartputc+0x49>
8010889a:	83 ec 0c             	sub    $0xc,%esp
8010889d:	68 fd 03 00 00       	push   $0x3fd
801088a2:	e8 94 fe ff ff       	call   8010873b <inb>
801088a7:	83 c4 10             	add    $0x10,%esp
801088aa:	0f b6 c0             	movzbl %al,%eax
801088ad:	83 e0 20             	and    $0x20,%eax
801088b0:	85 c0                	test   %eax,%eax
801088b2:	74 cf                	je     80108883 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801088b4:	8b 45 08             	mov    0x8(%ebp),%eax
801088b7:	0f b6 c0             	movzbl %al,%eax
801088ba:	83 ec 08             	sub    $0x8,%esp
801088bd:	50                   	push   %eax
801088be:	68 f8 03 00 00       	push   $0x3f8
801088c3:	e8 90 fe ff ff       	call   80108758 <outb>
801088c8:	83 c4 10             	add    $0x10,%esp
801088cb:	eb 01                	jmp    801088ce <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801088cd:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801088ce:	c9                   	leave  
801088cf:	c3                   	ret    

801088d0 <uartgetc>:

static int
uartgetc(void)
{
801088d0:	55                   	push   %ebp
801088d1:	89 e5                	mov    %esp,%ebp
  if(!uart)
801088d3:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
801088d8:	85 c0                	test   %eax,%eax
801088da:	75 07                	jne    801088e3 <uartgetc+0x13>
    return -1;
801088dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088e1:	eb 2e                	jmp    80108911 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801088e3:	68 fd 03 00 00       	push   $0x3fd
801088e8:	e8 4e fe ff ff       	call   8010873b <inb>
801088ed:	83 c4 04             	add    $0x4,%esp
801088f0:	0f b6 c0             	movzbl %al,%eax
801088f3:	83 e0 01             	and    $0x1,%eax
801088f6:	85 c0                	test   %eax,%eax
801088f8:	75 07                	jne    80108901 <uartgetc+0x31>
    return -1;
801088fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088ff:	eb 10                	jmp    80108911 <uartgetc+0x41>
  return inb(COM1+0);
80108901:	68 f8 03 00 00       	push   $0x3f8
80108906:	e8 30 fe ff ff       	call   8010873b <inb>
8010890b:	83 c4 04             	add    $0x4,%esp
8010890e:	0f b6 c0             	movzbl %al,%eax
}
80108911:	c9                   	leave  
80108912:	c3                   	ret    

80108913 <uartintr>:

void
uartintr(void)
{
80108913:	55                   	push   %ebp
80108914:	89 e5                	mov    %esp,%ebp
80108916:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80108919:	83 ec 0c             	sub    $0xc,%esp
8010891c:	68 d0 88 10 80       	push   $0x801088d0
80108921:	e8 d3 7e ff ff       	call   801007f9 <consoleintr>
80108926:	83 c4 10             	add    $0x10,%esp
}
80108929:	90                   	nop
8010892a:	c9                   	leave  
8010892b:	c3                   	ret    

8010892c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010892c:	6a 00                	push   $0x0
  pushl $0
8010892e:	6a 00                	push   $0x0
  jmp alltraps
80108930:	e9 cc f9 ff ff       	jmp    80108301 <alltraps>

80108935 <vector1>:
.globl vector1
vector1:
  pushl $0
80108935:	6a 00                	push   $0x0
  pushl $1
80108937:	6a 01                	push   $0x1
  jmp alltraps
80108939:	e9 c3 f9 ff ff       	jmp    80108301 <alltraps>

8010893e <vector2>:
.globl vector2
vector2:
  pushl $0
8010893e:	6a 00                	push   $0x0
  pushl $2
80108940:	6a 02                	push   $0x2
  jmp alltraps
80108942:	e9 ba f9 ff ff       	jmp    80108301 <alltraps>

80108947 <vector3>:
.globl vector3
vector3:
  pushl $0
80108947:	6a 00                	push   $0x0
  pushl $3
80108949:	6a 03                	push   $0x3
  jmp alltraps
8010894b:	e9 b1 f9 ff ff       	jmp    80108301 <alltraps>

80108950 <vector4>:
.globl vector4
vector4:
  pushl $0
80108950:	6a 00                	push   $0x0
  pushl $4
80108952:	6a 04                	push   $0x4
  jmp alltraps
80108954:	e9 a8 f9 ff ff       	jmp    80108301 <alltraps>

80108959 <vector5>:
.globl vector5
vector5:
  pushl $0
80108959:	6a 00                	push   $0x0
  pushl $5
8010895b:	6a 05                	push   $0x5
  jmp alltraps
8010895d:	e9 9f f9 ff ff       	jmp    80108301 <alltraps>

80108962 <vector6>:
.globl vector6
vector6:
  pushl $0
80108962:	6a 00                	push   $0x0
  pushl $6
80108964:	6a 06                	push   $0x6
  jmp alltraps
80108966:	e9 96 f9 ff ff       	jmp    80108301 <alltraps>

8010896b <vector7>:
.globl vector7
vector7:
  pushl $0
8010896b:	6a 00                	push   $0x0
  pushl $7
8010896d:	6a 07                	push   $0x7
  jmp alltraps
8010896f:	e9 8d f9 ff ff       	jmp    80108301 <alltraps>

80108974 <vector8>:
.globl vector8
vector8:
  pushl $8
80108974:	6a 08                	push   $0x8
  jmp alltraps
80108976:	e9 86 f9 ff ff       	jmp    80108301 <alltraps>

8010897b <vector9>:
.globl vector9
vector9:
  pushl $0
8010897b:	6a 00                	push   $0x0
  pushl $9
8010897d:	6a 09                	push   $0x9
  jmp alltraps
8010897f:	e9 7d f9 ff ff       	jmp    80108301 <alltraps>

80108984 <vector10>:
.globl vector10
vector10:
  pushl $10
80108984:	6a 0a                	push   $0xa
  jmp alltraps
80108986:	e9 76 f9 ff ff       	jmp    80108301 <alltraps>

8010898b <vector11>:
.globl vector11
vector11:
  pushl $11
8010898b:	6a 0b                	push   $0xb
  jmp alltraps
8010898d:	e9 6f f9 ff ff       	jmp    80108301 <alltraps>

80108992 <vector12>:
.globl vector12
vector12:
  pushl $12
80108992:	6a 0c                	push   $0xc
  jmp alltraps
80108994:	e9 68 f9 ff ff       	jmp    80108301 <alltraps>

80108999 <vector13>:
.globl vector13
vector13:
  pushl $13
80108999:	6a 0d                	push   $0xd
  jmp alltraps
8010899b:	e9 61 f9 ff ff       	jmp    80108301 <alltraps>

801089a0 <vector14>:
.globl vector14
vector14:
  pushl $14
801089a0:	6a 0e                	push   $0xe
  jmp alltraps
801089a2:	e9 5a f9 ff ff       	jmp    80108301 <alltraps>

801089a7 <vector15>:
.globl vector15
vector15:
  pushl $0
801089a7:	6a 00                	push   $0x0
  pushl $15
801089a9:	6a 0f                	push   $0xf
  jmp alltraps
801089ab:	e9 51 f9 ff ff       	jmp    80108301 <alltraps>

801089b0 <vector16>:
.globl vector16
vector16:
  pushl $0
801089b0:	6a 00                	push   $0x0
  pushl $16
801089b2:	6a 10                	push   $0x10
  jmp alltraps
801089b4:	e9 48 f9 ff ff       	jmp    80108301 <alltraps>

801089b9 <vector17>:
.globl vector17
vector17:
  pushl $17
801089b9:	6a 11                	push   $0x11
  jmp alltraps
801089bb:	e9 41 f9 ff ff       	jmp    80108301 <alltraps>

801089c0 <vector18>:
.globl vector18
vector18:
  pushl $0
801089c0:	6a 00                	push   $0x0
  pushl $18
801089c2:	6a 12                	push   $0x12
  jmp alltraps
801089c4:	e9 38 f9 ff ff       	jmp    80108301 <alltraps>

801089c9 <vector19>:
.globl vector19
vector19:
  pushl $0
801089c9:	6a 00                	push   $0x0
  pushl $19
801089cb:	6a 13                	push   $0x13
  jmp alltraps
801089cd:	e9 2f f9 ff ff       	jmp    80108301 <alltraps>

801089d2 <vector20>:
.globl vector20
vector20:
  pushl $0
801089d2:	6a 00                	push   $0x0
  pushl $20
801089d4:	6a 14                	push   $0x14
  jmp alltraps
801089d6:	e9 26 f9 ff ff       	jmp    80108301 <alltraps>

801089db <vector21>:
.globl vector21
vector21:
  pushl $0
801089db:	6a 00                	push   $0x0
  pushl $21
801089dd:	6a 15                	push   $0x15
  jmp alltraps
801089df:	e9 1d f9 ff ff       	jmp    80108301 <alltraps>

801089e4 <vector22>:
.globl vector22
vector22:
  pushl $0
801089e4:	6a 00                	push   $0x0
  pushl $22
801089e6:	6a 16                	push   $0x16
  jmp alltraps
801089e8:	e9 14 f9 ff ff       	jmp    80108301 <alltraps>

801089ed <vector23>:
.globl vector23
vector23:
  pushl $0
801089ed:	6a 00                	push   $0x0
  pushl $23
801089ef:	6a 17                	push   $0x17
  jmp alltraps
801089f1:	e9 0b f9 ff ff       	jmp    80108301 <alltraps>

801089f6 <vector24>:
.globl vector24
vector24:
  pushl $0
801089f6:	6a 00                	push   $0x0
  pushl $24
801089f8:	6a 18                	push   $0x18
  jmp alltraps
801089fa:	e9 02 f9 ff ff       	jmp    80108301 <alltraps>

801089ff <vector25>:
.globl vector25
vector25:
  pushl $0
801089ff:	6a 00                	push   $0x0
  pushl $25
80108a01:	6a 19                	push   $0x19
  jmp alltraps
80108a03:	e9 f9 f8 ff ff       	jmp    80108301 <alltraps>

80108a08 <vector26>:
.globl vector26
vector26:
  pushl $0
80108a08:	6a 00                	push   $0x0
  pushl $26
80108a0a:	6a 1a                	push   $0x1a
  jmp alltraps
80108a0c:	e9 f0 f8 ff ff       	jmp    80108301 <alltraps>

80108a11 <vector27>:
.globl vector27
vector27:
  pushl $0
80108a11:	6a 00                	push   $0x0
  pushl $27
80108a13:	6a 1b                	push   $0x1b
  jmp alltraps
80108a15:	e9 e7 f8 ff ff       	jmp    80108301 <alltraps>

80108a1a <vector28>:
.globl vector28
vector28:
  pushl $0
80108a1a:	6a 00                	push   $0x0
  pushl $28
80108a1c:	6a 1c                	push   $0x1c
  jmp alltraps
80108a1e:	e9 de f8 ff ff       	jmp    80108301 <alltraps>

80108a23 <vector29>:
.globl vector29
vector29:
  pushl $0
80108a23:	6a 00                	push   $0x0
  pushl $29
80108a25:	6a 1d                	push   $0x1d
  jmp alltraps
80108a27:	e9 d5 f8 ff ff       	jmp    80108301 <alltraps>

80108a2c <vector30>:
.globl vector30
vector30:
  pushl $0
80108a2c:	6a 00                	push   $0x0
  pushl $30
80108a2e:	6a 1e                	push   $0x1e
  jmp alltraps
80108a30:	e9 cc f8 ff ff       	jmp    80108301 <alltraps>

80108a35 <vector31>:
.globl vector31
vector31:
  pushl $0
80108a35:	6a 00                	push   $0x0
  pushl $31
80108a37:	6a 1f                	push   $0x1f
  jmp alltraps
80108a39:	e9 c3 f8 ff ff       	jmp    80108301 <alltraps>

80108a3e <vector32>:
.globl vector32
vector32:
  pushl $0
80108a3e:	6a 00                	push   $0x0
  pushl $32
80108a40:	6a 20                	push   $0x20
  jmp alltraps
80108a42:	e9 ba f8 ff ff       	jmp    80108301 <alltraps>

80108a47 <vector33>:
.globl vector33
vector33:
  pushl $0
80108a47:	6a 00                	push   $0x0
  pushl $33
80108a49:	6a 21                	push   $0x21
  jmp alltraps
80108a4b:	e9 b1 f8 ff ff       	jmp    80108301 <alltraps>

80108a50 <vector34>:
.globl vector34
vector34:
  pushl $0
80108a50:	6a 00                	push   $0x0
  pushl $34
80108a52:	6a 22                	push   $0x22
  jmp alltraps
80108a54:	e9 a8 f8 ff ff       	jmp    80108301 <alltraps>

80108a59 <vector35>:
.globl vector35
vector35:
  pushl $0
80108a59:	6a 00                	push   $0x0
  pushl $35
80108a5b:	6a 23                	push   $0x23
  jmp alltraps
80108a5d:	e9 9f f8 ff ff       	jmp    80108301 <alltraps>

80108a62 <vector36>:
.globl vector36
vector36:
  pushl $0
80108a62:	6a 00                	push   $0x0
  pushl $36
80108a64:	6a 24                	push   $0x24
  jmp alltraps
80108a66:	e9 96 f8 ff ff       	jmp    80108301 <alltraps>

80108a6b <vector37>:
.globl vector37
vector37:
  pushl $0
80108a6b:	6a 00                	push   $0x0
  pushl $37
80108a6d:	6a 25                	push   $0x25
  jmp alltraps
80108a6f:	e9 8d f8 ff ff       	jmp    80108301 <alltraps>

80108a74 <vector38>:
.globl vector38
vector38:
  pushl $0
80108a74:	6a 00                	push   $0x0
  pushl $38
80108a76:	6a 26                	push   $0x26
  jmp alltraps
80108a78:	e9 84 f8 ff ff       	jmp    80108301 <alltraps>

80108a7d <vector39>:
.globl vector39
vector39:
  pushl $0
80108a7d:	6a 00                	push   $0x0
  pushl $39
80108a7f:	6a 27                	push   $0x27
  jmp alltraps
80108a81:	e9 7b f8 ff ff       	jmp    80108301 <alltraps>

80108a86 <vector40>:
.globl vector40
vector40:
  pushl $0
80108a86:	6a 00                	push   $0x0
  pushl $40
80108a88:	6a 28                	push   $0x28
  jmp alltraps
80108a8a:	e9 72 f8 ff ff       	jmp    80108301 <alltraps>

80108a8f <vector41>:
.globl vector41
vector41:
  pushl $0
80108a8f:	6a 00                	push   $0x0
  pushl $41
80108a91:	6a 29                	push   $0x29
  jmp alltraps
80108a93:	e9 69 f8 ff ff       	jmp    80108301 <alltraps>

80108a98 <vector42>:
.globl vector42
vector42:
  pushl $0
80108a98:	6a 00                	push   $0x0
  pushl $42
80108a9a:	6a 2a                	push   $0x2a
  jmp alltraps
80108a9c:	e9 60 f8 ff ff       	jmp    80108301 <alltraps>

80108aa1 <vector43>:
.globl vector43
vector43:
  pushl $0
80108aa1:	6a 00                	push   $0x0
  pushl $43
80108aa3:	6a 2b                	push   $0x2b
  jmp alltraps
80108aa5:	e9 57 f8 ff ff       	jmp    80108301 <alltraps>

80108aaa <vector44>:
.globl vector44
vector44:
  pushl $0
80108aaa:	6a 00                	push   $0x0
  pushl $44
80108aac:	6a 2c                	push   $0x2c
  jmp alltraps
80108aae:	e9 4e f8 ff ff       	jmp    80108301 <alltraps>

80108ab3 <vector45>:
.globl vector45
vector45:
  pushl $0
80108ab3:	6a 00                	push   $0x0
  pushl $45
80108ab5:	6a 2d                	push   $0x2d
  jmp alltraps
80108ab7:	e9 45 f8 ff ff       	jmp    80108301 <alltraps>

80108abc <vector46>:
.globl vector46
vector46:
  pushl $0
80108abc:	6a 00                	push   $0x0
  pushl $46
80108abe:	6a 2e                	push   $0x2e
  jmp alltraps
80108ac0:	e9 3c f8 ff ff       	jmp    80108301 <alltraps>

80108ac5 <vector47>:
.globl vector47
vector47:
  pushl $0
80108ac5:	6a 00                	push   $0x0
  pushl $47
80108ac7:	6a 2f                	push   $0x2f
  jmp alltraps
80108ac9:	e9 33 f8 ff ff       	jmp    80108301 <alltraps>

80108ace <vector48>:
.globl vector48
vector48:
  pushl $0
80108ace:	6a 00                	push   $0x0
  pushl $48
80108ad0:	6a 30                	push   $0x30
  jmp alltraps
80108ad2:	e9 2a f8 ff ff       	jmp    80108301 <alltraps>

80108ad7 <vector49>:
.globl vector49
vector49:
  pushl $0
80108ad7:	6a 00                	push   $0x0
  pushl $49
80108ad9:	6a 31                	push   $0x31
  jmp alltraps
80108adb:	e9 21 f8 ff ff       	jmp    80108301 <alltraps>

80108ae0 <vector50>:
.globl vector50
vector50:
  pushl $0
80108ae0:	6a 00                	push   $0x0
  pushl $50
80108ae2:	6a 32                	push   $0x32
  jmp alltraps
80108ae4:	e9 18 f8 ff ff       	jmp    80108301 <alltraps>

80108ae9 <vector51>:
.globl vector51
vector51:
  pushl $0
80108ae9:	6a 00                	push   $0x0
  pushl $51
80108aeb:	6a 33                	push   $0x33
  jmp alltraps
80108aed:	e9 0f f8 ff ff       	jmp    80108301 <alltraps>

80108af2 <vector52>:
.globl vector52
vector52:
  pushl $0
80108af2:	6a 00                	push   $0x0
  pushl $52
80108af4:	6a 34                	push   $0x34
  jmp alltraps
80108af6:	e9 06 f8 ff ff       	jmp    80108301 <alltraps>

80108afb <vector53>:
.globl vector53
vector53:
  pushl $0
80108afb:	6a 00                	push   $0x0
  pushl $53
80108afd:	6a 35                	push   $0x35
  jmp alltraps
80108aff:	e9 fd f7 ff ff       	jmp    80108301 <alltraps>

80108b04 <vector54>:
.globl vector54
vector54:
  pushl $0
80108b04:	6a 00                	push   $0x0
  pushl $54
80108b06:	6a 36                	push   $0x36
  jmp alltraps
80108b08:	e9 f4 f7 ff ff       	jmp    80108301 <alltraps>

80108b0d <vector55>:
.globl vector55
vector55:
  pushl $0
80108b0d:	6a 00                	push   $0x0
  pushl $55
80108b0f:	6a 37                	push   $0x37
  jmp alltraps
80108b11:	e9 eb f7 ff ff       	jmp    80108301 <alltraps>

80108b16 <vector56>:
.globl vector56
vector56:
  pushl $0
80108b16:	6a 00                	push   $0x0
  pushl $56
80108b18:	6a 38                	push   $0x38
  jmp alltraps
80108b1a:	e9 e2 f7 ff ff       	jmp    80108301 <alltraps>

80108b1f <vector57>:
.globl vector57
vector57:
  pushl $0
80108b1f:	6a 00                	push   $0x0
  pushl $57
80108b21:	6a 39                	push   $0x39
  jmp alltraps
80108b23:	e9 d9 f7 ff ff       	jmp    80108301 <alltraps>

80108b28 <vector58>:
.globl vector58
vector58:
  pushl $0
80108b28:	6a 00                	push   $0x0
  pushl $58
80108b2a:	6a 3a                	push   $0x3a
  jmp alltraps
80108b2c:	e9 d0 f7 ff ff       	jmp    80108301 <alltraps>

80108b31 <vector59>:
.globl vector59
vector59:
  pushl $0
80108b31:	6a 00                	push   $0x0
  pushl $59
80108b33:	6a 3b                	push   $0x3b
  jmp alltraps
80108b35:	e9 c7 f7 ff ff       	jmp    80108301 <alltraps>

80108b3a <vector60>:
.globl vector60
vector60:
  pushl $0
80108b3a:	6a 00                	push   $0x0
  pushl $60
80108b3c:	6a 3c                	push   $0x3c
  jmp alltraps
80108b3e:	e9 be f7 ff ff       	jmp    80108301 <alltraps>

80108b43 <vector61>:
.globl vector61
vector61:
  pushl $0
80108b43:	6a 00                	push   $0x0
  pushl $61
80108b45:	6a 3d                	push   $0x3d
  jmp alltraps
80108b47:	e9 b5 f7 ff ff       	jmp    80108301 <alltraps>

80108b4c <vector62>:
.globl vector62
vector62:
  pushl $0
80108b4c:	6a 00                	push   $0x0
  pushl $62
80108b4e:	6a 3e                	push   $0x3e
  jmp alltraps
80108b50:	e9 ac f7 ff ff       	jmp    80108301 <alltraps>

80108b55 <vector63>:
.globl vector63
vector63:
  pushl $0
80108b55:	6a 00                	push   $0x0
  pushl $63
80108b57:	6a 3f                	push   $0x3f
  jmp alltraps
80108b59:	e9 a3 f7 ff ff       	jmp    80108301 <alltraps>

80108b5e <vector64>:
.globl vector64
vector64:
  pushl $0
80108b5e:	6a 00                	push   $0x0
  pushl $64
80108b60:	6a 40                	push   $0x40
  jmp alltraps
80108b62:	e9 9a f7 ff ff       	jmp    80108301 <alltraps>

80108b67 <vector65>:
.globl vector65
vector65:
  pushl $0
80108b67:	6a 00                	push   $0x0
  pushl $65
80108b69:	6a 41                	push   $0x41
  jmp alltraps
80108b6b:	e9 91 f7 ff ff       	jmp    80108301 <alltraps>

80108b70 <vector66>:
.globl vector66
vector66:
  pushl $0
80108b70:	6a 00                	push   $0x0
  pushl $66
80108b72:	6a 42                	push   $0x42
  jmp alltraps
80108b74:	e9 88 f7 ff ff       	jmp    80108301 <alltraps>

80108b79 <vector67>:
.globl vector67
vector67:
  pushl $0
80108b79:	6a 00                	push   $0x0
  pushl $67
80108b7b:	6a 43                	push   $0x43
  jmp alltraps
80108b7d:	e9 7f f7 ff ff       	jmp    80108301 <alltraps>

80108b82 <vector68>:
.globl vector68
vector68:
  pushl $0
80108b82:	6a 00                	push   $0x0
  pushl $68
80108b84:	6a 44                	push   $0x44
  jmp alltraps
80108b86:	e9 76 f7 ff ff       	jmp    80108301 <alltraps>

80108b8b <vector69>:
.globl vector69
vector69:
  pushl $0
80108b8b:	6a 00                	push   $0x0
  pushl $69
80108b8d:	6a 45                	push   $0x45
  jmp alltraps
80108b8f:	e9 6d f7 ff ff       	jmp    80108301 <alltraps>

80108b94 <vector70>:
.globl vector70
vector70:
  pushl $0
80108b94:	6a 00                	push   $0x0
  pushl $70
80108b96:	6a 46                	push   $0x46
  jmp alltraps
80108b98:	e9 64 f7 ff ff       	jmp    80108301 <alltraps>

80108b9d <vector71>:
.globl vector71
vector71:
  pushl $0
80108b9d:	6a 00                	push   $0x0
  pushl $71
80108b9f:	6a 47                	push   $0x47
  jmp alltraps
80108ba1:	e9 5b f7 ff ff       	jmp    80108301 <alltraps>

80108ba6 <vector72>:
.globl vector72
vector72:
  pushl $0
80108ba6:	6a 00                	push   $0x0
  pushl $72
80108ba8:	6a 48                	push   $0x48
  jmp alltraps
80108baa:	e9 52 f7 ff ff       	jmp    80108301 <alltraps>

80108baf <vector73>:
.globl vector73
vector73:
  pushl $0
80108baf:	6a 00                	push   $0x0
  pushl $73
80108bb1:	6a 49                	push   $0x49
  jmp alltraps
80108bb3:	e9 49 f7 ff ff       	jmp    80108301 <alltraps>

80108bb8 <vector74>:
.globl vector74
vector74:
  pushl $0
80108bb8:	6a 00                	push   $0x0
  pushl $74
80108bba:	6a 4a                	push   $0x4a
  jmp alltraps
80108bbc:	e9 40 f7 ff ff       	jmp    80108301 <alltraps>

80108bc1 <vector75>:
.globl vector75
vector75:
  pushl $0
80108bc1:	6a 00                	push   $0x0
  pushl $75
80108bc3:	6a 4b                	push   $0x4b
  jmp alltraps
80108bc5:	e9 37 f7 ff ff       	jmp    80108301 <alltraps>

80108bca <vector76>:
.globl vector76
vector76:
  pushl $0
80108bca:	6a 00                	push   $0x0
  pushl $76
80108bcc:	6a 4c                	push   $0x4c
  jmp alltraps
80108bce:	e9 2e f7 ff ff       	jmp    80108301 <alltraps>

80108bd3 <vector77>:
.globl vector77
vector77:
  pushl $0
80108bd3:	6a 00                	push   $0x0
  pushl $77
80108bd5:	6a 4d                	push   $0x4d
  jmp alltraps
80108bd7:	e9 25 f7 ff ff       	jmp    80108301 <alltraps>

80108bdc <vector78>:
.globl vector78
vector78:
  pushl $0
80108bdc:	6a 00                	push   $0x0
  pushl $78
80108bde:	6a 4e                	push   $0x4e
  jmp alltraps
80108be0:	e9 1c f7 ff ff       	jmp    80108301 <alltraps>

80108be5 <vector79>:
.globl vector79
vector79:
  pushl $0
80108be5:	6a 00                	push   $0x0
  pushl $79
80108be7:	6a 4f                	push   $0x4f
  jmp alltraps
80108be9:	e9 13 f7 ff ff       	jmp    80108301 <alltraps>

80108bee <vector80>:
.globl vector80
vector80:
  pushl $0
80108bee:	6a 00                	push   $0x0
  pushl $80
80108bf0:	6a 50                	push   $0x50
  jmp alltraps
80108bf2:	e9 0a f7 ff ff       	jmp    80108301 <alltraps>

80108bf7 <vector81>:
.globl vector81
vector81:
  pushl $0
80108bf7:	6a 00                	push   $0x0
  pushl $81
80108bf9:	6a 51                	push   $0x51
  jmp alltraps
80108bfb:	e9 01 f7 ff ff       	jmp    80108301 <alltraps>

80108c00 <vector82>:
.globl vector82
vector82:
  pushl $0
80108c00:	6a 00                	push   $0x0
  pushl $82
80108c02:	6a 52                	push   $0x52
  jmp alltraps
80108c04:	e9 f8 f6 ff ff       	jmp    80108301 <alltraps>

80108c09 <vector83>:
.globl vector83
vector83:
  pushl $0
80108c09:	6a 00                	push   $0x0
  pushl $83
80108c0b:	6a 53                	push   $0x53
  jmp alltraps
80108c0d:	e9 ef f6 ff ff       	jmp    80108301 <alltraps>

80108c12 <vector84>:
.globl vector84
vector84:
  pushl $0
80108c12:	6a 00                	push   $0x0
  pushl $84
80108c14:	6a 54                	push   $0x54
  jmp alltraps
80108c16:	e9 e6 f6 ff ff       	jmp    80108301 <alltraps>

80108c1b <vector85>:
.globl vector85
vector85:
  pushl $0
80108c1b:	6a 00                	push   $0x0
  pushl $85
80108c1d:	6a 55                	push   $0x55
  jmp alltraps
80108c1f:	e9 dd f6 ff ff       	jmp    80108301 <alltraps>

80108c24 <vector86>:
.globl vector86
vector86:
  pushl $0
80108c24:	6a 00                	push   $0x0
  pushl $86
80108c26:	6a 56                	push   $0x56
  jmp alltraps
80108c28:	e9 d4 f6 ff ff       	jmp    80108301 <alltraps>

80108c2d <vector87>:
.globl vector87
vector87:
  pushl $0
80108c2d:	6a 00                	push   $0x0
  pushl $87
80108c2f:	6a 57                	push   $0x57
  jmp alltraps
80108c31:	e9 cb f6 ff ff       	jmp    80108301 <alltraps>

80108c36 <vector88>:
.globl vector88
vector88:
  pushl $0
80108c36:	6a 00                	push   $0x0
  pushl $88
80108c38:	6a 58                	push   $0x58
  jmp alltraps
80108c3a:	e9 c2 f6 ff ff       	jmp    80108301 <alltraps>

80108c3f <vector89>:
.globl vector89
vector89:
  pushl $0
80108c3f:	6a 00                	push   $0x0
  pushl $89
80108c41:	6a 59                	push   $0x59
  jmp alltraps
80108c43:	e9 b9 f6 ff ff       	jmp    80108301 <alltraps>

80108c48 <vector90>:
.globl vector90
vector90:
  pushl $0
80108c48:	6a 00                	push   $0x0
  pushl $90
80108c4a:	6a 5a                	push   $0x5a
  jmp alltraps
80108c4c:	e9 b0 f6 ff ff       	jmp    80108301 <alltraps>

80108c51 <vector91>:
.globl vector91
vector91:
  pushl $0
80108c51:	6a 00                	push   $0x0
  pushl $91
80108c53:	6a 5b                	push   $0x5b
  jmp alltraps
80108c55:	e9 a7 f6 ff ff       	jmp    80108301 <alltraps>

80108c5a <vector92>:
.globl vector92
vector92:
  pushl $0
80108c5a:	6a 00                	push   $0x0
  pushl $92
80108c5c:	6a 5c                	push   $0x5c
  jmp alltraps
80108c5e:	e9 9e f6 ff ff       	jmp    80108301 <alltraps>

80108c63 <vector93>:
.globl vector93
vector93:
  pushl $0
80108c63:	6a 00                	push   $0x0
  pushl $93
80108c65:	6a 5d                	push   $0x5d
  jmp alltraps
80108c67:	e9 95 f6 ff ff       	jmp    80108301 <alltraps>

80108c6c <vector94>:
.globl vector94
vector94:
  pushl $0
80108c6c:	6a 00                	push   $0x0
  pushl $94
80108c6e:	6a 5e                	push   $0x5e
  jmp alltraps
80108c70:	e9 8c f6 ff ff       	jmp    80108301 <alltraps>

80108c75 <vector95>:
.globl vector95
vector95:
  pushl $0
80108c75:	6a 00                	push   $0x0
  pushl $95
80108c77:	6a 5f                	push   $0x5f
  jmp alltraps
80108c79:	e9 83 f6 ff ff       	jmp    80108301 <alltraps>

80108c7e <vector96>:
.globl vector96
vector96:
  pushl $0
80108c7e:	6a 00                	push   $0x0
  pushl $96
80108c80:	6a 60                	push   $0x60
  jmp alltraps
80108c82:	e9 7a f6 ff ff       	jmp    80108301 <alltraps>

80108c87 <vector97>:
.globl vector97
vector97:
  pushl $0
80108c87:	6a 00                	push   $0x0
  pushl $97
80108c89:	6a 61                	push   $0x61
  jmp alltraps
80108c8b:	e9 71 f6 ff ff       	jmp    80108301 <alltraps>

80108c90 <vector98>:
.globl vector98
vector98:
  pushl $0
80108c90:	6a 00                	push   $0x0
  pushl $98
80108c92:	6a 62                	push   $0x62
  jmp alltraps
80108c94:	e9 68 f6 ff ff       	jmp    80108301 <alltraps>

80108c99 <vector99>:
.globl vector99
vector99:
  pushl $0
80108c99:	6a 00                	push   $0x0
  pushl $99
80108c9b:	6a 63                	push   $0x63
  jmp alltraps
80108c9d:	e9 5f f6 ff ff       	jmp    80108301 <alltraps>

80108ca2 <vector100>:
.globl vector100
vector100:
  pushl $0
80108ca2:	6a 00                	push   $0x0
  pushl $100
80108ca4:	6a 64                	push   $0x64
  jmp alltraps
80108ca6:	e9 56 f6 ff ff       	jmp    80108301 <alltraps>

80108cab <vector101>:
.globl vector101
vector101:
  pushl $0
80108cab:	6a 00                	push   $0x0
  pushl $101
80108cad:	6a 65                	push   $0x65
  jmp alltraps
80108caf:	e9 4d f6 ff ff       	jmp    80108301 <alltraps>

80108cb4 <vector102>:
.globl vector102
vector102:
  pushl $0
80108cb4:	6a 00                	push   $0x0
  pushl $102
80108cb6:	6a 66                	push   $0x66
  jmp alltraps
80108cb8:	e9 44 f6 ff ff       	jmp    80108301 <alltraps>

80108cbd <vector103>:
.globl vector103
vector103:
  pushl $0
80108cbd:	6a 00                	push   $0x0
  pushl $103
80108cbf:	6a 67                	push   $0x67
  jmp alltraps
80108cc1:	e9 3b f6 ff ff       	jmp    80108301 <alltraps>

80108cc6 <vector104>:
.globl vector104
vector104:
  pushl $0
80108cc6:	6a 00                	push   $0x0
  pushl $104
80108cc8:	6a 68                	push   $0x68
  jmp alltraps
80108cca:	e9 32 f6 ff ff       	jmp    80108301 <alltraps>

80108ccf <vector105>:
.globl vector105
vector105:
  pushl $0
80108ccf:	6a 00                	push   $0x0
  pushl $105
80108cd1:	6a 69                	push   $0x69
  jmp alltraps
80108cd3:	e9 29 f6 ff ff       	jmp    80108301 <alltraps>

80108cd8 <vector106>:
.globl vector106
vector106:
  pushl $0
80108cd8:	6a 00                	push   $0x0
  pushl $106
80108cda:	6a 6a                	push   $0x6a
  jmp alltraps
80108cdc:	e9 20 f6 ff ff       	jmp    80108301 <alltraps>

80108ce1 <vector107>:
.globl vector107
vector107:
  pushl $0
80108ce1:	6a 00                	push   $0x0
  pushl $107
80108ce3:	6a 6b                	push   $0x6b
  jmp alltraps
80108ce5:	e9 17 f6 ff ff       	jmp    80108301 <alltraps>

80108cea <vector108>:
.globl vector108
vector108:
  pushl $0
80108cea:	6a 00                	push   $0x0
  pushl $108
80108cec:	6a 6c                	push   $0x6c
  jmp alltraps
80108cee:	e9 0e f6 ff ff       	jmp    80108301 <alltraps>

80108cf3 <vector109>:
.globl vector109
vector109:
  pushl $0
80108cf3:	6a 00                	push   $0x0
  pushl $109
80108cf5:	6a 6d                	push   $0x6d
  jmp alltraps
80108cf7:	e9 05 f6 ff ff       	jmp    80108301 <alltraps>

80108cfc <vector110>:
.globl vector110
vector110:
  pushl $0
80108cfc:	6a 00                	push   $0x0
  pushl $110
80108cfe:	6a 6e                	push   $0x6e
  jmp alltraps
80108d00:	e9 fc f5 ff ff       	jmp    80108301 <alltraps>

80108d05 <vector111>:
.globl vector111
vector111:
  pushl $0
80108d05:	6a 00                	push   $0x0
  pushl $111
80108d07:	6a 6f                	push   $0x6f
  jmp alltraps
80108d09:	e9 f3 f5 ff ff       	jmp    80108301 <alltraps>

80108d0e <vector112>:
.globl vector112
vector112:
  pushl $0
80108d0e:	6a 00                	push   $0x0
  pushl $112
80108d10:	6a 70                	push   $0x70
  jmp alltraps
80108d12:	e9 ea f5 ff ff       	jmp    80108301 <alltraps>

80108d17 <vector113>:
.globl vector113
vector113:
  pushl $0
80108d17:	6a 00                	push   $0x0
  pushl $113
80108d19:	6a 71                	push   $0x71
  jmp alltraps
80108d1b:	e9 e1 f5 ff ff       	jmp    80108301 <alltraps>

80108d20 <vector114>:
.globl vector114
vector114:
  pushl $0
80108d20:	6a 00                	push   $0x0
  pushl $114
80108d22:	6a 72                	push   $0x72
  jmp alltraps
80108d24:	e9 d8 f5 ff ff       	jmp    80108301 <alltraps>

80108d29 <vector115>:
.globl vector115
vector115:
  pushl $0
80108d29:	6a 00                	push   $0x0
  pushl $115
80108d2b:	6a 73                	push   $0x73
  jmp alltraps
80108d2d:	e9 cf f5 ff ff       	jmp    80108301 <alltraps>

80108d32 <vector116>:
.globl vector116
vector116:
  pushl $0
80108d32:	6a 00                	push   $0x0
  pushl $116
80108d34:	6a 74                	push   $0x74
  jmp alltraps
80108d36:	e9 c6 f5 ff ff       	jmp    80108301 <alltraps>

80108d3b <vector117>:
.globl vector117
vector117:
  pushl $0
80108d3b:	6a 00                	push   $0x0
  pushl $117
80108d3d:	6a 75                	push   $0x75
  jmp alltraps
80108d3f:	e9 bd f5 ff ff       	jmp    80108301 <alltraps>

80108d44 <vector118>:
.globl vector118
vector118:
  pushl $0
80108d44:	6a 00                	push   $0x0
  pushl $118
80108d46:	6a 76                	push   $0x76
  jmp alltraps
80108d48:	e9 b4 f5 ff ff       	jmp    80108301 <alltraps>

80108d4d <vector119>:
.globl vector119
vector119:
  pushl $0
80108d4d:	6a 00                	push   $0x0
  pushl $119
80108d4f:	6a 77                	push   $0x77
  jmp alltraps
80108d51:	e9 ab f5 ff ff       	jmp    80108301 <alltraps>

80108d56 <vector120>:
.globl vector120
vector120:
  pushl $0
80108d56:	6a 00                	push   $0x0
  pushl $120
80108d58:	6a 78                	push   $0x78
  jmp alltraps
80108d5a:	e9 a2 f5 ff ff       	jmp    80108301 <alltraps>

80108d5f <vector121>:
.globl vector121
vector121:
  pushl $0
80108d5f:	6a 00                	push   $0x0
  pushl $121
80108d61:	6a 79                	push   $0x79
  jmp alltraps
80108d63:	e9 99 f5 ff ff       	jmp    80108301 <alltraps>

80108d68 <vector122>:
.globl vector122
vector122:
  pushl $0
80108d68:	6a 00                	push   $0x0
  pushl $122
80108d6a:	6a 7a                	push   $0x7a
  jmp alltraps
80108d6c:	e9 90 f5 ff ff       	jmp    80108301 <alltraps>

80108d71 <vector123>:
.globl vector123
vector123:
  pushl $0
80108d71:	6a 00                	push   $0x0
  pushl $123
80108d73:	6a 7b                	push   $0x7b
  jmp alltraps
80108d75:	e9 87 f5 ff ff       	jmp    80108301 <alltraps>

80108d7a <vector124>:
.globl vector124
vector124:
  pushl $0
80108d7a:	6a 00                	push   $0x0
  pushl $124
80108d7c:	6a 7c                	push   $0x7c
  jmp alltraps
80108d7e:	e9 7e f5 ff ff       	jmp    80108301 <alltraps>

80108d83 <vector125>:
.globl vector125
vector125:
  pushl $0
80108d83:	6a 00                	push   $0x0
  pushl $125
80108d85:	6a 7d                	push   $0x7d
  jmp alltraps
80108d87:	e9 75 f5 ff ff       	jmp    80108301 <alltraps>

80108d8c <vector126>:
.globl vector126
vector126:
  pushl $0
80108d8c:	6a 00                	push   $0x0
  pushl $126
80108d8e:	6a 7e                	push   $0x7e
  jmp alltraps
80108d90:	e9 6c f5 ff ff       	jmp    80108301 <alltraps>

80108d95 <vector127>:
.globl vector127
vector127:
  pushl $0
80108d95:	6a 00                	push   $0x0
  pushl $127
80108d97:	6a 7f                	push   $0x7f
  jmp alltraps
80108d99:	e9 63 f5 ff ff       	jmp    80108301 <alltraps>

80108d9e <vector128>:
.globl vector128
vector128:
  pushl $0
80108d9e:	6a 00                	push   $0x0
  pushl $128
80108da0:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108da5:	e9 57 f5 ff ff       	jmp    80108301 <alltraps>

80108daa <vector129>:
.globl vector129
vector129:
  pushl $0
80108daa:	6a 00                	push   $0x0
  pushl $129
80108dac:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108db1:	e9 4b f5 ff ff       	jmp    80108301 <alltraps>

80108db6 <vector130>:
.globl vector130
vector130:
  pushl $0
80108db6:	6a 00                	push   $0x0
  pushl $130
80108db8:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108dbd:	e9 3f f5 ff ff       	jmp    80108301 <alltraps>

80108dc2 <vector131>:
.globl vector131
vector131:
  pushl $0
80108dc2:	6a 00                	push   $0x0
  pushl $131
80108dc4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108dc9:	e9 33 f5 ff ff       	jmp    80108301 <alltraps>

80108dce <vector132>:
.globl vector132
vector132:
  pushl $0
80108dce:	6a 00                	push   $0x0
  pushl $132
80108dd0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108dd5:	e9 27 f5 ff ff       	jmp    80108301 <alltraps>

80108dda <vector133>:
.globl vector133
vector133:
  pushl $0
80108dda:	6a 00                	push   $0x0
  pushl $133
80108ddc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108de1:	e9 1b f5 ff ff       	jmp    80108301 <alltraps>

80108de6 <vector134>:
.globl vector134
vector134:
  pushl $0
80108de6:	6a 00                	push   $0x0
  pushl $134
80108de8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108ded:	e9 0f f5 ff ff       	jmp    80108301 <alltraps>

80108df2 <vector135>:
.globl vector135
vector135:
  pushl $0
80108df2:	6a 00                	push   $0x0
  pushl $135
80108df4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108df9:	e9 03 f5 ff ff       	jmp    80108301 <alltraps>

80108dfe <vector136>:
.globl vector136
vector136:
  pushl $0
80108dfe:	6a 00                	push   $0x0
  pushl $136
80108e00:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108e05:	e9 f7 f4 ff ff       	jmp    80108301 <alltraps>

80108e0a <vector137>:
.globl vector137
vector137:
  pushl $0
80108e0a:	6a 00                	push   $0x0
  pushl $137
80108e0c:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108e11:	e9 eb f4 ff ff       	jmp    80108301 <alltraps>

80108e16 <vector138>:
.globl vector138
vector138:
  pushl $0
80108e16:	6a 00                	push   $0x0
  pushl $138
80108e18:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108e1d:	e9 df f4 ff ff       	jmp    80108301 <alltraps>

80108e22 <vector139>:
.globl vector139
vector139:
  pushl $0
80108e22:	6a 00                	push   $0x0
  pushl $139
80108e24:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108e29:	e9 d3 f4 ff ff       	jmp    80108301 <alltraps>

80108e2e <vector140>:
.globl vector140
vector140:
  pushl $0
80108e2e:	6a 00                	push   $0x0
  pushl $140
80108e30:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108e35:	e9 c7 f4 ff ff       	jmp    80108301 <alltraps>

80108e3a <vector141>:
.globl vector141
vector141:
  pushl $0
80108e3a:	6a 00                	push   $0x0
  pushl $141
80108e3c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108e41:	e9 bb f4 ff ff       	jmp    80108301 <alltraps>

80108e46 <vector142>:
.globl vector142
vector142:
  pushl $0
80108e46:	6a 00                	push   $0x0
  pushl $142
80108e48:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108e4d:	e9 af f4 ff ff       	jmp    80108301 <alltraps>

80108e52 <vector143>:
.globl vector143
vector143:
  pushl $0
80108e52:	6a 00                	push   $0x0
  pushl $143
80108e54:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108e59:	e9 a3 f4 ff ff       	jmp    80108301 <alltraps>

80108e5e <vector144>:
.globl vector144
vector144:
  pushl $0
80108e5e:	6a 00                	push   $0x0
  pushl $144
80108e60:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108e65:	e9 97 f4 ff ff       	jmp    80108301 <alltraps>

80108e6a <vector145>:
.globl vector145
vector145:
  pushl $0
80108e6a:	6a 00                	push   $0x0
  pushl $145
80108e6c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108e71:	e9 8b f4 ff ff       	jmp    80108301 <alltraps>

80108e76 <vector146>:
.globl vector146
vector146:
  pushl $0
80108e76:	6a 00                	push   $0x0
  pushl $146
80108e78:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108e7d:	e9 7f f4 ff ff       	jmp    80108301 <alltraps>

80108e82 <vector147>:
.globl vector147
vector147:
  pushl $0
80108e82:	6a 00                	push   $0x0
  pushl $147
80108e84:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108e89:	e9 73 f4 ff ff       	jmp    80108301 <alltraps>

80108e8e <vector148>:
.globl vector148
vector148:
  pushl $0
80108e8e:	6a 00                	push   $0x0
  pushl $148
80108e90:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108e95:	e9 67 f4 ff ff       	jmp    80108301 <alltraps>

80108e9a <vector149>:
.globl vector149
vector149:
  pushl $0
80108e9a:	6a 00                	push   $0x0
  pushl $149
80108e9c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108ea1:	e9 5b f4 ff ff       	jmp    80108301 <alltraps>

80108ea6 <vector150>:
.globl vector150
vector150:
  pushl $0
80108ea6:	6a 00                	push   $0x0
  pushl $150
80108ea8:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108ead:	e9 4f f4 ff ff       	jmp    80108301 <alltraps>

80108eb2 <vector151>:
.globl vector151
vector151:
  pushl $0
80108eb2:	6a 00                	push   $0x0
  pushl $151
80108eb4:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108eb9:	e9 43 f4 ff ff       	jmp    80108301 <alltraps>

80108ebe <vector152>:
.globl vector152
vector152:
  pushl $0
80108ebe:	6a 00                	push   $0x0
  pushl $152
80108ec0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108ec5:	e9 37 f4 ff ff       	jmp    80108301 <alltraps>

80108eca <vector153>:
.globl vector153
vector153:
  pushl $0
80108eca:	6a 00                	push   $0x0
  pushl $153
80108ecc:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108ed1:	e9 2b f4 ff ff       	jmp    80108301 <alltraps>

80108ed6 <vector154>:
.globl vector154
vector154:
  pushl $0
80108ed6:	6a 00                	push   $0x0
  pushl $154
80108ed8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108edd:	e9 1f f4 ff ff       	jmp    80108301 <alltraps>

80108ee2 <vector155>:
.globl vector155
vector155:
  pushl $0
80108ee2:	6a 00                	push   $0x0
  pushl $155
80108ee4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108ee9:	e9 13 f4 ff ff       	jmp    80108301 <alltraps>

80108eee <vector156>:
.globl vector156
vector156:
  pushl $0
80108eee:	6a 00                	push   $0x0
  pushl $156
80108ef0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108ef5:	e9 07 f4 ff ff       	jmp    80108301 <alltraps>

80108efa <vector157>:
.globl vector157
vector157:
  pushl $0
80108efa:	6a 00                	push   $0x0
  pushl $157
80108efc:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108f01:	e9 fb f3 ff ff       	jmp    80108301 <alltraps>

80108f06 <vector158>:
.globl vector158
vector158:
  pushl $0
80108f06:	6a 00                	push   $0x0
  pushl $158
80108f08:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108f0d:	e9 ef f3 ff ff       	jmp    80108301 <alltraps>

80108f12 <vector159>:
.globl vector159
vector159:
  pushl $0
80108f12:	6a 00                	push   $0x0
  pushl $159
80108f14:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108f19:	e9 e3 f3 ff ff       	jmp    80108301 <alltraps>

80108f1e <vector160>:
.globl vector160
vector160:
  pushl $0
80108f1e:	6a 00                	push   $0x0
  pushl $160
80108f20:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108f25:	e9 d7 f3 ff ff       	jmp    80108301 <alltraps>

80108f2a <vector161>:
.globl vector161
vector161:
  pushl $0
80108f2a:	6a 00                	push   $0x0
  pushl $161
80108f2c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108f31:	e9 cb f3 ff ff       	jmp    80108301 <alltraps>

80108f36 <vector162>:
.globl vector162
vector162:
  pushl $0
80108f36:	6a 00                	push   $0x0
  pushl $162
80108f38:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108f3d:	e9 bf f3 ff ff       	jmp    80108301 <alltraps>

80108f42 <vector163>:
.globl vector163
vector163:
  pushl $0
80108f42:	6a 00                	push   $0x0
  pushl $163
80108f44:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108f49:	e9 b3 f3 ff ff       	jmp    80108301 <alltraps>

80108f4e <vector164>:
.globl vector164
vector164:
  pushl $0
80108f4e:	6a 00                	push   $0x0
  pushl $164
80108f50:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108f55:	e9 a7 f3 ff ff       	jmp    80108301 <alltraps>

80108f5a <vector165>:
.globl vector165
vector165:
  pushl $0
80108f5a:	6a 00                	push   $0x0
  pushl $165
80108f5c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108f61:	e9 9b f3 ff ff       	jmp    80108301 <alltraps>

80108f66 <vector166>:
.globl vector166
vector166:
  pushl $0
80108f66:	6a 00                	push   $0x0
  pushl $166
80108f68:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108f6d:	e9 8f f3 ff ff       	jmp    80108301 <alltraps>

80108f72 <vector167>:
.globl vector167
vector167:
  pushl $0
80108f72:	6a 00                	push   $0x0
  pushl $167
80108f74:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108f79:	e9 83 f3 ff ff       	jmp    80108301 <alltraps>

80108f7e <vector168>:
.globl vector168
vector168:
  pushl $0
80108f7e:	6a 00                	push   $0x0
  pushl $168
80108f80:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108f85:	e9 77 f3 ff ff       	jmp    80108301 <alltraps>

80108f8a <vector169>:
.globl vector169
vector169:
  pushl $0
80108f8a:	6a 00                	push   $0x0
  pushl $169
80108f8c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108f91:	e9 6b f3 ff ff       	jmp    80108301 <alltraps>

80108f96 <vector170>:
.globl vector170
vector170:
  pushl $0
80108f96:	6a 00                	push   $0x0
  pushl $170
80108f98:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108f9d:	e9 5f f3 ff ff       	jmp    80108301 <alltraps>

80108fa2 <vector171>:
.globl vector171
vector171:
  pushl $0
80108fa2:	6a 00                	push   $0x0
  pushl $171
80108fa4:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108fa9:	e9 53 f3 ff ff       	jmp    80108301 <alltraps>

80108fae <vector172>:
.globl vector172
vector172:
  pushl $0
80108fae:	6a 00                	push   $0x0
  pushl $172
80108fb0:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108fb5:	e9 47 f3 ff ff       	jmp    80108301 <alltraps>

80108fba <vector173>:
.globl vector173
vector173:
  pushl $0
80108fba:	6a 00                	push   $0x0
  pushl $173
80108fbc:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108fc1:	e9 3b f3 ff ff       	jmp    80108301 <alltraps>

80108fc6 <vector174>:
.globl vector174
vector174:
  pushl $0
80108fc6:	6a 00                	push   $0x0
  pushl $174
80108fc8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108fcd:	e9 2f f3 ff ff       	jmp    80108301 <alltraps>

80108fd2 <vector175>:
.globl vector175
vector175:
  pushl $0
80108fd2:	6a 00                	push   $0x0
  pushl $175
80108fd4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108fd9:	e9 23 f3 ff ff       	jmp    80108301 <alltraps>

80108fde <vector176>:
.globl vector176
vector176:
  pushl $0
80108fde:	6a 00                	push   $0x0
  pushl $176
80108fe0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108fe5:	e9 17 f3 ff ff       	jmp    80108301 <alltraps>

80108fea <vector177>:
.globl vector177
vector177:
  pushl $0
80108fea:	6a 00                	push   $0x0
  pushl $177
80108fec:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108ff1:	e9 0b f3 ff ff       	jmp    80108301 <alltraps>

80108ff6 <vector178>:
.globl vector178
vector178:
  pushl $0
80108ff6:	6a 00                	push   $0x0
  pushl $178
80108ff8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108ffd:	e9 ff f2 ff ff       	jmp    80108301 <alltraps>

80109002 <vector179>:
.globl vector179
vector179:
  pushl $0
80109002:	6a 00                	push   $0x0
  pushl $179
80109004:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80109009:	e9 f3 f2 ff ff       	jmp    80108301 <alltraps>

8010900e <vector180>:
.globl vector180
vector180:
  pushl $0
8010900e:	6a 00                	push   $0x0
  pushl $180
80109010:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80109015:	e9 e7 f2 ff ff       	jmp    80108301 <alltraps>

8010901a <vector181>:
.globl vector181
vector181:
  pushl $0
8010901a:	6a 00                	push   $0x0
  pushl $181
8010901c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80109021:	e9 db f2 ff ff       	jmp    80108301 <alltraps>

80109026 <vector182>:
.globl vector182
vector182:
  pushl $0
80109026:	6a 00                	push   $0x0
  pushl $182
80109028:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010902d:	e9 cf f2 ff ff       	jmp    80108301 <alltraps>

80109032 <vector183>:
.globl vector183
vector183:
  pushl $0
80109032:	6a 00                	push   $0x0
  pushl $183
80109034:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80109039:	e9 c3 f2 ff ff       	jmp    80108301 <alltraps>

8010903e <vector184>:
.globl vector184
vector184:
  pushl $0
8010903e:	6a 00                	push   $0x0
  pushl $184
80109040:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80109045:	e9 b7 f2 ff ff       	jmp    80108301 <alltraps>

8010904a <vector185>:
.globl vector185
vector185:
  pushl $0
8010904a:	6a 00                	push   $0x0
  pushl $185
8010904c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80109051:	e9 ab f2 ff ff       	jmp    80108301 <alltraps>

80109056 <vector186>:
.globl vector186
vector186:
  pushl $0
80109056:	6a 00                	push   $0x0
  pushl $186
80109058:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010905d:	e9 9f f2 ff ff       	jmp    80108301 <alltraps>

80109062 <vector187>:
.globl vector187
vector187:
  pushl $0
80109062:	6a 00                	push   $0x0
  pushl $187
80109064:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80109069:	e9 93 f2 ff ff       	jmp    80108301 <alltraps>

8010906e <vector188>:
.globl vector188
vector188:
  pushl $0
8010906e:	6a 00                	push   $0x0
  pushl $188
80109070:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80109075:	e9 87 f2 ff ff       	jmp    80108301 <alltraps>

8010907a <vector189>:
.globl vector189
vector189:
  pushl $0
8010907a:	6a 00                	push   $0x0
  pushl $189
8010907c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80109081:	e9 7b f2 ff ff       	jmp    80108301 <alltraps>

80109086 <vector190>:
.globl vector190
vector190:
  pushl $0
80109086:	6a 00                	push   $0x0
  pushl $190
80109088:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010908d:	e9 6f f2 ff ff       	jmp    80108301 <alltraps>

80109092 <vector191>:
.globl vector191
vector191:
  pushl $0
80109092:	6a 00                	push   $0x0
  pushl $191
80109094:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80109099:	e9 63 f2 ff ff       	jmp    80108301 <alltraps>

8010909e <vector192>:
.globl vector192
vector192:
  pushl $0
8010909e:	6a 00                	push   $0x0
  pushl $192
801090a0:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801090a5:	e9 57 f2 ff ff       	jmp    80108301 <alltraps>

801090aa <vector193>:
.globl vector193
vector193:
  pushl $0
801090aa:	6a 00                	push   $0x0
  pushl $193
801090ac:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801090b1:	e9 4b f2 ff ff       	jmp    80108301 <alltraps>

801090b6 <vector194>:
.globl vector194
vector194:
  pushl $0
801090b6:	6a 00                	push   $0x0
  pushl $194
801090b8:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801090bd:	e9 3f f2 ff ff       	jmp    80108301 <alltraps>

801090c2 <vector195>:
.globl vector195
vector195:
  pushl $0
801090c2:	6a 00                	push   $0x0
  pushl $195
801090c4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801090c9:	e9 33 f2 ff ff       	jmp    80108301 <alltraps>

801090ce <vector196>:
.globl vector196
vector196:
  pushl $0
801090ce:	6a 00                	push   $0x0
  pushl $196
801090d0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801090d5:	e9 27 f2 ff ff       	jmp    80108301 <alltraps>

801090da <vector197>:
.globl vector197
vector197:
  pushl $0
801090da:	6a 00                	push   $0x0
  pushl $197
801090dc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801090e1:	e9 1b f2 ff ff       	jmp    80108301 <alltraps>

801090e6 <vector198>:
.globl vector198
vector198:
  pushl $0
801090e6:	6a 00                	push   $0x0
  pushl $198
801090e8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801090ed:	e9 0f f2 ff ff       	jmp    80108301 <alltraps>

801090f2 <vector199>:
.globl vector199
vector199:
  pushl $0
801090f2:	6a 00                	push   $0x0
  pushl $199
801090f4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801090f9:	e9 03 f2 ff ff       	jmp    80108301 <alltraps>

801090fe <vector200>:
.globl vector200
vector200:
  pushl $0
801090fe:	6a 00                	push   $0x0
  pushl $200
80109100:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80109105:	e9 f7 f1 ff ff       	jmp    80108301 <alltraps>

8010910a <vector201>:
.globl vector201
vector201:
  pushl $0
8010910a:	6a 00                	push   $0x0
  pushl $201
8010910c:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80109111:	e9 eb f1 ff ff       	jmp    80108301 <alltraps>

80109116 <vector202>:
.globl vector202
vector202:
  pushl $0
80109116:	6a 00                	push   $0x0
  pushl $202
80109118:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010911d:	e9 df f1 ff ff       	jmp    80108301 <alltraps>

80109122 <vector203>:
.globl vector203
vector203:
  pushl $0
80109122:	6a 00                	push   $0x0
  pushl $203
80109124:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80109129:	e9 d3 f1 ff ff       	jmp    80108301 <alltraps>

8010912e <vector204>:
.globl vector204
vector204:
  pushl $0
8010912e:	6a 00                	push   $0x0
  pushl $204
80109130:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80109135:	e9 c7 f1 ff ff       	jmp    80108301 <alltraps>

8010913a <vector205>:
.globl vector205
vector205:
  pushl $0
8010913a:	6a 00                	push   $0x0
  pushl $205
8010913c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80109141:	e9 bb f1 ff ff       	jmp    80108301 <alltraps>

80109146 <vector206>:
.globl vector206
vector206:
  pushl $0
80109146:	6a 00                	push   $0x0
  pushl $206
80109148:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010914d:	e9 af f1 ff ff       	jmp    80108301 <alltraps>

80109152 <vector207>:
.globl vector207
vector207:
  pushl $0
80109152:	6a 00                	push   $0x0
  pushl $207
80109154:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80109159:	e9 a3 f1 ff ff       	jmp    80108301 <alltraps>

8010915e <vector208>:
.globl vector208
vector208:
  pushl $0
8010915e:	6a 00                	push   $0x0
  pushl $208
80109160:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80109165:	e9 97 f1 ff ff       	jmp    80108301 <alltraps>

8010916a <vector209>:
.globl vector209
vector209:
  pushl $0
8010916a:	6a 00                	push   $0x0
  pushl $209
8010916c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80109171:	e9 8b f1 ff ff       	jmp    80108301 <alltraps>

80109176 <vector210>:
.globl vector210
vector210:
  pushl $0
80109176:	6a 00                	push   $0x0
  pushl $210
80109178:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010917d:	e9 7f f1 ff ff       	jmp    80108301 <alltraps>

80109182 <vector211>:
.globl vector211
vector211:
  pushl $0
80109182:	6a 00                	push   $0x0
  pushl $211
80109184:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80109189:	e9 73 f1 ff ff       	jmp    80108301 <alltraps>

8010918e <vector212>:
.globl vector212
vector212:
  pushl $0
8010918e:	6a 00                	push   $0x0
  pushl $212
80109190:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80109195:	e9 67 f1 ff ff       	jmp    80108301 <alltraps>

8010919a <vector213>:
.globl vector213
vector213:
  pushl $0
8010919a:	6a 00                	push   $0x0
  pushl $213
8010919c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801091a1:	e9 5b f1 ff ff       	jmp    80108301 <alltraps>

801091a6 <vector214>:
.globl vector214
vector214:
  pushl $0
801091a6:	6a 00                	push   $0x0
  pushl $214
801091a8:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801091ad:	e9 4f f1 ff ff       	jmp    80108301 <alltraps>

801091b2 <vector215>:
.globl vector215
vector215:
  pushl $0
801091b2:	6a 00                	push   $0x0
  pushl $215
801091b4:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801091b9:	e9 43 f1 ff ff       	jmp    80108301 <alltraps>

801091be <vector216>:
.globl vector216
vector216:
  pushl $0
801091be:	6a 00                	push   $0x0
  pushl $216
801091c0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801091c5:	e9 37 f1 ff ff       	jmp    80108301 <alltraps>

801091ca <vector217>:
.globl vector217
vector217:
  pushl $0
801091ca:	6a 00                	push   $0x0
  pushl $217
801091cc:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801091d1:	e9 2b f1 ff ff       	jmp    80108301 <alltraps>

801091d6 <vector218>:
.globl vector218
vector218:
  pushl $0
801091d6:	6a 00                	push   $0x0
  pushl $218
801091d8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801091dd:	e9 1f f1 ff ff       	jmp    80108301 <alltraps>

801091e2 <vector219>:
.globl vector219
vector219:
  pushl $0
801091e2:	6a 00                	push   $0x0
  pushl $219
801091e4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801091e9:	e9 13 f1 ff ff       	jmp    80108301 <alltraps>

801091ee <vector220>:
.globl vector220
vector220:
  pushl $0
801091ee:	6a 00                	push   $0x0
  pushl $220
801091f0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801091f5:	e9 07 f1 ff ff       	jmp    80108301 <alltraps>

801091fa <vector221>:
.globl vector221
vector221:
  pushl $0
801091fa:	6a 00                	push   $0x0
  pushl $221
801091fc:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80109201:	e9 fb f0 ff ff       	jmp    80108301 <alltraps>

80109206 <vector222>:
.globl vector222
vector222:
  pushl $0
80109206:	6a 00                	push   $0x0
  pushl $222
80109208:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010920d:	e9 ef f0 ff ff       	jmp    80108301 <alltraps>

80109212 <vector223>:
.globl vector223
vector223:
  pushl $0
80109212:	6a 00                	push   $0x0
  pushl $223
80109214:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80109219:	e9 e3 f0 ff ff       	jmp    80108301 <alltraps>

8010921e <vector224>:
.globl vector224
vector224:
  pushl $0
8010921e:	6a 00                	push   $0x0
  pushl $224
80109220:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80109225:	e9 d7 f0 ff ff       	jmp    80108301 <alltraps>

8010922a <vector225>:
.globl vector225
vector225:
  pushl $0
8010922a:	6a 00                	push   $0x0
  pushl $225
8010922c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80109231:	e9 cb f0 ff ff       	jmp    80108301 <alltraps>

80109236 <vector226>:
.globl vector226
vector226:
  pushl $0
80109236:	6a 00                	push   $0x0
  pushl $226
80109238:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010923d:	e9 bf f0 ff ff       	jmp    80108301 <alltraps>

80109242 <vector227>:
.globl vector227
vector227:
  pushl $0
80109242:	6a 00                	push   $0x0
  pushl $227
80109244:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80109249:	e9 b3 f0 ff ff       	jmp    80108301 <alltraps>

8010924e <vector228>:
.globl vector228
vector228:
  pushl $0
8010924e:	6a 00                	push   $0x0
  pushl $228
80109250:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80109255:	e9 a7 f0 ff ff       	jmp    80108301 <alltraps>

8010925a <vector229>:
.globl vector229
vector229:
  pushl $0
8010925a:	6a 00                	push   $0x0
  pushl $229
8010925c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80109261:	e9 9b f0 ff ff       	jmp    80108301 <alltraps>

80109266 <vector230>:
.globl vector230
vector230:
  pushl $0
80109266:	6a 00                	push   $0x0
  pushl $230
80109268:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010926d:	e9 8f f0 ff ff       	jmp    80108301 <alltraps>

80109272 <vector231>:
.globl vector231
vector231:
  pushl $0
80109272:	6a 00                	push   $0x0
  pushl $231
80109274:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80109279:	e9 83 f0 ff ff       	jmp    80108301 <alltraps>

8010927e <vector232>:
.globl vector232
vector232:
  pushl $0
8010927e:	6a 00                	push   $0x0
  pushl $232
80109280:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80109285:	e9 77 f0 ff ff       	jmp    80108301 <alltraps>

8010928a <vector233>:
.globl vector233
vector233:
  pushl $0
8010928a:	6a 00                	push   $0x0
  pushl $233
8010928c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80109291:	e9 6b f0 ff ff       	jmp    80108301 <alltraps>

80109296 <vector234>:
.globl vector234
vector234:
  pushl $0
80109296:	6a 00                	push   $0x0
  pushl $234
80109298:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010929d:	e9 5f f0 ff ff       	jmp    80108301 <alltraps>

801092a2 <vector235>:
.globl vector235
vector235:
  pushl $0
801092a2:	6a 00                	push   $0x0
  pushl $235
801092a4:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801092a9:	e9 53 f0 ff ff       	jmp    80108301 <alltraps>

801092ae <vector236>:
.globl vector236
vector236:
  pushl $0
801092ae:	6a 00                	push   $0x0
  pushl $236
801092b0:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801092b5:	e9 47 f0 ff ff       	jmp    80108301 <alltraps>

801092ba <vector237>:
.globl vector237
vector237:
  pushl $0
801092ba:	6a 00                	push   $0x0
  pushl $237
801092bc:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801092c1:	e9 3b f0 ff ff       	jmp    80108301 <alltraps>

801092c6 <vector238>:
.globl vector238
vector238:
  pushl $0
801092c6:	6a 00                	push   $0x0
  pushl $238
801092c8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801092cd:	e9 2f f0 ff ff       	jmp    80108301 <alltraps>

801092d2 <vector239>:
.globl vector239
vector239:
  pushl $0
801092d2:	6a 00                	push   $0x0
  pushl $239
801092d4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801092d9:	e9 23 f0 ff ff       	jmp    80108301 <alltraps>

801092de <vector240>:
.globl vector240
vector240:
  pushl $0
801092de:	6a 00                	push   $0x0
  pushl $240
801092e0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801092e5:	e9 17 f0 ff ff       	jmp    80108301 <alltraps>

801092ea <vector241>:
.globl vector241
vector241:
  pushl $0
801092ea:	6a 00                	push   $0x0
  pushl $241
801092ec:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801092f1:	e9 0b f0 ff ff       	jmp    80108301 <alltraps>

801092f6 <vector242>:
.globl vector242
vector242:
  pushl $0
801092f6:	6a 00                	push   $0x0
  pushl $242
801092f8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801092fd:	e9 ff ef ff ff       	jmp    80108301 <alltraps>

80109302 <vector243>:
.globl vector243
vector243:
  pushl $0
80109302:	6a 00                	push   $0x0
  pushl $243
80109304:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80109309:	e9 f3 ef ff ff       	jmp    80108301 <alltraps>

8010930e <vector244>:
.globl vector244
vector244:
  pushl $0
8010930e:	6a 00                	push   $0x0
  pushl $244
80109310:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80109315:	e9 e7 ef ff ff       	jmp    80108301 <alltraps>

8010931a <vector245>:
.globl vector245
vector245:
  pushl $0
8010931a:	6a 00                	push   $0x0
  pushl $245
8010931c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80109321:	e9 db ef ff ff       	jmp    80108301 <alltraps>

80109326 <vector246>:
.globl vector246
vector246:
  pushl $0
80109326:	6a 00                	push   $0x0
  pushl $246
80109328:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010932d:	e9 cf ef ff ff       	jmp    80108301 <alltraps>

80109332 <vector247>:
.globl vector247
vector247:
  pushl $0
80109332:	6a 00                	push   $0x0
  pushl $247
80109334:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80109339:	e9 c3 ef ff ff       	jmp    80108301 <alltraps>

8010933e <vector248>:
.globl vector248
vector248:
  pushl $0
8010933e:	6a 00                	push   $0x0
  pushl $248
80109340:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80109345:	e9 b7 ef ff ff       	jmp    80108301 <alltraps>

8010934a <vector249>:
.globl vector249
vector249:
  pushl $0
8010934a:	6a 00                	push   $0x0
  pushl $249
8010934c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80109351:	e9 ab ef ff ff       	jmp    80108301 <alltraps>

80109356 <vector250>:
.globl vector250
vector250:
  pushl $0
80109356:	6a 00                	push   $0x0
  pushl $250
80109358:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010935d:	e9 9f ef ff ff       	jmp    80108301 <alltraps>

80109362 <vector251>:
.globl vector251
vector251:
  pushl $0
80109362:	6a 00                	push   $0x0
  pushl $251
80109364:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80109369:	e9 93 ef ff ff       	jmp    80108301 <alltraps>

8010936e <vector252>:
.globl vector252
vector252:
  pushl $0
8010936e:	6a 00                	push   $0x0
  pushl $252
80109370:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80109375:	e9 87 ef ff ff       	jmp    80108301 <alltraps>

8010937a <vector253>:
.globl vector253
vector253:
  pushl $0
8010937a:	6a 00                	push   $0x0
  pushl $253
8010937c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80109381:	e9 7b ef ff ff       	jmp    80108301 <alltraps>

80109386 <vector254>:
.globl vector254
vector254:
  pushl $0
80109386:	6a 00                	push   $0x0
  pushl $254
80109388:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010938d:	e9 6f ef ff ff       	jmp    80108301 <alltraps>

80109392 <vector255>:
.globl vector255
vector255:
  pushl $0
80109392:	6a 00                	push   $0x0
  pushl $255
80109394:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109399:	e9 63 ef ff ff       	jmp    80108301 <alltraps>

8010939e <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010939e:	55                   	push   %ebp
8010939f:	89 e5                	mov    %esp,%ebp
801093a1:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801093a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801093a7:	83 e8 01             	sub    $0x1,%eax
801093aa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801093ae:	8b 45 08             	mov    0x8(%ebp),%eax
801093b1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801093b5:	8b 45 08             	mov    0x8(%ebp),%eax
801093b8:	c1 e8 10             	shr    $0x10,%eax
801093bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801093bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801093c2:	0f 01 10             	lgdtl  (%eax)
}
801093c5:	90                   	nop
801093c6:	c9                   	leave  
801093c7:	c3                   	ret    

801093c8 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801093c8:	55                   	push   %ebp
801093c9:	89 e5                	mov    %esp,%ebp
801093cb:	83 ec 04             	sub    $0x4,%esp
801093ce:	8b 45 08             	mov    0x8(%ebp),%eax
801093d1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801093d5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801093d9:	0f 00 d8             	ltr    %ax
}
801093dc:	90                   	nop
801093dd:	c9                   	leave  
801093de:	c3                   	ret    

801093df <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801093df:	55                   	push   %ebp
801093e0:	89 e5                	mov    %esp,%ebp
801093e2:	83 ec 04             	sub    $0x4,%esp
801093e5:	8b 45 08             	mov    0x8(%ebp),%eax
801093e8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801093ec:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801093f0:	8e e8                	mov    %eax,%gs
}
801093f2:	90                   	nop
801093f3:	c9                   	leave  
801093f4:	c3                   	ret    

801093f5 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801093f5:	55                   	push   %ebp
801093f6:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801093f8:	8b 45 08             	mov    0x8(%ebp),%eax
801093fb:	0f 22 d8             	mov    %eax,%cr3
}
801093fe:	90                   	nop
801093ff:	5d                   	pop    %ebp
80109400:	c3                   	ret    

80109401 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80109401:	55                   	push   %ebp
80109402:	89 e5                	mov    %esp,%ebp
80109404:	8b 45 08             	mov    0x8(%ebp),%eax
80109407:	05 00 00 00 80       	add    $0x80000000,%eax
8010940c:	5d                   	pop    %ebp
8010940d:	c3                   	ret    

8010940e <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010940e:	55                   	push   %ebp
8010940f:	89 e5                	mov    %esp,%ebp
80109411:	8b 45 08             	mov    0x8(%ebp),%eax
80109414:	05 00 00 00 80       	add    $0x80000000,%eax
80109419:	5d                   	pop    %ebp
8010941a:	c3                   	ret    

8010941b <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010941b:	55                   	push   %ebp
8010941c:	89 e5                	mov    %esp,%ebp
8010941e:	53                   	push   %ebx
8010941f:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80109422:	e8 af a0 ff ff       	call   801034d6 <cpunum>
80109427:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010942d:	05 a0 43 11 80       	add    $0x801143a0,%eax
80109432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80109435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109438:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010943e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109441:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80109447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010944a:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010944e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109451:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109455:	83 e2 f0             	and    $0xfffffff0,%edx
80109458:	83 ca 0a             	or     $0xa,%edx
8010945b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010945e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109461:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109465:	83 ca 10             	or     $0x10,%edx
80109468:	88 50 7d             	mov    %dl,0x7d(%eax)
8010946b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010946e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109472:	83 e2 9f             	and    $0xffffff9f,%edx
80109475:	88 50 7d             	mov    %dl,0x7d(%eax)
80109478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010947b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010947f:	83 ca 80             	or     $0xffffff80,%edx
80109482:	88 50 7d             	mov    %dl,0x7d(%eax)
80109485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109488:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010948c:	83 ca 0f             	or     $0xf,%edx
8010948f:	88 50 7e             	mov    %dl,0x7e(%eax)
80109492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109495:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109499:	83 e2 ef             	and    $0xffffffef,%edx
8010949c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010949f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801094a6:	83 e2 df             	and    $0xffffffdf,%edx
801094a9:	88 50 7e             	mov    %dl,0x7e(%eax)
801094ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094af:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801094b3:	83 ca 40             	or     $0x40,%edx
801094b6:	88 50 7e             	mov    %dl,0x7e(%eax)
801094b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801094c0:	83 ca 80             	or     $0xffffff80,%edx
801094c3:	88 50 7e             	mov    %dl,0x7e(%eax)
801094c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094c9:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801094cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d0:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801094d7:	ff ff 
801094d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094dc:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801094e3:	00 00 
801094e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e8:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801094ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801094f9:	83 e2 f0             	and    $0xfffffff0,%edx
801094fc:	83 ca 02             	or     $0x2,%edx
801094ff:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109508:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010950f:	83 ca 10             	or     $0x10,%edx
80109512:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109522:	83 e2 9f             	and    $0xffffff9f,%edx
80109525:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010952b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010952e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109535:	83 ca 80             	or     $0xffffff80,%edx
80109538:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010953e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109541:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109548:	83 ca 0f             	or     $0xf,%edx
8010954b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109554:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010955b:	83 e2 ef             	and    $0xffffffef,%edx
8010955e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109567:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010956e:	83 e2 df             	and    $0xffffffdf,%edx
80109571:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010957a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109581:	83 ca 40             	or     $0x40,%edx
80109584:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010958a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010958d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109594:	83 ca 80             	or     $0xffffff80,%edx
80109597:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010959d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a0:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801095a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095aa:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801095b1:	ff ff 
801095b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b6:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801095bd:	00 00 
801095bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c2:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801095c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095cc:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801095d3:	83 e2 f0             	and    $0xfffffff0,%edx
801095d6:	83 ca 0a             	or     $0xa,%edx
801095d9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801095df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801095e9:	83 ca 10             	or     $0x10,%edx
801095ec:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801095f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801095fc:	83 ca 60             	or     $0x60,%edx
801095ff:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109608:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010960f:	83 ca 80             	or     $0xffffff80,%edx
80109612:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010961b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109622:	83 ca 0f             	or     $0xf,%edx
80109625:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010962b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010962e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109635:	83 e2 ef             	and    $0xffffffef,%edx
80109638:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010963e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109641:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109648:	83 e2 df             	and    $0xffffffdf,%edx
8010964b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109654:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010965b:	83 ca 40             	or     $0x40,%edx
8010965e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109667:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010966e:	83 ca 80             	or     $0xffffff80,%edx
80109671:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010967a:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80109681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109684:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010968b:	ff ff 
8010968d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109690:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109697:	00 00 
80109699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010969c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801096a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a6:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801096ad:	83 e2 f0             	and    $0xfffffff0,%edx
801096b0:	83 ca 02             	or     $0x2,%edx
801096b3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801096b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096bc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801096c3:	83 ca 10             	or     $0x10,%edx
801096c6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801096cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096cf:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801096d6:	83 ca 60             	or     $0x60,%edx
801096d9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801096df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096e2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801096e9:	83 ca 80             	or     $0xffffff80,%edx
801096ec:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801096f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801096fc:	83 ca 0f             	or     $0xf,%edx
801096ff:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109708:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010970f:	83 e2 ef             	and    $0xffffffef,%edx
80109712:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109722:	83 e2 df             	and    $0xffffffdf,%edx
80109725:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010972b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010972e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109735:	83 ca 40             	or     $0x40,%edx
80109738:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010973e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109741:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109748:	83 ca 80             	or     $0xffffff80,%edx
8010974b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109754:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010975b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010975e:	05 b4 00 00 00       	add    $0xb4,%eax
80109763:	89 c3                	mov    %eax,%ebx
80109765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109768:	05 b4 00 00 00       	add    $0xb4,%eax
8010976d:	c1 e8 10             	shr    $0x10,%eax
80109770:	89 c2                	mov    %eax,%edx
80109772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109775:	05 b4 00 00 00       	add    $0xb4,%eax
8010977a:	c1 e8 18             	shr    $0x18,%eax
8010977d:	89 c1                	mov    %eax,%ecx
8010977f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109782:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109789:	00 00 
8010978b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010978e:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109798:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010979e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a1:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801097a8:	83 e2 f0             	and    $0xfffffff0,%edx
801097ab:	83 ca 02             	or     $0x2,%edx
801097ae:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801097b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097b7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801097be:	83 ca 10             	or     $0x10,%edx
801097c1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801097c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ca:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801097d1:	83 e2 9f             	and    $0xffffff9f,%edx
801097d4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801097da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097dd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801097e4:	83 ca 80             	or     $0xffffff80,%edx
801097e7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801097ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097f0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801097f7:	83 e2 f0             	and    $0xfffffff0,%edx
801097fa:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109803:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010980a:	83 e2 ef             	and    $0xffffffef,%edx
8010980d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109816:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010981d:	83 e2 df             	and    $0xffffffdf,%edx
80109820:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109829:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109830:	83 ca 40             	or     $0x40,%edx
80109833:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010983c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109843:	83 ca 80             	or     $0xffffff80,%edx
80109846:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010984c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010984f:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109858:	83 c0 70             	add    $0x70,%eax
8010985b:	83 ec 08             	sub    $0x8,%esp
8010985e:	6a 38                	push   $0x38
80109860:	50                   	push   %eax
80109861:	e8 38 fb ff ff       	call   8010939e <lgdt>
80109866:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109869:	83 ec 0c             	sub    $0xc,%esp
8010986c:	6a 18                	push   $0x18
8010986e:	e8 6c fb ff ff       	call   801093df <loadgs>
80109873:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109879:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010987f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109886:	00 00 00 00 
}
8010988a:	90                   	nop
8010988b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010988e:	c9                   	leave  
8010988f:	c3                   	ret    

80109890 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109890:	55                   	push   %ebp
80109891:	89 e5                	mov    %esp,%ebp
80109893:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109896:	8b 45 0c             	mov    0xc(%ebp),%eax
80109899:	c1 e8 16             	shr    $0x16,%eax
8010989c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801098a3:	8b 45 08             	mov    0x8(%ebp),%eax
801098a6:	01 d0                	add    %edx,%eax
801098a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801098ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098ae:	8b 00                	mov    (%eax),%eax
801098b0:	83 e0 01             	and    $0x1,%eax
801098b3:	85 c0                	test   %eax,%eax
801098b5:	74 18                	je     801098cf <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801098b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098ba:	8b 00                	mov    (%eax),%eax
801098bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801098c1:	50                   	push   %eax
801098c2:	e8 47 fb ff ff       	call   8010940e <p2v>
801098c7:	83 c4 04             	add    $0x4,%esp
801098ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
801098cd:	eb 48                	jmp    80109917 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801098cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801098d3:	74 0e                	je     801098e3 <walkpgdir+0x53>
801098d5:	e8 96 98 ff ff       	call   80103170 <kalloc>
801098da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801098dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801098e1:	75 07                	jne    801098ea <walkpgdir+0x5a>
      return 0;
801098e3:	b8 00 00 00 00       	mov    $0x0,%eax
801098e8:	eb 44                	jmp    8010992e <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801098ea:	83 ec 04             	sub    $0x4,%esp
801098ed:	68 00 10 00 00       	push   $0x1000
801098f2:	6a 00                	push   $0x0
801098f4:	ff 75 f4             	pushl  -0xc(%ebp)
801098f7:	e8 34 d2 ff ff       	call   80106b30 <memset>
801098fc:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801098ff:	83 ec 0c             	sub    $0xc,%esp
80109902:	ff 75 f4             	pushl  -0xc(%ebp)
80109905:	e8 f7 fa ff ff       	call   80109401 <v2p>
8010990a:	83 c4 10             	add    $0x10,%esp
8010990d:	83 c8 07             	or     $0x7,%eax
80109910:	89 c2                	mov    %eax,%edx
80109912:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109915:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80109917:	8b 45 0c             	mov    0xc(%ebp),%eax
8010991a:	c1 e8 0c             	shr    $0xc,%eax
8010991d:	25 ff 03 00 00       	and    $0x3ff,%eax
80109922:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010992c:	01 d0                	add    %edx,%eax
}
8010992e:	c9                   	leave  
8010992f:	c3                   	ret    

80109930 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109930:	55                   	push   %ebp
80109931:	89 e5                	mov    %esp,%ebp
80109933:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80109936:	8b 45 0c             	mov    0xc(%ebp),%eax
80109939:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010993e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109941:	8b 55 0c             	mov    0xc(%ebp),%edx
80109944:	8b 45 10             	mov    0x10(%ebp),%eax
80109947:	01 d0                	add    %edx,%eax
80109949:	83 e8 01             	sub    $0x1,%eax
8010994c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109954:	83 ec 04             	sub    $0x4,%esp
80109957:	6a 01                	push   $0x1
80109959:	ff 75 f4             	pushl  -0xc(%ebp)
8010995c:	ff 75 08             	pushl  0x8(%ebp)
8010995f:	e8 2c ff ff ff       	call   80109890 <walkpgdir>
80109964:	83 c4 10             	add    $0x10,%esp
80109967:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010996a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010996e:	75 07                	jne    80109977 <mappages+0x47>
      return -1;
80109970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109975:	eb 47                	jmp    801099be <mappages+0x8e>
    if(*pte & PTE_P)
80109977:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010997a:	8b 00                	mov    (%eax),%eax
8010997c:	83 e0 01             	and    $0x1,%eax
8010997f:	85 c0                	test   %eax,%eax
80109981:	74 0d                	je     80109990 <mappages+0x60>
      panic("remap");
80109983:	83 ec 0c             	sub    $0xc,%esp
80109986:	68 80 a9 10 80       	push   $0x8010a980
8010998b:	e8 d6 6b ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109990:	8b 45 18             	mov    0x18(%ebp),%eax
80109993:	0b 45 14             	or     0x14(%ebp),%eax
80109996:	83 c8 01             	or     $0x1,%eax
80109999:	89 c2                	mov    %eax,%edx
8010999b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010999e:	89 10                	mov    %edx,(%eax)
    if(a == last)
801099a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801099a6:	74 10                	je     801099b8 <mappages+0x88>
      break;
    a += PGSIZE;
801099a8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801099af:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801099b6:	eb 9c                	jmp    80109954 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801099b8:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801099b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801099be:	c9                   	leave  
801099bf:	c3                   	ret    

801099c0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801099c0:	55                   	push   %ebp
801099c1:	89 e5                	mov    %esp,%ebp
801099c3:	53                   	push   %ebx
801099c4:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801099c7:	e8 a4 97 ff ff       	call   80103170 <kalloc>
801099cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801099cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801099d3:	75 0a                	jne    801099df <setupkvm+0x1f>
    return 0;
801099d5:	b8 00 00 00 00       	mov    $0x0,%eax
801099da:	e9 8e 00 00 00       	jmp    80109a6d <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801099df:	83 ec 04             	sub    $0x4,%esp
801099e2:	68 00 10 00 00       	push   $0x1000
801099e7:	6a 00                	push   $0x0
801099e9:	ff 75 f0             	pushl  -0x10(%ebp)
801099ec:	e8 3f d1 ff ff       	call   80106b30 <memset>
801099f1:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801099f4:	83 ec 0c             	sub    $0xc,%esp
801099f7:	68 00 00 00 0e       	push   $0xe000000
801099fc:	e8 0d fa ff ff       	call   8010940e <p2v>
80109a01:	83 c4 10             	add    $0x10,%esp
80109a04:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109a09:	76 0d                	jbe    80109a18 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109a0b:	83 ec 0c             	sub    $0xc,%esp
80109a0e:	68 86 a9 10 80       	push   $0x8010a986
80109a13:	e8 4e 6b ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109a18:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
80109a1f:	eb 40                	jmp    80109a61 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a24:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a2a:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a30:	8b 58 08             	mov    0x8(%eax),%ebx
80109a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a36:	8b 40 04             	mov    0x4(%eax),%eax
80109a39:	29 c3                	sub    %eax,%ebx
80109a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a3e:	8b 00                	mov    (%eax),%eax
80109a40:	83 ec 0c             	sub    $0xc,%esp
80109a43:	51                   	push   %ecx
80109a44:	52                   	push   %edx
80109a45:	53                   	push   %ebx
80109a46:	50                   	push   %eax
80109a47:	ff 75 f0             	pushl  -0x10(%ebp)
80109a4a:	e8 e1 fe ff ff       	call   80109930 <mappages>
80109a4f:	83 c4 20             	add    $0x20,%esp
80109a52:	85 c0                	test   %eax,%eax
80109a54:	79 07                	jns    80109a5d <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109a56:	b8 00 00 00 00       	mov    $0x0,%eax
80109a5b:	eb 10                	jmp    80109a6d <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109a5d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109a61:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
80109a68:	72 b7                	jb     80109a21 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109a6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109a70:	c9                   	leave  
80109a71:	c3                   	ret    

80109a72 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109a72:	55                   	push   %ebp
80109a73:	89 e5                	mov    %esp,%ebp
80109a75:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109a78:	e8 43 ff ff ff       	call   801099c0 <setupkvm>
80109a7d:	a3 58 79 11 80       	mov    %eax,0x80117958
  switchkvm();
80109a82:	e8 03 00 00 00       	call   80109a8a <switchkvm>
}
80109a87:	90                   	nop
80109a88:	c9                   	leave  
80109a89:	c3                   	ret    

80109a8a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109a8a:	55                   	push   %ebp
80109a8b:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109a8d:	a1 58 79 11 80       	mov    0x80117958,%eax
80109a92:	50                   	push   %eax
80109a93:	e8 69 f9 ff ff       	call   80109401 <v2p>
80109a98:	83 c4 04             	add    $0x4,%esp
80109a9b:	50                   	push   %eax
80109a9c:	e8 54 f9 ff ff       	call   801093f5 <lcr3>
80109aa1:	83 c4 04             	add    $0x4,%esp
}
80109aa4:	90                   	nop
80109aa5:	c9                   	leave  
80109aa6:	c3                   	ret    

80109aa7 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109aa7:	55                   	push   %ebp
80109aa8:	89 e5                	mov    %esp,%ebp
80109aaa:	56                   	push   %esi
80109aab:	53                   	push   %ebx
  pushcli();
80109aac:	e8 79 cf ff ff       	call   80106a2a <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109ab1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109ab7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109abe:	83 c2 08             	add    $0x8,%edx
80109ac1:	89 d6                	mov    %edx,%esi
80109ac3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109aca:	83 c2 08             	add    $0x8,%edx
80109acd:	c1 ea 10             	shr    $0x10,%edx
80109ad0:	89 d3                	mov    %edx,%ebx
80109ad2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109ad9:	83 c2 08             	add    $0x8,%edx
80109adc:	c1 ea 18             	shr    $0x18,%edx
80109adf:	89 d1                	mov    %edx,%ecx
80109ae1:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109ae8:	67 00 
80109aea:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109af1:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109af7:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109afe:	83 e2 f0             	and    $0xfffffff0,%edx
80109b01:	83 ca 09             	or     $0x9,%edx
80109b04:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109b0a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109b11:	83 ca 10             	or     $0x10,%edx
80109b14:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109b1a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109b21:	83 e2 9f             	and    $0xffffff9f,%edx
80109b24:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109b2a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109b31:	83 ca 80             	or     $0xffffff80,%edx
80109b34:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109b3a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109b41:	83 e2 f0             	and    $0xfffffff0,%edx
80109b44:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109b4a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109b51:	83 e2 ef             	and    $0xffffffef,%edx
80109b54:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109b5a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109b61:	83 e2 df             	and    $0xffffffdf,%edx
80109b64:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109b6a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109b71:	83 ca 40             	or     $0x40,%edx
80109b74:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109b7a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109b81:	83 e2 7f             	and    $0x7f,%edx
80109b84:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109b8a:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109b90:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109b96:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109b9d:	83 e2 ef             	and    $0xffffffef,%edx
80109ba0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109ba6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109bac:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109bb2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109bb8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109bbf:	8b 52 08             	mov    0x8(%edx),%edx
80109bc2:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109bc8:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109bcb:	83 ec 0c             	sub    $0xc,%esp
80109bce:	6a 30                	push   $0x30
80109bd0:	e8 f3 f7 ff ff       	call   801093c8 <ltr>
80109bd5:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80109bdb:	8b 40 04             	mov    0x4(%eax),%eax
80109bde:	85 c0                	test   %eax,%eax
80109be0:	75 0d                	jne    80109bef <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109be2:	83 ec 0c             	sub    $0xc,%esp
80109be5:	68 97 a9 10 80       	push   $0x8010a997
80109bea:	e8 77 69 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109bef:	8b 45 08             	mov    0x8(%ebp),%eax
80109bf2:	8b 40 04             	mov    0x4(%eax),%eax
80109bf5:	83 ec 0c             	sub    $0xc,%esp
80109bf8:	50                   	push   %eax
80109bf9:	e8 03 f8 ff ff       	call   80109401 <v2p>
80109bfe:	83 c4 10             	add    $0x10,%esp
80109c01:	83 ec 0c             	sub    $0xc,%esp
80109c04:	50                   	push   %eax
80109c05:	e8 eb f7 ff ff       	call   801093f5 <lcr3>
80109c0a:	83 c4 10             	add    $0x10,%esp
  popcli();
80109c0d:	e8 5d ce ff ff       	call   80106a6f <popcli>
}
80109c12:	90                   	nop
80109c13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109c16:	5b                   	pop    %ebx
80109c17:	5e                   	pop    %esi
80109c18:	5d                   	pop    %ebp
80109c19:	c3                   	ret    

80109c1a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109c1a:	55                   	push   %ebp
80109c1b:	89 e5                	mov    %esp,%ebp
80109c1d:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109c20:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109c27:	76 0d                	jbe    80109c36 <inituvm+0x1c>
    panic("inituvm: more than a page");
80109c29:	83 ec 0c             	sub    $0xc,%esp
80109c2c:	68 ab a9 10 80       	push   $0x8010a9ab
80109c31:	e8 30 69 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109c36:	e8 35 95 ff ff       	call   80103170 <kalloc>
80109c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109c3e:	83 ec 04             	sub    $0x4,%esp
80109c41:	68 00 10 00 00       	push   $0x1000
80109c46:	6a 00                	push   $0x0
80109c48:	ff 75 f4             	pushl  -0xc(%ebp)
80109c4b:	e8 e0 ce ff ff       	call   80106b30 <memset>
80109c50:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109c53:	83 ec 0c             	sub    $0xc,%esp
80109c56:	ff 75 f4             	pushl  -0xc(%ebp)
80109c59:	e8 a3 f7 ff ff       	call   80109401 <v2p>
80109c5e:	83 c4 10             	add    $0x10,%esp
80109c61:	83 ec 0c             	sub    $0xc,%esp
80109c64:	6a 06                	push   $0x6
80109c66:	50                   	push   %eax
80109c67:	68 00 10 00 00       	push   $0x1000
80109c6c:	6a 00                	push   $0x0
80109c6e:	ff 75 08             	pushl  0x8(%ebp)
80109c71:	e8 ba fc ff ff       	call   80109930 <mappages>
80109c76:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109c79:	83 ec 04             	sub    $0x4,%esp
80109c7c:	ff 75 10             	pushl  0x10(%ebp)
80109c7f:	ff 75 0c             	pushl  0xc(%ebp)
80109c82:	ff 75 f4             	pushl  -0xc(%ebp)
80109c85:	e8 65 cf ff ff       	call   80106bef <memmove>
80109c8a:	83 c4 10             	add    $0x10,%esp
}
80109c8d:	90                   	nop
80109c8e:	c9                   	leave  
80109c8f:	c3                   	ret    

80109c90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109c90:	55                   	push   %ebp
80109c91:	89 e5                	mov    %esp,%ebp
80109c93:	53                   	push   %ebx
80109c94:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c9a:	25 ff 0f 00 00       	and    $0xfff,%eax
80109c9f:	85 c0                	test   %eax,%eax
80109ca1:	74 0d                	je     80109cb0 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109ca3:	83 ec 0c             	sub    $0xc,%esp
80109ca6:	68 c8 a9 10 80       	push   $0x8010a9c8
80109cab:	e8 b6 68 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109cb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109cb7:	e9 95 00 00 00       	jmp    80109d51 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
80109cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cc2:	01 d0                	add    %edx,%eax
80109cc4:	83 ec 04             	sub    $0x4,%esp
80109cc7:	6a 00                	push   $0x0
80109cc9:	50                   	push   %eax
80109cca:	ff 75 08             	pushl  0x8(%ebp)
80109ccd:	e8 be fb ff ff       	call   80109890 <walkpgdir>
80109cd2:	83 c4 10             	add    $0x10,%esp
80109cd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109cd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109cdc:	75 0d                	jne    80109ceb <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109cde:	83 ec 0c             	sub    $0xc,%esp
80109ce1:	68 eb a9 10 80       	push   $0x8010a9eb
80109ce6:	e8 7b 68 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cee:	8b 00                	mov    (%eax),%eax
80109cf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109cf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109cf8:	8b 45 18             	mov    0x18(%ebp),%eax
80109cfb:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109cfe:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109d03:	77 0b                	ja     80109d10 <loaduvm+0x80>
      n = sz - i;
80109d05:	8b 45 18             	mov    0x18(%ebp),%eax
80109d08:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109d0e:	eb 07                	jmp    80109d17 <loaduvm+0x87>
    else
      n = PGSIZE;
80109d10:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109d17:	8b 55 14             	mov    0x14(%ebp),%edx
80109d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d1d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109d20:	83 ec 0c             	sub    $0xc,%esp
80109d23:	ff 75 e8             	pushl  -0x18(%ebp)
80109d26:	e8 e3 f6 ff ff       	call   8010940e <p2v>
80109d2b:	83 c4 10             	add    $0x10,%esp
80109d2e:	ff 75 f0             	pushl  -0x10(%ebp)
80109d31:	53                   	push   %ebx
80109d32:	50                   	push   %eax
80109d33:	ff 75 10             	pushl  0x10(%ebp)
80109d36:	e8 a7 86 ff ff       	call   801023e2 <readi>
80109d3b:	83 c4 10             	add    $0x10,%esp
80109d3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109d41:	74 07                	je     80109d4a <loaduvm+0xba>
      return -1;
80109d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109d48:	eb 18                	jmp    80109d62 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109d4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d54:	3b 45 18             	cmp    0x18(%ebp),%eax
80109d57:	0f 82 5f ff ff ff    	jb     80109cbc <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109d65:	c9                   	leave  
80109d66:	c3                   	ret    

80109d67 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109d67:	55                   	push   %ebp
80109d68:	89 e5                	mov    %esp,%ebp
80109d6a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109d6d:	8b 45 10             	mov    0x10(%ebp),%eax
80109d70:	85 c0                	test   %eax,%eax
80109d72:	79 0a                	jns    80109d7e <allocuvm+0x17>
    return 0;
80109d74:	b8 00 00 00 00       	mov    $0x0,%eax
80109d79:	e9 b0 00 00 00       	jmp    80109e2e <allocuvm+0xc7>
  if(newsz < oldsz)
80109d7e:	8b 45 10             	mov    0x10(%ebp),%eax
80109d81:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109d84:	73 08                	jae    80109d8e <allocuvm+0x27>
    return oldsz;
80109d86:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d89:	e9 a0 00 00 00       	jmp    80109e2e <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d91:	05 ff 0f 00 00       	add    $0xfff,%eax
80109d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109d9e:	eb 7f                	jmp    80109e1f <allocuvm+0xb8>
    mem = kalloc();
80109da0:	e8 cb 93 ff ff       	call   80103170 <kalloc>
80109da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109da8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109dac:	75 2b                	jne    80109dd9 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109dae:	83 ec 0c             	sub    $0xc,%esp
80109db1:	68 09 aa 10 80       	push   $0x8010aa09
80109db6:	e8 0b 66 ff ff       	call   801003c6 <cprintf>
80109dbb:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109dbe:	83 ec 04             	sub    $0x4,%esp
80109dc1:	ff 75 0c             	pushl  0xc(%ebp)
80109dc4:	ff 75 10             	pushl  0x10(%ebp)
80109dc7:	ff 75 08             	pushl  0x8(%ebp)
80109dca:	e8 61 00 00 00       	call   80109e30 <deallocuvm>
80109dcf:	83 c4 10             	add    $0x10,%esp
      return 0;
80109dd2:	b8 00 00 00 00       	mov    $0x0,%eax
80109dd7:	eb 55                	jmp    80109e2e <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109dd9:	83 ec 04             	sub    $0x4,%esp
80109ddc:	68 00 10 00 00       	push   $0x1000
80109de1:	6a 00                	push   $0x0
80109de3:	ff 75 f0             	pushl  -0x10(%ebp)
80109de6:	e8 45 cd ff ff       	call   80106b30 <memset>
80109deb:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109dee:	83 ec 0c             	sub    $0xc,%esp
80109df1:	ff 75 f0             	pushl  -0x10(%ebp)
80109df4:	e8 08 f6 ff ff       	call   80109401 <v2p>
80109df9:	83 c4 10             	add    $0x10,%esp
80109dfc:	89 c2                	mov    %eax,%edx
80109dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e01:	83 ec 0c             	sub    $0xc,%esp
80109e04:	6a 06                	push   $0x6
80109e06:	52                   	push   %edx
80109e07:	68 00 10 00 00       	push   $0x1000
80109e0c:	50                   	push   %eax
80109e0d:	ff 75 08             	pushl  0x8(%ebp)
80109e10:	e8 1b fb ff ff       	call   80109930 <mappages>
80109e15:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109e18:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e22:	3b 45 10             	cmp    0x10(%ebp),%eax
80109e25:	0f 82 75 ff ff ff    	jb     80109da0 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109e2b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109e2e:	c9                   	leave  
80109e2f:	c3                   	ret    

80109e30 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109e30:	55                   	push   %ebp
80109e31:	89 e5                	mov    %esp,%ebp
80109e33:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109e36:	8b 45 10             	mov    0x10(%ebp),%eax
80109e39:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109e3c:	72 08                	jb     80109e46 <deallocuvm+0x16>
    return oldsz;
80109e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109e41:	e9 a5 00 00 00       	jmp    80109eeb <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109e46:	8b 45 10             	mov    0x10(%ebp),%eax
80109e49:	05 ff 0f 00 00       	add    $0xfff,%eax
80109e4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109e56:	e9 81 00 00 00       	jmp    80109edc <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e5e:	83 ec 04             	sub    $0x4,%esp
80109e61:	6a 00                	push   $0x0
80109e63:	50                   	push   %eax
80109e64:	ff 75 08             	pushl  0x8(%ebp)
80109e67:	e8 24 fa ff ff       	call   80109890 <walkpgdir>
80109e6c:	83 c4 10             	add    $0x10,%esp
80109e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109e72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109e76:	75 09                	jne    80109e81 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109e78:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109e7f:	eb 54                	jmp    80109ed5 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e84:	8b 00                	mov    (%eax),%eax
80109e86:	83 e0 01             	and    $0x1,%eax
80109e89:	85 c0                	test   %eax,%eax
80109e8b:	74 48                	je     80109ed5 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e90:	8b 00                	mov    (%eax),%eax
80109e92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e97:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109e9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109e9e:	75 0d                	jne    80109ead <deallocuvm+0x7d>
        panic("kfree");
80109ea0:	83 ec 0c             	sub    $0xc,%esp
80109ea3:	68 21 aa 10 80       	push   $0x8010aa21
80109ea8:	e8 b9 66 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109ead:	83 ec 0c             	sub    $0xc,%esp
80109eb0:	ff 75 ec             	pushl  -0x14(%ebp)
80109eb3:	e8 56 f5 ff ff       	call   8010940e <p2v>
80109eb8:	83 c4 10             	add    $0x10,%esp
80109ebb:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109ebe:	83 ec 0c             	sub    $0xc,%esp
80109ec1:	ff 75 e8             	pushl  -0x18(%ebp)
80109ec4:	e8 0a 92 ff ff       	call   801030d3 <kfree>
80109ec9:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109ed5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109edf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109ee2:	0f 82 73 ff ff ff    	jb     80109e5b <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109ee8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109eeb:	c9                   	leave  
80109eec:	c3                   	ret    

80109eed <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109eed:	55                   	push   %ebp
80109eee:	89 e5                	mov    %esp,%ebp
80109ef0:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109ef3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109ef7:	75 0d                	jne    80109f06 <freevm+0x19>
    panic("freevm: no pgdir");
80109ef9:	83 ec 0c             	sub    $0xc,%esp
80109efc:	68 27 aa 10 80       	push   $0x8010aa27
80109f01:	e8 60 66 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109f06:	83 ec 04             	sub    $0x4,%esp
80109f09:	6a 00                	push   $0x0
80109f0b:	68 00 00 00 80       	push   $0x80000000
80109f10:	ff 75 08             	pushl  0x8(%ebp)
80109f13:	e8 18 ff ff ff       	call   80109e30 <deallocuvm>
80109f18:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109f22:	eb 4f                	jmp    80109f73 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80109f31:	01 d0                	add    %edx,%eax
80109f33:	8b 00                	mov    (%eax),%eax
80109f35:	83 e0 01             	and    $0x1,%eax
80109f38:	85 c0                	test   %eax,%eax
80109f3a:	74 33                	je     80109f6f <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109f46:	8b 45 08             	mov    0x8(%ebp),%eax
80109f49:	01 d0                	add    %edx,%eax
80109f4b:	8b 00                	mov    (%eax),%eax
80109f4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109f52:	83 ec 0c             	sub    $0xc,%esp
80109f55:	50                   	push   %eax
80109f56:	e8 b3 f4 ff ff       	call   8010940e <p2v>
80109f5b:	83 c4 10             	add    $0x10,%esp
80109f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109f61:	83 ec 0c             	sub    $0xc,%esp
80109f64:	ff 75 f0             	pushl  -0x10(%ebp)
80109f67:	e8 67 91 ff ff       	call   801030d3 <kfree>
80109f6c:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109f6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109f73:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109f7a:	76 a8                	jbe    80109f24 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109f7c:	83 ec 0c             	sub    $0xc,%esp
80109f7f:	ff 75 08             	pushl  0x8(%ebp)
80109f82:	e8 4c 91 ff ff       	call   801030d3 <kfree>
80109f87:	83 c4 10             	add    $0x10,%esp
}
80109f8a:	90                   	nop
80109f8b:	c9                   	leave  
80109f8c:	c3                   	ret    

80109f8d <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109f8d:	55                   	push   %ebp
80109f8e:	89 e5                	mov    %esp,%ebp
80109f90:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109f93:	83 ec 04             	sub    $0x4,%esp
80109f96:	6a 00                	push   $0x0
80109f98:	ff 75 0c             	pushl  0xc(%ebp)
80109f9b:	ff 75 08             	pushl  0x8(%ebp)
80109f9e:	e8 ed f8 ff ff       	call   80109890 <walkpgdir>
80109fa3:	83 c4 10             	add    $0x10,%esp
80109fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109fad:	75 0d                	jne    80109fbc <clearpteu+0x2f>
    panic("clearpteu");
80109faf:	83 ec 0c             	sub    $0xc,%esp
80109fb2:	68 38 aa 10 80       	push   $0x8010aa38
80109fb7:	e8 aa 65 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fbf:	8b 00                	mov    (%eax),%eax
80109fc1:	83 e0 fb             	and    $0xfffffffb,%eax
80109fc4:	89 c2                	mov    %eax,%edx
80109fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fc9:	89 10                	mov    %edx,(%eax)
}
80109fcb:	90                   	nop
80109fcc:	c9                   	leave  
80109fcd:	c3                   	ret    

80109fce <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109fce:	55                   	push   %ebp
80109fcf:	89 e5                	mov    %esp,%ebp
80109fd1:	53                   	push   %ebx
80109fd2:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109fd5:	e8 e6 f9 ff ff       	call   801099c0 <setupkvm>
80109fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109fdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109fe1:	75 0a                	jne    80109fed <copyuvm+0x1f>
    return 0;
80109fe3:	b8 00 00 00 00       	mov    $0x0,%eax
80109fe8:	e9 f8 00 00 00       	jmp    8010a0e5 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109fed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109ff4:	e9 c4 00 00 00       	jmp    8010a0bd <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ffc:	83 ec 04             	sub    $0x4,%esp
80109fff:	6a 00                	push   $0x0
8010a001:	50                   	push   %eax
8010a002:	ff 75 08             	pushl  0x8(%ebp)
8010a005:	e8 86 f8 ff ff       	call   80109890 <walkpgdir>
8010a00a:	83 c4 10             	add    $0x10,%esp
8010a00d:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010a010:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010a014:	75 0d                	jne    8010a023 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
8010a016:	83 ec 0c             	sub    $0xc,%esp
8010a019:	68 42 aa 10 80       	push   $0x8010aa42
8010a01e:	e8 43 65 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
8010a023:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a026:	8b 00                	mov    (%eax),%eax
8010a028:	83 e0 01             	and    $0x1,%eax
8010a02b:	85 c0                	test   %eax,%eax
8010a02d:	75 0d                	jne    8010a03c <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010a02f:	83 ec 0c             	sub    $0xc,%esp
8010a032:	68 5c aa 10 80       	push   $0x8010aa5c
8010a037:	e8 2a 65 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010a03c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a03f:	8b 00                	mov    (%eax),%eax
8010a041:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a046:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010a049:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a04c:	8b 00                	mov    (%eax),%eax
8010a04e:	25 ff 0f 00 00       	and    $0xfff,%eax
8010a053:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010a056:	e8 15 91 ff ff       	call   80103170 <kalloc>
8010a05b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010a05e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010a062:	74 6a                	je     8010a0ce <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010a064:	83 ec 0c             	sub    $0xc,%esp
8010a067:	ff 75 e8             	pushl  -0x18(%ebp)
8010a06a:	e8 9f f3 ff ff       	call   8010940e <p2v>
8010a06f:	83 c4 10             	add    $0x10,%esp
8010a072:	83 ec 04             	sub    $0x4,%esp
8010a075:	68 00 10 00 00       	push   $0x1000
8010a07a:	50                   	push   %eax
8010a07b:	ff 75 e0             	pushl  -0x20(%ebp)
8010a07e:	e8 6c cb ff ff       	call   80106bef <memmove>
8010a083:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010a086:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010a089:	83 ec 0c             	sub    $0xc,%esp
8010a08c:	ff 75 e0             	pushl  -0x20(%ebp)
8010a08f:	e8 6d f3 ff ff       	call   80109401 <v2p>
8010a094:	83 c4 10             	add    $0x10,%esp
8010a097:	89 c2                	mov    %eax,%edx
8010a099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a09c:	83 ec 0c             	sub    $0xc,%esp
8010a09f:	53                   	push   %ebx
8010a0a0:	52                   	push   %edx
8010a0a1:	68 00 10 00 00       	push   $0x1000
8010a0a6:	50                   	push   %eax
8010a0a7:	ff 75 f0             	pushl  -0x10(%ebp)
8010a0aa:	e8 81 f8 ff ff       	call   80109930 <mappages>
8010a0af:	83 c4 20             	add    $0x20,%esp
8010a0b2:	85 c0                	test   %eax,%eax
8010a0b4:	78 1b                	js     8010a0d1 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010a0b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010a0bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010a0c3:	0f 82 30 ff ff ff    	jb     80109ff9 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010a0c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0cc:	eb 17                	jmp    8010a0e5 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010a0ce:	90                   	nop
8010a0cf:	eb 01                	jmp    8010a0d2 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010a0d1:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010a0d2:	83 ec 0c             	sub    $0xc,%esp
8010a0d5:	ff 75 f0             	pushl  -0x10(%ebp)
8010a0d8:	e8 10 fe ff ff       	call   80109eed <freevm>
8010a0dd:	83 c4 10             	add    $0x10,%esp
  return 0;
8010a0e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a0e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010a0e8:	c9                   	leave  
8010a0e9:	c3                   	ret    

8010a0ea <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010a0ea:	55                   	push   %ebp
8010a0eb:	89 e5                	mov    %esp,%ebp
8010a0ed:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010a0f0:	83 ec 04             	sub    $0x4,%esp
8010a0f3:	6a 00                	push   $0x0
8010a0f5:	ff 75 0c             	pushl  0xc(%ebp)
8010a0f8:	ff 75 08             	pushl  0x8(%ebp)
8010a0fb:	e8 90 f7 ff ff       	call   80109890 <walkpgdir>
8010a100:	83 c4 10             	add    $0x10,%esp
8010a103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010a106:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a109:	8b 00                	mov    (%eax),%eax
8010a10b:	83 e0 01             	and    $0x1,%eax
8010a10e:	85 c0                	test   %eax,%eax
8010a110:	75 07                	jne    8010a119 <uva2ka+0x2f>
    return 0;
8010a112:	b8 00 00 00 00       	mov    $0x0,%eax
8010a117:	eb 29                	jmp    8010a142 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010a119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a11c:	8b 00                	mov    (%eax),%eax
8010a11e:	83 e0 04             	and    $0x4,%eax
8010a121:	85 c0                	test   %eax,%eax
8010a123:	75 07                	jne    8010a12c <uva2ka+0x42>
    return 0;
8010a125:	b8 00 00 00 00       	mov    $0x0,%eax
8010a12a:	eb 16                	jmp    8010a142 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010a12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a12f:	8b 00                	mov    (%eax),%eax
8010a131:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a136:	83 ec 0c             	sub    $0xc,%esp
8010a139:	50                   	push   %eax
8010a13a:	e8 cf f2 ff ff       	call   8010940e <p2v>
8010a13f:	83 c4 10             	add    $0x10,%esp
}
8010a142:	c9                   	leave  
8010a143:	c3                   	ret    

8010a144 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010a144:	55                   	push   %ebp
8010a145:	89 e5                	mov    %esp,%ebp
8010a147:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010a14a:	8b 45 10             	mov    0x10(%ebp),%eax
8010a14d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010a150:	eb 7f                	jmp    8010a1d1 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010a152:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a155:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a15a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010a15d:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a160:	83 ec 08             	sub    $0x8,%esp
8010a163:	50                   	push   %eax
8010a164:	ff 75 08             	pushl  0x8(%ebp)
8010a167:	e8 7e ff ff ff       	call   8010a0ea <uva2ka>
8010a16c:	83 c4 10             	add    $0x10,%esp
8010a16f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010a172:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010a176:	75 07                	jne    8010a17f <copyout+0x3b>
      return -1;
8010a178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010a17d:	eb 61                	jmp    8010a1e0 <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010a17f:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a182:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a185:	05 00 10 00 00       	add    $0x1000,%eax
8010a18a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010a18d:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a190:	3b 45 14             	cmp    0x14(%ebp),%eax
8010a193:	76 06                	jbe    8010a19b <copyout+0x57>
      n = len;
8010a195:	8b 45 14             	mov    0x14(%ebp),%eax
8010a198:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010a19b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a19e:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010a1a1:	89 c2                	mov    %eax,%edx
8010a1a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1a6:	01 d0                	add    %edx,%eax
8010a1a8:	83 ec 04             	sub    $0x4,%esp
8010a1ab:	ff 75 f0             	pushl  -0x10(%ebp)
8010a1ae:	ff 75 f4             	pushl  -0xc(%ebp)
8010a1b1:	50                   	push   %eax
8010a1b2:	e8 38 ca ff ff       	call   80106bef <memmove>
8010a1b7:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010a1ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a1bd:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010a1c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a1c3:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010a1c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a1c9:	05 00 10 00 00       	add    $0x1000,%eax
8010a1ce:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a1d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010a1d5:	0f 85 77 ff ff ff    	jne    8010a152 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010a1db:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a1e0:	c9                   	leave  
8010a1e1:	c3                   	ret    
