#!/bin/bash

mkdir -p bin build
cd build/
yacc -d -Wno-yacc ../src/parser.y
lex ../src/scanner.l
cd ../bin/
gcc ../build/lex.yy.c ../build/y.tab.c -o icg
