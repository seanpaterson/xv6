
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main (int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 20             	sub    $0x20,%esp
  12:	89 cb                	mov    %ecx,%ebx
	uint startticks = 0;
  14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint tickdifference = 0;
  1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	uint pid;
	uint seconds;
	uint milliseconds;
	if(argc == 1)
  22:	83 3b 01             	cmpl   $0x1,(%ebx)
  25:	75 1b                	jne    42 <main+0x42>
		strcpy(argv[0], " ");
  27:	8b 43 04             	mov    0x4(%ebx),%eax
  2a:	8b 00                	mov    (%eax),%eax
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 dc 08 00 00       	push   $0x8dc
  34:	50                   	push   %eax
  35:	e8 d9 00 00 00       	call   113 <strcpy>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	e9 88 00 00 00       	jmp    ca <main+0xca>
	else{
		startticks = uptime();
  42:	e8 95 03 00 00       	call   3dc <uptime>
  47:	89 45 ec             	mov    %eax,-0x14(%ebp)
		++argv;
  4a:	83 43 04 04          	addl   $0x4,0x4(%ebx)
		pid = fork();
  4e:	e8 e9 02 00 00       	call   33c <fork>
  53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(pid == 0){
  56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  5a:	75 31                	jne    8d <main+0x8d>
			exec (argv[0],argv);
  5c:	8b 43 04             	mov    0x4(%ebx),%eax
  5f:	8b 00                	mov    (%eax),%eax
  61:	83 ec 08             	sub    $0x8,%esp
  64:	ff 73 04             	pushl  0x4(%ebx)
  67:	50                   	push   %eax
  68:	e8 0f 03 00 00       	call   37c <exec>
  6d:	83 c4 10             	add    $0x10,%esp
			printf(2, "ERROR: %s is not a proper name for a command! \n", argv[0]);
  70:	8b 43 04             	mov    0x4(%ebx),%eax
  73:	8b 00                	mov    (%eax),%eax
  75:	83 ec 04             	sub    $0x4,%esp
  78:	50                   	push   %eax
  79:	68 e0 08 00 00       	push   $0x8e0
  7e:	6a 02                	push   $0x2
  80:	e8 9e 04 00 00       	call   523 <printf>
  85:	83 c4 10             	add    $0x10,%esp
			exit();
  88:	e8 b7 02 00 00       	call   344 <exit>
		}
		wait();
  8d:	e8 ba 02 00 00       	call   34c <wait>
		tickdifference = uptime() - startticks;
  92:	e8 45 03 00 00       	call   3dc <uptime>
  97:	2b 45 ec             	sub    -0x14(%ebp),%eax
  9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		seconds = tickdifference / 100;
  9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  a0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  a5:	f7 e2                	mul    %edx
  a7:	89 d0                	mov    %edx,%eax
  a9:	c1 e8 05             	shr    $0x5,%eax
  ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        	milliseconds = tickdifference % 100;
  af:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  b2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  b7:	89 c8                	mov    %ecx,%eax
  b9:	f7 e2                	mul    %edx
  bb:	89 d0                	mov    %edx,%eax
  bd:	c1 e8 05             	shr    $0x5,%eax
  c0:	6b c0 64             	imul   $0x64,%eax,%eax
  c3:	29 c1                	sub    %eax,%ecx
  c5:	89 c8                	mov    %ecx,%eax
  c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}
	
	printf(2,"%s ran for %d.%d seconds. \n", argv[0],seconds,milliseconds);
  ca:	8b 43 04             	mov    0x4(%ebx),%eax
  cd:	8b 00                	mov    (%eax),%eax
  cf:	83 ec 0c             	sub    $0xc,%esp
  d2:	ff 75 f0             	pushl  -0x10(%ebp)
  d5:	ff 75 f4             	pushl  -0xc(%ebp)
  d8:	50                   	push   %eax
  d9:	68 10 09 00 00       	push   $0x910
  de:	6a 02                	push   $0x2
  e0:	e8 3e 04 00 00       	call   523 <printf>
  e5:	83 c4 20             	add    $0x20,%esp
	exit();
  e8:	e8 57 02 00 00       	call   344 <exit>

000000ed <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ed:	55                   	push   %ebp
  ee:	89 e5                	mov    %esp,%ebp
  f0:	57                   	push   %edi
  f1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f5:	8b 55 10             	mov    0x10(%ebp),%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	89 cb                	mov    %ecx,%ebx
  fd:	89 df                	mov    %ebx,%edi
  ff:	89 d1                	mov    %edx,%ecx
 101:	fc                   	cld    
 102:	f3 aa                	rep stos %al,%es:(%edi)
 104:	89 ca                	mov    %ecx,%edx
 106:	89 fb                	mov    %edi,%ebx
 108:	89 5d 08             	mov    %ebx,0x8(%ebp)
 10b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 10e:	90                   	nop
 10f:	5b                   	pop    %ebx
 110:	5f                   	pop    %edi
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    

00000113 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 11f:	90                   	nop
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	8d 50 01             	lea    0x1(%eax),%edx
 126:	89 55 08             	mov    %edx,0x8(%ebp)
 129:	8b 55 0c             	mov    0xc(%ebp),%edx
 12c:	8d 4a 01             	lea    0x1(%edx),%ecx
 12f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 132:	0f b6 12             	movzbl (%edx),%edx
 135:	88 10                	mov    %dl,(%eax)
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	84 c0                	test   %al,%al
 13c:	75 e2                	jne    120 <strcpy+0xd>
    ;
  return os;
 13e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 141:	c9                   	leave  
 142:	c3                   	ret    

00000143 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 146:	eb 08                	jmp    150 <strcmp+0xd>
    p++, q++;
 148:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 14c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	84 c0                	test   %al,%al
 158:	74 10                	je     16a <strcmp+0x27>
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	0f b6 10             	movzbl (%eax),%edx
 160:	8b 45 0c             	mov    0xc(%ebp),%eax
 163:	0f b6 00             	movzbl (%eax),%eax
 166:	38 c2                	cmp    %al,%dl
 168:	74 de                	je     148 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	0f b6 d0             	movzbl %al,%edx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	0f b6 c0             	movzbl %al,%eax
 17c:	29 c2                	sub    %eax,%edx
 17e:	89 d0                	mov    %edx,%eax
}
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <strlen>:

