// Correct Code

#include<stdio.h>

void addFunc(int a, int b)
{
	int ans;
	ans = a + b;
}

int main()
{
	int a;
	int b;
	a = 2;
	b = 4;
	if(a < b)
	{
		int c;
		c = a + b;
	}
	addFunc(a, b);
}
