
_p5-test:     file format elf32-i386


Disassembly of section .text:

00000000 <canRun>:
#include "stat.h"
#include "p5-test.h"

static int
canRun(char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int rc, uid, gid;
  struct stat st;

  uid = getuid();
       6:	e8 e1 13 00 00       	call   13ec <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 e1 13 00 00       	call   13f4 <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 cc             	lea    -0x34(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 38 12 00 00       	call   125d <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 d4 18 00 00       	push   $0x18d4
      39:	68 e4 18 00 00       	push   $0x18e4
      3e:	6a 02                	push   $0x2
      40:	e8 d6 14 00 00       	call   151b <printf>
      45:	83 c4 10             	add    $0x10,%esp
      48:	b8 00 00 00 00       	mov    $0x0,%eax
      4d:	e9 93 00 00 00       	jmp    e5 <canRun+0xe5>
  if (uid == st.uid) {
      52:	8b 55 e0             	mov    -0x20(%ebp),%edx
      55:	8b 45 f4             	mov    -0xc(%ebp),%eax
      58:	39 c2                	cmp    %eax,%edx
      5a:	75 2b                	jne    87 <canRun+0x87>
    if (st.mode.flags.u_x)
      5c:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      60:	83 e0 40             	and    $0x40,%eax
      63:	84 c0                	test   %al,%al
      65:	74 07                	je     6e <canRun+0x6e>
      return TRUE;
      67:	b8 01 00 00 00       	mov    $0x1,%eax
      6c:	eb 77                	jmp    e5 <canRun+0xe5>
    else {
      printf(2, "UID match. Execute permission for user not set.\n");
      6e:	83 ec 08             	sub    $0x8,%esp
      71:	68 f8 18 00 00       	push   $0x18f8
      76:	6a 02                	push   $0x2
      78:	e8 9e 14 00 00       	call   151b <printf>
      7d:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      80:	b8 00 00 00 00       	mov    $0x0,%eax
      85:	eb 5e                	jmp    e5 <canRun+0xe5>
    }
  }
  if (gid == st.gid) {
      87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      8d:	39 c2                	cmp    %eax,%edx
      8f:	75 2b                	jne    bc <canRun+0xbc>
    if (st.mode.flags.g_x)
      91:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      95:	83 e0 08             	and    $0x8,%eax
      98:	84 c0                	test   %al,%al
      9a:	74 07                	je     a3 <canRun+0xa3>
      return TRUE;
      9c:	b8 01 00 00 00       	mov    $0x1,%eax
      a1:	eb 42                	jmp    e5 <canRun+0xe5>
    else {
      printf(2, "GID match. Execute permission for group not set.\n");
      a3:	83 ec 08             	sub    $0x8,%esp
      a6:	68 2c 19 00 00       	push   $0x192c
      ab:	6a 02                	push   $0x2
      ad:	e8 69 14 00 00       	call   151b <printf>
      b2:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      b5:	b8 00 00 00 00       	mov    $0x0,%eax
      ba:	eb 29                	jmp    e5 <canRun+0xe5>
    }
  }
  if (st.mode.flags.o_x) {
      bc:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      c0:	83 e0 01             	and    $0x1,%eax
      c3:	84 c0                	test   %al,%al
      c5:	74 07                	je     ce <canRun+0xce>
    return TRUE;
      c7:	b8 01 00 00 00       	mov    $0x1,%eax
      cc:	eb 17                	jmp    e5 <canRun+0xe5>
  }

  printf(2, "Execute permission for other not set.\n");
      ce:	83 ec 08             	sub    $0x8,%esp
      d1:	68 60 19 00 00       	push   $0x1960
      d6:	6a 02                	push   $0x2
      d8:	e8 3e 14 00 00       	call   151b <printf>
      dd:	83 c4 10             	add    $0x10,%esp
  return FALSE;  // failure. Can't run
      e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e5:	c9                   	leave  
      e6:	c3                   	ret    

000000e7 <doSetuidTest>:

static int
doSetuidTest (char **cmd)
{
      e7:	55                   	push   %ebp
      e8:	89 e5                	mov    %esp,%ebp
      ea:	53                   	push   %ebx
      eb:	83 ec 24             	sub    $0x24,%esp
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};
      ee:	c7 45 e0 87 19 00 00 	movl   $0x1987,-0x20(%ebp)
      f5:	c7 45 e4 91 19 00 00 	movl   $0x1991,-0x1c(%ebp)
      fc:	c7 45 e8 9b 19 00 00 	movl   $0x199b,-0x18(%ebp)
     103:	c7 45 ec a1 19 00 00 	movl   $0x19a1,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10a:	83 ec 08             	sub    $0x8,%esp
     10d:	68 ad 19 00 00       	push   $0x19ad
     112:	6a 01                	push   $0x1
     114:	e8 02 14 00 00       	call   151b <printf>
     119:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     11c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     123:	e9 71 02 00 00       	jmp    399 <doSetuidTest+0x2b2>
    printf(1, "Starting test: %s.\n", test[i]);
     128:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12b:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     12f:	83 ec 04             	sub    $0x4,%esp
     132:	50                   	push   %eax
     133:	68 c9 19 00 00       	push   $0x19c9
     138:	6a 01                	push   $0x1
     13a:	e8 dc 13 00 00       	call   151b <printf>
     13f:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     142:	8b 45 f4             	mov    -0xc(%ebp),%eax
     145:	c1 e0 04             	shl    $0x4,%eax
     148:	05 c0 25 00 00       	add    $0x25c0,%eax
     14d:	8b 00                	mov    (%eax),%eax
     14f:	83 ec 0c             	sub    $0xc,%esp
     152:	50                   	push   %eax
     153:	e8 ac 12 00 00       	call   1404 <setuid>
     158:	83 c4 10             	add    $0x10,%esp
     15b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     15e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     162:	74 21                	je     185 <doSetuidTest+0x9e>
     164:	83 ec 04             	sub    $0x4,%esp
     167:	68 dd 19 00 00       	push   $0x19dd
     16c:	68 e4 18 00 00       	push   $0x18e4
     171:	6a 02                	push   $0x2
     173:	e8 a3 13 00 00       	call   151b <printf>
     178:	83 c4 10             	add    $0x10,%esp
     17b:	b8 00 00 00 00       	mov    $0x0,%eax
     180:	e9 4f 02 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    check(setgid(testperms[i][procgid]));
     185:	8b 45 f4             	mov    -0xc(%ebp),%eax
     188:	c1 e0 04             	shl    $0x4,%eax
     18b:	05 c4 25 00 00       	add    $0x25c4,%eax
     190:	8b 00                	mov    (%eax),%eax
     192:	83 ec 0c             	sub    $0xc,%esp
     195:	50                   	push   %eax
     196:	e8 71 12 00 00       	call   140c <setgid>
     19b:	83 c4 10             	add    $0x10,%esp
     19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a5:	74 21                	je     1c8 <doSetuidTest+0xe1>
     1a7:	83 ec 04             	sub    $0x4,%esp
     1aa:	68 fb 19 00 00       	push   $0x19fb
     1af:	68 e4 18 00 00       	push   $0x18e4
     1b4:	6a 02                	push   $0x2
     1b6:	e8 60 13 00 00       	call   151b <printf>
     1bb:	83 c4 10             	add    $0x10,%esp
     1be:	b8 00 00 00 00       	mov    $0x0,%eax
     1c3:	e9 0c 02 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1c8:	e8 27 12 00 00       	call   13f4 <getgid>
     1cd:	89 c3                	mov    %eax,%ebx
     1cf:	e8 18 12 00 00       	call   13ec <getuid>
     1d4:	53                   	push   %ebx
     1d5:	50                   	push   %eax
     1d6:	68 19 1a 00 00       	push   $0x1a19
     1db:	6a 01                	push   $0x1
     1dd:	e8 39 13 00 00       	call   151b <printf>
     1e2:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1e8:	c1 e0 04             	shl    $0x4,%eax
     1eb:	05 c8 25 00 00       	add    $0x25c8,%eax
     1f0:	8b 10                	mov    (%eax),%edx
     1f2:	8b 45 08             	mov    0x8(%ebp),%eax
     1f5:	8b 00                	mov    (%eax),%eax
     1f7:	83 ec 08             	sub    $0x8,%esp
     1fa:	52                   	push   %edx
     1fb:	50                   	push   %eax
     1fc:	e8 33 12 00 00       	call   1434 <chown>
     201:	83 c4 10             	add    $0x10,%esp
     204:	89 45 f0             	mov    %eax,-0x10(%ebp)
     207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20b:	74 21                	je     22e <doSetuidTest+0x147>
     20d:	83 ec 04             	sub    $0x4,%esp
     210:	68 34 1a 00 00       	push   $0x1a34
     215:	68 e4 18 00 00       	push   $0x18e4
     21a:	6a 02                	push   $0x2
     21c:	e8 fa 12 00 00       	call   151b <printf>
     221:	83 c4 10             	add    $0x10,%esp
     224:	b8 00 00 00 00       	mov    $0x0,%eax
     229:	e9 a6 01 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    check(chgrp(cmd[0], testperms[i][filegid]));
     22e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     231:	c1 e0 04             	shl    $0x4,%eax
     234:	05 cc 25 00 00       	add    $0x25cc,%eax
     239:	8b 10                	mov    (%eax),%edx
     23b:	8b 45 08             	mov    0x8(%ebp),%eax
     23e:	8b 00                	mov    (%eax),%eax
     240:	83 ec 08             	sub    $0x8,%esp
     243:	52                   	push   %edx
     244:	50                   	push   %eax
     245:	e8 f2 11 00 00       	call   143c <chgrp>
     24a:	83 c4 10             	add    $0x10,%esp
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	74 21                	je     277 <doSetuidTest+0x190>
     256:	83 ec 04             	sub    $0x4,%esp
     259:	68 5c 1a 00 00       	push   $0x1a5c
     25e:	68 e4 18 00 00       	push   $0x18e4
     263:	6a 02                	push   $0x2
     265:	e8 b1 12 00 00       	call   151b <printf>
     26a:	83 c4 10             	add    $0x10,%esp
     26d:	b8 00 00 00 00       	mov    $0x0,%eax
     272:	e9 5d 01 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    printf(1, "File uid: %d, gid: %d\n",
     277:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27a:	c1 e0 04             	shl    $0x4,%eax
     27d:	05 cc 25 00 00       	add    $0x25cc,%eax
     282:	8b 10                	mov    (%eax),%edx
     284:	8b 45 f4             	mov    -0xc(%ebp),%eax
     287:	c1 e0 04             	shl    $0x4,%eax
     28a:	05 c8 25 00 00       	add    $0x25c8,%eax
     28f:	8b 00                	mov    (%eax),%eax
     291:	52                   	push   %edx
     292:	50                   	push   %eax
     293:	68 81 1a 00 00       	push   $0x1a81
     298:	6a 01                	push   $0x1
     29a:	e8 7c 12 00 00       	call   151b <printf>
     29f:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], perms[i]));
     2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a5:	8b 14 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%edx
     2ac:	8b 45 08             	mov    0x8(%ebp),%eax
     2af:	8b 00                	mov    (%eax),%eax
     2b1:	83 ec 08             	sub    $0x8,%esp
     2b4:	52                   	push   %edx
     2b5:	50                   	push   %eax
     2b6:	e8 71 11 00 00       	call   142c <chmod>
     2bb:	83 c4 10             	add    $0x10,%esp
     2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2c5:	74 21                	je     2e8 <doSetuidTest+0x201>
     2c7:	83 ec 04             	sub    $0x4,%esp
     2ca:	68 98 1a 00 00       	push   $0x1a98
     2cf:	68 e4 18 00 00       	push   $0x18e4
     2d4:	6a 02                	push   $0x2
     2d6:	e8 40 12 00 00       	call   151b <printf>
     2db:	83 c4 10             	add    $0x10,%esp
     2de:	b8 00 00 00 00       	mov    $0x0,%eax
     2e3:	e9 ec 00 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    printf(1, "perms set to %s for %s\n", perms[i], cmd[0]);
     2e8:	8b 45 08             	mov    0x8(%ebp),%eax
     2eb:	8b 10                	mov    (%eax),%edx
     2ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f0:	8b 04 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%eax
     2f7:	52                   	push   %edx
     2f8:	50                   	push   %eax
     2f9:	68 b0 1a 00 00       	push   $0x1ab0
     2fe:	6a 01                	push   $0x1
     300:	e8 16 12 00 00       	call   151b <printf>
     305:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     308:	e8 27 10 00 00       	call   1334 <fork>
     30d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     310:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     314:	79 1c                	jns    332 <doSetuidTest+0x24b>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     316:	83 ec 08             	sub    $0x8,%esp
     319:	68 c8 1a 00 00       	push   $0x1ac8
     31e:	6a 02                	push   $0x2
     320:	e8 f6 11 00 00       	call   151b <printf>
     325:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     328:	b8 00 00 00 00       	mov    $0x0,%eax
     32d:	e9 a2 00 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    }
    if (rc == 0) {   // child
     332:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     336:	75 58                	jne    390 <doSetuidTest+0x2a9>
      exec(cmd[0], cmd);
     338:	8b 45 08             	mov    0x8(%ebp),%eax
     33b:	8b 00                	mov    (%eax),%eax
     33d:	83 ec 08             	sub    $0x8,%esp
     340:	ff 75 08             	pushl  0x8(%ebp)
     343:	50                   	push   %eax
     344:	e8 2b 10 00 00       	call   1374 <exec>
     349:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     34c:	a1 a0 25 00 00       	mov    0x25a0,%eax
     351:	83 e8 01             	sub    $0x1,%eax
     354:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     357:	74 1a                	je     373 <doSetuidTest+0x28c>
     359:	8b 45 08             	mov    0x8(%ebp),%eax
     35c:	8b 00                	mov    (%eax),%eax
     35e:	83 ec 04             	sub    $0x4,%esp
     361:	50                   	push   %eax
     362:	68 10 1b 00 00       	push   $0x1b10
     367:	6a 02                	push   $0x2
     369:	e8 ad 11 00 00       	call   151b <printf>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	eb 18                	jmp    38b <doSetuidTest+0x2a4>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     373:	8b 45 08             	mov    0x8(%ebp),%eax
     376:	8b 00                	mov    (%eax),%eax
     378:	83 ec 04             	sub    $0x4,%esp
     37b:	50                   	push   %eax
     37c:	68 34 1b 00 00       	push   $0x1b34
     381:	6a 02                	push   $0x2
     383:	e8 93 11 00 00       	call   151b <printf>
     388:	83 c4 10             	add    $0x10,%esp
      exit();
     38b:	e8 ac 0f 00 00       	call   133c <exit>
    }
    wait();
     390:	e8 af 0f 00 00       	call   1344 <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     395:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     399:	a1 a0 25 00 00       	mov    0x25a0,%eax
     39e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     3a1:	0f 8c 81 fd ff ff    	jl     128 <doSetuidTest+0x41>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chmod(cmd[0], 0755);  // total hack but necessary. sigh
     3a7:	8b 45 08             	mov    0x8(%ebp),%eax
     3aa:	8b 00                	mov    (%eax),%eax
     3ac:	83 ec 08             	sub    $0x8,%esp
     3af:	68 ed 01 00 00       	push   $0x1ed
     3b4:	50                   	push   %eax
     3b5:	e8 72 10 00 00       	call   142c <chmod>
     3ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3bd:	83 ec 08             	sub    $0x8,%esp
     3c0:	68 61 1b 00 00       	push   $0x1b61
     3c5:	6a 01                	push   $0x1
     3c7:	e8 4f 11 00 00       	call   151b <printf>
     3cc:	83 c4 10             	add    $0x10,%esp
  return PASS;
     3cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
     3d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3d7:	c9                   	leave  
     3d8:	c3                   	ret    

