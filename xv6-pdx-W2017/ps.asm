
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"

int
main (int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 58             	sub    $0x58,%esp
	uint max = 72;
  14:	c7 45 e0 48 00 00 00 	movl   $0x48,-0x20(%ebp)
	uint actual_max = 0;
  1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	uint CPU_seconds = 0;
  22:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	uint CPU_milli = 0;
  29:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	uint elapsed_seconds = 0;
  30:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	uint elapsed_milli = 0;
  37:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int i = 0;
  3e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	struct uproc * table;
	table = (struct uproc*)malloc (max*(sizeof(struct uproc)));
  45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  48:	89 d0                	mov    %edx,%eax
  4a:	01 c0                	add    %eax,%eax
  4c:	01 d0                	add    %edx,%eax
  4e:	c1 e0 05             	shl    $0x5,%eax
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	50                   	push   %eax
  55:	e8 52 09 00 00       	call   9ac <malloc>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	actual_max = getprocs(max, table);
  60:	83 ec 08             	sub    $0x8,%esp
  63:	ff 75 c8             	pushl  -0x38(%ebp)
  66:	ff 75 e0             	pushl  -0x20(%ebp)
  69:	e8 64 05 00 00       	call   5d2 <getprocs>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(actual_max <=0)
  74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  78:	75 17                	jne    91 <main+0x91>
	{
		printf(2, "ERROR MESSAGE! \n");
  7a:	83 ec 08             	sub    $0x8,%esp
  7d:	68 90 0a 00 00       	push   $0xa90
  82:	6a 02                	push   $0x2
  84:	e8 50 06 00 00       	call   6d9 <printf>
  89:	83 c4 10             	add    $0x10,%esp
		exit();
  8c:	e8 69 04 00 00       	call   4fa <exit>
	}
	printf(2, "PID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size \n");
  91:	83 ec 08             	sub    $0x8,%esp
  94:	68 a4 0a 00 00       	push   $0xaa4
  99:	6a 02                	push   $0x2
  9b:	e8 39 06 00 00       	call   6d9 <printf>
  a0:	83 c4 10             	add    $0x10,%esp
	for(i = 0; i < actual_max; ++i)
  a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  aa:	e9 e3 01 00 00       	jmp    292 <main+0x292>
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
  af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  b2:	89 d0                	mov    %edx,%eax
  b4:	01 c0                	add    %eax,%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	c1 e0 05             	shl    $0x5,%eax
  bb:	89 c2                	mov    %eax,%edx
  bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  c0:	01 d0                	add    %edx,%eax
  c2:	8b 40 14             	mov    0x14(%eax),%eax
  c5:	89 45 a8             	mov    %eax,-0x58(%ebp)
  c8:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  cf:	df 6d a8             	fildll -0x58(%ebp)
  d2:	dd 5d c0             	fstpl  -0x40(%ebp)
  d5:	dd 45 c0             	fldl   -0x40(%ebp)
  d8:	dd 05 00 0b 00 00    	fldl   0xb00
  de:	de c9                	fmulp  %st,%st(1)
  e0:	d9 7d be             	fnstcw -0x42(%ebp)
  e3:	0f b7 45 be          	movzwl -0x42(%ebp),%eax
  e7:	b4 0c                	mov    $0xc,%ah
  e9:	66 89 45 bc          	mov    %ax,-0x44(%ebp)
  ed:	d9 6d bc             	fldcw  -0x44(%ebp)
  f0:	df 7d b0             	fistpll -0x50(%ebp)
  f3:	d9 6d be             	fldcw  -0x42(%ebp)
  f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  f9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        	CPU_milli = table[i].CPU_total_ticks % 100;
  ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 102:	89 d0                	mov    %edx,%eax
 104:	01 c0                	add    %eax,%eax
 106:	01 d0                	add    %edx,%eax
 108:	c1 e0 05             	shl    $0x5,%eax
 10b:	89 c2                	mov    %eax,%edx
 10d:	8b 45 c8             	mov    -0x38(%ebp),%eax
 110:	01 d0                	add    %edx,%eax
 112:	8b 48 14             	mov    0x14(%eax),%ecx
 115:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 11a:	89 c8                	mov    %ecx,%eax
 11c:	f7 e2                	mul    %edx
 11e:	89 d0                	mov    %edx,%eax
 120:	c1 e8 05             	shr    $0x5,%eax
 123:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 126:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 129:	6b c0 64             	imul   $0x64,%eax,%eax
 12c:	29 c1                	sub    %eax,%ecx
 12e:	89 c8                	mov    %ecx,%eax
 130:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
 133:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 136:	89 d0                	mov    %edx,%eax
 138:	01 c0                	add    %eax,%eax
 13a:	01 d0                	add    %edx,%eax
 13c:	c1 e0 05             	shl    $0x5,%eax
 13f:	89 c2                	mov    %eax,%edx
 141:	8b 45 c8             	mov    -0x38(%ebp),%eax
 144:	01 d0                	add    %edx,%eax
 146:	8b 40 10             	mov    0x10(%eax),%eax
 149:	89 45 a8             	mov    %eax,-0x58(%ebp)
 14c:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
 153:	df 6d a8             	fildll -0x58(%ebp)
 156:	dd 5d c0             	fstpl  -0x40(%ebp)
 159:	dd 45 c0             	fldl   -0x40(%ebp)
 15c:	dd 05 00 0b 00 00    	fldl   0xb00
 162:	de c9                	fmulp  %st,%st(1)
 164:	d9 6d bc             	fldcw  -0x44(%ebp)
 167:	df 7d b0             	fistpll -0x50(%ebp)
 16a:	d9 6d be             	fldcw  -0x42(%ebp)
 16d:	8b 45 b0             	mov    -0x50(%ebp),%eax
 170:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 173:	89 45 d0             	mov    %eax,-0x30(%ebp)
        	elapsed_milli = table[i].elapsed_ticks % 100;
 176:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 179:	89 d0                	mov    %edx,%eax
 17b:	01 c0                	add    %eax,%eax
 17d:	01 d0                	add    %edx,%eax
 17f:	c1 e0 05             	shl    $0x5,%eax
 182:	89 c2                	mov    %eax,%edx
 184:	8b 45 c8             	mov    -0x38(%ebp),%eax
 187:	01 d0                	add    %edx,%eax
 189:	8b 48 10             	mov    0x10(%eax),%ecx
 18c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 191:	89 c8                	mov    %ecx,%eax
 193:	f7 e2                	mul    %edx
 195:	89 d0                	mov    %edx,%eax
 197:	c1 e8 05             	shr    $0x5,%eax
 19a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 19d:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1a0:	6b c0 64             	imul   $0x64,%eax,%eax
 1a3:	29 c1                	sub    %eax,%ecx
 1a5:	89 c8                	mov    %ecx,%eax
 1a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
 1aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1ad:	89 d0                	mov    %edx,%eax
 1af:	01 c0                	add    %eax,%eax
 1b1:	01 d0                	add    %edx,%eax
 1b3:	c1 e0 05             	shl    $0x5,%eax
 1b6:	89 c2                	mov    %eax,%edx
 1b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1bb:	01 d0                	add    %edx,%eax
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
 1bd:	8b 70 38             	mov    0x38(%eax),%esi
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
 1c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1c3:	89 d0                	mov    %edx,%eax
 1c5:	01 c0                	add    %eax,%eax
 1c7:	01 d0                	add    %edx,%eax
 1c9:	c1 e0 05             	shl    $0x5,%eax
 1cc:	89 c2                	mov    %eax,%edx
 1ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	83 c0 18             	add    $0x18,%eax
 1d6:	89 45 a8             	mov    %eax,-0x58(%ebp)
 1d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1dc:	89 d0                	mov    %edx,%eax
 1de:	01 c0                	add    %eax,%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c1 e0 05             	shl    $0x5,%eax
 1e5:	89 c2                	mov    %eax,%edx
 1e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
 1ec:	8b 58 5c             	mov    0x5c(%eax),%ebx
 1ef:	89 5d b8             	mov    %ebx,-0x48(%ebp)
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
 1f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1f5:	89 d0                	mov    %edx,%eax
 1f7:	01 c0                	add    %eax,%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	c1 e0 05             	shl    $0x5,%eax
 1fe:	89 c2                	mov    %eax,%edx
 200:	8b 45 c8             	mov    -0x38(%ebp),%eax
 203:	01 d0                	add    %edx,%eax
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
 205:	8b 78 0c             	mov    0xc(%eax),%edi
 208:	89 7d a4             	mov    %edi,-0x5c(%ebp)
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
 20b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 20e:	89 d0                	mov    %edx,%eax
 210:	01 c0                	add    %eax,%eax
 212:	01 d0                	add    %edx,%eax
 214:	c1 e0 05             	shl    $0x5,%eax
 217:	89 c2                	mov    %eax,%edx
 219:	8b 45 c8             	mov    -0x38(%ebp),%eax
 21c:	01 d0                	add    %edx,%eax
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
 21e:	8b 78 08             	mov    0x8(%eax),%edi
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
 221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 224:	89 d0                	mov    %edx,%eax
 226:	01 c0                	add    %eax,%eax
 228:	01 d0                	add    %edx,%eax
 22a:	c1 e0 05             	shl    $0x5,%eax
 22d:	89 c2                	mov    %eax,%edx
 22f:	8b 45 c8             	mov    -0x38(%ebp),%eax
 232:	01 d0                	add    %edx,%eax
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
 234:	8b 58 04             	mov    0x4(%eax),%ebx
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
 237:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 23a:	89 d0                	mov    %edx,%eax
 23c:	01 c0                	add    %eax,%eax
 23e:	01 d0                	add    %edx,%eax
 240:	c1 e0 05             	shl    $0x5,%eax
 243:	89 c2                	mov    %eax,%edx
 245:	8b 45 c8             	mov    -0x38(%ebp),%eax
 248:	01 d0                	add    %edx,%eax
 24a:	8d 48 3c             	lea    0x3c(%eax),%ecx
 24d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 250:	89 d0                	mov    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	01 d0                	add    %edx,%eax
 256:	c1 e0 05             	shl    $0x5,%eax
 259:	89 c2                	mov    %eax,%edx
 25b:	8b 45 c8             	mov    -0x38(%ebp),%eax
 25e:	01 d0                	add    %edx,%eax
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
 260:	8b 00                	mov    (%eax),%eax
 262:	83 ec 08             	sub    $0x8,%esp
 265:	56                   	push   %esi
 266:	ff 75 a8             	pushl  -0x58(%ebp)
 269:	ff 75 d4             	pushl  -0x2c(%ebp)
 26c:	ff 75 d8             	pushl  -0x28(%ebp)
 26f:	ff 75 cc             	pushl  -0x34(%ebp)
 272:	ff 75 d0             	pushl  -0x30(%ebp)
 275:	ff 75 b8             	pushl  -0x48(%ebp)
 278:	ff 75 a4             	pushl  -0x5c(%ebp)
 27b:	57                   	push   %edi
 27c:	53                   	push   %ebx
 27d:	51                   	push   %ecx
 27e:	50                   	push   %eax
 27f:	68 d8 0a 00 00       	push   $0xad8
 284:	6a 02                	push   $0x2
 286:	e8 4e 04 00 00       	call   6d9 <printf>
 28b:	83 c4 40             	add    $0x40,%esp
	{
		printf(2, "ERROR MESSAGE! \n");
		exit();
	}
	printf(2, "PID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size \n");
	for(i = 0; i < actual_max; ++i)
 28e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 295:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 298:	0f 82 11 fe ff ff    	jb     af <main+0xaf>
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
	}
	exit();
 29e:	e8 57 02 00 00       	call   4fa <exit>

