
_looper:     file format elf32-i386


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
	int rs;
	int pid = fork();
  11:	e8 a5 02 00 00       	call   2bb <fork>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(pid == 0)
  19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1d:	75 48                	jne    67 <main+0x67>
	{
		rs = setpriority(getpid(),0);
  1f:	e8 1f 03 00 00       	call   343 <getpid>
  24:	83 ec 08             	sub    $0x8,%esp
  27:	6a 00                	push   $0x0
  29:	50                   	push   %eax
  2a:	e8 7c 03 00 00       	call   3ab <setpriority>
  2f:	83 c4 10             	add    $0x10,%esp
  32:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(rs == -1)
  35:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  39:	75 12                	jne    4d <main+0x4d>
			printf(2, "WARNING: That Priority doesn't exist! \n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 58 08 00 00       	push   $0x858
  43:	6a 02                	push   $0x2
  45:	e8 58 04 00 00       	call   4a2 <printf>
  4a:	83 c4 10             	add    $0x10,%esp
		if(rs == -2)
  4d:	83 7d f0 fe          	cmpl   $0xfffffffe,-0x10(%ebp)
  51:	75 12                	jne    65 <main+0x65>
			printf(2, "WARNING: That PID doesn't exist! \n");
  53:	83 ec 08             	sub    $0x8,%esp
  56:	68 80 08 00 00       	push   $0x880
  5b:	6a 02                	push   $0x2
  5d:	e8 40 04 00 00       	call   4a2 <printf>
  62:	83 c4 10             	add    $0x10,%esp
		while(1);
  65:	eb fe                	jmp    65 <main+0x65>
			
	}
	exit();
  67:	e8 57 02 00 00       	call   2c3 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	90                   	nop
  8e:	5b                   	pop    %ebx
  8f:	5f                   	pop    %edi
  90:	5d                   	pop    %ebp
  91:	c3                   	ret    

00000092 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9e:	90                   	nop
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	8d 50 01             	lea    0x1(%eax),%edx
  a5:	89 55 08             	mov    %edx,0x8(%ebp)
  a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b1:	0f b6 12             	movzbl (%edx),%edx
  b4:	88 10                	mov    %dl,(%eax)
  b6:	0f b6 00             	movzbl (%eax),%eax
  b9:	84 c0                	test   %al,%al
  bb:	75 e2                	jne    9f <strcpy+0xd>
    ;
  return os;
  bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c0:	c9                   	leave  
  c1:	c3                   	ret    

000000c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c5:	eb 08                	jmp    cf <strcmp+0xd>
    p++, q++;
  c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	74 10                	je     e9 <strcmp+0x27>
  d9:	8b 45 08             	mov    0x8(%ebp),%eax
  dc:	0f b6 10             	movzbl (%eax),%edx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	38 c2                	cmp    %al,%dl
  e7:	74 de                	je     c7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	0f b6 d0             	movzbl %al,%edx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	0f b6 c0             	movzbl %al,%eax
  fb:	29 c2                	sub    %eax,%edx
  fd:	89 d0                	mov    %edx,%eax
}
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strlen>:

uint
strlen(char *s)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10e:	eb 04                	jmp    114 <strlen+0x13>
 110:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 114:	8b 55 fc             	mov    -0x4(%ebp),%edx
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	01 d0                	add    %edx,%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	84 c0                	test   %al,%al
 121:	75 ed                	jne    110 <strlen+0xf>
    ;
  return n;
 123:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 12b:	8b 45 10             	mov    0x10(%ebp),%eax
 12e:	50                   	push   %eax
 12f:	ff 75 0c             	pushl  0xc(%ebp)
 132:	ff 75 08             	pushl  0x8(%ebp)
 135:	e8 32 ff ff ff       	call   6c <stosb>
 13a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 04             	sub    $0x4,%esp
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14e:	eb 14                	jmp    164 <strchr+0x22>
    if(*s == c)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	3a 45 fc             	cmp    -0x4(%ebp),%al
 159:	75 05                	jne    160 <strchr+0x1e>
      return (char*)s;
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	eb 13                	jmp    173 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 160:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	75 e2                	jne    150 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 173:	c9                   	leave  
 174:	c3                   	ret    

00000175 <gets>:

