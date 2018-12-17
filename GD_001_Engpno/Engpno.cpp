#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <windows.h>
#include <time.h>
#include <map>
using namespace std;

int main()
{   
	int correct=0,wrong=0;
	map<char,int>m;
	m['z']=0;
	m['x']=1;
	m['c']=2;
	m['v']=3;
	m['b']=4;
	m['n']=5;
	m['m']=6;
	m[' ']=7;
	int mus[8]={523,587,659,698,784,880,988,523};
	string tab="zxcvbnm ";
	cout<<"-----------------------------------------------"<<endl;
	cout<<"    This is a simple English typing game"<<endl;
	cout<<"    - \"cls\" to refresh the screen¡I"<<endl; 
	cout<<"    - \"quit\" to terminate the game¡I"<<endl; 
	cout<<"    - \"score\" to see you socre¡I"<<endl;
	cout<<"    - \"new\" to start a new game¡I"<<endl; 
	cout<<"    - \"pno\" to play the piano¡I"<<endl; 
	cout<<"      (zxcvbnm - Do Re Mi Fa So La Si)"<<endl;
	cout<<"    - \"qpno\" to quit playing the piano¡I"<<endl;
	cout<<"-----------------------------------------------"<<endl;
	while(1)
	{
		string s,statement="",substg;
		srand((unsigned)time(NULL));
		for(int k=0;k<rand()%20;k++)
		{
			substg=char(rand()/(RAND_MAX+1.0)*26+65);
			cout<<substg;
			statement+=substg;
		}
			
		cout<<endl;
		
		getline(cin,s);
		if(s=="pno")
		{
			while(getline(cin,s))
			{
				if(s=="qpno")	break;
				if(s=="cls")
				{
					system("cls");
					cout<<"-----------------------------------------------"<<endl;
					cout<<"    This is a simple English typing game"<<endl;
					cout<<"    - \"cls\" to refresh the screen¡I"<<endl; 
					cout<<"    - \"quit\" to terminate the game¡I"<<endl; 
					cout<<"    - \"score\" to see you socre¡I"<<endl;
					cout<<"    - \"new\" to start a new game¡I"<<endl; 
					cout<<"    - \"pno\" to play the piano¡I"<<endl; 
					cout<<"      (zxcvbnm - Do Re Mi Fa So La Si)"<<endl;
					cout<<"    - \"qpno\" to quit playing the piano¡I"<<endl;
					cout<<"-----------------------------------------------"<<endl;
					continue;
				}
				
				const int len=s.length();
				string table[7][len];
				int prev=m[s[0]],current;
				table[6-prev][0]="¤@ ";
				for(int i=1;i<s.length();i++)
				{
					current=m[s[i]];
					if(current==7) continue;
					table[6-current][i]="¤@ ";
				}
				
				for(int i=0;i<s.length();i++)
				{
					if(m[s[i]]==7)	Sleep(1200);
					else Beep(mus[m[s[i]]],600);
				}
				 
				for(int i=0;i<7;i++,cout<<endl)
					for(int j=0;j<len;j++)
						if(table[i][j]=="")
							cout<<" # ";
						else
							cout<<table[i][j];
			}
			continue;	
		}
	
		if(s=="new")
		{
			correct=wrong=0;
			continue;
		}
		
		if(s=="score")
		{
			cout<<correct<<"correct, "<<wrong<<"wrong."<<endl;
			continue;
		}
		
		if(s=="cls")
		{
			system("cls");
			cout<<"-----------------------------------------------"<<endl;
			cout<<"    This is a simple English typing game"<<endl;
			cout<<"    - \"cls\" to refresh the screen¡I"<<endl; 
			cout<<"    - \"quit\" to terminate the game¡I"<<endl; 
			cout<<"    - \"score\" to see you socre¡I"<<endl;
			cout<<"    - \"new\" to start a new game¡I"<<endl; 
			cout<<"    - \"pno\" to play the piano¡I"<<endl; 
			cout<<"      (zxcvbnm - Do Re Mi Fa So La Si)"<<endl;
			cout<<"    - \"qpno\" to quit playing the piano¡I"<<endl;
			cout<<"-----------------------------------------------"<<endl;
			continue;
		}
		
		if(s=="quit")
			break;
			
		(s==statement)?correct++:wrong++;
	}
	return 0;
}
