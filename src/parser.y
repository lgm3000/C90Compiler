%{
#include <iostream>
#include <cstdlib>
#include <sstream>
#include "src/tree.hpp"
using namespace std;
int yylex();
int yyerror(const char* s);
int scope = 0;
nptr head;
string spaces(int num);
%}
 
%union{
	char*	name;
	nptr	node;
}


%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER RETURN SHORT SIGNED STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE SIZEOF INDEX POINTER PLUSPLUS MINUSMINUS BITWISESHIFTLEFT BITWISESHIFTRIGHT LESSOREQUAL GREATOREQUAL EQUAL NOTEQUAL AND OR MULTEQUAL DIVEQUAL MODEQUAL PLUSEQUAL MINUSEQUAL BSLEQUAL BSREQUAL BANDEQUAL BXOREQUAL BOREQUAL JINGJING EOL
%token IDENTIFIER CONSTANT STRINGLITERAL
%type<name> INT VOID '=' MULTEQUAL DIVEQUAL PLUSEQUAL MINUSEQUAL MODEQUAL BSLEQUAL BSREQUAL BANDEQUAL BXOREQUAL BOREQUAL sign UNSIGNED SIGNED LONG type2
%type<name> IDENTIFIER CONSTANT func_name eq_opr
%type<node> program dio function func_def parameter_list parameter_sub lines line in_scope var_def variables variable return_statement	
%type<node> asgnexpr expr0 expr1 expr2 expr3 expr4 expr5 expr6 expr7 expr8 expr9 expr10 expr11 expr12 noob commaop comma_sub ddexpr
%type<node> flow vexpr evexpr inner type varda
%start program
%%
program		: program dio{$1->add_child($2);}|
		dio{head = new head_n();$$ = head;head->add_child($1);}
		;
dio		:function{$$ = $1;}/*|line{$$ = $1;}*/;

function	: func_def'{' in_scope '}'{
			$$ =$1;$$->right = $3;scope--;}
		; 
func_def	: type func_name '(' parameter_list ')'{
			$$ = new func_n();$$->type = $1->tipe;$$->content = $2;$$->left = $4;}
		;
parameter_list	:parameter_sub{
			$$ = $1;}|
		{
			$$ = new para_n;
			}
		;
		
parameter_sub	: parameter_sub ',' type IDENTIFIER{
			$$ = $1;$1-> add_child(new low_n("IDENTIFIER",$4));}|
		type IDENTIFIER {
			$$ = new para_n;$$->content = "parameters";$$ -> add_child(new low_n("IDENTIFIER",$2));}
		;
type		: sign type2{$$ = new type_n($1,$2);}
		;

sign		: UNSIGNED{$$ = $1;}|SIGNED{$$ = $1;}|{char tmp[] = "signed";$$ = tmp;};

type2		: INT {$$ = $1;}| VOID{$$ = $1;} | LONG LONG{char tmp[] = "longlong";$$ = tmp;}|LONG{$$ = $1;};

in_scope	: lines {$$=$1;}|
		{$$ = new isco_n();}
		;

lines		: lines line{$$ = $1;$1->add_child($2);}|
		line{$$ = new isco_n();$$->add_child($1);}
		;

line		: var_def EOL{$$ = $1;}|asgnexpr EOL{$$ = $1;}|ddexpr EOL{$$=$1;}|expr0 EOL{$$ = new blank_n;}|commaop EOL{$$ = new blank_n;}|return_statement EOL{$$ = $1;}|flow{$$ = $1;};



return_statement: RETURN expr0{$$ = new retn_n();$$->add_child($2);$$->content = "Return";};

flow		: IF '('vexpr')' inner ELSE inner{$$ = new ifelse_n($3,$5,$7);}|
		IF '('vexpr')' inner{$$ = new if_n($3,$5);}|
		FOR'('evexpr EOL vexpr EOL evexpr')' inner {$$ = new for_n($3,$5,$7,$9);}|
		WHILE'('vexpr')' inner {$$ = new while_n($3,$5);}
		;

inner		:'{' lines '}'{$$ = $2;}|
		line{$$ = new isco_n();$$->add_child($1);};

var_def		: type variables {$$ = $2; $2->tipe = $1->tipe;$2->signda = $1->signda;}
		;
variables	: variables ',' variable{$$ = $1;$1->add_child($3);}|
		variable{$$ = new vard_n;$$ ->content = "Variable Def";$$->add_child($1);}
		;
variable	: IDENTIFIER '=' expr0{$$ = new asgn_n($2);$$->left = new low_n("IDENTIFIER",$1);$$->right = $3;}|
		IDENTIFIER{$$ = new low_n("IDENTIFIER",$1);}|
		'*'IDENTIFIER{$$ = new low_n("IDENTIFIER",$2);$$->pointa = true;}|
		IDENTIFIER'['CONSTANT']'{$$ = new aray_n($1,new low_n("CONSTANT",$3));}
		;
