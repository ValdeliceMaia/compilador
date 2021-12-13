%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>	


//Estrutura de um nó
typedef struct ast { 
	int nodetype;
	struct ast *l; 
	struct ast *r; 
}Ast; 

//Estrutura de um número
typedef struct numval { 
	int nodetype;
	double number;
}Numval;

//Estrutura de um nome de variável
typedef struct varval {
	int nodetype;
	char var[50];
}Varval;

//Estrutura de um fluxo (if,else,while)
typedef struct flow {
	int nodetype;
	Ast *cond;	//condição
	Ast *tl;	//then
	Ast *el;	//else
}Flow;

//Estrutura para um nó de atribuição
typedef struct symasgn {
	int nodetype;
	char s[50];
	Ast *v;
}Symasgn;

//Estrutura de uma variável
typedef struct var {
	int nodetype;
	char name[51];
	float valor;
	char valors[50];
	struct var *prox;
} Var;

//Estrutura de uma variável de texto
typedef struct textovar {
        int nodetype;
        char v[1000];
}Textovar;

//Variáveis
Var *l1;
Var *aux;

//Insere uma nova variável na lista de variáveis
Var *ins(Var*l,char n[]){
		Var*new =(Var*)malloc(sizeof(Var));
		strcpy(new->name, n);
		new->valor = 0;
		new->prox = l;
		return new;
}
	
//Busca uma variável na lista de variáveis
Var *srch(Var*l,char n[]){
		Var*aux = l;
		while(aux != NULL){
			if(strcmp(n,aux->name)==0)
				return aux;
			aux = aux->prox;
		}
		return aux;
}

//Função para criar um nó
Ast * newast(int nodetype, Ast *l, Ast *r){
	Ast *a = (Ast*) malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->l = l;
	a->r = r;
	return a;
}
 
//Função que cria uma nova variável
Ast * newvari(int nodetype, char nome[50]) {
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;;
	strcpy(a->var,nome);
	return (Ast*)a;
}

//Função de que cria um novo número
Ast * newnum(double d) {
	Numval *a = (Numval*) malloc(sizeof(Numval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'K';
	a->number = d;
	return (Ast*)a;
}	

//Função de que cria um novo texto (folha)
Ast * newtexto(char d[]) {			
    Textovar *a = (Textovar*) malloc(sizeof(Textovar));
    if(!a) {
        printf("out of space");
        exit(0);
    }
    a->nodetype = 'm';
    strcpy(a->v, d);
    return (Ast*)a;
}

//Função que cria um nó de if/else/while	
Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el){ 
	Flow *a = (Flow*)malloc(sizeof(Flow));
	if(!a) {
		printf("out of space");
	    exit(0);
	}
	a->nodetype = nodetype;
	a->cond = cond;
	a->tl = tl;
	a->el = el;
	return (Ast *)a;
}

//Função que cria um nó para testes
Ast * newcmp(int cmptype, Ast *l, Ast *r){ 
	Ast *a = (Ast*)malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
	    exit(0);
	}
	a->nodetype = '0' + cmptype; //Para pegar o tipo de teste, definido no arquivo.l e utilizar na função eval()
	a->l = l;
	a->r = r;
	return a;
}

//Função para um nó de atribuição
Ast * newasgn(char s[50], Ast *v) { 		
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
	    exit(0);
	}
	Var *aux = srch(l1, s);
	if(aux == NULL)
		l1 = ins(l1, s);
	a->nodetype = '=';
	strcpy(a->s,s);
	a->v = v;
	return (Ast *)a;
}

//Função que recupera o nome/referência de uma variável, neste caso o número
Ast * newValorVal(char s[50]) { 		
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'N';
	strcpy(a->var,s);
	return (Ast*)a;	
}

//Função que recupera o nome/referência de uma variável, neste caso o número
Ast * newValorValS(char s[50]) { 
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'Q';
	strcpy(a->var,s);
	return (Ast*)a;
}

//Função que executa operações a partir de um nó
char * eval2(Ast *a) { 
	Var *aux1;
	char *v2;
	
    switch(a->nodetype) {
            
        case 'Q':
			aux1 = srch(l1,((Varval *)a)->var);
			return aux1->valors;
			break;

		default:
            printf("internal error: bad node %c\n", a->nodetype);
			break;
		}
	return v2;
}

