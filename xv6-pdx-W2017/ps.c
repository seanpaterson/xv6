#include "types.h"
#include "user.h"
#include "uproc.h"

int
main (int argc, char *argv[])
{
	uint max = 72;
	uint actual_max = 0;
	uint CPU_seconds = 0;
	uint CPU_milli = 0;
	uint elapsed_seconds = 0;
	uint elapsed_milli = 0;
	int i = 0;
	struct uproc * table;
	table = (struct uproc*)malloc (max*(sizeof(struct uproc)));
	actual_max = getprocs(max, table);
	if(actual_max <=0)
	{
		printf(2, "ERROR MESSAGE! \n");
		exit();
	}
	printf(2, "PID	Name	UID	GID	PPID	Prio	Elapsed	CPU	State	Size \n");
	for(i = 0; i < actual_max; ++i)
	{
		CPU_seconds = table[i].CPU_total_ticks * 0.01;
        	CPU_milli = table[i].CPU_total_ticks % 100;
        	elapsed_seconds = table[i].elapsed_ticks * 0.01;
        	elapsed_milli = table[i].elapsed_ticks % 100;
		printf(2, "%d	%s	%d	%d	%d	%d	%d.%d	%d.%d	%s	%d\n",
			table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].prio,elapsed_seconds,elapsed_milli,CPU_seconds,CPU_milli,table[i].state,table[i].size);
	}
	exit();
}
