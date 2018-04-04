
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 51 08 00 00       	mov    $0x851,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 53 08 00 00       	mov    $0x853,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 55 08 00 00       	push   $0x855
  4b:	6a 01                	push   $0x1
  4d:	e8 49 04 00 00       	call   49b <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 57 02 00 00       	call   2bc <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 47 01 00 00       	call   2d4 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 0c 01 00 00       	call   2fc <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 03 01 00 00       	call   314 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 c2 00 00 00       	call   2e4 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 50 01             	lea    0x1(%eax),%edx
 291:	89 55 fc             	mov    %edx,-0x4(%ebp)
 294:	8b 55 f8             	mov    -0x8(%ebp),%edx
 297:	8d 4a 01             	lea    0x1(%edx),%ecx
 29a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <pipe>:
SYSCALL(pipe)
 2cc:	b8 04 00 00 00       	mov    $0x4,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <read>:
SYSCALL(read)
 2d4:	b8 05 00 00 00       	mov    $0x5,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <write>:
SYSCALL(write)
 2dc:	b8 10 00 00 00       	mov    $0x10,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <close>:
SYSCALL(close)
 2e4:	b8 15 00 00 00       	mov    $0x15,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <kill>:
SYSCALL(kill)
 2ec:	b8 06 00 00 00       	mov    $0x6,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <exec>:
SYSCALL(exec)
 2f4:	b8 07 00 00 00       	mov    $0x7,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <open>:
SYSCALL(open)
 2fc:	b8 0f 00 00 00       	mov    $0xf,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mknod>:
SYSCALL(mknod)
 304:	b8 11 00 00 00       	mov    $0x11,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <unlink>:
SYSCALL(unlink)
 30c:	b8 12 00 00 00       	mov    $0x12,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <fstat>:
SYSCALL(fstat)
 314:	b8 08 00 00 00       	mov    $0x8,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <link>:
SYSCALL(link)
 31c:	b8 13 00 00 00       	mov    $0x13,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mkdir>:
SYSCALL(mkdir)
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <chdir>:
SYSCALL(chdir)
 32c:	b8 09 00 00 00       	mov    $0x9,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <dup>:
SYSCALL(dup)
 334:	b8 0a 00 00 00       	mov    $0xa,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <getpid>:
SYSCALL(getpid)
 33c:	b8 0b 00 00 00       	mov    $0xb,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sbrk>:
SYSCALL(sbrk)
 344:	b8 0c 00 00 00       	mov    $0xc,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sleep>:
SYSCALL(sleep)
 34c:	b8 0d 00 00 00       	mov    $0xd,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <uptime>:
SYSCALL(uptime)
 354:	b8 0e 00 00 00       	mov    $0xe,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <halt>:
SYSCALL(halt)
 35c:	b8 16 00 00 00       	mov    $0x16,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <date>:
SYSCALL(date)
 364:	b8 17 00 00 00       	mov    $0x17,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <getuid>:
SYSCALL(getuid)
 36c:	b8 18 00 00 00       	mov    $0x18,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <getgid>:
SYSCALL(getgid)
 374:	b8 19 00 00 00       	mov    $0x19,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <getppid>:
SYSCALL(getppid)
 37c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <setuid>:
SYSCALL(setuid)
 384:	b8 1b 00 00 00       	mov    $0x1b,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <setgid>:
SYSCALL(setgid)
 38c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <getprocs>:
SYSCALL(getprocs)
 394:	b8 1d 00 00 00       	mov    $0x1d,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <looper>:
SYSCALL(looper)
 39c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <setpriority>:
SYSCALL(setpriority)
 3a4:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <chmod>:
SYSCALL(chmod)
 3ac:	b8 20 00 00 00       	mov    $0x20,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chown>:
SYSCALL(chown)
 3b4:	b8 21 00 00 00       	mov    $0x21,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <chgrp>:
