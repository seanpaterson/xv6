
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 57 02 00 00       	call   283 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 47 01 00 00       	call   29b <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 0c 01 00 00       	call   2c3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 03 01 00 00       	call   2db <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 c2 00 00 00       	call   2ab <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25e:	8d 4a 01             	lea    0x1(%edx),%ecx
 261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <halt>:
SYSCALL(halt)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <date>:
SYSCALL(date)
 32b:	b8 17 00 00 00       	mov    $0x17,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getuid>:
SYSCALL(getuid)
 333:	b8 18 00 00 00       	mov    $0x18,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getgid>:
SYSCALL(getgid)
 33b:	b8 19 00 00 00       	mov    $0x19,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getppid>:
SYSCALL(getppid)
 343:	b8 1a 00 00 00       	mov    $0x1a,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <setuid>:
SYSCALL(setuid)
 34b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <setgid>:
SYSCALL(setgid)
 353:	b8 1c 00 00 00       	mov    $0x1c,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <getprocs>:
SYSCALL(getprocs)
 35b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <looper>:
SYSCALL(looper)
 363:	b8 1e 00 00 00       	mov    $0x1e,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <setpriority>:
SYSCALL(setpriority)
 36b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <chmod>:
SYSCALL(chmod)
 373:	b8 20 00 00 00       	mov    $0x20,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <chown>:
SYSCALL(chown)
 37b:	b8 21 00 00 00       	mov    $0x21,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <chgrp>:
SYSCALL(chgrp)
 383:	b8 22 00 00 00       	mov    $0x22,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	83 ec 18             	sub    $0x18,%esp
 391:	8b 45 0c             	mov    0xc(%ebp),%eax
 394:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 397:	83 ec 04             	sub    $0x4,%esp
 39a:	6a 01                	push   $0x1
 39c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39f:	50                   	push   %eax
 3a0:	ff 75 08             	pushl  0x8(%ebp)
 3a3:	e8 fb fe ff ff       	call   2a3 <write>
 3a8:	83 c4 10             	add    $0x10,%esp
}
 3ab:	90                   	nop
 3ac:	c9                   	leave  
 3ad:	c3                   	ret    

000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
 3b1:	53                   	push   %ebx
 3b2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c0:	74 17                	je     3d9 <printint+0x2b>
 3c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c6:	79 11                	jns    3d9 <printint+0x2b>
    neg = 1;
 3c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d2:	f7 d8                	neg    %eax
 3d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d7:	eb 06                	jmp    3df <printint+0x31>
  } else {
    x = xx;
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e9:	8d 41 01             	lea    0x1(%ecx),%eax
 3ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f5:	ba 00 00 00 00       	mov    $0x0,%edx
 3fa:	f7 f3                	div    %ebx
 3fc:	89 d0                	mov    %edx,%eax
 3fe:	0f b6 80 68 0a 00 00 	movzbl 0xa68(%eax),%eax
 405:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 409:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40f:	ba 00 00 00 00       	mov    $0x0,%edx
 414:	f7 f3                	div    %ebx
 416:	89 45 ec             	mov    %eax,-0x14(%ebp)
 419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41d:	75 c7                	jne    3e6 <printint+0x38>
  if(neg)
 41f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 423:	74 2d                	je     452 <printint+0xa4>
    buf[i++] = '-';
 425:	8b 45 f4             	mov    -0xc(%ebp),%eax
 428:	8d 50 01             	lea    0x1(%eax),%edx
 42b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 433:	eb 1d                	jmp    452 <printint+0xa4>
    putc(fd, buf[i]);
 435:	8d 55 dc             	lea    -0x24(%ebp),%edx
 438:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43b:	01 d0                	add    %edx,%eax
 43d:	0f b6 00             	movzbl (%eax),%eax
 440:	0f be c0             	movsbl %al,%eax
 443:	83 ec 08             	sub    $0x8,%esp
 446:	50                   	push   %eax
 447:	ff 75 08             	pushl  0x8(%ebp)
 44a:	e8 3c ff ff ff       	call   38b <putc>
 44f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 452:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45a:	79 d9                	jns    435 <printint+0x87>
    putc(fd, buf[i]);
}
 45c:	90                   	nop
 45d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 460:	c9                   	leave  
 461:	c3                   	ret    

