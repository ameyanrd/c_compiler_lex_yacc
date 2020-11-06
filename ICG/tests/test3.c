// Variable defined outside the scope.
#include <stdio.h>

int main() {
	
	if(3 > 2){
		int a = 5;
		printf("%d", a);
	}
	
	printf("%d", a);
}
