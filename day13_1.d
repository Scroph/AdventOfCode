import std.stdio;
import std.algorithm;

int main(string[] args)
{
	string[] people;
	int[string][string] happiness;
	auto fh = File("input");

	int score;
	string a, b;
	string gain_lose;
	while(fh.readf("%s would %s %d happiness units by sitting next to %s.\r\n", &a, &gain_lose, &score, &b))
	{
		if(!people.canFind(a))
			people ~= a;
		if(!people.canFind(b))
			people ~= b;
		happiness[a][b] = gain_lose == "gain" ? score : -score;
	}
	if(args.canFind("--include-self"))
	{
		people ~= "Hassan";
		foreach(p; people)
		{
			happiness[p]["Hassan"] = 0;
			happiness["Hassan"][p] = 0;
		}
	}
	writeln(find_optimal_seats(people, happiness));
	return 0;
}

int find_optimal_seats(string[] people, int[string][string] happiness)
{
	int optimal;
	do
	{
		int score;
		score += happiness[people[0]][people[1]];
		score += happiness[people[0]][people[people.length - 1]];
		foreach(i; 1 .. people.length - 1)
			score += happiness[people[i]][people[i - 1]] + happiness[people[i]][people[i + 1]];
		score += happiness[people[people.length - 1]][people[people.length - 2]];
		score += happiness[people[people.length - 1]][people[0]];
		if(score > optimal)
			optimal = score;
	}
	while(nextPermutation(people));
	return optimal;
}
//~~
