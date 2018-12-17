#include <iostream>
#include <curses.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
using namespace std;

#define nSize 4
#define nType 7
#define nLeftBorder   12
#define nRightBorder  31
#define nBottomBorder 20
#define nTopBorder    0

struct Square
{
	int dx;
	int dy;
};

struct Tetromino
{
	Square s[4];
};

Tetromino t[7]=
{
	0,0, 1,0, 2,0, 3,0,
	0,0, 0,1, 1,1, 2,1,
	0,1, 1,1, 2,1, 2,0,
	0,0, 1,0, 0,1, 1,1,
	0,1, 1,1, 1,0, 2,0,
    0,1, 1,1, 1,0, 2,1,
    0,0, 1,0, 1,1, 2,1,
};

void draw_block(int pair,int y0,int x0)
{
	attron(COLOR_PAIR(pair));
	for(int i=0;i<nSize;i++)
	{
		move(y0+t[pair].s[i].dy,x0+2*t[pair].s[i].dx);
		addch(' '); addch(' ');	
	}	
	attroff(COLOR_PAIR(pair));
}

void erase_block(int pair,int y0,int x0)
{
	attron(COLOR_PAIR(7));
	for(int i=0;i<4;i++)
	{
		move(y0+t[pair].s[i].dy,x0+2*t[pair].s[i].dx);
		addch(' '); addch(' ');	
	}	
	attroff(COLOR_PAIR(7));
}

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
    curs_set(0);
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
	addstr("Game over¡I");
	refresh();
	echo();
	endwin();
}

int main()
{
    srand((unsigned)time(NULL));
	char i, c;
    init_game();
		
	int pair,pos,flag=1;
	int max_x[7]={24,26,26,28,26,26,26};
	int max_y[7]={20,19,19,19,19,19,19};
	int rand_pos[8]={12,14,16,18,20,22,24,26};
	while(flag)
	{
	    int init=0;
	    pair=rand()%7;
		pos=rand_pos[rand()%8];
		if(pair==0 && pos==26) pos-=2;
		draw_block(pair,init,pos);

		while ( (c = getch() ))
	    {	
			if(c=='q')
			{
				flag=0;
				break;
			}
			
			if(init==max_y[pair])
				break;

			else if(c==32)	//space
			{
				for(;init<max_y[pair];init++)
				{
					draw_block(pair,init,pos);
            	//	refresh();
           			usleep(3000);
            		erase_block(pair,init,pos);
				}
				draw_block(pair,init,pos);
			}
			
			else if(c==66)	//down
			{
				erase_block(pair,init,pos);
				(init==max_y[pair])?init=init:init++;
				draw_block(pair, init, pos);
			}
			
			else if(c==68)	//left 
	        {
				erase_block(pair, init, pos);
				(pos==12)?pos=pos:pos-=2;
				draw_block(pair, init, pos);	
			}
			
			else if(c==67)	//right
	        {
				erase_block(pair, init, pos);
				(pos==max_x[pair])?pos=pos:pos+=2;
				draw_block(pair, init, pos);	
	        }

			else
			{
				timeout(500);
				erase_block(pair, init, pos);
				init++;
				draw_block(pair, init, pos);	
			}
			refresh();
	    }
	}

    game_over();
    return 0;
}
