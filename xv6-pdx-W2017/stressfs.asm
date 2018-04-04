
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 3e 09 00 00       	push   $0x93e
  30:	6a 01                	push   $0x1
  32:	e8 51 05 00 00       	call   588 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 40 03 00 00       	call   3a1 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
    if(fork() > 0)
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 51 09 00 00       	push   $0x951
  7d:	6a 01                	push   $0x1
  7f:	e8 04 05 00 00       	call   588 <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 43 03 00 00       	call   3e9 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 fd 02 00 00       	call   3c9 <write>
  cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 ed 02 00 00       	call   3d1 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 5b 09 00 00       	push   $0x95b
  ef:	6a 01                	push   $0x1
  f1:	e8 92 04 00 00       	call   588 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 e2 02 00 00       	call   3e9 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 94 02 00 00       	call   3c1 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 8c 02 00 00       	call   3d1 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 64 02 00 00       	call   3b1 <wait>
  
  exit();
 14d:	e8 57 02 00 00       	call   3a9 <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8d 50 01             	lea    0x1(%eax),%edx
 18b:	89 55 08             	mov    %edx,0x8(%ebp)
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
 191:	8d 4a 01             	lea    0x1(%edx),%ecx
 194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 47 01 00 00       	call   3c1 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b3                	jl     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	pushl  0x8(%ebp)
 2d8:	e8 0c 01 00 00       	call   3e9 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	pushl  0xc(%ebp)
 2f6:	ff 75 f4             	pushl  -0xc(%ebp)
 2f9:	e8 03 01 00 00       	call   401 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	pushl  -0xc(%ebp)
 30a:	e8 c2 00 00 00       	call   3d1 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 381:	8b 55 f8             	mov    -0x8(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a1:	b8 01 00 00 00       	mov    $0x1,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <exit>:
SYSCALL(exit)
 3a9:	b8 02 00 00 00       	mov    $0x2,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <wait>:
SYSCALL(wait)
 3b1:	b8 03 00 00 00       	mov    $0x3,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <pipe>:
SYSCALL(pipe)
 3b9:	b8 04 00 00 00       	mov    $0x4,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <read>:
SYSCALL(read)
 3c1:	b8 05 00 00 00       	mov    $0x5,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <write>:
SYSCALL(write)
 3c9:	b8 10 00 00 00       	mov    $0x10,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <close>:
SYSCALL(close)
 3d1:	b8 15 00 00 00       	mov    $0x15,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <kill>:
SYSCALL(kill)
 3d9:	b8 06 00 00 00       	mov    $0x6,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <exec>:
SYSCALL(exec)
 3e1:	b8 07 00 00 00       	mov    $0x7,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <open>:
SYSCALL(open)
 3e9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <mknod>:
SYSCALL(mknod)
 3f1:	b8 11 00 00 00       	mov    $0x11,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <unlink>:
SYSCALL(unlink)
 3f9:	b8 12 00 00 00       	mov    $0x12,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <fstat>:
SYSCALL(fstat)
 401:	b8 08 00 00 00       	mov    $0x8,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <link>:
SYSCALL(link)
 409:	b8 13 00 00 00       	mov    $0x13,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <mkdir>:
SYSCALL(mkdir)
 411:	b8 14 00 00 00       	mov    $0x14,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <chdir>:
SYSCALL(chdir)
 419:	b8 09 00 00 00       	mov    $0x9,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <dup>:
SYSCALL(dup)
 421:	b8 0a 00 00 00       	mov    $0xa,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <getpid>:
SYSCALL(getpid)
 429:	b8 0b 00 00 00       	mov    $0xb,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <sbrk>:
SYSCALL(sbrk)
 431:	b8 0c 00 00 00       	mov    $0xc,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <sleep>:
SYSCALL(sleep)
 439:	b8 0d 00 00 00       	mov    $0xd,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <uptime>:
SYSCALL(uptime)
 441:	b8 0e 00 00 00       	mov    $0xe,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <halt>:
SYSCALL(halt)
 449:	b8 16 00 00 00       	mov    $0x16,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <date>:
SYSCALL(date)
 451:	b8 17 00 00 00       	mov    $0x17,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <getuid>:
SYSCALL(getuid)
 459:	b8 18 00 00 00       	mov    $0x18,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <getgid>:
SYSCALL(getgid)
 461:	b8 19 00 00 00       	mov    $0x19,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <getppid>:
SYSCALL(getppid)
 469:	b8 1a 00 00 00       	mov    $0x1a,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <setuid>:
SYSCALL(setuid)
 471:	b8 1b 00 00 00       	mov    $0x1b,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <setgid>:
SYSCALL(setgid)
 479:	b8 1c 00 00 00       	mov    $0x1c,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <getprocs>:
SYSCALL(getprocs)
 481:	b8 1d 00 00 00       	mov    $0x1d,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <looper>:
SYSCALL(looper)
 489:	b8 1e 00 00 00       	mov    $0x1e,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <setpriority>:
SYSCALL(setpriority)
 491:	b8 1f 00 00 00       	mov    $0x1f,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <chmod>:
SYSCALL(chmod)
 499:	b8 20 00 00 00       	mov    $0x20,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <chown>:
SYSCALL(chown)
 4a1:	b8 21 00 00 00       	mov    $0x21,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <chgrp>:
SYSCALL(chgrp)
 4a9:	b8 22 00 00 00       	mov    $0x22,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4b1:	55                   	push   %ebp
 4b2:	89 e5                	mov    %esp,%ebp
 4b4:	83 ec 18             	sub    $0x18,%esp
 4b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4bd:	83 ec 04             	sub    $0x4,%esp
 4c0:	6a 01                	push   $0x1
 4c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c5:	50                   	push   %eax
 4c6:	ff 75 08             	pushl  0x8(%ebp)
 4c9:	e8 fb fe ff ff       	call   3c9 <write>
 4ce:	83 c4 10             	add    $0x10,%esp
}
 4d1:	90                   	nop
 4d2:	c9                   	leave  
 4d3:	c3                   	ret    

