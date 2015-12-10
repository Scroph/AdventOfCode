import std.stdio;
import std.typecons : Tuple;
import std.string : startsWith, strip;
import std.algorithm : map;
import std.conv : to;
import std.format : formattedRead;

int main(string[] args)
{
	//uint[1000][1000] grid caused stack overflow
	auto grid = new int[][](1000, 1000);
	auto fh = File(args[1]);
	foreach(line; fh.byLine.map!(to!string).map!strip)
	{
		Tuple!(int, int) start, end;
		if(line.startsWith("turn on "))
		{
			line.formattedRead("turn on %d,%d through %d,%d", &start[0], &start[1], &end[0], &end[1]);
			foreach(row; start[0] .. end[0] + 1)
				foreach(col; start[1] .. end[1] + 1)
					grid[row][col]++;
		}
		else if(line.startsWith("turn off"))
		{
			line.formattedRead("turn off %d,%d through %d,%d", &start[0], &start[1], &end[0], &end[1]);
			foreach(row; start[0] .. end[0] + 1)
				foreach(col; start[1] .. end[1] + 1)
					if(grid[row][col] > 0)
						grid[row][col]--;
		}
		else
		{
			line.formattedRead("toggle %d,%d through %d,%d", &start[0], &start[1], &end[0], &end[1]);
			foreach(row; start[0] .. end[0] + 1)
				foreach(col; start[1] .. end[1] + 1)
					grid[row][col] += 2;
		}
	}
	uint lit;
	foreach(row; 0 .. 1000)
		foreach(col; 0 .. 1000)
			lit += grid[row][col];
	lit.writeln;
	return 0;
}