uint
strlen(char *s)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 188:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 18f:	eb 04                	jmp    195 <strlen+0x13>
 191:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 195:	8b 55 fc             	mov    -0x4(%ebp),%edx
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	01 d0                	add    %edx,%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	84 c0                	test   %al,%al
 1a2:	75 ed                	jne    191 <strlen+0xf>
    ;
  return n;
 1a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    

000001a9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ac:	8b 45 10             	mov    0x10(%ebp),%eax
 1af:	50                   	push   %eax
 1b0:	ff 75 0c             	pushl  0xc(%ebp)
 1b3:	ff 75 08             	pushl  0x8(%ebp)
 1b6:	e8 32 ff ff ff       	call   ed <stosb>
 1bb:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c1:	c9                   	leave  
 1c2:	c3                   	ret    

000001c3 <strchr>:

char*
strchr(const char *s, char c)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	83 ec 04             	sub    $0x4,%esp
 1c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1cf:	eb 14                	jmp    1e5 <strchr+0x22>
    if(*s == c)
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	0f b6 00             	movzbl (%eax),%eax
 1d7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1da:	75 05                	jne    1e1 <strchr+0x1e>
      return (char*)s;
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	eb 13                	jmp    1f4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	84 c0                	test   %al,%al
 1ed:	75 e2                	jne    1d1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <gets>:

char*
gets(char *buf, int max)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 203:	eb 42                	jmp    247 <gets+0x51>
    cc = read(0, &c, 1);
 205:	83 ec 04             	sub    $0x4,%esp
 208:	6a 01                	push   $0x1
 20a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 20d:	50                   	push   %eax
 20e:	6a 00                	push   $0x0
 210:	e8 47 01 00 00       	call   35c <read>
 215:	83 c4 10             	add    $0x10,%esp
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 21f:	7e 33                	jle    254 <gets+0x5e>
      break;
    buf[i++] = c;
 221:	8b 45 f4             	mov    -0xc(%ebp),%eax
 224:	8d 50 01             	lea    0x1(%eax),%edx
 227:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22a:	89 c2                	mov    %eax,%edx
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	01 c2                	add    %eax,%edx
 231:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 235:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 237:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23b:	3c 0a                	cmp    $0xa,%al
 23d:	74 16                	je     255 <gets+0x5f>
 23f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 243:	3c 0d                	cmp    $0xd,%al
 245:	74 0e                	je     255 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	83 c0 01             	add    $0x1,%eax
 24d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 250:	7c b3                	jl     205 <gets+0xf>
 252:	eb 01                	jmp    255 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 254:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 255:	8b 55 f4             	mov    -0xc(%ebp),%edx
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	01 d0                	add    %edx,%eax
 25d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <stat>:

int
stat(char *n, struct stat *st)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26b:	83 ec 08             	sub    $0x8,%esp
 26e:	6a 00                	push   $0x0
 270:	ff 75 08             	pushl  0x8(%ebp)
 273:	e8 0c 01 00 00       	call   384 <open>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 27e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 282:	79 07                	jns    28b <stat+0x26>
    return -1;
 284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 289:	eb 25                	jmp    2b0 <stat+0x4b>
  r = fstat(fd, st);
 28b:	83 ec 08             	sub    $0x8,%esp
 28e:	ff 75 0c             	pushl  0xc(%ebp)
 291:	ff 75 f4             	pushl  -0xc(%ebp)
 294:	e8 03 01 00 00       	call   39c <fstat>
 299:	83 c4 10             	add    $0x10,%esp
 29c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 29f:	83 ec 0c             	sub    $0xc,%esp
 2a2:	ff 75 f4             	pushl  -0xc(%ebp)
 2a5:	e8 c2 00 00 00       	call   36c <close>
 2aa:	83 c4 10             	add    $0x10,%esp
  return r;
 2ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <atoi>:

int
atoi(const char *s)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bf:	eb 25                	jmp    2e6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c4:	89 d0                	mov    %edx,%eax
 2c6:	c1 e0 02             	shl    $0x2,%eax
 2c9:	01 d0                	add    %edx,%eax
 2cb:	01 c0                	add    %eax,%eax
 2cd:	89 c1                	mov    %eax,%ecx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	8d 50 01             	lea    0x1(%eax),%edx
 2d5:	89 55 08             	mov    %edx,0x8(%ebp)
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	0f be c0             	movsbl %al,%eax
 2de:	01 c8                	add    %ecx,%eax
 2e0:	83 e8 30             	sub    $0x30,%eax
 2e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	3c 2f                	cmp    $0x2f,%al
 2ee:	7e 0a                	jle    2fa <atoi+0x48>
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	3c 39                	cmp    $0x39,%al
 2f8:	7e c7                	jle    2c1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fd:	c9                   	leave  
 2fe:	c3                   	ret    

000002ff <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ff:	55                   	push   %ebp
 300:	89 e5                	mov    %esp,%ebp
 302:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 30b:	8b 45 0c             	mov    0xc(%ebp),%eax
 30e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 311:	eb 17                	jmp    32a <memmove+0x2b>
    *dst++ = *src++;
 313:	8b 45 fc             	mov    -0x4(%ebp),%eax
 316:	8d 50 01             	lea    0x1(%eax),%edx
 319:	89 55 fc             	mov    %edx,-0x4(%ebp)
 31c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31f:	8d 4a 01             	lea    0x1(%edx),%ecx
 322:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 325:	0f b6 12             	movzbl (%edx),%edx
 328:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	8d 50 ff             	lea    -0x1(%eax),%edx
 330:	89 55 10             	mov    %edx,0x10(%ebp)
 333:	85 c0                	test   %eax,%eax
 335:	7f dc                	jg     313 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33c:	b8 01 00 00 00       	mov    $0x1,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exit>:
