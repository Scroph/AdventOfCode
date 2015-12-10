import std.stdio;
import std.ascii;
import std.conv;
import std.string;
import std.algorithm;

int main(string[] args)
{
	int string_code, memory_code;
	foreach(line; File("input").byLine.map!(to!string).map!strip)
	{
		string_code += line.length;
		memory_code += line[1 .. $ - 1].evaluate;
		//memory_code += line.encode;
	}
	writeln("Part 1 : ", memory_code);
	writeln("Part 1 : ", string_code - memory_code);
	//writeln("Part 2 : ", memory_code - string_code);
	return 0;
}

int evaluate(string input) //part 1
{
	int length, i;
	do
	{
		if(input[i] != '\\')
		{
			length++;
			i++;
			continue;
		}
		
		if(input[i + 1] == '\\' || input[i + 1] == '"')
		{
			i += 2;
			length++;
			continue;
		}

		if(i + 3 < input.length && input[i + 1] == 'x' && input[i + 2].isHexDigit && input[i + 3].isHexDigit)
		{
			length++;
			i += 4;
			continue;
		}
		else
		{
			length++;
			i++;
		}
	}
	while(i < input.length);
	return length;
}

int encode(string input) //part 2
{
	return 2 + input.length +  input.count!(a => a == '"' || a == '\\');
}