000004d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	53                   	push   %ebx
 4d8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4e2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e6:	74 17                	je     4ff <printint+0x2b>
 4e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ec:	79 11                	jns    4ff <printint+0x2b>
    neg = 1;
 4ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	f7 d8                	neg    %eax
 4fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fd:	eb 06                	jmp    505 <printint+0x31>
  } else {
    x = xx;
 4ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 502:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 50c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 50f:	8d 41 01             	lea    0x1(%ecx),%eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
 515:	8b 5d 10             	mov    0x10(%ebp),%ebx
 518:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51b:	ba 00 00 00 00       	mov    $0x0,%edx
 520:	f7 f3                	div    %ebx
 522:	89 d0                	mov    %edx,%eax
 524:	0f b6 80 b0 0b 00 00 	movzbl 0xbb0(%eax),%eax
 52b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 52f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 532:	8b 45 ec             	mov    -0x14(%ebp),%eax
 535:	ba 00 00 00 00       	mov    $0x0,%edx
 53a:	f7 f3                	div    %ebx
 53c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 543:	75 c7                	jne    50c <printint+0x38>
  if(neg)
 545:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 549:	74 2d                	je     578 <printint+0xa4>
    buf[i++] = '-';
 54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54e:	8d 50 01             	lea    0x1(%eax),%edx
 551:	89 55 f4             	mov    %edx,-0xc(%ebp)
 554:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 559:	eb 1d                	jmp    578 <printint+0xa4>
    putc(fd, buf[i]);
 55b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	01 d0                	add    %edx,%eax
 563:	0f b6 00             	movzbl (%eax),%eax
 566:	0f be c0             	movsbl %al,%eax
 569:	83 ec 08             	sub    $0x8,%esp
 56c:	50                   	push   %eax
 56d:	ff 75 08             	pushl  0x8(%ebp)
 570:	e8 3c ff ff ff       	call   4b1 <putc>
 575:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 578:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 57c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 580:	79 d9                	jns    55b <printint+0x87>
    putc(fd, buf[i]);
}
 582:	90                   	nop
 583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 586:	c9                   	leave  
 587:	c3                   	ret    

