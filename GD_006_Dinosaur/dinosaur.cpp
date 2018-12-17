#include <iostream>
#include <conio.h>
#include <windows.h>	//Sleep()
using namespace std;

//to set the cursor to be invisible
void SetCursorVisible(BOOL _bVisible,DWORD _dwSize)
{
	CONSOLE_CURSOR_INFO CCI;
	CCI.bVisible = _bVisible;
	CCI.dwSize = _dwSize;
	SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE),&CCI);
}

//to set the cursor to position (x,y)
void gotoxy(int pos_x, int pos_y)
{
	COORD coord;
	coord.X = pos_x;
	coord.Y = pos_y;
	HANDLE hOuput = GetStdHandle(STD_OUTPUT_HANDLE);
	SetConsoleCursorPosition(hOuput, coord);
	SetCursorVisible(false,100); 	
} 

void setup()
{
	system("cls");
	system("mode con: lines=30 cols=80");
	gotoxy(10,2);
	cout<<"Space: Jump, Q/q: quit";
	gotoxy(62,2);
	cout<<"Score: ";
	gotoxy(1,25);
	for(int x=0;x<79;x++)
		cout<<"~";
}



int t,speed=40;

void dinosaur(int status=0)
{
	static int a=1;

	if(status==0) t=0;	//running
	else if(status==2) t--;	//down
	else t++;	//jump
	
	//"��" by pressing alt+176
	gotoxy(2,13-t);
	cout<<"                  ";
	gotoxy(2,14-t);
	cout<<"          �ӡӡӡӡӡ�  ";
	gotoxy(2,15-t);
	cout<<"         �ӡӡӡӡӡӡӡӡ�";
	gotoxy(2,16-t);
	cout<<"         ��"<<char(36)<<"�ӡӡӡӡӡӡ�";
	gotoxy(2,17-t);
	cout<<"        �ӡӡӡӡӡӡӡӡӡ�";
	gotoxy(2,18-t);
	cout<<" ��     �ӡӡӡӡӡӡӡ�   ";
	gotoxy(2,19-t);
	cout<<" �ӡӡ� �ӡӡӡӡӡӡӡӡӡӡӡ� ";
	gotoxy(2,20-t);
	cout<<" �ӡӡ� �ӡӡӡӡӡӡӡӡӡ�   ";
	gotoxy(2,21-t);
	cout<<" �ӡӡӡӡӡӡӡӡӡӡӡ�  ��  ";
	gotoxy(2,22-t);
	cout<<"   �ӡӡӡӡӡӡӡӡ�      ";
	gotoxy(2,23-t);

	//jumping legs
	if(status!=0)
	{	
		cout<<"    �ӡӡӡӡ�       ";
		gotoxy(2,24-t);
		cout<<"    �ӡ�   �ӡ�      ";
	}

	//running legs a=0 -> a=1 -> a=1.....
	else if(a==1)
	{
		cout<<"    �ӡӡӡ�  �ӡӡ�   ";
		gotoxy(2,24-t);
		cout<<"      �ӡ�         ";
	}

	else if(a==0)
	{
		cout<<"     �ӡӡӡӡ�      ";
		gotoxy(2,24-t);
		cout<<"          �ӡ�     ";
	}

	gotoxy(2,25-t);
	if(status!=0)
		cout<<"                ";

	else	
		cout<<"~~~~~~~~~~~~~~~~";
	
	//take turn for running legs
	a=1-a;	
	Sleep(speed);
}

void tree()
{
	static int x=0,scr=0;
	
	if(x==56 && t<4)
	{
		scr=0;
		speed=40;
		gotoxy(36,8);
		cout<<"Game Over";
		getch();
		gotoxy(36,8);
		cout<<"         ";
	}
	
	gotoxy(74-x,20);
	cout<<"  ��  ";
	gotoxy(74-x,21);
	cout<<"�� �� �� ";
	gotoxy(74-x,22);
	cout<<"�ӡӡ� �� ";
	gotoxy(74-x,23);
	cout<<"  �ӡӡ� ";
	gotoxy(74-x,24);
	cout<<"  ��  " ;
	x++;
	
	if(x==73)
	{
		x=0;
		scr++;
		gotoxy(70,2);
		cout<<"     ";
		gotoxy(70,2);
		cout<<scr;
	}
	
}

int main()
{
	char ch;
	setup();
	while(true)
	{
		while(!kbhit())
		{
			dinosaur();
			tree();
		}
		ch=getch();
		if(ch==' ')
		{
			for(int i=0;i<10;i++)
			{
				dinosaur(1);
				tree();
			}
			for(int i=0;i<10;i++)
			{
				dinosaur(2);
				tree();
			}
		}
		else if (ch=='q' || ch=='Q')
			break;
	} 	
}
