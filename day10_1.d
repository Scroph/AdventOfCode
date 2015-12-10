import std.stdio;
import std.string : format;
import std.datetime;
import std.conv : to;

int main(string[] args)
{
	string input = args[1];
	int repeat = args.length > 2 ? args[2].to!int : 40;
	StopWatch sw;
	sw.start();
	foreach(x; 0 .. repeat)
	{
		string new_input;
		for(int i = 0; i < input.length;)
		{
			int repeated = 1;
			foreach(j; i + 1 .. input.length)
			{
				if(input[i] == input[j])
					repeated++;
				else
					break;
			}
			new_input ~= repeated.to!string ~ input[i];
			i += repeated;
		}
		input = new_input;
	}
	sw.stop();
	writeln(input.length);
	writeln("Time elapsed : ", sw.peek.msecs, " milliseconds");
	return 0;
}
//~~
