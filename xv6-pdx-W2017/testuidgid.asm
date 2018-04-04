
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
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
   e:	83 ec 24             	sub    $0x24,%esp
        uint uid, gid, ppid = 0;
  11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int uidcatch, gidcatch;
        uid = getuid();
  18:	e8 1e 04 00 00       	call   43b <getuid>
  1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        printf(2, "Current UID is: %d \n", uid);
  20:	83 ec 04             	sub    $0x4,%esp
  23:	ff 75 f0             	pushl  -0x10(%ebp)
  26:	68 20 09 00 00       	push   $0x920
  2b:	6a 02                	push   $0x2
  2d:	e8 38 05 00 00       	call   56a <printf>
  32:	83 c4 10             	add    $0x10,%esp
        printf(2, "Setting UID to 100 \n");
  35:	83 ec 08             	sub    $0x8,%esp
  38:	68 35 09 00 00       	push   $0x935
  3d:	6a 02                	push   $0x2
  3f:	e8 26 05 00 00       	call   56a <printf>
  44:	83 c4 10             	add    $0x10,%esp
        uidcatch = setuid(100);
  47:	83 ec 0c             	sub    $0xc,%esp
  4a:	6a 64                	push   $0x64
  4c:	e8 02 04 00 00       	call   453 <setuid>
  51:	83 c4 10             	add    $0x10,%esp
  54:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(uidcatch == -1)
  57:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  5b:	75 12                	jne    6f <main+0x6f>
		printf(2, "ERROR: UID out of bounds. \n");
  5d:	83 ec 08             	sub    $0x8,%esp
  60:	68 4a 09 00 00       	push   $0x94a
  65:	6a 02                	push   $0x2
  67:	e8 fe 04 00 00       	call   56a <printf>
  6c:	83 c4 10             	add    $0x10,%esp
	uid = getuid();
  6f:	e8 c7 03 00 00       	call   43b <getuid>
  74:	89 45 f0             	mov    %eax,-0x10(%ebp)
        printf(2, "Current UID is: %d \n", uid);
  77:	83 ec 04             	sub    $0x4,%esp
  7a:	ff 75 f0             	pushl  -0x10(%ebp)
  7d:	68 20 09 00 00       	push   $0x920
  82:	6a 02                	push   $0x2
  84:	e8 e1 04 00 00       	call   56a <printf>
  89:	83 c4 10             	add    $0x10,%esp
        gid = getgid();
  8c:	e8 b2 03 00 00       	call   443 <getgid>
  91:	89 45 e8             	mov    %eax,-0x18(%ebp)
        printf(2, "Current GID is: %d \n", gid);
  94:	83 ec 04             	sub    $0x4,%esp
  97:	ff 75 e8             	pushl  -0x18(%ebp)
  9a:	68 66 09 00 00       	push   $0x966
  9f:	6a 02                	push   $0x2
  a1:	e8 c4 04 00 00       	call   56a <printf>
  a6:	83 c4 10             	add    $0x10,%esp
        printf(2, "Setting GID to 100 \n");
  a9:	83 ec 08             	sub    $0x8,%esp
  ac:	68 7b 09 00 00       	push   $0x97b
  b1:	6a 02                	push   $0x2
  b3:	e8 b2 04 00 00       	call   56a <printf>
  b8:	83 c4 10             	add    $0x10,%esp
        gidcatch = setgid(100);
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	6a 64                	push   $0x64
  c0:	e8 96 03 00 00       	call   45b <setgid>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(gidcatch == -1)
  cb:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  cf:	75 12                	jne    e3 <main+0xe3>
		printf(2, "ERROR: GID out of bounds. \n");
  d1:	83 ec 08             	sub    $0x8,%esp
  d4:	68 90 09 00 00       	push   $0x990
  d9:	6a 02                	push   $0x2
  db:	e8 8a 04 00 00       	call   56a <printf>
  e0:	83 c4 10             	add    $0x10,%esp
	gid = getgid();
  e3:	e8 5b 03 00 00       	call   443 <getgid>
  e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        printf(2, "Current UID is: %d \n", gid);
  eb:	83 ec 04             	sub    $0x4,%esp
  ee:	ff 75 e8             	pushl  -0x18(%ebp)
  f1:	68 20 09 00 00       	push   $0x920
  f6:	6a 02                	push   $0x2
  f8:	e8 6d 04 00 00       	call   56a <printf>
  fd:	83 c4 10             	add    $0x10,%esp
	ppid = getppid();
 100:	e8 46 03 00 00       	call   44b <getppid>
 105:	89 45 f4             	mov    %eax,-0xc(%ebp)
	printf(2,"My parent process is: %d \n", ppid);
 108:	83 ec 04             	sub    $0x4,%esp
 10b:	ff 75 f4             	pushl  -0xc(%ebp)
 10e:	68 ac 09 00 00       	push   $0x9ac
 113:	6a 02                	push   $0x2
 115:	e8 50 04 00 00       	call   56a <printf>
 11a:	83 c4 10             	add    $0x10,%esp
	printf(2, "Done! \n");
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	68 c7 09 00 00       	push   $0x9c7
 125:	6a 02                	push   $0x2
 127:	e8 3e 04 00 00       	call   56a <printf>
 12c:	83 c4 10             	add    $0x10,%esp
	exit();
 12f:	e8 57 02 00 00       	call   38b <exit>