00000462 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46f:	8d 45 0c             	lea    0xc(%ebp),%eax
 472:	83 c0 04             	add    $0x4,%eax
 475:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 478:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47f:	e9 59 01 00 00       	jmp    5dd <printf+0x17b>
    c = fmt[i] & 0xff;
 484:	8b 55 0c             	mov    0xc(%ebp),%edx
 487:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48a:	01 d0                	add    %edx,%eax
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	25 ff 00 00 00       	and    $0xff,%eax
 497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49e:	75 2c                	jne    4cc <printf+0x6a>
      if(c == '%'){
 4a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a4:	75 0c                	jne    4b2 <printf+0x50>
        state = '%';
 4a6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ad:	e9 27 01 00 00       	jmp    5d9 <printf+0x177>
      } else {
        putc(fd, c);
 4b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	83 ec 08             	sub    $0x8,%esp
 4bb:	50                   	push   %eax
 4bc:	ff 75 08             	pushl  0x8(%ebp)
 4bf:	e8 c7 fe ff ff       	call   38b <putc>
 4c4:	83 c4 10             	add    $0x10,%esp
 4c7:	e9 0d 01 00 00       	jmp    5d9 <printf+0x177>
      }
    } else if(state == '%'){
 4cc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d0:	0f 85 03 01 00 00    	jne    5d9 <printf+0x177>
      if(c == 'd'){
 4d6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4da:	75 1e                	jne    4fa <printf+0x98>
        printint(fd, *ap, 10, 1);
 4dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	6a 01                	push   $0x1
 4e3:	6a 0a                	push   $0xa
 4e5:	50                   	push   %eax
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 c0 fe ff ff       	call   3ae <printint>
 4ee:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f5:	e9 d8 00 00 00       	jmp    5d2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4fa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fe:	74 06                	je     506 <printf+0xa4>
 500:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 504:	75 1e                	jne    524 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	6a 00                	push   $0x0
 50d:	6a 10                	push   $0x10
 50f:	50                   	push   %eax
 510:	ff 75 08             	pushl  0x8(%ebp)
 513:	e8 96 fe ff ff       	call   3ae <printint>
 518:	83 c4 10             	add    $0x10,%esp
        ap++;
 51b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51f:	e9 ae 00 00 00       	jmp    5d2 <printf+0x170>
      } else if(c == 's'){
 524:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 528:	75 43                	jne    56d <printf+0x10b>
        s = (char*)*ap;
 52a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52d:	8b 00                	mov    (%eax),%eax
 52f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53a:	75 25                	jne    561 <printf+0xff>
          s = "(null)";
 53c:	c7 45 f4 18 08 00 00 	movl   $0x818,-0xc(%ebp)
        while(*s != 0){
 543:	eb 1c                	jmp    561 <printf+0xff>
          putc(fd, *s);
 545:	8b 45 f4             	mov    -0xc(%ebp),%eax
 548:	0f b6 00             	movzbl (%eax),%eax
 54b:	0f be c0             	movsbl %al,%eax
 54e:	83 ec 08             	sub    $0x8,%esp
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	e8 31 fe ff ff       	call   38b <putc>
 55a:	83 c4 10             	add    $0x10,%esp
          s++;
 55d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 561:	8b 45 f4             	mov    -0xc(%ebp),%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	84 c0                	test   %al,%al
 569:	75 da                	jne    545 <printf+0xe3>
 56b:	eb 65                	jmp    5d2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 571:	75 1d                	jne    590 <printf+0x12e>
        putc(fd, *ap);
 573:	8b 45 e8             	mov    -0x18(%ebp),%eax
 576:	8b 00                	mov    (%eax),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	83 ec 08             	sub    $0x8,%esp
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 04 fe ff ff       	call   38b <putc>
 587:	83 c4 10             	add    $0x10,%esp
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58e:	eb 42                	jmp    5d2 <printf+0x170>
      } else if(c == '%'){
 590:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 594:	75 17                	jne    5ad <printf+0x14b>
        putc(fd, c);
 596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 ec 08             	sub    $0x8,%esp
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 e3 fd ff ff       	call   38b <putc>
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	eb 25                	jmp    5d2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ad:	83 ec 08             	sub    $0x8,%esp
 5b0:	6a 25                	push   $0x25
 5b2:	ff 75 08             	pushl  0x8(%ebp)
 5b5:	e8 d1 fd ff ff       	call   38b <putc>
 5ba:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	83 ec 08             	sub    $0x8,%esp
 5c6:	50                   	push   %eax
 5c7:	ff 75 08             	pushl  0x8(%ebp)
 5ca:	e8 bc fd ff ff       	call   38b <putc>
 5cf:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5dd:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e3:	01 d0                	add    %edx,%eax
 5e5:	0f b6 00             	movzbl (%eax),%eax
 5e8:	84 c0                	test   %al,%al
 5ea:	0f 85 94 fe ff ff    	jne    484 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f0:	90                   	nop
 5f1:	c9                   	leave  
 5f2:	c3                   	ret    

000005f3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f3:	55                   	push   %ebp
 5f4:	89 e5                	mov    %esp,%ebp
 5f6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	83 e8 08             	sub    $0x8,%eax
 5ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 602:	a1 84 0a 00 00       	mov    0xa84,%eax
 607:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60a:	eb 24                	jmp    630 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 614:	77 12                	ja     628 <free+0x35>
 616:	8b 45 f8             	mov    -0x8(%ebp),%eax
 619:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61c:	77 24                	ja     642 <free+0x4f>
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 626:	77 1a                	ja     642 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 636:	76 d4                	jbe    60c <free+0x19>
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 640:	76 ca                	jbe    60c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	8b 40 04             	mov    0x4(%eax),%eax
 648:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	01 c2                	add    %eax,%edx
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	39 c2                	cmp    %eax,%edx
 65b:	75 24                	jne    681 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	8b 50 04             	mov    0x4(%eax),%edx
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	8b 40 04             	mov    0x4(%eax),%eax
 66b:	01 c2                	add    %eax,%edx
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
 67f:	eb 0a                	jmp    68b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 10                	mov    (%eax),%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	01 d0                	add    %edx,%eax
 69d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a0:	75 20                	jne    6c2 <free+0xcf>
    p->s.size += bp->s.size;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	01 c2                	add    %eax,%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
 6c0:	eb 08                	jmp    6ca <free+0xd7>
  } else
    p->s.ptr = bp;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	a3 84 0a 00 00       	mov    %eax,0xa84
}
 6d2:	90                   	nop
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    

000006d5 <morecore>:

static Header*
morecore(uint nu)
{
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6db:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e2:	77 07                	ja     6eb <morecore+0x16>
    nu = 4096;
 6e4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	c1 e0 03             	shl    $0x3,%eax
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	50                   	push   %eax
 6f5:	e8 11 fc ff ff       	call   30b <sbrk>
 6fa:	83 c4 10             	add    $0x10,%esp
 6fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 700:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 704:	75 07                	jne    70d <morecore+0x38>
    return 0;
 706:	b8 00 00 00 00       	mov    $0x0,%eax
 70b:	eb 26                	jmp    733 <morecore+0x5e>
  hp = (Header*)p;
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	8b 55 08             	mov    0x8(%ebp),%edx
 719:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71f:	83 c0 08             	add    $0x8,%eax
 722:	83 ec 0c             	sub    $0xc,%esp
 725:	50                   	push   %eax
 726:	e8 c8 fe ff ff       	call   5f3 <free>
 72b:	83 c4 10             	add    $0x10,%esp
  return freep;
 72e:	a1 84 0a 00 00       	mov    0xa84,%eax
}
 733:	c9                   	leave  
 734:	c3                   	ret    

00000735 <malloc>:

void*
malloc(uint nbytes)
{
 735:	55                   	push   %ebp
 736:	89 e5                	mov    %esp,%ebp
 738:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73b:	8b 45 08             	mov    0x8(%ebp),%eax
 73e:	83 c0 07             	add    $0x7,%eax
 741:	c1 e8 03             	shr    $0x3,%eax
 744:	83 c0 01             	add    $0x1,%eax
 747:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 74a:	a1 84 0a 00 00       	mov    0xa84,%eax
 74f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 752:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 756:	75 23                	jne    77b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 758:	c7 45 f0 7c 0a 00 00 	movl   $0xa7c,-0x10(%ebp)
 75f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 762:	a3 84 0a 00 00       	mov    %eax,0xa84
 767:	a1 84 0a 00 00       	mov    0xa84,%eax
 76c:	a3 7c 0a 00 00       	mov    %eax,0xa7c
    base.s.size = 0;
 771:	c7 05 80 0a 00 00 00 	movl   $0x0,0xa80
 778:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78c:	72 4d                	jb     7db <malloc+0xa6>
      if(p->s.size == nunits)
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 797:	75 0c                	jne    7a5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 10                	mov    (%eax),%edx
 79e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a1:	89 10                	mov    %edx,(%eax)
 7a3:	eb 26                	jmp    7cb <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 40 04             	mov    0x4(%eax),%eax
 7ab:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ae:	89 c2                	mov    %eax,%edx
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	c1 e0 03             	shl    $0x3,%eax
 7bf:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ce:	a3 84 0a 00 00       	mov    %eax,0xa84
      return (void*)(p + 1);
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	83 c0 08             	add    $0x8,%eax
 7d9:	eb 3b                	jmp    816 <malloc+0xe1>
    }
    if(p == freep)
 7db:	a1 84 0a 00 00       	mov    0xa84,%eax
 7e0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e3:	75 1e                	jne    803 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7e5:	83 ec 0c             	sub    $0xc,%esp
 7e8:	ff 75 ec             	pushl  -0x14(%ebp)
 7eb:	e8 e5 fe ff ff       	call   6d5 <morecore>
 7f0:	83 c4 10             	add    $0x10,%esp
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fa:	75 07                	jne    803 <malloc+0xce>
        return 0;
 7fc:	b8 00 00 00 00       	mov    $0x0,%eax
 801:	eb 13                	jmp    816 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	89 45 f0             	mov    %eax,-0x10(%ebp)
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 811:	e9 6d ff ff ff       	jmp    783 <malloc+0x4e>
}
 816:	c9                   	leave  
 817:	c3                   	ret    
