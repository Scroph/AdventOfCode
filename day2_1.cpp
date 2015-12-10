#include <iostream>
#include <algorithm>
#include <vector>
#include <fstream>
#include <sstream>

int calculate_wrapping_area(int width, int length, int height);
std::vector<std::string> split(std::string str, char delimiter);
int find_smallest(int a, int b, int c);

int main(int argc, char *argv[])
{
	std::ifstream fh(argv[1]);
	std::string line;
	unsigned long total = 0;
	while(std::getline(fh, line))
	{
		auto parts = split(line, 'x');
		total += calculate_wrapping_area(atoi(parts[0].c_str()), atoi(parts[1].c_str()), atoi(parts[2].c_str()));
	}
	std::cout << total << std::endl;
	return 0;
}

int calculate_wrapping_area(int width, int length, int height)
{
	std::vector<int> surfaces {length * width, length * height, width * height};
	int smallest = find_smallest(surfaces[0], surfaces[1], surfaces[2]);
	std::for_each(surfaces.begin(), surfaces.end(), [](int &n) {n = n * 2;});
	return accumulate(surfaces.begin(), surfaces.end(), 0) + smallest;
}

int find_smallest(int a, int b, int c)
{
	int smallest = a < b ? a : b;
	return smallest < c ? smallest : c;
}

std::vector<std::string> split(std::string str, char delimiter)
{
	std::vector<std::string> result;
	std::stringstream ss(str);
	std::string element;
	while(std::getline(ss, element, delimiter))
	{
		result.push_back(element);
	}
	return result;
}
