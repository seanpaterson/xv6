
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <print_mode>:
#ifdef CS333_P5
// this is an ugly series of if statements but it works
void
print_mode(struct stat* st)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	0f b7 00             	movzwl (%eax),%eax
   c:	98                   	cwtl   
   d:	83 f8 02             	cmp    $0x2,%eax
  10:	74 1e                	je     30 <print_mode+0x30>
  12:	83 f8 03             	cmp    $0x3,%eax
  15:	74 2d                	je     44 <print_mode+0x44>
  17:	83 f8 01             	cmp    $0x1,%eax
  1a:	75 3c                	jne    58 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	68 24 0e 00 00       	push   $0xe24
  24:	6a 01                	push   $0x1
  26:	e8 43 0a 00 00       	call   a6e <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	eb 3a                	jmp    6a <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 26 0e 00 00       	push   $0xe26
  38:	6a 01                	push   $0x1
  3a:	e8 2f 0a 00 00       	call   a6e <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	eb 26                	jmp    6a <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 28 0e 00 00       	push   $0xe28
  4c:	6a 01                	push   $0x1
  4e:	e8 1b 0a 00 00       	call   a6e <printf>
  53:	83 c4 10             	add    $0x10,%esp
  56:	eb 12                	jmp    6a <print_mode+0x6a>
    default: printf(1, "?");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 2a 0e 00 00       	push   $0xe2a
  60:	6a 01                	push   $0x1
  62:	e8 07 0a 00 00       	call   a6e <printf>
  67:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	0f b6 40 1d          	movzbl 0x1d(%eax),%eax
  71:	83 e0 01             	and    $0x1,%eax
  74:	84 c0                	test   %al,%al
  76:	74 14                	je     8c <print_mode+0x8c>
    printf(1, "r");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 2c 0e 00 00       	push   $0xe2c
  80:	6a 01                	push   $0x1
  82:	e8 e7 09 00 00       	call   a6e <printf>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb 12                	jmp    9e <print_mode+0x9e>
  else
    printf(1, "-");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 26 0e 00 00       	push   $0xe26
  94:	6a 01                	push   $0x1
  96:	e8 d3 09 00 00       	call   a6e <printf>
  9b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
  a5:	83 e0 80             	and    $0xffffff80,%eax
  a8:	84 c0                	test   %al,%al
  aa:	74 14                	je     c0 <print_mode+0xc0>
    printf(1, "w");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 2e 0e 00 00       	push   $0xe2e
  b4:	6a 01                	push   $0x1
  b6:	e8 b3 09 00 00       	call   a6e <printf>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 12                	jmp    d2 <print_mode+0xd2>
  else
    printf(1, "-");
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 26 0e 00 00       	push   $0xe26
  c8:	6a 01                	push   $0x1
  ca:	e8 9f 09 00 00       	call   a6e <printf>
  cf:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
  d9:	c0 e8 06             	shr    $0x6,%al
  dc:	83 e0 01             	and    $0x1,%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 40 1d          	movzbl 0x1d(%eax),%eax
  e9:	d0 e8                	shr    %al
  eb:	83 e0 01             	and    $0x1,%eax
  ee:	0f b6 c0             	movzbl %al,%eax
  f1:	21 d0                	and    %edx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	74 14                	je     10b <print_mode+0x10b>
    printf(1, "S");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 30 0e 00 00       	push   $0xe30
  ff:	6a 01                	push   $0x1
 101:	e8 68 09 00 00       	call   a6e <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 34                	jmp    13f <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 112:	83 e0 40             	and    $0x40,%eax
 115:	84 c0                	test   %al,%al
 117:	74 14                	je     12d <print_mode+0x12d>
    printf(1, "x");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 32 0e 00 00       	push   $0xe32
 121:	6a 01                	push   $0x1
 123:	e8 46 09 00 00       	call   a6e <printf>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	eb 12                	jmp    13f <print_mode+0x13f>
  else
    printf(1, "-");
 12d:	83 ec 08             	sub    $0x8,%esp
 130:	68 26 0e 00 00       	push   $0xe26
 135:	6a 01                	push   $0x1
 137:	e8 32 09 00 00       	call   a6e <printf>
 13c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 146:	83 e0 20             	and    $0x20,%eax
 149:	84 c0                	test   %al,%al
 14b:	74 14                	je     161 <print_mode+0x161>
    printf(1, "r");
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	68 2c 0e 00 00       	push   $0xe2c
 155:	6a 01                	push   $0x1
 157:	e8 12 09 00 00       	call   a6e <printf>
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	eb 12                	jmp    173 <print_mode+0x173>
  else
    printf(1, "-");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 26 0e 00 00       	push   $0xe26
 169:	6a 01                	push   $0x1
 16b:	e8 fe 08 00 00       	call   a6e <printf>
 170:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 17a:	83 e0 10             	and    $0x10,%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 14                	je     195 <print_mode+0x195>
    printf(1, "w");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 2e 0e 00 00       	push   $0xe2e
 189:	6a 01                	push   $0x1
 18b:	e8 de 08 00 00       	call   a6e <printf>
 190:	83 c4 10             	add    $0x10,%esp
 193:	eb 12                	jmp    1a7 <print_mode+0x1a7>
  else
    printf(1, "-");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 26 0e 00 00       	push   $0xe26
 19d:	6a 01                	push   $0x1
 19f:	e8 ca 08 00 00       	call   a6e <printf>
 1a4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 1ae:	83 e0 08             	and    $0x8,%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 14                	je     1c9 <print_mode+0x1c9>
    printf(1, "x");
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	68 32 0e 00 00       	push   $0xe32
 1bd:	6a 01                	push   $0x1
 1bf:	e8 aa 08 00 00       	call   a6e <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 12                	jmp    1db <print_mode+0x1db>
  else
    printf(1, "-");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 26 0e 00 00       	push   $0xe26
 1d1:	6a 01                	push   $0x1
 1d3:	e8 96 08 00 00       	call   a6e <printf>
 1d8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 1e2:	83 e0 04             	and    $0x4,%eax
 1e5:	84 c0                	test   %al,%al
 1e7:	74 14                	je     1fd <print_mode+0x1fd>
    printf(1, "r");
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	68 2c 0e 00 00       	push   $0xe2c
 1f1:	6a 01                	push   $0x1
 1f3:	e8 76 08 00 00       	call   a6e <printf>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	eb 12                	jmp    20f <print_mode+0x20f>
  else
    printf(1, "-");
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	68 26 0e 00 00       	push   $0xe26
 205:	6a 01                	push   $0x1
 207:	e8 62 08 00 00       	call   a6e <printf>
 20c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 216:	83 e0 02             	and    $0x2,%eax
 219:	84 c0                	test   %al,%al
 21b:	74 14                	je     231 <print_mode+0x231>
    printf(1, "w");
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	68 2e 0e 00 00       	push   $0xe2e
 225:	6a 01                	push   $0x1
 227:	e8 42 08 00 00       	call   a6e <printf>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	eb 12                	jmp    243 <print_mode+0x243>
  else
    printf(1, "-");
 231:	83 ec 08             	sub    $0x8,%esp
 234:	68 26 0e 00 00       	push   $0xe26
 239:	6a 01                	push   $0x1
 23b:	e8 2e 08 00 00       	call   a6e <printf>
 240:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 24a:	83 e0 01             	and    $0x1,%eax
 24d:	84 c0                	test   %al,%al
 24f:	74 14                	je     265 <print_mode+0x265>
    printf(1, "x");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 32 0e 00 00       	push   $0xe32
 259:	6a 01                	push   $0x1
 25b:	e8 0e 08 00 00       	call   a6e <printf>
 260:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 263:	eb 13                	jmp    278 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 265:	83 ec 08             	sub    $0x8,%esp
 268:	68 26 0e 00 00       	push   $0xe26
 26d:	6a 01                	push   $0x1
 26f:	e8 fa 07 00 00       	call   a6e <printf>
 274:	83 c4 10             	add    $0x10,%esp

  return;
 277:	90                   	nop
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <fmtname>:
#include "fs.h"
#include "print_mode.c"

