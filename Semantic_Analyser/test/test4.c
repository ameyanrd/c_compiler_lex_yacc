// Semantic error - Number of formal and actual parameters is different

#include<stdio.h>

void funcPow2(int a){
	a = a + a;
}

int main(){
	int a;
	int b;
	a = 2;
	b = 4;
	funcPow2(a, b);
}
