bin/c_compiler: parser.tab.o lex.yy.o
	g++ -o bin/c_compiler parser.tab.o lex.yy.o src/tree.hpp

bin/c_lexer : src/tokenizer.cpp
	g++ src/tokenizer.cpp -o bin/c_lexer

bin/c_parser: parser.tab.o lex.yy.o
	g++ -o bin/c_parser parser.tab.o lex.yy.o tree.hpp

bin/c_codegen: parser.tab.o lex.yy.o
	g++ -o bin/c_codegen parser.tab.o lex.yy.o src/tree.hpp

#for parser
lex.yy.o: lex.yy.c parser.tab.h
	g++ -c lex.yy.c
	
parser.tab.o: parser.tab.c parser.tab.h
	g++ -c parser.tab.c
	
parser.tab.h: src/parser.y
	bison -d src/parser.y

parser.tab.c : src/parser.y
	bison -d src/parser.y
	
lex.yy.c: src/lexer.l
	flex src/lexer.l 
#clean
clean:
	rm -f lex.yy.c parser.tab.h parser.tab.c *.o bin/parse bin/c_lexer bin/c_codegen bin/c_compiler
