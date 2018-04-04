
_looper2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
        int pid = fork();
  11:	e8 5f 02 00 00       	call   275 <fork>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(pid == 0)
  19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1d:	75 02                	jne    21 <main+0x21>
        {
                while(1);
  1f:	eb fe                	jmp    1f <main+0x1f>

        }
        exit();
  21:	e8 57 02 00 00       	call   27d <exit>

00000026 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  26:	55                   	push   %ebp
  27:	89 e5                	mov    %esp,%ebp
  29:	57                   	push   %edi
  2a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2e:	8b 55 10             	mov    0x10(%ebp),%edx
  31:	8b 45 0c             	mov    0xc(%ebp),%eax
  34:	89 cb                	mov    %ecx,%ebx
  36:	89 df                	mov    %ebx,%edi
  38:	89 d1                	mov    %edx,%ecx
  3a:	fc                   	cld    
  3b:	f3 aa                	rep stos %al,%es:(%edi)
  3d:	89 ca                	mov    %ecx,%edx
  3f:	89 fb                	mov    %edi,%ebx
  41:	89 5d 08             	mov    %ebx,0x8(%ebp)
  44:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  47:	90                   	nop
  48:	5b                   	pop    %ebx
  49:	5f                   	pop    %edi
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  52:	8b 45 08             	mov    0x8(%ebp),%eax
  55:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  58:	90                   	nop
  59:	8b 45 08             	mov    0x8(%ebp),%eax
  5c:	8d 50 01             	lea    0x1(%eax),%edx
  5f:	89 55 08             	mov    %edx,0x8(%ebp)
  62:	8b 55 0c             	mov    0xc(%ebp),%edx
  65:	8d 4a 01             	lea    0x1(%edx),%ecx
  68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6b:	0f b6 12             	movzbl (%edx),%edx
  6e:	88 10                	mov    %dl,(%eax)
  70:	0f b6 00             	movzbl (%eax),%eax
  73:	84 c0                	test   %al,%al
  75:	75 e2                	jne    59 <strcpy+0xd>
    ;
  return os;
  77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7f:	eb 08                	jmp    89 <strcmp+0xd>
    p++, q++;
  81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  85:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 10                	je     a3 <strcmp+0x27>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 10             	movzbl (%eax),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 00             	movzbl (%eax),%eax
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 de                	je     81 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	0f b6 d0             	movzbl %al,%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	29 c2                	sub    %eax,%edx
  b7:	89 d0                	mov    %edx,%eax
}
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    

000000bb <strlen>:

uint
strlen(char *s)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c8:	eb 04                	jmp    ce <strlen+0x13>
  ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	01 d0                	add    %edx,%eax
  d6:	0f b6 00             	movzbl (%eax),%eax
  d9:	84 c0                	test   %al,%al
  db:	75 ed                	jne    ca <strlen+0xf>
    ;
  return n;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e5:	8b 45 10             	mov    0x10(%ebp),%eax
  e8:	50                   	push   %eax
  e9:	ff 75 0c             	pushl  0xc(%ebp)
  ec:	ff 75 08             	pushl  0x8(%ebp)
  ef:	e8 32 ff ff ff       	call   26 <stosb>
  f4:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 108:	eb 14                	jmp    11e <strchr+0x22>
    if(*s == c)
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	0f b6 00             	movzbl (%eax),%eax
 110:	3a 45 fc             	cmp    -0x4(%ebp),%al
 113:	75 05                	jne    11a <strchr+0x1e>
      return (char*)s;
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	eb 13                	jmp    12d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 e2                	jne    10a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 128:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <gets>:

