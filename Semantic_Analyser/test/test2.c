// Variable c defined in the function again.
#include<stdio.h>

int add(int a, int b, int c) {
	int c = a + b;
	return c;
}


int main() {

	int a = 20;
	int b = 30;
	int c = 0;

	int res = add(a, b, c);
	printf("%d", res);

	return 0;
}
