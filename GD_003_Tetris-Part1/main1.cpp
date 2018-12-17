#include <curses.h>
#include <unistd.h>
#include <cstdlib>
#include <time.h>


#define nSize 4
#define nType 7
#define nLeftBorder   12
#define nRightBorder  31
#define nBottomBorder 20
#define nTopBorder    0
#include "tetris.h"

void region() 
{
	for(int i=0;i<=nBottomBorder;i++)
	{
		move(i, nLeftBorder-2); addch('*');
		move(i, nLeftBorder-1); addch('*');
		move(i, nRightBorder+1); addch('*');
		move(i, nRightBorder+2); addch('*');	
	}
	for(int i=0;i<20;i++)
	{
		move(nBottomBorder+1, nLeftBorder+i); addch('*');
		move(nBottomBorder+2, nLeftBorder+i); addch('*');
	}	
}

void init_game()
{
	initscr();
    noecho();
    curs_set(0);	//set the cursors invisible 
    timeout(300);	//after 300ms 
    keypad(stdscr, TRUE);
    start_color();
    init_pair(0, COLOR_WHITE, COLOR_CYAN);
    init_pair(1, COLOR_WHITE, COLOR_BLUE);
    init_pair(2, COLOR_BLACK, COLOR_WHITE);
    init_pair(3, COLOR_WHITE, COLOR_YELLOW);
    init_pair(4, COLOR_WHITE, COLOR_GREEN);
    init_pair(5, COLOR_WHITE, COLOR_MAGENTA);
    init_pair(6, COLOR_WHITE, COLOR_RED);
    init_pair(7, COLOR_BLACK, COLOR_BLACK);
	region();
}

void game_over()
{
	move(nTopBorder,nRightBorder+3);
	addstr("Game over!");
	refresh();
}

int main()
{
    int i,c;
    CTetromino a;
	int rand_pos[8]={12,14,16,18,20,22,24,26};
	srand((unsigned)time(NULL));
    init_game();
    int flag=1;
    while(flag)
    {
	   	a = CTetromino(rand()%nType, rand_pos[rand()%8], 0);
       	do
       	{
			refresh();
			c=getch();
			if(c=='q')
			{
				game_over();
                flag=0;
                break;
			}
			else
			{
				a.Move(c);
			}
			
        } while (a.Move(KEY_DOWN));
	}
	
    refresh();
    game_over();
    getch();
    usleep(32768555);
    endwin(); 
    return 0;
}