char*
fmtname(char *path)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	53                   	push   %ebx
 27e:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 41 04 00 00       	call   6cd <strlen>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 d0                	add    %edx,%eax
 296:	89 45 f4             	mov    %eax,-0xc(%ebp)
 299:	eb 04                	jmp    29f <fmtname+0x25>
 29b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a2:	3b 45 08             	cmp    0x8(%ebp),%eax
 2a5:	72 0a                	jb     2b1 <fmtname+0x37>
 2a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2f                	cmp    $0x2f,%al
 2af:	75 ea                	jne    29b <fmtname+0x21>
    ;
  p++;
 2b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	ff 75 f4             	pushl  -0xc(%ebp)
 2bb:	e8 0d 04 00 00       	call   6cd <strlen>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	83 f8 0d             	cmp    $0xd,%eax
 2c6:	76 05                	jbe    2cd <fmtname+0x53>
    return p;
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	eb 60                	jmp    32d <fmtname+0xb3>
  memmove(buf, p, strlen(p));
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	ff 75 f4             	pushl  -0xc(%ebp)
 2d3:	e8 f5 03 00 00       	call   6cd <strlen>
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	50                   	push   %eax
 2df:	ff 75 f4             	pushl  -0xc(%ebp)
 2e2:	68 a0 11 00 00       	push   $0x11a0
 2e7:	e8 5e 05 00 00       	call   84a <memmove>
 2ec:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 2ef:	83 ec 0c             	sub    $0xc,%esp
 2f2:	ff 75 f4             	pushl  -0xc(%ebp)
 2f5:	e8 d3 03 00 00       	call   6cd <strlen>
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	ba 0e 00 00 00       	mov    $0xe,%edx
 302:	89 d3                	mov    %edx,%ebx
 304:	29 c3                	sub    %eax,%ebx
 306:	83 ec 0c             	sub    $0xc,%esp
 309:	ff 75 f4             	pushl  -0xc(%ebp)
 30c:	e8 bc 03 00 00       	call   6cd <strlen>
 311:	83 c4 10             	add    $0x10,%esp
 314:	05 a0 11 00 00       	add    $0x11a0,%eax
 319:	83 ec 04             	sub    $0x4,%esp
 31c:	53                   	push   %ebx
 31d:	6a 20                	push   $0x20
 31f:	50                   	push   %eax
 320:	e8 cf 03 00 00       	call   6f4 <memset>
 325:	83 c4 10             	add    $0x10,%esp
  return buf;
 328:	b8 a0 11 00 00       	mov    $0x11a0,%eax
}
 32d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <ls>:

void
ls(char *path)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	57                   	push   %edi
 336:	56                   	push   %esi
 337:	53                   	push   %ebx
 338:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	6a 00                	push   $0x0
 343:	ff 75 08             	pushl  0x8(%ebp)
 346:	e8 84 05 00 00       	call   8cf <open>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 351:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 355:	79 1a                	jns    371 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
 357:	83 ec 04             	sub    $0x4,%esp
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	68 34 0e 00 00       	push   $0xe34
 362:	6a 02                	push   $0x2
 364:	e8 05 07 00 00       	call   a6e <printf>
 369:	83 c4 10             	add    $0x10,%esp
    return;
 36c:	e9 5b 02 00 00       	jmp    5cc <ls+0x29a>
  }
  
  if(fstat(fd, &st) < 0){
 371:	83 ec 08             	sub    $0x8,%esp
 374:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 37a:	50                   	push   %eax
 37b:	ff 75 e4             	pushl  -0x1c(%ebp)
 37e:	e8 64 05 00 00       	call   8e7 <fstat>
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	79 28                	jns    3b2 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 38a:	83 ec 04             	sub    $0x4,%esp
 38d:	ff 75 08             	pushl  0x8(%ebp)
 390:	68 48 0e 00 00       	push   $0xe48
 395:	6a 02                	push   $0x2
 397:	e8 d2 06 00 00       	call   a6e <printf>
 39c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 39f:	83 ec 0c             	sub    $0xc,%esp
 3a2:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a5:	e8 0d 05 00 00       	call   8b7 <close>
 3aa:	83 c4 10             	add    $0x10,%esp
    return;
 3ad:	e9 1a 02 00 00       	jmp    5cc <ls+0x29a>
  }
  #ifdef CS333_P5
  printf(2, "mode		name		type	uid	gid	inode	size \n");
 3b2:	83 ec 08             	sub    $0x8,%esp
 3b5:	68 5c 0e 00 00       	push   $0xe5c
 3ba:	6a 02                	push   $0x2
 3bc:	e8 ad 06 00 00       	call   a6e <printf>
 3c1:	83 c4 10             	add    $0x10,%esp
  #endif
  switch(st.type){
 3c4:	0f b7 85 b0 fd ff ff 	movzwl -0x250(%ebp),%eax
 3cb:	98                   	cwtl   
 3cc:	83 f8 01             	cmp    $0x1,%eax
 3cf:	74 7b                	je     44c <ls+0x11a>
 3d1:	83 f8 02             	cmp    $0x2,%eax
 3d4:	0f 85 e4 01 00 00    	jne    5be <ls+0x28c>
  case T_FILE:
    #ifdef CS333_P5
    print_mode(&st);
 3da:	83 ec 0c             	sub    $0xc,%esp
 3dd:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 3e3:	50                   	push   %eax
 3e4:	e8 17 fc ff ff       	call   0 <print_mode>
 3e9:	83 c4 10             	add    $0x10,%esp
        printf(1, "	%s	%d	%d	%d	%d	%d \n", fmtname(path), st.type, st.uid, st.gid, st.ino, st.size);
 3ec:	8b 85 c0 fd ff ff    	mov    -0x240(%ebp),%eax
 3f2:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 3f8:	8b 8d b8 fd ff ff    	mov    -0x248(%ebp),%ecx
 3fe:	89 8d a0 fd ff ff    	mov    %ecx,-0x260(%ebp)
 404:	8b bd c8 fd ff ff    	mov    -0x238(%ebp),%edi
 40a:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 410:	0f b7 85 b0 fd ff ff 	movzwl -0x250(%ebp),%eax
 417:	0f bf d8             	movswl %ax,%ebx
 41a:	83 ec 0c             	sub    $0xc,%esp
 41d:	ff 75 08             	pushl  0x8(%ebp)
 420:	e8 55 fe ff ff       	call   27a <fmtname>
 425:	83 c4 10             	add    $0x10,%esp
 428:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 42e:	ff b5 a0 fd ff ff    	pushl  -0x260(%ebp)
 434:	57                   	push   %edi
 435:	56                   	push   %esi
 436:	53                   	push   %ebx
 437:	50                   	push   %eax
 438:	68 82 0e 00 00       	push   $0xe82
 43d:	6a 01                	push   $0x1
 43f:	e8 2a 06 00 00       	call   a6e <printf>
 444:	83 c4 20             	add    $0x20,%esp
    #else
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    #endif
    break;
 447:	e9 72 01 00 00       	jmp    5be <ls+0x28c>
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 44c:	83 ec 0c             	sub    $0xc,%esp
 44f:	ff 75 08             	pushl  0x8(%ebp)
 452:	e8 76 02 00 00       	call   6cd <strlen>
 457:	83 c4 10             	add    $0x10,%esp
 45a:	83 c0 10             	add    $0x10,%eax
 45d:	3d 00 02 00 00       	cmp    $0x200,%eax
 462:	76 17                	jbe    47b <ls+0x149>
      printf(1, "ls: path too long\n");
 464:	83 ec 08             	sub    $0x8,%esp
 467:	68 97 0e 00 00       	push   $0xe97
 46c:	6a 01                	push   $0x1
 46e:	e8 fb 05 00 00       	call   a6e <printf>
 473:	83 c4 10             	add    $0x10,%esp
      break;
 476:	e9 43 01 00 00       	jmp    5be <ls+0x28c>
    }
    strcpy(buf, path);
 47b:	83 ec 08             	sub    $0x8,%esp
 47e:	ff 75 08             	pushl  0x8(%ebp)
 481:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 487:	50                   	push   %eax
 488:	e8 d1 01 00 00       	call   65e <strcpy>
 48d:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 490:	83 ec 0c             	sub    $0xc,%esp
 493:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 499:	50                   	push   %eax
 49a:	e8 2e 02 00 00       	call   6cd <strlen>
 49f:	83 c4 10             	add    $0x10,%esp
 4a2:	89 c2                	mov    %eax,%edx
 4a4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 4af:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4b2:	8d 50 01             	lea    0x1(%eax),%edx
 4b5:	89 55 e0             	mov    %edx,-0x20(%ebp)
 4b8:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 4bb:	e9 dd 00 00 00       	jmp    59d <ls+0x26b>
      if(de.inum == 0)
 4c0:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 4c7:	66 85 c0             	test   %ax,%ax
 4ca:	75 05                	jne    4d1 <ls+0x19f>
        continue;
 4cc:	e9 cc 00 00 00       	jmp    59d <ls+0x26b>
      memmove(p, de.name, DIRSIZ);
 4d1:	83 ec 04             	sub    $0x4,%esp
 4d4:	6a 0e                	push   $0xe
 4d6:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 4dc:	83 c0 02             	add    $0x2,%eax
 4df:	50                   	push   %eax
 4e0:	ff 75 e0             	pushl  -0x20(%ebp)
 4e3:	e8 62 03 00 00       	call   84a <memmove>
 4e8:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 4eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4ee:	83 c0 0e             	add    $0xe,%eax
 4f1:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 4f4:	83 ec 08             	sub    $0x8,%esp
 4f7:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 4fd:	50                   	push   %eax
 4fe:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 504:	50                   	push   %eax
 505:	e8 a6 02 00 00       	call   7b0 <stat>
 50a:	83 c4 10             	add    $0x10,%esp
 50d:	85 c0                	test   %eax,%eax
 50f:	79 1b                	jns    52c <ls+0x1fa>
        printf(1, "ls: cannot stat %s\n", buf);
 511:	83 ec 04             	sub    $0x4,%esp
 514:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 51a:	50                   	push   %eax
 51b:	68 48 0e 00 00       	push   $0xe48
 520:	6a 01                	push   $0x1
 522:	e8 47 05 00 00       	call   a6e <printf>
 527:	83 c4 10             	add    $0x10,%esp
        continue;
 52a:	eb 71                	jmp    59d <ls+0x26b>
      }
      #ifdef CS333_P5
      print_mode(&st);
 52c:	83 ec 0c             	sub    $0xc,%esp
 52f:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 535:	50                   	push   %eax
 536:	e8 c5 fa ff ff       	call   0 <print_mode>
 53b:	83 c4 10             	add    $0x10,%esp
      printf(1, "	%s	%d 	%d 	%d 	%d 	%d \n", fmtname(buf), st.type, st.uid, st.gid, st.ino, st.size);
 53e:	8b 85 c0 fd ff ff    	mov    -0x240(%ebp),%eax
 544:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 54a:	8b 8d b8 fd ff ff    	mov    -0x248(%ebp),%ecx
 550:	89 8d a0 fd ff ff    	mov    %ecx,-0x260(%ebp)
 556:	8b bd c8 fd ff ff    	mov    -0x238(%ebp),%edi
 55c:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 562:	0f b7 85 b0 fd ff ff 	movzwl -0x250(%ebp),%eax
 569:	0f bf d8             	movswl %ax,%ebx
 56c:	83 ec 0c             	sub    $0xc,%esp
 56f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 575:	50                   	push   %eax
 576:	e8 ff fc ff ff       	call   27a <fmtname>
 57b:	83 c4 10             	add    $0x10,%esp
 57e:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 584:	ff b5 a0 fd ff ff    	pushl  -0x260(%ebp)
 58a:	57                   	push   %edi
 58b:	56                   	push   %esi
 58c:	53                   	push   %ebx
 58d:	50                   	push   %eax
 58e:	68 aa 0e 00 00       	push   $0xeaa
 593:	6a 01                	push   $0x1
 595:	e8 d4 04 00 00       	call   a6e <printf>
 59a:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 59d:	83 ec 04             	sub    $0x4,%esp
 5a0:	6a 10                	push   $0x10
 5a2:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 5a8:	50                   	push   %eax
 5a9:	ff 75 e4             	pushl  -0x1c(%ebp)
 5ac:	e8 f6 02 00 00       	call   8a7 <read>
 5b1:	83 c4 10             	add    $0x10,%esp
 5b4:	83 f8 10             	cmp    $0x10,%eax
 5b7:	0f 84 03 ff ff ff    	je     4c0 <ls+0x18e>
      printf(1, "	%s	%d 	%d 	%d 	%d 	%d \n", fmtname(buf), st.type, st.uid, st.gid, st.ino, st.size);
      #else
      printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
      #endif
    }
    break;
 5bd:	90                   	nop
  }
  close(fd);
 5be:	83 ec 0c             	sub    $0xc,%esp
 5c1:	ff 75 e4             	pushl  -0x1c(%ebp)
 5c4:	e8 ee 02 00 00       	call   8b7 <close>
 5c9:	83 c4 10             	add    $0x10,%esp
}
 5cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    