SYSCALL(exit)
 344:	b8 02 00 00 00       	mov    $0x2,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <wait>:
SYSCALL(wait)
 34c:	b8 03 00 00 00       	mov    $0x3,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <pipe>:
SYSCALL(pipe)
 354:	b8 04 00 00 00       	mov    $0x4,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <read>:
SYSCALL(read)
 35c:	b8 05 00 00 00       	mov    $0x5,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <write>:
SYSCALL(write)
 364:	b8 10 00 00 00       	mov    $0x10,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <close>:
SYSCALL(close)
 36c:	b8 15 00 00 00       	mov    $0x15,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <kill>:
SYSCALL(kill)
 374:	b8 06 00 00 00       	mov    $0x6,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exec>:
SYSCALL(exec)
 37c:	b8 07 00 00 00       	mov    $0x7,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <open>:
SYSCALL(open)
 384:	b8 0f 00 00 00       	mov    $0xf,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mknod>:
SYSCALL(mknod)
 38c:	b8 11 00 00 00       	mov    $0x11,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <unlink>:
SYSCALL(unlink)
 394:	b8 12 00 00 00       	mov    $0x12,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <fstat>:
SYSCALL(fstat)
 39c:	b8 08 00 00 00       	mov    $0x8,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <link>:
SYSCALL(link)
 3a4:	b8 13 00 00 00       	mov    $0x13,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <mkdir>:
SYSCALL(mkdir)
 3ac:	b8 14 00 00 00       	mov    $0x14,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chdir>:
SYSCALL(chdir)
 3b4:	b8 09 00 00 00       	mov    $0x9,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <dup>:
SYSCALL(dup)
 3bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <getpid>:
SYSCALL(getpid)
 3c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <sleep>:
SYSCALL(sleep)
 3d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <uptime>:
SYSCALL(uptime)
 3dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <halt>:
SYSCALL(halt)
 3e4:	b8 16 00 00 00       	mov    $0x16,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <date>:
SYSCALL(date)
 3ec:	b8 17 00 00 00       	mov    $0x17,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getuid>:
SYSCALL(getuid)
 3f4:	b8 18 00 00 00       	mov    $0x18,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getgid>:
SYSCALL(getgid)
 3fc:	b8 19 00 00 00       	mov    $0x19,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <getppid>:
SYSCALL(getppid)
 404:	b8 1a 00 00 00       	mov    $0x1a,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <setuid>:
SYSCALL(setuid)
 40c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <setgid>:
SYSCALL(setgid)
 414:	b8 1c 00 00 00       	mov    $0x1c,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <getprocs>:
SYSCALL(getprocs)
 41c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <looper>:
SYSCALL(looper)
 424:	b8 1e 00 00 00       	mov    $0x1e,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <setpriority>:
SYSCALL(setpriority)
 42c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <chmod>:
SYSCALL(chmod)
 434:	b8 20 00 00 00       	mov    $0x20,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <chown>:
SYSCALL(chown)
 43c:	b8 21 00 00 00       	mov    $0x21,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <chgrp>:
SYSCALL(chgrp)
 444:	b8 22 00 00 00       	mov    $0x22,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 18             	sub    $0x18,%esp
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 458:	83 ec 04             	sub    $0x4,%esp
 45b:	6a 01                	push   $0x1
 45d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 460:	50                   	push   %eax
 461:	ff 75 08             	pushl  0x8(%ebp)
 464:	e8 fb fe ff ff       	call   364 <write>
 469:	83 c4 10             	add    $0x10,%esp
}
 46c:	90                   	nop
 46d:	c9                   	leave  
 46e:	c3                   	ret    