char*
gets(char *buf, int max)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13c:	eb 42                	jmp    180 <gets+0x51>
    cc = read(0, &c, 1);
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	6a 01                	push   $0x1
 143:	8d 45 ef             	lea    -0x11(%ebp),%eax
 146:	50                   	push   %eax
 147:	6a 00                	push   $0x0
 149:	e8 47 01 00 00       	call   295 <read>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 158:	7e 33                	jle    18d <gets+0x5e>
      break;
    buf[i++] = c;
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 50 01             	lea    0x1(%eax),%edx
 160:	89 55 f4             	mov    %edx,-0xc(%ebp)
 163:	89 c2                	mov    %eax,%edx
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	01 c2                	add    %eax,%edx
 16a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	3c 0a                	cmp    $0xa,%al
 176:	74 16                	je     18e <gets+0x5f>
 178:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17c:	3c 0d                	cmp    $0xd,%al
 17e:	74 0e                	je     18e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	8b 45 f4             	mov    -0xc(%ebp),%eax
 183:	83 c0 01             	add    $0x1,%eax
 186:	3b 45 0c             	cmp    0xc(%ebp),%eax
 189:	7c b3                	jl     13e <gets+0xf>
 18b:	eb 01                	jmp    18e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	01 d0                	add    %edx,%eax
 196:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <stat>:

int
stat(char *n, struct stat *st)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	6a 00                	push   $0x0
 1a9:	ff 75 08             	pushl  0x8(%ebp)
 1ac:	e8 0c 01 00 00       	call   2bd <open>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bb:	79 07                	jns    1c4 <stat+0x26>
    return -1;
 1bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c2:	eb 25                	jmp    1e9 <stat+0x4b>
  r = fstat(fd, st);
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	ff 75 0c             	pushl  0xc(%ebp)
 1ca:	ff 75 f4             	pushl  -0xc(%ebp)
 1cd:	e8 03 01 00 00       	call   2d5 <fstat>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	ff 75 f4             	pushl  -0xc(%ebp)
 1de:	e8 c2 00 00 00       	call   2a5 <close>
 1e3:	83 c4 10             	add    $0x10,%esp
  return r;
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <atoi>:

int
atoi(const char *s)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f8:	eb 25                	jmp    21f <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	89 d0                	mov    %edx,%eax
 1ff:	c1 e0 02             	shl    $0x2,%eax
 202:	01 d0                	add    %edx,%eax
 204:	01 c0                	add    %eax,%eax
 206:	89 c1                	mov    %eax,%ecx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	8d 50 01             	lea    0x1(%eax),%edx
 20e:	89 55 08             	mov    %edx,0x8(%ebp)
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	0f be c0             	movsbl %al,%eax
 217:	01 c8                	add    %ecx,%eax
 219:	83 e8 30             	sub    $0x30,%eax
 21c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3c 2f                	cmp    $0x2f,%al
 227:	7e 0a                	jle    233 <atoi+0x48>
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 39                	cmp    $0x39,%al
 231:	7e c7                	jle    1fa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 233:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24a:	eb 17                	jmp    263 <memmove+0x2b>
    *dst++ = *src++;
 24c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24f:	8d 50 01             	lea    0x1(%eax),%edx
 252:	89 55 fc             	mov    %edx,-0x4(%ebp)
 255:	8b 55 f8             	mov    -0x8(%ebp),%edx
 258:	8d 4a 01             	lea    0x1(%edx),%ecx
 25b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 25e:	0f b6 12             	movzbl (%edx),%edx
 261:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 263:	8b 45 10             	mov    0x10(%ebp),%eax
 266:	8d 50 ff             	lea    -0x1(%eax),%edx
 269:	89 55 10             	mov    %edx,0x10(%ebp)
 26c:	85 c0                	test   %eax,%eax
 26e:	7f dc                	jg     24c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 275:	b8 01 00 00 00       	mov    $0x1,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <exit>:
SYSCALL(exit)
 27d:	b8 02 00 00 00       	mov    $0x2,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <wait>:
SYSCALL(wait)
 285:	b8 03 00 00 00       	mov    $0x3,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <pipe>:
SYSCALL(pipe)
 28d:	b8 04 00 00 00       	mov    $0x4,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <read>:
