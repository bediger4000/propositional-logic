# Propositional Logic Parser
Read propositional logic expressions, and reprint them.

Reads text representations of propositional logic expressions. Propositional variables are same
as C or Java identifiers, matching regular expression `[a-zA-Z_][a-zA-Z_0-9]*`.

* Conjunction: `p & q`
* Disjunction: `p | q`
* Logical equivalence : `p = q`
* Material implication : `p > q`
* Negation: `~p`

You should parenthesize enough to group as you mean. It does do levels of precedence.

For example:

    $ ./tester
    b & c = b > c
    (b & c) = (b > c)

## Building

    $ make

You get a small program named `tester`

## Notes

The idea is to maybe make a program to find tautologies by Smullyan's tableaux method,
although printing a truth table is something else that should happen.
