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
                printf("Keyword!! ");
                printf("%s %d\n", yytext, yylineno);
                break;
            case IDENTIFIER:
                printf("Identifier!! ");
                printf("%s %d\n", yytext, yylineno);
                break;
            case SPECIAL_SYM:
                printf("Special Symbol!! ");
                printf("%s %d\n", yytext, yylineno);
                break;
            case OPERATOR:
                printf("Operator!! ");
                printf("%s %d\n", yytext, yylineno); 
                break;
            case CONSTANT:
                printf("Constant!! ");
                printf("%s %d\n", yytext, yylineno);
                break;
            case S_COMMENT:
                printf("Single Comment!! ");
                printf("%s %d\n", yytext, yylineno);
                break;
            case M_COMMENT:
                printf("Multiline Comments!! ");
                printf("%s %d\n", yytext, yylineno);
                break;
            default:
                printf("Not identified!!\n");
                printf("%s %d\n", yytext, yylineno);
                if (token == NONE) {
                    printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
                    if(yytext[0]=='#')
                    {
                        printf("ERROR: Error in Pre-Processor directive at line no. %d\n",yylineno);
                    }
                    else if(yytext[0]=='/')
                    {
                        printf("ERROR: UNMATCHED_COMMENT at line no. %d\n",yylineno);
                    }
                    else if(yytext[0]=='"')
                    {
                        printf("ERROR: INCOMPLETE_STRING at line no. %d\n",yylineno);
                    }
                    else
                    {
                        printf("ERROR: at line no. %d\n",yylineno);
                    }
                    printf("\t%s\n", yytext);
                    printf("\t^^\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
                }
                break;
        }
        token = yylex();
    }
    PrintTables();
    return 0;
}
