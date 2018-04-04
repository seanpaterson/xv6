
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
  "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
static char *days[] = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   4:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
   8:	7f 0b                	jg     15 <dayofweek+0x15>
   a:	8b 45 08             	mov    0x8(%ebp),%eax
   d:	8d 50 ff             	lea    -0x1(%eax),%edx
  10:	89 55 08             	mov    %edx,0x8(%ebp)
  13:	eb 06                	jmp    1b <dayofweek+0x1b>
  15:	8b 45 08             	mov    0x8(%ebp),%eax
  18:	83 e8 02             	sub    $0x2,%eax
  1b:	01 45 10             	add    %eax,0x10(%ebp)
  1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  21:	6b c8 17             	imul   $0x17,%eax,%ecx
  24:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	f7 ea                	imul   %edx
  2d:	d1 fa                	sar    %edx
  2f:	89 c8                	mov    %ecx,%eax
  31:	c1 f8 1f             	sar    $0x1f,%eax
  34:	29 c2                	sub    %eax,%edx
  36:	8b 45 10             	mov    0x10(%ebp),%eax
  39:	01 d0                	add    %edx,%eax
  3b:	8d 48 04             	lea    0x4(%eax),%ecx
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 03             	lea    0x3(%eax),%edx
  44:	85 c0                	test   %eax,%eax
  46:	0f 48 c2             	cmovs  %edx,%eax
  49:	c1 f8 02             	sar    $0x2,%eax
  4c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  57:	89 c8                	mov    %ecx,%eax
  59:	f7 ea                	imul   %edx
  5b:	c1 fa 05             	sar    $0x5,%edx
  5e:	89 c8                	mov    %ecx,%eax
  60:	c1 f8 1f             	sar    $0x1f,%eax
  63:	29 c2                	sub    %eax,%edx
  65:	89 d0                	mov    %edx,%eax
  67:	29 c3                	sub    %eax,%ebx
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  71:	89 c8                	mov    %ecx,%eax
  73:	f7 ea                	imul   %edx
  75:	c1 fa 07             	sar    $0x7,%edx
  78:	89 c8                	mov    %ecx,%eax
  7a:	c1 f8 1f             	sar    $0x1f,%eax
  7d:	29 c2                	sub    %eax,%edx
  7f:	89 d0                	mov    %edx,%eax
  81:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  84:	ba 93 24 49 92       	mov    $0x92492493,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	f7 ea                	imul   %edx
  8d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  90:	c1 f8 02             	sar    $0x2,%eax
  93:	89 c2                	mov    %eax,%edx
  95:	89 c8                	mov    %ecx,%eax
  97:	c1 f8 1f             	sar    $0x1f,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	c1 e2 03             	shl    $0x3,%edx
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b0:	83 e4 f0             	and    $0xfffffff0,%esp
  b3:	ff 71 fc             	pushl  -0x4(%ecx)
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	53                   	push   %ebx
  ba:	51                   	push   %ecx
  bb:	83 ec 20             	sub    $0x20,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  be:	83 ec 0c             	sub    $0xc,%esp
  c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  c4:	50                   	push   %eax
  c5:	e8 92 03 00 00       	call   45c <date>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	85 c0                	test   %eax,%eax
  cf:	74 1b                	je     ec <main+0x40>
    printf(2,"Error: date call failed. %s at line %d\n", __FILE__, __LINE__);
  d1:	6a 19                	push   $0x19
  d3:	68 9d 09 00 00       	push   $0x99d
  d8:	68 a4 09 00 00       	push   $0x9a4
  dd:	6a 02                	push   $0x2
  df:	e8 af 04 00 00       	call   593 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
    exit();
  e7:	e8 c8 02 00 00       	call   3b4 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ef:	89 c1                	mov    %eax,%ecx
  f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  f4:	89 c2                	mov    %eax,%edx
  f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f9:	83 ec 04             	sub    $0x4,%esp
  fc:	51                   	push   %ecx
  fd:	52                   	push   %edx
  fe:	50                   	push   %eax
  ff:	e8 fc fe ff ff       	call   0 <dayofweek>
 104:	83 c4 10             	add    $0x10,%esp
 107:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(2, "%s %s %d", days[day], months[r.month], r.day);
 10a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 110:	8b 14 85 60 0c 00 00 	mov    0xc60(,%eax,4),%edx
 117:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11a:	8b 04 85 94 0c 00 00 	mov    0xc94(,%eax,4),%eax
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	51                   	push   %ecx
 125:	52                   	push   %edx
 126:	50                   	push   %eax
 127:	68 cc 09 00 00       	push   $0x9cc
 12c:	6a 02                	push   $0x2
 12e:	e8 60 04 00 00       	call   593 <printf>
 133:	83 c4 20             	add    $0x20,%esp
  printf(2, " %d:%d:%d UTC %d\n", r.hour, r.minute, r.second, r.year);
 136:	8b 5d f0             	mov    -0x10(%ebp),%ebx
 139:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 13c:	8b 55 e0             	mov    -0x20(%ebp),%edx
 13f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 142:	83 ec 08             	sub    $0x8,%esp
 145:	53                   	push   %ebx
 146:	51                   	push   %ecx
 147:	52                   	push   %edx
 148:	50                   	push   %eax
 149:	68 d5 09 00 00       	push   $0x9d5
 14e:	6a 02                	push   $0x2
 150:	e8 3e 04 00 00       	call   593 <printf>
 155:	83 c4 20             	add    $0x20,%esp

  exit();
 158:	e8 57 02 00 00       	call   3b4 <exit>