evexpr		:vexpr{$$ = $1;}|{$$ = NULL;};
vexpr		:asgnexpr{$$ = $1;}|expr0{$$ = $1;}|commaop{$$ = $1;}|ddexpr{$$ = $1;};
asgnexpr	: varda eq_opr asgnexpr{$$ = new asgn_n($2);$$ ->left =$1;$$->right = $3;}|
		varda eq_opr expr0{$$ = new asgn_n($2);$$ ->left =$1;$$->right = $3;}
		;	
//?:
expr0		:expr0 noob expr0{$$ = new ternexpr_n($1,$2,$3);}|
		expr1{$$=$1;}
		;
noob		:'?'expr0':'{$$ = $2;};
// ||
expr1		: expr1 OR expr2{$$ = new ororexpr_n($1,$3);}|
		expr2{$$=$1;}
		;
//&&
expr2		: expr2 AND expr3{$$ = new andandexpr_n($1,$3);}|
		expr3{$$=$1;}
		;
// |
expr3		: expr3'|'expr4{$$ = new orexpr_n($1,$3);}|
		expr4{$$=$1;}
		;
//^
expr4		: expr4'^'expr5{$$ = new xorexpr_n($1,$3);}|
		expr5{$$=$1;}
		;
//&
expr5		: expr5'&'expr6{$$ = new andexpr_n($1,$3);}|
		expr6{$$=$1;}
		;
// == !=
expr6		: expr6 EQUAL expr7{$$ = new eqeqexpr_n($1,$3);}|
		expr6 NOTEQUAL expr7{$$ = new neqexpr_n($1,$3);}|
		expr7{$$=$1;}
		;
// < > <= >=
expr7		: expr7 LESSOREQUAL expr8{$$ = new lesseqexpr_n($1,$3);}|
		expr7 GREATOREQUAL expr8{$$ = new grteqexpr_n($1,$3);}|
		expr7 '<' expr8{$$ = new lessexpr_n($1,$3);}|
		expr7 '>' expr8{$$ = new grtexpr_n($1,$3);}|
		expr8{$$=$1;}
		;
//<< >>
expr8		: expr8 BITWISESHIFTLEFT expr9{$$ = new lsl_n($1,$3);}|
		expr8 BITWISESHIFTRIGHT expr9{$$ = new lsr_n($1,$3);}|
		expr9{$$=$1;}
		;
//expr for +- lvl9
expr9		: expr9 '+' expr10{$$ = new addexpr_n($1,$3);}|
		expr9 '-' expr10{$$ = new subexpr_n($1,$3);}|
		expr10{$$ = $1;}
		;
//expr for */% lvl10
expr10		:expr10 '*' expr11{$$ = new multexpr_n($1,$3);}|
		expr10 '/' expr11{$$ = new divexpr_n($1,$3);}|
		expr10 '%' expr11{$$ = new modexpr_n($1,$3);}|
		expr11{$$ = $1;}
		;
//expr for some unary operators lvl11
expr11		:'+'expr12{$$ = $2;}|
		'-'CONSTANT{$$ = new low_n("CONSTANT",$2);$$->content = $$->content.insert(0,"-");}|
		'-'varda{$$ = new negexpr_n($2);}|
		'!'expr12{$$ = new punc_n($2);}|
		'*'varda{$$ = new ptrv_n($2->content);}|
		'&'varda{$$ = new adrv_n($2->content);}|
		'~'expr12{$$ = new not_n($2);}|
		SIZEOF'('expr12')'{$$ = new blank_n;/**/}|
		ddexpr{$$ = $1;}|
		'('expr0')' {$$ = $2;}|
		expr12{$$=$1;}
		;
ddexpr		: PLUSPLUS IDENTIFIER {$$ = new ppi_n($2);}|
		MINUSMINUS IDENTIFIER {$$ = new mmi_n($2);}|
		IDENTIFIER PLUSPLUS {$$ = new ipp_n($1);}|
		IDENTIFIER MINUSMINUS {$$ = new imm_n($1);}
		;
//expr for bottomlevel
expr12		: varda{$$ = $1;}|
		CONSTANT   {$$ = new low_n("CONSTANT",$1);}
		;
varda		: IDENTIFIER'['expr0']'{$$ = new aray_n($1,$3);}|
		IDENTIFIER {$$ = new low_n("IDENTIFIER",$1);}
		;

commaop		:'('comma_sub')'{$$ = $2;};
comma_sub	:comma_sub','expr0{$$ = $3;}|
		expr0','expr0{$$ = $3;};
eq_opr		:'='{$$ = $1;}|MULTEQUAL{$$ = $1;}|DIVEQUAL{$$ = $1;}|PLUSEQUAL{$$ = $1;}|MINUSEQUAL{$$ = $1;};
//operator	:SIZEOF|INDEX|PLUSPLUS|MINUSMINUS|'&'|'*'|'+'|'-'|'~'|'!'|'/'|'%'|BITWISESHIFTLEFT|BITWISESHIFTRIGHT|'<'|'>'|LESSOREQUAL|GREATOREQUAL|EQUAL|NOTEQUAL|'^'|'|'|AND|OR|','|'#'|JINGJING|';'|':'|MULTEQUAL|DIVEQUAL|MODEQUAL|PLUSEQUAL|MINUSEQUAL|BSLEQUAL|BSREQUAL|BANDEQUAL|BXOREQUAL|BOREQUAL|BSLEQUAL|BSREQUAL|BANDEQUAL|BXOREQUAL|MODEQUAL|BOREQUAL;
func_name	: IDENTIFIER{$$ = $1;scope++;}
		;