000003d9 <doUidTest>:

static int
doUidTest (char **cmd)
{
     3d9:	55                   	push   %ebp
     3da:	89 e5                	mov    %esp,%ebp
     3dc:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, startuid, testuid, baduidcount = 3;
     3df:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int baduids[] = {32767+5, -41, ~0};  // 32767 is max value
     3e6:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     3ed:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     3f4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setuid() test.\n\n");
     3fb:	83 ec 08             	sub    $0x8,%esp
     3fe:	68 6e 1b 00 00       	push   $0x1b6e
     403:	6a 01                	push   $0x1
     405:	e8 11 11 00 00       	call   151b <printf>
     40a:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     40d:	e8 da 0f 00 00       	call   13ec <getuid>
     412:	89 45 ec             	mov    %eax,-0x14(%ebp)
     415:	8b 45 ec             	mov    -0x14(%ebp),%eax
     418:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testuid = ++uid;
     41b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     41f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setuid(testuid);
     425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     428:	83 ec 0c             	sub    $0xc,%esp
     42b:	50                   	push   %eax
     42c:	e8 d3 0f 00 00       	call   1404 <setuid>
     431:	83 c4 10             	add    $0x10,%esp
     434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     43b:	74 1c                	je     459 <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     43d:	83 ec 08             	sub    $0x8,%esp
     440:	68 8c 1b 00 00       	push   $0x1b8c
     445:	6a 02                	push   $0x2
     447:	e8 cf 10 00 00       	call   151b <printf>
     44c:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     44f:	b8 00 00 00 00       	mov    $0x0,%eax
     454:	e9 07 01 00 00       	jmp    560 <doUidTest+0x187>
  }
  uid = getuid();
     459:	e8 8e 0f 00 00       	call   13ec <getuid>
     45e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     461:	8b 45 ec             	mov    -0x14(%ebp),%eax
     464:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     467:	74 31                	je     49a <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     469:	83 ec 08             	sub    $0x8,%esp
     46c:	68 b4 1b 00 00       	push   $0x1bb4
     471:	6a 02                	push   $0x2
     473:	e8 a3 10 00 00       	call   151b <printf>
     478:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     47b:	ff 75 ec             	pushl  -0x14(%ebp)
     47e:	ff 75 e4             	pushl  -0x1c(%ebp)
     481:	68 ec 1b 00 00       	push   $0x1bec
     486:	6a 02                	push   $0x2
     488:	e8 8e 10 00 00       	call   151b <printf>
     48d:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     490:	b8 00 00 00 00       	mov    $0x0,%eax
     495:	e9 c6 00 00 00       	jmp    560 <doUidTest+0x187>
  }
  for (i=0; i<baduidcount; i++) {
     49a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4a1:	e9 88 00 00 00       	jmp    52e <doUidTest+0x155>
    rc = setuid(baduids[i]);
     4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a9:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4ad:	83 ec 0c             	sub    $0xc,%esp
     4b0:	50                   	push   %eax
     4b1:	e8 4e 0f 00 00       	call   1404 <setuid>
     4b6:	83 c4 10             	add    $0x10,%esp
     4b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     4bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     4c0:	75 21                	jne    4e3 <doUidTest+0x10a>
      printf(2, "Tried to set the uid to a bad value (%d) and setuid()failed to fail. rc == %d\n",
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4c9:	ff 75 e0             	pushl  -0x20(%ebp)
     4cc:	50                   	push   %eax
     4cd:	68 10 1c 00 00       	push   $0x1c10
     4d2:	6a 02                	push   $0x2
     4d4:	e8 42 10 00 00       	call   151b <printf>
     4d9:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4dc:	b8 00 00 00 00       	mov    $0x0,%eax
     4e1:	eb 7d                	jmp    560 <doUidTest+0x187>
    }
    rc = getuid();
     4e3:	e8 04 0f 00 00       	call   13ec <getuid>
     4e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (baduids[i] == rc) {
     4eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ee:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4f2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     4f5:	75 33                	jne    52a <doUidTest+0x151>
      printf(2, "ERROR! Gave setuid() a bad value (%d) and it failed to fail. gid: %d\n",
     4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fa:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4fe:	ff 75 e0             	pushl  -0x20(%ebp)
     501:	50                   	push   %eax
     502:	68 60 1c 00 00       	push   $0x1c60
     507:	6a 02                	push   $0x2
     509:	e8 0d 10 00 00       	call   151b <printf>
     50e:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     511:	83 ec 08             	sub    $0x8,%esp
     514:	68 a8 1c 00 00       	push   $0x1ca8
     519:	6a 02                	push   $0x2
     51b:	e8 fb 0f 00 00       	call   151b <printf>
     520:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     523:	b8 00 00 00 00       	mov    $0x0,%eax
     528:	eb 36                	jmp    560 <doUidTest+0x187>
  if (uid != testuid) {
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
    return NOPASS;
  }
  for (i=0; i<baduidcount; i++) {
     52a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     531:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     534:	0f 8c 6c ff ff ff    	jl     4a6 <doUidTest+0xcd>
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setuid(startuid);
     53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     53d:	83 ec 0c             	sub    $0xc,%esp
     540:	50                   	push   %eax
     541:	e8 be 0e 00 00       	call   1404 <setuid>
     546:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     549:	83 ec 08             	sub    $0x8,%esp
     54c:	68 61 1b 00 00       	push   $0x1b61
     551:	6a 01                	push   $0x1
     553:	e8 c3 0f 00 00       	call   151b <printf>
     558:	83 c4 10             	add    $0x10,%esp
  return PASS;
     55b:	b8 01 00 00 00       	mov    $0x1,%eax
}
     560:	c9                   	leave  
     561:	c3                   	ret    

00000562 <doGidTest>:

static int
doGidTest (char **cmd)
{
     562:	55                   	push   %ebp
     563:	89 e5                	mov    %esp,%ebp
     565:	83 ec 38             	sub    $0x38,%esp
  int i, rc, gid, startgid, testgid, badgidcount = 3;
     568:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int badgids[] = {32767+5, -41, ~0};  // 32767 is max value
     56f:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     576:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     57d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setgid() test.\n\n");
     584:	83 ec 08             	sub    $0x8,%esp
     587:	68 d6 1c 00 00       	push   $0x1cd6
     58c:	6a 01                	push   $0x1
     58e:	e8 88 0f 00 00       	call   151b <printf>
     593:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     596:	e8 59 0e 00 00       	call   13f4 <getgid>
     59b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     59e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testgid = ++gid;
     5a4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     5a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setgid(testgid);
     5ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5b1:	83 ec 0c             	sub    $0xc,%esp
     5b4:	50                   	push   %eax
     5b5:	e8 52 0e 00 00       	call   140c <setgid>
     5ba:	83 c4 10             	add    $0x10,%esp
     5bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5c4:	74 1c                	je     5e2 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5c6:	83 ec 08             	sub    $0x8,%esp
     5c9:	68 f4 1c 00 00       	push   $0x1cf4
     5ce:	6a 02                	push   $0x2
     5d0:	e8 46 0f 00 00       	call   151b <printf>
     5d5:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5d8:	b8 00 00 00 00       	mov    $0x0,%eax
     5dd:	e9 07 01 00 00       	jmp    6e9 <doGidTest+0x187>
  }
  gid = getgid();
     5e2:	e8 0d 0e 00 00       	call   13f4 <getgid>
     5e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     5f0:	74 31                	je     623 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     5f2:	83 ec 08             	sub    $0x8,%esp
     5f5:	68 1c 1d 00 00       	push   $0x1d1c
     5fa:	6a 02                	push   $0x2
     5fc:	e8 1a 0f 00 00       	call   151b <printf>
     601:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     604:	ff 75 ec             	pushl  -0x14(%ebp)
     607:	ff 75 e4             	pushl  -0x1c(%ebp)
     60a:	68 54 1d 00 00       	push   $0x1d54
     60f:	6a 02                	push   $0x2
     611:	e8 05 0f 00 00       	call   151b <printf>
     616:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     619:	b8 00 00 00 00       	mov    $0x0,%eax
     61e:	e9 c6 00 00 00       	jmp    6e9 <doGidTest+0x187>
  }
  for (i=0; i<badgidcount; i++) {
     623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     62a:	e9 88 00 00 00       	jmp    6b7 <doGidTest+0x155>
    rc = setgid(badgids[i]); 
     62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     632:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     636:	83 ec 0c             	sub    $0xc,%esp
     639:	50                   	push   %eax
     63a:	e8 cd 0d 00 00       	call   140c <setgid>
     63f:	83 c4 10             	add    $0x10,%esp
     642:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     645:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     649:	75 21                	jne    66c <doGidTest+0x10a>
      printf(2, "Tried to set the gid to a bad value (%d) and setgid()failed to fail. rc == %d\n",
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     652:	ff 75 e0             	pushl  -0x20(%ebp)
     655:	50                   	push   %eax
     656:	68 78 1d 00 00       	push   $0x1d78
     65b:	6a 02                	push   $0x2
     65d:	e8 b9 0e 00 00       	call   151b <printf>
     662:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     665:	b8 00 00 00 00       	mov    $0x0,%eax
     66a:	eb 7d                	jmp    6e9 <doGidTest+0x187>
    }
    rc = getgid();
     66c:	e8 83 0d 00 00       	call   13f4 <getgid>
     671:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (badgids[i] == rc) {
     674:	8b 45 f4             	mov    -0xc(%ebp),%eax
     677:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     67b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     67e:	75 33                	jne    6b3 <doGidTest+0x151>
      printf(2, "ERROR! Gave setgid() a bad value (%d) and it failed to fail. gid: %d\n",
     680:	8b 45 f4             	mov    -0xc(%ebp),%eax
     683:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     687:	ff 75 e0             	pushl  -0x20(%ebp)
     68a:	50                   	push   %eax
     68b:	68 c8 1d 00 00       	push   $0x1dc8
     690:	6a 02                	push   $0x2
     692:	e8 84 0e 00 00       	call   151b <printf>
     697:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     69a:	83 ec 08             	sub    $0x8,%esp
     69d:	68 10 1e 00 00       	push   $0x1e10
     6a2:	6a 02                	push   $0x2
     6a4:	e8 72 0e 00 00       	call   151b <printf>
     6a9:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     6ac:	b8 00 00 00 00       	mov    $0x0,%eax
     6b1:	eb 36                	jmp    6e9 <doGidTest+0x187>
  if (gid != testgid) {
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
    return NOPASS;
  }
  for (i=0; i<badgidcount; i++) {
     6b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     6bd:	0f 8c 6c ff ff ff    	jl     62f <doGidTest+0xcd>
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setgid(startgid);
     6c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6c6:	83 ec 0c             	sub    $0xc,%esp
     6c9:	50                   	push   %eax
     6ca:	e8 3d 0d 00 00       	call   140c <setgid>
     6cf:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6d2:	83 ec 08             	sub    $0x8,%esp
     6d5:	68 61 1b 00 00       	push   $0x1b61
     6da:	6a 01                	push   $0x1
     6dc:	e8 3a 0e 00 00       	call   151b <printf>
     6e1:	83 c4 10             	add    $0x10,%esp
  return PASS;
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
     6e9:	c9                   	leave  
     6ea:	c3                   	ret    

000006eb <doChmodTest>:

static int
doChmodTest(char **cmd) 
{
     6eb:	55                   	push   %ebp
     6ec:	89 e5                	mov    %esp,%ebp
     6ee:	83 ec 38             	sub    $0x38,%esp
  int i, rc, mode, testmode;
  struct stat st;

  printf(1, "\nExecuting chmod() test.\n\n");
     6f1:	83 ec 08             	sub    $0x8,%esp
     6f4:	68 3e 1e 00 00       	push   $0x1e3e
     6f9:	6a 01                	push   $0x1
     6fb:	e8 1b 0e 00 00       	call   151b <printf>
     700:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     703:	8b 45 08             	mov    0x8(%ebp),%eax
     706:	8b 00                	mov    (%eax),%eax
     708:	83 ec 08             	sub    $0x8,%esp
     70b:	8d 55 c8             	lea    -0x38(%ebp),%edx
     70e:	52                   	push   %edx
     70f:	50                   	push   %eax
     710:	e8 48 0b 00 00       	call   125d <stat>
     715:	83 c4 10             	add    $0x10,%esp
     718:	89 45 f0             	mov    %eax,-0x10(%ebp)
     71b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     71f:	74 21                	je     742 <doChmodTest+0x57>
     721:	83 ec 04             	sub    $0x4,%esp
     724:	68 59 1e 00 00       	push   $0x1e59
     729:	68 e4 18 00 00       	push   $0x18e4
     72e:	6a 02                	push   $0x2
     730:	e8 e6 0d 00 00       	call   151b <printf>
     735:	83 c4 10             	add    $0x10,%esp
     738:	b8 00 00 00 00       	mov    $0x0,%eax
     73d:	e9 46 01 00 00       	jmp    888 <doChmodTest+0x19d>
  mode = st.mode.asInt;
     742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     745:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     74f:	e9 f9 00 00 00       	jmp    84d <doChmodTest+0x162>
    check(chmod(cmd[0], perms[i]));
     754:	8b 45 f4             	mov    -0xc(%ebp),%eax
     757:	8b 14 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%edx
     75e:	8b 45 08             	mov    0x8(%ebp),%eax
     761:	8b 00                	mov    (%eax),%eax
     763:	83 ec 08             	sub    $0x8,%esp
     766:	52                   	push   %edx
     767:	50                   	push   %eax
     768:	e8 bf 0c 00 00       	call   142c <chmod>
     76d:	83 c4 10             	add    $0x10,%esp
     770:	89 45 f0             	mov    %eax,-0x10(%ebp)
     773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     777:	74 21                	je     79a <doChmodTest+0xaf>
     779:	83 ec 04             	sub    $0x4,%esp
     77c:	68 98 1a 00 00       	push   $0x1a98
     781:	68 e4 18 00 00       	push   $0x18e4
     786:	6a 02                	push   $0x2
     788:	e8 8e 0d 00 00       	call   151b <printf>
     78d:	83 c4 10             	add    $0x10,%esp
     790:	b8 00 00 00 00       	mov    $0x0,%eax
     795:	e9 ee 00 00 00       	jmp    888 <doChmodTest+0x19d>
    check(stat(cmd[0], &st));
     79a:	8b 45 08             	mov    0x8(%ebp),%eax
     79d:	8b 00                	mov    (%eax),%eax
     79f:	83 ec 08             	sub    $0x8,%esp
     7a2:	8d 55 c8             	lea    -0x38(%ebp),%edx
     7a5:	52                   	push   %edx
     7a6:	50                   	push   %eax
     7a7:	e8 b1 0a 00 00       	call   125d <stat>
     7ac:	83 c4 10             	add    $0x10,%esp
     7af:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7b6:	74 21                	je     7d9 <doChmodTest+0xee>
     7b8:	83 ec 04             	sub    $0x4,%esp
     7bb:	68 59 1e 00 00       	push   $0x1e59
     7c0:	68 e4 18 00 00       	push   $0x18e4
     7c5:	6a 02                	push   $0x2
     7c7:	e8 4f 0d 00 00       	call   151b <printf>
     7cc:	83 c4 10             	add    $0x10,%esp
     7cf:	b8 00 00 00 00       	mov    $0x0,%eax
     7d4:	e9 af 00 00 00       	jmp    888 <doChmodTest+0x19d>
    testmode = st.mode.asInt;
     7d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) {
     7df:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7e5:	75 3a                	jne    821 <doChmodTest+0x136>
      printf(2, "Error! Unable to test.\n");
     7e7:	83 ec 08             	sub    $0x8,%esp
     7ea:	68 6b 1e 00 00       	push   $0x1e6b
     7ef:	6a 02                	push   $0x2
     7f1:	e8 25 0d 00 00       	call   151b <printf>
     7f6:	83 c4 10             	add    $0x10,%esp
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
     7f9:	8b 45 08             	mov    0x8(%ebp),%eax
     7fc:	8b 00                	mov    (%eax),%eax
     7fe:	83 ec 08             	sub    $0x8,%esp
     801:	ff 75 f4             	pushl  -0xc(%ebp)
     804:	50                   	push   %eax
     805:	ff 75 e8             	pushl  -0x18(%ebp)
     808:	ff 75 ec             	pushl  -0x14(%ebp)
     80b:	68 84 1e 00 00       	push   $0x1e84
     810:	6a 02                	push   $0x2
     812:	e8 04 0d 00 00       	call   151b <printf>
     817:	83 c4 20             	add    $0x20,%esp
		     mode, testmode, cmd[0], i);
      return NOPASS;
     81a:	b8 00 00 00 00       	mov    $0x0,%eax
     81f:	eb 67                	jmp    888 <doChmodTest+0x19d>
    }
    if (mode == testmode) { 
     821:	8b 45 ec             	mov    -0x14(%ebp),%eax
     824:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     827:	75 20                	jne    849 <doChmodTest+0x15e>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
     829:	68 b6 00 00 00       	push   $0xb6
     82e:	68 bf 1e 00 00       	push   $0x1ebf
     833:	68 cc 1e 00 00       	push   $0x1ecc
     838:	6a 02                	push   $0x2
     83a:	e8 dc 0c 00 00       	call   151b <printf>
     83f:	83 c4 10             	add    $0x10,%esp
		      __FILE__, __LINE__);
      return NOPASS;
     842:	b8 00 00 00 00       	mov    $0x0,%eax
     847:	eb 3f                	jmp    888 <doChmodTest+0x19d>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.asInt;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     849:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     84d:	a1 a0 25 00 00       	mov    0x25a0,%eax
     852:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     855:	0f 8c f9 fe ff ff    	jl     754 <doChmodTest+0x69>
      printf(2, "Error! chmod() failed to set permissions correctly. %s, %d\n",
		      __FILE__, __LINE__);
      return NOPASS;
    }
  }
  chmod(cmd[0], 0755); // hack
     85b:	8b 45 08             	mov    0x8(%ebp),%eax
     85e:	8b 00                	mov    (%eax),%eax
     860:	83 ec 08             	sub    $0x8,%esp
     863:	68 ed 01 00 00       	push   $0x1ed
     868:	50                   	push   %eax
     869:	e8 be 0b 00 00       	call   142c <chmod>
     86e:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     871:	83 ec 08             	sub    $0x8,%esp
     874:	68 61 1b 00 00       	push   $0x1b61
     879:	6a 01                	push   $0x1
     87b:	e8 9b 0c 00 00       	call   151b <printf>
     880:	83 c4 10             	add    $0x10,%esp
  return PASS;
     883:	b8 01 00 00 00       	mov    $0x1,%eax
}
     888:	c9                   	leave  
     889:	c3                   	ret    

0000088a <doChownTest>:

static int
doChownTest(char **cmd) 
{
     88a:	55                   	push   %ebp
     88b:	89 e5                	mov    %esp,%ebp
     88d:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     890:	83 ec 08             	sub    $0x8,%esp
     893:	68 08 1f 00 00       	push   $0x1f08
     898:	6a 01                	push   $0x1
     89a:	e8 7c 0c 00 00       	call   151b <printf>
     89f:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	8b 00                	mov    (%eax),%eax
     8a7:	83 ec 08             	sub    $0x8,%esp
     8aa:	8d 55 cc             	lea    -0x34(%ebp),%edx
     8ad:	52                   	push   %edx
     8ae:	50                   	push   %eax
     8af:	e8 a9 09 00 00       	call   125d <stat>
     8b4:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     8b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     8ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c0:	8d 50 01             	lea    0x1(%eax),%edx
     8c3:	8b 45 08             	mov    0x8(%ebp),%eax
     8c6:	8b 00                	mov    (%eax),%eax
     8c8:	83 ec 08             	sub    $0x8,%esp
     8cb:	52                   	push   %edx
     8cc:	50                   	push   %eax
     8cd:	e8 62 0b 00 00       	call   1434 <chown>
     8d2:	83 c4 10             	add    $0x10,%esp
     8d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     8d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8dc:	74 1c                	je     8fa <doChownTest+0x70>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8de:	83 ec 04             	sub    $0x4,%esp
     8e1:	ff 75 f0             	pushl  -0x10(%ebp)
     8e4:	68 24 1f 00 00       	push   $0x1f24
     8e9:	6a 02                	push   $0x2
     8eb:	e8 2b 0c 00 00       	call   151b <printf>
     8f0:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8f3:	b8 00 00 00 00       	mov    $0x0,%eax
     8f8:	eb 6a                	jmp    964 <doChownTest+0xda>
  }

  stat(cmd[0], &st);
     8fa:	8b 45 08             	mov    0x8(%ebp),%eax
     8fd:	8b 00                	mov    (%eax),%eax
     8ff:	83 ec 08             	sub    $0x8,%esp
     902:	8d 55 cc             	lea    -0x34(%ebp),%edx
     905:	52                   	push   %edx
     906:	50                   	push   %eax
     907:	e8 51 09 00 00       	call   125d <stat>
     90c:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     90f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     912:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     915:	8b 45 f4             	mov    -0xc(%ebp),%eax
     918:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     91b:	75 1c                	jne    939 <doChownTest+0xaf>
    printf(2, "Error! test failed. Old uid: %d, new uid: uid2, should differ\n",
     91d:	ff 75 ec             	pushl  -0x14(%ebp)
     920:	ff 75 f4             	pushl  -0xc(%ebp)
     923:	68 5c 1f 00 00       	push   $0x1f5c
     928:	6a 02                	push   $0x2
     92a:	e8 ec 0b 00 00       	call   151b <printf>
     92f:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     932:	b8 00 00 00 00       	mov    $0x0,%eax
     937:	eb 2b                	jmp    964 <doChownTest+0xda>
  }
  chown(cmd[0], uid1);  // put back the original
     939:	8b 45 08             	mov    0x8(%ebp),%eax
     93c:	8b 00                	mov    (%eax),%eax
     93e:	83 ec 08             	sub    $0x8,%esp
     941:	ff 75 f4             	pushl  -0xc(%ebp)
     944:	50                   	push   %eax
     945:	e8 ea 0a 00 00       	call   1434 <chown>
     94a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     94d:	83 ec 08             	sub    $0x8,%esp
     950:	68 61 1b 00 00       	push   $0x1b61
     955:	6a 01                	push   $0x1
     957:	e8 bf 0b 00 00       	call   151b <printf>
     95c:	83 c4 10             	add    $0x10,%esp
  return PASS;
     95f:	b8 01 00 00 00       	mov    $0x1,%eax
}
     964:	c9                   	leave  
     965:	c3                   	ret    

00000966 <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     966:	55                   	push   %ebp
     967:	89 e5                	mov    %esp,%ebp
     969:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     96c:	83 ec 08             	sub    $0x8,%esp
     96f:	68 9b 1f 00 00       	push   $0x1f9b
     974:	6a 01                	push   $0x1
     976:	e8 a0 0b 00 00       	call   151b <printf>
     97b:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     97e:	8b 45 08             	mov    0x8(%ebp),%eax
     981:	8b 00                	mov    (%eax),%eax
     983:	83 ec 08             	sub    $0x8,%esp
     986:	8d 55 cc             	lea    -0x34(%ebp),%edx
     989:	52                   	push   %edx
     98a:	50                   	push   %eax
     98b:	e8 cd 08 00 00       	call   125d <stat>
     990:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     996:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     999:	8b 45 f4             	mov    -0xc(%ebp),%eax
     99c:	8d 50 01             	lea    0x1(%eax),%edx
     99f:	8b 45 08             	mov    0x8(%ebp),%eax
     9a2:	8b 00                	mov    (%eax),%eax
     9a4:	83 ec 08             	sub    $0x8,%esp
     9a7:	52                   	push   %edx
     9a8:	50                   	push   %eax
     9a9:	e8 8e 0a 00 00       	call   143c <chgrp>
     9ae:	83 c4 10             	add    $0x10,%esp
     9b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     9b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9b8:	74 19                	je     9d3 <doChgrpTest+0x6d>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     9ba:	83 ec 08             	sub    $0x8,%esp
     9bd:	68 b4 1f 00 00       	push   $0x1fb4
     9c2:	6a 02                	push   $0x2
     9c4:	e8 52 0b 00 00       	call   151b <printf>
     9c9:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     9cc:	b8 00 00 00 00       	mov    $0x0,%eax
     9d1:	eb 6a                	jmp    a3d <doChgrpTest+0xd7>
  }

  stat(cmd[0], &st);
     9d3:	8b 45 08             	mov    0x8(%ebp),%eax
     9d6:	8b 00                	mov    (%eax),%eax
     9d8:	83 ec 08             	sub    $0x8,%esp
     9db:	8d 55 cc             	lea    -0x34(%ebp),%edx
     9de:	52                   	push   %edx
     9df:	50                   	push   %eax
     9e0:	e8 78 08 00 00       	call   125d <stat>
     9e5:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9eb:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     9f4:	75 1c                	jne    a12 <doChgrpTest+0xac>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     9f6:	ff 75 ec             	pushl  -0x14(%ebp)
     9f9:	ff 75 f4             	pushl  -0xc(%ebp)
     9fc:	68 e4 1f 00 00       	push   $0x1fe4
     a01:	6a 02                	push   $0x2
     a03:	e8 13 0b 00 00       	call   151b <printf>
     a08:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     a0b:	b8 00 00 00 00       	mov    $0x0,%eax
     a10:	eb 2b                	jmp    a3d <doChgrpTest+0xd7>
  }
  chown(cmd[0], gid1);  // put back the original
     a12:	8b 45 08             	mov    0x8(%ebp),%eax
     a15:	8b 00                	mov    (%eax),%eax
     a17:	83 ec 08             	sub    $0x8,%esp
     a1a:	ff 75 f4             	pushl  -0xc(%ebp)
     a1d:	50                   	push   %eax
     a1e:	e8 11 0a 00 00       	call   1434 <chown>
     a23:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     a26:	83 ec 08             	sub    $0x8,%esp
     a29:	68 61 1b 00 00       	push   $0x1b61
     a2e:	6a 01                	push   $0x1
     a30:	e8 e6 0a 00 00       	call   151b <printf>
     a35:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a38:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a3d:	c9                   	leave  
     a3e:	c3                   	ret    

