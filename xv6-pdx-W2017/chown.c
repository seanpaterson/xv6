#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char ** argv)
{
	int i;
        char *owner;
        if (argc != 3)
          exit();

        owner = argv[1];
        for(i = 0; i < strlen(owner); ++i)
        {
                if (!(owner[i] >= '0' && owner[i] <= '9'))
                        exit();

        }
	chown(argv[2], atoi(argv[1]));
	exit();
}
