import std.stdio;
import std.range;
import std.string;
import std.algorithm;
import std.conv;

int main(string[] args)
{
	string[string] replacements;
	string medicine;
	foreach(line; File(args[1]).byLine.map!strip.map!(to!string))
	{
		if(line.length == 0)
			continue;
		int idx = line.indexOf(" => ");
		if(idx == -1)
		{
			medicine = line;
			break;
		}
		replacements[line[idx + 4 .. $]] = line[0 .. idx];
	}
	writeln("Part 1 : ", medicine.generate_molecules(replacements));

	return 0;
}

string replace_molecule(string molecule, string[string] replacements)
{
	foreach(k, v; replacements)
	{
		if(v == molecule)
		{
			return mo
		}
	}
}

int generate_molecules(string medicine, string[string] replacements)
{
	string[] potential_molecules;
	foreach(k, v; replacements)
	{
		int occurrences, start;
		string _medicine = medicine.idup;
		int idx = medicine.indexOf(v, 0);
		if(idx == -1)
			continue;
		while(true)
		{
			medicine = medicine[0 .. idx] ~ k ~ medicine[idx + v.length .. $];
			if(!potential_molecules.canFind(medicine))
				potential_molecules ~= medicine;
			medicine = _medicine;
			idx = medicine.indexOf(v, idx + v.length);
			if(idx == -1)
				break;
		}
	}
	return potential_molecules.length;
}
//~~
