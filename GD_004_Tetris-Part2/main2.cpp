#include <iostream>
#include <curses.h>
#include <unistd.h>
#include <cstdlib>
#include <time.h>
#include <cmath>
#include <cstring>
using namespace std;

#define nSize 4
#define nType 7
#define nLeftBorder   12
#define nRightBorder  31
#define nBottomBorder 20
#define nTopBorder    0
#include "tetris.h"

int sum=0;

void region() //game border
{
	for(int i=0;i<=nBottomBorder;i++)
	{
		move(i, nLeftBorder-2); addch('*');
		move(i, nLeftBorder-1); addch('*');
		move(i, nRightBorder+1); addch('*');
		move(i, nRightBorder+2); addch('*');	
	}
	for(int i=0;i<nBottomBorder;i++)
	{
		move(nBottomBorder+1, nLeftBorder+i); addch('*');
		move(nBottomBorder+2, nLeftBorder+i); addch('*');
	}	
	move(nTopBorder+5,nRightBorder+5);
	addstr("---Next---");
}

void init_game()
{
	initscr();	//start curses mode			
    noecho();	//not to dislay keys that user pressed 	
    curs_set(0); //set the cursors invisible		 
    timeout(300);	//after 300ms
    keypad(stdscr,TRUE); //trun on the keypad in curses.h	
    start_color();
	//init_pair need to start from '1' 	
    //1~7 represent seven Tetrominos respectively
	//8 for erasing the Tetromino 
    init_pair(1, COLOR_WHITE, COLOR_CYAN);
    init_pair(2, COLOR_WHITE, COLOR_BLUE);
    init_pair(3, COLOR_BLACK, COLOR_WHITE);
    init_pair(4, COLOR_WHITE, COLOR_YELLOW);
    init_pair(5, COLOR_WHITE, COLOR_GREEN);
    init_pair(6, COLOR_WHITE, COLOR_MAGENTA);
    init_pair(7, COLOR_WHITE, COLOR_RED);   
	init_pair(8, COLOR_BLACK, COLOR_BLACK);
	region();
}

void game_over()
{
	move(nTopBorder+2,nRightBorder+6);
	addstr("Game over!");
	refresh();
}

void show_line(int sum)
{
	move(nTopBorder+10,nRightBorder+5);
	addstr("---Line---");
	int i=0,num=sum;
	while(num+48>=58)
	{
		i++;
		num-=10;
	}
	if(i!=0)
	{ 
		move(nTopBorder+12,nRightBorder+9);
		addch(i+48);
	}
	move(nTopBorder+12,nRightBorder+10);
	addch(sum-i*10+48);
}


int main()
{
    attron(A_BOLD);	//°ª«G«× 
	int c,shift,next_id,current_id,cnt,start=1;
    CTetromino current,next;
	srand((unsigned)time(NULL));
    init_game();
    current.init();
    current_id=rand()%nType+1;
    
	while(start)
    {	//where id is in {1,2,...,7} as shown in init_game()
	   	current=CTetromino(current_id,18,0,0); 
       	next_id=rand()%nType+1; 
		//show the next tetromino	
       	if(next_id==1) shift=6;
       	else if(next_id==4) shift=8;
       	else shift=7;
		next=CTetromino(next_id,nRightBorder+shift,nTopBorder+7,0);
		show_line(sum);
		
		do
       	{
			refresh();
			c=getch();
					
			if(c=='q' || !current.end_game()) 
			{
				game_over();
                start=0;
                break;
			}
			else
			{
				current.Move(c);							
			}			
        }while (current.Move(KEY_DOWN));
        current.update();
        cnt=current.check_line();
        sum+=cnt;
        next.Erase();
		current_id=next_id;
	} 
	
    usleep(32768555);
    endwin(); 
    return 0;
}