000005d4 <main>:

int
main(int argc, char *argv[])
{
 5d4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 5d8:	83 e4 f0             	and    $0xfffffff0,%esp
 5db:	ff 71 fc             	pushl  -0x4(%ecx)
 5de:	55                   	push   %ebp
 5df:	89 e5                	mov    %esp,%ebp
 5e1:	53                   	push   %ebx
 5e2:	51                   	push   %ecx
 5e3:	83 ec 10             	sub    $0x10,%esp
 5e6:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 5e8:	83 3b 01             	cmpl   $0x1,(%ebx)
 5eb:	7f 15                	jg     602 <main+0x2e>
    ls(".");
 5ed:	83 ec 0c             	sub    $0xc,%esp
 5f0:	68 c3 0e 00 00       	push   $0xec3
 5f5:	e8 38 fd ff ff       	call   332 <ls>
 5fa:	83 c4 10             	add    $0x10,%esp
    exit();
 5fd:	e8 8d 02 00 00       	call   88f <exit>
  }
  for(i=1; i<argc; i++)
 602:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 609:	eb 21                	jmp    62c <main+0x58>
    ls(argv[i]);
 60b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 615:	8b 43 04             	mov    0x4(%ebx),%eax
 618:	01 d0                	add    %edx,%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	83 ec 0c             	sub    $0xc,%esp
 61f:	50                   	push   %eax
 620:	e8 0d fd ff ff       	call   332 <ls>
 625:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 628:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 62c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62f:	3b 03                	cmp    (%ebx),%eax
 631:	7c d8                	jl     60b <main+0x37>
    ls(argv[i]);
  exit();
 633:	e8 57 02 00 00       	call   88f <exit>

00000638 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	57                   	push   %edi
 63c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 63d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 640:	8b 55 10             	mov    0x10(%ebp),%edx
 643:	8b 45 0c             	mov    0xc(%ebp),%eax
 646:	89 cb                	mov    %ecx,%ebx
 648:	89 df                	mov    %ebx,%edi
 64a:	89 d1                	mov    %edx,%ecx
 64c:	fc                   	cld    
 64d:	f3 aa                	rep stos %al,%es:(%edi)
 64f:	89 ca                	mov    %ecx,%edx
 651:	89 fb                	mov    %edi,%ebx
 653:	89 5d 08             	mov    %ebx,0x8(%ebp)
 656:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 659:	90                   	nop
 65a:	5b                   	pop    %ebx
 65b:	5f                   	pop    %edi
 65c:	5d                   	pop    %ebp
 65d:	c3                   	ret    

0000065e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 65e:	55                   	push   %ebp
 65f:	89 e5                	mov    %esp,%ebp
 661:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 66a:	90                   	nop
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	8d 50 01             	lea    0x1(%eax),%edx
 671:	89 55 08             	mov    %edx,0x8(%ebp)
 674:	8b 55 0c             	mov    0xc(%ebp),%edx
 677:	8d 4a 01             	lea    0x1(%edx),%ecx
 67a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 67d:	0f b6 12             	movzbl (%edx),%edx
 680:	88 10                	mov    %dl,(%eax)
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	84 c0                	test   %al,%al
 687:	75 e2                	jne    66b <strcpy+0xd>
    ;
  return os;
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 68c:	c9                   	leave  
 68d:	c3                   	ret    

0000068e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 68e:	55                   	push   %ebp
 68f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 691:	eb 08                	jmp    69b <strcmp+0xd>
    p++, q++;
 693:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 697:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 69b:	8b 45 08             	mov    0x8(%ebp),%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	84 c0                	test   %al,%al
 6a3:	74 10                	je     6b5 <strcmp+0x27>
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	0f b6 10             	movzbl (%eax),%edx
 6ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ae:	0f b6 00             	movzbl (%eax),%eax
 6b1:	38 c2                	cmp    %al,%dl
 6b3:	74 de                	je     693 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	0f b6 d0             	movzbl %al,%edx
 6be:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c1:	0f b6 00             	movzbl (%eax),%eax
 6c4:	0f b6 c0             	movzbl %al,%eax
 6c7:	29 c2                	sub    %eax,%edx
 6c9:	89 d0                	mov    %edx,%eax
}
 6cb:	5d                   	pop    %ebp
 6cc:	c3                   	ret    

000006cd <strlen>:

uint
strlen(char *s)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6da:	eb 04                	jmp    6e0 <strlen+0x13>
 6dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	01 d0                	add    %edx,%eax
 6e8:	0f b6 00             	movzbl (%eax),%eax
 6eb:	84 c0                	test   %al,%al
 6ed:	75 ed                	jne    6dc <strlen+0xf>
    ;
  return n;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6f2:	c9                   	leave  
 6f3:	c3                   	ret    

000006f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6f7:	8b 45 10             	mov    0x10(%ebp),%eax
 6fa:	50                   	push   %eax
 6fb:	ff 75 0c             	pushl  0xc(%ebp)
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 32 ff ff ff       	call   638 <stosb>
 706:	83 c4 0c             	add    $0xc,%esp
  return dst;
 709:	8b 45 08             	mov    0x8(%ebp),%eax
}
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <strchr>:

char*
strchr(const char *s, char c)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 04             	sub    $0x4,%esp
 714:	8b 45 0c             	mov    0xc(%ebp),%eax
 717:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 71a:	eb 14                	jmp    730 <strchr+0x22>
    if(*s == c)
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	0f b6 00             	movzbl (%eax),%eax
 722:	3a 45 fc             	cmp    -0x4(%ebp),%al
 725:	75 05                	jne    72c <strchr+0x1e>
      return (char*)s;
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	eb 13                	jmp    73f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 72c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	0f b6 00             	movzbl (%eax),%eax
 736:	84 c0                	test   %al,%al
 738:	75 e2                	jne    71c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 73a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 73f:	c9                   	leave  
 740:	c3                   	ret    

00000741 <gets>:

