#include <stdio.h>
#include <scanner.h>
#include <tables.h>

extern int yylex();  /* Returns the first and successively valid token */
extern int yylineno; /* Returns the line where erro occurs */
extern char* yytext; /* Returns the text of the token */

int main() {
    int token = yylex();
    while (token) {
        switch (token) {
            case KEYWORD:
                printf("Keyword\t");
                printf("%s\t%d\n", yytext, yylineno);
                break;
            case IDENTIFIER:
                printf("Identifier\t");
                printf("%s\t%d\n", yytext, yylineno);
                break;
            case SPECIAL_SYM:
                printf("Special Symbol\t");
                printf("%s\t%d\n", yytext, yylineno);
                break;
            case OPERATOR:
                printf("Operator\t");
                printf("%s\t%d\n", yytext, yylineno); 
                break;
            case CONSTANT:
                printf("Constant\t");
                printf("%s\t%d\n", yytext, yylineno);
                break;
            case S_COMMENT:
                printf("Single Comment\t");
                printf("%s\t%d\n", yytext, yylineno);
                break;
            case M_COMMENT:
                printf("Multiline Comments\t");
                printf("%s\t%d\n", yytext, yylineno);
                break;
            default:
                printf("%s\t%d\n", yytext, yylineno);
                if (token == NONE) {
                    printf("-------------------------------------------------------------\n");
                    if(yytext[0]=='#')
                    {
                        printf("err: Error in Pre-Processor directive at line no. %d\n",yylineno);
                    }
                    else if(yytext[0]=='/')
                    {
                        printf("err: unmatched comment at line no. %d\n",yylineno);
                    }
                    else if(yytext[0]=='"')
                    {
                        printf("err: incomplete string at line no. %d\n",yylineno);
                    }
                    else
                    {
                        printf("err: at line no. %d\n",yylineno);
                    }
                    printf("\t%s\n", yytext);
                    printf("\t^^\n-------------------------------------------------------------\n");
                }
                break;
        }
        token = yylex();
    }
    PrintTables();
    return 0;
}
