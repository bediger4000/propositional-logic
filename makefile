YACC = bison -d -b y -y
LEX = flex

tester: y.tab.c lex.yy.c y.tab.h
	$(CC) -g -Wall -Wextra -I. -o tester y.tab.c lex.yy.c

y.tab.c y.tab.h: grammar.y
	$(YACC) grammar.y

lex.yy.c: lex.l
	$(LEX) lex.l

clean:
	-rm -rf y.tab.c y.tab.h lex.yy.c tester y.output
