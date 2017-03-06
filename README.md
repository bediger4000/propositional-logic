# Propositional Logic Parser
Read propositional logic expressions, and reprint them.

Reads text representations of propositional logic expressions. Propositional variables are same
as C or Java identifiers, matching regular expression `[a-zA-Z_][a-zA-Z_0-9]*`.

* Conjunction: `p & q`
* Disjunction: `p | q`
* Logical equivalence : `p = q`
* Material implication : `p > q`
* Negation: `~p`

You should parenthesize enough to group as you mean, I don't have levels of operator precedence.

For example:

    $ ./tester
    ~(b & c) = ~b | ~c
    (~(b & c) = ~b) | ~c

It gets the precedence of OR and EQUIVALENCE incorrect.


## Building

    make

## Notes
