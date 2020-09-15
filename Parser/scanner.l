%{
	#include <stdio.h>
	#include <string.h>
	#include "y.tab.h"

	#define ANSI_COLOR_RED		"\x1b[31m"
	#define ANSI_COLOR_GREEN	"\x1b[32m"
	#define ANSI_COLOR_YELLOW	"\x1b[33m"
	#define ANSI_COLOR_BLUE		"\x1b[34m"
	#define ANSI_COLOR_MAGENTA	"\x1b[35m"
	#define ANSI_COLOR_CYAN		"\x1b[36m"
	#define ANSI_COLOR_RESET	"\x1b[0m"

	struct symbolTable
	{
		char name[100];
		char class[100];
		char type[100];
		char value[100];
		int lineno;
		int length;
	}ST[1001];

	struct constantTable
	{
		char name[100];
		char type[100];
		int length;
	}CT[1001];

	int hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			value = 10*value + (str[i] - 'A');
			value = value % 1001;
			while(value < 0)
				value = value + 1001;
		}
		return value;
	}

	int lookup(char *str, int lookupMode)
	{
        if(lookupMode == 0)
        {
            int value = hash(str);
            if(ST[value].length == 0)
            {
                return 0;
            }
            else if(strcmp(ST[value].name,str)==0)
            {	
                return 1;
            }
            else
            {
                for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
                {
                    if(strcmp(ST[i].name,str)==0)
                    {
                        return 1;
                    }
                }
                return 0;
            }
        }
        else
		{
			int value = hash(str);
			if(CT[value].length == 0)
				return 0;
			else if(strcmp(CT[value].name,str)==0)
				return 1;
			else
			{
				for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(strcmp(CT[i].name,str)==0)
					{
						return 1;
					}
				}
				return 0;
			}
		}
		
	}

	void insert(char *str1, char *str2, int insertMode)
	{
		if(insertMode == 0)
		{
			if(lookup(str1, 0))
			{
				return;
			}
			else
			{
				int value = hash(str1);
				if(ST[value].length == 0)
				{
					strcpy(ST[value].name,str1);
					strcpy(ST[value].type,str2);
					ST[value].length = strlen(str1);
					return;
				}

				int pos = 0;

				for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(ST[i].length == 0)
					{
						pos = i;
						break;
					}
				}

				strcpy(ST[pos].name,str1);
				strcpy(ST[pos].type,str2);
				ST[pos].length = strlen(str1);
			}
		}
		else
		{
			if(lookup(str1, 1))
				return;
			else
			{
				int value = hash(str1);
				if(CT[value].length == 0)
				{
					strcpy(CT[value].name,str1);
					strcpy(CT[value].type,str2);
					CT[value].length = strlen(str1);
					return;
				}

				int pos = 0;

				for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
				{
					if(CT[i].length == 0)
					{
						pos = i;
						break;
					}
				}

				strcpy(CT[pos].name,str1);
				strcpy(CT[pos].type,str2);
				CT[pos].length = strlen(str1);
			}
		}
	}


	void insertSTtype(char *str1, char *str2)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].name,str1)==0)
			{
				strcpy(ST[i].type,str2);
			}
		}
    }

	void insertSTvalue(char *str1, char *str2)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].name,str1)==0)
			{
				strcpy(ST[i].value,str2);
			}
		}
	}

	void insertSTline(char *str1, int line)
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(strcmp(ST[i].name,str1)==0)
			{
				ST[i].lineno = line;
			}
		}
	}

    void printTables()
	{
		printf("\n\nSYMBOL TABLE\n\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(ST[i].length == 0)
			{
				continue;
			}

			printf("\t%s\t\t\t%s\n",ST[i].name, ST[i].type);
		}
		printf("\n\nCONSTANT TABLE\n\n");
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(CT[i].length == 0)
				continue;

			printf("\t%s\t\t\t%s\n",CT[i].name, CT[i].type);
		}
	}

	char curid[20];
	char curtype[20];
	char curval[20];
        int yylineno;

%}