SYSCALL(read)
 295:	b8 05 00 00 00       	mov    $0x5,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <write>:
SYSCALL(write)
 29d:	b8 10 00 00 00       	mov    $0x10,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <close>:
SYSCALL(close)
 2a5:	b8 15 00 00 00       	mov    $0x15,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <kill>:
SYSCALL(kill)
 2ad:	b8 06 00 00 00       	mov    $0x6,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <exec>:
SYSCALL(exec)
 2b5:	b8 07 00 00 00       	mov    $0x7,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <open>:
SYSCALL(open)
 2bd:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <mknod>:
SYSCALL(mknod)
 2c5:	b8 11 00 00 00       	mov    $0x11,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <unlink>:
SYSCALL(unlink)
 2cd:	b8 12 00 00 00       	mov    $0x12,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <fstat>:
SYSCALL(fstat)
 2d5:	b8 08 00 00 00       	mov    $0x8,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <link>:
SYSCALL(link)
 2dd:	b8 13 00 00 00       	mov    $0x13,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <mkdir>:
SYSCALL(mkdir)
 2e5:	b8 14 00 00 00       	mov    $0x14,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <chdir>:
SYSCALL(chdir)
 2ed:	b8 09 00 00 00       	mov    $0x9,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <dup>:
SYSCALL(dup)
 2f5:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <getpid>:
SYSCALL(getpid)
 2fd:	b8 0b 00 00 00       	mov    $0xb,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <sbrk>:
SYSCALL(sbrk)
 305:	b8 0c 00 00 00       	mov    $0xc,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <sleep>:
SYSCALL(sleep)
 30d:	b8 0d 00 00 00       	mov    $0xd,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <uptime>:
SYSCALL(uptime)
 315:	b8 0e 00 00 00       	mov    $0xe,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <halt>:
SYSCALL(halt)
 31d:	b8 16 00 00 00       	mov    $0x16,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <date>:
SYSCALL(date)
 325:	b8 17 00 00 00       	mov    $0x17,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <getuid>:
SYSCALL(getuid)
 32d:	b8 18 00 00 00       	mov    $0x18,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <getgid>:
SYSCALL(getgid)
 335:	b8 19 00 00 00       	mov    $0x19,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <getppid>:
SYSCALL(getppid)
 33d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <setuid>:
SYSCALL(setuid)
 345:	b8 1b 00 00 00       	mov    $0x1b,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <setgid>:
SYSCALL(setgid)
 34d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <getprocs>:
SYSCALL(getprocs)
 355:	b8 1d 00 00 00       	mov    $0x1d,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <looper>:
SYSCALL(looper)
 35d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <setpriority>:
SYSCALL(setpriority)
 365:	b8 1f 00 00 00       	mov    $0x1f,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <chmod>:
SYSCALL(chmod)
 36d:	b8 20 00 00 00       	mov    $0x20,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <chown>:
SYSCALL(chown)
 375:	b8 21 00 00 00       	mov    $0x21,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <chgrp>:
SYSCALL(chgrp)
 37d:	b8 22 00 00 00       	mov    $0x22,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	83 ec 18             	sub    $0x18,%esp
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 391:	83 ec 04             	sub    $0x4,%esp
 394:	6a 01                	push   $0x1
 396:	8d 45 f4             	lea    -0xc(%ebp),%eax
 399:	50                   	push   %eax
 39a:	ff 75 08             	pushl  0x8(%ebp)
 39d:	e8 fb fe ff ff       	call   29d <write>
 3a2:	83 c4 10             	add    $0x10,%esp
}
 3a5:	90                   	nop
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	53                   	push   %ebx
 3ac:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ba:	74 17                	je     3d3 <printint+0x2b>
 3bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c0:	79 11                	jns    3d3 <printint+0x2b>
    neg = 1;
 3c2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	f7 d8                	neg    %eax
 3ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d1:	eb 06                	jmp    3d9 <printint+0x31>
  } else {
    x = xx;
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e3:	8d 41 01             	lea    0x1(%ecx),%eax
 3e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ef:	ba 00 00 00 00       	mov    $0x0,%edx
 3f4:	f7 f3                	div    %ebx
 3f6:	89 d0                	mov    %edx,%eax
 3f8:	0f b6 80 64 0a 00 00 	movzbl 0xa64(%eax),%eax
 3ff:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 403:	8b 5d 10             	mov    0x10(%ebp),%ebx
 406:	8b 45 ec             	mov    -0x14(%ebp),%eax
 409:	ba 00 00 00 00       	mov    $0x0,%edx
 40e:	f7 f3                	div    %ebx
 410:	89 45 ec             	mov    %eax,-0x14(%ebp)
 413:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 417:	75 c7                	jne    3e0 <printint+0x38>
  if(neg)
 419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41d:	74 2d                	je     44c <printint+0xa4>
    buf[i++] = '-';
 41f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 422:	8d 50 01             	lea    0x1(%eax),%edx
 425:	89 55 f4             	mov    %edx,-0xc(%ebp)
 428:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42d:	eb 1d                	jmp    44c <printint+0xa4>
    putc(fd, buf[i]);
 42f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	01 d0                	add    %edx,%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	0f be c0             	movsbl %al,%eax
 43d:	83 ec 08             	sub    $0x8,%esp
 440:	50                   	push   %eax
 441:	ff 75 08             	pushl  0x8(%ebp)
 444:	e8 3c ff ff ff       	call   385 <putc>
 449:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 450:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 454:	79 d9                	jns    42f <printint+0x87>
    putc(fd, buf[i]);
}
 456:	90                   	nop
 457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 462:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 469:	8d 45 0c             	lea    0xc(%ebp),%eax
 46c:	83 c0 04             	add    $0x4,%eax
 46f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 479:	e9 59 01 00 00       	jmp    5d7 <printf+0x17b>
    c = fmt[i] & 0xff;
 47e:	8b 55 0c             	mov    0xc(%ebp),%edx
 481:	8b 45 f0             	mov    -0x10(%ebp),%eax
 484:	01 d0                	add    %edx,%eax
 486:	0f b6 00             	movzbl (%eax),%eax
 489:	0f be c0             	movsbl %al,%eax
 48c:	25 ff 00 00 00       	and    $0xff,%eax
 491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 494:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 498:	75 2c                	jne    4c6 <printf+0x6a>
      if(c == '%'){
 49a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49e:	75 0c                	jne    4ac <printf+0x50>
        state = '%';
 4a0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a7:	e9 27 01 00 00       	jmp    5d3 <printf+0x177>
      } else {
        putc(fd, c);
 4ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	83 ec 08             	sub    $0x8,%esp
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 c7 fe ff ff       	call   385 <putc>
 4be:	83 c4 10             	add    $0x10,%esp
 4c1:	e9 0d 01 00 00       	jmp    5d3 <printf+0x177>
      }
    } else if(state == '%'){
 4c6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ca:	0f 85 03 01 00 00    	jne    5d3 <printf+0x177>
      if(c == 'd'){
 4d0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d4:	75 1e                	jne    4f4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d9:	8b 00                	mov    (%eax),%eax
 4db:	6a 01                	push   $0x1
 4dd:	6a 0a                	push   $0xa
 4df:	50                   	push   %eax
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 c0 fe ff ff       	call   3a8 <printint>
 4e8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ef:	e9 d8 00 00 00       	jmp    5cc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f8:	74 06                	je     500 <printf+0xa4>
 4fa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fe:	75 1e                	jne    51e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	6a 00                	push   $0x0
 507:	6a 10                	push   $0x10
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 96 fe ff ff       	call   3a8 <printint>
 512:	83 c4 10             	add    $0x10,%esp
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 519:	e9 ae 00 00 00       	jmp    5cc <printf+0x170>
      } else if(c == 's'){
 51e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 522:	75 43                	jne    567 <printf+0x10b>
        s = (char*)*ap;
 524:	8b 45 e8             	mov    -0x18(%ebp),%eax
 527:	8b 00                	mov    (%eax),%eax
 529:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 534:	75 25                	jne    55b <printf+0xff>
          s = "(null)";
 536:	c7 45 f4 12 08 00 00 	movl   $0x812,-0xc(%ebp)
        while(*s != 0){
 53d:	eb 1c                	jmp    55b <printf+0xff>
          putc(fd, *s);
 53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 31 fe ff ff       	call   385 <putc>
 554:	83 c4 10             	add    $0x10,%esp
          s++;
 557:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55e:	0f b6 00             	movzbl (%eax),%eax
 561:	84 c0                	test   %al,%al
 563:	75 da                	jne    53f <printf+0xe3>
 565:	eb 65                	jmp    5cc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 567:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56b:	75 1d                	jne    58a <printf+0x12e>
        putc(fd, *ap);
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 04 fe ff ff       	call   385 <putc>
 581:	83 c4 10             	add    $0x10,%esp
        ap++;
 584:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 588:	eb 42                	jmp    5cc <printf+0x170>
      } else if(c == '%'){
 58a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58e:	75 17                	jne    5a7 <printf+0x14b>
        putc(fd, c);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	83 ec 08             	sub    $0x8,%esp
 599:	50                   	push   %eax
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 e3 fd ff ff       	call   385 <putc>
 5a2:	83 c4 10             	add    $0x10,%esp
 5a5:	eb 25                	jmp    5cc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a7:	83 ec 08             	sub    $0x8,%esp
 5aa:	6a 25                	push   $0x25
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 d1 fd ff ff       	call   385 <putc>
 5b4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 bc fd ff ff       	call   385 <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5dd:	01 d0                	add    %edx,%eax
 5df:	0f b6 00             	movzbl (%eax),%eax
 5e2:	84 c0                	test   %al,%al
 5e4:	0f 85 94 fe ff ff    	jne    47e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ea:	90                   	nop
 5eb:	c9                   	leave  
 5ec:	c3                   	ret    

000005ed <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ed:	55                   	push   %ebp
 5ee:	89 e5                	mov    %esp,%ebp
 5f0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	83 e8 08             	sub    $0x8,%eax
 5f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	a1 80 0a 00 00       	mov    0xa80,%eax
 601:	89 45 fc             	mov    %eax,-0x4(%ebp)
 604:	eb 24                	jmp    62a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 606:	8b 45 fc             	mov    -0x4(%ebp),%eax
 609:	8b 00                	mov    (%eax),%eax
 60b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60e:	77 12                	ja     622 <free+0x35>
 610:	8b 45 f8             	mov    -0x8(%ebp),%eax
 613:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 616:	77 24                	ja     63c <free+0x4f>
 618:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 620:	77 1a                	ja     63c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 630:	76 d4                	jbe    606 <free+0x19>
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63a:	76 ca                	jbe    606 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	8b 40 04             	mov    0x4(%eax),%eax
 642:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	01 c2                	add    %eax,%edx
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	39 c2                	cmp    %eax,%edx
 655:	75 24                	jne    67b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	8b 50 04             	mov    0x4(%eax),%edx
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	8b 40 04             	mov    0x4(%eax),%eax
 665:	01 c2                	add    %eax,%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	8b 10                	mov    (%eax),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	89 10                	mov    %edx,(%eax)
 679:	eb 0a                	jmp    685 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 10                	mov    (%eax),%edx
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 40 04             	mov    0x4(%eax),%eax
 68b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	01 d0                	add    %edx,%eax
 697:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69a:	75 20                	jne    6bc <free+0xcf>
    p->s.size += bp->s.size;
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 50 04             	mov    0x4(%eax),%edx
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	8b 40 04             	mov    0x4(%eax),%eax
 6a8:	01 c2                	add    %eax,%edx
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	8b 10                	mov    (%eax),%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	89 10                	mov    %edx,(%eax)
 6ba:	eb 08                	jmp    6c4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	a3 80 0a 00 00       	mov    %eax,0xa80
}
 6cc:	90                   	nop
 6cd:	c9                   	leave  
 6ce:	c3                   	ret    

000006cf <morecore>:

static Header*
morecore(uint nu)
{
 6cf:	55                   	push   %ebp
 6d0:	89 e5                	mov    %esp,%ebp
 6d2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6dc:	77 07                	ja     6e5 <morecore+0x16>
    nu = 4096;
 6de:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	c1 e0 03             	shl    $0x3,%eax
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	50                   	push   %eax
 6ef:	e8 11 fc ff ff       	call   305 <sbrk>
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fe:	75 07                	jne    707 <morecore+0x38>
    return 0;
 700:	b8 00 00 00 00       	mov    $0x0,%eax
 705:	eb 26                	jmp    72d <morecore+0x5e>
  hp = (Header*)p;
 707:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	8b 55 08             	mov    0x8(%ebp),%edx
 713:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 716:	8b 45 f0             	mov    -0x10(%ebp),%eax
 719:	83 c0 08             	add    $0x8,%eax
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	50                   	push   %eax
 720:	e8 c8 fe ff ff       	call   5ed <free>
 725:	83 c4 10             	add    $0x10,%esp
  return freep;
 728:	a1 80 0a 00 00       	mov    0xa80,%eax
}
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <malloc>:

void*
malloc(uint nbytes)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	83 c0 07             	add    $0x7,%eax
 73b:	c1 e8 03             	shr    $0x3,%eax
 73e:	83 c0 01             	add    $0x1,%eax
 741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 744:	a1 80 0a 00 00       	mov    0xa80,%eax
 749:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 750:	75 23                	jne    775 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 752:	c7 45 f0 78 0a 00 00 	movl   $0xa78,-0x10(%ebp)
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	a3 80 0a 00 00       	mov    %eax,0xa80
 761:	a1 80 0a 00 00       	mov    0xa80,%eax
 766:	a3 78 0a 00 00       	mov    %eax,0xa78
    base.s.size = 0;
 76b:	c7 05 7c 0a 00 00 00 	movl   $0x0,0xa7c
 772:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 786:	72 4d                	jb     7d5 <malloc+0xa6>
      if(p->s.size == nunits)
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 791:	75 0c                	jne    79f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 26                	jmp    7c5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a8:	89 c2                	mov    %eax,%edx
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	c1 e0 03             	shl    $0x3,%eax
 7b9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	a3 80 0a 00 00       	mov    %eax,0xa80
      return (void*)(p + 1);
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	83 c0 08             	add    $0x8,%eax
 7d3:	eb 3b                	jmp    810 <malloc+0xe1>
    }
    if(p == freep)
 7d5:	a1 80 0a 00 00       	mov    0xa80,%eax
 7da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7dd:	75 1e                	jne    7fd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7df:	83 ec 0c             	sub    $0xc,%esp
 7e2:	ff 75 ec             	pushl  -0x14(%ebp)
 7e5:	e8 e5 fe ff ff       	call   6cf <morecore>
 7ea:	83 c4 10             	add    $0x10,%esp
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f4:	75 07                	jne    7fd <malloc+0xce>
        return 0;
 7f6:	b8 00 00 00 00       	mov    $0x0,%eax
 7fb:	eb 13                	jmp    810 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	89 45 f0             	mov    %eax,-0x10(%ebp)
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 80b:	e9 6d ff ff ff       	jmp    77d <malloc+0x4e>
}
 810:	c9                   	leave  
 811:	c3                   	ret    
