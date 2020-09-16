#!/bin/bash

mkdir -p bin build
cd build/
lex ../src/scanner.l
yacc -d ../src/parser.y
cd ../
gcc build/lex.yy.c build/y.tab.c -o bin/parser
