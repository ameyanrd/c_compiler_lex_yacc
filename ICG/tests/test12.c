// Function call inside while inside for
#include<stdio.h>

void function(int a, int b){
    printf("Function called!");
}
int main(){
    int i, j;
    for(i = 0; i < 5; i++){
        j = 0;
        while(j < 5){
            j+=1;
            if(i == 0){
                printf("i is 0.");
            }
            else if(i == 1){
                function(i, j);
            }
        }
    }
    return 0;
}
