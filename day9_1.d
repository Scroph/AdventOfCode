import std.stdio;
import std.format : formattedRead;
import std.array;
import std.string;
import std.algorithm;
import std.conv;

int main(string[] args)
{
	string[] cities;
	int[string] distances;

	string a, b;
	int dist;
	auto fh = File(args[1]);
	while(fh.readf("%s to %s = %d\r\n", &a, &b, &dist))
	{
		if(!cities.canFind(a))
			cities ~= a;
		if(!cities.canFind(b))
			cities ~= b;
		distances["%s to %s".format(a, b)] = dist;
	}
	find_shortest(cities, distances);
	find_longest(cities, distances);
	return 0;
}

void find_longest(string[] cities, int[string] distances)
{
	int longest_distance;
	string[] longest_path;
	do
	{
		int distance;
		foreach(i; 0 .. cities.length - 1)
		{
			foreach(path, dist; distances)
			{
				if(path.indexOf(cities[i]) != -1 && path.indexOf(cities[i + 1]) != -1)
				{
					distance += dist;
				}
			}
		}
		if(distance > longest_distance)
		{
			longest_distance = distance;
			longest_path = cities;
		}
	}
	while(cities.nextPermutation);
	writeln("Longest distance : ", longest_path.joiner(" -> "), " = ", longest_distance);
}

void find_shortest(string[] cities, int[string] distances)
{
	int shortest_distance = int.max;
	string[] shortest_path;
	do
	{
		int distance;
		foreach(i; 0 .. cities.length - 1)
		{
			foreach(path, dist; distances)
			{
				if(path.indexOf(cities[i]) != -1 && path.indexOf(cities[i + 1]) != -1)
				{
					distance += dist;
				}
			}
		}
		if(distance < shortest_distance)
		{
			shortest_distance = distance;
			shortest_path = cities;
		}
	}
	while(cities.nextPermutation);
	writeln("Shortest distance : ", shortest_path.joiner(" -> "), " = ", shortest_distance);
}
//~~
