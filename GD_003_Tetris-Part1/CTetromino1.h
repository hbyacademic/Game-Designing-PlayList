int max_y[7]={20,19,19,19,19,19,19};
int max_x[7]={24,26,26,28,26,26,26};

struct Square	//position of each block 
{
	int dx;
	int dy;
};

struct Tetromino	//position of four blocks (i.e. Tetromino)
{
	Square s[4];
};

Tetromino t[7]=		//position of seven Tetromino 
{
	0,0, 1,0, 2,0, 3,0,
	0,0, 0,1, 1,1, 2,1,
	0,1, 1,1, 2,1, 2,0,
	0,0, 1,0, 0,1, 1,1,
	0,1, 1,1, 1,0, 2,0,
    0,1, 1,1, 1,0, 2,1,
    0,0, 1,0, 1,1, 2,1,
};

class CTetromino
{	
	public:
	
		unsigned short type_id; 
		unsigned short pos_x;
		unsigned short pos_y;
		
		CTetromino()
		{
			type_id=0;
			pos_x=0;
			pos_y=0;
		}
		
		CTetromino(int id,int x,int y)
		{
			type_id=id;
			pos_x=x;
			pos_y=y;
			Draw();	//when block is constructed, display it
		}
		
	/*	bool detect_confliction()
		{	
			for(int i=0;i<4;i++)
			{
				if(occupied[pos_y+t[type_id].s[i].dy+1][pos_x+2*t[type_id].s[i].dx-12]==false ||
				occupied[pos_y+t[type_id].s[i].dy+1][pos_x+2*t[type_id].s[i].dx+1-12]==false)
					return false;
			}
			return true;
		}
		
		void update_occupy()
		{
			for(int i=0;i<4;i++)
			{
				occupied[pos_y+t[type_id].s[i].dy][pos_x+2*t[type_id].s[i].dx-12]=false;
				occupied[pos_y+t[type_id].s[i].dy][pos_x+2*t[type_id].s[i].dx+1-12]=false;
			}
				
		}	*/	
		
			
		bool Move(int c)
		{					
		/*	if(!detect_confliction())
			{
				update_occupy();
				return false;	
			}*/
			
			if(pos_y==max_y[type_id])
				return false;
			
			if(c==KEY_LEFT)
			{
				Erase();
				if(pos_x==12);
				else
					pos_x-=2;
				Draw();
			}
			
			else if(c==KEY_RIGHT)
			{
				Erase();
				if(pos_x==max_x[type_id]);
				else
					pos_x+=2;
				Draw();
			}
		
			else if(c==KEY_DOWN)
			{
				Erase();
				if(pos_y==max_y[type_id])
					return false;
				else
					pos_y++;
				Draw();
			} 
			
			else if(c==32) //space
			{
				for(;pos_y<max_y[type_id];pos_y++)
				{
					Draw();
           			usleep(3000);
            		Erase();
				}
				Draw();
			}
			return true;
		}
	
	private:
	 	
		//bool occupied[21][20]={{true}};
		
		void Draw() 
		{
			attron(COLOR_PAIR(type_id));	
			for(int i=0;i<nSize;i++)
			{
				move(pos_y+t[type_id].s[i].dy,pos_x+2*t[type_id].s[i].dx);
				addch(' '); addch(' ');	
			}	
			attroff(COLOR_PAIR(type_id));
		}
		
		void Erase()
		{
			attron(COLOR_PAIR(7));
			for(int i=0;i<nSize;i++)
			{
				move(pos_y+t[type_id].s[i].dy,pos_x+2*t[type_id].s[i].dx);
				addch(' '); addch(' ');	
			}	
			attroff(COLOR_PAIR(7));
		}			
};

