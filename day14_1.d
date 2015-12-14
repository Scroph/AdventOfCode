import std.stdio;
import std.conv : to;
import std.algorithm;


int main(string[] args)
{
	auto fh = File(args[1]);
	Reindeer[] participants;
	int time_limit = args.length > 2 ? args[2].to!int : 2503;

	string name;
	int speed, flying_period, resting_period;
	while(fh.readf("%s can fly %d km/s for %d seconds, but then must rest for %d seconds.\r\n", &name, &speed, &flying_period, &resting_period))
		participants ~= Reindeer(name, speed, flying_period, resting_period);
	
	round_one(participants, time_limit);
	foreach(ref p; participants)
		p.reinitialize();
	round_two(participants, time_limit);

	return 0;
}

void round_one(Reindeer[] participants, int time_limit)
{
	foreach(ref p; participants)
		p.distance_after(time_limit);
	auto fastest = participants.reduce!((a, b) => max(a, b));
	writeln("Round 1");
	writeln("Fastest reindeer : ", fastest.name);
	writeln("Traveled a total amout of ", fastest.distance, " kilometers !");
	writeln;
}

void round_two(Reindeer[] participants, int time_limit)
{
	writeln("Round 2");
	foreach(second; 0 .. time_limit)
	{
		foreach(ref p; participants)
			p.tick();
		int highest_distance = participants.reduce!((a, b) => max(a, b)).distance;
		foreach(ref p; participants)
			if(p.distance == highest_distance)
				p.score++;
	}
	foreach(ref p; participants)
		p.scoring_system = ScoringSystem.per_tick;
	auto fastest = participants.reduce!((a, b) => max(a, b));
	writeln("Fastest reindeer : ", fastest.name);
	writeln("Traveled a total amout of ", fastest.distance, " kilometers for a total score of ", fastest.score, " points !");
}

struct Reindeer
{
	string name;
	int speed;
	int flying_period;
	int resting_period;
	int distance;
	int score;
	ScoringSystem scoring_system;

	private Action status;
	private int resting_timer;
	private int flying_timer;

	//operator overloading for <= and >= 
	//necessary in order to be able to use max()
	int opCmp(ref Reindeer opponent)
	{
		switch(scoring_system) with(ScoringSystem)
		{
			case distance:
				return this.distance - opponent.distance;
			break;
			default:
				return this.score - opponent.score;
			break;
		}
	}

	void reinitialize()
	{
		status = Action.flying;
		resting_timer = 0;
		flying_timer = 0;
		distance = 0;
	}

	void tick()
	{
		if(status == Action.flying)
		{
			distance += speed;
			flying_timer++;
			if(flying_timer == flying_period)
			{
				flying_timer = 0;
				status = Action.resting;
			}
		}
		else if(status == Action.resting)
		{
			resting_timer++;
			if(resting_timer == resting_period)
			{
				resting_timer = 0;
				status = Action.flying;
			}
		}
	}

	void distance_after(int seconds)
	{
		foreach(sec; 0 .. seconds)
		{
			tick();
		}
	}
}

enum Action
{
	flying,
	resting
}

enum ScoringSystem
{
	distance,
	per_tick
}
//~~