000002a3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	57                   	push   %edi
 2a7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ab:	8b 55 10             	mov    0x10(%ebp),%edx
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 cb                	mov    %ecx,%ebx
 2b3:	89 df                	mov    %ebx,%edi
 2b5:	89 d1                	mov    %edx,%ecx
 2b7:	fc                   	cld    
 2b8:	f3 aa                	rep stos %al,%es:(%edi)
 2ba:	89 ca                	mov    %ecx,%edx
 2bc:	89 fb                	mov    %edi,%ebx
 2be:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2c1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2c4:	90                   	nop
 2c5:	5b                   	pop    %ebx
 2c6:	5f                   	pop    %edi
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    

000002c9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2d5:	90                   	nop
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	8d 50 01             	lea    0x1(%eax),%edx
 2dc:	89 55 08             	mov    %edx,0x8(%ebp)
 2df:	8b 55 0c             	mov    0xc(%ebp),%edx
 2e2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2e8:	0f b6 12             	movzbl (%edx),%edx
 2eb:	88 10                	mov    %dl,(%eax)
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	84 c0                	test   %al,%al
 2f2:	75 e2                	jne    2d6 <strcpy+0xd>
    ;
  return os;
 2f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2fc:	eb 08                	jmp    306 <strcmp+0xd>
    p++, q++;
 2fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 302:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	84 c0                	test   %al,%al
 30e:	74 10                	je     320 <strcmp+0x27>
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	0f b6 10             	movzbl (%eax),%edx
 316:	8b 45 0c             	mov    0xc(%ebp),%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	38 c2                	cmp    %al,%dl
 31e:	74 de                	je     2fe <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	0f b6 00             	movzbl (%eax),%eax
 326:	0f b6 d0             	movzbl %al,%edx
 329:	8b 45 0c             	mov    0xc(%ebp),%eax
 32c:	0f b6 00             	movzbl (%eax),%eax
 32f:	0f b6 c0             	movzbl %al,%eax
 332:	29 c2                	sub    %eax,%edx
 334:	89 d0                	mov    %edx,%eax
}
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    

