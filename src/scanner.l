%{
#include "keywords.h"
#include "scanner.h"
#include "tables.h"
%}

special_sym [;,\{\}\(\)\[\]\:\\\.]
multiline_comment \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/
op [[<][=]|[>][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]
flt_num ([0-9]*)\.([0-9]+)
num [1-9][0-9]*|0

%%
\n                              {
                                    yylineno++;
                                }
\/\/(.*)                        {
                                    return S_COMMENT;
                                }
{multiline_comment}             {
                                    return M_COMMENT;
                                }
[ \n\t]                         ;
{special_sym}                    return SPECIAL_SYM;
[a-zA-Z_][a-zA-Z0-9_]*     {
                                    if (isKeyword(yytext)) {
                                        insert(yytext, "KEYWORD", 0);
                                        return KEYWORD;
                                     } else {
                                        insert(yytext, "IDENTIFIER", 0);
                                        return IDENTIFIER;
                                    }       
                                }
\"[^\n]*\"/[;|,|\)|\}]          {
                                    insert(yytext,"STRING CONSTANT", 1);
                                    return CONSTANT; /* String Constant */
                                }
\'[A-Z|a-z]\'/[;|,|\)|:|\}]     {
                                    insert(yytext,"CHARACTER CONSTANT", 1);
                                    return CONSTANT; /*Char Constant */
                                }
{op}                            return OPERATOR;

{num}                           {
                                    insert(yytext, "NUMBER CONSTANT", 1);
                                    return CONSTANT; /* Integer Constant */
                                }
{flt_num}                       {
                                    insert(yytext, "FLOATING CONSTANT", 1);
                                    return CONSTANT; /* Float Constant */
                                }
(.?)                            return NONE;
%%

int yywrap(void) {
    return 1;
}
/**
  temp = (var)
  */
