// Correct code - Formal and actual params match
#include<stdio.h>
void function(int a, int b){
	a = a + b;
}
int main(){
	int a;
	int b;
	a = 1;
	b = 2;
	function(a, b);
}