0000046f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	53                   	push   %ebx
 473:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 476:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 47d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 481:	74 17                	je     49a <printint+0x2b>
 483:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 487:	79 11                	jns    49a <printint+0x2b>
    neg = 1;
 489:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 490:	8b 45 0c             	mov    0xc(%ebp),%eax
 493:	f7 d8                	neg    %eax
 495:	89 45 ec             	mov    %eax,-0x14(%ebp)
 498:	eb 06                	jmp    4a0 <printint+0x31>
  } else {
    x = xx;
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4aa:	8d 41 01             	lea    0x1(%ecx),%eax
 4ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b6:	ba 00 00 00 00       	mov    $0x0,%edx
 4bb:	f7 f3                	div    %ebx
 4bd:	89 d0                	mov    %edx,%eax
 4bf:	0f b6 80 80 0b 00 00 	movzbl 0xb80(%eax),%eax
 4c6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d0:	ba 00 00 00 00       	mov    $0x0,%edx
 4d5:	f7 f3                	div    %ebx
 4d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4de:	75 c7                	jne    4a7 <printint+0x38>
  if(neg)
 4e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e4:	74 2d                	je     513 <printint+0xa4>
    buf[i++] = '-';
 4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e9:	8d 50 01             	lea    0x1(%eax),%edx
 4ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ef:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f4:	eb 1d                	jmp    513 <printint+0xa4>
    putc(fd, buf[i]);
 4f6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	01 d0                	add    %edx,%eax
 4fe:	0f b6 00             	movzbl (%eax),%eax
 501:	0f be c0             	movsbl %al,%eax
 504:	83 ec 08             	sub    $0x8,%esp
 507:	50                   	push   %eax
 508:	ff 75 08             	pushl  0x8(%ebp)
 50b:	e8 3c ff ff ff       	call   44c <putc>
 510:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 513:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 517:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51b:	79 d9                	jns    4f6 <printint+0x87>
    putc(fd, buf[i]);
}
 51d:	90                   	nop
 51e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 521:	c9                   	leave  
 522:	c3                   	ret    

