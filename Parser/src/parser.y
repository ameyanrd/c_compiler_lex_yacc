%{
	void yyerror(char* s);
	int yylex();
	#include "stdio.h"
	#include "stdlib.h"
	#include "ctype.h"
	#include "string.h"
	void ins();
	void insV();
	int flag=0;

	extern char curid[20];
	extern char curtype[20];
	extern char curval[20];

%}

%nonassoc IF
%token INT CHAR FLOAT DOUBLE LONG SHORT SIGNED UNSIGNED STRUCT
%token RETURN MAIN
%token VOID
%token WHILE FOR DO 
%token BREAK
%token ENDIF
%expect 2

%token identifier
%token integer_constant string_constant float_constant character_constant

%nonassoc ELSE

%right leftshift_assignment_op rightshift_assignment_op
%right XOR_assignment_op OR_assignment_op
%right AND_assignment_op modulo_assignment_op
%right multiplication_assignment_op division_assignment_op
%right addition_assignment_op subtraction_assignment_op
%right assignment_op

%left OR_op
%left AND_op
%left pipe_op
%left caret_op
%left amp_op
%left equality_op inequality_op
%left lessthan_assignment_op lessthan_op greaterthan_assignment_op greaterthan_op
%left leftshift_op rightshift_op 
%left add_op subtract_op
%left multiplication_op division_op modulo_op

%right SIZEOF
%right tilde_op exclamation_op
%left increment_op decrement_op 


%start program

%%
program
			: declaration_list;

declaration_list
			: declaration D 

D
			: declaration_list
			| ;

declaration
			: variable_declaration 
			| function_declaration
			| structure_definition;

variable_declaration
			: type_specifier variable_declaration_list ';' 
			| structure_declaration;

variable_declaration_list
			: variable_declaration_identifier V;

V
			: ',' variable_declaration_list 
			| ;

variable_declaration_identifier 
			: identifier { ins(); } vdi;

vdi : identifier_array_type | assignment_op expression ; 

identifier_array_type
			: '[' initilization_params
			| ;

initilization_params
			: integer_constant ']' initilization
			| ']' string_initilization;

initilization
			: string_initilization
			| array_initialization
			| ;

type_specifier 
			: INT | CHAR | FLOAT | DOUBLE 
			| LONG long_grammar 
			| SHORT short_grammar
			| UNSIGNED unsigned_grammar 
			| SIGNED signed_grammar
			| VOID ;

unsigned_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

signed_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

long_grammar 
			: INT | ;

short_grammar 
			: INT | ;

structure_definition
			: STRUCT identifier { ins(); } '{' V1  '}' ';';

V1 : variable_declaration V1 | ;

structure_declaration 
			: STRUCT identifier variable_declaration_list;


function_declaration
			: function_declaration_type function_declaration_param_statement;

function_declaration_type
			: type_specifier identifier '('  { ins();};

function_declaration_param_statement
			: params ')' statement;

params 
			: parameters_list | ;

parameters_list 
			: type_specifier parameters_identifier_list;

parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup;

parameters_identifier_list_breakup
			: ',' parameters_list 
			| ;

param_identifier 
			: identifier { ins(); } param_identifier_breakup;

param_identifier_breakup
			: '[' ']'
			| ;

statement 
			: expression_statment | compound_statement 
			| conditional_statements | iterative_statements 
			| return_statement | break_statement 
			| variable_declaration;

compound_statement 
			: '{' statment_list '}' ;

statment_list 
			: statement statment_list 
			| ;

expression_statment 
			: expression ';' 
			| ';' ;

conditional_statements 
			: IF '(' simple_expression ')' statement conditional_statements_breakup;

conditional_statements_breakup
			: ELSE statement
			| ;

iterative_statements 
			: WHILE '(' simple_expression ')' statement 
			| FOR '(' expression ';' simple_expression ';' expression ')' 
			| DO statement WHILE '(' simple_expression ')' ';';

return_statement 
			: RETURN return_statement_breakup;

return_statement_breakup
			: ';' 
			| expression ';' ;

break_statement 
			: BREAK ';' ;

string_initilization
			: assignment_op string_constant { insV(); };

array_initialization
			: assignment_op '{' array_int_declarations '}';

array_int_declarations
			: integer_constant array_int_declarations_breakup;

array_int_declarations_breakup
			: ',' array_int_declarations 
			| ;

expression 
			: mutable expression_breakup
			| simple_expression ;

expression_breakup
			: assignment_op expression 
			| addition_assignment_op expression 
			| subtraction_assignment_op expression 
			| multiplication_assignment_op expression 
			| division_assignment_op expression 
			| modulo_assignment_op expression 
			| increment_op 
			| decrement_op ;

simple_expression 
			: and_expression simple_expression_breakup;

simple_expression_breakup 
			: OR_op and_expression simple_expression_breakup | ;

and_expression 
			: unary_relation_expression and_expression_breakup;

and_expression_breakup
			: AND_op unary_relation_expression and_expression_breakup
			| ;

unary_relation_expression 
			: exclamation_op unary_relation_expression 
			| regular_expression ;

regular_expression 
			: sum_expression regular_expression_breakup;

regular_expression_breakup
			: relational_ops sum_expression 
			| ;

relational_ops 
			: greaterthan_assignment_op | lessthan_assignment_op | greaterthan_op 
			| lessthan_op | equality_op | inequality_op ;

sum_expression 
			: sum_expression sum_ops term 
			| term ;

sum_ops 
			: add_op 
			| subtract_op ;

term
			: term MULOP factor 
			| factor ;

MULOP 
			: multiplication_op | division_op | modulo_op ;

factor 
			: immutable | mutable ;

mutable 
			: identifier 
			| mutable mutable_breakup;

mutable_breakup
			: '[' expression ']' 
			| '.' identifier;

immutable 
			: '(' expression ')' 
			| call | constant;

call
			: identifier '(' arguments ')';

arguments 
			: arguments_list | ;

arguments_list 
			: expression A;

A
			: ',' expression A 
			| ;

constant 
			: integer_constant 	{ insV(); } 
			| string_constant	{ insV(); } 
			| float_constant	{ insV(); } 
			| character_constant{ insV(); };

%%

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
void insertSTtype(char *,char *);
void insertSTvalue(char *, char *);
void incertCT(char *, char *);
void printST();
void printCT();

int main(int argc , char **argv)
{
	yyin = fopen(argv[1], "r");
	yyparse();

	if(flag == 0)
	{
		printf("Parsing Successful\n");
		printST();

		printCT();
	}
}

void yyerror(char *s)
{
	printf("%d %s %s\n", yylineno, s, yytext);
	flag=1;
	printf("Parsing Failed\n");
}

void ins()
{
	insertSTtype(curid,curtype);
}

void insV()
{
	insertSTvalue(curid,curval);
}

int yywrap()
{
	return 1;
}