00000a3f <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a3f:	55                   	push   %ebp
     a40:	89 e5                	mov    %esp,%ebp
     a42:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a45:	83 ec 08             	sub    $0x8,%esp
     a48:	68 23 20 00 00       	push   $0x2023
     a4d:	6a 01                	push   $0x1
     a4f:	e8 c7 0a 00 00       	call   151b <printf>
     a54:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	8b 00                	mov    (%eax),%eax
     a5c:	83 ec 0c             	sub    $0xc,%esp
     a5f:	50                   	push   %eax
     a60:	e8 9b f5 ff ff       	call   0 <canRun>
     a65:	83 c4 10             	add    $0x10,%esp
     a68:	85 c0                	test   %eax,%eax
     a6a:	75 22                	jne    a8e <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a6c:	8b 45 08             	mov    0x8(%ebp),%eax
     a6f:	8b 00                	mov    (%eax),%eax
     a71:	83 ec 04             	sub    $0x4,%esp
     a74:	50                   	push   %eax
     a75:	68 3c 20 00 00       	push   $0x203c
     a7a:	6a 02                	push   $0x2
     a7c:	e8 9a 0a 00 00       	call   151b <printf>
     a81:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a84:	b8 00 00 00 00       	mov    $0x0,%eax
     a89:	e9 dc 02 00 00       	jmp    d6a <doExecTest+0x32b>
  }

  check(stat(cmd[0], &st));
     a8e:	8b 45 08             	mov    0x8(%ebp),%eax
     a91:	8b 00                	mov    (%eax),%eax
     a93:	83 ec 08             	sub    $0x8,%esp
     a96:	8d 55 c8             	lea    -0x38(%ebp),%edx
     a99:	52                   	push   %edx
     a9a:	50                   	push   %eax
     a9b:	e8 bd 07 00 00       	call   125d <stat>
     aa0:	83 c4 10             	add    $0x10,%esp
     aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     aa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     aaa:	74 21                	je     acd <doExecTest+0x8e>
     aac:	83 ec 04             	sub    $0x4,%esp
     aaf:	68 59 1e 00 00       	push   $0x1e59
     ab4:	68 e4 18 00 00       	push   $0x18e4
     ab9:	6a 02                	push   $0x2
     abb:	e8 5b 0a 00 00       	call   151b <printf>
     ac0:	83 c4 10             	add    $0x10,%esp
     ac3:	b8 00 00 00 00       	mov    $0x0,%eax
     ac8:	e9 9d 02 00 00       	jmp    d6a <doExecTest+0x32b>
  uid = st.uid;
     acd:	8b 45 dc             	mov    -0x24(%ebp),%eax
     ad0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ad6:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     ad9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ae0:	e9 22 02 00 00       	jmp    d07 <doExecTest+0x2c8>
    check(setuid(testperms[i][procuid]));
     ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ae8:	c1 e0 04             	shl    $0x4,%eax
     aeb:	05 c0 25 00 00       	add    $0x25c0,%eax
     af0:	8b 00                	mov    (%eax),%eax
     af2:	83 ec 0c             	sub    $0xc,%esp
     af5:	50                   	push   %eax
     af6:	e8 09 09 00 00       	call   1404 <setuid>
     afb:	83 c4 10             	add    $0x10,%esp
     afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b05:	74 21                	je     b28 <doExecTest+0xe9>
     b07:	83 ec 04             	sub    $0x4,%esp
     b0a:	68 dd 19 00 00       	push   $0x19dd
     b0f:	68 e4 18 00 00       	push   $0x18e4
     b14:	6a 02                	push   $0x2
     b16:	e8 00 0a 00 00       	call   151b <printf>
     b1b:	83 c4 10             	add    $0x10,%esp
     b1e:	b8 00 00 00 00       	mov    $0x0,%eax
     b23:	e9 42 02 00 00       	jmp    d6a <doExecTest+0x32b>
    check(setgid(testperms[i][procgid]));
     b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2b:	c1 e0 04             	shl    $0x4,%eax
     b2e:	05 c4 25 00 00       	add    $0x25c4,%eax
     b33:	8b 00                	mov    (%eax),%eax
     b35:	83 ec 0c             	sub    $0xc,%esp
     b38:	50                   	push   %eax
     b39:	e8 ce 08 00 00       	call   140c <setgid>
     b3e:	83 c4 10             	add    $0x10,%esp
     b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b48:	74 21                	je     b6b <doExecTest+0x12c>
     b4a:	83 ec 04             	sub    $0x4,%esp
     b4d:	68 fb 19 00 00       	push   $0x19fb
     b52:	68 e4 18 00 00       	push   $0x18e4
     b57:	6a 02                	push   $0x2
     b59:	e8 bd 09 00 00       	call   151b <printf>
     b5e:	83 c4 10             	add    $0x10,%esp
     b61:	b8 00 00 00 00       	mov    $0x0,%eax
     b66:	e9 ff 01 00 00       	jmp    d6a <doExecTest+0x32b>
    check(chown(cmd[0], testperms[i][fileuid]));
     b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b6e:	c1 e0 04             	shl    $0x4,%eax
     b71:	05 c8 25 00 00       	add    $0x25c8,%eax
     b76:	8b 10                	mov    (%eax),%edx
     b78:	8b 45 08             	mov    0x8(%ebp),%eax
     b7b:	8b 00                	mov    (%eax),%eax
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	52                   	push   %edx
     b81:	50                   	push   %eax
     b82:	e8 ad 08 00 00       	call   1434 <chown>
     b87:	83 c4 10             	add    $0x10,%esp
     b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b91:	74 21                	je     bb4 <doExecTest+0x175>
     b93:	83 ec 04             	sub    $0x4,%esp
     b96:	68 34 1a 00 00       	push   $0x1a34
     b9b:	68 e4 18 00 00       	push   $0x18e4
     ba0:	6a 02                	push   $0x2
     ba2:	e8 74 09 00 00       	call   151b <printf>
     ba7:	83 c4 10             	add    $0x10,%esp
     baa:	b8 00 00 00 00       	mov    $0x0,%eax
     baf:	e9 b6 01 00 00       	jmp    d6a <doExecTest+0x32b>
    check(chgrp(cmd[0], testperms[i][filegid]));
     bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bb7:	c1 e0 04             	shl    $0x4,%eax
     bba:	05 cc 25 00 00       	add    $0x25cc,%eax
     bbf:	8b 10                	mov    (%eax),%edx
     bc1:	8b 45 08             	mov    0x8(%ebp),%eax
     bc4:	8b 00                	mov    (%eax),%eax
     bc6:	83 ec 08             	sub    $0x8,%esp
     bc9:	52                   	push   %edx
     bca:	50                   	push   %eax
     bcb:	e8 6c 08 00 00       	call   143c <chgrp>
     bd0:	83 c4 10             	add    $0x10,%esp
     bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bda:	74 21                	je     bfd <doExecTest+0x1be>
     bdc:	83 ec 04             	sub    $0x4,%esp
     bdf:	68 5c 1a 00 00       	push   $0x1a5c
     be4:	68 e4 18 00 00       	push   $0x18e4
     be9:	6a 02                	push   $0x2
     beb:	e8 2b 09 00 00       	call   151b <printf>
     bf0:	83 c4 10             	add    $0x10,%esp
     bf3:	b8 00 00 00 00       	mov    $0x0,%eax
     bf8:	e9 6d 01 00 00       	jmp    d6a <doExecTest+0x32b>
    check(chmod(cmd[0], perms[i]));
     bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c00:	8b 14 85 a4 25 00 00 	mov    0x25a4(,%eax,4),%edx
     c07:	8b 45 08             	mov    0x8(%ebp),%eax
     c0a:	8b 00                	mov    (%eax),%eax
     c0c:	83 ec 08             	sub    $0x8,%esp
     c0f:	52                   	push   %edx
     c10:	50                   	push   %eax
     c11:	e8 16 08 00 00       	call   142c <chmod>
     c16:	83 c4 10             	add    $0x10,%esp
     c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c20:	74 21                	je     c43 <doExecTest+0x204>
     c22:	83 ec 04             	sub    $0x4,%esp
     c25:	68 98 1a 00 00       	push   $0x1a98
     c2a:	68 e4 18 00 00       	push   $0x18e4
     c2f:	6a 02                	push   $0x2
     c31:	e8 e5 08 00 00       	call   151b <printf>
     c36:	83 c4 10             	add    $0x10,%esp
     c39:	b8 00 00 00 00       	mov    $0x0,%eax
     c3e:	e9 27 01 00 00       	jmp    d6a <doExecTest+0x32b>
    if (i != NUMPERMSTOCHECK-1)
     c43:	a1 a0 25 00 00       	mov    0x25a0,%eax
     c48:	83 e8 01             	sub    $0x1,%eax
     c4b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c4e:	74 14                	je     c64 <doExecTest+0x225>
      printf(2, "The following test should not produce an error.\n");
     c50:	83 ec 08             	sub    $0x8,%esp
     c53:	68 60 20 00 00       	push   $0x2060
     c58:	6a 02                	push   $0x2
     c5a:	e8 bc 08 00 00       	call   151b <printf>
     c5f:	83 c4 10             	add    $0x10,%esp
     c62:	eb 12                	jmp    c76 <doExecTest+0x237>
    else
      printf(2, "The following test should fail.\n");
     c64:	83 ec 08             	sub    $0x8,%esp
     c67:	68 94 20 00 00       	push   $0x2094
     c6c:	6a 02                	push   $0x2
     c6e:	e8 a8 08 00 00       	call   151b <printf>
     c73:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c76:	e8 b9 06 00 00       	call   1334 <fork>
     c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c82:	79 1c                	jns    ca0 <doExecTest+0x261>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     c84:	83 ec 08             	sub    $0x8,%esp
     c87:	68 c8 1a 00 00       	push   $0x1ac8
     c8c:	6a 02                	push   $0x2
     c8e:	e8 88 08 00 00       	call   151b <printf>
     c93:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     c96:	b8 00 00 00 00       	mov    $0x0,%eax
     c9b:	e9 ca 00 00 00       	jmp    d6a <doExecTest+0x32b>
    }
    if (rc == 0) {   // child
     ca0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ca4:	75 58                	jne    cfe <doExecTest+0x2bf>
      exec(cmd[0], cmd);
     ca6:	8b 45 08             	mov    0x8(%ebp),%eax
     ca9:	8b 00                	mov    (%eax),%eax
     cab:	83 ec 08             	sub    $0x8,%esp
     cae:	ff 75 08             	pushl  0x8(%ebp)
     cb1:	50                   	push   %eax
     cb2:	e8 bd 06 00 00       	call   1374 <exec>
     cb7:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     cba:	a1 a0 25 00 00       	mov    0x25a0,%eax
     cbf:	83 e8 01             	sub    $0x1,%eax
     cc2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     cc5:	74 1a                	je     ce1 <doExecTest+0x2a2>
     cc7:	8b 45 08             	mov    0x8(%ebp),%eax
     cca:	8b 00                	mov    (%eax),%eax
     ccc:	83 ec 04             	sub    $0x4,%esp
     ccf:	50                   	push   %eax
     cd0:	68 10 1b 00 00       	push   $0x1b10
     cd5:	6a 02                	push   $0x2
     cd7:	e8 3f 08 00 00       	call   151b <printf>
     cdc:	83 c4 10             	add    $0x10,%esp
     cdf:	eb 18                	jmp    cf9 <doExecTest+0x2ba>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     ce1:	8b 45 08             	mov    0x8(%ebp),%eax
     ce4:	8b 00                	mov    (%eax),%eax
     ce6:	83 ec 04             	sub    $0x4,%esp
     ce9:	50                   	push   %eax
     cea:	68 34 1b 00 00       	push   $0x1b34
     cef:	6a 02                	push   $0x2
     cf1:	e8 25 08 00 00       	call   151b <printf>
     cf6:	83 c4 10             	add    $0x10,%esp
      exit();
     cf9:	e8 3e 06 00 00       	call   133c <exit>
    }
    wait();
     cfe:	e8 41 06 00 00       	call   1344 <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     d03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d07:	a1 a0 25 00 00       	mov    0x25a0,%eax
     d0c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d0f:	0f 8c d0 fd ff ff    	jl     ae5 <doExecTest+0xa6>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chown(cmd[0], uid);
     d15:	8b 45 08             	mov    0x8(%ebp),%eax
     d18:	8b 00                	mov    (%eax),%eax
     d1a:	83 ec 08             	sub    $0x8,%esp
     d1d:	ff 75 ec             	pushl  -0x14(%ebp)
     d20:	50                   	push   %eax
     d21:	e8 0e 07 00 00       	call   1434 <chown>
     d26:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d29:	8b 45 08             	mov    0x8(%ebp),%eax
     d2c:	8b 00                	mov    (%eax),%eax
     d2e:	83 ec 08             	sub    $0x8,%esp
     d31:	ff 75 e8             	pushl  -0x18(%ebp)
     d34:	50                   	push   %eax
     d35:	e8 02 07 00 00       	call   143c <chgrp>
     d3a:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 0755);
     d3d:	8b 45 08             	mov    0x8(%ebp),%eax
     d40:	8b 00                	mov    (%eax),%eax
     d42:	83 ec 08             	sub    $0x8,%esp
     d45:	68 ed 01 00 00       	push   $0x1ed
     d4a:	50                   	push   %eax
     d4b:	e8 dc 06 00 00       	call   142c <chmod>
     d50:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d53:	83 ec 08             	sub    $0x8,%esp
     d56:	68 b8 20 00 00       	push   $0x20b8
     d5b:	6a 01                	push   $0x1
     d5d:	e8 b9 07 00 00       	call   151b <printf>
     d62:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d65:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d6a:	c9                   	leave  
     d6b:	c3                   	ret    

