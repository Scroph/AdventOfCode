import std.stdio;
import std.string;
import std.digest.md;

int main(string[] args)
{
	auto key = args[1];
	int decimal;
	foreach(i; 1 .. int.max)
	{
		if(md5Of("%s%d".format(key, i)).toHexString().idup.startsWith("000000"))
		{
			writeln(i);
			return 0;
		}
	}
	writeln("Not found.");
	return 0;
}
