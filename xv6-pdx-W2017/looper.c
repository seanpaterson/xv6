#include "types.h"
#include "user.h"

int main(void)
{
	int rs;
	int pid = fork();
	if(pid == 0)
	{
		rs = setpriority(getpid(),0);
		if(rs == -1)
			printf(2, "WARNING: That Priority doesn't exist! \n");
		if(rs == -2)
			printf(2, "WARNING: That PID doesn't exist! \n");
		while(1);
			
	}
	exit();

}