00000588 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 588:	55                   	push   %ebp
 589:	89 e5                	mov    %esp,%ebp
 58b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 58e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 595:	8d 45 0c             	lea    0xc(%ebp),%eax
 598:	83 c0 04             	add    $0x4,%eax
 59b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 59e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a5:	e9 59 01 00 00       	jmp    703 <printf+0x17b>
    c = fmt[i] & 0xff;
 5aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b0:	01 d0                	add    %edx,%eax
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	25 ff 00 00 00       	and    $0xff,%eax
 5bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c4:	75 2c                	jne    5f2 <printf+0x6a>
      if(c == '%'){
 5c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ca:	75 0c                	jne    5d8 <printf+0x50>
        state = '%';
 5cc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5d3:	e9 27 01 00 00       	jmp    6ff <printf+0x177>
      } else {
        putc(fd, c);
 5d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	83 ec 08             	sub    $0x8,%esp
 5e1:	50                   	push   %eax
 5e2:	ff 75 08             	pushl  0x8(%ebp)
 5e5:	e8 c7 fe ff ff       	call   4b1 <putc>
 5ea:	83 c4 10             	add    $0x10,%esp
 5ed:	e9 0d 01 00 00       	jmp    6ff <printf+0x177>
      }
    } else if(state == '%'){
 5f2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f6:	0f 85 03 01 00 00    	jne    6ff <printf+0x177>
      if(c == 'd'){
 5fc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 600:	75 1e                	jne    620 <printf+0x98>
        printint(fd, *ap, 10, 1);
 602:	8b 45 e8             	mov    -0x18(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	6a 01                	push   $0x1
 609:	6a 0a                	push   $0xa
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 c0 fe ff ff       	call   4d4 <printint>
 614:	83 c4 10             	add    $0x10,%esp
        ap++;
 617:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61b:	e9 d8 00 00 00       	jmp    6f8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 620:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 624:	74 06                	je     62c <printf+0xa4>
 626:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 62a:	75 1e                	jne    64a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 62c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	6a 00                	push   $0x0
 633:	6a 10                	push   $0x10
 635:	50                   	push   %eax
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 96 fe ff ff       	call   4d4 <printint>
 63e:	83 c4 10             	add    $0x10,%esp
        ap++;
 641:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 645:	e9 ae 00 00 00       	jmp    6f8 <printf+0x170>
      } else if(c == 's'){
 64a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 64e:	75 43                	jne    693 <printf+0x10b>
        s = (char*)*ap;
 650:	8b 45 e8             	mov    -0x18(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 658:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 65c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 660:	75 25                	jne    687 <printf+0xff>
          s = "(null)";
 662:	c7 45 f4 61 09 00 00 	movl   $0x961,-0xc(%ebp)
        while(*s != 0){
 669:	eb 1c                	jmp    687 <printf+0xff>
          putc(fd, *s);
 66b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66e:	0f b6 00             	movzbl (%eax),%eax
 671:	0f be c0             	movsbl %al,%eax
 674:	83 ec 08             	sub    $0x8,%esp
 677:	50                   	push   %eax
 678:	ff 75 08             	pushl  0x8(%ebp)
 67b:	e8 31 fe ff ff       	call   4b1 <putc>
 680:	83 c4 10             	add    $0x10,%esp
          s++;
 683:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 687:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68a:	0f b6 00             	movzbl (%eax),%eax
 68d:	84 c0                	test   %al,%al
 68f:	75 da                	jne    66b <printf+0xe3>
 691:	eb 65                	jmp    6f8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 693:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 697:	75 1d                	jne    6b6 <printf+0x12e>
        putc(fd, *ap);
 699:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	0f be c0             	movsbl %al,%eax
 6a1:	83 ec 08             	sub    $0x8,%esp
 6a4:	50                   	push   %eax
 6a5:	ff 75 08             	pushl  0x8(%ebp)
 6a8:	e8 04 fe ff ff       	call   4b1 <putc>
 6ad:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b4:	eb 42                	jmp    6f8 <printf+0x170>
      } else if(c == '%'){
 6b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ba:	75 17                	jne    6d3 <printf+0x14b>
        putc(fd, c);
 6bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bf:	0f be c0             	movsbl %al,%eax
 6c2:	83 ec 08             	sub    $0x8,%esp
 6c5:	50                   	push   %eax
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 e3 fd ff ff       	call   4b1 <putc>
 6ce:	83 c4 10             	add    $0x10,%esp
 6d1:	eb 25                	jmp    6f8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d3:	83 ec 08             	sub    $0x8,%esp
 6d6:	6a 25                	push   $0x25
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 d1 fd ff ff       	call   4b1 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e6:	0f be c0             	movsbl %al,%eax
 6e9:	83 ec 08             	sub    $0x8,%esp
 6ec:	50                   	push   %eax
 6ed:	ff 75 08             	pushl  0x8(%ebp)
 6f0:	e8 bc fd ff ff       	call   4b1 <putc>
 6f5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ff:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 703:	8b 55 0c             	mov    0xc(%ebp),%edx
 706:	8b 45 f0             	mov    -0x10(%ebp),%eax
 709:	01 d0                	add    %edx,%eax
 70b:	0f b6 00             	movzbl (%eax),%eax
 70e:	84 c0                	test   %al,%al
 710:	0f 85 94 fe ff ff    	jne    5aa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 716:	90                   	nop
 717:	c9                   	leave  
 718:	c3                   	ret    

00000719 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	83 e8 08             	sub    $0x8,%eax
 725:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 72d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 730:	eb 24                	jmp    756 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73a:	77 12                	ja     74e <free+0x35>
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 742:	77 24                	ja     768 <free+0x4f>
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74c:	77 1a                	ja     768 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	89 45 fc             	mov    %eax,-0x4(%ebp)
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75c:	76 d4                	jbe    732 <free+0x19>
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 766:	76 ca                	jbe    732 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	01 c2                	add    %eax,%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	39 c2                	cmp    %eax,%edx
 781:	75 24                	jne    7a7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 50 04             	mov    0x4(%eax),%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	01 c2                	add    %eax,%edx
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	8b 10                	mov    (%eax),%edx
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	89 10                	mov    %edx,(%eax)
 7a5:	eb 0a                	jmp    7b1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	01 d0                	add    %edx,%eax
 7c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c6:	75 20                	jne    7e8 <free+0xcf>
    p->s.size += bp->s.size;
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 50 04             	mov    0x4(%eax),%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	01 c2                	add    %eax,%edx
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	8b 10                	mov    (%eax),%edx
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	89 10                	mov    %edx,(%eax)
 7e6:	eb 08                	jmp    7f0 <free+0xd7>
  } else
    p->s.ptr = bp;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ee:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	a3 cc 0b 00 00       	mov    %eax,0xbcc
}
 7f8:	90                   	nop
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    

000007fb <morecore>:

static Header*
morecore(uint nu)
{
 7fb:	55                   	push   %ebp
 7fc:	89 e5                	mov    %esp,%ebp
 7fe:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 801:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 808:	77 07                	ja     811 <morecore+0x16>
    nu = 4096;
 80a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 811:	8b 45 08             	mov    0x8(%ebp),%eax
 814:	c1 e0 03             	shl    $0x3,%eax
 817:	83 ec 0c             	sub    $0xc,%esp
 81a:	50                   	push   %eax
 81b:	e8 11 fc ff ff       	call   431 <sbrk>
 820:	83 c4 10             	add    $0x10,%esp
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 826:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82a:	75 07                	jne    833 <morecore+0x38>
    return 0;
 82c:	b8 00 00 00 00       	mov    $0x0,%eax
 831:	eb 26                	jmp    859 <morecore+0x5e>
  hp = (Header*)p;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	8b 55 08             	mov    0x8(%ebp),%edx
 83f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	83 c0 08             	add    $0x8,%eax
 848:	83 ec 0c             	sub    $0xc,%esp
 84b:	50                   	push   %eax
 84c:	e8 c8 fe ff ff       	call   719 <free>
 851:	83 c4 10             	add    $0x10,%esp
  return freep;
 854:	a1 cc 0b 00 00       	mov    0xbcc,%eax
}
 859:	c9                   	leave  
 85a:	c3                   	ret    

0000085b <malloc>:

void*
malloc(uint nbytes)
{
 85b:	55                   	push   %ebp
 85c:	89 e5                	mov    %esp,%ebp
 85e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 861:	8b 45 08             	mov    0x8(%ebp),%eax
 864:	83 c0 07             	add    $0x7,%eax
 867:	c1 e8 03             	shr    $0x3,%eax
 86a:	83 c0 01             	add    $0x1,%eax
 86d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 870:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 875:	89 45 f0             	mov    %eax,-0x10(%ebp)
 878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 87c:	75 23                	jne    8a1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 87e:	c7 45 f0 c4 0b 00 00 	movl   $0xbc4,-0x10(%ebp)
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	a3 cc 0b 00 00       	mov    %eax,0xbcc
 88d:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 892:	a3 c4 0b 00 00       	mov    %eax,0xbc4
    base.s.size = 0;
 897:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 89e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b2:	72 4d                	jb     901 <malloc+0xa6>
      if(p->s.size == nunits)
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	8b 40 04             	mov    0x4(%eax),%eax
 8ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8bd:	75 0c                	jne    8cb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	8b 10                	mov    (%eax),%edx
 8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c7:	89 10                	mov    %edx,(%eax)
 8c9:	eb 26                	jmp    8f1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	8b 40 04             	mov    0x4(%eax),%eax
 8d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8d4:	89 c2                	mov    %eax,%edx
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	c1 e0 03             	shl    $0x3,%eax
 8e5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f4:	a3 cc 0b 00 00       	mov    %eax,0xbcc
      return (void*)(p + 1);
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	83 c0 08             	add    $0x8,%eax
 8ff:	eb 3b                	jmp    93c <malloc+0xe1>
    }
    if(p == freep)
 901:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 906:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 909:	75 1e                	jne    929 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 90b:	83 ec 0c             	sub    $0xc,%esp
 90e:	ff 75 ec             	pushl  -0x14(%ebp)
 911:	e8 e5 fe ff ff       	call   7fb <morecore>
 916:	83 c4 10             	add    $0x10,%esp
 919:	89 45 f4             	mov    %eax,-0xc(%ebp)
 91c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 920:	75 07                	jne    929 <malloc+0xce>
        return 0;
 922:	b8 00 00 00 00       	mov    $0x0,%eax
 927:	eb 13                	jmp    93c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	8b 00                	mov    (%eax),%eax
 934:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 937:	e9 6d ff ff ff       	jmp    8a9 <malloc+0x4e>
}
 93c:	c9                   	leave  
 93d:	c3                   	ret    
