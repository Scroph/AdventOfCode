import std.stdio;
import std.datetime : StopWatch;
import std.algorithm;

int main(string[] args)
{
	auto fh = File(args[1]);
	bool with_calories = args.canFind("--with-calories");

	string format = "%s: capacity %d, durability %d, flavor %d, texture %d, calories %d\r\n";
	Ingredient i;
	Ingredient[] ingredients;
	while(fh.readf(format, &i.name, &i.capacity, &i.durability, &i.flavor, &i.texture, &i.calories))
		ingredients ~= i;

	ulong max_score = 0UL;
	int[] teaspoons = new int[ingredients.length];
	long from_100 = 0;
	StopWatch sw;
	sw.start();
	scope(exit)
		sw.stop();
	while(true)
	{
		from_base(from_100++, 101, teaspoons);
		if(teaspoons.all!(x => x == 100))
			break;
		if(teaspoons.sum == 100)
		{
			ulong score = ingredients.calculate_score(teaspoons, with_calories);
			if(score > max_score)
				max_score = score;
		}
	}
	writeln("Total time elapsed : ", sw.peek().seconds, " seconds");
	writeln(max_score);

	return 0;
}

void from_base(long number, int base, ref int[] numbers)
{
	int index = numbers.length - 1;
	do
	{
		numbers[index--] = number % base;
		number /= base;
	}
	while(number);
}

ulong calculate_score(Ingredient[] ingredients, int[] amounts, bool with_calories = false)
{
	ulong score;
	Ingredient cookie;
	foreach(i, ingredient; ingredients)
	{
		cookie.capacity 	+= amounts[i] * ingredient.capacity;
		cookie.durability 	+= amounts[i] * ingredient.durability;
		cookie.flavor		+= amounts[i] * ingredient.flavor;
		cookie.texture	 	+= amounts[i] * ingredient.texture;
		if(with_calories)
			cookie.calories	+= amounts[i] * ingredient.calories;
	}
	int[] parts = [cookie.capacity, cookie.durability, cookie.flavor, cookie.texture];
	if(with_calories && cookie.calories != 500)
		return 0;
	if(parts.any!(x => x <= 0))
		return 0;
	return reduce!((a, b) => a * b)(1, parts);
}

struct Ingredient
{
	string name;
	int capacity;
	int durability;
	int flavor;
	int texture;
	int calories;
}
//~~
