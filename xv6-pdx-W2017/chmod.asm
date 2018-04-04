
_chmod:     file format elf32-i386


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
    int imode = 0;
  14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char *mode;
    if (argc != 3) {
  1b:	83 3b 03             	cmpl   $0x3,(%ebx)
  1e:	74 17                	je     37 <main+0x37>
      printf(2, "Error. Need a string to convert to octal\n");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 38 09 00 00       	push   $0x938
  28:	6a 02                	push   $0x2
  2a:	e8 51 05 00 00       	call   580 <printf>
  2f:	83 c4 10             	add    $0x10,%esp
      exit();
  32:	e8 6a 03 00 00       	call   3a1 <exit>
    }

    mode = argv[1];
  37:	8b 43 04             	mov    0x4(%ebx),%eax
  3a:	8b 40 04             	mov    0x4(%eax),%eax
  3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (strlen(mode) != 4) {
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	ff 75 f0             	pushl  -0x10(%ebp)
  46:	e8 94 01 00 00       	call   1df <strlen>
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	83 f8 04             	cmp    $0x4,%eax
  51:	74 17                	je     6a <main+0x6a>
      printf(2, "Error. 4 octal digits required.\n");
  53:	83 ec 08             	sub    $0x8,%esp
  56:	68 64 09 00 00       	push   $0x964
  5b:	6a 02                	push   $0x2
  5d:	e8 1e 05 00 00       	call   580 <printf>
  62:	83 c4 10             	add    $0x10,%esp
      exit();
  65:	e8 37 03 00 00       	call   3a1 <exit>
    }
    if (!(mode[0] == '0' || mode[0] == '1'))
  6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  6d:	0f b6 00             	movzbl (%eax),%eax
  70:	3c 30                	cmp    $0x30,%al
  72:	74 0f                	je     83 <main+0x83>
  74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  77:	0f b6 00             	movzbl (%eax),%eax
  7a:	3c 31                	cmp    $0x31,%al
  7c:	74 05                	je     83 <main+0x83>
      exit();
  7e:	e8 1e 03 00 00       	call   3a1 <exit>
    if (!(mode[1] >= '0' && mode[1] <= '7'))
  83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  86:	83 c0 01             	add    $0x1,%eax
  89:	0f b6 00             	movzbl (%eax),%eax
  8c:	3c 2f                	cmp    $0x2f,%al
  8e:	7e 0d                	jle    9d <main+0x9d>
  90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  93:	83 c0 01             	add    $0x1,%eax
  96:	0f b6 00             	movzbl (%eax),%eax
  99:	3c 37                	cmp    $0x37,%al
  9b:	7e 05                	jle    a2 <main+0xa2>
      exit();
  9d:	e8 ff 02 00 00       	call   3a1 <exit>
    if (!(mode[2] >= '0' && mode[2] <= '7'))
  a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a5:	83 c0 02             	add    $0x2,%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	3c 2f                	cmp    $0x2f,%al
  ad:	7e 0d                	jle    bc <main+0xbc>
  af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b2:	83 c0 02             	add    $0x2,%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	3c 37                	cmp    $0x37,%al
  ba:	7e 05                	jle    c1 <main+0xc1>
      exit();
  bc:	e8 e0 02 00 00       	call   3a1 <exit>
    if (!(mode[3] >= '0' && mode[3] <= '7'))
  c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c4:	83 c0 03             	add    $0x3,%eax
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	3c 2f                	cmp    $0x2f,%al
  cc:	7e 0d                	jle    db <main+0xdb>
  ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d1:	83 c0 03             	add    $0x3,%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	3c 37                	cmp    $0x37,%al
  d9:	7e 05                	jle    e0 <main+0xe0>
      exit();
  db:	e8 c1 02 00 00       	call   3a1 <exit>
    imode += ((int)(mode[0] - '0') * (8*8*8));
  e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	0f be c0             	movsbl %al,%eax
  e9:	83 e8 30             	sub    $0x30,%eax
  ec:	c1 e0 09             	shl    $0x9,%eax
  ef:	01 45 f4             	add    %eax,-0xc(%ebp)
    imode += ((int)(mode[1] - '0') * (8*8));
  f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f5:	83 c0 01             	add    $0x1,%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f be c0             	movsbl %al,%eax
  fe:	83 e8 30             	sub    $0x30,%eax
 101:	c1 e0 06             	shl    $0x6,%eax
 104:	01 45 f4             	add    %eax,-0xc(%ebp)
    imode += ((int)(mode[2] - '0') * (8));
 107:	8b 45 f0             	mov    -0x10(%ebp),%eax
 10a:	83 c0 02             	add    $0x2,%eax
 10d:	0f b6 00             	movzbl (%eax),%eax
 110:	0f be c0             	movsbl %al,%eax
 113:	83 e8 30             	sub    $0x30,%eax
 116:	c1 e0 03             	shl    $0x3,%eax
 119:	01 45 f4             	add    %eax,-0xc(%ebp)
    imode +=  (int)(mode[3] - '0');
 11c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 11f:	83 c0 03             	add    $0x3,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	0f be c0             	movsbl %al,%eax
 128:	83 e8 30             	sub    $0x30,%eax
 12b:	01 45 f4             	add    %eax,-0xc(%ebp)
    chmod(argv[2], imode);
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	83 c0 08             	add    $0x8,%eax
 134:	8b 00                	mov    (%eax),%eax
 136:	83 ec 08             	sub    $0x8,%esp
 139:	ff 75 f4             	pushl  -0xc(%ebp)
 13c:	50                   	push   %eax
 13d:	e8 4f 03 00 00       	call   491 <chmod>
 142:	83 c4 10             	add    $0x10,%esp
    exit();
 145:	e8 57 02 00 00       	call   3a1 <exit>