//Função que executa operações a partir de um nó
double eval(Ast *a) { 
	double v; 
	char v1[50];
	char *v2;
	Var * aux1;
	int auxValor;
	if(!a) {
		printf("internal error, null eval");
		return 0.0;
	}
	switch(a->nodetype) {
		case 'K': v = ((Numval *)a)->number; break; 	
		case 'm': v = atof(((Textovar *)a)->v); break; 	
		case 'N': 
			aux1 = srch(l1,((Varval *)a)->var);
			v = aux1->valor;
			break;
		case '+': v = eval(a->l) + eval(a->r); break;	
		case '-': v = eval(a->l) - eval(a->r); break;	
		case '*': v = eval(a->l) * eval(a->r); break;	
		case '/': v = eval(a->l) / eval(a->r); break; 
		case 'M': v = -eval(a->l); break;				
	
		case '1': v = (eval(a->l) > eval(a->r))? 1 : 0; break;	
		case '2': v = (eval(a->l) < eval(a->r))? 1 : 0; break;
		case '3': v = (eval(a->l) != eval(a->r))? 1 : 0; break;
		case '4': v = (eval(a->l) == eval(a->r))? 1 : 0; break;
		case '5': v = (eval(a->l) >= eval(a->r))? 1 : 0; break;
		case '6': v = (eval(a->l) <= eval(a->r))? 1 : 0; break;
		
		case '=':
			
			v = eval(((Symasgn *)a)->v); 
			aux = srch(l1,((Symasgn *)a)->s);
			aux->valor = v;			
			break;
		
		case 'I':						
			if (eval(((Flow *)a)->cond) != 0) {	
				if (((Flow *)a)->tl)		
					v = eval(((Flow *)a)->tl); 
				else
					v = 0.0;
			} else {
				if( ((Flow *)a)->el) {
					v = eval(((Flow *)a)->el); 
				} else
					v = 0.0;
				}
			break;

		case 'S': 	
            scanf("%lf",&v);
			aux1 = srch(l1,((Varval *)a)->var);
			aux1->valor = v;
			break;
			
		case 'W':
			v = 0.0;
			if( ((Flow *)a)->tl) {
				while( eval(((Flow *)a)->cond) != 0){
					v = eval(((Flow *)a)->tl);
				}
			}
		    break;
			
		case 'L': 	
            eval(a->l);
			v = eval(a->r);
			break;
		
		case 'P': 	
            v = eval(a->l);		
			auxValor = v;
			if (fmod(v, 1) == 0.0) {
				printf ("%d\n",auxValor);
			}else{printf ("%.2f\n",v);}
			break;
							
		case 'V': 	
            l1 = ins(l1,((Varval*)a)->var);
			break;

		case 'T': 	
            printf("%s\n", ((Textovar*)a->l)->v);
			break;

		case 'Q': 	
            printf("\n");
			break;

		case 'Y':	
            v2 = eval2(a->l);		
			printf ("%s\n",v2); break; 
			break;

		case 'Z':
         	scanf("%s",v1);
			aux1 = srch(l1,((Varval *)a)->var);
			strcpy(aux1->valors,v1);
			break;

		case 'J': 		
			if(((Textovar*)a->l)->nodetype == 'm') {				
				if(((Textovar*)a->l)->v == "\n"){
					//printf("quebra");
				}
                printf ("%s", ((Textovar*)a->l)->v);
				break;
            }	

		default: printf("internal error: bad node %c\n", a->nodetype);
				
	}
	return v;
}

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

%}

%union{
	char str[50];
	float flo;
	int fn;
	int inter;
	Ast *a;
	}

%token <flo>NUM
%token <str>TIPO
%token <str>VARIA
%token <str> STRING
%token ESCREVAL ESPACO
%token INICIO FIM PRINT PRINTS OUT OUTS SE SENAO WHILE  
%token <fn> CMP

%right '='
%right '^' '#'
%left '+' '-'
%left '*' '/'
%left '('')'
%left CMP

%type <a> exp exp1 list stmt prog escrever

%nonassoc IFX NEG

%%

val: INICIO prog FIM
	;

prog: stmt 		{eval($1);}  /*Inicia e execução da árvore de derivação*/
	| prog stmt {eval($2);}	 /*Inicia e execução da árvore de derivação*/
	;
	
/*Funções para análise sintática e criação dos nós na AST*/	
/*Verifique q nenhuma operação é realizada na ação semântica, apenas são criados nós na árvore de derivação com suas respectivas operações*/
	
stmt: SE '(' exp ')' '{' list '}' %prec IFX
		{
			$$ = newflow('I', $3, $6, NULL);
		}
	
	| SE '(' exp ')' '{' list '}' SENAO '{' list '}'
		{
			$$ = newflow('I', $3, $6, $10);
		}

	| WHILE '(' exp ')' '{' list '}'
		{
			$$ = newflow('W', $3, $6, NULL);
		}
	| ESCREVAL '(' escrever ')' {$$ = $3;} // derivacao para escrever	
		
	| ESPACO '('')' {$$ = newast('Q',NULL,NULL);} // derivacao para escrever	

	| TIPO VARIA  { $$ = newvari('V',$2);}
	
    | TIPO VARIA '=' exp 
		{
			$$ = newasgn($2,$4);
		}

	| VARIA '=' exp
		{
			$$ = newasgn($1,$3);
		}
	| PRINT '(' exp ')'
		{
			$$ = newast('P',$3,NULL);
		}
	| PRINTS '(' exp1 ')'
		{
			$$ = newast('Y',$3,NULL);
		}	
	| OUT '(' VARIA ')'
		{
			$$ = newvari('S',$3);
		}
	| OUTS '(' VARIA ')'
		{
			$$ = newvari('Z',$3);
		}	



;	

// nó nao-terminal para escrever variaveis de tipos distintos
escrever: 
     
     STRING {$$ = newast('J', newtexto($1), NULL);} 
    ;

list:	  stmt{$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;
	
exp: 
	 exp '+' exp {$$ = newast('+',$1,$3);}		/*Expressões matemáticas*/
	|exp '-' exp {$$ = newast('-',$1,$3);}
	|exp '*' exp {$$ = newast('*',$1,$3);}
	|exp '/' exp {$$ = newast('/',$1,$3);}
	|exp '^' exp {$$ = newast('^',$1,$3);}
	|exp CMP exp {$$ = newcmp($2,$1,$3);}		/*Testes condicionais*/
	|'(' exp ')' {$$ = $2;}
	|'-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	|NUM {$$ = newnum($1);}
	|VARIA {$$ = newValorVal($1);}
	;

exp1: 
	VARIA {$$ = newValorValS($1);}
	;
%%


#include "lex.yy.c"

int main(){
	
	yyin=fopen("entrada.val","r");
	//yyin=fopen("media.txt","r");
	yyparse();
	yylex();
	fclose(yyin);
return 0;
}

