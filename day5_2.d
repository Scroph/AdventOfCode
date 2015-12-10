import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.functional : pipe;

int main(string[] args)
{
	auto fh = File(args[1]);
	int nice = fh.byLine.map!(pipe!(to!string, std.string.strip)).count!is_nice;
	nice.writeln;
	return 0;
}

bool is_nice(string word)
{
	bool pair, repetition;
	foreach(i; 0 .. word.length)
	{
		if(i + 2 < word.length && word.count(word[i .. i + 2]) >= 2)
			pair = true;
		if(i + 2 < word.length && word[i] == word[i + 2])
			repetition = true;
		if(repetition && pair)
			return true;
	}
	return false;
}

unittest
{
	static assert("qjhvhtzxzqqjkmpb".is_nice == true);
	static assert("xxyxx".is_nice == true);
	static assert("uurcxstgmygtbstg".is_nice == false);
	static assert("ieodomkazucvgmuy".is_nice == false);
}
