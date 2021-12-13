%option yylineno
%option noyywrap
%{
#include <string.h>


%}

NUME_INT [0-9]+
CARAC [a-zA-Z]+
STRING \"[^\"]*\" 
NUM [0-9]+\.?[0-9]*

VARIA "@"({CARAC}|{NUME_INT})*","?
TIPO {ESPACO}?("inteiro"|"dizima"|"txt")

COMENTARIO "-_-"  
INICIO "inicio"
FIM "fim"
OUT "leia"
OUTS "leias"
PRINT "imprimir"
PRINTS "imprima"

SE "se"
SENAO "senao"
WHILE "while"
ESPACO [\ ]
INVALIDO . 
ESCREVAL "escrever"
TAB "ESPACO"

%%


{INICIO} {return INICIO;}
{FIM} {return FIM;}
{SE} {return SE;}
{SENAO} {return SENAO;}
{WHILE} {return WHILE;}
{PRINT} {return PRINT;}
{PRINTS} {return PRINTS;}
{OUT} {return OUT;}
{OUTS} {return OUTS;}
{ESCREVAL} {return ESCREVAL;}
{TAB} {return ESPACO;}

{VARIA} {
	strcpy(yylval.str,yytext);
	return VARIA;
	}

{NUM} {
	yylval.flo = atof(yytext);
	return NUM;
	}	
{STRING} {
    int x; 
        for (x=0; x<strlen(yytext); x++){
        yytext[x] = yytext[x+1];
    }
        yytext[strlen(yytext)-1] = '\0';
        (yylval.str, yytext);
        return STRING;
    }
[-+()=/*^{};] {
	return *yytext;
    }		

">" {yylval.fn = 1; return CMP; }
"<" {yylval.fn = 2; return CMP; }
"<>" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }

{COMENTARIO} {;}
"\n" {;}
{INVALIDO} {;}

%%