char*
gets(char *buf, int max)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 182:	eb 42                	jmp    1c6 <gets+0x51>
    cc = read(0, &c, 1);
 184:	83 ec 04             	sub    $0x4,%esp
 187:	6a 01                	push   $0x1
 189:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18c:	50                   	push   %eax
 18d:	6a 00                	push   $0x0
 18f:	e8 47 01 00 00       	call   2db <read>
 194:	83 c4 10             	add    $0x10,%esp
 197:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19e:	7e 33                	jle    1d3 <gets+0x5e>
      break;
    buf[i++] = c;
 1a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a3:	8d 50 01             	lea    0x1(%eax),%edx
 1a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a9:	89 c2                	mov    %eax,%edx
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	01 c2                	add    %eax,%edx
 1b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	3c 0a                	cmp    $0xa,%al
 1bc:	74 16                	je     1d4 <gets+0x5f>
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0d                	cmp    $0xd,%al
 1c4:	74 0e                	je     1d4 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c9:	83 c0 01             	add    $0x1,%eax
 1cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1cf:	7c b3                	jl     184 <gets+0xf>
 1d1:	eb 01                	jmp    1d4 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	01 d0                	add    %edx,%eax
 1dc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <stat>:

int
stat(char *n, struct stat *st)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	6a 00                	push   $0x0
 1ef:	ff 75 08             	pushl  0x8(%ebp)
 1f2:	e8 0c 01 00 00       	call   303 <open>
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 201:	79 07                	jns    20a <stat+0x26>
    return -1;
 203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 208:	eb 25                	jmp    22f <stat+0x4b>
  r = fstat(fd, st);
 20a:	83 ec 08             	sub    $0x8,%esp
 20d:	ff 75 0c             	pushl  0xc(%ebp)
 210:	ff 75 f4             	pushl  -0xc(%ebp)
 213:	e8 03 01 00 00       	call   31b <fstat>
 218:	83 c4 10             	add    $0x10,%esp
 21b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21e:	83 ec 0c             	sub    $0xc,%esp
 221:	ff 75 f4             	pushl  -0xc(%ebp)
 224:	e8 c2 00 00 00       	call   2eb <close>
 229:	83 c4 10             	add    $0x10,%esp
  return r;
 22c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <atoi>:

int
atoi(const char *s)
{
 231:	55                   	push   %ebp
 232:	89 e5                	mov    %esp,%ebp
 234:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 237:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23e:	eb 25                	jmp    265 <atoi+0x34>
    n = n*10 + *s++ - '0';
 240:	8b 55 fc             	mov    -0x4(%ebp),%edx
 243:	89 d0                	mov    %edx,%eax
 245:	c1 e0 02             	shl    $0x2,%eax
 248:	01 d0                	add    %edx,%eax
 24a:	01 c0                	add    %eax,%eax
 24c:	89 c1                	mov    %eax,%ecx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	8d 50 01             	lea    0x1(%eax),%edx
 254:	89 55 08             	mov    %edx,0x8(%ebp)
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	0f be c0             	movsbl %al,%eax
 25d:	01 c8                	add    %ecx,%eax
 25f:	83 e8 30             	sub    $0x30,%eax
 262:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	3c 2f                	cmp    $0x2f,%al
 26d:	7e 0a                	jle    279 <atoi+0x48>
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	3c 39                	cmp    $0x39,%al
 277:	7e c7                	jle    240 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 279:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 290:	eb 17                	jmp    2a9 <memmove+0x2b>
    *dst++ = *src++;
 292:	8b 45 fc             	mov    -0x4(%ebp),%eax
 295:	8d 50 01             	lea    0x1(%eax),%edx
 298:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29e:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a4:	0f b6 12             	movzbl (%edx),%edx
 2a7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a9:	8b 45 10             	mov    0x10(%ebp),%eax
 2ac:	8d 50 ff             	lea    -0x1(%eax),%edx
 2af:	89 55 10             	mov    %edx,0x10(%ebp)
 2b2:	85 c0                	test   %eax,%eax
 2b4:	7f dc                	jg     292 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b9:	c9                   	leave  
 2ba:	c3                   	ret    

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <halt>:
SYSCALL(halt)
 363:	b8 16 00 00 00       	mov    $0x16,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <date>:
SYSCALL(date)
 36b:	b8 17 00 00 00       	mov    $0x17,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getuid>:
SYSCALL(getuid)
 373:	b8 18 00 00 00       	mov    $0x18,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getgid>:
SYSCALL(getgid)
 37b:	b8 19 00 00 00       	mov    $0x19,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getppid>:
SYSCALL(getppid)
 383:	b8 1a 00 00 00       	mov    $0x1a,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <setuid>:
SYSCALL(setuid)
 38b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <setgid>:
SYSCALL(setgid)
 393:	b8 1c 00 00 00       	mov    $0x1c,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <getprocs>:
SYSCALL(getprocs)
 39b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <looper>:
SYSCALL(looper)
 3a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <setpriority>:
SYSCALL(setpriority)
 3ab:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <chmod>:
SYSCALL(chmod)
 3b3:	b8 20 00 00 00       	mov    $0x20,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <chown>:
SYSCALL(chown)
 3bb:	b8 21 00 00 00       	mov    $0x21,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <chgrp>:
SYSCALL(chgrp)
 3c3:	b8 22 00 00 00       	mov    $0x22,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 18             	sub    $0x18,%esp
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d7:	83 ec 04             	sub    $0x4,%esp
 3da:	6a 01                	push   $0x1
 3dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3df:	50                   	push   %eax
 3e0:	ff 75 08             	pushl  0x8(%ebp)
 3e3:	e8 fb fe ff ff       	call   2e3 <write>
 3e8:	83 c4 10             	add    $0x10,%esp
}
 3eb:	90                   	nop
 3ec:	c9                   	leave  
 3ed:	c3                   	ret    

