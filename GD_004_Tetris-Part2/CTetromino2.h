int max_y[7][4]=
{
	20,19,20,18,
	19,18,18,19,
	19,18,18,18,
	19,19,19,19,
	19,19,19,19,
	19,19,20,19,
	19,19,20,19
};

int max_x[7][4]=
{
	24,26,22,26,
	26,26,26,28,
	26,26,26,28,
	28,28,28,28,
	26,28,26,28,
	26,28,26,26,
	26,28,26,26
};

int min_x[7][4]=
{
	12, 8,10, 8,
	12,10,12,12,
	12,10,12,12,
	12,12,12,12,
	12,12,12,12,
	12,12,12,10,
	12,12,12,10
};

struct Square	//position of each block 
{
	int dx;
	int dy;
};

struct Tetromino	//position of four blocks (i.e. Tetromino)
{
	Square s[4];
};

Tetromino t[7][4]=		//position of seven Tetromino 
{	//rotate clockwise
	//  0 degree              90 degree              180 degree              270 degree   
	0,0, 1,0, 2,0, 3,0,	 2,-2, 2,-1, 2,0, 2,1,   1,0, 2,0, 3,0, 4,0,   2,-1, 2,0, 2,1, 2,2,  // ----
	0,0, 0,1, 1,1, 2,1,	  1,0,  1,1, 1,2, 2,0,   0,1, 1,1, 2,1, 2,2,    0,1, 1,1, 1,0, 1,-1, // |_
	0,1, 1,1, 2,1, 2,0,	  1,0,  1,1, 1,2, 2,2,   0,1, 1,1, 2,1, 0,2,    0,0, 1,0, 1,1, 1,2,  // _|
	0,0, 1,0, 0,1, 1,1,	  0,0,  1,0, 0,1, 1,1,   0,0, 1,0, 0,1, 1,1,    0,0, 1,0, 0,1, 1,1,  // ¤f 	
	0,1, 1,1, 1,0, 2,0,  0,-1,  0,0, 1,0, 1,1,   0,1, 1,1, 1,0, 2,0,   0,-1, 0,0, 1,0, 1,1,  // _|- 	
    0,1, 1,1, 1,0, 2,1,  0,-1,  0,0, 0,1, 1,0,  0,-1,1,-1,2,-1, 1,0,    1,0,2,-1, 2,0, 2,1,  // _|_
    0,0, 1,0, 1,1, 2,1,  1,-1,  1,0, 0,0, 0,1,  0,-1,1,-1, 1,0, 2,0,   2,-1, 2,0, 1,0, 1,1  // -|_
};

bool occupied[nBottomBorder-nTopBorder+2][nRightBorder-nLeftBorder+1];
int color[nBottomBorder-nTopBorder+2][nRightBorder-nLeftBorder+1]; 

class CTetromino
{	
	public:
	
		unsigned short type_id; 
		unsigned short pos_x;
		unsigned short pos_y;
		unsigned short rotate;
		
		CTetromino()
		{
			type_id=0;
			pos_x=0;
			pos_y=0;
			rotate=0;
		}
		
		CTetromino(unsigned short id,unsigned short x,unsigned short y,unsigned short r)
		{
			type_id=id;
			pos_x=x;
			pos_y=y;
			rotate=r;
			//when block is constructed, display it
			Draw();		
		}
	
		void init()	//initialize the occupied blocks & color
		{
			for(int i=0;i<22;i++)
				for(int j=0;j<20;j++)
				{
					occupied[i][j]=true;
					color[i][j]=8; //black
				}
		}
		
		bool detect_confliction(int shift_y,int shift_x) 
		{										//(0,0)  -> right below
			for(int i=0;i<nSize;i++)			//(0,-2) -> lower left
			{									//(0,2)  -> lower right
				if(occupied[pos_y+t[type_id-1][rotate].s[i].dy+1+shift_y][pos_x+2*t[type_id-1][rotate].s[i].dx-12+shift_x]==false
				|| occupied[pos_y+t[type_id-1][rotate].s[i].dy+1+shift_y][pos_x+2*t[type_id-1][rotate].s[i].dx+1-12+shift_x]==false)
					return false;
			}
			return true;
		}						
	
