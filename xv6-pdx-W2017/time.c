#include "types.h"
#include "user.h"

int main (int argc, char *argv[])
{
	uint startticks = 0;
	uint tickdifference = 0;
	uint pid;
	uint seconds;
	uint milliseconds;
	if(argc == 1)
		strcpy(argv[0], " ");
	else{
		startticks = uptime();
		++argv;
		pid = fork();
		if(pid == 0){
			exec (argv[0],argv);
			printf(2, "ERROR: %s is not a proper name for a command! \n", argv[0]);
			exit();
		}
		wait();
		tickdifference = uptime() - startticks;
		seconds = tickdifference / 100;
        	milliseconds = tickdifference % 100;
	}
	
	printf(2,"%s ran for %d.%d seconds. \n", argv[0],seconds,milliseconds);
	exit();
}