00000338 <strlen>:

uint
strlen(char *s)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 33e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 345:	eb 04                	jmp    34b <strlen+0x13>
 347:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 34b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	01 d0                	add    %edx,%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	84 c0                	test   %al,%al
 358:	75 ed                	jne    347 <strlen+0xf>
    ;
  return n;
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35d:	c9                   	leave  
 35e:	c3                   	ret    

0000035f <memset>:

void*
memset(void *dst, int c, uint n)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 362:	8b 45 10             	mov    0x10(%ebp),%eax
 365:	50                   	push   %eax
 366:	ff 75 0c             	pushl  0xc(%ebp)
 369:	ff 75 08             	pushl  0x8(%ebp)
 36c:	e8 32 ff ff ff       	call   2a3 <stosb>
 371:	83 c4 0c             	add    $0xc,%esp
  return dst;
 374:	8b 45 08             	mov    0x8(%ebp),%eax
}
 377:	c9                   	leave  
 378:	c3                   	ret    

00000379 <strchr>:

char*
strchr(const char *s, char c)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 04             	sub    $0x4,%esp
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 385:	eb 14                	jmp    39b <strchr+0x22>
    if(*s == c)
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 00             	movzbl (%eax),%eax
 38d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 390:	75 05                	jne    397 <strchr+0x1e>
      return (char*)s;
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	eb 13                	jmp    3aa <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 397:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	0f b6 00             	movzbl (%eax),%eax
 3a1:	84 c0                	test   %al,%al
 3a3:	75 e2                	jne    387 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <gets>:

char*
gets(char *buf, int max)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3b9:	eb 42                	jmp    3fd <gets+0x51>
    cc = read(0, &c, 1);
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	6a 01                	push   $0x1
 3c0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3c3:	50                   	push   %eax
 3c4:	6a 00                	push   $0x0
 3c6:	e8 47 01 00 00       	call   512 <read>
 3cb:	83 c4 10             	add    $0x10,%esp
 3ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d5:	7e 33                	jle    40a <gets+0x5e>
      break;
    buf[i++] = c;
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e0:	89 c2                	mov    %eax,%edx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	01 c2                	add    %eax,%edx
 3e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3eb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f1:	3c 0a                	cmp    $0xa,%al
 3f3:	74 16                	je     40b <gets+0x5f>
 3f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f9:	3c 0d                	cmp    $0xd,%al
 3fb:	74 0e                	je     40b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	83 c0 01             	add    $0x1,%eax
 403:	3b 45 0c             	cmp    0xc(%ebp),%eax
 406:	7c b3                	jl     3bb <gets+0xf>
 408:	eb 01                	jmp    40b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 40a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 40b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	01 d0                	add    %edx,%eax
 413:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 416:	8b 45 08             	mov    0x8(%ebp),%eax
}
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <stat>:

int
stat(char *n, struct stat *st)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 421:	83 ec 08             	sub    $0x8,%esp
 424:	6a 00                	push   $0x0
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 0c 01 00 00       	call   53a <open>
 42e:	83 c4 10             	add    $0x10,%esp
 431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 438:	79 07                	jns    441 <stat+0x26>
    return -1;
 43a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43f:	eb 25                	jmp    466 <stat+0x4b>
  r = fstat(fd, st);
 441:	83 ec 08             	sub    $0x8,%esp
 444:	ff 75 0c             	pushl  0xc(%ebp)
 447:	ff 75 f4             	pushl  -0xc(%ebp)
 44a:	e8 03 01 00 00       	call   552 <fstat>
 44f:	83 c4 10             	add    $0x10,%esp
 452:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 455:	83 ec 0c             	sub    $0xc,%esp
 458:	ff 75 f4             	pushl  -0xc(%ebp)
 45b:	e8 c2 00 00 00       	call   522 <close>
 460:	83 c4 10             	add    $0x10,%esp
  return r;
 463:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 466:	c9                   	leave  
 467:	c3                   	ret    

00000468 <atoi>:

int
atoi(const char *s)
{
 468:	55                   	push   %ebp
 469:	89 e5                	mov    %esp,%ebp
 46b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 46e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 475:	eb 25                	jmp    49c <atoi+0x34>
    n = n*10 + *s++ - '0';
 477:	8b 55 fc             	mov    -0x4(%ebp),%edx
 47a:	89 d0                	mov    %edx,%eax
 47c:	c1 e0 02             	shl    $0x2,%eax
 47f:	01 d0                	add    %edx,%eax
 481:	01 c0                	add    %eax,%eax
 483:	89 c1                	mov    %eax,%ecx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	8d 50 01             	lea    0x1(%eax),%edx
 48b:	89 55 08             	mov    %edx,0x8(%ebp)
 48e:	0f b6 00             	movzbl (%eax),%eax
 491:	0f be c0             	movsbl %al,%eax
 494:	01 c8                	add    %ecx,%eax
 496:	83 e8 30             	sub    $0x30,%eax
 499:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	0f b6 00             	movzbl (%eax),%eax
 4a2:	3c 2f                	cmp    $0x2f,%al
 4a4:	7e 0a                	jle    4b0 <atoi+0x48>
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	0f b6 00             	movzbl (%eax),%eax
 4ac:	3c 39                	cmp    $0x39,%al
 4ae:	7e c7                	jle    477 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b3:	c9                   	leave  
 4b4:	c3                   	ret    

000004b5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b5:	55                   	push   %ebp
 4b6:	89 e5                	mov    %esp,%ebp
 4b8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c7:	eb 17                	jmp    4e0 <memmove+0x2b>
    *dst++ = *src++;
 4c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4cc:	8d 50 01             	lea    0x1(%eax),%edx
 4cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4d5:	8d 4a 01             	lea    0x1(%edx),%ecx
 4d8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4db:	0f b6 12             	movzbl (%edx),%edx
 4de:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4e0:	8b 45 10             	mov    0x10(%ebp),%eax
 4e3:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e6:	89 55 10             	mov    %edx,0x10(%ebp)
 4e9:	85 c0                	test   %eax,%eax
 4eb:	7f dc                	jg     4c9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f0:	c9                   	leave  
 4f1:	c3                   	ret    

000004f2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f2:	b8 01 00 00 00       	mov    $0x1,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <exit>:
SYSCALL(exit)
 4fa:	b8 02 00 00 00       	mov    $0x2,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <wait>:
SYSCALL(wait)
 502:	b8 03 00 00 00       	mov    $0x3,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <pipe>:
SYSCALL(pipe)
 50a:	b8 04 00 00 00       	mov    $0x4,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <read>:
SYSCALL(read)
 512:	b8 05 00 00 00       	mov    $0x5,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <write>:
SYSCALL(write)
 51a:	b8 10 00 00 00       	mov    $0x10,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <close>:
SYSCALL(close)
 522:	b8 15 00 00 00       	mov    $0x15,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <kill>:
SYSCALL(kill)
 52a:	b8 06 00 00 00       	mov    $0x6,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <exec>:
SYSCALL(exec)
 532:	b8 07 00 00 00       	mov    $0x7,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <open>:
SYSCALL(open)
 53a:	b8 0f 00 00 00       	mov    $0xf,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <mknod>:
SYSCALL(mknod)
 542:	b8 11 00 00 00       	mov    $0x11,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <unlink>:
SYSCALL(unlink)
 54a:	b8 12 00 00 00       	mov    $0x12,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <fstat>:
SYSCALL(fstat)
 552:	b8 08 00 00 00       	mov    $0x8,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <link>:
SYSCALL(link)
 55a:	b8 13 00 00 00       	mov    $0x13,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <mkdir>:
SYSCALL(mkdir)
 562:	b8 14 00 00 00       	mov    $0x14,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <chdir>:
SYSCALL(chdir)
 56a:	b8 09 00 00 00       	mov    $0x9,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <dup>:
SYSCALL(dup)
 572:	b8 0a 00 00 00       	mov    $0xa,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <getpid>:
SYSCALL(getpid)
 57a:	b8 0b 00 00 00       	mov    $0xb,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <sbrk>:
SYSCALL(sbrk)
 582:	b8 0c 00 00 00       	mov    $0xc,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <sleep>:
SYSCALL(sleep)
 58a:	b8 0d 00 00 00       	mov    $0xd,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <uptime>:
SYSCALL(uptime)
 592:	b8 0e 00 00 00       	mov    $0xe,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <halt>:
SYSCALL(halt)
 59a:	b8 16 00 00 00       	mov    $0x16,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <date>:
SYSCALL(date)
 5a2:	b8 17 00 00 00       	mov    $0x17,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <getuid>:
SYSCALL(getuid)
 5aa:	b8 18 00 00 00       	mov    $0x18,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <getgid>:
SYSCALL(getgid)
 5b2:	b8 19 00 00 00       	mov    $0x19,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <getppid>:
SYSCALL(getppid)
 5ba:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <setuid>:
SYSCALL(setuid)
 5c2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <setgid>:
SYSCALL(setgid)
 5ca:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <getprocs>:
SYSCALL(getprocs)
 5d2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <looper>:
SYSCALL(looper)
 5da:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <setpriority>:
SYSCALL(setpriority)
 5e2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <chmod>:
SYSCALL(chmod)
 5ea:	b8 20 00 00 00       	mov    $0x20,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <chown>:
SYSCALL(chown)
 5f2:	b8 21 00 00 00       	mov    $0x21,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <chgrp>:
SYSCALL(chgrp)
 5fa:	b8 22 00 00 00       	mov    $0x22,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	83 ec 18             	sub    $0x18,%esp
 608:	8b 45 0c             	mov    0xc(%ebp),%eax
 60b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 60e:	83 ec 04             	sub    $0x4,%esp
 611:	6a 01                	push   $0x1
 613:	8d 45 f4             	lea    -0xc(%ebp),%eax
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 fb fe ff ff       	call   51a <write>
 61f:	83 c4 10             	add    $0x10,%esp
}
 622:	90                   	nop
 623:	c9                   	leave  
 624:	c3                   	ret    