00000d6c <printMenu>:

void
printMenu(void)
{
     d6c:	55                   	push   %ebp
     d6d:	89 e5                	mov    %esp,%ebp
     d6f:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d79:	83 ec 08             	sub    $0x8,%esp
     d7c:	68 e3 20 00 00       	push   $0x20e3
     d81:	6a 01                	push   $0x1
     d83:	e8 93 07 00 00       	call   151b <printf>
     d88:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8e:	8d 50 01             	lea    0x1(%eax),%edx
     d91:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d94:	83 ec 04             	sub    $0x4,%esp
     d97:	50                   	push   %eax
     d98:	68 e5 20 00 00       	push   $0x20e5
     d9d:	6a 01                	push   $0x1
     d9f:	e8 77 07 00 00       	call   151b <printf>
     da4:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     daa:	8d 50 01             	lea    0x1(%eax),%edx
     dad:	89 55 f4             	mov    %edx,-0xc(%ebp)
     db0:	83 ec 04             	sub    $0x4,%esp
     db3:	50                   	push   %eax
     db4:	68 f7 20 00 00       	push   $0x20f7
     db9:	6a 01                	push   $0x1
     dbb:	e8 5b 07 00 00       	call   151b <printf>
     dc0:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dc6:	8d 50 01             	lea    0x1(%eax),%edx
     dc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dcc:	83 ec 04             	sub    $0x4,%esp
     dcf:	50                   	push   %eax
     dd0:	68 05 21 00 00       	push   $0x2105
     dd5:	6a 01                	push   $0x1
     dd7:	e8 3f 07 00 00       	call   151b <printf>
     ddc:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de2:	8d 50 01             	lea    0x1(%eax),%edx
     de5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     de8:	83 ec 04             	sub    $0x4,%esp
     deb:	50                   	push   %eax
     dec:	68 13 21 00 00       	push   $0x2113
     df1:	6a 01                	push   $0x1
     df3:	e8 23 07 00 00       	call   151b <printf>
     df8:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dfe:	8d 50 01             	lea    0x1(%eax),%edx
     e01:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e04:	83 ec 04             	sub    $0x4,%esp
     e07:	50                   	push   %eax
     e08:	68 20 21 00 00       	push   $0x2120
     e0d:	6a 01                	push   $0x1
     e0f:	e8 07 07 00 00       	call   151b <printf>
     e14:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1a:	8d 50 01             	lea    0x1(%eax),%edx
     e1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e20:	83 ec 04             	sub    $0x4,%esp
     e23:	50                   	push   %eax
     e24:	68 2d 21 00 00       	push   $0x212d
     e29:	6a 01                	push   $0x1
     e2b:	e8 eb 06 00 00       	call   151b <printf>
     e30:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e36:	8d 50 01             	lea    0x1(%eax),%edx
     e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e3c:	83 ec 04             	sub    $0x4,%esp
     e3f:	50                   	push   %eax
     e40:	68 3a 21 00 00       	push   $0x213a
     e45:	6a 01                	push   $0x1
     e47:	e8 cf 06 00 00       	call   151b <printf>
     e4c:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e52:	8d 50 01             	lea    0x1(%eax),%edx
     e55:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e58:	83 ec 04             	sub    $0x4,%esp
     e5b:	50                   	push   %eax
     e5c:	68 46 21 00 00       	push   $0x2146
     e61:	6a 01                	push   $0x1
     e63:	e8 b3 06 00 00       	call   151b <printf>
     e68:	83 c4 10             	add    $0x10,%esp
}
     e6b:	90                   	nop
     e6c:	c9                   	leave  
     e6d:	c3                   	ret    

