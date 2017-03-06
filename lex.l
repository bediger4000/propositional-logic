%{
#include "y.tab.h"
%}
%%
\#.*$       { return TK_EOL; }
\n          { return TK_EOL; }
\\\n        { /* Just eat it. */ }
\(          { return TK_LPAREN; }
\)          { return TK_RPAREN; }
\=			{ return TK_EQUIV; }
\>			{ return TK_IMPLIES; }
\&			{ return TK_CONJ; }
\|			{ return TK_DISJ; }
\~			{ return TK_NOT; }
[a-zA-Z_][a-zA-Z_0-9'*]* { yylval.identifier = yytext; return TK_IDENT; }
. { /* eat it. */ }
%%

int
yywrap()
{
	return 1;
}