00000134 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
 138:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 139:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13c:	8b 55 10             	mov    0x10(%ebp),%edx
 13f:	8b 45 0c             	mov    0xc(%ebp),%eax
 142:	89 cb                	mov    %ecx,%ebx
 144:	89 df                	mov    %ebx,%edi
 146:	89 d1                	mov    %edx,%ecx
 148:	fc                   	cld    
 149:	f3 aa                	rep stos %al,%es:(%edi)
 14b:	89 ca                	mov    %ecx,%edx
 14d:	89 fb                	mov    %edi,%ebx
 14f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 152:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 155:	90                   	nop
 156:	5b                   	pop    %ebx
 157:	5f                   	pop    %edi
 158:	5d                   	pop    %ebp
 159:	c3                   	ret    

0000015a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
 15d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 166:	90                   	nop
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8d 50 01             	lea    0x1(%eax),%edx
 16d:	89 55 08             	mov    %edx,0x8(%ebp)
 170:	8b 55 0c             	mov    0xc(%ebp),%edx
 173:	8d 4a 01             	lea    0x1(%edx),%ecx
 176:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 179:	0f b6 12             	movzbl (%edx),%edx
 17c:	88 10                	mov    %dl,(%eax)
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	84 c0                	test   %al,%al
 183:	75 e2                	jne    167 <strcpy+0xd>
    ;
  return os;
 185:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 18d:	eb 08                	jmp    197 <strcmp+0xd>
    p++, q++;
 18f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 193:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	84 c0                	test   %al,%al
 19f:	74 10                	je     1b1 <strcmp+0x27>
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
 1a4:	0f b6 10             	movzbl (%eax),%edx
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	38 c2                	cmp    %al,%dl
 1af:	74 de                	je     18f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 d0             	movzbl %al,%edx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	0f b6 c0             	movzbl %al,%eax
 1c3:	29 c2                	sub    %eax,%edx
 1c5:	89 d0                	mov    %edx,%eax
}
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    

000001c9 <strlen>:

uint
strlen(char *s)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1d6:	eb 04                	jmp    1dc <strlen+0x13>
 1d8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	0f b6 00             	movzbl (%eax),%eax
 1e7:	84 c0                	test   %al,%al
 1e9:	75 ed                	jne    1d8 <strlen+0xf>
    ;
  return n;
 1eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1f3:	8b 45 10             	mov    0x10(%ebp),%eax
 1f6:	50                   	push   %eax
 1f7:	ff 75 0c             	pushl  0xc(%ebp)
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 32 ff ff ff       	call   134 <stosb>
 202:	83 c4 0c             	add    $0xc,%esp
  return dst;
 205:	8b 45 08             	mov    0x8(%ebp),%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <strchr>:

char*
strchr(const char *s, char c)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 04             	sub    $0x4,%esp
 210:	8b 45 0c             	mov    0xc(%ebp),%eax
 213:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 216:	eb 14                	jmp    22c <strchr+0x22>
    if(*s == c)
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 221:	75 05                	jne    228 <strchr+0x1e>
      return (char*)s;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	eb 13                	jmp    23b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 228:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	0f b6 00             	movzbl (%eax),%eax
 232:	84 c0                	test   %al,%al
 234:	75 e2                	jne    218 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 236:	b8 00 00 00 00       	mov    $0x0,%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <gets>:

char*
gets(char *buf, int max)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 243:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 24a:	eb 42                	jmp    28e <gets+0x51>
    cc = read(0, &c, 1);
 24c:	83 ec 04             	sub    $0x4,%esp
 24f:	6a 01                	push   $0x1
 251:	8d 45 ef             	lea    -0x11(%ebp),%eax
 254:	50                   	push   %eax
 255:	6a 00                	push   $0x0
 257:	e8 47 01 00 00       	call   3a3 <read>
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 266:	7e 33                	jle    29b <gets+0x5e>
      break;
    buf[i++] = c;
 268:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26b:	8d 50 01             	lea    0x1(%eax),%edx
 26e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 271:	89 c2                	mov    %eax,%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	01 c2                	add    %eax,%edx
 278:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 27e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 282:	3c 0a                	cmp    $0xa,%al
 284:	74 16                	je     29c <gets+0x5f>
 286:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28a:	3c 0d                	cmp    $0xd,%al
 28c:	74 0e                	je     29c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 291:	83 c0 01             	add    $0x1,%eax
 294:	3b 45 0c             	cmp    0xc(%ebp),%eax
 297:	7c b3                	jl     24c <gets+0xf>
 299:	eb 01                	jmp    29c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 29b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 29c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <stat>:

int
stat(char *n, struct stat *st)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b2:	83 ec 08             	sub    $0x8,%esp
 2b5:	6a 00                	push   $0x0
 2b7:	ff 75 08             	pushl  0x8(%ebp)
 2ba:	e8 0c 01 00 00       	call   3cb <open>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c9:	79 07                	jns    2d2 <stat+0x26>
    return -1;
 2cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d0:	eb 25                	jmp    2f7 <stat+0x4b>
  r = fstat(fd, st);
 2d2:	83 ec 08             	sub    $0x8,%esp
 2d5:	ff 75 0c             	pushl  0xc(%ebp)
 2d8:	ff 75 f4             	pushl  -0xc(%ebp)
 2db:	e8 03 01 00 00       	call   3e3 <fstat>
 2e0:	83 c4 10             	add    $0x10,%esp
 2e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e6:	83 ec 0c             	sub    $0xc,%esp
 2e9:	ff 75 f4             	pushl  -0xc(%ebp)
 2ec:	e8 c2 00 00 00       	call   3b3 <close>
 2f1:	83 c4 10             	add    $0x10,%esp
  return r;
 2f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <atoi>:

int
atoi(const char *s)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 306:	eb 25                	jmp    32d <atoi+0x34>
    n = n*10 + *s++ - '0';
 308:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30b:	89 d0                	mov    %edx,%eax
 30d:	c1 e0 02             	shl    $0x2,%eax
 310:	01 d0                	add    %edx,%eax
 312:	01 c0                	add    %eax,%eax
 314:	89 c1                	mov    %eax,%ecx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	8d 50 01             	lea    0x1(%eax),%edx
 31c:	89 55 08             	mov    %edx,0x8(%ebp)
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	0f be c0             	movsbl %al,%eax
 325:	01 c8                	add    %ecx,%eax
 327:	83 e8 30             	sub    $0x30,%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 00             	movzbl (%eax),%eax
 333:	3c 2f                	cmp    $0x2f,%al
 335:	7e 0a                	jle    341 <atoi+0x48>
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	3c 39                	cmp    $0x39,%al
 33f:	7e c7                	jle    308 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 341:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 352:	8b 45 0c             	mov    0xc(%ebp),%eax
 355:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 358:	eb 17                	jmp    371 <memmove+0x2b>
    *dst++ = *src++;
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35d:	8d 50 01             	lea    0x1(%eax),%edx
 360:	89 55 fc             	mov    %edx,-0x4(%ebp)
 363:	8b 55 f8             	mov    -0x8(%ebp),%edx
 366:	8d 4a 01             	lea    0x1(%edx),%ecx
 369:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 36c:	0f b6 12             	movzbl (%edx),%edx
 36f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 371:	8b 45 10             	mov    0x10(%ebp),%eax
 374:	8d 50 ff             	lea    -0x1(%eax),%edx
 377:	89 55 10             	mov    %edx,0x10(%ebp)
 37a:	85 c0                	test   %eax,%eax
 37c:	7f dc                	jg     35a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 381:	c9                   	leave  
 382:	c3                   	ret    

