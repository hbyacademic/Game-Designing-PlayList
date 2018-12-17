#include <iostream>
#include <cstdlib>
#include <time.h>
#include <conio.h>
using namespace std;

#define max 20
#define min 8
#define cmax 4
#define cmin 3

//show the all the number you count in that turn
//------------------------------------//
//num_cnt: the number count in that turn
//turn: 1 -> coomputer, 0 -> player 
//cnt: the starting point
//------------------------------------//
void show_number(int num_cnt,int cnt,int turn)
{	
	if(turn) 
		cout<<"computer: ";
	else
		cout<<"player:   ";
	for(int i=cnt+1;i<cnt+1+num_cnt;i++)
		cout<<i<<" ";
	cout<<endl;
}

int main()
{
	int N,c,turn,num,flag,prev,cnt=0,i=0,count=0;
	srand((unsigned)time(NULL));
	N=rand()%(max-min+1)+min;		//random number [min,max]
	c=rand()%(cmax-cmin+1)+cmin;	//random number [cmin,cmax]
	cout<<"Grab "<<N<<", the max count: "<<c<<endl;
	
	if(!((N-1)%(c+1)))	
	{
		turn=0;
		cout<<"You go first!"<<endl<<endl;
	}
	
	else	//go first will win the game
	{
		turn=1;
		//the first time, you should control the number (N-1)%(c+1)
		flag=1;
		cout<<"I go first!"<<endl<<endl;
	}

	while(cnt<N)
	{
		//every two times(computer+player) => 1 round
		if(count%2==0)
			cout<<endl<<"----round "<<++i<<"----"<<endl<<endl;
			
		if(turn)
		{
			if(flag)
			{
				num=(N-1)%(c+1);
				cout<<"(number count: "<<num<<") ";
				show_number(num,cnt,turn);	
				flag=0;
			}
				
			else
			{	
				//to keep the total number count to (c+1)
				num=c+1-prev;
				cout<<"(number count: "<<num<<") ";
				show_number(num,cnt,turn);
			} 
		}
			
		else
		{
			num=getch()-'0';	
			//if it is more than the max number count c,then set the number count to c
			if(num>c) num=c;
			cout<<"(number count: "<<num<<") ";
			show_number(num,cnt,turn);
			prev=num;
		}
		
		if(cnt+num>=N)
		{
			if(turn)
				cout<<"computer lose"<<endl;
			else
				cout<<endl<<"player lose"<<endl;
			break;
		}
		//computer and player take turns
		turn=1-turn;
		cnt+=num;
		count++;
	}
	return 0;
} 
