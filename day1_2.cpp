#include <iostream>
#include <fstream>

int main(int argc, char *argv[])
{
	std::ifstream fh(argv[1]);
	int floor = 0, pos = 0;
	char paren;
	while(fh >> paren)
	{
		if(paren == '(')
			floor++;
		else
			floor--;
		pos++;
		if(floor == -1)
			break;
	}
	std::cout << "Basement reached after character #" << pos << std::endl;
	return 0;
}