0000014a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	57                   	push   %edi
 14e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 14f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 152:	8b 55 10             	mov    0x10(%ebp),%edx
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	89 cb                	mov    %ecx,%ebx
 15a:	89 df                	mov    %ebx,%edi
 15c:	89 d1                	mov    %edx,%ecx
 15e:	fc                   	cld    
 15f:	f3 aa                	rep stos %al,%es:(%edi)
 161:	89 ca                	mov    %ecx,%edx
 163:	89 fb                	mov    %edi,%ebx
 165:	89 5d 08             	mov    %ebx,0x8(%ebp)
 168:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 16b:	90                   	nop
 16c:	5b                   	pop    %ebx
 16d:	5f                   	pop    %edi
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 17c:	90                   	nop
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	8d 50 01             	lea    0x1(%eax),%edx
 183:	89 55 08             	mov    %edx,0x8(%ebp)
 186:	8b 55 0c             	mov    0xc(%ebp),%edx
 189:	8d 4a 01             	lea    0x1(%edx),%ecx
 18c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 18f:	0f b6 12             	movzbl (%edx),%edx
 192:	88 10                	mov    %dl,(%eax)
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	84 c0                	test   %al,%al
 199:	75 e2                	jne    17d <strcpy+0xd>
    ;
  return os;
 19b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a3:	eb 08                	jmp    1ad <strcmp+0xd>
    p++, q++;
 1a5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	84 c0                	test   %al,%al
 1b5:	74 10                	je     1c7 <strcmp+0x27>
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	38 c2                	cmp    %al,%dl
 1c5:	74 de                	je     1a5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	0f b6 d0             	movzbl %al,%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	0f b6 c0             	movzbl %al,%eax
 1d9:	29 c2                	sub    %eax,%edx
 1db:	89 d0                	mov    %edx,%eax
}
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    

000001df <strlen>:

uint
strlen(char *s)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ec:	eb 04                	jmp    1f2 <strlen+0x13>
 1ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	01 d0                	add    %edx,%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	84 c0                	test   %al,%al
 1ff:	75 ed                	jne    1ee <strlen+0xf>
    ;
  return n;
 201:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <memset>:

void*
memset(void *dst, int c, uint n)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 209:	8b 45 10             	mov    0x10(%ebp),%eax
 20c:	50                   	push   %eax
 20d:	ff 75 0c             	pushl  0xc(%ebp)
 210:	ff 75 08             	pushl  0x8(%ebp)
 213:	e8 32 ff ff ff       	call   14a <stosb>
 218:	83 c4 0c             	add    $0xc,%esp
  return dst;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 04             	sub    $0x4,%esp
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22c:	eb 14                	jmp    242 <strchr+0x22>
    if(*s == c)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3a 45 fc             	cmp    -0x4(%ebp),%al
 237:	75 05                	jne    23e <strchr+0x1e>
      return (char*)s;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	eb 13                	jmp    251 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	84 c0                	test   %al,%al
 24a:	75 e2                	jne    22e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 24c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <gets>:

char*
gets(char *buf, int max)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 260:	eb 42                	jmp    2a4 <gets+0x51>
    cc = read(0, &c, 1);
 262:	83 ec 04             	sub    $0x4,%esp
 265:	6a 01                	push   $0x1
 267:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26a:	50                   	push   %eax
 26b:	6a 00                	push   $0x0
 26d:	e8 47 01 00 00       	call   3b9 <read>
 272:	83 c4 10             	add    $0x10,%esp
 275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27c:	7e 33                	jle    2b1 <gets+0x5e>
      break;
    buf[i++] = c;
 27e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 281:	8d 50 01             	lea    0x1(%eax),%edx
 284:	89 55 f4             	mov    %edx,-0xc(%ebp)
 287:	89 c2                	mov    %eax,%edx
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	01 c2                	add    %eax,%edx
 28e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 292:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 294:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 298:	3c 0a                	cmp    $0xa,%al
 29a:	74 16                	je     2b2 <gets+0x5f>
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0d                	cmp    $0xd,%al
 2a2:	74 0e                	je     2b2 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a7:	83 c0 01             	add    $0x1,%eax
 2aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ad:	7c b3                	jl     262 <gets+0xf>
 2af:	eb 01                	jmp    2b2 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	01 d0                	add    %edx,%eax
 2ba:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c0:	c9                   	leave  
 2c1:	c3                   	ret    

000002c2 <stat>:

int
stat(char *n, struct stat *st)
{
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	6a 00                	push   $0x0
 2cd:	ff 75 08             	pushl  0x8(%ebp)
 2d0:	e8 0c 01 00 00       	call   3e1 <open>
 2d5:	83 c4 10             	add    $0x10,%esp
 2d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2df:	79 07                	jns    2e8 <stat+0x26>
    return -1;
 2e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e6:	eb 25                	jmp    30d <stat+0x4b>
  r = fstat(fd, st);
 2e8:	83 ec 08             	sub    $0x8,%esp
 2eb:	ff 75 0c             	pushl  0xc(%ebp)
 2ee:	ff 75 f4             	pushl  -0xc(%ebp)
 2f1:	e8 03 01 00 00       	call   3f9 <fstat>
 2f6:	83 c4 10             	add    $0x10,%esp
 2f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2fc:	83 ec 0c             	sub    $0xc,%esp
 2ff:	ff 75 f4             	pushl  -0xc(%ebp)
 302:	e8 c2 00 00 00       	call   3c9 <close>
 307:	83 c4 10             	add    $0x10,%esp
  return r;
 30a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <atoi>:

int
atoi(const char *s)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
 312:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31c:	eb 25                	jmp    343 <atoi+0x34>
    n = n*10 + *s++ - '0';
 31e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 321:	89 d0                	mov    %edx,%eax
 323:	c1 e0 02             	shl    $0x2,%eax
 326:	01 d0                	add    %edx,%eax
 328:	01 c0                	add    %eax,%eax
 32a:	89 c1                	mov    %eax,%ecx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	8d 50 01             	lea    0x1(%eax),%edx
 332:	89 55 08             	mov    %edx,0x8(%ebp)
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	0f be c0             	movsbl %al,%eax
 33b:	01 c8                	add    %ecx,%eax
 33d:	83 e8 30             	sub    $0x30,%eax
 340:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 00             	movzbl (%eax),%eax
 349:	3c 2f                	cmp    $0x2f,%al
 34b:	7e 0a                	jle    357 <atoi+0x48>
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	0f b6 00             	movzbl (%eax),%eax
 353:	3c 39                	cmp    $0x39,%al
 355:	7e c7                	jle    31e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 357:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35a:	c9                   	leave  
 35b:	c3                   	ret    

0000035c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36e:	eb 17                	jmp    387 <memmove+0x2b>
    *dst++ = *src++;
 370:	8b 45 fc             	mov    -0x4(%ebp),%eax
 373:	8d 50 01             	lea    0x1(%eax),%edx
 376:	89 55 fc             	mov    %edx,-0x4(%ebp)
 379:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37c:	8d 4a 01             	lea    0x1(%edx),%ecx
 37f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 382:	0f b6 12             	movzbl (%edx),%edx
 385:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 387:	8b 45 10             	mov    0x10(%ebp),%eax
 38a:	8d 50 ff             	lea    -0x1(%eax),%edx
 38d:	89 55 10             	mov    %edx,0x10(%ebp)
 390:	85 c0                	test   %eax,%eax
 392:	7f dc                	jg     370 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 394:	8b 45 08             	mov    0x8(%ebp),%eax
}
 397:	c9                   	leave  
 398:	c3                   	ret    