00000523 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 529:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 530:	8d 45 0c             	lea    0xc(%ebp),%eax
 533:	83 c0 04             	add    $0x4,%eax
 536:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 540:	e9 59 01 00 00       	jmp    69e <printf+0x17b>
    c = fmt[i] & 0xff;
 545:	8b 55 0c             	mov    0xc(%ebp),%edx
 548:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54b:	01 d0                	add    %edx,%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	0f be c0             	movsbl %al,%eax
 553:	25 ff 00 00 00       	and    $0xff,%eax
 558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55f:	75 2c                	jne    58d <printf+0x6a>
      if(c == '%'){
 561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 565:	75 0c                	jne    573 <printf+0x50>
        state = '%';
 567:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56e:	e9 27 01 00 00       	jmp    69a <printf+0x177>
      } else {
        putc(fd, c);
 573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 c7 fe ff ff       	call   44c <putc>
 585:	83 c4 10             	add    $0x10,%esp
 588:	e9 0d 01 00 00       	jmp    69a <printf+0x177>
      }
    } else if(state == '%'){
 58d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 591:	0f 85 03 01 00 00    	jne    69a <printf+0x177>
      if(c == 'd'){
 597:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59b:	75 1e                	jne    5bb <printf+0x98>
        printint(fd, *ap, 10, 1);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	6a 01                	push   $0x1
 5a4:	6a 0a                	push   $0xa
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 c0 fe ff ff       	call   46f <printint>
 5af:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b6:	e9 d8 00 00 00       	jmp    693 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5bb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bf:	74 06                	je     5c7 <printf+0xa4>
 5c1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c5:	75 1e                	jne    5e5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ca:	8b 00                	mov    (%eax),%eax
 5cc:	6a 00                	push   $0x0
 5ce:	6a 10                	push   $0x10
 5d0:	50                   	push   %eax
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 96 fe ff ff       	call   46f <printint>
 5d9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e0:	e9 ae 00 00 00       	jmp    693 <printf+0x170>
      } else if(c == 's'){
 5e5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e9:	75 43                	jne    62e <printf+0x10b>
        s = (char*)*ap;
 5eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fb:	75 25                	jne    622 <printf+0xff>
          s = "(null)";
 5fd:	c7 45 f4 2c 09 00 00 	movl   $0x92c,-0xc(%ebp)
        while(*s != 0){
 604:	eb 1c                	jmp    622 <printf+0xff>
          putc(fd, *s);
 606:	8b 45 f4             	mov    -0xc(%ebp),%eax
 609:	0f b6 00             	movzbl (%eax),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	83 ec 08             	sub    $0x8,%esp
 612:	50                   	push   %eax
 613:	ff 75 08             	pushl  0x8(%ebp)
 616:	e8 31 fe ff ff       	call   44c <putc>
 61b:	83 c4 10             	add    $0x10,%esp
          s++;
 61e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	84 c0                	test   %al,%al
 62a:	75 da                	jne    606 <printf+0xe3>
 62c:	eb 65                	jmp    693 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 632:	75 1d                	jne    651 <printf+0x12e>
        putc(fd, *ap);
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	83 ec 08             	sub    $0x8,%esp
 63f:	50                   	push   %eax
 640:	ff 75 08             	pushl  0x8(%ebp)
 643:	e8 04 fe ff ff       	call   44c <putc>
 648:	83 c4 10             	add    $0x10,%esp
        ap++;
 64b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64f:	eb 42                	jmp    693 <printf+0x170>
      } else if(c == '%'){
 651:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 655:	75 17                	jne    66e <printf+0x14b>
        putc(fd, c);
 657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65a:	0f be c0             	movsbl %al,%eax
 65d:	83 ec 08             	sub    $0x8,%esp
 660:	50                   	push   %eax
 661:	ff 75 08             	pushl  0x8(%ebp)
 664:	e8 e3 fd ff ff       	call   44c <putc>
 669:	83 c4 10             	add    $0x10,%esp
 66c:	eb 25                	jmp    693 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	6a 25                	push   $0x25
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 d1 fd ff ff       	call   44c <putc>
 67b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	83 ec 08             	sub    $0x8,%esp
 687:	50                   	push   %eax
 688:	ff 75 08             	pushl  0x8(%ebp)
 68b:	e8 bc fd ff ff       	call   44c <putc>
 690:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 693:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69e:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a4:	01 d0                	add    %edx,%eax
 6a6:	0f b6 00             	movzbl (%eax),%eax
 6a9:	84 c0                	test   %al,%al
 6ab:	0f 85 94 fe ff ff    	jne    545 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b1:	90                   	nop
 6b2:	c9                   	leave  
 6b3:	c3                   	ret    

000006b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	83 e8 08             	sub    $0x8,%eax
 6c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c3:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 6c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cb:	eb 24                	jmp    6f1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	77 12                	ja     6e9 <free+0x35>
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6dd:	77 24                	ja     703 <free+0x4f>
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e7:	77 1a                	ja     703 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f7:	76 d4                	jbe    6cd <free+0x19>
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 701:	76 ca                	jbe    6cd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	8b 40 04             	mov    0x4(%eax),%eax
 709:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	01 c2                	add    %eax,%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	39 c2                	cmp    %eax,%edx
 71c:	75 24                	jne    742 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 50 04             	mov    0x4(%eax),%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	eb 0a                	jmp    74c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	01 d0                	add    %edx,%eax
 75e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 761:	75 20                	jne    783 <free+0xcf>
    p->s.size += bp->s.size;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 50 04             	mov    0x4(%eax),%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	01 c2                	add    %eax,%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
 781:	eb 08                	jmp    78b <free+0xd7>
  } else
    p->s.ptr = bp;
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 55 f8             	mov    -0x8(%ebp),%edx
 789:	89 10                	mov    %edx,(%eax)
  freep = p;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	a3 9c 0b 00 00       	mov    %eax,0xb9c
}
 793:	90                   	nop
 794:	c9                   	leave  
 795:	c3                   	ret    

00000796 <morecore>:

static Header*
morecore(uint nu)
{
 796:	55                   	push   %ebp
 797:	89 e5                	mov    %esp,%ebp
 799:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a3:	77 07                	ja     7ac <morecore+0x16>
    nu = 4096;
 7a5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	c1 e0 03             	shl    $0x3,%eax
 7b2:	83 ec 0c             	sub    $0xc,%esp
 7b5:	50                   	push   %eax
 7b6:	e8 11 fc ff ff       	call   3cc <sbrk>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c5:	75 07                	jne    7ce <morecore+0x38>
    return 0;
 7c7:	b8 00 00 00 00       	mov    $0x0,%eax
 7cc:	eb 26                	jmp    7f4 <morecore+0x5e>
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
 7e7:	e8 c8 fe ff ff       	call   6b4 <free>
 7ec:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ef:	a1 9c 0b 00 00       	mov    0xb9c,%eax
}
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    

000007f6 <malloc>:

void*
malloc(uint nbytes)
{
 7f6:	55                   	push   %ebp
 7f7:	89 e5                	mov    %esp,%ebp
 7f9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	83 c0 07             	add    $0x7,%eax
 802:	c1 e8 03             	shr    $0x3,%eax
 805:	83 c0 01             	add    $0x1,%eax
 808:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80b:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 810:	89 45 f0             	mov    %eax,-0x10(%ebp)
 813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 817:	75 23                	jne    83c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 819:	c7 45 f0 94 0b 00 00 	movl   $0xb94,-0x10(%ebp)
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	a3 9c 0b 00 00       	mov    %eax,0xb9c
 828:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 82d:	a3 94 0b 00 00       	mov    %eax,0xb94
    base.s.size = 0;
 832:	c7 05 98 0b 00 00 00 	movl   $0x0,0xb98
 839:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	8b 00                	mov    (%eax),%eax
 841:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84d:	72 4d                	jb     89c <malloc+0xa6>
      if(p->s.size == nunits)
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 858:	75 0c                	jne    866 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 10                	mov    (%eax),%edx
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	89 10                	mov    %edx,(%eax)
 864:	eb 26                	jmp    88c <malloc+0x96>
      else {
        p->s.size -= nunits;
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86f:	89 c2                	mov    %eax,%edx
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	c1 e0 03             	shl    $0x3,%eax
 880:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 55 ec             	mov    -0x14(%ebp),%edx
 889:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	a3 9c 0b 00 00       	mov    %eax,0xb9c
      return (void*)(p + 1);
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	83 c0 08             	add    $0x8,%eax
 89a:	eb 3b                	jmp    8d7 <malloc+0xe1>
    }
    if(p == freep)
 89c:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 8a1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a4:	75 1e                	jne    8c4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a6:	83 ec 0c             	sub    $0xc,%esp
 8a9:	ff 75 ec             	pushl  -0x14(%ebp)
 8ac:	e8 e5 fe ff ff       	call   796 <morecore>
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8bb:	75 07                	jne    8c4 <malloc+0xce>
        return 0;
 8bd:	b8 00 00 00 00       	mov    $0x0,%eax
 8c2:	eb 13                	jmp    8d7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 00                	mov    (%eax),%eax
 8cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d2:	e9 6d ff ff ff       	jmp    844 <malloc+0x4e>
}
 8d7:	c9                   	leave  
 8d8:	c3                   	ret    
