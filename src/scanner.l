%{
#include "keywords.h"
#include "scanner.h"
%}

special_sym [\[\]\{\};,]

%%
[a-z A-Z _][a-z A-Z 0-9 _]*     {
                                    if (isKeyword(yytext))
                                        return KEYWORD;
                                    else
                                        return IDENTIFIER;
                                }
{special_sym}                    return SPECIAL_SYM;
.                               return NONE;

%%

int yywrap(void) {
    return 1;
}