00000399 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 399:	b8 01 00 00 00       	mov    $0x1,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <exit>:
SYSCALL(exit)
 3a1:	b8 02 00 00 00       	mov    $0x2,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <wait>:
SYSCALL(wait)
 3a9:	b8 03 00 00 00       	mov    $0x3,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <pipe>:
SYSCALL(pipe)
 3b1:	b8 04 00 00 00       	mov    $0x4,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <read>:
SYSCALL(read)
 3b9:	b8 05 00 00 00       	mov    $0x5,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <write>:
SYSCALL(write)
 3c1:	b8 10 00 00 00       	mov    $0x10,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <close>:
SYSCALL(close)
 3c9:	b8 15 00 00 00       	mov    $0x15,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <kill>:
SYSCALL(kill)
 3d1:	b8 06 00 00 00       	mov    $0x6,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <exec>:
SYSCALL(exec)
 3d9:	b8 07 00 00 00       	mov    $0x7,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <open>:
SYSCALL(open)
 3e1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <mknod>:
SYSCALL(mknod)
 3e9:	b8 11 00 00 00       	mov    $0x11,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <unlink>:
SYSCALL(unlink)
 3f1:	b8 12 00 00 00       	mov    $0x12,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <fstat>:
SYSCALL(fstat)
 3f9:	b8 08 00 00 00       	mov    $0x8,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <link>:
SYSCALL(link)
 401:	b8 13 00 00 00       	mov    $0x13,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <mkdir>:
SYSCALL(mkdir)
 409:	b8 14 00 00 00       	mov    $0x14,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <chdir>:
SYSCALL(chdir)
 411:	b8 09 00 00 00       	mov    $0x9,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <dup>:
SYSCALL(dup)
 419:	b8 0a 00 00 00       	mov    $0xa,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <getpid>:
SYSCALL(getpid)
 421:	b8 0b 00 00 00       	mov    $0xb,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <sbrk>:
SYSCALL(sbrk)
 429:	b8 0c 00 00 00       	mov    $0xc,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <sleep>:
SYSCALL(sleep)
 431:	b8 0d 00 00 00       	mov    $0xd,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <uptime>:
SYSCALL(uptime)
 439:	b8 0e 00 00 00       	mov    $0xe,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <halt>:
SYSCALL(halt)
 441:	b8 16 00 00 00       	mov    $0x16,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <date>:
SYSCALL(date)
 449:	b8 17 00 00 00       	mov    $0x17,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <getuid>:
SYSCALL(getuid)
 451:	b8 18 00 00 00       	mov    $0x18,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <getgid>:
SYSCALL(getgid)
 459:	b8 19 00 00 00       	mov    $0x19,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <getppid>:
SYSCALL(getppid)
 461:	b8 1a 00 00 00       	mov    $0x1a,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <setuid>:
SYSCALL(setuid)
 469:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <setgid>:
SYSCALL(setgid)
 471:	b8 1c 00 00 00       	mov    $0x1c,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <getprocs>:
SYSCALL(getprocs)
 479:	b8 1d 00 00 00       	mov    $0x1d,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <looper>:
SYSCALL(looper)
 481:	b8 1e 00 00 00       	mov    $0x1e,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <setpriority>:
SYSCALL(setpriority)
 489:	b8 1f 00 00 00       	mov    $0x1f,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <chmod>:
SYSCALL(chmod)
 491:	b8 20 00 00 00       	mov    $0x20,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <chown>:
SYSCALL(chown)
 499:	b8 21 00 00 00       	mov    $0x21,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <chgrp>:
