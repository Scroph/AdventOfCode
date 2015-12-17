import std.stdio;
import std.datetime;
import std.conv : to;
import std.algorithm;
import std.string;

int main(string[] args)
{
	int[] data;
	int total = args.length > 2 ? args[2].to!int : 150;
	foreach(container; File(args[1]).byLine.map!strip.map!(to!int))
		data ~= container;

	StopWatch sw;
	sw.start();
	int amount;
	int[][] combos;
	auto last = 1 << (data.length + 1) - 1;
	int min_length = int.max;
	do
	{
		int[] combo;
		foreach(i; 0 .. data.length)
			if(last & (1 << i))
				combo ~= data[i];
		if(combo.sum == total)
		{
			combos ~= [combo];
			if(combo.length < min_length)
				min_length = combo.length;
		}
	}
	while(last--);

	auto cur_time = sw.peek.msecs;
	writeln("Part 1 : ", combos.length);
	writeln("Total time elapsed : ", cur_time, " milliseconds.");

	writeln("Part 2 : ", combos.count!(x => x.length == min_length));
	writeln("Total time elapsed : ", sw.peek.msecs - cur_time, " milliseconds.");
	return 0;
}