%%
string spaces(int num){
	stringstream ss;
	for(int i=0;i<num*4;i++) ss<< " ";	
	return ss.str();
}

int yyerror(const char* s){
	cout << "error";
    return 0;
}

void go_tree(nptr curptr){
	if(curptr->child.size()>0){
		for(int i=0;i<curptr->child.size();i++)
			go_tree(curptr->child[i]);
	cout << curptr->content << endl;
	}
	else {
		if(curptr->left!=NULL)
			go_tree(curptr->left);
		cout << curptr->content<<endl;
		
		if(curptr->right!=NULL)
			go_tree(curptr->right);
	}
}

int main(void) {
	yyparse();
	head -> content = "Finish";
	head->traverse(0);
	return 0;
}

int reassemble(nptr curptr){
	int i=0,tmpary = 0;
	while(i<curptr->child.size() && (curptr->child[i]->content != "Variable Def")) i++;
	if(i<curptr->child.size()){
		for(int j=0;j<curptr->child[i]->child.size();j++)
			if(curptr->child[i]->child[j]->type == "array")	{
				curptr->child[i]->child[j]->tipe=curptr->child[i]->tipe;curptr->child[i]->child[j]->signda=curptr->child[i]->signda;
				if(curptr->child[i]->child[j]->left->type == "CONSTANT") tmpary+=atoi(curptr->child[i]->child[j]->left->content.c_str());
				else tmpary+=10;
			}else
			if(curptr->child[i]->child[j]->type != "IDENTIFIER"){
				curptr->child.insert(curptr->child.begin()+i+1,curptr->child[i]->child[j]);
				curptr->child[i]->child[j] = curptr->child[i]->child[j]->left;
				curptr->child[i]->child[j]->tipe=curptr->child[i]->tipe;
				curptr->child[i]->child[j]->signda=curptr->child[i]->signda;
			}
			else{curptr->child[i]->child[j]->tipe=curptr->child[i]->tipe;curptr->child[i]->child[j]->signda=curptr->child[i]->signda;}
		for(int j=i+1;j<curptr->child.size();j++)
			if(curptr->child[j]->content == "Variable Def"){
				for(int k=0;k<curptr->child[j]->child.size();k++)
					if(curptr->child[j]->child[k]->type == "IDENTIFIER"){
					curptr->child[j]->child[k]->tipe=curptr->child[j]->tipe;curptr->child[j]->child[k]->signda=curptr->child[j]->signda;
						curptr->child[i]->add_child(curptr->child[j]->child[k]);
					}
					else if(curptr->child[j]->child[k]->type == "array"){
	curptr->child[j]->child[k]->tipe=curptr->child[j]->tipe;curptr->child[j]->child[k]->signda=curptr->child[j]->signda;
						curptr->child[i]->add_child(curptr->child[j]->child[k]);
						if(curptr->child[j]->child[k]->left->type == "CONSTANT") tmpary+=atoi(curptr->child[j]->child[k]->left->content.c_str());
						else tmpary+=10;
					}else {
	curptr->child[j]->child[k]->left->tipe=curptr->child[j]->tipe;curptr->child[j]->child[k]->left->signda=curptr->child[j]->signda;
						curptr->child[i]->add_child(curptr->child[j]->child[k]->left);
						curptr->child.insert(curptr->child.begin()+j+1,curptr->child[j]->child[k]);
					}
				curptr->child.erase(curptr->child.begin()+j);
				}
	curptr->left = curptr->child[i];
		curptr->child.erase(curptr->child.begin()+i);
	}
	else{
		curptr->left = new vard_n;
		}
	curptr->right = new line_n;
	for(i=0;i<curptr->child.size();i++)
			curptr->right->add_child(curptr->child[i]);
	curptr->child.clear();
	return tmpary;
				
}
void s_r(nptr curptr,int tmpary){
	tmpary = reassemble(curptr);
	curvar+= curptr->left->child.size();
	curvar+= tmpary;
	maxvar = curvar>maxvar?curvar:maxvar;
	int i=0;
	for(;i<curptr->right->child.size();i++){
		if(curptr->right->child[i]!=NULL){
			if(curptr->right->child[i]->content == "isco") s_r(curptr->right->child[i],0);
			if(curptr->right->child[i]->left!=NULL)
				if(curptr->right->child[i]->left->content == "isco")s_r(curptr->right->child[i]->left,0);
			if(curptr->right->child[i]->right != NULL)
				if(curptr->right->child[i]->right->content == "isco")s_r(curptr->right->child[i]->right,0);
		}
	}
	curvar-=curptr->left->child.size();
	curvar-=tmpary;
				
}

