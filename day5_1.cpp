#include <iostream>
#include <set>
#include <vector>
#include <string>
#include <fstream>

bool is_naughty(const std::string& word);
int main(int argc, char *argv[])
{
	std::ifstream fh(argv[1]);
	std::string vowels = "aeiou";
	std::string word;
	int nice = 0;
	while(fh >> word)
		if(!is_naughty(word))
			nice++;
	std::cout << "Found " << nice << " strings." << std::endl;
	return 0;
}

bool is_naughty(const std::string& word)
{
	std::vector<std::string> exceptions{"ab", "cd", "pq", "xy"};
	for(std::vector<std::string>::iterator it = exceptions.begin(); it != exceptions.end(); it++)
	{
		std::string::size_type idx = word.find(*it);
		if(word.find(*it) != std::string::npos)
			return true;
	}
	bool has_repeated_letters = false;
	std::vector<char> vowels;
	for(int i = 0; i < word.length(); i++)
	{
		if(i + 1 < word.length() && word[i] == word[i + 1])
			has_repeated_letters = true;
		if(word[i] == 'a' || word[i] == 'e' || word[i] == 'o' || word[i] == 'u' || word[i] == 'i')
			vowels.push_back(word[i]);
	}
	if(vowels.size() < 3)
		return true;
	if(!has_repeated_letters)
		return true;
	return false;
}