00000e6e <main>:

int
main(int argc, char *argv[])
{
     e6e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e72:	83 e4 f0             	and    $0xfffffff0,%esp
     e75:	ff 71 fc             	pushl  -0x4(%ecx)
     e78:	55                   	push   %ebp
     e79:	89 e5                	mov    %esp,%ebp
     e7b:	51                   	push   %ecx
     e7c:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"time", '\0'};
     e86:	c7 45 d8 52 21 00 00 	movl   $0x2152,-0x28(%ebp)
     e8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     e94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     e9b:	e8 cc fe ff ff       	call   d6c <printMenu>
    printf(1, "Enter test number: ");
     ea0:	83 ec 08             	sub    $0x8,%esp
     ea3:	68 57 21 00 00       	push   $0x2157
     ea8:	6a 01                	push   $0x1
     eaa:	e8 6c 06 00 00       	call   151b <printf>
     eaf:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     eb2:	83 ec 08             	sub    $0x8,%esp
     eb5:	6a 05                	push   $0x5
     eb7:	8d 45 e7             	lea    -0x19(%ebp),%eax
     eba:	50                   	push   %eax
     ebb:	e8 2e 03 00 00       	call   11ee <gets>
     ec0:	83 c4 10             	add    $0x10,%esp
    if (buf[0] == '\n') continue;
     ec3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ec7:	3c 0a                	cmp    $0xa,%al
     ec9:	0f 84 e9 01 00 00    	je     10b8 <main+0x24a>
    select = atoi(buf);
     ecf:	83 ec 0c             	sub    $0xc,%esp
     ed2:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ed5:	50                   	push   %eax
     ed6:	e8 cf 03 00 00       	call   12aa <atoi>
     edb:	83 c4 10             	add    $0x10,%esp
     ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     ee1:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     ee5:	0f 87 9b 01 00 00    	ja     1086 <main+0x218>
     eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eee:	c1 e0 02             	shl    $0x2,%eax
     ef1:	05 f8 21 00 00       	add    $0x21f8,%eax
     ef6:	8b 00                	mov    (%eax),%eax
     ef8:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     efa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     f01:	e9 a7 01 00 00       	jmp    10ad <main+0x23f>
	    case 1:
		  doTest(doUidTest,    t0); break;
     f06:	83 ec 0c             	sub    $0xc,%esp
     f09:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f0c:	50                   	push   %eax
     f0d:	e8 c7 f4 ff ff       	call   3d9 <doUidTest>
     f12:	83 c4 10             	add    $0x10,%esp
     f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f1c:	0f 85 78 01 00 00    	jne    109a <main+0x22c>
     f22:	83 ec 04             	sub    $0x4,%esp
     f25:	68 6b 21 00 00       	push   $0x216b
     f2a:	68 75 21 00 00       	push   $0x2175
     f2f:	6a 02                	push   $0x2
     f31:	e8 e5 05 00 00       	call   151b <printf>
     f36:	83 c4 10             	add    $0x10,%esp
     f39:	e8 fe 03 00 00       	call   133c <exit>
	    case 2:
		  doTest(doGidTest,    t0); break;
     f3e:	83 ec 0c             	sub    $0xc,%esp
     f41:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f44:	50                   	push   %eax
     f45:	e8 18 f6 ff ff       	call   562 <doGidTest>
     f4a:	83 c4 10             	add    $0x10,%esp
     f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f54:	0f 85 43 01 00 00    	jne    109d <main+0x22f>
     f5a:	83 ec 04             	sub    $0x4,%esp
     f5d:	68 87 21 00 00       	push   $0x2187
     f62:	68 75 21 00 00       	push   $0x2175
     f67:	6a 02                	push   $0x2
     f69:	e8 ad 05 00 00       	call   151b <printf>
     f6e:	83 c4 10             	add    $0x10,%esp
     f71:	e8 c6 03 00 00       	call   133c <exit>
	    case 3:
		  doTest(doChmodTest,  t1); break;
     f76:	83 ec 0c             	sub    $0xc,%esp
     f79:	8d 45 d8             	lea    -0x28(%ebp),%eax
     f7c:	50                   	push   %eax
     f7d:	e8 69 f7 ff ff       	call   6eb <doChmodTest>
     f82:	83 c4 10             	add    $0x10,%esp
     f85:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f8c:	0f 85 0e 01 00 00    	jne    10a0 <main+0x232>
     f92:	83 ec 04             	sub    $0x4,%esp
     f95:	68 91 21 00 00       	push   $0x2191
     f9a:	68 75 21 00 00       	push   $0x2175
     f9f:	6a 02                	push   $0x2
     fa1:	e8 75 05 00 00       	call   151b <printf>
     fa6:	83 c4 10             	add    $0x10,%esp
     fa9:	e8 8e 03 00 00       	call   133c <exit>
	    case 4:
		  doTest(doChownTest,  t1); break;
     fae:	83 ec 0c             	sub    $0xc,%esp
     fb1:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fb4:	50                   	push   %eax
     fb5:	e8 d0 f8 ff ff       	call   88a <doChownTest>
     fba:	83 c4 10             	add    $0x10,%esp
     fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fc4:	0f 85 d9 00 00 00    	jne    10a3 <main+0x235>
     fca:	83 ec 04             	sub    $0x4,%esp
     fcd:	68 9d 21 00 00       	push   $0x219d
     fd2:	68 75 21 00 00       	push   $0x2175
     fd7:	6a 02                	push   $0x2
     fd9:	e8 3d 05 00 00       	call   151b <printf>
     fde:	83 c4 10             	add    $0x10,%esp
     fe1:	e8 56 03 00 00       	call   133c <exit>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
     fe6:	83 ec 0c             	sub    $0xc,%esp
     fe9:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fec:	50                   	push   %eax
     fed:	e8 74 f9 ff ff       	call   966 <doChgrpTest>
     ff2:	83 c4 10             	add    $0x10,%esp
     ff5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ff8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ffc:	0f 85 a4 00 00 00    	jne    10a6 <main+0x238>
    1002:	83 ec 04             	sub    $0x4,%esp
    1005:	68 a9 21 00 00       	push   $0x21a9
    100a:	68 75 21 00 00       	push   $0x2175
    100f:	6a 02                	push   $0x2
    1011:	e8 05 05 00 00       	call   151b <printf>
    1016:	83 c4 10             	add    $0x10,%esp
    1019:	e8 1e 03 00 00       	call   133c <exit>
	    case 6:
		  doTest(doExecTest,   t1); break;
    101e:	83 ec 0c             	sub    $0xc,%esp
    1021:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1024:	50                   	push   %eax
    1025:	e8 15 fa ff ff       	call   a3f <doExecTest>
    102a:	83 c4 10             	add    $0x10,%esp
    102d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1030:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1034:	75 73                	jne    10a9 <main+0x23b>
    1036:	83 ec 04             	sub    $0x4,%esp
    1039:	68 b5 21 00 00       	push   $0x21b5
    103e:	68 75 21 00 00       	push   $0x2175
    1043:	6a 02                	push   $0x2
    1045:	e8 d1 04 00 00       	call   151b <printf>
    104a:	83 c4 10             	add    $0x10,%esp
    104d:	e8 ea 02 00 00       	call   133c <exit>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    1052:	83 ec 0c             	sub    $0xc,%esp
    1055:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1058:	50                   	push   %eax
    1059:	e8 89 f0 ff ff       	call   e7 <doSetuidTest>
    105e:	83 c4 10             	add    $0x10,%esp
    1061:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1064:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1068:	75 42                	jne    10ac <main+0x23e>
    106a:	83 ec 04             	sub    $0x4,%esp
    106d:	68 c0 21 00 00       	push   $0x21c0
    1072:	68 75 21 00 00       	push   $0x2175
    1077:	6a 02                	push   $0x2
    1079:	e8 9d 04 00 00       	call   151b <printf>
    107e:	83 c4 10             	add    $0x10,%esp
    1081:	e8 b6 02 00 00       	call   133c <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    1086:	83 ec 08             	sub    $0x8,%esp
    1089:	68 cd 21 00 00       	push   $0x21cd
    108e:	6a 01                	push   $0x1
    1090:	e8 86 04 00 00       	call   151b <printf>
    1095:	83 c4 10             	add    $0x10,%esp
    1098:	eb 13                	jmp    10ad <main+0x23f>
    if (buf[0] == '\n') continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1:
		  doTest(doUidTest,    t0); break;
    109a:	90                   	nop
    109b:	eb 10                	jmp    10ad <main+0x23f>
	    case 2:
		  doTest(doGidTest,    t0); break;
    109d:	90                   	nop
    109e:	eb 0d                	jmp    10ad <main+0x23f>
	    case 3:
		  doTest(doChmodTest,  t1); break;
    10a0:	90                   	nop
    10a1:	eb 0a                	jmp    10ad <main+0x23f>
	    case 4:
		  doTest(doChownTest,  t1); break;
    10a3:	90                   	nop
    10a4:	eb 07                	jmp    10ad <main+0x23f>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
    10a6:	90                   	nop
    10a7:	eb 04                	jmp    10ad <main+0x23f>
	    case 6:
		  doTest(doExecTest,   t1); break;
    10a9:	90                   	nop
    10aa:	eb 01                	jmp    10ad <main+0x23f>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    10ac:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10b1:	75 0b                	jne    10be <main+0x250>
    10b3:	e9 dc fd ff ff       	jmp    e94 <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if (buf[0] == '\n') continue;
    10b8:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    10b9:	e9 d6 fd ff ff       	jmp    e94 <main+0x26>
		  doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10be:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10bf:	83 ec 08             	sub    $0x8,%esp
    10c2:	68 e9 21 00 00       	push   $0x21e9
    10c7:	6a 01                	push   $0x1
    10c9:	e8 4d 04 00 00       	call   151b <printf>
    10ce:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10d1:	83 ec 0c             	sub    $0xc,%esp
    10d4:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10d7:	50                   	push   %eax
    10d8:	e8 cf 05 00 00       	call   16ac <free>
    10dd:	83 c4 10             	add    $0x10,%esp
  exit();
    10e0:	e8 57 02 00 00       	call   133c <exit>