SYSCALL(chgrp)
 4a1:	b8 22 00 00 00       	mov    $0x22,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	83 ec 18             	sub    $0x18,%esp
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b5:	83 ec 04             	sub    $0x4,%esp
 4b8:	6a 01                	push   $0x1
 4ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 fb fe ff ff       	call   3c1 <write>
 4c6:	83 c4 10             	add    $0x10,%esp
}
 4c9:	90                   	nop
 4ca:	c9                   	leave  
 4cb:	c3                   	ret    

000004cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	53                   	push   %ebx
 4d0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4da:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4de:	74 17                	je     4f7 <printint+0x2b>
 4e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e4:	79 11                	jns    4f7 <printint+0x2b>
    neg = 1;
 4e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	f7 d8                	neg    %eax
 4f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f5:	eb 06                	jmp    4fd <printint+0x31>
  } else {
    x = xx;
 4f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 504:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 507:	8d 41 01             	lea    0x1(%ecx),%eax
 50a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 510:	8b 45 ec             	mov    -0x14(%ebp),%eax
 513:	ba 00 00 00 00       	mov    $0x0,%edx
 518:	f7 f3                	div    %ebx
 51a:	89 d0                	mov    %edx,%eax
 51c:	0f b6 80 d8 0b 00 00 	movzbl 0xbd8(%eax),%eax
 523:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 527:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52d:	ba 00 00 00 00       	mov    $0x0,%edx
 532:	f7 f3                	div    %ebx
 534:	89 45 ec             	mov    %eax,-0x14(%ebp)
 537:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53b:	75 c7                	jne    504 <printint+0x38>
  if(neg)
 53d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 541:	74 2d                	je     570 <printint+0xa4>
    buf[i++] = '-';
 543:	8b 45 f4             	mov    -0xc(%ebp),%eax
 546:	8d 50 01             	lea    0x1(%eax),%edx
 549:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 551:	eb 1d                	jmp    570 <printint+0xa4>
    putc(fd, buf[i]);
 553:	8d 55 dc             	lea    -0x24(%ebp),%edx
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	01 d0                	add    %edx,%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	83 ec 08             	sub    $0x8,%esp
 564:	50                   	push   %eax
 565:	ff 75 08             	pushl  0x8(%ebp)
 568:	e8 3c ff ff ff       	call   4a9 <putc>
 56d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 570:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 578:	79 d9                	jns    553 <printint+0x87>
    putc(fd, buf[i]);
}
 57a:	90                   	nop
 57b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57e:	c9                   	leave  
 57f:	c3                   	ret    

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58d:	8d 45 0c             	lea    0xc(%ebp),%eax
 590:	83 c0 04             	add    $0x4,%eax
 593:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 596:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59d:	e9 59 01 00 00       	jmp    6fb <printf+0x17b>
    c = fmt[i] & 0xff;
 5a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a8:	01 d0                	add    %edx,%eax
 5aa:	0f b6 00             	movzbl (%eax),%eax
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	25 ff 00 00 00       	and    $0xff,%eax
 5b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bc:	75 2c                	jne    5ea <printf+0x6a>
      if(c == '%'){
 5be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c2:	75 0c                	jne    5d0 <printf+0x50>
        state = '%';
 5c4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cb:	e9 27 01 00 00       	jmp    6f7 <printf+0x177>
      } else {
        putc(fd, c);
 5d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	83 ec 08             	sub    $0x8,%esp
 5d9:	50                   	push   %eax
 5da:	ff 75 08             	pushl  0x8(%ebp)
 5dd:	e8 c7 fe ff ff       	call   4a9 <putc>
 5e2:	83 c4 10             	add    $0x10,%esp
 5e5:	e9 0d 01 00 00       	jmp    6f7 <printf+0x177>
      }
    } else if(state == '%'){
 5ea:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ee:	0f 85 03 01 00 00    	jne    6f7 <printf+0x177>
      if(c == 'd'){
 5f4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f8:	75 1e                	jne    618 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	6a 01                	push   $0x1
 601:	6a 0a                	push   $0xa
 603:	50                   	push   %eax
 604:	ff 75 08             	pushl  0x8(%ebp)
 607:	e8 c0 fe ff ff       	call   4cc <printint>
 60c:	83 c4 10             	add    $0x10,%esp
        ap++;
 60f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 613:	e9 d8 00 00 00       	jmp    6f0 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 618:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61c:	74 06                	je     624 <printf+0xa4>
 61e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 622:	75 1e                	jne    642 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 624:	8b 45 e8             	mov    -0x18(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	6a 00                	push   $0x0
 62b:	6a 10                	push   $0x10
 62d:	50                   	push   %eax
 62e:	ff 75 08             	pushl  0x8(%ebp)
 631:	e8 96 fe ff ff       	call   4cc <printint>
 636:	83 c4 10             	add    $0x10,%esp
        ap++;
 639:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63d:	e9 ae 00 00 00       	jmp    6f0 <printf+0x170>
      } else if(c == 's'){
 642:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 646:	75 43                	jne    68b <printf+0x10b>
        s = (char*)*ap;
 648:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 650:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 658:	75 25                	jne    67f <printf+0xff>
          s = "(null)";
 65a:	c7 45 f4 85 09 00 00 	movl   $0x985,-0xc(%ebp)
        while(*s != 0){
 661:	eb 1c                	jmp    67f <printf+0xff>
          putc(fd, *s);
 663:	8b 45 f4             	mov    -0xc(%ebp),%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	50                   	push   %eax
 670:	ff 75 08             	pushl  0x8(%ebp)
 673:	e8 31 fe ff ff       	call   4a9 <putc>
 678:	83 c4 10             	add    $0x10,%esp
          s++;
 67b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	84 c0                	test   %al,%al
 687:	75 da                	jne    663 <printf+0xe3>
 689:	eb 65                	jmp    6f0 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68f:	75 1d                	jne    6ae <printf+0x12e>
        putc(fd, *ap);
 691:	8b 45 e8             	mov    -0x18(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	0f be c0             	movsbl %al,%eax
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	50                   	push   %eax
 69d:	ff 75 08             	pushl  0x8(%ebp)
 6a0:	e8 04 fe ff ff       	call   4a9 <putc>
 6a5:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ac:	eb 42                	jmp    6f0 <printf+0x170>
      } else if(c == '%'){
 6ae:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b2:	75 17                	jne    6cb <printf+0x14b>
        putc(fd, c);
 6b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	83 ec 08             	sub    $0x8,%esp
 6bd:	50                   	push   %eax
 6be:	ff 75 08             	pushl  0x8(%ebp)
 6c1:	e8 e3 fd ff ff       	call   4a9 <putc>
 6c6:	83 c4 10             	add    $0x10,%esp
 6c9:	eb 25                	jmp    6f0 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cb:	83 ec 08             	sub    $0x8,%esp
 6ce:	6a 25                	push   $0x25
 6d0:	ff 75 08             	pushl  0x8(%ebp)
 6d3:	e8 d1 fd ff ff       	call   4a9 <putc>
 6d8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6de:	0f be c0             	movsbl %al,%eax
 6e1:	83 ec 08             	sub    $0x8,%esp
 6e4:	50                   	push   %eax
 6e5:	ff 75 08             	pushl  0x8(%ebp)
 6e8:	e8 bc fd ff ff       	call   4a9 <putc>
 6ed:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	0f b6 00             	movzbl (%eax),%eax
 706:	84 c0                	test   %al,%al
 708:	0f 85 94 fe ff ff    	jne    5a2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 70e:	90                   	nop
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	83 e8 08             	sub    $0x8,%eax
 71d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 725:	89 45 fc             	mov    %eax,-0x4(%ebp)
 728:	eb 24                	jmp    74e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	77 12                	ja     746 <free+0x35>
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73a:	77 24                	ja     760 <free+0x4f>
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 744:	77 1a                	ja     760 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 754:	76 d4                	jbe    72a <free+0x19>
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75e:	76 ca                	jbe    72a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	01 c2                	add    %eax,%edx
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	39 c2                	cmp    %eax,%edx
 779:	75 24                	jne    79f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	01 c2                	add    %eax,%edx
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 0a                	jmp    7a9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	01 d0                	add    %edx,%eax
 7bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7be:	75 20                	jne    7e0 <free+0xcf>
    p->s.size += bp->s.size;
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 50 04             	mov    0x4(%eax),%edx
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	01 c2                	add    %eax,%edx
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d7:	8b 10                	mov    (%eax),%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	89 10                	mov    %edx,(%eax)
 7de:	eb 08                	jmp    7e8 <free+0xd7>
  } else
    p->s.ptr = bp;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e6:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	a3 f4 0b 00 00       	mov    %eax,0xbf4
}
 7f0:	90                   	nop
 7f1:	c9                   	leave  
 7f2:	c3                   	ret    

000007f3 <morecore>:

static Header*
morecore(uint nu)
{
 7f3:	55                   	push   %ebp
 7f4:	89 e5                	mov    %esp,%ebp
 7f6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 800:	77 07                	ja     809 <morecore+0x16>
    nu = 4096;
 802:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 809:	8b 45 08             	mov    0x8(%ebp),%eax
 80c:	c1 e0 03             	shl    $0x3,%eax
 80f:	83 ec 0c             	sub    $0xc,%esp
 812:	50                   	push   %eax
 813:	e8 11 fc ff ff       	call   429 <sbrk>
 818:	83 c4 10             	add    $0x10,%esp
 81b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 822:	75 07                	jne    82b <morecore+0x38>
    return 0;
 824:	b8 00 00 00 00       	mov    $0x0,%eax
 829:	eb 26                	jmp    851 <morecore+0x5e>
  hp = (Header*)p;
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	8b 55 08             	mov    0x8(%ebp),%edx
 837:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83d:	83 c0 08             	add    $0x8,%eax
 840:	83 ec 0c             	sub    $0xc,%esp
 843:	50                   	push   %eax
 844:	e8 c8 fe ff ff       	call   711 <free>
 849:	83 c4 10             	add    $0x10,%esp
  return freep;
 84c:	a1 f4 0b 00 00       	mov    0xbf4,%eax
}
 851:	c9                   	leave  
 852:	c3                   	ret    

00000853 <malloc>:

void*
malloc(uint nbytes)
{
 853:	55                   	push   %ebp
 854:	89 e5                	mov    %esp,%ebp
 856:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
 85c:	83 c0 07             	add    $0x7,%eax
 85f:	c1 e8 03             	shr    $0x3,%eax
 862:	83 c0 01             	add    $0x1,%eax
 865:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 868:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 86d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 874:	75 23                	jne    899 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 876:	c7 45 f0 ec 0b 00 00 	movl   $0xbec,-0x10(%ebp)
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	a3 f4 0b 00 00       	mov    %eax,0xbf4
 885:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 88a:	a3 ec 0b 00 00       	mov    %eax,0xbec
    base.s.size = 0;
 88f:	c7 05 f0 0b 00 00 00 	movl   $0x0,0xbf0
 896:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 40 04             	mov    0x4(%eax),%eax
 8a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8aa:	72 4d                	jb     8f9 <malloc+0xa6>
      if(p->s.size == nunits)
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b5:	75 0c                	jne    8c3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	89 10                	mov    %edx,(%eax)
 8c1:	eb 26                	jmp    8e9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8cc:	89 c2                	mov    %eax,%edx
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	c1 e0 03             	shl    $0x3,%eax
 8dd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	a3 f4 0b 00 00       	mov    %eax,0xbf4
      return (void*)(p + 1);
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	83 c0 08             	add    $0x8,%eax
 8f7:	eb 3b                	jmp    934 <malloc+0xe1>
    }
    if(p == freep)
 8f9:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 8fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 901:	75 1e                	jne    921 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 903:	83 ec 0c             	sub    $0xc,%esp
 906:	ff 75 ec             	pushl  -0x14(%ebp)
 909:	e8 e5 fe ff ff       	call   7f3 <morecore>
 90e:	83 c4 10             	add    $0x10,%esp
 911:	89 45 f4             	mov    %eax,-0xc(%ebp)
 914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 918:	75 07                	jne    921 <malloc+0xce>
        return 0;
 91a:	b8 00 00 00 00       	mov    $0x0,%eax
 91f:	eb 13                	jmp    934 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	89 45 f0             	mov    %eax,-0x10(%ebp)
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 92f:	e9 6d ff ff ff       	jmp    8a1 <malloc+0x4e>
}
 934:	c9                   	leave  
 935:	c3                   	ret    
