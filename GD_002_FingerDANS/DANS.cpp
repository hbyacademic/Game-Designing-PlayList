#include <iostream>
#include <conio.h>
#include <windows.h>
#include <time.h>
#include <vector> 
//#include <console.h>
using namespace std;

char dir[4]={'^','v','<','>'};
const int tkamt=27; //test case amount


void graphic_interface(int kase)	//kase=0~3 -> dir[kase] -> the text color of dir[kase] will be green
{	
	switch(kase)	
	{
		case 0:
		{
			cout<<"                                  -----"<<endl;
			cout<<"                                  | ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
			cout<<"^ ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
			cout<<"|"<<endl;
			cout<<"                              -------------"<<endl;
			cout<<"                              | < | v | > |"<<endl;
			cout<<"                              -------------"<<endl;
			break;
		}
		
		case 1:
		{
			cout<<"                                  -----"<<endl;
			cout<<"                                  | ^ |"<<endl;
			cout<<"                              -------------"<<endl;
			cout<<"                              | < | ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
			cout<<"v ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
			cout<<"| > |"<<endl;
			cout<<"                              -------------"<<endl;
			break;
		}	
	
		case 2:
		{
			cout<<"                                  -----"<<endl;
			cout<<"                                  | ^ |"<<endl;
			cout<<"                              -------------"<<endl;
			cout<<"                              | ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
			cout<<"< ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
			cout<<"| v | > |"<<endl;
			cout<<"                              -------------"<<endl;
			break;
		}	
	
		case 3:
		{
			cout<<"                                  -----"<<endl;
			cout<<"                                  | ^ |"<<endl;
			cout<<"                              -------------"<<endl;
			cout<<"                              | < | v | ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
			cout<<"> ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
			cout<<"|"<<endl;
			cout<<"                              -------------"<<endl;
			break;
		}	
	}
}

void text_interface(int idx,vector<int>tk)	//show all the test case be the form of text interface
{											// the text color of i-th test case will be green
	cout<<"          ";
	for(int i=0;i<tkamt;i++)
	{
		if(i==idx)
		{
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
			cout<<dir[tk[i]]<<" ";
			SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
		}
		else
			cout<<dir[tk[i]]<<" ";
	}
	cout<<endl<<endl;
}

void intro()	//the introduction of the game 
{
	cout<<"Have you ever played Daning Machine ?"<<endl;
	Sleep(2000);
	cout<<"when you see one of the arrow keys on the screen"<<endl;
	Sleep(5000);
	cout<<"you have to 'step on' the corresponding button by 'your leg(s)'"<<endl;
	Sleep(5000);
	cout<<"Now, this is a game by 'pressing' the corrsponding button by 'your hand(s)'"<<endl;
	Sleep(5000);
	cout<<"for example, when you see....."<<endl<<endl;
	Sleep(1000);
	cout<<"                   -----"<<endl;		
	cout<<"                   | ^ |"<<endl;
	cout<<"               -------------"<<endl;
	cout<<"               | ";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
	cout<<"< ";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
	cout<<"| v | > |     or     ^ > > v";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
	cout<<" <";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
	cout<<" ^ > v v <"<<endl;		
	cout<<"               -------------"<<endl<<endl;
	Sleep(3000);
	cout<<"you have to press the left arrow key on your keyboard¡I"<<endl;
	Sleep(3000);
}

int countdown()	//select modes(1:graphic/0:text interface)  & the countdown of the game start
{
	int mode;
	char c;
	cout<<"Select a mode to start the game (0:text interface, 1:graphic interface) -- ";
	while(mode=getche()-'0')	
	{
		if(mode<2)	//until you press '0' or '1'
			break;
		else 
		{
			system("cls");
			cout<<"Select a mode to start the game (0:text interface, 1:graphic interface) -- ";
		}
	}
	
	cout<<endl;
	
	cout<<"Are you ready ? [y/n] ";	
	while(c=getche())	//until you press 'y' or 'n'
	{
		if(c=='y')
		{
			cout<<endl<<endl<<"3"<<endl;
			Sleep(1000);
			cout<<"2"<<endl;
			Sleep(1000);
			cout<<"1"<<endl;
			system("cls");
			break;
		}
	
		else if(c=='n')
		{
			cout<<endl<<"i will give you five seconds to get ready";
			for(int i=0;i<5;i++)
			{
				cout<<".";
				Sleep(1000);
			}
			cout<<endl<<endl;
			cout<<"3"<<endl;
			Sleep(1000);
			cout<<"2"<<endl;
			Sleep(1000);
			cout<<"1"<<endl;
			system("cls");
			break;
		}
	
		else
		{
			system("cls");
			cout<<"Select a mode to start the game (0:text interface, 1:graphic interface) -- "<<mode<<endl;
			cout<<"Are you ready ? [y/n] ";	
		}
	}
	cout<<endl;

	return mode;
}

void finished()	//the screen of the end of each game
{
	cout<<endl<<endl;
	cout<<"     ========================================================================="<<endl<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_INTENSITY);
	cout<<"          ffffffff  iiiiiii   nnn      nn  iiiiiii   sssssss   hhh    hhh\n"; 
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
	cout<<"          ffffffff  iiiiiii   nnn      nn  iiiiiii   ssss ss   hhh    hhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY);	
	cout<<"          fff         iii     nnn      nn    iii     sss       hhh    hhh\n"; 
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          fff         iii     nnnn     nn    iii     ssss      hhh    hhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),8 | FOREGROUND_INTENSITY);
	cout<<"          ffffffff    iii     nn nn    nn    iii      ssss     hhhhhhhhhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          ffffffff    iii     nn  nn   nn    iii       ssss    hhhhhhhhhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          fff         iii     nn   nn  nn    iii        ssss   hhh    hhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          fff         iii     nn    nn nn    iii         sss   hhh    hhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),6 | FOREGROUND_INTENSITY);
	cout<<"          fff       iiiiiii   nn     nnnn  iiiiiii  ss sssss   hhh    hhh\n";
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_INTENSITY);
    cout<<"          fff       iiiiiii   nn      nnn  iiiiiii  sssssss    hhh    hhh\n\n";
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
    cout<<"     ========================================================================="<<endl<<endl; 
    cout<<endl;
}