00000383 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 383:	b8 01 00 00 00       	mov    $0x1,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <exit>:
SYSCALL(exit)
 38b:	b8 02 00 00 00       	mov    $0x2,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <wait>:
SYSCALL(wait)
 393:	b8 03 00 00 00       	mov    $0x3,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <pipe>:
SYSCALL(pipe)
 39b:	b8 04 00 00 00       	mov    $0x4,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <read>:
SYSCALL(read)
 3a3:	b8 05 00 00 00       	mov    $0x5,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <write>:
SYSCALL(write)
 3ab:	b8 10 00 00 00       	mov    $0x10,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <close>:
SYSCALL(close)
 3b3:	b8 15 00 00 00       	mov    $0x15,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <kill>:
SYSCALL(kill)
 3bb:	b8 06 00 00 00       	mov    $0x6,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <exec>:
SYSCALL(exec)
 3c3:	b8 07 00 00 00       	mov    $0x7,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <open>:
SYSCALL(open)
 3cb:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <mknod>:
SYSCALL(mknod)
 3d3:	b8 11 00 00 00       	mov    $0x11,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <unlink>:
SYSCALL(unlink)
 3db:	b8 12 00 00 00       	mov    $0x12,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <fstat>:
SYSCALL(fstat)
 3e3:	b8 08 00 00 00       	mov    $0x8,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <link>:
SYSCALL(link)
 3eb:	b8 13 00 00 00       	mov    $0x13,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <mkdir>:
SYSCALL(mkdir)
 3f3:	b8 14 00 00 00       	mov    $0x14,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <chdir>:
SYSCALL(chdir)
 3fb:	b8 09 00 00 00       	mov    $0x9,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <dup>:
SYSCALL(dup)
 403:	b8 0a 00 00 00       	mov    $0xa,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <getpid>:
SYSCALL(getpid)
 40b:	b8 0b 00 00 00       	mov    $0xb,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <sbrk>:
SYSCALL(sbrk)
 413:	b8 0c 00 00 00       	mov    $0xc,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <sleep>:
SYSCALL(sleep)
 41b:	b8 0d 00 00 00       	mov    $0xd,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <uptime>:
SYSCALL(uptime)
 423:	b8 0e 00 00 00       	mov    $0xe,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <halt>:
SYSCALL(halt)
 42b:	b8 16 00 00 00       	mov    $0x16,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <date>:
SYSCALL(date)
 433:	b8 17 00 00 00       	mov    $0x17,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <getuid>:
SYSCALL(getuid)
 43b:	b8 18 00 00 00       	mov    $0x18,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <getgid>:
SYSCALL(getgid)
 443:	b8 19 00 00 00       	mov    $0x19,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <getppid>:
SYSCALL(getppid)
 44b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <setuid>:
SYSCALL(setuid)
 453:	b8 1b 00 00 00       	mov    $0x1b,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <setgid>:
SYSCALL(setgid)
 45b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <getprocs>:
SYSCALL(getprocs)
 463:	b8 1d 00 00 00       	mov    $0x1d,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <looper>:
SYSCALL(looper)
 46b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <setpriority>:
SYSCALL(setpriority)
 473:	b8 1f 00 00 00       	mov    $0x1f,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <chmod>:
SYSCALL(chmod)
 47b:	b8 20 00 00 00       	mov    $0x20,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <chown>:
SYSCALL(chown)
 483:	b8 21 00 00 00       	mov    $0x21,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <chgrp>:
SYSCALL(chgrp)
 48b:	b8 22 00 00 00       	mov    $0x22,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 493:	55                   	push   %ebp
 494:	89 e5                	mov    %esp,%ebp
 496:	83 ec 18             	sub    $0x18,%esp
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 49f:	83 ec 04             	sub    $0x4,%esp
 4a2:	6a 01                	push   $0x1
 4a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 fb fe ff ff       	call   3ab <write>
 4b0:	83 c4 10             	add    $0x10,%esp
}
 4b3:	90                   	nop
 4b4:	c9                   	leave  
 4b5:	c3                   	ret    

000004b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b6:	55                   	push   %ebp
 4b7:	89 e5                	mov    %esp,%ebp
 4b9:	53                   	push   %ebx
 4ba:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c8:	74 17                	je     4e1 <printint+0x2b>
 4ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4ce:	79 11                	jns    4e1 <printint+0x2b>
    neg = 1;
 4d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4da:	f7 d8                	neg    %eax
 4dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4df:	eb 06                	jmp    4e7 <printint+0x31>
  } else {
    x = xx;
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4f1:	8d 41 01             	lea    0x1(%ecx),%eax
 4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fd:	ba 00 00 00 00       	mov    $0x0,%edx
 502:	f7 f3                	div    %ebx
 504:	89 d0                	mov    %edx,%eax
 506:	0f b6 80 20 0c 00 00 	movzbl 0xc20(%eax),%eax
 50d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 511:	8b 5d 10             	mov    0x10(%ebp),%ebx
 514:	8b 45 ec             	mov    -0x14(%ebp),%eax
 517:	ba 00 00 00 00       	mov    $0x0,%edx
 51c:	f7 f3                	div    %ebx
 51e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 525:	75 c7                	jne    4ee <printint+0x38>
  if(neg)
 527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52b:	74 2d                	je     55a <printint+0xa4>
    buf[i++] = '-';
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	8d 50 01             	lea    0x1(%eax),%edx
 533:	89 55 f4             	mov    %edx,-0xc(%ebp)
 536:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 53b:	eb 1d                	jmp    55a <printint+0xa4>
    putc(fd, buf[i]);
 53d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	01 d0                	add    %edx,%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	83 ec 08             	sub    $0x8,%esp
 54e:	50                   	push   %eax
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 3c ff ff ff       	call   493 <putc>
 557:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 55e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 562:	79 d9                	jns    53d <printint+0x87>
    putc(fd, buf[i]);
}
 564:	90                   	nop
 565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 568:	c9                   	leave  
 569:	c3                   	ret    

