#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

void print_grid(bool *grid, int width, int height);
void next_generation(bool *grid, int width, int height, bool ignore_corners);
int alive_neighbors(bool *grid, int width, int height, int row, int col);

int main(int argc, char *argv[])
{
	FILE *fh = fopen(argv[1], "r");
	int width = 100, height = 100, col = 0, row = 0, generations = 100;
	bool ignore_corners = false;
	if(argc > 2)
		width = atoi(argv[2]);
	if(argc > 3)
		height = atoi(argv[3]);
	if(argc > 4)
		generations = atoi(argv[4]);
	if(argc > 5)
		ignore_corners = strcmp(argv[5], "--ignore-corners") == 0;

	char line[1024];
	bool grid[width * height];
	while(fgets(line, 1024, fh))
	{
		for(col = 0; col < width; col++)
			grid[row * width + col] = line[col] == '#';
		row++;
	}
	if(ignore_corners)
	{
		grid[0 * width + 0] = true;
		grid[0 * width + (height - 1)] = true;
		grid[(width - 1) * width + 0] = true;
		grid[(width - 1) * width + (height - 1)] = true;
	}
	for(col = 0; col < generations; col++)
		next_generation(grid, width, height, ignore_corners);

	int alive = 0;
	for(row = 0; row < height; row++)
		for(col = 0; col < width; col++)
			if(grid[row * width + col])
				alive++;
	printf("%d alive cells.\n", alive);
	fclose(fh);
	return 0;
}

void next_generation(bool *grid, int width, int height, bool ignore_corners)
{
	int r, c;
	bool old[width * height];
	memcpy(old, grid, width * height);
	for(r = 0; r < height; r++)
	{
		for(c = 0; c < width; c++)
		{
			if(ignore_corners && ((r == 0 && c == 0) || (c == 0 && r == height - 1) || (c == width - 1 && r == 0) || (c == width - 1 && r == height - 1)))
				continue;
			int alive = alive_neighbors(old, width, height, r, c);
			if(old[r * width + c])
				grid[r * width + c] = alive == 3 || alive == 2;
			else
				grid[r * width + c] = alive == 3;
		}
	}
}

int alive_neighbors(bool *grid, int width, int height, int row, int col)
{
	int r, c, count = 0;
	for(r = row - 1; r <= row + 1; r++)
		for(c = col - 1; c <= col + 1; c++)
			if(c != col || r != row)
				if(0 <= r && r < height && 0 <= c && c < width)
					if(grid[r * width + c])
						count++;
	return count;

}

//for debugging purposes
void print_grid(bool *grid, int width, int height)
{
	int r, c;
	for(r = 0; r < height; r++)
	{
		for(c = 0; c < width; c++)
		{
			printf("%c", grid[r * width + c] ? '#' : '.');
		}
		printf("\n");
	}
}
