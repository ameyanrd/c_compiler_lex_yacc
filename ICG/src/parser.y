%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	
	void yyerror(char* s);
	int yylex();
	void ins();
	void insV();
	int flag=0;
	extern char curid[20];
	extern char curtype[20];
	extern char curval[20];
	extern int currnest;
	void deleteData (int );
	int identifierInScope(char*);
	int isIdentifierAFunc(char *);
	void insertST(char*, char*);
	void insertIdentifierNestVal(char*, int);
	void insertFuncArgsCount(char*, int);
	int getFuncArgsCount(char*);
	int check_isIdentifierAlreadyDeclared(char*);
	int isFuncDeclared(char*, char *);
	int areFuncArgsNotVoid(char*);
	int isIdentifierAlreadyDeclared(char *s);
	int isIdentifierAnArray(char*);
	char currfunctype[100];
	char currfunc[100];
	char currfunccall[100];
	void insertSTF(char*);
	char getFirstCharOfIDDatatype(char*,int);
	char getfirst(char*);
	void push(char *s);
	void codegen();
        void codegendoubleop();
	void codeassign();
	char* itoa(int num, char* str, int base);
	void reverse(char str[], int length); 
	void swap(char*,char*);
	void label1();
	void label2();
	void label3();
	void label4();
	void label5();
	void label6();
        void label7();
        void label8();
	void genunary();
	void codegencon();
	void funcgen();
	void funcgenend();
	void arggen();
	void callgen();

        extern int yylineno;

	int params_count=0;
	int call_params_count=0;
	int top = 0,count=0,ltop=0,lno=0;
	char temp[3] = "t";
        int case_stmt_num = 0, case_var_val, case_exit_label = -1, default_num = 0;
%}

%nonassoc IF
%token INT CHAR FLOAT DOUBLE LONG SHORT SIGNED UNSIGNED STRUCT
%token RETURN MAIN
%token VOID
%token WHILE FOR DO 
%token BREAK
%token ENDIF
%token SWITCH CASE DEFAULT
%expect 1

%token identifier array_identifier func_identifier
%token integer_constant string_constant float_constant character_constant

%nonassoc ELSE

%right leftshift_assignment_operator rightshift_assignment_operator
%right XOR_assignment_operator OR_assignment_operator
%right AND_assignment_operator modulo_assignment_operator
%right multiplication_assignment_operator division_assignment_operator
%right addition_assignment_operator subtraction_assignment_operator
%right assignment_operator

%left OR_operator
%left AND_operator
%left pipe_operator
%left caret_operator
%left amp_operator
%left equality_operator inequality_operator
%left lessthan_assignment_operator lessthan_operator greaterthan_assignment_operator greaterthan_operator
%left leftshift_operator rightshift_operator 
%left add_operator subtract_operator
%left multiplication_operator division_operator modulo_operator

%right SIZEOF
%right tilde_operator exclamation_operator
%left increment_operator decrement_operator 
%left ':'

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
                        | switch_logic

variable_declaration
			: type_specifier variable_declaration_list ';' 

variable_declaration_list
			: variable_declaration_list ',' variable_declaration_identifier | variable_declaration_identifier;

variable_declaration_identifier 
			: identifier {if(isIdentifierAlreadyDeclared(curid)){printf("\nLine %d: Semantic error: Variable '%s' is already declared.\n\n", yylineno, curid);exit(0);}insertIdentifierNestVal(curid,currnest); ins();  } vdi   
			  | array_identifier {if(isIdentifierAlreadyDeclared(curid)){printf("isIdentifierAlreadyDeclared\n");exit(0);}insertIdentifierNestVal(curid,currnest); ins();  } vdi;
			
			

vdi : identifier_array_type | assignment_operator simple_expression  ; 

identifier_array_type
			: '[' initilization_params
			| ;

initilization_params
			: integer_constant ']' initilization {if($$ < 1) {printf("Wrong array size\n"); exit(0);} }
			| ']' string_initilization;

initilization
			: string_initilization
			| array_initialization
			| ;

type_specifier 
			: INT | CHAR | FLOAT  | DOUBLE  
			| LONG long_grammar 
			| SHORT short_grammar
			| UNSIGNED unsigned_grammar 
			| SIGNED signed_grammar
			| VOID  ;

unsigned_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

signed_grammar 
			: INT | LONG long_grammar | SHORT short_grammar | ;

long_grammar 
			: INT  | ;

short_grammar 
			: INT | ;

function_declaration
			: function_declaration_type function_declaration_param_statement;