char*
gets(char *buf, int max)
{
 741:	55                   	push   %ebp
 742:	89 e5                	mov    %esp,%ebp
 744:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 74e:	eb 42                	jmp    792 <gets+0x51>
    cc = read(0, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	6a 01                	push   $0x1
 755:	8d 45 ef             	lea    -0x11(%ebp),%eax
 758:	50                   	push   %eax
 759:	6a 00                	push   $0x0
 75b:	e8 47 01 00 00       	call   8a7 <read>
 760:	83 c4 10             	add    $0x10,%esp
 763:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76a:	7e 33                	jle    79f <gets+0x5e>
      break;
    buf[i++] = c;
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8d 50 01             	lea    0x1(%eax),%edx
 772:	89 55 f4             	mov    %edx,-0xc(%ebp)
 775:	89 c2                	mov    %eax,%edx
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	01 c2                	add    %eax,%edx
 77c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 780:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 782:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 786:	3c 0a                	cmp    $0xa,%al
 788:	74 16                	je     7a0 <gets+0x5f>
 78a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 78e:	3c 0d                	cmp    $0xd,%al
 790:	74 0e                	je     7a0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	83 c0 01             	add    $0x1,%eax
 798:	3b 45 0c             	cmp    0xc(%ebp),%eax
 79b:	7c b3                	jl     750 <gets+0xf>
 79d:	eb 01                	jmp    7a0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 79f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	01 d0                	add    %edx,%eax
 7a8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7ae:	c9                   	leave  
 7af:	c3                   	ret    

000007b0 <stat>:

int
stat(char *n, struct stat *st)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7b6:	83 ec 08             	sub    $0x8,%esp
 7b9:	6a 00                	push   $0x0
 7bb:	ff 75 08             	pushl  0x8(%ebp)
 7be:	e8 0c 01 00 00       	call   8cf <open>
 7c3:	83 c4 10             	add    $0x10,%esp
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7cd:	79 07                	jns    7d6 <stat+0x26>
    return -1;
 7cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7d4:	eb 25                	jmp    7fb <stat+0x4b>
  r = fstat(fd, st);
 7d6:	83 ec 08             	sub    $0x8,%esp
 7d9:	ff 75 0c             	pushl  0xc(%ebp)
 7dc:	ff 75 f4             	pushl  -0xc(%ebp)
 7df:	e8 03 01 00 00       	call   8e7 <fstat>
 7e4:	83 c4 10             	add    $0x10,%esp
 7e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7ea:	83 ec 0c             	sub    $0xc,%esp
 7ed:	ff 75 f4             	pushl  -0xc(%ebp)
 7f0:	e8 c2 00 00 00       	call   8b7 <close>
 7f5:	83 c4 10             	add    $0x10,%esp
  return r;
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7fb:	c9                   	leave  
 7fc:	c3                   	ret    

000007fd <atoi>:

int
atoi(const char *s)
{
 7fd:	55                   	push   %ebp
 7fe:	89 e5                	mov    %esp,%ebp
 800:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 803:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 80a:	eb 25                	jmp    831 <atoi+0x34>
    n = n*10 + *s++ - '0';
 80c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 80f:	89 d0                	mov    %edx,%eax
 811:	c1 e0 02             	shl    $0x2,%eax
 814:	01 d0                	add    %edx,%eax
 816:	01 c0                	add    %eax,%eax
 818:	89 c1                	mov    %eax,%ecx
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	8d 50 01             	lea    0x1(%eax),%edx
 820:	89 55 08             	mov    %edx,0x8(%ebp)
 823:	0f b6 00             	movzbl (%eax),%eax
 826:	0f be c0             	movsbl %al,%eax
 829:	01 c8                	add    %ecx,%eax
 82b:	83 e8 30             	sub    $0x30,%eax
 82e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 831:	8b 45 08             	mov    0x8(%ebp),%eax
 834:	0f b6 00             	movzbl (%eax),%eax
 837:	3c 2f                	cmp    $0x2f,%al
 839:	7e 0a                	jle    845 <atoi+0x48>
 83b:	8b 45 08             	mov    0x8(%ebp),%eax
 83e:	0f b6 00             	movzbl (%eax),%eax
 841:	3c 39                	cmp    $0x39,%al
 843:	7e c7                	jle    80c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 848:	c9                   	leave  
 849:	c3                   	ret    

0000084a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 84a:	55                   	push   %ebp
 84b:	89 e5                	mov    %esp,%ebp
 84d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 856:	8b 45 0c             	mov    0xc(%ebp),%eax
 859:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 85c:	eb 17                	jmp    875 <memmove+0x2b>
    *dst++ = *src++;
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8d 50 01             	lea    0x1(%eax),%edx
 864:	89 55 fc             	mov    %edx,-0x4(%ebp)
 867:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86a:	8d 4a 01             	lea    0x1(%edx),%ecx
 86d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 870:	0f b6 12             	movzbl (%edx),%edx
 873:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 875:	8b 45 10             	mov    0x10(%ebp),%eax
 878:	8d 50 ff             	lea    -0x1(%eax),%edx
 87b:	89 55 10             	mov    %edx,0x10(%ebp)
 87e:	85 c0                	test   %eax,%eax
 880:	7f dc                	jg     85e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 882:	8b 45 08             	mov    0x8(%ebp),%eax
}
 885:	c9                   	leave  
 886:	c3                   	ret    

00000887 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 887:	b8 01 00 00 00       	mov    $0x1,%eax
 88c:	cd 40                	int    $0x40
 88e:	c3                   	ret    

0000088f <exit>:
SYSCALL(exit)
 88f:	b8 02 00 00 00       	mov    $0x2,%eax
 894:	cd 40                	int    $0x40
 896:	c3                   	ret    

00000897 <wait>:
SYSCALL(wait)
 897:	b8 03 00 00 00       	mov    $0x3,%eax
 89c:	cd 40                	int    $0x40
 89e:	c3                   	ret    

0000089f <pipe>:
SYSCALL(pipe)
 89f:	b8 04 00 00 00       	mov    $0x4,%eax
 8a4:	cd 40                	int    $0x40
 8a6:	c3                   	ret    

000008a7 <read>:
SYSCALL(read)
 8a7:	b8 05 00 00 00       	mov    $0x5,%eax
 8ac:	cd 40                	int    $0x40
 8ae:	c3                   	ret    

000008af <write>:
SYSCALL(write)
 8af:	b8 10 00 00 00       	mov    $0x10,%eax
 8b4:	cd 40                	int    $0x40
 8b6:	c3                   	ret    

000008b7 <close>:
SYSCALL(close)
 8b7:	b8 15 00 00 00       	mov    $0x15,%eax
 8bc:	cd 40                	int    $0x40
 8be:	c3                   	ret    

000008bf <kill>:
SYSCALL(kill)
 8bf:	b8 06 00 00 00       	mov    $0x6,%eax
 8c4:	cd 40                	int    $0x40
 8c6:	c3                   	ret    

000008c7 <exec>:
SYSCALL(exec)
 8c7:	b8 07 00 00 00       	mov    $0x7,%eax
 8cc:	cd 40                	int    $0x40
 8ce:	c3                   	ret    

000008cf <open>:
SYSCALL(open)
 8cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 8d4:	cd 40                	int    $0x40
 8d6:	c3                   	ret    

000008d7 <mknod>:
SYSCALL(mknod)
 8d7:	b8 11 00 00 00       	mov    $0x11,%eax
 8dc:	cd 40                	int    $0x40
 8de:	c3                   	ret    

000008df <unlink>:
SYSCALL(unlink)
 8df:	b8 12 00 00 00       	mov    $0x12,%eax
 8e4:	cd 40                	int    $0x40
 8e6:	c3                   	ret    

000008e7 <fstat>:
SYSCALL(fstat)
 8e7:	b8 08 00 00 00       	mov    $0x8,%eax
 8ec:	cd 40                	int    $0x40
 8ee:	c3                   	ret    

000008ef <link>:
SYSCALL(link)
 8ef:	b8 13 00 00 00       	mov    $0x13,%eax
 8f4:	cd 40                	int    $0x40
 8f6:	c3                   	ret    

000008f7 <mkdir>:
SYSCALL(mkdir)
 8f7:	b8 14 00 00 00       	mov    $0x14,%eax
 8fc:	cd 40                	int    $0x40
 8fe:	c3                   	ret    

000008ff <chdir>:
SYSCALL(chdir)
 8ff:	b8 09 00 00 00       	mov    $0x9,%eax
 904:	cd 40                	int    $0x40
 906:	c3                   	ret    

00000907 <dup>:
SYSCALL(dup)
 907:	b8 0a 00 00 00       	mov    $0xa,%eax
 90c:	cd 40                	int    $0x40
 90e:	c3                   	ret    

0000090f <getpid>:
SYSCALL(getpid)
 90f:	b8 0b 00 00 00       	mov    $0xb,%eax
 914:	cd 40                	int    $0x40
 916:	c3                   	ret    

00000917 <sbrk>:
SYSCALL(sbrk)
 917:	b8 0c 00 00 00       	mov    $0xc,%eax
 91c:	cd 40                	int    $0x40
 91e:	c3                   	ret    

0000091f <sleep>:
SYSCALL(sleep)
 91f:	b8 0d 00 00 00       	mov    $0xd,%eax
 924:	cd 40                	int    $0x40
 926:	c3                   	ret    

00000927 <uptime>:
SYSCALL(uptime)
 927:	b8 0e 00 00 00       	mov    $0xe,%eax
 92c:	cd 40                	int    $0x40
 92e:	c3                   	ret    

0000092f <halt>:
SYSCALL(halt)
 92f:	b8 16 00 00 00       	mov    $0x16,%eax
 934:	cd 40                	int    $0x40
 936:	c3                   	ret    

00000937 <date>:
SYSCALL(date)
 937:	b8 17 00 00 00       	mov    $0x17,%eax
 93c:	cd 40                	int    $0x40
 93e:	c3                   	ret    

0000093f <getuid>:
SYSCALL(getuid)
 93f:	b8 18 00 00 00       	mov    $0x18,%eax
 944:	cd 40                	int    $0x40
 946:	c3                   	ret    

00000947 <getgid>:
SYSCALL(getgid)
 947:	b8 19 00 00 00       	mov    $0x19,%eax
 94c:	cd 40                	int    $0x40
 94e:	c3                   	ret    

0000094f <getppid>:
SYSCALL(getppid)
 94f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 954:	cd 40                	int    $0x40
 956:	c3                   	ret    

00000957 <setuid>:
SYSCALL(setuid)
 957:	b8 1b 00 00 00       	mov    $0x1b,%eax
 95c:	cd 40                	int    $0x40
 95e:	c3                   	ret    

0000095f <setgid>:
SYSCALL(setgid)
 95f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 964:	cd 40                	int    $0x40
 966:	c3                   	ret    

00000967 <getprocs>:
SYSCALL(getprocs)
 967:	b8 1d 00 00 00       	mov    $0x1d,%eax
 96c:	cd 40                	int    $0x40
 96e:	c3                   	ret    

0000096f <looper>:
SYSCALL(looper)
 96f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 974:	cd 40                	int    $0x40
 976:	c3                   	ret    

00000977 <setpriority>:
SYSCALL(setpriority)
 977:	b8 1f 00 00 00       	mov    $0x1f,%eax
 97c:	cd 40                	int    $0x40
 97e:	c3                   	ret    

0000097f <chmod>:
SYSCALL(chmod)
 97f:	b8 20 00 00 00       	mov    $0x20,%eax
 984:	cd 40                	int    $0x40
 986:	c3                   	ret    

00000987 <chown>:
SYSCALL(chown)
 987:	b8 21 00 00 00       	mov    $0x21,%eax
 98c:	cd 40                	int    $0x40
 98e:	c3                   	ret    

0000098f <chgrp>:
SYSCALL(chgrp)
 98f:	b8 22 00 00 00       	mov    $0x22,%eax
 994:	cd 40                	int    $0x40
 996:	c3                   	ret    

00000997 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 997:	55                   	push   %ebp
 998:	89 e5                	mov    %esp,%ebp
 99a:	83 ec 18             	sub    $0x18,%esp
 99d:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9a3:	83 ec 04             	sub    $0x4,%esp
 9a6:	6a 01                	push   $0x1
 9a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9ab:	50                   	push   %eax
 9ac:	ff 75 08             	pushl  0x8(%ebp)
 9af:	e8 fb fe ff ff       	call   8af <write>
 9b4:	83 c4 10             	add    $0x10,%esp
}
 9b7:	90                   	nop
 9b8:	c9                   	leave  
 9b9:	c3                   	ret    

000009ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9ba:	55                   	push   %ebp
 9bb:	89 e5                	mov    %esp,%ebp
 9bd:	53                   	push   %ebx
 9be:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9c8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9cc:	74 17                	je     9e5 <printint+0x2b>
 9ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9d2:	79 11                	jns    9e5 <printint+0x2b>
    neg = 1;
 9d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9db:	8b 45 0c             	mov    0xc(%ebp),%eax
 9de:	f7 d8                	neg    %eax
 9e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9e3:	eb 06                	jmp    9eb <printint+0x31>
  } else {
    x = xx;
 9e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 9e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9f5:	8d 41 01             	lea    0x1(%ecx),%eax
 9f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a01:	ba 00 00 00 00       	mov    $0x0,%edx
 a06:	f7 f3                	div    %ebx
 a08:	89 d0                	mov    %edx,%eax
 a0a:	0f b6 80 8c 11 00 00 	movzbl 0x118c(%eax),%eax
 a11:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a15:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a1b:	ba 00 00 00 00       	mov    $0x0,%edx
 a20:	f7 f3                	div    %ebx
 a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a29:	75 c7                	jne    9f2 <printint+0x38>
  if(neg)
 a2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a2f:	74 2d                	je     a5e <printint+0xa4>
    buf[i++] = '-';
 a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a34:	8d 50 01             	lea    0x1(%eax),%edx
 a37:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a3a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a3f:	eb 1d                	jmp    a5e <printint+0xa4>
    putc(fd, buf[i]);
 a41:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	01 d0                	add    %edx,%eax
 a49:	0f b6 00             	movzbl (%eax),%eax
 a4c:	0f be c0             	movsbl %al,%eax
 a4f:	83 ec 08             	sub    $0x8,%esp
 a52:	50                   	push   %eax
 a53:	ff 75 08             	pushl  0x8(%ebp)
 a56:	e8 3c ff ff ff       	call   997 <putc>
 a5b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a5e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a66:	79 d9                	jns    a41 <printint+0x87>
    putc(fd, buf[i]);
}
 a68:	90                   	nop
 a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a6c:	c9                   	leave  
 a6d:	c3                   	ret    