000010e5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10e5:	55                   	push   %ebp
    10e6:	89 e5                	mov    %esp,%ebp
    10e8:	57                   	push   %edi
    10e9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10ed:	8b 55 10             	mov    0x10(%ebp),%edx
    10f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f3:	89 cb                	mov    %ecx,%ebx
    10f5:	89 df                	mov    %ebx,%edi
    10f7:	89 d1                	mov    %edx,%ecx
    10f9:	fc                   	cld    
    10fa:	f3 aa                	rep stos %al,%es:(%edi)
    10fc:	89 ca                	mov    %ecx,%edx
    10fe:	89 fb                	mov    %edi,%ebx
    1100:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1103:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1106:	90                   	nop
    1107:	5b                   	pop    %ebx
    1108:	5f                   	pop    %edi
    1109:	5d                   	pop    %ebp
    110a:	c3                   	ret    

0000110b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    110b:	55                   	push   %ebp
    110c:	89 e5                	mov    %esp,%ebp
    110e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1117:	90                   	nop
    1118:	8b 45 08             	mov    0x8(%ebp),%eax
    111b:	8d 50 01             	lea    0x1(%eax),%edx
    111e:	89 55 08             	mov    %edx,0x8(%ebp)
    1121:	8b 55 0c             	mov    0xc(%ebp),%edx
    1124:	8d 4a 01             	lea    0x1(%edx),%ecx
    1127:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    112a:	0f b6 12             	movzbl (%edx),%edx
    112d:	88 10                	mov    %dl,(%eax)
    112f:	0f b6 00             	movzbl (%eax),%eax
    1132:	84 c0                	test   %al,%al
    1134:	75 e2                	jne    1118 <strcpy+0xd>
    ;
  return os;
    1136:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1139:	c9                   	leave  
    113a:	c3                   	ret    

0000113b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    113b:	55                   	push   %ebp
    113c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    113e:	eb 08                	jmp    1148 <strcmp+0xd>
    p++, q++;
    1140:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1144:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	0f b6 00             	movzbl (%eax),%eax
    114e:	84 c0                	test   %al,%al
    1150:	74 10                	je     1162 <strcmp+0x27>
    1152:	8b 45 08             	mov    0x8(%ebp),%eax
    1155:	0f b6 10             	movzbl (%eax),%edx
    1158:	8b 45 0c             	mov    0xc(%ebp),%eax
    115b:	0f b6 00             	movzbl (%eax),%eax
    115e:	38 c2                	cmp    %al,%dl
    1160:	74 de                	je     1140 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1162:	8b 45 08             	mov    0x8(%ebp),%eax
    1165:	0f b6 00             	movzbl (%eax),%eax
    1168:	0f b6 d0             	movzbl %al,%edx
    116b:	8b 45 0c             	mov    0xc(%ebp),%eax
    116e:	0f b6 00             	movzbl (%eax),%eax
    1171:	0f b6 c0             	movzbl %al,%eax
    1174:	29 c2                	sub    %eax,%edx
    1176:	89 d0                	mov    %edx,%eax
}
    1178:	5d                   	pop    %ebp
    1179:	c3                   	ret    

0000117a <strlen>:

