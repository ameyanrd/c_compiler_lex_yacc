/**
 * Keywords in C language
 */

#include <string.h>
#define FALSE 0
#define TRUE 1

 
char* keywords[] = {
	"auto",
	"double",
	"int",
	"struct",
	"break",
	"else",
	"long",
	"switch",
	"case",
	"enum",
	"register",
	"typedef",
	"char",
	"extern",
	"return",
	"union",
	"continue",
	"for",
	"signed",
	"void",
	"do",
	"if",
	"static",
	"while",
	"default",
	"goto",
	"sizeof",
	"volatile",
	"const",
	"float",
	"short",
	"unsigned",
	NULL
};

int isKeyword(char word[]) {
	int i=0;
	while (keywords[i] != NULL) {
		if (!strcmp(keywords[i], word))
			return TRUE;
		i++;
	}
	return FALSE;
}
