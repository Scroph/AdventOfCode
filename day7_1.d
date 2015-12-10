import std.stdio;
import std.conv;
import std.algorithm;
import std.string;

int main(string[] args)
{
	string[string] wires;
	foreach(line; File(args[1]).byLine.map!(to!string).map!(strip))
	{
		auto parts = line.split(" -> ");
		wires[parts[1]] = parts[0];
	}
	wires.solve_for("a").writeln;
	foreach(k, v; wires)
		writeln(k, ": ", v);
	return 0;
}

ushort solve_for(string[string] input, string variable)
{
	string[] operators = [" AND ", " OR ", " LSHIFT ", " RSHIFT ", "NOT "];
	string operator;
	foreach(op; operators)
	{
		if(input[variable].indexOf(op) != -1)
		{
			operator = op;
			break;
		}
	}
	ushort result;
	string[] parts;
	if(operator != "")
		parts = input[variable].split(operator);
	else
		return input.solve_for(input[variable]);
	//parts.writeln();
	if(input.evaluate(parts[0], operator, parts[1], result))
	{
		return result;
	}
	else
	{
		input.evaluate(input.solve_for(parts[0]).to!string, operator, input.solve_for(parts[0]).to!string, result);
	}
	return result;
}

bool evaluate(string[string] input, string a, string op, string b, ref ushort result)
{
	if(op == " NOT " && !isNumeric(input[b]))
		return false;
	/*writeln("input[", a, "] = ", input[a]);
	writeln("input[", b, "] = ", input[b]);*/
	if((a in input && !input[a].isNumeric) || (b in input && !input[b].isNumeric))
		return false;
	ushort a_short, b_short;
	a_short = a in input ? input[a].to!ushort : a.to!ushort;
	b_short = b in input ? input[b].to!ushort : b.to!ushort;
	switch(op)
	{
		case " AND ":
			result = a_short & b_short;
		break;
		case " OR ":
			result = a_short | b_short;
		break;
		case " LSHIFT ":
			result = cast(ushort)(a_short << b_short);
		break;
		case " RSHIFT ":
			result = a_short >> b_short;
		break;
		//case " NOT ":
		default:
			result = ~b_short;
		break;
	}
	return true;
}