000003ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ee:	55                   	push   %ebp
 3ef:	89 e5                	mov    %esp,%ebp
 3f1:	53                   	push   %ebx
 3f2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3fc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 400:	74 17                	je     419 <printint+0x2b>
 402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 406:	79 11                	jns    419 <printint+0x2b>
    neg = 1;
 408:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	f7 d8                	neg    %eax
 414:	89 45 ec             	mov    %eax,-0x14(%ebp)
 417:	eb 06                	jmp    41f <printint+0x31>
  } else {
    x = xx;
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 41f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 426:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 429:	8d 41 01             	lea    0x1(%ecx),%eax
 42c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 42f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 432:	8b 45 ec             	mov    -0x14(%ebp),%eax
 435:	ba 00 00 00 00       	mov    $0x0,%edx
 43a:	f7 f3                	div    %ebx
 43c:	89 d0                	mov    %edx,%eax
 43e:	0f b6 80 f4 0a 00 00 	movzbl 0xaf4(%eax),%eax
 445:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 449:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44f:	ba 00 00 00 00       	mov    $0x0,%edx
 454:	f7 f3                	div    %ebx
 456:	89 45 ec             	mov    %eax,-0x14(%ebp)
 459:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45d:	75 c7                	jne    426 <printint+0x38>
  if(neg)
 45f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 463:	74 2d                	je     492 <printint+0xa4>
    buf[i++] = '-';
 465:	8b 45 f4             	mov    -0xc(%ebp),%eax
 468:	8d 50 01             	lea    0x1(%eax),%edx
 46b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 473:	eb 1d                	jmp    492 <printint+0xa4>
    putc(fd, buf[i]);
 475:	8d 55 dc             	lea    -0x24(%ebp),%edx
 478:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	0f b6 00             	movzbl (%eax),%eax
 480:	0f be c0             	movsbl %al,%eax
 483:	83 ec 08             	sub    $0x8,%esp
 486:	50                   	push   %eax
 487:	ff 75 08             	pushl  0x8(%ebp)
 48a:	e8 3c ff ff ff       	call   3cb <putc>
 48f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 492:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49a:	79 d9                	jns    475 <printint+0x87>
    putc(fd, buf[i]);
}
 49c:	90                   	nop
 49d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a0:	c9                   	leave  
 4a1:	c3                   	ret    