uint
strlen(char *s)
{
    117a:	55                   	push   %ebp
    117b:	89 e5                	mov    %esp,%ebp
    117d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1187:	eb 04                	jmp    118d <strlen+0x13>
    1189:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    118d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1190:	8b 45 08             	mov    0x8(%ebp),%eax
    1193:	01 d0                	add    %edx,%eax
    1195:	0f b6 00             	movzbl (%eax),%eax
    1198:	84 c0                	test   %al,%al
    119a:	75 ed                	jne    1189 <strlen+0xf>
    ;
  return n;
    119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    119f:	c9                   	leave  
    11a0:	c3                   	ret    

000011a1 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11a1:	55                   	push   %ebp
    11a2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    11a4:	8b 45 10             	mov    0x10(%ebp),%eax
    11a7:	50                   	push   %eax
    11a8:	ff 75 0c             	pushl  0xc(%ebp)
    11ab:	ff 75 08             	pushl  0x8(%ebp)
    11ae:	e8 32 ff ff ff       	call   10e5 <stosb>
    11b3:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11b9:	c9                   	leave  
    11ba:	c3                   	ret    

000011bb <strchr>:

char*
strchr(const char *s, char c)
{
    11bb:	55                   	push   %ebp
    11bc:	89 e5                	mov    %esp,%ebp
    11be:	83 ec 04             	sub    $0x4,%esp
    11c1:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11c7:	eb 14                	jmp    11dd <strchr+0x22>
    if(*s == c)
    11c9:	8b 45 08             	mov    0x8(%ebp),%eax
    11cc:	0f b6 00             	movzbl (%eax),%eax
    11cf:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11d2:	75 05                	jne    11d9 <strchr+0x1e>
      return (char*)s;
    11d4:	8b 45 08             	mov    0x8(%ebp),%eax
    11d7:	eb 13                	jmp    11ec <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11dd:	8b 45 08             	mov    0x8(%ebp),%eax
    11e0:	0f b6 00             	movzbl (%eax),%eax
    11e3:	84 c0                	test   %al,%al
    11e5:	75 e2                	jne    11c9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11ec:	c9                   	leave  
    11ed:	c3                   	ret    

000011ee <gets>:

char*
gets(char *buf, int max)
{
    11ee:	55                   	push   %ebp
    11ef:	89 e5                	mov    %esp,%ebp
    11f1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11fb:	eb 42                	jmp    123f <gets+0x51>
    cc = read(0, &c, 1);
    11fd:	83 ec 04             	sub    $0x4,%esp
    1200:	6a 01                	push   $0x1
    1202:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1205:	50                   	push   %eax
    1206:	6a 00                	push   $0x0
    1208:	e8 47 01 00 00       	call   1354 <read>
    120d:	83 c4 10             	add    $0x10,%esp
    1210:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1213:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1217:	7e 33                	jle    124c <gets+0x5e>
      break;
    buf[i++] = c;
    1219:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121c:	8d 50 01             	lea    0x1(%eax),%edx
    121f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1222:	89 c2                	mov    %eax,%edx
    1224:	8b 45 08             	mov    0x8(%ebp),%eax
    1227:	01 c2                	add    %eax,%edx
    1229:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    122d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    122f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1233:	3c 0a                	cmp    $0xa,%al
    1235:	74 16                	je     124d <gets+0x5f>
    1237:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    123b:	3c 0d                	cmp    $0xd,%al
    123d:	74 0e                	je     124d <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1242:	83 c0 01             	add    $0x1,%eax
    1245:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1248:	7c b3                	jl     11fd <gets+0xf>
    124a:	eb 01                	jmp    124d <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    124c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1250:	8b 45 08             	mov    0x8(%ebp),%eax
    1253:	01 d0                	add    %edx,%eax
    1255:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1258:	8b 45 08             	mov    0x8(%ebp),%eax
}
    125b:	c9                   	leave  
    125c:	c3                   	ret    

0000125d <stat>:

int
stat(char *n, struct stat *st)
{
    125d:	55                   	push   %ebp
    125e:	89 e5                	mov    %esp,%ebp
    1260:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1263:	83 ec 08             	sub    $0x8,%esp
    1266:	6a 00                	push   $0x0
    1268:	ff 75 08             	pushl  0x8(%ebp)
    126b:	e8 0c 01 00 00       	call   137c <open>
    1270:	83 c4 10             	add    $0x10,%esp
    1273:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    127a:	79 07                	jns    1283 <stat+0x26>
    return -1;
    127c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1281:	eb 25                	jmp    12a8 <stat+0x4b>
  r = fstat(fd, st);
    1283:	83 ec 08             	sub    $0x8,%esp
    1286:	ff 75 0c             	pushl  0xc(%ebp)
    1289:	ff 75 f4             	pushl  -0xc(%ebp)
    128c:	e8 03 01 00 00       	call   1394 <fstat>
    1291:	83 c4 10             	add    $0x10,%esp
    1294:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1297:	83 ec 0c             	sub    $0xc,%esp
    129a:	ff 75 f4             	pushl  -0xc(%ebp)
    129d:	e8 c2 00 00 00       	call   1364 <close>
    12a2:	83 c4 10             	add    $0x10,%esp
  return r;
    12a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12a8:	c9                   	leave  
    12a9:	c3                   	ret    

000012aa <atoi>:

int
atoi(const char *s)
{
    12aa:	55                   	push   %ebp
    12ab:	89 e5                	mov    %esp,%ebp
    12ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12b7:	eb 25                	jmp    12de <atoi+0x34>
    n = n*10 + *s++ - '0';
    12b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12bc:	89 d0                	mov    %edx,%eax
    12be:	c1 e0 02             	shl    $0x2,%eax
    12c1:	01 d0                	add    %edx,%eax
    12c3:	01 c0                	add    %eax,%eax
    12c5:	89 c1                	mov    %eax,%ecx
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
    12ca:	8d 50 01             	lea    0x1(%eax),%edx
    12cd:	89 55 08             	mov    %edx,0x8(%ebp)
    12d0:	0f b6 00             	movzbl (%eax),%eax
    12d3:	0f be c0             	movsbl %al,%eax
    12d6:	01 c8                	add    %ecx,%eax
    12d8:	83 e8 30             	sub    $0x30,%eax
    12db:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12de:	8b 45 08             	mov    0x8(%ebp),%eax
    12e1:	0f b6 00             	movzbl (%eax),%eax
    12e4:	3c 2f                	cmp    $0x2f,%al
    12e6:	7e 0a                	jle    12f2 <atoi+0x48>
    12e8:	8b 45 08             	mov    0x8(%ebp),%eax
    12eb:	0f b6 00             	movzbl (%eax),%eax
    12ee:	3c 39                	cmp    $0x39,%al
    12f0:	7e c7                	jle    12b9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    12f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12f5:	c9                   	leave  
    12f6:	c3                   	ret    

000012f7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12f7:	55                   	push   %ebp
    12f8:	89 e5                	mov    %esp,%ebp
    12fa:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1300:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1303:	8b 45 0c             	mov    0xc(%ebp),%eax
    1306:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1309:	eb 17                	jmp    1322 <memmove+0x2b>
    *dst++ = *src++;
    130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130e:	8d 50 01             	lea    0x1(%eax),%edx
    1311:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1314:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1317:	8d 4a 01             	lea    0x1(%edx),%ecx
    131a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    131d:	0f b6 12             	movzbl (%edx),%edx
    1320:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1322:	8b 45 10             	mov    0x10(%ebp),%eax
    1325:	8d 50 ff             	lea    -0x1(%eax),%edx
    1328:	89 55 10             	mov    %edx,0x10(%ebp)
    132b:	85 c0                	test   %eax,%eax
    132d:	7f dc                	jg     130b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    132f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1332:	c9                   	leave  
    1333:	c3                   	ret    

00001334 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1334:	b8 01 00 00 00       	mov    $0x1,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <exit>:
SYSCALL(exit)
    133c:	b8 02 00 00 00       	mov    $0x2,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <wait>:
SYSCALL(wait)
    1344:	b8 03 00 00 00       	mov    $0x3,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <pipe>:
SYSCALL(pipe)
    134c:	b8 04 00 00 00       	mov    $0x4,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <read>:
SYSCALL(read)
    1354:	b8 05 00 00 00       	mov    $0x5,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <write>:
SYSCALL(write)
    135c:	b8 10 00 00 00       	mov    $0x10,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <close>:
SYSCALL(close)
    1364:	b8 15 00 00 00       	mov    $0x15,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <kill>:
SYSCALL(kill)
    136c:	b8 06 00 00 00       	mov    $0x6,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <exec>:
SYSCALL(exec)
    1374:	b8 07 00 00 00       	mov    $0x7,%eax
    1379:	cd 40                	int    $0x40
    137b:	c3                   	ret    

0000137c <open>:
SYSCALL(open)
    137c:	b8 0f 00 00 00       	mov    $0xf,%eax
    1381:	cd 40                	int    $0x40
    1383:	c3                   	ret    

00001384 <mknod>:
SYSCALL(mknod)
    1384:	b8 11 00 00 00       	mov    $0x11,%eax
    1389:	cd 40                	int    $0x40
    138b:	c3                   	ret    

0000138c <unlink>:
SYSCALL(unlink)
    138c:	b8 12 00 00 00       	mov    $0x12,%eax
    1391:	cd 40                	int    $0x40
    1393:	c3                   	ret    

00001394 <fstat>:
SYSCALL(fstat)
    1394:	b8 08 00 00 00       	mov    $0x8,%eax
    1399:	cd 40                	int    $0x40
    139b:	c3                   	ret    

0000139c <link>:
SYSCALL(link)
    139c:	b8 13 00 00 00       	mov    $0x13,%eax
    13a1:	cd 40                	int    $0x40
    13a3:	c3                   	ret    

000013a4 <mkdir>:
SYSCALL(mkdir)
    13a4:	b8 14 00 00 00       	mov    $0x14,%eax
    13a9:	cd 40                	int    $0x40
    13ab:	c3                   	ret    

000013ac <chdir>:
SYSCALL(chdir)
    13ac:	b8 09 00 00 00       	mov    $0x9,%eax
    13b1:	cd 40                	int    $0x40
    13b3:	c3                   	ret    

000013b4 <dup>:
SYSCALL(dup)
    13b4:	b8 0a 00 00 00       	mov    $0xa,%eax
    13b9:	cd 40                	int    $0x40
    13bb:	c3                   	ret    

000013bc <getpid>:
SYSCALL(getpid)
    13bc:	b8 0b 00 00 00       	mov    $0xb,%eax
    13c1:	cd 40                	int    $0x40
    13c3:	c3                   	ret    

000013c4 <sbrk>:
SYSCALL(sbrk)
    13c4:	b8 0c 00 00 00       	mov    $0xc,%eax
    13c9:	cd 40                	int    $0x40
    13cb:	c3                   	ret    

000013cc <sleep>:
SYSCALL(sleep)
    13cc:	b8 0d 00 00 00       	mov    $0xd,%eax
    13d1:	cd 40                	int    $0x40
    13d3:	c3                   	ret    

000013d4 <uptime>:
SYSCALL(uptime)
    13d4:	b8 0e 00 00 00       	mov    $0xe,%eax
    13d9:	cd 40                	int    $0x40
    13db:	c3                   	ret    

000013dc <halt>:
SYSCALL(halt)
    13dc:	b8 16 00 00 00       	mov    $0x16,%eax
    13e1:	cd 40                	int    $0x40
    13e3:	c3                   	ret    

000013e4 <date>:
SYSCALL(date)
    13e4:	b8 17 00 00 00       	mov    $0x17,%eax
    13e9:	cd 40                	int    $0x40
    13eb:	c3                   	ret    

000013ec <getuid>:
SYSCALL(getuid)
    13ec:	b8 18 00 00 00       	mov    $0x18,%eax
    13f1:	cd 40                	int    $0x40
    13f3:	c3                   	ret    

000013f4 <getgid>:
SYSCALL(getgid)
    13f4:	b8 19 00 00 00       	mov    $0x19,%eax
    13f9:	cd 40                	int    $0x40
    13fb:	c3                   	ret    

000013fc <getppid>:
SYSCALL(getppid)
    13fc:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1401:	cd 40                	int    $0x40
    1403:	c3                   	ret    

00001404 <setuid>:
SYSCALL(setuid)
    1404:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1409:	cd 40                	int    $0x40
    140b:	c3                   	ret    

0000140c <setgid>:
SYSCALL(setgid)
    140c:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1411:	cd 40                	int    $0x40
    1413:	c3                   	ret    

00001414 <getprocs>:
SYSCALL(getprocs)
    1414:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1419:	cd 40                	int    $0x40
    141b:	c3                   	ret    

0000141c <looper>:
SYSCALL(looper)
    141c:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1421:	cd 40                	int    $0x40
    1423:	c3                   	ret    

00001424 <setpriority>:
SYSCALL(setpriority)
    1424:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1429:	cd 40                	int    $0x40
    142b:	c3                   	ret    

0000142c <chmod>:
SYSCALL(chmod)
    142c:	b8 20 00 00 00       	mov    $0x20,%eax
    1431:	cd 40                	int    $0x40
    1433:	c3                   	ret    

00001434 <chown>:
SYSCALL(chown)
    1434:	b8 21 00 00 00       	mov    $0x21,%eax
    1439:	cd 40                	int    $0x40
    143b:	c3                   	ret    

0000143c <chgrp>:
SYSCALL(chgrp)
    143c:	b8 22 00 00 00       	mov    $0x22,%eax
    1441:	cd 40                	int    $0x40
    1443:	c3                   	ret    

00001444 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1444:	55                   	push   %ebp
    1445:	89 e5                	mov    %esp,%ebp
    1447:	83 ec 18             	sub    $0x18,%esp
    144a:	8b 45 0c             	mov    0xc(%ebp),%eax
    144d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1450:	83 ec 04             	sub    $0x4,%esp
    1453:	6a 01                	push   $0x1
    1455:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1458:	50                   	push   %eax
    1459:	ff 75 08             	pushl  0x8(%ebp)
    145c:	e8 fb fe ff ff       	call   135c <write>
    1461:	83 c4 10             	add    $0x10,%esp
}
    1464:	90                   	nop
    1465:	c9                   	leave  
    1466:	c3                   	ret    

00001467 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1467:	55                   	push   %ebp
    1468:	89 e5                	mov    %esp,%ebp
    146a:	53                   	push   %ebx
    146b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    146e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1475:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1479:	74 17                	je     1492 <printint+0x2b>
    147b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    147f:	79 11                	jns    1492 <printint+0x2b>
    neg = 1;
    1481:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1488:	8b 45 0c             	mov    0xc(%ebp),%eax
    148b:	f7 d8                	neg    %eax
    148d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1490:	eb 06                	jmp    1498 <printint+0x31>
  } else {
    x = xx;
    1492:	8b 45 0c             	mov    0xc(%ebp),%eax
    1495:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    149f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14a2:	8d 41 01             	lea    0x1(%ecx),%eax
    14a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14ae:	ba 00 00 00 00       	mov    $0x0,%edx
    14b3:	f7 f3                	div    %ebx
    14b5:	89 d0                	mov    %edx,%eax
    14b7:	0f b6 80 00 26 00 00 	movzbl 0x2600(%eax),%eax
    14be:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14c8:	ba 00 00 00 00       	mov    $0x0,%edx
    14cd:	f7 f3                	div    %ebx
    14cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14d6:	75 c7                	jne    149f <printint+0x38>
  if(neg)
    14d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14dc:	74 2d                	je     150b <printint+0xa4>
    buf[i++] = '-';
    14de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e1:	8d 50 01             	lea    0x1(%eax),%edx
    14e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14e7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14ec:	eb 1d                	jmp    150b <printint+0xa4>
    putc(fd, buf[i]);
    14ee:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f4:	01 d0                	add    %edx,%eax
    14f6:	0f b6 00             	movzbl (%eax),%eax
    14f9:	0f be c0             	movsbl %al,%eax
    14fc:	83 ec 08             	sub    $0x8,%esp
    14ff:	50                   	push   %eax
    1500:	ff 75 08             	pushl  0x8(%ebp)
    1503:	e8 3c ff ff ff       	call   1444 <putc>
    1508:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    150b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    150f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1513:	79 d9                	jns    14ee <printint+0x87>
    putc(fd, buf[i]);
}
    1515:	90                   	nop
    1516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1519:	c9                   	leave  
    151a:	c3                   	ret    

0000151b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    151b:	55                   	push   %ebp
    151c:	89 e5                	mov    %esp,%ebp
    151e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1521:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1528:	8d 45 0c             	lea    0xc(%ebp),%eax
    152b:	83 c0 04             	add    $0x4,%eax
    152e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1531:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1538:	e9 59 01 00 00       	jmp    1696 <printf+0x17b>
    c = fmt[i] & 0xff;
    153d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1540:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1543:	01 d0                	add    %edx,%eax
    1545:	0f b6 00             	movzbl (%eax),%eax
    1548:	0f be c0             	movsbl %al,%eax
    154b:	25 ff 00 00 00       	and    $0xff,%eax
    1550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1553:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1557:	75 2c                	jne    1585 <printf+0x6a>
      if(c == '%'){
    1559:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    155d:	75 0c                	jne    156b <printf+0x50>
        state = '%';
    155f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1566:	e9 27 01 00 00       	jmp    1692 <printf+0x177>
      } else {
        putc(fd, c);
    156b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    156e:	0f be c0             	movsbl %al,%eax
    1571:	83 ec 08             	sub    $0x8,%esp
    1574:	50                   	push   %eax
    1575:	ff 75 08             	pushl  0x8(%ebp)
    1578:	e8 c7 fe ff ff       	call   1444 <putc>
    157d:	83 c4 10             	add    $0x10,%esp
    1580:	e9 0d 01 00 00       	jmp    1692 <printf+0x177>
      }
    } else if(state == '%'){
    1585:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1589:	0f 85 03 01 00 00    	jne    1692 <printf+0x177>
      if(c == 'd'){
    158f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1593:	75 1e                	jne    15b3 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1595:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1598:	8b 00                	mov    (%eax),%eax
    159a:	6a 01                	push   $0x1
    159c:	6a 0a                	push   $0xa
    159e:	50                   	push   %eax
    159f:	ff 75 08             	pushl  0x8(%ebp)
    15a2:	e8 c0 fe ff ff       	call   1467 <printint>
    15a7:	83 c4 10             	add    $0x10,%esp
        ap++;
    15aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15ae:	e9 d8 00 00 00       	jmp    168b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    15b3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15b7:	74 06                	je     15bf <printf+0xa4>
    15b9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15bd:	75 1e                	jne    15dd <printf+0xc2>
        printint(fd, *ap, 16, 0);
    15bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c2:	8b 00                	mov    (%eax),%eax
    15c4:	6a 00                	push   $0x0
    15c6:	6a 10                	push   $0x10
    15c8:	50                   	push   %eax
    15c9:	ff 75 08             	pushl  0x8(%ebp)
    15cc:	e8 96 fe ff ff       	call   1467 <printint>
    15d1:	83 c4 10             	add    $0x10,%esp
        ap++;
    15d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d8:	e9 ae 00 00 00       	jmp    168b <printf+0x170>
      } else if(c == 's'){
    15dd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15e1:	75 43                	jne    1626 <printf+0x10b>
        s = (char*)*ap;
    15e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15e6:	8b 00                	mov    (%eax),%eax
    15e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15f3:	75 25                	jne    161a <printf+0xff>
          s = "(null)";
    15f5:	c7 45 f4 18 22 00 00 	movl   $0x2218,-0xc(%ebp)
        while(*s != 0){
    15fc:	eb 1c                	jmp    161a <printf+0xff>
          putc(fd, *s);
    15fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1601:	0f b6 00             	movzbl (%eax),%eax
    1604:	0f be c0             	movsbl %al,%eax
    1607:	83 ec 08             	sub    $0x8,%esp
    160a:	50                   	push   %eax
    160b:	ff 75 08             	pushl  0x8(%ebp)
    160e:	e8 31 fe ff ff       	call   1444 <putc>
    1613:	83 c4 10             	add    $0x10,%esp
          s++;
    1616:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161d:	0f b6 00             	movzbl (%eax),%eax
    1620:	84 c0                	test   %al,%al
    1622:	75 da                	jne    15fe <printf+0xe3>
    1624:	eb 65                	jmp    168b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1626:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    162a:	75 1d                	jne    1649 <printf+0x12e>
        putc(fd, *ap);
    162c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    162f:	8b 00                	mov    (%eax),%eax
    1631:	0f be c0             	movsbl %al,%eax
    1634:	83 ec 08             	sub    $0x8,%esp
    1637:	50                   	push   %eax
    1638:	ff 75 08             	pushl  0x8(%ebp)
    163b:	e8 04 fe ff ff       	call   1444 <putc>
    1640:	83 c4 10             	add    $0x10,%esp
        ap++;
    1643:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1647:	eb 42                	jmp    168b <printf+0x170>
      } else if(c == '%'){
    1649:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    164d:	75 17                	jne    1666 <printf+0x14b>
        putc(fd, c);
    164f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1652:	0f be c0             	movsbl %al,%eax
    1655:	83 ec 08             	sub    $0x8,%esp
    1658:	50                   	push   %eax
    1659:	ff 75 08             	pushl  0x8(%ebp)
    165c:	e8 e3 fd ff ff       	call   1444 <putc>
    1661:	83 c4 10             	add    $0x10,%esp
    1664:	eb 25                	jmp    168b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1666:	83 ec 08             	sub    $0x8,%esp
    1669:	6a 25                	push   $0x25
    166b:	ff 75 08             	pushl  0x8(%ebp)
    166e:	e8 d1 fd ff ff       	call   1444 <putc>
    1673:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1679:	0f be c0             	movsbl %al,%eax
    167c:	83 ec 08             	sub    $0x8,%esp
    167f:	50                   	push   %eax
    1680:	ff 75 08             	pushl  0x8(%ebp)
    1683:	e8 bc fd ff ff       	call   1444 <putc>
    1688:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    168b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1692:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1696:	8b 55 0c             	mov    0xc(%ebp),%edx
    1699:	8b 45 f0             	mov    -0x10(%ebp),%eax
    169c:	01 d0                	add    %edx,%eax
    169e:	0f b6 00             	movzbl (%eax),%eax
    16a1:	84 c0                	test   %al,%al
    16a3:	0f 85 94 fe ff ff    	jne    153d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16a9:	90                   	nop
    16aa:	c9                   	leave  
    16ab:	c3                   	ret    

000016ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16ac:	55                   	push   %ebp
    16ad:	89 e5                	mov    %esp,%ebp
    16af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16b2:	8b 45 08             	mov    0x8(%ebp),%eax
    16b5:	83 e8 08             	sub    $0x8,%eax
    16b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16bb:	a1 1c 26 00 00       	mov    0x261c,%eax
    16c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16c3:	eb 24                	jmp    16e9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c8:	8b 00                	mov    (%eax),%eax
    16ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16cd:	77 12                	ja     16e1 <free+0x35>
    16cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16d5:	77 24                	ja     16fb <free+0x4f>
    16d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16da:	8b 00                	mov    (%eax),%eax
    16dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16df:	77 1a                	ja     16fb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	8b 00                	mov    (%eax),%eax
    16e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16ef:	76 d4                	jbe    16c5 <free+0x19>
    16f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f4:	8b 00                	mov    (%eax),%eax
    16f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16f9:	76 ca                	jbe    16c5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fe:	8b 40 04             	mov    0x4(%eax),%eax
    1701:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1708:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170b:	01 c2                	add    %eax,%edx
    170d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1710:	8b 00                	mov    (%eax),%eax
    1712:	39 c2                	cmp    %eax,%edx
    1714:	75 24                	jne    173a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1716:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1719:	8b 50 04             	mov    0x4(%eax),%edx
    171c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171f:	8b 00                	mov    (%eax),%eax
    1721:	8b 40 04             	mov    0x4(%eax),%eax
    1724:	01 c2                	add    %eax,%edx
    1726:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1729:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172f:	8b 00                	mov    (%eax),%eax
    1731:	8b 10                	mov    (%eax),%edx
    1733:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1736:	89 10                	mov    %edx,(%eax)
    1738:	eb 0a                	jmp    1744 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    173a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173d:	8b 10                	mov    (%eax),%edx
    173f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1742:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1744:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1747:	8b 40 04             	mov    0x4(%eax),%eax
    174a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1751:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1754:	01 d0                	add    %edx,%eax
    1756:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1759:	75 20                	jne    177b <free+0xcf>
    p->s.size += bp->s.size;
    175b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175e:	8b 50 04             	mov    0x4(%eax),%edx
    1761:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1764:	8b 40 04             	mov    0x4(%eax),%eax
    1767:	01 c2                	add    %eax,%edx
    1769:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1772:	8b 10                	mov    (%eax),%edx
    1774:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1777:	89 10                	mov    %edx,(%eax)
    1779:	eb 08                	jmp    1783 <free+0xd7>
  } else
    p->s.ptr = bp;
    177b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1781:	89 10                	mov    %edx,(%eax)
  freep = p;
    1783:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1786:	a3 1c 26 00 00       	mov    %eax,0x261c
}
    178b:	90                   	nop
    178c:	c9                   	leave  
    178d:	c3                   	ret    

0000178e <morecore>:

static Header*
morecore(uint nu)
{
    178e:	55                   	push   %ebp
    178f:	89 e5                	mov    %esp,%ebp
    1791:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1794:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    179b:	77 07                	ja     17a4 <morecore+0x16>
    nu = 4096;
    179d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17a4:	8b 45 08             	mov    0x8(%ebp),%eax
    17a7:	c1 e0 03             	shl    $0x3,%eax
    17aa:	83 ec 0c             	sub    $0xc,%esp
    17ad:	50                   	push   %eax
    17ae:	e8 11 fc ff ff       	call   13c4 <sbrk>
    17b3:	83 c4 10             	add    $0x10,%esp
    17b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17b9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17bd:	75 07                	jne    17c6 <morecore+0x38>
    return 0;
    17bf:	b8 00 00 00 00       	mov    $0x0,%eax
    17c4:	eb 26                	jmp    17ec <morecore+0x5e>
  hp = (Header*)p;
    17c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17cf:	8b 55 08             	mov    0x8(%ebp),%edx
    17d2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d8:	83 c0 08             	add    $0x8,%eax
    17db:	83 ec 0c             	sub    $0xc,%esp
    17de:	50                   	push   %eax
    17df:	e8 c8 fe ff ff       	call   16ac <free>
    17e4:	83 c4 10             	add    $0x10,%esp
  return freep;
    17e7:	a1 1c 26 00 00       	mov    0x261c,%eax
}
    17ec:	c9                   	leave  
    17ed:	c3                   	ret    

000017ee <malloc>:

void*
malloc(uint nbytes)
{
    17ee:	55                   	push   %ebp
    17ef:	89 e5                	mov    %esp,%ebp
    17f1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17f4:	8b 45 08             	mov    0x8(%ebp),%eax
    17f7:	83 c0 07             	add    $0x7,%eax
    17fa:	c1 e8 03             	shr    $0x3,%eax
    17fd:	83 c0 01             	add    $0x1,%eax
    1800:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1803:	a1 1c 26 00 00       	mov    0x261c,%eax
    1808:	89 45 f0             	mov    %eax,-0x10(%ebp)
    180b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    180f:	75 23                	jne    1834 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1811:	c7 45 f0 14 26 00 00 	movl   $0x2614,-0x10(%ebp)
    1818:	8b 45 f0             	mov    -0x10(%ebp),%eax
    181b:	a3 1c 26 00 00       	mov    %eax,0x261c
    1820:	a1 1c 26 00 00       	mov    0x261c,%eax
    1825:	a3 14 26 00 00       	mov    %eax,0x2614
    base.s.size = 0;
    182a:	c7 05 18 26 00 00 00 	movl   $0x0,0x2618
    1831:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1834:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1837:	8b 00                	mov    (%eax),%eax
    1839:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183f:	8b 40 04             	mov    0x4(%eax),%eax
    1842:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1845:	72 4d                	jb     1894 <malloc+0xa6>
      if(p->s.size == nunits)
    1847:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184a:	8b 40 04             	mov    0x4(%eax),%eax
    184d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1850:	75 0c                	jne    185e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1852:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1855:	8b 10                	mov    (%eax),%edx
    1857:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185a:	89 10                	mov    %edx,(%eax)
    185c:	eb 26                	jmp    1884 <malloc+0x96>
      else {
        p->s.size -= nunits;
    185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1861:	8b 40 04             	mov    0x4(%eax),%eax
    1864:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1867:	89 c2                	mov    %eax,%edx
    1869:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1872:	8b 40 04             	mov    0x4(%eax),%eax
    1875:	c1 e0 03             	shl    $0x3,%eax
    1878:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1881:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1884:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1887:	a3 1c 26 00 00       	mov    %eax,0x261c
      return (void*)(p + 1);
    188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    188f:	83 c0 08             	add    $0x8,%eax
    1892:	eb 3b                	jmp    18cf <malloc+0xe1>
    }
    if(p == freep)
    1894:	a1 1c 26 00 00       	mov    0x261c,%eax
    1899:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    189c:	75 1e                	jne    18bc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    189e:	83 ec 0c             	sub    $0xc,%esp
    18a1:	ff 75 ec             	pushl  -0x14(%ebp)
    18a4:	e8 e5 fe ff ff       	call   178e <morecore>
    18a9:	83 c4 10             	add    $0x10,%esp
    18ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18b3:	75 07                	jne    18bc <malloc+0xce>
        return 0;
    18b5:	b8 00 00 00 00       	mov    $0x0,%eax
    18ba:	eb 13                	jmp    18cf <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c5:	8b 00                	mov    (%eax),%eax
    18c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18ca:	e9 6d ff ff ff       	jmp    183c <malloc+0x4e>
}
    18cf:	c9                   	leave  
    18d0:	c3                   	ret    
