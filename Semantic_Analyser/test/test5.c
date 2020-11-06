// Semantic error - Type mismatch of formal and actual parameters
#include<stdio.h>

void functionPow2(int a, double b){
	a = a + a;
}

int main(){
	double a;
	int b;
	a = 2.0;
	b = 4;
	functionPow2(a, b);
}