0000015d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 162:	8b 4d 08             	mov    0x8(%ebp),%ecx
 165:	8b 55 10             	mov    0x10(%ebp),%edx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	89 cb                	mov    %ecx,%ebx
 16d:	89 df                	mov    %ebx,%edi
 16f:	89 d1                	mov    %edx,%ecx
 171:	fc                   	cld    
 172:	f3 aa                	rep stos %al,%es:(%edi)
 174:	89 ca                	mov    %ecx,%edx
 176:	89 fb                	mov    %edi,%ebx
 178:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 17e:	90                   	nop
 17f:	5b                   	pop    %ebx
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    

00000183 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18f:	90                   	nop
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	8d 50 01             	lea    0x1(%eax),%edx
 196:	89 55 08             	mov    %edx,0x8(%ebp)
 199:	8b 55 0c             	mov    0xc(%ebp),%edx
 19c:	8d 4a 01             	lea    0x1(%edx),%ecx
 19f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a2:	0f b6 12             	movzbl (%edx),%edx
 1a5:	88 10                	mov    %dl,(%eax)
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	84 c0                	test   %al,%al
 1ac:	75 e2                	jne    190 <strcpy+0xd>
    ;
  return os;
 1ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b1:	c9                   	leave  
 1b2:	c3                   	ret    

000001b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b6:	eb 08                	jmp    1c0 <strcmp+0xd>
    p++, q++;
 1b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	84 c0                	test   %al,%al
 1c8:	74 10                	je     1da <strcmp+0x27>
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	0f b6 10             	movzbl (%eax),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	38 c2                	cmp    %al,%dl
 1d8:	74 de                	je     1b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	0f b6 d0             	movzbl %al,%edx
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	0f b6 00             	movzbl (%eax),%eax
 1e9:	0f b6 c0             	movzbl %al,%eax
 1ec:	29 c2                	sub    %eax,%edx
 1ee:	89 d0                	mov    %edx,%eax
}
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <strlen>:

uint
strlen(char *s)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ff:	eb 04                	jmp    205 <strlen+0x13>
 201:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	84 c0                	test   %al,%al
 212:	75 ed                	jne    201 <strlen+0xf>
    ;
  return n;
 214:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <memset>:

void*
memset(void *dst, int c, uint n)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21c:	8b 45 10             	mov    0x10(%ebp),%eax
 21f:	50                   	push   %eax
 220:	ff 75 0c             	pushl  0xc(%ebp)
 223:	ff 75 08             	pushl  0x8(%ebp)
 226:	e8 32 ff ff ff       	call   15d <stosb>
 22b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strchr>:

char*
strchr(const char *s, char c)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 04             	sub    $0x4,%esp
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 23f:	eb 14                	jmp    255 <strchr+0x22>
    if(*s == c)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24a:	75 05                	jne    251 <strchr+0x1e>
      return (char*)s;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	eb 13                	jmp    264 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 251:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	84 c0                	test   %al,%al
 25d:	75 e2                	jne    241 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <gets>:

char*
gets(char *buf, int max)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 273:	eb 42                	jmp    2b7 <gets+0x51>
    cc = read(0, &c, 1);
 275:	83 ec 04             	sub    $0x4,%esp
 278:	6a 01                	push   $0x1
 27a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	6a 00                	push   $0x0
 280:	e8 47 01 00 00       	call   3cc <read>
 285:	83 c4 10             	add    $0x10,%esp
 288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28f:	7e 33                	jle    2c4 <gets+0x5e>
      break;
    buf[i++] = c;
 291:	8b 45 f4             	mov    -0xc(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 c2                	add    %eax,%edx
 2a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ab:	3c 0a                	cmp    $0xa,%al
 2ad:	74 16                	je     2c5 <gets+0x5f>
 2af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 0e                	je     2c5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	83 c0 01             	add    $0x1,%eax
 2bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c0:	7c b3                	jl     275 <gets+0xf>
 2c2:	eb 01                	jmp    2c5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	01 d0                	add    %edx,%eax
 2cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <stat>:

int
stat(char *n, struct stat *st)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2db:	83 ec 08             	sub    $0x8,%esp
 2de:	6a 00                	push   $0x0
 2e0:	ff 75 08             	pushl  0x8(%ebp)
 2e3:	e8 0c 01 00 00       	call   3f4 <open>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f2:	79 07                	jns    2fb <stat+0x26>
    return -1;
 2f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f9:	eb 25                	jmp    320 <stat+0x4b>
  r = fstat(fd, st);
 2fb:	83 ec 08             	sub    $0x8,%esp
 2fe:	ff 75 0c             	pushl  0xc(%ebp)
 301:	ff 75 f4             	pushl  -0xc(%ebp)
 304:	e8 03 01 00 00       	call   40c <fstat>
 309:	83 c4 10             	add    $0x10,%esp
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30f:	83 ec 0c             	sub    $0xc,%esp
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 c2 00 00 00       	call   3dc <close>
 31a:	83 c4 10             	add    $0x10,%esp
  return r;
 31d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <atoi>:

int
atoi(const char *s)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32f:	eb 25                	jmp    356 <atoi+0x34>
    n = n*10 + *s++ - '0';
 331:	8b 55 fc             	mov    -0x4(%ebp),%edx
 334:	89 d0                	mov    %edx,%eax
 336:	c1 e0 02             	shl    $0x2,%eax
 339:	01 d0                	add    %edx,%eax
 33b:	01 c0                	add    %eax,%eax
 33d:	89 c1                	mov    %eax,%ecx
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 08             	mov    %edx,0x8(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	01 c8                	add    %ecx,%eax
 350:	83 e8 30             	sub    $0x30,%eax
 353:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	3c 2f                	cmp    $0x2f,%al
 35e:	7e 0a                	jle    36a <atoi+0x48>
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	3c 39                	cmp    $0x39,%al
 368:	7e c7                	jle    331 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 381:	eb 17                	jmp    39a <memmove+0x2b>
    *dst++ = *src++;
 383:	8b 45 fc             	mov    -0x4(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 fc             	mov    %edx,-0x4(%ebp)
 38c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38f:	8d 4a 01             	lea    0x1(%edx),%ecx
 392:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 395:	0f b6 12             	movzbl (%edx),%edx
 398:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39a:	8b 45 10             	mov    0x10(%ebp),%eax
 39d:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a0:	89 55 10             	mov    %edx,0x10(%ebp)
 3a3:	85 c0                	test   %eax,%eax
 3a5:	7f dc                	jg     383 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ac:	b8 01 00 00 00       	mov    $0x1,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exit>:
SYSCALL(exit)
 3b4:	b8 02 00 00 00       	mov    $0x2,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <wait>:
SYSCALL(wait)
 3bc:	b8 03 00 00 00       	mov    $0x3,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <pipe>:
SYSCALL(pipe)
 3c4:	b8 04 00 00 00       	mov    $0x4,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <read>:
SYSCALL(read)
 3cc:	b8 05 00 00 00       	mov    $0x5,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <write>:
SYSCALL(write)
 3d4:	b8 10 00 00 00       	mov    $0x10,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <close>:
SYSCALL(close)
 3dc:	b8 15 00 00 00       	mov    $0x15,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <kill>:
SYSCALL(kill)
 3e4:	b8 06 00 00 00       	mov    $0x6,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <exec>:
SYSCALL(exec)
 3ec:	b8 07 00 00 00       	mov    $0x7,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <open>:
SYSCALL(open)
 3f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mknod>:
SYSCALL(mknod)
 3fc:	b8 11 00 00 00       	mov    $0x11,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <unlink>:
SYSCALL(unlink)
 404:	b8 12 00 00 00       	mov    $0x12,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <fstat>:
SYSCALL(fstat)
 40c:	b8 08 00 00 00       	mov    $0x8,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <link>:
SYSCALL(link)
 414:	b8 13 00 00 00       	mov    $0x13,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <mkdir>:
SYSCALL(mkdir)
 41c:	b8 14 00 00 00       	mov    $0x14,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <chdir>:
SYSCALL(chdir)
 424:	b8 09 00 00 00       	mov    $0x9,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <dup>:
SYSCALL(dup)
 42c:	b8 0a 00 00 00       	mov    $0xa,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <getpid>:
SYSCALL(getpid)
 434:	b8 0b 00 00 00       	mov    $0xb,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <sbrk>:
SYSCALL(sbrk)
 43c:	b8 0c 00 00 00       	mov    $0xc,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <sleep>:
SYSCALL(sleep)
 444:	b8 0d 00 00 00       	mov    $0xd,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <uptime>:
SYSCALL(uptime)
 44c:	b8 0e 00 00 00       	mov    $0xe,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <halt>:
SYSCALL(halt)
 454:	b8 16 00 00 00       	mov    $0x16,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <date>:
SYSCALL(date)
 45c:	b8 17 00 00 00       	mov    $0x17,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <getuid>:
SYSCALL(getuid)
 464:	b8 18 00 00 00       	mov    $0x18,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <getgid>:
SYSCALL(getgid)
 46c:	b8 19 00 00 00       	mov    $0x19,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <getppid>:
SYSCALL(getppid)
 474:	b8 1a 00 00 00       	mov    $0x1a,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <setuid>:
SYSCALL(setuid)
 47c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <setgid>:
SYSCALL(setgid)
 484:	b8 1c 00 00 00       	mov    $0x1c,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <getprocs>:
SYSCALL(getprocs)
 48c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <looper>:
SYSCALL(looper)
 494:	b8 1e 00 00 00       	mov    $0x1e,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <setpriority>:
SYSCALL(setpriority)
 49c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <chmod>:
SYSCALL(chmod)
 4a4:	b8 20 00 00 00       	mov    $0x20,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <chown>:
SYSCALL(chown)
 4ac:	b8 21 00 00 00       	mov    $0x21,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <chgrp>:
SYSCALL(chgrp)
 4b4:	b8 22 00 00 00       	mov    $0x22,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 18             	sub    $0x18,%esp
 4c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c8:	83 ec 04             	sub    $0x4,%esp
 4cb:	6a 01                	push   $0x1
 4cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d0:	50                   	push   %eax
 4d1:	ff 75 08             	pushl  0x8(%ebp)
 4d4:	e8 fb fe ff ff       	call   3d4 <write>
 4d9:	83 c4 10             	add    $0x10,%esp
}
 4dc:	90                   	nop
 4dd:	c9                   	leave  
 4de:	c3                   	ret    

000004df <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4df:	55                   	push   %ebp
 4e0:	89 e5                	mov    %esp,%ebp
 4e2:	53                   	push   %ebx
 4e3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ed:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f1:	74 17                	je     50a <printint+0x2b>
 4f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4f7:	79 11                	jns    50a <printint+0x2b>
    neg = 1;
 4f9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 500:	8b 45 0c             	mov    0xc(%ebp),%eax
 503:	f7 d8                	neg    %eax
 505:	89 45 ec             	mov    %eax,-0x14(%ebp)
 508:	eb 06                	jmp    510 <printint+0x31>
  } else {
    x = xx;
 50a:	8b 45 0c             	mov    0xc(%ebp),%eax
 50d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 517:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 51a:	8d 41 01             	lea    0x1(%ecx),%eax
 51d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 520:	8b 5d 10             	mov    0x10(%ebp),%ebx
 523:	8b 45 ec             	mov    -0x14(%ebp),%eax
 526:	ba 00 00 00 00       	mov    $0x0,%edx
 52b:	f7 f3                	div    %ebx
 52d:	89 d0                	mov    %edx,%eax
 52f:	0f b6 80 b0 0c 00 00 	movzbl 0xcb0(%eax),%eax
 536:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 53a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 53d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 540:	ba 00 00 00 00       	mov    $0x0,%edx
 545:	f7 f3                	div    %ebx
 547:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54e:	75 c7                	jne    517 <printint+0x38>
  if(neg)
 550:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 554:	74 2d                	je     583 <printint+0xa4>
    buf[i++] = '-';
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	8d 50 01             	lea    0x1(%eax),%edx
 55c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 55f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 564:	eb 1d                	jmp    583 <printint+0xa4>
    putc(fd, buf[i]);
 566:	8d 55 dc             	lea    -0x24(%ebp),%edx
 569:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56c:	01 d0                	add    %edx,%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	83 ec 08             	sub    $0x8,%esp
 577:	50                   	push   %eax
 578:	ff 75 08             	pushl  0x8(%ebp)
 57b:	e8 3c ff ff ff       	call   4bc <putc>
 580:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 583:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58b:	79 d9                	jns    566 <printint+0x87>
    putc(fd, buf[i]);
}
 58d:	90                   	nop
 58e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 591:	c9                   	leave  
 592:	c3                   	ret    

00000593 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 593:	55                   	push   %ebp
 594:	89 e5                	mov    %esp,%ebp
 596:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 599:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a0:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a3:	83 c0 04             	add    $0x4,%eax
 5a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b0:	e9 59 01 00 00       	jmp    70e <printf+0x17b>
    c = fmt[i] & 0xff;
 5b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bb:	01 d0                	add    %edx,%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	25 ff 00 00 00       	and    $0xff,%eax
 5c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cf:	75 2c                	jne    5fd <printf+0x6a>
      if(c == '%'){
 5d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d5:	75 0c                	jne    5e3 <printf+0x50>
        state = '%';
 5d7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5de:	e9 27 01 00 00       	jmp    70a <printf+0x177>
      } else {
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 c7 fe ff ff       	call   4bc <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	e9 0d 01 00 00       	jmp    70a <printf+0x177>
      }
    } else if(state == '%'){
 5fd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 601:	0f 85 03 01 00 00    	jne    70a <printf+0x177>
      if(c == 'd'){
 607:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 60b:	75 1e                	jne    62b <printf+0x98>
        printint(fd, *ap, 10, 1);
 60d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	6a 01                	push   $0x1
 614:	6a 0a                	push   $0xa
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 c0 fe ff ff       	call   4df <printint>
 61f:	83 c4 10             	add    $0x10,%esp
        ap++;
 622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 626:	e9 d8 00 00 00       	jmp    703 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 62b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62f:	74 06                	je     637 <printf+0xa4>
 631:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 635:	75 1e                	jne    655 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 637:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	6a 00                	push   $0x0
 63e:	6a 10                	push   $0x10
 640:	50                   	push   %eax
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 96 fe ff ff       	call   4df <printint>
 649:	83 c4 10             	add    $0x10,%esp
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 650:	e9 ae 00 00 00       	jmp    703 <printf+0x170>
      } else if(c == 's'){
 655:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 659:	75 43                	jne    69e <printf+0x10b>
        s = (char*)*ap;
 65b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 663:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 667:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 66b:	75 25                	jne    692 <printf+0xff>
          s = "(null)";
 66d:	c7 45 f4 e7 09 00 00 	movl   $0x9e7,-0xc(%ebp)
        while(*s != 0){
 674:	eb 1c                	jmp    692 <printf+0xff>
          putc(fd, *s);
 676:	8b 45 f4             	mov    -0xc(%ebp),%eax
 679:	0f b6 00             	movzbl (%eax),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	83 ec 08             	sub    $0x8,%esp
 682:	50                   	push   %eax
 683:	ff 75 08             	pushl  0x8(%ebp)
 686:	e8 31 fe ff ff       	call   4bc <putc>
 68b:	83 c4 10             	add    $0x10,%esp
          s++;
 68e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 692:	8b 45 f4             	mov    -0xc(%ebp),%eax
 695:	0f b6 00             	movzbl (%eax),%eax
 698:	84 c0                	test   %al,%al
 69a:	75 da                	jne    676 <printf+0xe3>
 69c:	eb 65                	jmp    703 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a2:	75 1d                	jne    6c1 <printf+0x12e>
        putc(fd, *ap);
 6a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	83 ec 08             	sub    $0x8,%esp
 6af:	50                   	push   %eax
 6b0:	ff 75 08             	pushl  0x8(%ebp)
 6b3:	e8 04 fe ff ff       	call   4bc <putc>
 6b8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bf:	eb 42                	jmp    703 <printf+0x170>
      } else if(c == '%'){
 6c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c5:	75 17                	jne    6de <printf+0x14b>
        putc(fd, c);
 6c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ca:	0f be c0             	movsbl %al,%eax
 6cd:	83 ec 08             	sub    $0x8,%esp
 6d0:	50                   	push   %eax
 6d1:	ff 75 08             	pushl  0x8(%ebp)
 6d4:	e8 e3 fd ff ff       	call   4bc <putc>
 6d9:	83 c4 10             	add    $0x10,%esp
 6dc:	eb 25                	jmp    703 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6de:	83 ec 08             	sub    $0x8,%esp
 6e1:	6a 25                	push   $0x25
 6e3:	ff 75 08             	pushl  0x8(%ebp)
 6e6:	e8 d1 fd ff ff       	call   4bc <putc>
 6eb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	83 ec 08             	sub    $0x8,%esp
 6f7:	50                   	push   %eax
 6f8:	ff 75 08             	pushl  0x8(%ebp)
 6fb:	e8 bc fd ff ff       	call   4bc <putc>
 700:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 703:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 70a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 70e:	8b 55 0c             	mov    0xc(%ebp),%edx
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	01 d0                	add    %edx,%eax
 716:	0f b6 00             	movzbl (%eax),%eax
 719:	84 c0                	test   %al,%al
 71b:	0f 85 94 fe ff ff    	jne    5b5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 721:	90                   	nop
 722:	c9                   	leave  
 723:	c3                   	ret    

00000724 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 724:	55                   	push   %ebp
 725:	89 e5                	mov    %esp,%ebp
 727:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
 72d:	83 e8 08             	sub    $0x8,%eax
 730:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 733:	a1 cc 0c 00 00       	mov    0xccc,%eax
 738:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73b:	eb 24                	jmp    761 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 745:	77 12                	ja     759 <free+0x35>
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74d:	77 24                	ja     773 <free+0x4f>
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 757:	77 1a                	ja     773 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 767:	76 d4                	jbe    73d <free+0x19>
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 771:	76 ca                	jbe    73d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	01 c2                	add    %eax,%edx
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	39 c2                	cmp    %eax,%edx
 78c:	75 24                	jne    7b2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	8b 50 04             	mov    0x4(%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	01 c2                	add    %eax,%edx
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	8b 10                	mov    (%eax),%edx
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	89 10                	mov    %edx,(%eax)
 7b0:	eb 0a                	jmp    7bc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	01 d0                	add    %edx,%eax
 7ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d1:	75 20                	jne    7f3 <free+0xcf>
    p->s.size += bp->s.size;
 7d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d6:	8b 50 04             	mov    0x4(%eax),%edx
 7d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	01 c2                	add    %eax,%edx
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	89 10                	mov    %edx,(%eax)
 7f1:	eb 08                	jmp    7fb <free+0xd7>
  } else
    p->s.ptr = bp;
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fe:	a3 cc 0c 00 00       	mov    %eax,0xccc
}
 803:	90                   	nop
 804:	c9                   	leave  
 805:	c3                   	ret    

00000806 <morecore>:

static Header*
morecore(uint nu)
{
 806:	55                   	push   %ebp
 807:	89 e5                	mov    %esp,%ebp
 809:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 80c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 813:	77 07                	ja     81c <morecore+0x16>
    nu = 4096;
 815:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 81c:	8b 45 08             	mov    0x8(%ebp),%eax
 81f:	c1 e0 03             	shl    $0x3,%eax
 822:	83 ec 0c             	sub    $0xc,%esp
 825:	50                   	push   %eax
 826:	e8 11 fc ff ff       	call   43c <sbrk>
 82b:	83 c4 10             	add    $0x10,%esp
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 831:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 835:	75 07                	jne    83e <morecore+0x38>
    return 0;
 837:	b8 00 00 00 00       	mov    $0x0,%eax
 83c:	eb 26                	jmp    864 <morecore+0x5e>
  hp = (Header*)p;
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
 847:	8b 55 08             	mov    0x8(%ebp),%edx
 84a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	83 c0 08             	add    $0x8,%eax
 853:	83 ec 0c             	sub    $0xc,%esp
 856:	50                   	push   %eax
 857:	e8 c8 fe ff ff       	call   724 <free>
 85c:	83 c4 10             	add    $0x10,%esp
  return freep;
 85f:	a1 cc 0c 00 00       	mov    0xccc,%eax
}
 864:	c9                   	leave  
 865:	c3                   	ret    

00000866 <malloc>:

void*
malloc(uint nbytes)
{
 866:	55                   	push   %ebp
 867:	89 e5                	mov    %esp,%ebp
 869:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	83 c0 07             	add    $0x7,%eax
 872:	c1 e8 03             	shr    $0x3,%eax
 875:	83 c0 01             	add    $0x1,%eax
 878:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 87b:	a1 cc 0c 00 00       	mov    0xccc,%eax
 880:	89 45 f0             	mov    %eax,-0x10(%ebp)
 883:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 887:	75 23                	jne    8ac <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 889:	c7 45 f0 c4 0c 00 00 	movl   $0xcc4,-0x10(%ebp)
 890:	8b 45 f0             	mov    -0x10(%ebp),%eax
 893:	a3 cc 0c 00 00       	mov    %eax,0xccc
 898:	a1 cc 0c 00 00       	mov    0xccc,%eax
 89d:	a3 c4 0c 00 00       	mov    %eax,0xcc4
    base.s.size = 0;
 8a2:	c7 05 c8 0c 00 00 00 	movl   $0x0,0xcc8
 8a9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	8b 00                	mov    (%eax),%eax
 8b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	8b 40 04             	mov    0x4(%eax),%eax
 8ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8bd:	72 4d                	jb     90c <malloc+0xa6>
      if(p->s.size == nunits)
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c8:	75 0c                	jne    8d6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 10                	mov    (%eax),%edx
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	89 10                	mov    %edx,(%eax)
 8d4:	eb 26                	jmp    8fc <malloc+0x96>
      else {
        p->s.size -= nunits;
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8df:	89 c2                	mov    %eax,%edx
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	c1 e0 03             	shl    $0x3,%eax
 8f0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	a3 cc 0c 00 00       	mov    %eax,0xccc
      return (void*)(p + 1);
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	83 c0 08             	add    $0x8,%eax
 90a:	eb 3b                	jmp    947 <malloc+0xe1>
    }
    if(p == freep)
 90c:	a1 cc 0c 00 00       	mov    0xccc,%eax
 911:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 914:	75 1e                	jne    934 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 916:	83 ec 0c             	sub    $0xc,%esp
 919:	ff 75 ec             	pushl  -0x14(%ebp)
 91c:	e8 e5 fe ff ff       	call   806 <morecore>
 921:	83 c4 10             	add    $0x10,%esp
 924:	89 45 f4             	mov    %eax,-0xc(%ebp)
 927:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92b:	75 07                	jne    934 <malloc+0xce>
        return 0;
 92d:	b8 00 00 00 00       	mov    $0x0,%eax
 932:	eb 13                	jmp    947 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	8b 00                	mov    (%eax),%eax
 93f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 942:	e9 6d ff ff ff       	jmp    8b4 <malloc+0x4e>
}
 947:	c9                   	leave  
 948:	c3                   	ret    
