import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;

int main(string[] args)
{
	Item[] weapons;
	Item[] armors;
	Item[] rings;

	load_items(weapons, "weapons");
	load_items(armors, "armors");
	load_items(rings, "rings");

	auto empty_items = [Item(0, 0, 0), Item(0, 0, 0), Item(0, 0, 0), Item(0, 0, 0), Item(0, 0, 0)];

	int min_cost = int.max;
	min_cost = min(min_cost, find_min_cost(weapons, empty_items, empty_items, empty_items)); //no armors and no rings
	min_cost = min(min_cost, find_min_cost(weapons, empty_items, empty_items, armors)); //1 armor and no rings
	min_cost = min(min_cost, find_min_cost(weapons, rings, empty_items, armors)); //1 armor and 1 ring
	min_cost = min(min_cost, find_min_cost(weapons, rings, rings, empty_items)); //2 rings and no armor
	min_cost = min(min_cost, find_min_cost(weapons, rings, rings, armors)); //2 rings and 1 armor
	writeln("The minimum cost is : ", min_cost);

	int max_cost;
	max_cost = max(max_cost, find_max_cost(weapons, empty_items, empty_items, empty_items)); //no armors and no rings
	max_cost = max(max_cost, find_max_cost(weapons, empty_items, empty_items, armors)); //1 armor and no rings
	max_cost = max(max_cost, find_max_cost(weapons, rings, empty_items, armors)); //1 armor and 1 ring
	max_cost = max(max_cost, find_max_cost(weapons, rings, rings, empty_items)); //2 rings and no armor
	max_cost = max(max_cost, find_max_cost(weapons, rings, rings, armors)); //2 rings and 1 armor
	writeln("The maximum cost is : ", max_cost);

	return 0;
}

int find_max_cost(Item[] weapons, Item[] left_rings, Item[] right_rings, Item[] armors)
{
	int max_cost = 0;
	foreach(i; 0 .. weapons.length)
	{
		foreach(j; 0 .. left_rings.length)
		{
			foreach(k; 0 .. right_rings.length)
			{
				foreach(l; 0 .. armors.length)
				{
					auto boss = Player(100, 8, 2);
					auto hero = Player(100, 0, 0);
					hero.use_item(weapons[i]);
					hero.use_item(left_rings[j]);
					hero.use_item(right_rings[k]);
					hero.use_item(armors[l]);
					int cost = hero.money_spent;
					bool won = simulate_fight(hero, boss);
					if(!won)
						max_cost = max(cost, max_cost);
				}
			}
		}
	}
	return max_cost;
}

int find_min_cost(Item[] weapons, Item[] left_rings, Item[] right_rings, Item[] armors)
{
	int min_cost = int.max;
	foreach(i; 0 .. weapons.length)
	{
		foreach(j; 0 .. left_rings.length)
		{
			foreach(k; 0 .. right_rings.length)
			{
				foreach(l; 0 .. armors.length)
				{
					auto boss = Player(100, 8, 2);
					auto hero = Player(100, 0, 0);
					hero.use_item(weapons[i]);
					hero.use_item(left_rings[j]);
					hero.use_item(right_rings[k]);
					hero.use_item(armors[l]);
					int cost = hero.money_spent;
					bool won = simulate_fight(hero, boss);
					if(won)
						min_cost = min(cost, min_cost);
				}
			}
		}
	}
	return min_cost;
}

bool simulate_fight(Player hero, Player boss)
{
	while(true)
	{
		hero.attack(boss);
		if(!boss.alive)
			return true;
		boss.attack(hero);
		if(!hero.alive)
			return false;
	}
}

struct Player
{
	int hp;
	int damage;
	int armor;
	int money_spent;

	this(int hp, int damage, int armor)
	{
		this.hp = hp;
		this.damage = damage;
		this.armor = armor;
	}

	void use_item(Item item)
	{
		damage += item.damage;
		armor += item.armor;
		money_spent += item.cost;
	}

	bool alive()
	{
		return hp > 0;
	}

	void attack(ref Player enemy)
	{
		enemy.hp -= max(1, damage - enemy.armor);
	}
}

void load_items(ref Item[] items, string filename)
{
	foreach(line; File(filename).byLine.map!(to!string))
	{
		string[] row = line.split(" ");

		Item current;
		current.cost = row[1].strip.to!int;
		current.damage = row[2].strip.to!int;
		current.armor = row[3].strip.to!int;
		items ~= current;
	}
}

struct Item
{
	int cost;
	int damage;
	int armor;
}
//~~