		void update()	//update blocks occupied & color 
		{
			for(int i=0;i<nSize;i++)
			{
				occupied[pos_y+t[type_id-1][rotate].s[i].dy][pos_x+2*t[type_id-1][rotate].s[i].dx-12]=false;
				occupied[pos_y+t[type_id-1][rotate].s[i].dy][pos_x+2*t[type_id-1][rotate].s[i].dx+1-12]=false;
				color[pos_y+t[type_id-1][rotate].s[i].dy][pos_x+2*t[type_id-1][rotate].s[i].dx-12]=type_id;
				color[pos_y+t[type_id-1][rotate].s[i].dy][pos_x+2*t[type_id-1][rotate].s[i].dx+1-12]=type_id;
			}
		}
			
		bool end_game()	//end of the game
		{
			int flag=100;
			for(int i=0;i<nSize;i++)		
			{								
				if(occupied[pos_y+t[type_id-1][rotate].s[i].dy+1][pos_x+2*t[type_id-1][rotate].s[i].dx-12]==false
				|| occupied[pos_y+t[type_id-1][rotate].s[i].dy+1][pos_x+2*t[type_id-1][rotate].s[i].dx+1-12]==false)
				{
					flag=pos_y+t[type_id-1][rotate].s[i].dy;
					break;
				}
			}
			if(flag<=1)
				return false;
			return true;
		}
		
		void Draw() 	//draw tetromino
		{
			attron(COLOR_PAIR(type_id));	
			for(int i=0;i<nSize;i++)
			{
				move(pos_y+t[type_id-1][rotate].s[i].dy,pos_x+2*t[type_id-1][rotate].s[i].dx);
				addch(' '); addch(' ');	
			}	
			attroff(COLOR_PAIR(type_id));
		}
							
		void Erase()	//erase tetromino
		{
			attron(COLOR_PAIR(8));
			for(int i=0;i<nSize;i++)
			{
				move(pos_y+t[type_id-1][rotate].s[i].dy,pos_x+2*t[type_id-1][rotate].s[i].dx);
				addch(' '); addch(' ');	
			}	
			attroff(COLOR_PAIR(8));
		}			
		
		void redraw()	//draw blocks after eliminating lines
		{
			for(int i=0;i<nBottomBorder-nTopBorder+1;i++)
				for(int j=0;j<nRightBorder-nLeftBorder+1;j++)
				{
					attron(COLOR_PAIR(color[i][j]));
					move(i,j+12);
					addch(' ');
					attroff(COLOR_PAIR(color[i][j]));
				}
			refresh();
		}
		
		int check_line()	//check if some rows all occupied by blocks 
		{
			int j,cnt=0;
			for(int i=0;i<=nBottomBorder;i++)
			{
				for(j=0;j<nRightBorder-nLeftBorder+1;j++)
					if(occupied[i][j]==true)		 	
				 		break;
				if(j==nRightBorder-nLeftBorder+1)
				{
					for(int k=i-1;k>=0;k--)
					{
						for(int m=0;m<nRightBorder-nLeftBorder+1;m++)
						{
							color[k+1][m]=color[k][m];
							color[k][m]=8;
							occupied[k+1][m]=occupied[k][m];
							occupied[k][m]=true;
						}
					}
					cnt++;
				}
			}
			redraw();
			return cnt;
		}
	
		bool Move(int c)
		{				
			if(!detect_confliction(0,0))
				return false;
				
			if(pos_y==max_y[type_id-1][rotate])	//reach the bottom
				return false;
				
			else if(c==KEY_UP && pos_y>=2)	//rotate
			{
				Erase();	//check if out of border before rotating
				if(pos_x>max_x[type_id-1][(rotate+1)%4]);
				else if(pos_x<min_x[type_id-1][(rotate+1)%4]);
				else
					rotate++;
				rotate=rotate%4;
				Draw();
			}
			
			else if(c==KEY_LEFT && detect_confliction(0,-2))  //left
			{
				Erase();
				if(pos_x==min_x[type_id-1][rotate]);
				else
					pos_x-=2;
				Draw();
			}
			
			else if(c==KEY_RIGHT && detect_confliction(0,2))  //right
			{
				Erase();
				if(pos_x==max_x[type_id-1][rotate]);
				else
					pos_x+=2;
				Draw();
			}
		
			else if(c==KEY_DOWN)
			{
				Erase();
				pos_y++;	
				Draw();		
			} 
			
			else if(c==32) //drop speedy
			{
				for(;pos_y<max_y[type_id-1][rotate] && detect_confliction(0,0);pos_y++)
				{
					Draw();
           			usleep(3000);
            		Erase();
				}
				Draw();
			}
			
			return true;
		}
};