00000625 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	53                   	push   %ebx
 629:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 62c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 633:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 637:	74 17                	je     650 <printint+0x2b>
 639:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 63d:	79 11                	jns    650 <printint+0x2b>
    neg = 1;
 63f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 646:	8b 45 0c             	mov    0xc(%ebp),%eax
 649:	f7 d8                	neg    %eax
 64b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 64e:	eb 06                	jmp    656 <printint+0x31>
  } else {
    x = xx;
 650:	8b 45 0c             	mov    0xc(%ebp),%eax
 653:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 656:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 65d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 660:	8d 41 01             	lea    0x1(%ecx),%eax
 663:	89 45 f4             	mov    %eax,-0xc(%ebp)
 666:	8b 5d 10             	mov    0x10(%ebp),%ebx
 669:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66c:	ba 00 00 00 00       	mov    $0x0,%edx
 671:	f7 f3                	div    %ebx
 673:	89 d0                	mov    %edx,%eax
 675:	0f b6 80 64 0d 00 00 	movzbl 0xd64(%eax),%eax
 67c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 680:	8b 5d 10             	mov    0x10(%ebp),%ebx
 683:	8b 45 ec             	mov    -0x14(%ebp),%eax
 686:	ba 00 00 00 00       	mov    $0x0,%edx
 68b:	f7 f3                	div    %ebx
 68d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 690:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 694:	75 c7                	jne    65d <printint+0x38>
  if(neg)
 696:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69a:	74 2d                	je     6c9 <printint+0xa4>
    buf[i++] = '-';
 69c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69f:	8d 50 01             	lea    0x1(%eax),%edx
 6a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6aa:	eb 1d                	jmp    6c9 <printint+0xa4>
    putc(fd, buf[i]);
 6ac:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b2:	01 d0                	add    %edx,%eax
 6b4:	0f b6 00             	movzbl (%eax),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	83 ec 08             	sub    $0x8,%esp
 6bd:	50                   	push   %eax
 6be:	ff 75 08             	pushl  0x8(%ebp)
 6c1:	e8 3c ff ff ff       	call   602 <putc>
 6c6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6c9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d1:	79 d9                	jns    6ac <printint+0x87>
    putc(fd, buf[i]);
}
 6d3:	90                   	nop
 6d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    

