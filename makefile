all : trab_compil.l trab_compi.y
	clear/cls
	win_flex -i trab_compil.l
	win_bison trab_compi.y
	gcc .\trab_compi.tab.c -o analisador