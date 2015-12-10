#include <iostream>
#include <fstream>

int main(int argc, char *argv[])
{
	std::ifstream fh(argv[1]);
	int floor = 0;
	char paren;
	while(fh >> paren)
	{
		if(paren == '(')
			floor++;
		else
			floor--;
	}
	std::cout << "Floor #" << floor << std::endl;
	return 0;
}