function_declaration_type
			: type_specifier identifier '('  { strcpy(currfunctype, curtype); strcpy(currfunc, curid); check_isIdentifierAlreadyDeclared(curid); insertSTF(curid); ins(); };

function_declaration_param_statement
			: {params_count=0;}params ')' {funcgen();} statement {funcgenend();};

params 
			: parameters_list { insertFuncArgsCount(currfunc, params_count); }| { insertFuncArgsCount(currfunc, params_count); };

parameters_list 
			: type_specifier { areFuncArgsNotVoid(curtype);} parameters_identifier_list ;

parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup;

parameters_identifier_list_breakup
			: ',' parameters_list 
			| ;

param_identifier 
			: identifier { ins();insertIdentifierNestVal(curid,1); params_count++; } param_identifier_breakup;

param_identifier_breakup
			: '[' ']'
			| ;

statement 
			: expression_statment | compound_statement 
			| conditional_statements | iterative_statements 
			| return_statement | break_statement 
			| variable_declaration
                        | switch_logic;

switch_logic            : {label8(); case_exit_label = lno-1;} SWITCH '(' identifier {case_var_val = count-1;}')' {label7();} '{' case_stmts default_stmt'}' {
                                                    label6();
                                                    printf("L%d:\n",case_exit_label);
                                                    case_exit_label = -1;
                                                };

case_stmts              : case_stmt case_stmts | ;

case_stmt               : {label4(); case_stmt_num++;}CASE constant ':' statment_list;

default_stmt            : {label4(); default_num = 1;}DEFAULT ':' statment_list;

compound_statement 
			: {currnest++;} '{'  statment_list  '}' {deleteData(currnest);currnest--;}  ;

statment_list 
			: statement statment_list 
			| ;

expression_statment 
			: expression ';' 
			| ';' ;

conditional_statements 
			: IF '(' simple_expression ')' {label1();if($3!=1){printf("Condition checking is not of type int\n");exit(0);}} statement {label2();}  conditional_statements_breakup;

conditional_statements_breakup
			: ELSE statement {label3();}
			| {label3();};

iterative_statements 
			: WHILE '(' {label4();} simple_expression ')' {label1();if($4!=1){printf("Condition checking is not of type int\n");exit(0);}} statement {label5();} 
			| FOR '(' expression ';' {label4();} simple_expression ';' {label1();if($6!=1){printf("Condition checking is not of type int\n");exit(0);}} expression ')'statement {label5();} 
			| {label4();}DO statement WHILE '(' simple_expression ')'{label1();label5();if($6!=1){printf("Condition checking is not of type int\n");exit(0);}} ';';
return_statement 
			: RETURN ';' {if(strcmp(currfunctype,"void")) {printf("Returning void of a non-void function\n"); exit(0);}}
			| RETURN expression ';' { 	if(!strcmp(currfunctype, "void"))
										{ 
											yyerror("Function is void");
										}

										if((currfunctype[0]=='i' || currfunctype[0]=='c') && $2!=1)
										{
											printf("Expression doesn't match return type of function\n"); exit(0);
										}

									};

break_statement 
                        : BREAK ';' {
                                        if (case_exit_label != -1) {
                                            printf("Goto L%d\n", case_exit_label);
                                        }
                                    };

string_initilization
			: assignment_operator string_constant {insV();} ;

array_initialization
			: assignment_operator '{' array_int_declarations '}';

array_int_declarations
			: integer_constant array_int_declarations_breakup;

array_int_declarations_breakup
			: ',' array_int_declarations 
			| ;

expression 
			: mutable assignment_operator {push("=");} expression   {   
																	  if($1==1 && $4==1) 
																	  {
			                                                          $$=1;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                          codeassign();
			                                                       }
			| mutable addition_assignment_operator {push("+");}expression {  
																	  if($1==1 && $4==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);}
                                                                                  codegendoubleop();
			                                                          codeassign();
			                                                       }
			| mutable subtraction_assignment_operator {push("-");} expression  {	  
																	  if($1==1 && $4==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);}
                                                                                  codegendoubleop();
			                                                          codeassign();
			                                                       }
			| mutable multiplication_assignment_operator {push("*");} expression {
																	  if($1==1 && $4==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);}
                                                                                  codegendoubleop();
			                                                          codeassign(); 
			                                                       }
			| mutable division_assignment_operator {push("/");}expression 		{ 
																	  if($1==1 && $4==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);}
                                                                                  codegendoubleop();
                                                                                  codeassign();
			                                                       }
			| mutable modulo_assignment_operator {push("%");}expression 		{ 
																	  if($1==1 && $3==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);}
                                                                                  codegendoubleop();
			                                                          codeassign();
																	}
			| mutable increment_operator 							{ push("++");if($1 == 1) $$=1; else $$=-1; genunary();}
			| mutable decrement_operator  							{ push("--");if($1 == 1) $$=1; else $$=-1; genunary();}
			| simple_expression {if($1 == 1) $$=1; else $$=-1;} ;


