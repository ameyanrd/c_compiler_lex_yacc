#include <string.h>
#include <stdio.h>

struct SymbolT{
    char name[105];  //name  of symbol
    char type[105];  // type of symbol
    int length;       //length of symbol
}st[1005];          //table of 1005 elements

struct ConstantT{

    char name[105];     //name of constant
    char type[105];     //type of constant
    int length;         //length of constnt
}ct[1005];              //table of 1005 elements


//Hash Function to calc index in symbol table
int HashFunc(char *str)
{
    int index=0;

    int n=strlen(str);

    for(int i=0;i<n;i++){

        //calc value of index
        index=(index*10+(str[i]-'A'));      
        index=index%1005;

        //if index is negative
        while(index<0){
            index+=1005;
        }
    }
    return index;
}

//function to check if symbol or constant is present in table
int lookup(char *str,int table){

    if(table==0){   //symbol table lookup

        int index=HashFunc(str);//index of symbol

        if(st[index].length==0){
            //if not present
            return 0;
        }
        else if(!strcmp(st[index].name, str)){
            // if present
            return 1;
        }
        else{

            for(int i=index+1;i!=index;i=(i+1)%1005){
                //find index value of symbl
                if(!strcmp(st[i].name, str)){
                    return 1;
                }
            }
            return 0;
        }
    }
    else{
        //index of constant in table
        int index=HashFunc(str);
        
        if(ct[index].length==0){
            //if not present
            if(ct[index].length==0){
                return 0;
            }
            else if(!strcmp(ct[index].name, str)){
                // if present
                return 1;
            }
            else{

                for(int i=index+1;i!=index;i=(i+1)%1005){
                    //find index value of symbl
                    if(!strcmp(ct[index].name, str)){
                        return 1;
                    }
                }
                return 0;
            }
        }
    }
}


//insert symbol and constant in table
void insert(char *str1,char *str2,int table){

    //symbol table
    if(table==0){

        //if not present
        if(lookup(str1,0)){
            return;
        }
        else{
            //calc index
            int index=HashFunc(str1);

            //if not present
            if(st[index].length==0){

                //insert in table
                strcpy(st[index].name,str1);
				strcpy(st[index].type,str2);
                st[index].length=strlen(str1);
                return;
            }

            int temp=0;

            //find index of empty place
            for(int i=index+1;i!=index;i=(i+1)%1005){

                if(st[i].length==0){
                    temp=i;
                    break;
                }
            }
            //insert in table
            strcpy(st[temp].name,str1);
			strcpy(st[temp].type,str2);
			st[temp].length = strlen(str1);
        }
    }
    else{
        //constant table
        if(lookup(str1, 1))
				return;
			else
			{
                //calc index in constant table
				int index = HashFunc(str1);

                //if not present
				if(ct[index].length == 0)
				{
                    //insert in table
					strcpy(ct[index].name,str1);
					strcpy(ct[index].type,str2);
					ct[index].length = strlen(str1);
					return;
				}

				int pos = 0;
                //calc index of empty place
				for (int i = index + 1 ; i!=index ; i = (i+1)%1005)
				{
					if(ct[i].length == 0)
					{
						pos = i;
						break;
					}
				}

                //insert in table
				strcpy(ct[index].name,str1);
				strcpy(ct[index].type,str2);
				ct[index].length = strlen(str1);
			}

    }
}


//Function to print tables
void PrintTables(){

    printf("================\nSYMBOL TABLE\n================\n");

    for(int i=0;i<1005;i++){

        if(st[i].length==0){
            continue;
        }
        printf("\t%s\t\t|\t%s\n",st[i].name, st[i].type);
    }
    printf("\n===============\nCONSTANT TABLE\n===============\n");
		for(int i = 0 ; i < 1005 ; i++)
		{
			if(ct[i].length == 0)
				continue;

			printf("\t%s\t\t|\t%s\n",ct[i].name, ct[i].type);
		}

}
