#include <stdio.h>
#include <scanner.h>

extern int yylex();  /* Returns the first and successively valid token */
extern int yylineno; /* Returns the line where erro occurs */
extern char* yytext; /* Returns the text of the token */

int main() {
    int token = yylex();
    while (token) {
        switch (token) {
            case KEYWORD:
                printf("Keyword!!\n");
                break;
            case IDENTIFIER:
                printf("Identifier!!\n");
                break;
            case SPECIAL_SYM:
                printf("Special Symbol!!\n");
                break;
            default:
                printf("Not identified!!\n");
                break;
        }
        token = yylex();
    }
    return 0;
}