000004a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4af:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b2:	83 c0 04             	add    $0x4,%eax
 4b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4bf:	e9 59 01 00 00       	jmp    61d <printf+0x17b>
    c = fmt[i] & 0xff;
 4c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ca:	01 d0                	add    %edx,%eax
 4cc:	0f b6 00             	movzbl (%eax),%eax
 4cf:	0f be c0             	movsbl %al,%eax
 4d2:	25 ff 00 00 00       	and    $0xff,%eax
 4d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4de:	75 2c                	jne    50c <printf+0x6a>
      if(c == '%'){
 4e0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e4:	75 0c                	jne    4f2 <printf+0x50>
        state = '%';
 4e6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ed:	e9 27 01 00 00       	jmp    619 <printf+0x177>
      } else {
        putc(fd, c);
 4f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f5:	0f be c0             	movsbl %al,%eax
 4f8:	83 ec 08             	sub    $0x8,%esp
 4fb:	50                   	push   %eax
 4fc:	ff 75 08             	pushl  0x8(%ebp)
 4ff:	e8 c7 fe ff ff       	call   3cb <putc>
 504:	83 c4 10             	add    $0x10,%esp
 507:	e9 0d 01 00 00       	jmp    619 <printf+0x177>
      }
    } else if(state == '%'){
 50c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 510:	0f 85 03 01 00 00    	jne    619 <printf+0x177>
      if(c == 'd'){
 516:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51a:	75 1e                	jne    53a <printf+0x98>
        printint(fd, *ap, 10, 1);
 51c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51f:	8b 00                	mov    (%eax),%eax
 521:	6a 01                	push   $0x1
 523:	6a 0a                	push   $0xa
 525:	50                   	push   %eax
 526:	ff 75 08             	pushl  0x8(%ebp)
 529:	e8 c0 fe ff ff       	call   3ee <printint>
 52e:	83 c4 10             	add    $0x10,%esp
        ap++;
 531:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 535:	e9 d8 00 00 00       	jmp    612 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 53a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53e:	74 06                	je     546 <printf+0xa4>
 540:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 544:	75 1e                	jne    564 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 546:	8b 45 e8             	mov    -0x18(%ebp),%eax
 549:	8b 00                	mov    (%eax),%eax
 54b:	6a 00                	push   $0x0
 54d:	6a 10                	push   $0x10
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 96 fe ff ff       	call   3ee <printint>
 558:	83 c4 10             	add    $0x10,%esp
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55f:	e9 ae 00 00 00       	jmp    612 <printf+0x170>
      } else if(c == 's'){
 564:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 568:	75 43                	jne    5ad <printf+0x10b>
        s = (char*)*ap;
 56a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57a:	75 25                	jne    5a1 <printf+0xff>
          s = "(null)";
 57c:	c7 45 f4 a3 08 00 00 	movl   $0x8a3,-0xc(%ebp)
        while(*s != 0){
 583:	eb 1c                	jmp    5a1 <printf+0xff>
          putc(fd, *s);
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	83 ec 08             	sub    $0x8,%esp
 591:	50                   	push   %eax
 592:	ff 75 08             	pushl  0x8(%ebp)
 595:	e8 31 fe ff ff       	call   3cb <putc>
 59a:	83 c4 10             	add    $0x10,%esp
          s++;
 59d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a4:	0f b6 00             	movzbl (%eax),%eax
 5a7:	84 c0                	test   %al,%al
 5a9:	75 da                	jne    585 <printf+0xe3>
 5ab:	eb 65                	jmp    612 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ad:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b1:	75 1d                	jne    5d0 <printf+0x12e>
        putc(fd, *ap);
 5b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 04 fe ff ff       	call   3cb <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ce:	eb 42                	jmp    612 <printf+0x170>
      } else if(c == '%'){
 5d0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d4:	75 17                	jne    5ed <printf+0x14b>
        putc(fd, c);
 5d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	83 ec 08             	sub    $0x8,%esp
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 e3 fd ff ff       	call   3cb <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
 5eb:	eb 25                	jmp    612 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	6a 25                	push   $0x25
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 d1 fd ff ff       	call   3cb <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	83 ec 08             	sub    $0x8,%esp
 606:	50                   	push   %eax
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 bc fd ff ff       	call   3cb <putc>
 60f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 612:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 619:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 61d:	8b 55 0c             	mov    0xc(%ebp),%edx
 620:	8b 45 f0             	mov    -0x10(%ebp),%eax
 623:	01 d0                	add    %edx,%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	84 c0                	test   %al,%al
 62a:	0f 85 94 fe ff ff    	jne    4c4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 630:	90                   	nop
 631:	c9                   	leave  
 632:	c3                   	ret    

00000633 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	83 e8 08             	sub    $0x8,%eax
 63f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 642:	a1 10 0b 00 00       	mov    0xb10,%eax
 647:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64a:	eb 24                	jmp    670 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 654:	77 12                	ja     668 <free+0x35>
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65c:	77 24                	ja     682 <free+0x4f>
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 666:	77 1a                	ja     682 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 676:	76 d4                	jbe    64c <free+0x19>
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 680:	76 ca                	jbe    64c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 40 04             	mov    0x4(%eax),%eax
 688:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	01 c2                	add    %eax,%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	39 c2                	cmp    %eax,%edx
 69b:	75 24                	jne    6c1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	8b 50 04             	mov    0x4(%eax),%edx
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	8b 40 04             	mov    0x4(%eax),%eax
 6ab:	01 c2                	add    %eax,%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	8b 10                	mov    (%eax),%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	89 10                	mov    %edx,(%eax)
 6bf:	eb 0a                	jmp    6cb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 10                	mov    (%eax),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 40 04             	mov    0x4(%eax),%eax
 6d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	01 d0                	add    %edx,%eax
 6dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e0:	75 20                	jne    702 <free+0xcf>
    p->s.size += bp->s.size;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 50 04             	mov    0x4(%eax),%edx
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	8b 40 04             	mov    0x4(%eax),%eax
 6ee:	01 c2                	add    %eax,%edx
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
 700:	eb 08                	jmp    70a <free+0xd7>
  } else
    p->s.ptr = bp;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 55 f8             	mov    -0x8(%ebp),%edx
 708:	89 10                	mov    %edx,(%eax)
  freep = p;
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	a3 10 0b 00 00       	mov    %eax,0xb10
}
 712:	90                   	nop
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <morecore>:

static Header*
morecore(uint nu)
{
 715:	55                   	push   %ebp
 716:	89 e5                	mov    %esp,%ebp
 718:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 722:	77 07                	ja     72b <morecore+0x16>
    nu = 4096;
 724:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	c1 e0 03             	shl    $0x3,%eax
 731:	83 ec 0c             	sub    $0xc,%esp
 734:	50                   	push   %eax
 735:	e8 11 fc ff ff       	call   34b <sbrk>
 73a:	83 c4 10             	add    $0x10,%esp
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 740:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 744:	75 07                	jne    74d <morecore+0x38>
    return 0;
 746:	b8 00 00 00 00       	mov    $0x0,%eax
 74b:	eb 26                	jmp    773 <morecore+0x5e>
  hp = (Header*)p;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	8b 55 08             	mov    0x8(%ebp),%edx
 759:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	83 c0 08             	add    $0x8,%eax
 762:	83 ec 0c             	sub    $0xc,%esp
 765:	50                   	push   %eax
 766:	e8 c8 fe ff ff       	call   633 <free>
 76b:	83 c4 10             	add    $0x10,%esp
  return freep;
 76e:	a1 10 0b 00 00       	mov    0xb10,%eax
}
 773:	c9                   	leave  
 774:	c3                   	ret    

00000775 <malloc>:

void*
malloc(uint nbytes)
{
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77b:	8b 45 08             	mov    0x8(%ebp),%eax
 77e:	83 c0 07             	add    $0x7,%eax
 781:	c1 e8 03             	shr    $0x3,%eax
 784:	83 c0 01             	add    $0x1,%eax
 787:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78a:	a1 10 0b 00 00       	mov    0xb10,%eax
 78f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 796:	75 23                	jne    7bb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 798:	c7 45 f0 08 0b 00 00 	movl   $0xb08,-0x10(%ebp)
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	a3 10 0b 00 00       	mov    %eax,0xb10
 7a7:	a1 10 0b 00 00       	mov    0xb10,%eax
 7ac:	a3 08 0b 00 00       	mov    %eax,0xb08
    base.s.size = 0;
 7b1:	c7 05 0c 0b 00 00 00 	movl   $0x0,0xb0c
 7b8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cc:	72 4d                	jb     81b <malloc+0xa6>
      if(p->s.size == nunits)
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d7:	75 0c                	jne    7e5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
 7e3:	eb 26                	jmp    80b <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ee:	89 c2                	mov    %eax,%edx
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	c1 e0 03             	shl    $0x3,%eax
 7ff:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 55 ec             	mov    -0x14(%ebp),%edx
 808:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80e:	a3 10 0b 00 00       	mov    %eax,0xb10
      return (void*)(p + 1);
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	83 c0 08             	add    $0x8,%eax
 819:	eb 3b                	jmp    856 <malloc+0xe1>
    }
    if(p == freep)
 81b:	a1 10 0b 00 00       	mov    0xb10,%eax
 820:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 823:	75 1e                	jne    843 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 825:	83 ec 0c             	sub    $0xc,%esp
 828:	ff 75 ec             	pushl  -0x14(%ebp)
 82b:	e8 e5 fe ff ff       	call   715 <morecore>
 830:	83 c4 10             	add    $0x10,%esp
 833:	89 45 f4             	mov    %eax,-0xc(%ebp)
 836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83a:	75 07                	jne    843 <malloc+0xce>
        return 0;
 83c:	b8 00 00 00 00       	mov    $0x0,%eax
 841:	eb 13                	jmp    856 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	89 45 f0             	mov    %eax,-0x10(%ebp)
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 851:	e9 6d ff ff ff       	jmp    7c3 <malloc+0x4e>
}
 856:	c9                   	leave  
 857:	c3                   	ret    
