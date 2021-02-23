%option noyywrap
%{

    //codigo c

%}
COMENT "!!"[a-zA-Z]*
NUM [0-9]+
CARA [a-zA-Z]+
SUM [0-9]+"+"[0-9]+
SUB [0-9]+"-"[0-9]+
MULT [0-9]+"*"[0-9]+
DIV [0-9]+"/"[1-9]+
LER "r >> "[a-zA-Z]+
ESCREVAL "vv << "[a-zA-Z]+
VALINT "int "[0-9]+
VALFLOAT "flt "{NUM}+("."){NUM}+
VALTXT "txt "[a-zA-Z]+
COND ([a-z][a-zA-Z0-9]*|[0-9]+)[<>=][=]?([a-z][a-zA-Z0-9]*|[0-9]+)
SE "se("{COND}")"
SENAO "senao("{COND}")"
REPETICAO "ENQUANTO("[a-zA-Z]+")"
QUEBRA "float" 
TXT "string"

%%

"Inicio" {
    printf ("Inicio do programa \n");
}
"Fim" {
    printf ("Fim do programa \n");
}
{COMENT} {
    printf ("Caractere: \t%s\n",yytext);
}
{NUM} {
    printf ("Digitos %s\n", yytext);
}
{CARA} {
    printf ("Letras %s\n", yytext);
}
{SUM} {
    printf ("Soma dos valores: %s\n",yytext);
}
{SUB} {
    printf ("Subtração dos valores: %s\n",yytext);
}
{MULT} {
    printf ("Multiplicar os valores: %s\n",yytext);
}
{DIV} {
    printf ("Divisão dos Valores: %s\n",yytext);
}
{LER} {
    printf ("Leia com calma: %s\n",yytext);
}
{ESCREVAL} {
    printf ("Textos com letras: %s\n",yytext);
}
{VALINT} {
    printf ("Valores inteiros: %s\n",yytext);
}
{VALFLOAT} {
    printf ("Valores floats: %s\n",yytext);
}
{VALTXT} {
    printf ("fRASES E TEXTOS: %s\n",yytext);
}
{COND} {
    printf ("Operação Condicional: %s\n", yytext);
}
{SE} {
    printf ("Condicional %s\n", yytext);
}
{SENAO} {
    printf ("Condicional SENÃO %s\n", yytext);
}
{REPETICAO} {
    printf ("Estrutura de repetição: %s\n ",yytext);
}
"\n" {
}

%%

//codigo C
int main(){

    yyin = fopen("compi.v", "r");
    yylex();
    fclose (yyin);

    return 0;
}
