import std.stdio;
import std.range : lockstep, iota, retro;
import std.datetime : StopWatch;
import std.string : indexOf;
import std.conv : to;
import std.algorithm.mutation : reverse;

int main(string[] args)
{
	auto last_permutation = args[1].dup;
	int permutations = args.length > 2 ? args[2].to!int : 2;
	StopWatch watch;
	watch.start();
	auto last_tick = watch.peek.msecs;
	while(permutations--)
	{
		auto current = last_permutation.next_valid_permutation;
		auto now = watch.peek.msecs;
		current.writeln;
		writeln("Elapsed time : ", now - last_tick, " milliseconds.");
		last_tick = now;
		last_permutation = current;
	}
	watch.stop();

	return 0;
}

char[] next_valid_permutation(char[] password)
{
	auto result = password.dup;
	do
		result = result.next_permutation;
	while(!result.is_valid);
	return result;
}

char[] next_permutation(char[] password)
{
	return to_string(password.to_base26 + 1);
}

ulong to_base26(char[] password)
{
	ulong base26;
	for(int i = password.length - 1, j = 0; i >= 0; i--, j++)
	{
		int letter = password[i] - 'a';
		base26 += letter * (26UL ^^ j);
	}
	return base26;
}

char[] to_string(ulong number)
{
	char[] password;
	while(number > 0)
	{
		password ~= ('a' + (number % 26));
		number /= 26;
	}
	reverse(password);
	return password;
}

unittest
{
	assert(1773681352989609UL.to_string == "moroccomall");
	assert("moroccomall".dup.to_base26 == 1773681352989609UL);
}

bool is_valid(char[] password)
{
	char last_letter = password[password.length - 1]; //the remaining letters are checked inside the first loop
	if(last_letter == 'i' || last_letter == 'o' || last_letter == 'l')
		return false;

	char[] overlapping;
	foreach(ref i; 0 .. password.length - 1)
	{
		if(password[i] == 'i' || password[i] == 'o' || password[i] == 'l')
			return false;
		if(password[i] == password[i + 1])
		{
			if(overlapping.indexOf(password[i]) == -1)
				overlapping ~= password[i];
			i++;
		}
	}
	if(overlapping.length < 2)
		return false;
	foreach(i; 0 .. password.length - 2)
		if(password[i] + 1 == password[i + 1] && password[i] + 2 == password[i + 2])
			return true;
	return false;
}

unittest
{
	assert("abcdefgh".dup.is_valid == false);
	assert("ghijklmn".dup.is_valid == false);
	assert("hijklmmn".dup.is_valid == false);
	assert("abbceffg".dup.is_valid == false);
	assert("abbcegjk".dup.is_valid == false);
	assert("abcdffaa".dup.is_valid);
	assert("ghjaabcc".dup.is_valid);
}