SYSCALL(chgrp)
 3bc:	b8 22 00 00 00       	mov    $0x22,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 18             	sub    $0x18,%esp
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d0:	83 ec 04             	sub    $0x4,%esp
 3d3:	6a 01                	push   $0x1
 3d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d8:	50                   	push   %eax
 3d9:	ff 75 08             	pushl  0x8(%ebp)
 3dc:	e8 fb fe ff ff       	call   2dc <write>
 3e1:	83 c4 10             	add    $0x10,%esp
}
 3e4:	90                   	nop
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	53                   	push   %ebx
 3eb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f9:	74 17                	je     412 <printint+0x2b>
 3fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ff:	79 11                	jns    412 <printint+0x2b>
    neg = 1;
 401:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	f7 d8                	neg    %eax
 40d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 410:	eb 06                	jmp    418 <printint+0x31>
  } else {
    x = xx;
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 418:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 41f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 422:	8d 41 01             	lea    0x1(%ecx),%eax
 425:	89 45 f4             	mov    %eax,-0xc(%ebp)
 428:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42e:	ba 00 00 00 00       	mov    $0x0,%edx
 433:	f7 f3                	div    %ebx
 435:	89 d0                	mov    %edx,%eax
 437:	0f b6 80 b0 0a 00 00 	movzbl 0xab0(%eax),%eax
 43e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 442:	8b 5d 10             	mov    0x10(%ebp),%ebx
 445:	8b 45 ec             	mov    -0x14(%ebp),%eax
 448:	ba 00 00 00 00       	mov    $0x0,%edx
 44d:	f7 f3                	div    %ebx
 44f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 452:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 456:	75 c7                	jne    41f <printint+0x38>
  if(neg)
 458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45c:	74 2d                	je     48b <printint+0xa4>
    buf[i++] = '-';
 45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 461:	8d 50 01             	lea    0x1(%eax),%edx
 464:	89 55 f4             	mov    %edx,-0xc(%ebp)
 467:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 46c:	eb 1d                	jmp    48b <printint+0xa4>
    putc(fd, buf[i]);
 46e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 471:	8b 45 f4             	mov    -0xc(%ebp),%eax
 474:	01 d0                	add    %edx,%eax
 476:	0f b6 00             	movzbl (%eax),%eax
 479:	0f be c0             	movsbl %al,%eax
 47c:	83 ec 08             	sub    $0x8,%esp
 47f:	50                   	push   %eax
 480:	ff 75 08             	pushl  0x8(%ebp)
 483:	e8 3c ff ff ff       	call   3c4 <putc>
 488:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 493:	79 d9                	jns    46e <printint+0x87>
    putc(fd, buf[i]);
}
 495:	90                   	nop
 496:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 499:	c9                   	leave  
 49a:	c3                   	ret    