void game_title()	//the screen of the game start
{
	cout<<endl<<endl;
	cout<<"     =============================================================="<<endl<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_INTENSITY);
	cout<<"          dddddd           aaaaa      nnn      nnn   sssssss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_INTENSITY);
	cout<<"          dd    dd        aaaaaaa     nnn      nnn   ssss ss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
	cout<<"          dd     dd      aa     aa    nnn      nnn   sss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          dd      dd    aa       aa   nnnn     nnn    ssss"<<endl;	
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),8 | FOREGROUND_INTENSITY);
	cout<<"          dd       dd  aa         aa  nnnnn    nnn     ssss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          dd       dd  aa         aa  nnn nn   nnn      ssss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          dd       dd  -HBYacademic-  nnn nn   nnn       ssss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_BLUE | FOREGROUND_INTENSITY);
	cout<<"          dd      dd   aa         aa  nnn   nn nnn        sss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),6 | FOREGROUND_INTENSITY);
	cout<<"          dd     dd    aa         aa  nnn    nnnnn   ss sssss"<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_INTENSITY);
	cout<<"          ddddddd      aa         aa  nnn     nnnn   sssssss"<<endl<<endl;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
	cout<<"     ==============================================================="<<endl<<endl;
}

double best_record(vector<double>data) //find the best score under different modes 
{
	double min=data[0];
	for(int i=1;i<data.size();i++)
		if(data[i]<min) min=data[i];
	return min;
}

int main(void)
{   
	int mode,cnt=1;
	char option;
	srand((unsigned)time(NULL));
	vector<double>graphic_career_record;	
	vector<double>text_career_record;
	
	// setting the window size
	SMALL_RECT rect;
    COORD coord;
    coord.X = 89; // Defining our X and Y size for buffer
    coord.Y = 43;  
    rect.Top = 0;
    rect.Left = 0;
    rect.Bottom = coord.Y-1; // height for window
    rect.Right = coord.X-1;  // width for window
    HANDLE hwnd = GetStdHandle(STD_OUTPUT_HANDLE); // get handle
    SetConsoleScreenBufferSize(hwnd, coord);       // set buffer size
    SetConsoleWindowInfo(hwnd, 1, &rect);       // set window size
	
	while(1)
	{	
		if(option=='n')	//not to play again & show the best score
		{
			if(graphic_career_record.size()==0)
				cout<<"                 The best record of graphic interface is -- seconds."<<endl;
			else
				cout<<"                 The best record of graphic interface is "<<best_record(graphic_career_record)<<" seconds."<<endl;
			
			if(text_career_record.size()==0)
				cout<<"                 The best record of text interface is -- seconds."<<endl;
			else
				cout<<"                 The best record of text interface is "<<best_record(text_career_record)<<" seconds."<<endl;
			break;
		}
		
		if(cnt<2)	//the first play of the game, will show the intro
			intro();

		mode=countdown();	//record the mode (graphic/text interface)
		
		WORD color=FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE;
		SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),color);	//set the foreground of the text color be WHITE
		
		int extend_dir_key[4]={72,80,75,77}; 	//the return value of the four arrow keys
		vector<int>tk;	//test case (statement)
		tk.clear();
		int ch,idx=0;
		double start,end;
		
		for(int i=0;i<tkamt;i++)	//randomly generate 20 arrow keys for games	
			tk.push_back(rand()%4);
				
		start=clock();	//record the starting time
		while(1)
		{		
			if(idx==tkamt)	//end of each game
			{
				end=clock();	//record the ending time
				(mode)?graphic_career_record.push_back((end-start)/CLOCKS_PER_SEC):text_career_record.push_back((end-start)/CLOCKS_PER_SEC);
				finished();
				cout<<"                              you spend "<<(end-start)/CLOCKS_PER_SEC<<" seconds."<<endl; 
				cnt++;
				cout<<"play again ? [y/n] ";
				while(option=getche())	//until you press 'y' or 'n'
				{
					if(option=='y' || option=='n')
						break;
					
					else
					{
						system("cls");
						finished();
						cout<<"                              you spend "<<(end-start)/CLOCKS_PER_SEC<<" seconds."<<endl; 
						cout<<"play again ? [y/n] ";
					}
				}
				
				if(option=='y')
					system("cls");
				
				else
				{
				 	system("cls");
					finished();
					cout<<"                              you spend "<<(end-start)/CLOCKS_PER_SEC<<" seconds."<<endl; 
					cout<<endl<<endl;
				} 
					
				break;
			}
			
			if(idx==0)	//for the first screen of the game start different from others
				system("cls");	//do cls one time to adjust
			game_title();
			
			if(!mode)
				text_interface(idx,tk);
			else
				graphic_interface(tk[idx]);	
								
			while(ch=getch()) //get the input key 
			{
				if(ch==extend_dir_key[tk[idx]])	//until you press the correct corresponding key
				{
					idx++;
					system("cls");
					break;
				}
			}
		}
	}
	system("PAUSE");
}