00000a6e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a6e:	55                   	push   %ebp
 a6f:	89 e5                	mov    %esp,%ebp
 a71:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a74:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a7b:	8d 45 0c             	lea    0xc(%ebp),%eax
 a7e:	83 c0 04             	add    $0x4,%eax
 a81:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a8b:	e9 59 01 00 00       	jmp    be9 <printf+0x17b>
    c = fmt[i] & 0xff;
 a90:	8b 55 0c             	mov    0xc(%ebp),%edx
 a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a96:	01 d0                	add    %edx,%eax
 a98:	0f b6 00             	movzbl (%eax),%eax
 a9b:	0f be c0             	movsbl %al,%eax
 a9e:	25 ff 00 00 00       	and    $0xff,%eax
 aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 aa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 aaa:	75 2c                	jne    ad8 <printf+0x6a>
      if(c == '%'){
 aac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ab0:	75 0c                	jne    abe <printf+0x50>
        state = '%';
 ab2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ab9:	e9 27 01 00 00       	jmp    be5 <printf+0x177>
      } else {
        putc(fd, c);
 abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ac1:	0f be c0             	movsbl %al,%eax
 ac4:	83 ec 08             	sub    $0x8,%esp
 ac7:	50                   	push   %eax
 ac8:	ff 75 08             	pushl  0x8(%ebp)
 acb:	e8 c7 fe ff ff       	call   997 <putc>
 ad0:	83 c4 10             	add    $0x10,%esp
 ad3:	e9 0d 01 00 00       	jmp    be5 <printf+0x177>
      }
    } else if(state == '%'){
 ad8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 adc:	0f 85 03 01 00 00    	jne    be5 <printf+0x177>
      if(c == 'd'){
 ae2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 ae6:	75 1e                	jne    b06 <printf+0x98>
        printint(fd, *ap, 10, 1);
 ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aeb:	8b 00                	mov    (%eax),%eax
 aed:	6a 01                	push   $0x1
 aef:	6a 0a                	push   $0xa
 af1:	50                   	push   %eax
 af2:	ff 75 08             	pushl  0x8(%ebp)
 af5:	e8 c0 fe ff ff       	call   9ba <printint>
 afa:	83 c4 10             	add    $0x10,%esp
        ap++;
 afd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b01:	e9 d8 00 00 00       	jmp    bde <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 b06:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b0a:	74 06                	je     b12 <printf+0xa4>
 b0c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b10:	75 1e                	jne    b30 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b15:	8b 00                	mov    (%eax),%eax
 b17:	6a 00                	push   $0x0
 b19:	6a 10                	push   $0x10
 b1b:	50                   	push   %eax
 b1c:	ff 75 08             	pushl  0x8(%ebp)
 b1f:	e8 96 fe ff ff       	call   9ba <printint>
 b24:	83 c4 10             	add    $0x10,%esp
        ap++;
 b27:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b2b:	e9 ae 00 00 00       	jmp    bde <printf+0x170>
      } else if(c == 's'){
 b30:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b34:	75 43                	jne    b79 <printf+0x10b>
        s = (char*)*ap;
 b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b39:	8b 00                	mov    (%eax),%eax
 b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b3e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b46:	75 25                	jne    b6d <printf+0xff>
          s = "(null)";
 b48:	c7 45 f4 c5 0e 00 00 	movl   $0xec5,-0xc(%ebp)
        while(*s != 0){
 b4f:	eb 1c                	jmp    b6d <printf+0xff>
          putc(fd, *s);
 b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b54:	0f b6 00             	movzbl (%eax),%eax
 b57:	0f be c0             	movsbl %al,%eax
 b5a:	83 ec 08             	sub    $0x8,%esp
 b5d:	50                   	push   %eax
 b5e:	ff 75 08             	pushl  0x8(%ebp)
 b61:	e8 31 fe ff ff       	call   997 <putc>
 b66:	83 c4 10             	add    $0x10,%esp
          s++;
 b69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b70:	0f b6 00             	movzbl (%eax),%eax
 b73:	84 c0                	test   %al,%al
 b75:	75 da                	jne    b51 <printf+0xe3>
 b77:	eb 65                	jmp    bde <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b79:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b7d:	75 1d                	jne    b9c <printf+0x12e>
        putc(fd, *ap);
 b7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b82:	8b 00                	mov    (%eax),%eax
 b84:	0f be c0             	movsbl %al,%eax
 b87:	83 ec 08             	sub    $0x8,%esp
 b8a:	50                   	push   %eax
 b8b:	ff 75 08             	pushl  0x8(%ebp)
 b8e:	e8 04 fe ff ff       	call   997 <putc>
 b93:	83 c4 10             	add    $0x10,%esp
        ap++;
 b96:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b9a:	eb 42                	jmp    bde <printf+0x170>
      } else if(c == '%'){
 b9c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ba0:	75 17                	jne    bb9 <printf+0x14b>
        putc(fd, c);
 ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ba5:	0f be c0             	movsbl %al,%eax
 ba8:	83 ec 08             	sub    $0x8,%esp
 bab:	50                   	push   %eax
 bac:	ff 75 08             	pushl  0x8(%ebp)
 baf:	e8 e3 fd ff ff       	call   997 <putc>
 bb4:	83 c4 10             	add    $0x10,%esp
 bb7:	eb 25                	jmp    bde <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bb9:	83 ec 08             	sub    $0x8,%esp
 bbc:	6a 25                	push   $0x25
 bbe:	ff 75 08             	pushl  0x8(%ebp)
 bc1:	e8 d1 fd ff ff       	call   997 <putc>
 bc6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bcc:	0f be c0             	movsbl %al,%eax
 bcf:	83 ec 08             	sub    $0x8,%esp
 bd2:	50                   	push   %eax
 bd3:	ff 75 08             	pushl  0x8(%ebp)
 bd6:	e8 bc fd ff ff       	call   997 <putc>
 bdb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 bde:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 be5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 be9:	8b 55 0c             	mov    0xc(%ebp),%edx
 bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bef:	01 d0                	add    %edx,%eax
 bf1:	0f b6 00             	movzbl (%eax),%eax
 bf4:	84 c0                	test   %al,%al
 bf6:	0f 85 94 fe ff ff    	jne    a90 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bfc:	90                   	nop
 bfd:	c9                   	leave  
 bfe:	c3                   	ret    

00000bff <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bff:	55                   	push   %ebp
 c00:	89 e5                	mov    %esp,%ebp
 c02:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c05:	8b 45 08             	mov    0x8(%ebp),%eax
 c08:	83 e8 08             	sub    $0x8,%eax
 c0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c0e:	a1 b8 11 00 00       	mov    0x11b8,%eax
 c13:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c16:	eb 24                	jmp    c3c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1b:	8b 00                	mov    (%eax),%eax
 c1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c20:	77 12                	ja     c34 <free+0x35>
 c22:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c25:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c28:	77 24                	ja     c4e <free+0x4f>
 c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2d:	8b 00                	mov    (%eax),%eax
 c2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c32:	77 1a                	ja     c4e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c37:	8b 00                	mov    (%eax),%eax
 c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c42:	76 d4                	jbe    c18 <free+0x19>
 c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c47:	8b 00                	mov    (%eax),%eax
 c49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c4c:	76 ca                	jbe    c18 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c51:	8b 40 04             	mov    0x4(%eax),%eax
 c54:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5e:	01 c2                	add    %eax,%edx
 c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c63:	8b 00                	mov    (%eax),%eax
 c65:	39 c2                	cmp    %eax,%edx
 c67:	75 24                	jne    c8d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c6c:	8b 50 04             	mov    0x4(%eax),%edx
 c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c72:	8b 00                	mov    (%eax),%eax
 c74:	8b 40 04             	mov    0x4(%eax),%eax
 c77:	01 c2                	add    %eax,%edx
 c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c82:	8b 00                	mov    (%eax),%eax
 c84:	8b 10                	mov    (%eax),%edx
 c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c89:	89 10                	mov    %edx,(%eax)
 c8b:	eb 0a                	jmp    c97 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c90:	8b 10                	mov    (%eax),%edx
 c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c95:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9a:	8b 40 04             	mov    0x4(%eax),%eax
 c9d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca7:	01 d0                	add    %edx,%eax
 ca9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cac:	75 20                	jne    cce <free+0xcf>
    p->s.size += bp->s.size;
 cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb1:	8b 50 04             	mov    0x4(%eax),%edx
 cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb7:	8b 40 04             	mov    0x4(%eax),%eax
 cba:	01 c2                	add    %eax,%edx
 cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc5:	8b 10                	mov    (%eax),%edx
 cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cca:	89 10                	mov    %edx,(%eax)
 ccc:	eb 08                	jmp    cd6 <free+0xd7>
  } else
    p->s.ptr = bp;
 cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 cd4:	89 10                	mov    %edx,(%eax)
  freep = p;
 cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd9:	a3 b8 11 00 00       	mov    %eax,0x11b8
}
 cde:	90                   	nop
 cdf:	c9                   	leave  
 ce0:	c3                   	ret    

00000ce1 <morecore>:

static Header*
morecore(uint nu)
{
 ce1:	55                   	push   %ebp
 ce2:	89 e5                	mov    %esp,%ebp
 ce4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ce7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cee:	77 07                	ja     cf7 <morecore+0x16>
    nu = 4096;
 cf0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cf7:	8b 45 08             	mov    0x8(%ebp),%eax
 cfa:	c1 e0 03             	shl    $0x3,%eax
 cfd:	83 ec 0c             	sub    $0xc,%esp
 d00:	50                   	push   %eax
 d01:	e8 11 fc ff ff       	call   917 <sbrk>
 d06:	83 c4 10             	add    $0x10,%esp
 d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d0c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d10:	75 07                	jne    d19 <morecore+0x38>
    return 0;
 d12:	b8 00 00 00 00       	mov    $0x0,%eax
 d17:	eb 26                	jmp    d3f <morecore+0x5e>
  hp = (Header*)p;
 d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d22:	8b 55 08             	mov    0x8(%ebp),%edx
 d25:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d2b:	83 c0 08             	add    $0x8,%eax
 d2e:	83 ec 0c             	sub    $0xc,%esp
 d31:	50                   	push   %eax
 d32:	e8 c8 fe ff ff       	call   bff <free>
 d37:	83 c4 10             	add    $0x10,%esp
  return freep;
 d3a:	a1 b8 11 00 00       	mov    0x11b8,%eax
}
 d3f:	c9                   	leave  
 d40:	c3                   	ret    

00000d41 <malloc>:

void*
malloc(uint nbytes)
{
 d41:	55                   	push   %ebp
 d42:	89 e5                	mov    %esp,%ebp
 d44:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d47:	8b 45 08             	mov    0x8(%ebp),%eax
 d4a:	83 c0 07             	add    $0x7,%eax
 d4d:	c1 e8 03             	shr    $0x3,%eax
 d50:	83 c0 01             	add    $0x1,%eax
 d53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d56:	a1 b8 11 00 00       	mov    0x11b8,%eax
 d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d62:	75 23                	jne    d87 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d64:	c7 45 f0 b0 11 00 00 	movl   $0x11b0,-0x10(%ebp)
 d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d6e:	a3 b8 11 00 00       	mov    %eax,0x11b8
 d73:	a1 b8 11 00 00       	mov    0x11b8,%eax
 d78:	a3 b0 11 00 00       	mov    %eax,0x11b0
    base.s.size = 0;
 d7d:	c7 05 b4 11 00 00 00 	movl   $0x0,0x11b4
 d84:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d8a:	8b 00                	mov    (%eax),%eax
 d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d92:	8b 40 04             	mov    0x4(%eax),%eax
 d95:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d98:	72 4d                	jb     de7 <malloc+0xa6>
      if(p->s.size == nunits)
 d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9d:	8b 40 04             	mov    0x4(%eax),%eax
 da0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 da3:	75 0c                	jne    db1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da8:	8b 10                	mov    (%eax),%edx
 daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dad:	89 10                	mov    %edx,(%eax)
 daf:	eb 26                	jmp    dd7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db4:	8b 40 04             	mov    0x4(%eax),%eax
 db7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 dba:	89 c2                	mov    %eax,%edx
 dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc5:	8b 40 04             	mov    0x4(%eax),%eax
 dc8:	c1 e0 03             	shl    $0x3,%eax
 dcb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 dd4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dda:	a3 b8 11 00 00       	mov    %eax,0x11b8
      return (void*)(p + 1);
 ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de2:	83 c0 08             	add    $0x8,%eax
 de5:	eb 3b                	jmp    e22 <malloc+0xe1>
    }
    if(p == freep)
 de7:	a1 b8 11 00 00       	mov    0x11b8,%eax
 dec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 def:	75 1e                	jne    e0f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 df1:	83 ec 0c             	sub    $0xc,%esp
 df4:	ff 75 ec             	pushl  -0x14(%ebp)
 df7:	e8 e5 fe ff ff       	call   ce1 <morecore>
 dfc:	83 c4 10             	add    $0x10,%esp
 dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e06:	75 07                	jne    e0f <malloc+0xce>
        return 0;
 e08:	b8 00 00 00 00       	mov    $0x0,%eax
 e0d:	eb 13                	jmp    e22 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e18:	8b 00                	mov    (%eax),%eax
 e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e1d:	e9 6d ff ff ff       	jmp    d8f <malloc+0x4e>
}
 e22:	c9                   	leave  
 e23:	c3                   	ret    