0000049b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49b:	55                   	push   %ebp
 49c:	89 e5                	mov    %esp,%ebp
 49e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a8:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ab:	83 c0 04             	add    $0x4,%eax
 4ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b8:	e9 59 01 00 00       	jmp    616 <printf+0x17b>
    c = fmt[i] & 0xff;
 4bd:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c3:	01 d0                	add    %edx,%eax
 4c5:	0f b6 00             	movzbl (%eax),%eax
 4c8:	0f be c0             	movsbl %al,%eax
 4cb:	25 ff 00 00 00       	and    $0xff,%eax
 4d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d7:	75 2c                	jne    505 <printf+0x6a>
      if(c == '%'){
 4d9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4dd:	75 0c                	jne    4eb <printf+0x50>
        state = '%';
 4df:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e6:	e9 27 01 00 00       	jmp    612 <printf+0x177>
      } else {
        putc(fd, c);
 4eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	83 ec 08             	sub    $0x8,%esp
 4f4:	50                   	push   %eax
 4f5:	ff 75 08             	pushl  0x8(%ebp)
 4f8:	e8 c7 fe ff ff       	call   3c4 <putc>
 4fd:	83 c4 10             	add    $0x10,%esp
 500:	e9 0d 01 00 00       	jmp    612 <printf+0x177>
      }
    } else if(state == '%'){
 505:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 509:	0f 85 03 01 00 00    	jne    612 <printf+0x177>
      if(c == 'd'){
 50f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 513:	75 1e                	jne    533 <printf+0x98>
        printint(fd, *ap, 10, 1);
 515:	8b 45 e8             	mov    -0x18(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	6a 01                	push   $0x1
 51c:	6a 0a                	push   $0xa
 51e:	50                   	push   %eax
 51f:	ff 75 08             	pushl  0x8(%ebp)
 522:	e8 c0 fe ff ff       	call   3e7 <printint>
 527:	83 c4 10             	add    $0x10,%esp
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52e:	e9 d8 00 00 00       	jmp    60b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 533:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 537:	74 06                	je     53f <printf+0xa4>
 539:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53d:	75 1e                	jne    55d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 53f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 542:	8b 00                	mov    (%eax),%eax
 544:	6a 00                	push   $0x0
 546:	6a 10                	push   $0x10
 548:	50                   	push   %eax
 549:	ff 75 08             	pushl  0x8(%ebp)
 54c:	e8 96 fe ff ff       	call   3e7 <printint>
 551:	83 c4 10             	add    $0x10,%esp
        ap++;
 554:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 558:	e9 ae 00 00 00       	jmp    60b <printf+0x170>
      } else if(c == 's'){
 55d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 561:	75 43                	jne    5a6 <printf+0x10b>
        s = (char*)*ap;
 563:	8b 45 e8             	mov    -0x18(%ebp),%eax
 566:	8b 00                	mov    (%eax),%eax
 568:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 56b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 573:	75 25                	jne    59a <printf+0xff>
          s = "(null)";
 575:	c7 45 f4 5a 08 00 00 	movl   $0x85a,-0xc(%ebp)
        while(*s != 0){
 57c:	eb 1c                	jmp    59a <printf+0xff>
          putc(fd, *s);
 57e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 581:	0f b6 00             	movzbl (%eax),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	83 ec 08             	sub    $0x8,%esp
 58a:	50                   	push   %eax
 58b:	ff 75 08             	pushl  0x8(%ebp)
 58e:	e8 31 fe ff ff       	call   3c4 <putc>
 593:	83 c4 10             	add    $0x10,%esp
          s++;
 596:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	84 c0                	test   %al,%al
 5a2:	75 da                	jne    57e <printf+0xe3>
 5a4:	eb 65                	jmp    60b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5aa:	75 1d                	jne    5c9 <printf+0x12e>
        putc(fd, *ap);
 5ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	83 ec 08             	sub    $0x8,%esp
 5b7:	50                   	push   %eax
 5b8:	ff 75 08             	pushl  0x8(%ebp)
 5bb:	e8 04 fe ff ff       	call   3c4 <putc>
 5c0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c7:	eb 42                	jmp    60b <printf+0x170>
      } else if(c == '%'){
 5c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5cd:	75 17                	jne    5e6 <printf+0x14b>
        putc(fd, c);
 5cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d2:	0f be c0             	movsbl %al,%eax
 5d5:	83 ec 08             	sub    $0x8,%esp
 5d8:	50                   	push   %eax
 5d9:	ff 75 08             	pushl  0x8(%ebp)
 5dc:	e8 e3 fd ff ff       	call   3c4 <putc>
 5e1:	83 c4 10             	add    $0x10,%esp
 5e4:	eb 25                	jmp    60b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e6:	83 ec 08             	sub    $0x8,%esp
 5e9:	6a 25                	push   $0x25
 5eb:	ff 75 08             	pushl  0x8(%ebp)
 5ee:	e8 d1 fd ff ff       	call   3c4 <putc>
 5f3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	83 ec 08             	sub    $0x8,%esp
 5ff:	50                   	push   %eax
 600:	ff 75 08             	pushl  0x8(%ebp)
 603:	e8 bc fd ff ff       	call   3c4 <putc>
 608:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 60b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 612:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 616:	8b 55 0c             	mov    0xc(%ebp),%edx
 619:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61c:	01 d0                	add    %edx,%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	84 c0                	test   %al,%al
 623:	0f 85 94 fe ff ff    	jne    4bd <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 629:	90                   	nop
 62a:	c9                   	leave  
 62b:	c3                   	ret    

0000062c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62c:	55                   	push   %ebp
 62d:	89 e5                	mov    %esp,%ebp
 62f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	83 e8 08             	sub    $0x8,%eax
 638:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63b:	a1 cc 0a 00 00       	mov    0xacc,%eax
 640:	89 45 fc             	mov    %eax,-0x4(%ebp)
 643:	eb 24                	jmp    669 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	77 12                	ja     661 <free+0x35>
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 655:	77 24                	ja     67b <free+0x4f>
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	77 1a                	ja     67b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	89 45 fc             	mov    %eax,-0x4(%ebp)
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66f:	76 d4                	jbe    645 <free+0x19>
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 679:	76 ca                	jbe    645 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	8b 40 04             	mov    0x4(%eax),%eax
 681:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	01 c2                	add    %eax,%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	39 c2                	cmp    %eax,%edx
 694:	75 24                	jne    6ba <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	8b 50 04             	mov    0x4(%eax),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
 6b8:	eb 0a                	jmp    6c4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 40 04             	mov    0x4(%eax),%eax
 6ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d9:	75 20                	jne    6fb <free+0xcf>
    p->s.size += bp->s.size;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 50 04             	mov    0x4(%eax),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 40 04             	mov    0x4(%eax),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	89 10                	mov    %edx,(%eax)
 6f9:	eb 08                	jmp    703 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 701:	89 10                	mov    %edx,(%eax)
  freep = p;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	a3 cc 0a 00 00       	mov    %eax,0xacc
}
 70b:	90                   	nop
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <morecore>:

static Header*
morecore(uint nu)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 714:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71b:	77 07                	ja     724 <morecore+0x16>
    nu = 4096;
 71d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	c1 e0 03             	shl    $0x3,%eax
 72a:	83 ec 0c             	sub    $0xc,%esp
 72d:	50                   	push   %eax
 72e:	e8 11 fc ff ff       	call   344 <sbrk>
 733:	83 c4 10             	add    $0x10,%esp
 736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 739:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73d:	75 07                	jne    746 <morecore+0x38>
    return 0;
 73f:	b8 00 00 00 00       	mov    $0x0,%eax
 744:	eb 26                	jmp    76c <morecore+0x5e>
  hp = (Header*)p;
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74f:	8b 55 08             	mov    0x8(%ebp),%edx
 752:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	83 c0 08             	add    $0x8,%eax
 75b:	83 ec 0c             	sub    $0xc,%esp
 75e:	50                   	push   %eax
 75f:	e8 c8 fe ff ff       	call   62c <free>
 764:	83 c4 10             	add    $0x10,%esp
  return freep;
 767:	a1 cc 0a 00 00       	mov    0xacc,%eax
}
 76c:	c9                   	leave  
 76d:	c3                   	ret    

0000076e <malloc>:

void*
malloc(uint nbytes)
{
 76e:	55                   	push   %ebp
 76f:	89 e5                	mov    %esp,%ebp
 771:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	83 c0 07             	add    $0x7,%eax
 77a:	c1 e8 03             	shr    $0x3,%eax
 77d:	83 c0 01             	add    $0x1,%eax
 780:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 783:	a1 cc 0a 00 00       	mov    0xacc,%eax
 788:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78f:	75 23                	jne    7b4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 791:	c7 45 f0 c4 0a 00 00 	movl   $0xac4,-0x10(%ebp)
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	a3 cc 0a 00 00       	mov    %eax,0xacc
 7a0:	a1 cc 0a 00 00       	mov    0xacc,%eax
 7a5:	a3 c4 0a 00 00       	mov    %eax,0xac4
    base.s.size = 0;
 7aa:	c7 05 c8 0a 00 00 00 	movl   $0x0,0xac8
 7b1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c5:	72 4d                	jb     814 <malloc+0xa6>
      if(p->s.size == nunits)
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d0:	75 0c                	jne    7de <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 26                	jmp    804 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e7:	89 c2                	mov    %eax,%edx
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	c1 e0 03             	shl    $0x3,%eax
 7f8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
 801:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	a3 cc 0a 00 00       	mov    %eax,0xacc
      return (void*)(p + 1);
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	83 c0 08             	add    $0x8,%eax
 812:	eb 3b                	jmp    84f <malloc+0xe1>
    }
    if(p == freep)
 814:	a1 cc 0a 00 00       	mov    0xacc,%eax
 819:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81c:	75 1e                	jne    83c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 81e:	83 ec 0c             	sub    $0xc,%esp
 821:	ff 75 ec             	pushl  -0x14(%ebp)
 824:	e8 e5 fe ff ff       	call   70e <morecore>
 829:	83 c4 10             	add    $0x10,%esp
 82c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 833:	75 07                	jne    83c <malloc+0xce>
        return 0;
 835:	b8 00 00 00 00       	mov    $0x0,%eax
 83a:	eb 13                	jmp    84f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 00                	mov    (%eax),%eax
 847:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84a:	e9 6d ff ff ff       	jmp    7bc <malloc+0x4e>
}
 84f:	c9                   	leave  
 850:	c3                   	ret    