0000056a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56a:	55                   	push   %ebp
 56b:	89 e5                	mov    %esp,%ebp
 56d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 570:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 577:	8d 45 0c             	lea    0xc(%ebp),%eax
 57a:	83 c0 04             	add    $0x4,%eax
 57d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 580:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 587:	e9 59 01 00 00       	jmp    6e5 <printf+0x17b>
    c = fmt[i] & 0xff;
 58c:	8b 55 0c             	mov    0xc(%ebp),%edx
 58f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 592:	01 d0                	add    %edx,%eax
 594:	0f b6 00             	movzbl (%eax),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	25 ff 00 00 00       	and    $0xff,%eax
 59f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a6:	75 2c                	jne    5d4 <printf+0x6a>
      if(c == '%'){
 5a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ac:	75 0c                	jne    5ba <printf+0x50>
        state = '%';
 5ae:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b5:	e9 27 01 00 00       	jmp    6e1 <printf+0x177>
      } else {
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 c7 fe ff ff       	call   493 <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
 5cf:	e9 0d 01 00 00       	jmp    6e1 <printf+0x177>
      }
    } else if(state == '%'){
 5d4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d8:	0f 85 03 01 00 00    	jne    6e1 <printf+0x177>
      if(c == 'd'){
 5de:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e2:	75 1e                	jne    602 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	6a 01                	push   $0x1
 5eb:	6a 0a                	push   $0xa
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 c0 fe ff ff       	call   4b6 <printint>
 5f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	e9 d8 00 00 00       	jmp    6da <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 602:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 606:	74 06                	je     60e <printf+0xa4>
 608:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60c:	75 1e                	jne    62c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 60e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	6a 00                	push   $0x0
 615:	6a 10                	push   $0x10
 617:	50                   	push   %eax
 618:	ff 75 08             	pushl  0x8(%ebp)
 61b:	e8 96 fe ff ff       	call   4b6 <printint>
 620:	83 c4 10             	add    $0x10,%esp
        ap++;
 623:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 627:	e9 ae 00 00 00       	jmp    6da <printf+0x170>
      } else if(c == 's'){
 62c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 630:	75 43                	jne    675 <printf+0x10b>
        s = (char*)*ap;
 632:	8b 45 e8             	mov    -0x18(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 63e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 642:	75 25                	jne    669 <printf+0xff>
          s = "(null)";
 644:	c7 45 f4 cf 09 00 00 	movl   $0x9cf,-0xc(%ebp)
        while(*s != 0){
 64b:	eb 1c                	jmp    669 <printf+0xff>
          putc(fd, *s);
 64d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 650:	0f b6 00             	movzbl (%eax),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	83 ec 08             	sub    $0x8,%esp
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 31 fe ff ff       	call   493 <putc>
 662:	83 c4 10             	add    $0x10,%esp
          s++;
 665:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	84 c0                	test   %al,%al
 671:	75 da                	jne    64d <printf+0xe3>
 673:	eb 65                	jmp    6da <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 675:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 679:	75 1d                	jne    698 <printf+0x12e>
        putc(fd, *ap);
 67b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	0f be c0             	movsbl %al,%eax
 683:	83 ec 08             	sub    $0x8,%esp
 686:	50                   	push   %eax
 687:	ff 75 08             	pushl  0x8(%ebp)
 68a:	e8 04 fe ff ff       	call   493 <putc>
 68f:	83 c4 10             	add    $0x10,%esp
        ap++;
 692:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 696:	eb 42                	jmp    6da <printf+0x170>
      } else if(c == '%'){
 698:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 69c:	75 17                	jne    6b5 <printf+0x14b>
        putc(fd, c);
 69e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a1:	0f be c0             	movsbl %al,%eax
 6a4:	83 ec 08             	sub    $0x8,%esp
 6a7:	50                   	push   %eax
 6a8:	ff 75 08             	pushl  0x8(%ebp)
 6ab:	e8 e3 fd ff ff       	call   493 <putc>
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	eb 25                	jmp    6da <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b5:	83 ec 08             	sub    $0x8,%esp
 6b8:	6a 25                	push   $0x25
 6ba:	ff 75 08             	pushl  0x8(%ebp)
 6bd:	e8 d1 fd ff ff       	call   493 <putc>
 6c2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c8:	0f be c0             	movsbl %al,%eax
 6cb:	83 ec 08             	sub    $0x8,%esp
 6ce:	50                   	push   %eax
 6cf:	ff 75 08             	pushl  0x8(%ebp)
 6d2:	e8 bc fd ff ff       	call   493 <putc>
 6d7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6eb:	01 d0                	add    %edx,%eax
 6ed:	0f b6 00             	movzbl (%eax),%eax
 6f0:	84 c0                	test   %al,%al
 6f2:	0f 85 94 fe ff ff    	jne    58c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f8:	90                   	nop
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	83 e8 08             	sub    $0x8,%eax
 707:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 70f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 712:	eb 24                	jmp    738 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71c:	77 12                	ja     730 <free+0x35>
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 724:	77 24                	ja     74a <free+0x4f>
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72e:	77 1a                	ja     74a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	89 45 fc             	mov    %eax,-0x4(%ebp)
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73e:	76 d4                	jbe    714 <free+0x19>
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 748:	76 ca                	jbe    714 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	01 c2                	add    %eax,%edx
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	39 c2                	cmp    %eax,%edx
 763:	75 24                	jne    789 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 50 04             	mov    0x4(%eax),%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	01 c2                	add    %eax,%edx
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
 787:	eb 0a                	jmp    793 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	01 d0                	add    %edx,%eax
 7a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a8:	75 20                	jne    7ca <free+0xcf>
    p->s.size += bp->s.size;
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	01 c2                	add    %eax,%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	89 10                	mov    %edx,(%eax)
 7c8:	eb 08                	jmp    7d2 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	a3 3c 0c 00 00       	mov    %eax,0xc3c
}
 7da:	90                   	nop
 7db:	c9                   	leave  
 7dc:	c3                   	ret    

000007dd <morecore>:

static Header*
morecore(uint nu)
{
 7dd:	55                   	push   %ebp
 7de:	89 e5                	mov    %esp,%ebp
 7e0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ea:	77 07                	ja     7f3 <morecore+0x16>
    nu = 4096;
 7ec:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	c1 e0 03             	shl    $0x3,%eax
 7f9:	83 ec 0c             	sub    $0xc,%esp
 7fc:	50                   	push   %eax
 7fd:	e8 11 fc ff ff       	call   413 <sbrk>
 802:	83 c4 10             	add    $0x10,%esp
 805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 808:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 80c:	75 07                	jne    815 <morecore+0x38>
    return 0;
 80e:	b8 00 00 00 00       	mov    $0x0,%eax
 813:	eb 26                	jmp    83b <morecore+0x5e>
  hp = (Header*)p;
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	8b 55 08             	mov    0x8(%ebp),%edx
 821:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	83 c0 08             	add    $0x8,%eax
 82a:	83 ec 0c             	sub    $0xc,%esp
 82d:	50                   	push   %eax
 82e:	e8 c8 fe ff ff       	call   6fb <free>
 833:	83 c4 10             	add    $0x10,%esp
  return freep;
 836:	a1 3c 0c 00 00       	mov    0xc3c,%eax
}
 83b:	c9                   	leave  
 83c:	c3                   	ret    

0000083d <malloc>:

void*
malloc(uint nbytes)
{
 83d:	55                   	push   %ebp
 83e:	89 e5                	mov    %esp,%ebp
 840:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	83 c0 07             	add    $0x7,%eax
 849:	c1 e8 03             	shr    $0x3,%eax
 84c:	83 c0 01             	add    $0x1,%eax
 84f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 852:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 857:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85e:	75 23                	jne    883 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 860:	c7 45 f0 34 0c 00 00 	movl   $0xc34,-0x10(%ebp)
 867:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86a:	a3 3c 0c 00 00       	mov    %eax,0xc3c
 86f:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 874:	a3 34 0c 00 00       	mov    %eax,0xc34
    base.s.size = 0;
 879:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 880:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	8b 40 04             	mov    0x4(%eax),%eax
 891:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 894:	72 4d                	jb     8e3 <malloc+0xa6>
      if(p->s.size == nunits)
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89f:	75 0c                	jne    8ad <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 10                	mov    (%eax),%edx
 8a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a9:	89 10                	mov    %edx,(%eax)
 8ab:	eb 26                	jmp    8d3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b6:	89 c2                	mov    %eax,%edx
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	c1 e0 03             	shl    $0x3,%eax
 8c7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	a3 3c 0c 00 00       	mov    %eax,0xc3c
      return (void*)(p + 1);
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	83 c0 08             	add    $0x8,%eax
 8e1:	eb 3b                	jmp    91e <malloc+0xe1>
    }
    if(p == freep)
 8e3:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 8e8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8eb:	75 1e                	jne    90b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ed:	83 ec 0c             	sub    $0xc,%esp
 8f0:	ff 75 ec             	pushl  -0x14(%ebp)
 8f3:	e8 e5 fe ff ff       	call   7dd <morecore>
 8f8:	83 c4 10             	add    $0x10,%esp
 8fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 902:	75 07                	jne    90b <malloc+0xce>
        return 0;
 904:	b8 00 00 00 00       	mov    $0x0,%eax
 909:	eb 13                	jmp    91e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 00                	mov    (%eax),%eax
 916:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 919:	e9 6d ff ff ff       	jmp    88b <malloc+0x4e>
}
 91e:	c9                   	leave  
 91f:	c3                   	ret    
