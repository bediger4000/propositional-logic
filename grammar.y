%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef YYBISON
#define YYERROR_VERBOSE

enum LogicalOperator { AND, NOT, OR, EQUIV, ID, IMPLY };
struct node *new_node(enum LogicalOperator op);
struct node *new_identifier(char *ident);
void free_node(struct node *n);
void print_node(struct node *n);

extern int yylex(void);
int yyerror(const char *s1);

extern int yyparse(void);

#endif

struct node {
	char *identifier;
	enum LogicalOperator op;
	struct node *left;
	struct node *right;
};

%}

%union{
	char *identifier;
	struct node *node;
}

%token TK_CONJ TK_DISJ TK_EQUIV TK_IMPLIES TK_LPAREN TK_RPAREN
%token <identifier> TK_IDENT TK_NOT
%token TK_EOL

%type <node> term expression program stmnt
%%
program
	: expression          { print_node($$); printf("\n"); free_node($$); $$ = NULL; }
	| program expression  { print_node($2); printf("\n"); free_node($2); $2 = NULL; }
	| error               { if ($$) free_node($$); $$ = NULL; }
	;

expression
	: stmnt TK_EOL  { $$ = $1; }
	;

stmnt
	: stmnt TK_EQUIV term   { $$ = new_node(EQUIV); $$->left = $1; $$->right = $3; }
	| stmnt TK_CONJ term    { $$ = new_node(AND); $$->left = $1; $$->right = $3; }
	| stmnt TK_DISJ term    { $$ = new_node(OR); $$->left = $1; $$->right = $3; }
	| stmnt TK_IMPLIES term { $$ = new_node(IMPLY); $$->left = $1; $$->right = $3; }
	| term
	;

term
	: TK_IDENT                  { $$ = new_identifier($1); }
	| TK_LPAREN stmnt TK_RPAREN { $$ = $2; }
	| TK_NOT term           	{ $$ = new_node(NOT); $$->left = $2; }
	;

%%

int
main(int ac, char **av)
{
	int r = yyparse();
	return r;
}
int
yyerror(const char *s1)
{
    fprintf(stderr, "%s\n", s1);

    return 0;
}

struct node *
new_node(enum LogicalOperator op)
{
	struct node *r = malloc(sizeof *r);
	r->identifier = NULL;
	r->op = op;
	r->left = r->right = NULL;
	return r;
}

struct node *
new_identifier(char *ident)
{
	struct node *r = malloc(sizeof *r);
	r->identifier = strdup(ident);
	r->op = ID;
	r->left = r->right = NULL;
	return r;
}

void
free_node(struct node *n)
{
	if (!n) return;

	if (n->identifier)
	{
		free(n->identifier);
		n->identifier = NULL;
	}

	if (n->left)
		free_node(n->left);
	if (n->right)
		free_node(n->right);
	n->left = n->right = NULL;
	free(n);
	n = NULL;
}

void
print_node(struct node *n)
{
	char oper = '\0';
	if (NOT == n->op)
		printf("~");
	if (n->left)
	{
		int print_paren = 0;
		if (n->left->op != ID && n->left->op != NOT)
		{
			printf("(");
			print_paren = 1;
		}
		print_node(n->left);
		if (print_paren) printf(")");
	}
	switch (n->op)
	{
	case IMPLY:
		oper = '>';
		break;
	case AND:
		oper = '&';
		break;
	case OR:
		oper = '|';
		break;
	case EQUIV:
		oper = '=';
		break;
	case NOT:
	case ID:
		oper = '\0';
	}
	if (oper) printf(" %c ", oper);
	if (n->identifier) printf("%s", n->identifier);
	if (n->right)
	{
		int print_paren = 0;
		if (n->right->op != ID && n->right->op != NOT)
		{
			printf("(");
			print_paren = 1;
		}
		print_node(n->right);
		if (print_paren) printf(")");
	}
}
