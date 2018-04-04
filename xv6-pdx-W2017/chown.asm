
_chown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char ** argv)
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
        char *owner;
        if (argc != 3)
  14:	83 3b 03             	cmpl   $0x3,(%ebx)
  17:	74 05                	je     1e <main+0x1e>
          exit();
  19:	e8 d7 02 00 00       	call   2f5 <exit>

        owner = argv[1];
  1e:	8b 43 04             	mov    0x4(%ebx),%eax
  21:	8b 40 04             	mov    0x4(%eax),%eax
  24:	89 45 f0             	mov    %eax,-0x10(%ebp)
        for(i = 0; i < strlen(owner); ++i)
  27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  2e:	eb 27                	jmp    57 <main+0x57>
        {
                if (!(owner[i] >= '0' && owner[i] <= '9'))
  30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  36:	01 d0                	add    %edx,%eax
  38:	0f b6 00             	movzbl (%eax),%eax
  3b:	3c 2f                	cmp    $0x2f,%al
  3d:	7e 0f                	jle    4e <main+0x4e>
  3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  45:	01 d0                	add    %edx,%eax
  47:	0f b6 00             	movzbl (%eax),%eax
  4a:	3c 39                	cmp    $0x39,%al
  4c:	7e 05                	jle    53 <main+0x53>
                        exit();
  4e:	e8 a2 02 00 00       	call   2f5 <exit>
        char *owner;
        if (argc != 3)
          exit();

        owner = argv[1];
        for(i = 0; i < strlen(owner); ++i)
  53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  57:	83 ec 0c             	sub    $0xc,%esp
  5a:	ff 75 f0             	pushl  -0x10(%ebp)
  5d:	e8 d1 00 00 00       	call   133 <strlen>
  62:	83 c4 10             	add    $0x10,%esp
  65:	89 c2                	mov    %eax,%edx
  67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6a:	39 c2                	cmp    %eax,%edx
  6c:	77 c2                	ja     30 <main+0x30>
        {
                if (!(owner[i] >= '0' && owner[i] <= '9'))
                        exit();

        }
	chown(argv[2], atoi(argv[1]));
  6e:	8b 43 04             	mov    0x4(%ebx),%eax
  71:	83 c0 04             	add    $0x4,%eax
  74:	8b 00                	mov    (%eax),%eax
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	50                   	push   %eax
  7a:	e8 e4 01 00 00       	call   263 <atoi>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	89 c2                	mov    %eax,%edx
  84:	8b 43 04             	mov    0x4(%ebx),%eax
  87:	83 c0 08             	add    $0x8,%eax
  8a:	8b 00                	mov    (%eax),%eax
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	52                   	push   %edx
  90:	50                   	push   %eax
  91:	e8 57 03 00 00       	call   3ed <chown>
  96:	83 c4 10             	add    $0x10,%esp
	exit();
  99:	e8 57 02 00 00       	call   2f5 <exit>

0000009e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	57                   	push   %edi
  a2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a6:	8b 55 10             	mov    0x10(%ebp),%edx
  a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  ac:	89 cb                	mov    %ecx,%ebx
  ae:	89 df                	mov    %ebx,%edi
  b0:	89 d1                	mov    %edx,%ecx
  b2:	fc                   	cld    
  b3:	f3 aa                	rep stos %al,%es:(%edi)
  b5:	89 ca                	mov    %ecx,%edx
  b7:	89 fb                	mov    %edi,%ebx
  b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
  bc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  bf:	90                   	nop
  c0:	5b                   	pop    %ebx
  c1:	5f                   	pop    %edi
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d0:	90                   	nop
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	8d 50 01             	lea    0x1(%eax),%edx
  d7:	89 55 08             	mov    %edx,0x8(%ebp)
  da:	8b 55 0c             	mov    0xc(%ebp),%edx
  dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  e0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  e3:	0f b6 12             	movzbl (%edx),%edx
  e6:	88 10                	mov    %dl,(%eax)
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	84 c0                	test   %al,%al
  ed:	75 e2                	jne    d1 <strcpy+0xd>
    ;
  return os;
  ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f2:	c9                   	leave  
  f3:	c3                   	ret    

000000f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f7:	eb 08                	jmp    101 <strcmp+0xd>
    p++, q++;
  f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 101:	8b 45 08             	mov    0x8(%ebp),%eax
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	84 c0                	test   %al,%al
 109:	74 10                	je     11b <strcmp+0x27>
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 10             	movzbl (%eax),%edx
 111:	8b 45 0c             	mov    0xc(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	38 c2                	cmp    %al,%dl
 119:	74 de                	je     f9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	0f b6 00             	movzbl (%eax),%eax
 121:	0f b6 d0             	movzbl %al,%edx
 124:	8b 45 0c             	mov    0xc(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	0f b6 c0             	movzbl %al,%eax
 12d:	29 c2                	sub    %eax,%edx
 12f:	89 d0                	mov    %edx,%eax
}
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    

00000133 <strlen>:

uint
strlen(char *s)
{
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
 136:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 140:	eb 04                	jmp    146 <strlen+0x13>
 142:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 146:	8b 55 fc             	mov    -0x4(%ebp),%edx
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	01 d0                	add    %edx,%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	84 c0                	test   %al,%al
 153:	75 ed                	jne    142 <strlen+0xf>
    ;
  return n;
 155:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 158:	c9                   	leave  
 159:	c3                   	ret    

0000015a <memset>:

void*
memset(void *dst, int c, uint n)
{
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 15d:	8b 45 10             	mov    0x10(%ebp),%eax
 160:	50                   	push   %eax
 161:	ff 75 0c             	pushl  0xc(%ebp)
 164:	ff 75 08             	pushl  0x8(%ebp)
 167:	e8 32 ff ff ff       	call   9e <stosb>
 16c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 172:	c9                   	leave  
 173:	c3                   	ret    

00000174 <strchr>:

char*
strchr(const char *s, char c)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	83 ec 04             	sub    $0x4,%esp
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 180:	eb 14                	jmp    196 <strchr+0x22>
    if(*s == c)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18b:	75 05                	jne    192 <strchr+0x1e>
      return (char*)s;
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	eb 13                	jmp    1a5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 192:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	0f b6 00             	movzbl (%eax),%eax
 19c:	84 c0                	test   %al,%al
 19e:	75 e2                	jne    182 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a5:	c9                   	leave  
 1a6:	c3                   	ret    

000001a7 <gets>:

char*
gets(char *buf, int max)
{
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b4:	eb 42                	jmp    1f8 <gets+0x51>
    cc = read(0, &c, 1);
 1b6:	83 ec 04             	sub    $0x4,%esp
 1b9:	6a 01                	push   $0x1
 1bb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1be:	50                   	push   %eax
 1bf:	6a 00                	push   $0x0
 1c1:	e8 47 01 00 00       	call   30d <read>
 1c6:	83 c4 10             	add    $0x10,%esp
 1c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d0:	7e 33                	jle    205 <gets+0x5e>
      break;
    buf[i++] = c;
 1d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d5:	8d 50 01             	lea    0x1(%eax),%edx
 1d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1db:	89 c2                	mov    %eax,%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 c2                	add    %eax,%edx
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ec:	3c 0a                	cmp    $0xa,%al
 1ee:	74 16                	je     206 <gets+0x5f>
 1f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f4:	3c 0d                	cmp    $0xd,%al
 1f6:	74 0e                	je     206 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fb:	83 c0 01             	add    $0x1,%eax
 1fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
 201:	7c b3                	jl     1b6 <gets+0xf>
 203:	eb 01                	jmp    206 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 205:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 206:	8b 55 f4             	mov    -0xc(%ebp),%edx
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	01 d0                	add    %edx,%eax
 20e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 211:	8b 45 08             	mov    0x8(%ebp),%eax
}
 214:	c9                   	leave  
 215:	c3                   	ret    

00000216 <stat>:

int
stat(char *n, struct stat *st)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21c:	83 ec 08             	sub    $0x8,%esp
 21f:	6a 00                	push   $0x0
 221:	ff 75 08             	pushl  0x8(%ebp)
 224:	e8 0c 01 00 00       	call   335 <open>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 233:	79 07                	jns    23c <stat+0x26>
    return -1;
 235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23a:	eb 25                	jmp    261 <stat+0x4b>
  r = fstat(fd, st);
 23c:	83 ec 08             	sub    $0x8,%esp
 23f:	ff 75 0c             	pushl  0xc(%ebp)
 242:	ff 75 f4             	pushl  -0xc(%ebp)
 245:	e8 03 01 00 00       	call   34d <fstat>
 24a:	83 c4 10             	add    $0x10,%esp
 24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 250:	83 ec 0c             	sub    $0xc,%esp
 253:	ff 75 f4             	pushl  -0xc(%ebp)
 256:	e8 c2 00 00 00       	call   31d <close>
 25b:	83 c4 10             	add    $0x10,%esp
  return r;
 25e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 261:	c9                   	leave  
 262:	c3                   	ret    

00000263 <atoi>:

int
atoi(const char *s)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 270:	eb 25                	jmp    297 <atoi+0x34>
    n = n*10 + *s++ - '0';
 272:	8b 55 fc             	mov    -0x4(%ebp),%edx
 275:	89 d0                	mov    %edx,%eax
 277:	c1 e0 02             	shl    $0x2,%eax
 27a:	01 d0                	add    %edx,%eax
 27c:	01 c0                	add    %eax,%eax
 27e:	89 c1                	mov    %eax,%ecx
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	8d 50 01             	lea    0x1(%eax),%edx
 286:	89 55 08             	mov    %edx,0x8(%ebp)
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	0f be c0             	movsbl %al,%eax
 28f:	01 c8                	add    %ecx,%eax
 291:	83 e8 30             	sub    $0x30,%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	3c 2f                	cmp    $0x2f,%al
 29f:	7e 0a                	jle    2ab <atoi+0x48>
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3c 39                	cmp    $0x39,%al
 2a9:	7e c7                	jle    272 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ae:	c9                   	leave  
 2af:	c3                   	ret    

000002b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c2:	eb 17                	jmp    2db <memmove+0x2b>
    *dst++ = *src++;
 2c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c7:	8d 50 01             	lea    0x1(%eax),%edx
 2ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d6:	0f b6 12             	movzbl (%edx),%edx
 2d9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2db:	8b 45 10             	mov    0x10(%ebp),%eax
 2de:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e1:	89 55 10             	mov    %edx,0x10(%ebp)
 2e4:	85 c0                	test   %eax,%eax
 2e6:	7f dc                	jg     2c4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ed:	b8 01 00 00 00       	mov    $0x1,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <exit>:
SYSCALL(exit)
 2f5:	b8 02 00 00 00       	mov    $0x2,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <wait>:
SYSCALL(wait)
 2fd:	b8 03 00 00 00       	mov    $0x3,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <pipe>:
SYSCALL(pipe)
 305:	b8 04 00 00 00       	mov    $0x4,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <read>:
SYSCALL(read)
 30d:	b8 05 00 00 00       	mov    $0x5,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <write>:
SYSCALL(write)
 315:	b8 10 00 00 00       	mov    $0x10,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <close>:
SYSCALL(close)
 31d:	b8 15 00 00 00       	mov    $0x15,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <kill>:
SYSCALL(kill)
 325:	b8 06 00 00 00       	mov    $0x6,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exec>:
SYSCALL(exec)
 32d:	b8 07 00 00 00       	mov    $0x7,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <open>:
SYSCALL(open)
 335:	b8 0f 00 00 00       	mov    $0xf,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <mknod>:
SYSCALL(mknod)
 33d:	b8 11 00 00 00       	mov    $0x11,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <unlink>:
SYSCALL(unlink)
 345:	b8 12 00 00 00       	mov    $0x12,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <fstat>:
SYSCALL(fstat)
 34d:	b8 08 00 00 00       	mov    $0x8,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <link>:
SYSCALL(link)
 355:	b8 13 00 00 00       	mov    $0x13,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mkdir>:
SYSCALL(mkdir)
 35d:	b8 14 00 00 00       	mov    $0x14,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <chdir>:
SYSCALL(chdir)
 365:	b8 09 00 00 00       	mov    $0x9,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <dup>:
SYSCALL(dup)
 36d:	b8 0a 00 00 00       	mov    $0xa,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getpid>:
SYSCALL(getpid)
 375:	b8 0b 00 00 00       	mov    $0xb,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <sbrk>:
SYSCALL(sbrk)
 37d:	b8 0c 00 00 00       	mov    $0xc,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <sleep>:
SYSCALL(sleep)
 385:	b8 0d 00 00 00       	mov    $0xd,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <uptime>:
SYSCALL(uptime)
 38d:	b8 0e 00 00 00       	mov    $0xe,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <halt>:
SYSCALL(halt)
 395:	b8 16 00 00 00       	mov    $0x16,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <date>:
SYSCALL(date)
 39d:	b8 17 00 00 00       	mov    $0x17,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <getuid>:
SYSCALL(getuid)
 3a5:	b8 18 00 00 00       	mov    $0x18,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getgid>:
SYSCALL(getgid)
 3ad:	b8 19 00 00 00       	mov    $0x19,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <getppid>:
SYSCALL(getppid)
 3b5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <setuid>:
SYSCALL(setuid)
 3bd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <setgid>:
SYSCALL(setgid)
 3c5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getprocs>:
SYSCALL(getprocs)
 3cd:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <looper>:
SYSCALL(looper)
 3d5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <setpriority>:
SYSCALL(setpriority)
 3dd:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <chmod>:
SYSCALL(chmod)
 3e5:	b8 20 00 00 00       	mov    $0x20,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <chown>:
SYSCALL(chown)
 3ed:	b8 21 00 00 00       	mov    $0x21,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <chgrp>:
SYSCALL(chgrp)
 3f5:	b8 22 00 00 00       	mov    $0x22,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 18             	sub    $0x18,%esp
 403:	8b 45 0c             	mov    0xc(%ebp),%eax
 406:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 409:	83 ec 04             	sub    $0x4,%esp
 40c:	6a 01                	push   $0x1
 40e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 411:	50                   	push   %eax
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 fb fe ff ff       	call   315 <write>
 41a:	83 c4 10             	add    $0x10,%esp
}
 41d:	90                   	nop
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 432:	74 17                	je     44b <printint+0x2b>
 434:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 438:	79 11                	jns    44b <printint+0x2b>
    neg = 1;
 43a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	f7 d8                	neg    %eax
 446:	89 45 ec             	mov    %eax,-0x14(%ebp)
 449:	eb 06                	jmp    451 <printint+0x31>
  } else {
    x = xx;
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 458:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45b:	8d 41 01             	lea    0x1(%ecx),%eax
 45e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 461:	8b 5d 10             	mov    0x10(%ebp),%ebx
 464:	8b 45 ec             	mov    -0x14(%ebp),%eax
 467:	ba 00 00 00 00       	mov    $0x0,%edx
 46c:	f7 f3                	div    %ebx
 46e:	89 d0                	mov    %edx,%eax
 470:	0f b6 80 e0 0a 00 00 	movzbl 0xae0(%eax),%eax
 477:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 481:	ba 00 00 00 00       	mov    $0x0,%edx
 486:	f7 f3                	div    %ebx
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 c7                	jne    458 <printint+0x38>
  if(neg)
 491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 495:	74 2d                	je     4c4 <printint+0xa4>
    buf[i++] = '-';
 497:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49a:	8d 50 01             	lea    0x1(%eax),%edx
 49d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a5:	eb 1d                	jmp    4c4 <printint+0xa4>
    putc(fd, buf[i]);
 4a7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ad:	01 d0                	add    %edx,%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	83 ec 08             	sub    $0x8,%esp
 4b8:	50                   	push   %eax
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 3c ff ff ff       	call   3fd <putc>
 4c1:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cc:	79 d9                	jns    4a7 <printint+0x87>
    putc(fd, buf[i]);
}
 4ce:	90                   	nop
 4cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d2:	c9                   	leave  
 4d3:	c3                   	ret    

000004d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e4:	83 c0 04             	add    $0x4,%eax
 4e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f1:	e9 59 01 00 00       	jmp    64f <printf+0x17b>
    c = fmt[i] & 0xff;
 4f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fc:	01 d0                	add    %edx,%eax
 4fe:	0f b6 00             	movzbl (%eax),%eax
 501:	0f be c0             	movsbl %al,%eax
 504:	25 ff 00 00 00       	and    $0xff,%eax
 509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 510:	75 2c                	jne    53e <printf+0x6a>
      if(c == '%'){
 512:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 516:	75 0c                	jne    524 <printf+0x50>
        state = '%';
 518:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51f:	e9 27 01 00 00       	jmp    64b <printf+0x177>
      } else {
        putc(fd, c);
 524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	83 ec 08             	sub    $0x8,%esp
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 c7 fe ff ff       	call   3fd <putc>
 536:	83 c4 10             	add    $0x10,%esp
 539:	e9 0d 01 00 00       	jmp    64b <printf+0x177>
      }
    } else if(state == '%'){
 53e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 542:	0f 85 03 01 00 00    	jne    64b <printf+0x177>
      if(c == 'd'){
 548:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54c:	75 1e                	jne    56c <printf+0x98>
        printint(fd, *ap, 10, 1);
 54e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 551:	8b 00                	mov    (%eax),%eax
 553:	6a 01                	push   $0x1
 555:	6a 0a                	push   $0xa
 557:	50                   	push   %eax
 558:	ff 75 08             	pushl  0x8(%ebp)
 55b:	e8 c0 fe ff ff       	call   420 <printint>
 560:	83 c4 10             	add    $0x10,%esp
        ap++;
 563:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 567:	e9 d8 00 00 00       	jmp    644 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 56c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 570:	74 06                	je     578 <printf+0xa4>
 572:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 576:	75 1e                	jne    596 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 578:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	6a 00                	push   $0x0
 57f:	6a 10                	push   $0x10
 581:	50                   	push   %eax
 582:	ff 75 08             	pushl  0x8(%ebp)
 585:	e8 96 fe ff ff       	call   420 <printint>
 58a:	83 c4 10             	add    $0x10,%esp
        ap++;
 58d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 591:	e9 ae 00 00 00       	jmp    644 <printf+0x170>
      } else if(c == 's'){
 596:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59a:	75 43                	jne    5df <printf+0x10b>
        s = (char*)*ap;
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ac:	75 25                	jne    5d3 <printf+0xff>
          s = "(null)";
 5ae:	c7 45 f4 8a 08 00 00 	movl   $0x88a,-0xc(%ebp)
        while(*s != 0){
 5b5:	eb 1c                	jmp    5d3 <printf+0xff>
          putc(fd, *s);
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 31 fe ff ff       	call   3fd <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
          s++;
 5cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	84 c0                	test   %al,%al
 5db:	75 da                	jne    5b7 <printf+0xe3>
 5dd:	eb 65                	jmp    644 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5df:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e3:	75 1d                	jne    602 <printf+0x12e>
        putc(fd, *ap);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	50                   	push   %eax
 5f1:	ff 75 08             	pushl  0x8(%ebp)
 5f4:	e8 04 fe ff ff       	call   3fd <putc>
 5f9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 600:	eb 42                	jmp    644 <printf+0x170>
      } else if(c == '%'){
 602:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 606:	75 17                	jne    61f <printf+0x14b>
        putc(fd, c);
 608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	83 ec 08             	sub    $0x8,%esp
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 e3 fd ff ff       	call   3fd <putc>
 61a:	83 c4 10             	add    $0x10,%esp
 61d:	eb 25                	jmp    644 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	6a 25                	push   $0x25
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 d1 fd ff ff       	call   3fd <putc>
 62c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	83 ec 08             	sub    $0x8,%esp
 638:	50                   	push   %eax
 639:	ff 75 08             	pushl  0x8(%ebp)
 63c:	e8 bc fd ff ff       	call   3fd <putc>
 641:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 644:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64f:	8b 55 0c             	mov    0xc(%ebp),%edx
 652:	8b 45 f0             	mov    -0x10(%ebp),%eax
 655:	01 d0                	add    %edx,%eax
 657:	0f b6 00             	movzbl (%eax),%eax
 65a:	84 c0                	test   %al,%al
 65c:	0f 85 94 fe ff ff    	jne    4f6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 662:	90                   	nop
 663:	c9                   	leave  
 664:	c3                   	ret    

00000665 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 665:	55                   	push   %ebp
 666:	89 e5                	mov    %esp,%ebp
 668:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	83 e8 08             	sub    $0x8,%eax
 671:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	a1 fc 0a 00 00       	mov    0xafc,%eax
 679:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67c:	eb 24                	jmp    6a2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 686:	77 12                	ja     69a <free+0x35>
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68e:	77 24                	ja     6b4 <free+0x4f>
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 698:	77 1a                	ja     6b4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a8:	76 d4                	jbe    67e <free+0x19>
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b2:	76 ca                	jbe    67e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	8b 40 04             	mov    0x4(%eax),%eax
 6ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	01 c2                	add    %eax,%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	39 c2                	cmp    %eax,%edx
 6cd:	75 24                	jne    6f3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 50 04             	mov    0x4(%eax),%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	01 c2                	add    %eax,%edx
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
 6f1:	eb 0a                	jmp    6fd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 10                	mov    (%eax),%edx
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 40 04             	mov    0x4(%eax),%eax
 703:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	01 d0                	add    %edx,%eax
 70f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 712:	75 20                	jne    734 <free+0xcf>
    p->s.size += bp->s.size;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 50 04             	mov    0x4(%eax),%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	01 c2                	add    %eax,%edx
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	8b 10                	mov    (%eax),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	89 10                	mov    %edx,(%eax)
 732:	eb 08                	jmp    73c <free+0xd7>
  } else
    p->s.ptr = bp;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73a:	89 10                	mov    %edx,(%eax)
  freep = p;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	a3 fc 0a 00 00       	mov    %eax,0xafc
}
 744:	90                   	nop
 745:	c9                   	leave  
 746:	c3                   	ret    

00000747 <morecore>:

static Header*
morecore(uint nu)
{
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
 74a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 754:	77 07                	ja     75d <morecore+0x16>
    nu = 4096;
 756:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	c1 e0 03             	shl    $0x3,%eax
 763:	83 ec 0c             	sub    $0xc,%esp
 766:	50                   	push   %eax
 767:	e8 11 fc ff ff       	call   37d <sbrk>
 76c:	83 c4 10             	add    $0x10,%esp
 76f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 772:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 776:	75 07                	jne    77f <morecore+0x38>
    return 0;
 778:	b8 00 00 00 00       	mov    $0x0,%eax
 77d:	eb 26                	jmp    7a5 <morecore+0x5e>
  hp = (Header*)p;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	8b 55 08             	mov    0x8(%ebp),%edx
 78b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	83 c0 08             	add    $0x8,%eax
 794:	83 ec 0c             	sub    $0xc,%esp
 797:	50                   	push   %eax
 798:	e8 c8 fe ff ff       	call   665 <free>
 79d:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a0:	a1 fc 0a 00 00       	mov    0xafc,%eax
}
 7a5:	c9                   	leave  
 7a6:	c3                   	ret    

000007a7 <malloc>:

void*
malloc(uint nbytes)
{
 7a7:	55                   	push   %ebp
 7a8:	89 e5                	mov    %esp,%ebp
 7aa:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	83 c0 07             	add    $0x7,%eax
 7b3:	c1 e8 03             	shr    $0x3,%eax
 7b6:	83 c0 01             	add    $0x1,%eax
 7b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bc:	a1 fc 0a 00 00       	mov    0xafc,%eax
 7c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c8:	75 23                	jne    7ed <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ca:	c7 45 f0 f4 0a 00 00 	movl   $0xaf4,-0x10(%ebp)
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	a3 fc 0a 00 00       	mov    %eax,0xafc
 7d9:	a1 fc 0a 00 00       	mov    0xafc,%eax
 7de:	a3 f4 0a 00 00       	mov    %eax,0xaf4
    base.s.size = 0;
 7e3:	c7 05 f8 0a 00 00 00 	movl   $0x0,0xaf8
 7ea:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fe:	72 4d                	jb     84d <malloc+0xa6>
      if(p->s.size == nunits)
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 809:	75 0c                	jne    817 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 10                	mov    (%eax),%edx
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	89 10                	mov    %edx,(%eax)
 815:	eb 26                	jmp    83d <malloc+0x96>
      else {
        p->s.size -= nunits;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 820:	89 c2                	mov    %eax,%edx
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	a3 fc 0a 00 00       	mov    %eax,0xafc
      return (void*)(p + 1);
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	83 c0 08             	add    $0x8,%eax
 84b:	eb 3b                	jmp    888 <malloc+0xe1>
    }
    if(p == freep)
 84d:	a1 fc 0a 00 00       	mov    0xafc,%eax
 852:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 855:	75 1e                	jne    875 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 857:	83 ec 0c             	sub    $0xc,%esp
 85a:	ff 75 ec             	pushl  -0x14(%ebp)
 85d:	e8 e5 fe ff ff       	call   747 <morecore>
 862:	83 c4 10             	add    $0x10,%esp
 865:	89 45 f4             	mov    %eax,-0xc(%ebp)
 868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86c:	75 07                	jne    875 <malloc+0xce>
        return 0;
 86e:	b8 00 00 00 00       	mov    $0x0,%eax
 873:	eb 13                	jmp    888 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 883:	e9 6d ff ff ff       	jmp    7f5 <malloc+0x4e>
}
 888:	c9                   	leave  
 889:	c3                   	ret    
