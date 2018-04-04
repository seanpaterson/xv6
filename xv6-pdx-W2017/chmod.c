#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char ** argv)
{
    int imode = 0;
    char *mode;
    if (argc != 3) {
      printf(2, "Error. Need a string to convert to octal\n");
      exit();
    }

    mode = argv[1];
    if (strlen(mode) != 4) {
      printf(2, "Error. 4 octal digits required.\n");
      exit();
    }
    if (!(mode[0] == '0' || mode[0] == '1'))
      exit();
    if (!(mode[1] >= '0' && mode[1] <= '7'))
      exit();
    if (!(mode[2] >= '0' && mode[2] <= '7'))
      exit();
    if (!(mode[3] >= '0' && mode[3] <= '7'))
      exit();
    imode += ((int)(mode[0] - '0') * (8*8*8));
    imode += ((int)(mode[1] - '0') * (8*8));
    imode += ((int)(mode[2] - '0') * (8));
    imode +=  (int)(mode[3] - '0');
    chmod(argv[2], imode);
    exit();
}
