#include "types.h"
#include "user.h"

int
main(void)
{
        uint uid, gid, ppid = 0;
	int uidcatch, gidcatch;
        uid = getuid();
        printf(2, "Current UID is: %d \n", uid);
        printf(2, "Setting UID to 100 \n");
        uidcatch = setuid(100);
	if(uidcatch == -1)
		printf(2, "ERROR: UID out of bounds. \n");
	uid = getuid();
        printf(2, "Current UID is: %d \n", uid);
        gid = getgid();
        printf(2, "Current GID is: %d \n", gid);
        printf(2, "Setting GID to 100 \n");
        gidcatch = setgid(100);
	if(gidcatch == -1)
		printf(2, "ERROR: GID out of bounds. \n");
	gid = getgid();
        printf(2, "Current UID is: %d \n", gid);
	ppid = getppid();
	printf(2,"My parent process is: %d \n", ppid);
	printf(2, "Done! \n");
	exit();
}