000006d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6e6:	8d 45 0c             	lea    0xc(%ebp),%eax
 6e9:	83 c0 04             	add    $0x4,%eax
 6ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6f6:	e9 59 01 00 00       	jmp    854 <printf+0x17b>
    c = fmt[i] & 0xff;
 6fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	0f b6 00             	movzbl (%eax),%eax
 706:	0f be c0             	movsbl %al,%eax
 709:	25 ff 00 00 00       	and    $0xff,%eax
 70e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 711:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 715:	75 2c                	jne    743 <printf+0x6a>
      if(c == '%'){
 717:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71b:	75 0c                	jne    729 <printf+0x50>
        state = '%';
 71d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 724:	e9 27 01 00 00       	jmp    850 <printf+0x177>
      } else {
        putc(fd, c);
 729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72c:	0f be c0             	movsbl %al,%eax
 72f:	83 ec 08             	sub    $0x8,%esp
 732:	50                   	push   %eax
 733:	ff 75 08             	pushl  0x8(%ebp)
 736:	e8 c7 fe ff ff       	call   602 <putc>
 73b:	83 c4 10             	add    $0x10,%esp
 73e:	e9 0d 01 00 00       	jmp    850 <printf+0x177>
      }
    } else if(state == '%'){
 743:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 747:	0f 85 03 01 00 00    	jne    850 <printf+0x177>
      if(c == 'd'){
 74d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 751:	75 1e                	jne    771 <printf+0x98>
        printint(fd, *ap, 10, 1);
 753:	8b 45 e8             	mov    -0x18(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	6a 01                	push   $0x1
 75a:	6a 0a                	push   $0xa
 75c:	50                   	push   %eax
 75d:	ff 75 08             	pushl  0x8(%ebp)
 760:	e8 c0 fe ff ff       	call   625 <printint>
 765:	83 c4 10             	add    $0x10,%esp
        ap++;
 768:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76c:	e9 d8 00 00 00       	jmp    849 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 771:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 775:	74 06                	je     77d <printf+0xa4>
 777:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 77b:	75 1e                	jne    79b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 77d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	6a 00                	push   $0x0
 784:	6a 10                	push   $0x10
 786:	50                   	push   %eax
 787:	ff 75 08             	pushl  0x8(%ebp)
 78a:	e8 96 fe ff ff       	call   625 <printint>
 78f:	83 c4 10             	add    $0x10,%esp
        ap++;
 792:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 796:	e9 ae 00 00 00       	jmp    849 <printf+0x170>
      } else if(c == 's'){
 79b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 79f:	75 43                	jne    7e4 <printf+0x10b>
        s = (char*)*ap;
 7a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b1:	75 25                	jne    7d8 <printf+0xff>
          s = "(null)";
 7b3:	c7 45 f4 08 0b 00 00 	movl   $0xb08,-0xc(%ebp)
        while(*s != 0){
 7ba:	eb 1c                	jmp    7d8 <printf+0xff>
          putc(fd, *s);
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	0f b6 00             	movzbl (%eax),%eax
 7c2:	0f be c0             	movsbl %al,%eax
 7c5:	83 ec 08             	sub    $0x8,%esp
 7c8:	50                   	push   %eax
 7c9:	ff 75 08             	pushl  0x8(%ebp)
 7cc:	e8 31 fe ff ff       	call   602 <putc>
 7d1:	83 c4 10             	add    $0x10,%esp
          s++;
 7d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	0f b6 00             	movzbl (%eax),%eax
 7de:	84 c0                	test   %al,%al
 7e0:	75 da                	jne    7bc <printf+0xe3>
 7e2:	eb 65                	jmp    849 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7e4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7e8:	75 1d                	jne    807 <printf+0x12e>
        putc(fd, *ap);
 7ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ed:	8b 00                	mov    (%eax),%eax
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	83 ec 08             	sub    $0x8,%esp
 7f5:	50                   	push   %eax
 7f6:	ff 75 08             	pushl  0x8(%ebp)
 7f9:	e8 04 fe ff ff       	call   602 <putc>
 7fe:	83 c4 10             	add    $0x10,%esp
        ap++;
 801:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 805:	eb 42                	jmp    849 <printf+0x170>
      } else if(c == '%'){
 807:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 80b:	75 17                	jne    824 <printf+0x14b>
        putc(fd, c);
 80d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 810:	0f be c0             	movsbl %al,%eax
 813:	83 ec 08             	sub    $0x8,%esp
 816:	50                   	push   %eax
 817:	ff 75 08             	pushl  0x8(%ebp)
 81a:	e8 e3 fd ff ff       	call   602 <putc>
 81f:	83 c4 10             	add    $0x10,%esp
 822:	eb 25                	jmp    849 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 824:	83 ec 08             	sub    $0x8,%esp
 827:	6a 25                	push   $0x25
 829:	ff 75 08             	pushl  0x8(%ebp)
 82c:	e8 d1 fd ff ff       	call   602 <putc>
 831:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 837:	0f be c0             	movsbl %al,%eax
 83a:	83 ec 08             	sub    $0x8,%esp
 83d:	50                   	push   %eax
 83e:	ff 75 08             	pushl  0x8(%ebp)
 841:	e8 bc fd ff ff       	call   602 <putc>
 846:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 849:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 850:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 854:	8b 55 0c             	mov    0xc(%ebp),%edx
 857:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85a:	01 d0                	add    %edx,%eax
 85c:	0f b6 00             	movzbl (%eax),%eax
 85f:	84 c0                	test   %al,%al
 861:	0f 85 94 fe ff ff    	jne    6fb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 867:	90                   	nop
 868:	c9                   	leave  
 869:	c3                   	ret    

0000086a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86a:	55                   	push   %ebp
 86b:	89 e5                	mov    %esp,%ebp
 86d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	83 e8 08             	sub    $0x8,%eax
 876:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 879:	a1 80 0d 00 00       	mov    0xd80,%eax
 87e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 881:	eb 24                	jmp    8a7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88b:	77 12                	ja     89f <free+0x35>
 88d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 890:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 893:	77 24                	ja     8b9 <free+0x4f>
 895:	8b 45 fc             	mov    -0x4(%ebp),%eax
 898:	8b 00                	mov    (%eax),%eax
 89a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89d:	77 1a                	ja     8b9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	8b 00                	mov    (%eax),%eax
 8a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ad:	76 d4                	jbe    883 <free+0x19>
 8af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b2:	8b 00                	mov    (%eax),%eax
 8b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b7:	76 ca                	jbe    883 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bc:	8b 40 04             	mov    0x4(%eax),%eax
 8bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c9:	01 c2                	add    %eax,%edx
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	8b 00                	mov    (%eax),%eax
 8d0:	39 c2                	cmp    %eax,%edx
 8d2:	75 24                	jne    8f8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d7:	8b 50 04             	mov    0x4(%eax),%edx
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	8b 00                	mov    (%eax),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	01 c2                	add    %eax,%edx
 8e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	8b 10                	mov    (%eax),%edx
 8f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f4:	89 10                	mov    %edx,(%eax)
 8f6:	eb 0a                	jmp    902 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 10                	mov    (%eax),%edx
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	8b 40 04             	mov    0x4(%eax),%eax
 908:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	01 d0                	add    %edx,%eax
 914:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 917:	75 20                	jne    939 <free+0xcf>
    p->s.size += bp->s.size;
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 50 04             	mov    0x4(%eax),%edx
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	01 c2                	add    %eax,%edx
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 92d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 930:	8b 10                	mov    (%eax),%edx
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	89 10                	mov    %edx,(%eax)
 937:	eb 08                	jmp    941 <free+0xd7>
  } else
    p->s.ptr = bp;
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 93f:	89 10                	mov    %edx,(%eax)
  freep = p;
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	a3 80 0d 00 00       	mov    %eax,0xd80
}
 949:	90                   	nop
 94a:	c9                   	leave  
 94b:	c3                   	ret    

0000094c <morecore>:

static Header*
morecore(uint nu)
{
 94c:	55                   	push   %ebp
 94d:	89 e5                	mov    %esp,%ebp
 94f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 952:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 959:	77 07                	ja     962 <morecore+0x16>
    nu = 4096;
 95b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 962:	8b 45 08             	mov    0x8(%ebp),%eax
 965:	c1 e0 03             	shl    $0x3,%eax
 968:	83 ec 0c             	sub    $0xc,%esp
 96b:	50                   	push   %eax
 96c:	e8 11 fc ff ff       	call   582 <sbrk>
 971:	83 c4 10             	add    $0x10,%esp
 974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 977:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 97b:	75 07                	jne    984 <morecore+0x38>
    return 0;
 97d:	b8 00 00 00 00       	mov    $0x0,%eax
 982:	eb 26                	jmp    9aa <morecore+0x5e>
  hp = (Header*)p;
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 98a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98d:	8b 55 08             	mov    0x8(%ebp),%edx
 990:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 993:	8b 45 f0             	mov    -0x10(%ebp),%eax
 996:	83 c0 08             	add    $0x8,%eax
 999:	83 ec 0c             	sub    $0xc,%esp
 99c:	50                   	push   %eax
 99d:	e8 c8 fe ff ff       	call   86a <free>
 9a2:	83 c4 10             	add    $0x10,%esp
  return freep;
 9a5:	a1 80 0d 00 00       	mov    0xd80,%eax
}
 9aa:	c9                   	leave  
 9ab:	c3                   	ret    

000009ac <malloc>:

void*
malloc(uint nbytes)
{
 9ac:	55                   	push   %ebp
 9ad:	89 e5                	mov    %esp,%ebp
 9af:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	8b 45 08             	mov    0x8(%ebp),%eax
 9b5:	83 c0 07             	add    $0x7,%eax
 9b8:	c1 e8 03             	shr    $0x3,%eax
 9bb:	83 c0 01             	add    $0x1,%eax
 9be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9c1:	a1 80 0d 00 00       	mov    0xd80,%eax
 9c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9cd:	75 23                	jne    9f2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9cf:	c7 45 f0 78 0d 00 00 	movl   $0xd78,-0x10(%ebp)
 9d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d9:	a3 80 0d 00 00       	mov    %eax,0xd80
 9de:	a1 80 0d 00 00       	mov    0xd80,%eax
 9e3:	a3 78 0d 00 00       	mov    %eax,0xd78
    base.s.size = 0;
 9e8:	c7 05 7c 0d 00 00 00 	movl   $0x0,0xd7c
 9ef:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f5:	8b 00                	mov    (%eax),%eax
 9f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fd:	8b 40 04             	mov    0x4(%eax),%eax
 a00:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a03:	72 4d                	jb     a52 <malloc+0xa6>
      if(p->s.size == nunits)
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	8b 40 04             	mov    0x4(%eax),%eax
 a0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a0e:	75 0c                	jne    a1c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	8b 10                	mov    (%eax),%edx
 a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a18:	89 10                	mov    %edx,(%eax)
 a1a:	eb 26                	jmp    a42 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8b 40 04             	mov    0x4(%eax),%eax
 a22:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a25:	89 c2                	mov    %eax,%edx
 a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a30:	8b 40 04             	mov    0x4(%eax),%eax
 a33:	c1 e0 03             	shl    $0x3,%eax
 a36:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a3f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a45:	a3 80 0d 00 00       	mov    %eax,0xd80
      return (void*)(p + 1);
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	83 c0 08             	add    $0x8,%eax
 a50:	eb 3b                	jmp    a8d <malloc+0xe1>
    }
    if(p == freep)
 a52:	a1 80 0d 00 00       	mov    0xd80,%eax
 a57:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a5a:	75 1e                	jne    a7a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a5c:	83 ec 0c             	sub    $0xc,%esp
 a5f:	ff 75 ec             	pushl  -0x14(%ebp)
 a62:	e8 e5 fe ff ff       	call   94c <morecore>
 a67:	83 c4 10             	add    $0x10,%esp
 a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a71:	75 07                	jne    a7a <malloc+0xce>
        return 0;
 a73:	b8 00 00 00 00       	mov    $0x0,%eax
 a78:	eb 13                	jmp    a8d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	8b 00                	mov    (%eax),%eax
 a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a88:	e9 6d ff ff ff       	jmp    9fa <malloc+0x4e>
}
 a8d:	c9                   	leave  
 a8e:	c3                   	ret    
