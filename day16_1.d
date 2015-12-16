import std.stdio;
import std.conv;
import std.string;
import std.algorithm;

int main(string[] args)
{
	auto fh = File(args[1]);
	int[string][] sues;
	int[string] ticker_tape = ["children": 3, "cats": 7, "samoyeds": 2, "pomeranians": 3, "akitas": 0, "vizslas": 0, "goldfish": 5, "trees": 3, "cars": 2, "perfumes": 1];
	foreach(line; fh.byLine.map!(to!string).map!strip)
	{
		int[string] clues;
		parse_sues(line, clues);
		sues ~= clues;
	}

	foreach(i, aunt; sues)
	{
		if(aunt.is_legit(ticker_tape))
			writeln("Part #1 : Sue ", i + 1, " : ", aunt);
		if(aunt.is_really_legit(ticker_tape))
			writeln("Part #2 : Sue ", i + 1, " : ", aunt);
	}

	return 0;
}

bool is_really_legit(int[string] clues, int[string] ticker_tape)
{
	foreach(k, v; clues)
	{
		if(k in ticker_tape)
		{
			switch(k)
			{
				case "cats":
				case "trees":
					if(ticker_tape[k] >= v)
						return false;
				break;
				case "pomeranians":
				case "goldfish":
					if(v >= ticker_tape[k])
						return false;
				break;
				default:
					if(ticker_tape[k] != v)
						return false;
				break;
			}
		}
	}
	return true;
}

bool is_legit(int[string] clues, int[string] ticker_tape)
{
	foreach(k, v; clues)
		if(k in ticker_tape && ticker_tape[k] != v)
			return false;
	return true;
}

void parse_sues(string line, ref int[string] clues)
{
	auto first_coma = line.indexOf(":");
	line = line[first_coma + 2 .. $];
	auto parts = line.split(", ");
	foreach(p; parts)
	{
		int idx = p.indexOf(": ");
		clues[p[0 .. idx]] = p[idx + 2 .. $].to!int;
	}
}
//~~