%%
\n 	{yylineno++;}
\/\/(.*)																		{ }
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/										{ }
[ \n\t] ;
";"				{ return(';'); }
","				{ return(','); }
("{")			{ return('{'); }
("}")			{ return('}'); }
"("				{ return('('); }
")"				{ return(')'); }
("["|"<:")		{ return('['); }
("]"|":>") 		{ return(']'); }
":"				{ return(':'); }
"."				{ return('.'); }

"char"			{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0); return CHAR;}
"double"		{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0); return DOUBLE;}
"else"			{ insertSTline(yytext, yylineno); insert(yytext, "Keyword", 0); return ELSE;}
"float"			{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);return FLOAT;}
"while"			{ insert(yytext, "Keyword", 0); return WHILE;}
"do"			{ insert(yytext, "Keyword", 0); return DO;}
"for"			{ insert(yytext, "Keyword", 0); return FOR;}
"if"			{ insert(yytext, "Keyword", 0); return IF;}
"int"			{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);return INT;}
"long"			{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);  return LONG;}
"return"		{ insert(yytext, "Keyword", 0);  return RETURN;}
"short"			{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);  return SHORT;}
"signed"		{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);  return SIGNED;}
"sizeof" 		{ insert(yytext, "Keyword", 0);  return SIZEOF;}
"struct"		{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);  return STRUCT;}
"unsigned"		{ insert(yytext, "Keyword", 0);  return UNSIGNED;}
"void"			{ strcpy(curtype,yytext); insert(yytext, "Keyword", 0);  return VOID;}
"break"			{ insert(yytext, "Keyword", 0);  return BREAK;}


"++"			{ return increment_operator; }
"--"			{ return decrement_operator; }
"<<"			{ return leftshift_operator; }
">>"			{ return rightshift_operator; }
"<="			{ return lessthan_assignment_operator; }
"<"				{ return lessthan_operator; }
">="			{ return greaterthan_assignment_operator; }
">"				{ return greaterthan_operator; }
"=="			{ return equality_operator; }
"!="			{ return inequality_operator; }
"&&"			{ return AND_operator; }
"||"			{ return OR_operator; }
"^"				{ return caret_operator; }
"*="			{ return multiplication_assignment_operator; }
"/="			{ return division_assignment_operator; }
"%="			{ return modulo_assignment_operator; }
"+="			{ return addition_assignment_operator; }
"-="			{ return subtraction_assignment_operator; }
"<<="			{ return leftshift_assignment_operator; }
">>="			{ return rightshift_assignment_operator; }
"&="			{ return AND_assignment_operator; }
"^="			{ return XOR_assignment_operator; }
"|="			{ return OR_assignment_operator; }
"&"				{ return amp_operator; }
"!"				{ return exclamation_operator; }
"~"				{ return tilde_operator; }
"-"				{ return subtract_operator; }
"+"				{ return add_operator; }
"*"				{ return multiplication_operator; }
"/"				{ return division_operator; }
"%"				{ return modulo_operator; }
"|"				{ return pipe_operator; }
\=				{ return assignment_operator;}

\"[^\n]*\"/[;|,|\)] 			{strcpy(curval,yytext); insert(yytext,"String Constant", 1); return string_constant;}
\'[A-Z|a-z]\'/[;|,|\)|:] 		{strcpy(curval,yytext); insert(yytext,"Character Constant", 1); return character_constant;}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ 	{strcpy(curid,yytext); insert(yytext, "Array Identifier", 0);  return identifier;}
[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] 	{strcpy(curval,yytext); insert(yytext, "Number Constant", 1); return integer_constant;}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] 	{strcpy(curval,yytext); insert(yytext, "Floating Constant", 1); return float_constant;}
[A-Za-z_][A-Za-z_0-9]* {strcpy(curid,yytext);insert(yytext,"Identifier", 0);  return identifier;}

(.?) {
		if(yytext[0]=='#')
		{
			printf("Error in Pre-Processor directive at line no. %d\n",yylineno);
		}
		else if(yytext[0]=='/')
		{
			printf("ERR_UNMATCHED_COMMENT at line no. %d\n",yylineno);
		}
		else if(yytext[0]=='"')
		{
			printf("ERR_INCOMPLETE_STRING at line no. %d\n",yylineno);
		}
		else
		{
			printf("ERROR at line no. %d\n",yylineno);
		}
		printf("%s\n", yytext);
		return 0;
}

%%
