%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef YYBISON
#define YYERROR_VERBOSE

enum LogicalOperator { AND, NOT, OR, EQUIV, ID };
struct node *new_node(enum LogicalOperator op);
struct node *new_identifier(xhar *ident);
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
%token TK_IDENT TK_NOT
%token TK_EOL

%%
program
	: expression
	| program expression
	| error
	;

expression
	: stmnt TK_EOL
	;

stmnt
	: stmnt TK_EQUIV term
	| stmnt TK_CONJ term
	| stmnt TK_DISJ term
	| stmnt TK_IMPLIES term
	| TK_NOT term
	| term
	;

term
	: TK_IDENT
	| TK_LPAREN stmnt TK_RPAREN
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
	char oper = '?';
	if (n->left) print_node(n->left);
	switch (n->op)
	{
	case AND:
		oper ='&';
		break;
	case NOT:
		oper ='~';
		break;
	case OR:
		oper ='|';
		break;
	case EQUIV:
		oper ='=';
		break;
	case ID:
		oper = '\0';
	}
	if (oper)
		printf(" %c ", oper);
	if (n->identifier)
		printf("%s", n->identifier);
	if (n->right) print_node(n->right);
}