simple_expression 
			: simple_expression OR_operator and_expression {push("||");} {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			| and_expression {if($1 == 1) $$=1; else $$=-1;};

and_expression 
			: and_expression AND_operator {push("&&");} unary_relation_expression  {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			  |unary_relation_expression {if($1 == 1) $$=1; else $$=-1;} ;


unary_relation_expression 
			: exclamation_operator {push("!");} unary_relation_expression {if($2==1) $$=1; else $$=-1; codegen();} 
			| regular_expression {if($1 == 1) $$=1; else $$=-1;} ;

regular_expression 
			: regular_expression relational_operators sum_expression {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			  | sum_expression {if($1 == 1) $$=1; else $$=-1;} ;
			
relational_operators 
			: greaterthan_assignment_operator {push(">=");} | lessthan_assignment_operator {push("<=");} | greaterthan_operator {push(">");}| lessthan_operator {push("<");}| equality_operator {push("==");}| inequality_operator {push("!=");} ;

sum_expression 
			: sum_expression sum_operators term  {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			| term {if($1 == 1) $$=1; else $$=-1;};

sum_operators 
			: add_operator {push("+");}
			| subtract_operator {push("-");} ;

term
			: term MULOP factor {if($1 == 1 && $3==1) $$=1; else $$=-1; codegen();}
			| factor {if($1 == 1) $$=1; else $$=-1;} ;

MULOP 
			: multiplication_operator {push("*");}| division_operator {push("/");} | modulo_operator {push("%");} ;

factor 
			: immutable {if($1 == 1) $$=1; else $$=-1;} 
			| mutable {if($1 == 1) $$=1; else $$=-1;} ;

mutable 
			: identifier {
						  push(curid);
						  if(isIdentifierAFunc(curid))
						  {printf("Function name used as Identifier\n"); exit(8);}
			              if(!identifierInScope(curid))
			              {printf("%s\n",curid);printf("\nLine %d: Semantic error: Variable '%s' is already declared.\n\n", yylineno, curid);exit(0);} 
			              if(!isIdentifierAnArray(curid))
			              {printf("%s\n",curid);printf("Array ID has no subscript\n");exit(0);}
			              if(getFirstCharOfIDDatatype(curid,0)=='i' || getFirstCharOfIDDatatype(curid,1)== 'c')
			              $$ = 1;
			              else
			              $$ = -1;
			              }
			| array_identifier {if(!identifierInScope(curid)){printf("%s\n",curid);printf("Undeclared\n");exit(0);}} '[' expression ']' 
			                   {if(getFirstCharOfIDDatatype(curid,0)=='i' || getFirstCharOfIDDatatype(curid,1)== 'c')
			              		$$ = 1;
			              		else
			              		$$ = -1;
			              		};

immutable 
			: '(' expression ')' {if($2==1) $$=1; else $$=-1;}
			| call {if($1==-1) $$=-1; else $$=1;}
			| constant {if($1==1) $$=1; else $$=-1;};

call
			: identifier '('{

			             if(!isFuncDeclared(curid, "Function"))
			             { printf("Function not declared"); exit(0);} 
			             insertSTF(curid); 
						 strcpy(currfunccall,curid);
						 if(getFirstCharOfIDDatatype(curid,0)=='i' || getFirstCharOfIDDatatype(curid,1)== 'c')
						 {
			             $$ = 1;
			             }
			             else
			             $$ = -1;
                         call_params_count=0;
			             } 
			             arguments ')' 
						 { if(strcmp(currfunccall,"printf") && strcmp(currfunccall, "scanf"))
							{ 
								if(getFuncArgsCount(currfunccall)!=call_params_count)
								{	
									yyerror("Number of arguments in function call doesn't match number of parameters");
									exit(8);
								}
							}
							callgen();
						 };

arguments 
			: arguments_list | ;

arguments_list 
			: arguments_list ',' exp { call_params_count++; }  
			| exp { call_params_count++; };

exp : identifier {arggen(1);} | integer_constant {arggen(2);} | string_constant {arggen(3);} | float_constant {arggen(4);} | character_constant {arggen(5);} | amp_operator identifier {arggen(1);};

constant 
			: integer_constant 	{  insV(); codegencon(); $$=1; } 
			| string_constant	{  insV(); codegencon();$$=-1;} 
			| float_constant	{  insV(); codegencon();} 
			| character_constant    {  insV(); codegencon();$$=1; };

%%

extern FILE *yyin;
extern char *yytext;
void insertSTtype(char *,char *);
void insertSTvalue(char *, char *);
void incertCT(char *, char *);
void printST();
void printCT();

struct stack
{
	char value[100];
	int labelvalue;
}s[100],label[100];


void push(char *x)
{
	strcpy(s[++top].value,x);
}

void swap(char *x, char *y)
{
	char temp = *x;
	*x = *y;
	*y = temp;
}

void reverse(char str[], int length) 
{ 
    int start = 0; 
    int end = length -1; 
    while (start < end) 
    { 
        swap((str+start), (str+end)); 
        start++; 
        end--; 
    } 
} 
  
char* itoa(int num, char* str, int base) 
{ 
    int i = 0; 
    int isNegative = 0; 
  
   
    if (num == 0) 
    { 
        str[i++] = '0'; 
        str[i] = '\0'; 
        return str; 
    } 
  
    if (num < 0 && base == 10) 
    { 
        isNegative = 1; 
        num = -num; 
    } 
  
   
    while (num != 0) 
    { 
        int rem = num % base; 
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
        num = num/base; 
    } 
  
    if (isNegative) 
        str[i++] = '-'; 
  
    str[i] = '\0'; 
  
   
    reverse(str, i); 
  
    return str; 
}

/* 
 * Generate code for expressions like y op z
 * Create temporary variable tCount, reduce y op z into tCount, display tCount = y op z
 */
void codegen()
{
	strcpy(temp,"t");
	char buffer[100];
	itoa(count,buffer,10);
	strcat(temp,buffer);
	printf("%s = %s %s %s\n",temp,s[top-2].value,s[top-1].value,s[top].value);
	top = top - 2;
	strcpy(s[top].value,temp);
	count++; 
}

void codegendoubleop()
{
        strcpy(temp,"t");
	char buffer[100];
	itoa(count,buffer,10);
	strcat(temp,buffer);
	printf("%s = %s %s %s\n",temp,s[top-2].value,s[top-1].value,s[top].value);
	strcpy(s[top].value,temp);
	count++;
}

/*
 * Generate code for constant values
 * Create temporary variable tCount, put constant value into tCount, display tCount = constant value
 */
void codegencon()
{
	strcpy(temp,"t");
	char buffer[100];
	itoa(count,buffer,10);
	strcat(temp,buffer);
	printf("%s = %s\n",temp,curval);	// curval has a constant in it from yytext
	push(temp);
	count++;
}

int isunary(char *s)
{
	if(strcmp(s, "--")==0 || strcmp(s, "++")==0)
	{
		return 1;
	}
	return 0;
}

/*
 * Generate code for unary operators.
 * x-- becomes tCount = x - 1, x = tCount
 */
void genunary()
{
	char temp1[100], temp2[100], temp3[100];
	strcpy(temp1, s[top].value);
	strcpy(temp2, s[top-1].value);

	if(isunary(temp1))
	{
		strcpy(temp3, temp1);
		strcpy(temp1, temp2);
		strcpy(temp2, temp3);
	}
	strcpy(temp, "t");
	char buffer[100];
	itoa(count, buffer, 10);
	strcat(temp, buffer);
	count++;

	if(strcmp(temp2,"--")==0)
	{
		printf("%s = %s - 1\n", temp, temp1);
		printf("%s = %s\n", temp1, temp);
	}

	if(strcmp(temp2,"++")==0)
	{
		printf("%s = %s + 1\n", temp, temp1);
		printf("%s = %s\n", temp1, temp);
	}

	top = top -2;
}

/*
 * Generate code for assigning s[top] (a temporary containing final value) to s[top-2] (the target variable)
 * For x = 2, 2 will be in some temporary tCount, which will be at s[top], x will be s[top-2], = will be at s[top-1]
 * For x += 2, we will have called codegendoubleop() already, which will result in x+2 in tCount at s[top], x at s[top-2], and + at s[top-1]
 */
void codeassign()
{
	printf("%s = %s\n",s[top-2].value,s[top].value);
	top = top - 2;
}

/*
 * Create (not print) a label for jumping to, when the if or loop condition is false
 * Also generate code for the same
 */
void label1()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("IF not %s GoTo %s\n",s[top].value,temp);
	label[++ltop].labelvalue = lno++;
}

/*
 * Create label for jumping to end of else, after completing the if.
 * Print the label for beginning of else.
 */
void label2()
{
	// Create new label for jumping directly to the end of else, after completing the if. We will put it into the stack soon
	// Also generate code i.e. goto L lno
	strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("GoTo %s\n",temp);

	// At the beginning of if, we had put the label for jumping to, if the if condition was false, on the stack.
	// This was done in label1()
	// Now we must generate code for (i.e. print) that label, and remove it from the label stack.
	strcpy(temp,"L");
	itoa(label[ltop].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	ltop--;

	// Put the newly created label on the stack
	label[++ltop].labelvalue=lno++;
}

/*
 * Print the label for jumping to the end of the if-else construct
 * This label was kept on the stack in label2()
 */
void label3()
{
	// In label2(), we had generated a label for jumping directly to the end of else, after completing the if.
	// We had put it into the stack
	// We will now generate code for (i.e. print) that label, and remove it from the label stack
	strcpy(temp,"L");
	char buffer[100];
	itoa(label[ltop].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	ltop--;
	
}

/*
 * Create label for starting of loop
 * Print it, and put it on stack.
 */
void label4()
{
	strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);
	label[++ltop].labelvalue = lno++;
}

/*
 * We are now at the end of loop. Two things are required:
 * 1. goto to the beginning of loop, and 2. the label denoting end of loop
 * The label of beginning of loop is at label[ltop-1]. Generated (and printed) using label4()
 * The label of end of loop is at label[ltop]. Generated using label1()
 */
void label5()
{
	// goto to the beginning of loop
	strcpy(temp,"L");
	char buffer[100];
	itoa(label[ltop-1].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("GoTo %s:\n",temp);

	// Label denoting end of loop
	strcpy(temp,"L");
	itoa(label[ltop].labelvalue,buffer,10);
	strcat(temp,buffer);
	printf("%s:\n",temp);

	// We are done with both labels. Hence, we will remove them from stack.
	ltop = ltop - 2;
    
   
}

void label6()
{
        strcpy(temp, "L");
        char buffer[100];
        itoa(label[ltop-case_stmt_num].labelvalue, buffer, 10);
        strcat(temp, buffer);
        printf("%s:\n",temp);
        int i, num=0;
        if (default_num == 1) case_stmt_num++;
        for (i=ltop-case_stmt_num; i<ltop-1; i++) {
            printf("if t%d = %d GoTo L%d\n",case_var_val, num++, i);
        }
        if (default_num == 1) {
            printf("Goto L%d\n", ltop-1);
        }
}

void label7()
{
        strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	printf("GoTo %s:\n",temp);
	label[++ltop].labelvalue = lno++; 
}

void label8()
{
        // No print label
        strcpy(temp,"L");
	char buffer[100];
	itoa(lno,buffer,10);
	strcat(temp,buffer);
	label[++ltop].labelvalue = lno++;
}

/*
 * Generate code for beginning of function currfunc
 * currfunc contains curid, which contains yytext
 */
void funcgen()
{
	printf("begin %s\n",currfunc);
}

/*
 * Generate code for end of function currfunc
 * currfunc contains curid, which contains yytext
 */
void funcgenend()
{
	printf("end %s\n\n", currfunc);
}

/*
 * Generate code for actual parameter, like param 2
 * param may be an identifier or a constant.
 * If it is an identifier, then i will be 1. We can then print curid.
 * If it is a constant, then i will be > 1. We can then print curval.
 */
void arggen(int i)
{
    if(i==1)
    {
        printf("param %s\n", curid);
    }
    else
    {
        printf("param %s\n", curval);
    }
}

/*
 * Generate code for calling function, whose name is in currfunccall
 * params have already been printed. Number of params is saved in call_params_count
 */
void callgen()
{
	push("result");
	printf("call %s, %d\n", currfunccall, call_params_count);
}



int main(int argc , char **argv)
{
	yyin = fopen(argv[1], "r");
	yyparse();
        if(flag == 0)
	{
		printf("Status: Parsing Complete - Valid\n");
		printf("%30sSYMBOL TABLE\n", " ");
		printf("%30s %s\n", " ", "------------");
		printST();

		printf("\n\n%30sCONSTANT TABLE\n", " ");
		printf("%30s %s\n", " ", "--------------");
		printCT();
	}
}

void yyerror(char *s)
{
	flag=1;
	printf("Line %d: Error: %s, near \'%s\'\n", yylineno, s, yytext);
	exit(7);
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
