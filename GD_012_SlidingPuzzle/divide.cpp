#include <iostream>
#include <fstream> 
#include <stdlib.h>
#include <vector>
#include <algorithm> 
using namespace std;

typedef unsigned char   BYTE;   //  1 byte (0~255) 
typedef unsigned short  WORD;   //  2 bytes (0~65536) 
typedef unsigned long   DWORD;  //  4 bytes (0~2^32 -1) 

#pragma pack(push) 
#pragma pack(2)    
struct INFO
{
	// BITMAPFILEHEADER (14 bytes) from 16 reducing to 14
	WORD bfType;          //BM -> 0x4d42 (19778)     
	DWORD BfSize;         //�`���ɤj�p        
	WORD bfReserved1;     //bfReserved1 ����0  
    WORD bfReserved2;     //bfReserved2 ����0        
    DWORD bfOffBits;      //�����q 
	// BITMAPINFOHEADER(40 bytes)    
    DWORD biSize;         //info header�j�p     
    int biWidth;
    int biHeight;
    WORD biPlanes;        //�줸�ϼh��=1 
    WORD biBitCount;      //�C��pixel�ݭn�h��bits 
    DWORD biCompression;  //0�������Y 
    DWORD biSizeImage;    //�I�}�ϸ�Ƥj�p  
    int biXPelsPerMeter;  //�����ѪR�� 
    int biYPelsPerMeter;  //�����ѪR�� 
    DWORD biClrUsed;      //0���ϥΩҦ��զ�L�C�� 
    DWORD biClrImportant; //���n���C���(0���Ҧ��C��Ҥ@�˭��n) 
};
#pragma pack(pop) 

class Image
{	
	public:
		
		int height;
		int width;
		int rowsize;    // bgr -> 3 bytes(24 bits) 
		BYTE* term;
		
		Image()   //storage is bottom-up,from left to right 
		{
			height=0;
			width=0;
		}
		
		Image(int height,int width)
		{
			this->height=height;
			this->width=width;
			rowsize=(3*width+3)/4*4;   //set to be a multiple of "4" 
			term=new BYTE[height*rowsize];  
		}
		
		void load(const char *filename)
		{
			INFO h;  
			ifstream f;
			f.open(filename,ios::in|ios::binary);
			f.seekg(0,f.end);
			//cout<<"���ɤj�p�G "<<f.tellg()<<"bytes"<<endl;
			f.seekg(0,f.beg);
			f.read((char*)&h,sizeof(h));
						
			width=h.biWidth;
			height=h.biHeight;
			//cout<<"reading from "<<filename<<"..."<<endl;
			//print(h);
			*this=Image(height,width);
			f.read((char*)term,height*rowsize);
			f.close();
		}
		
		void save(const char* filename)
		{
			INFO h=
			{		
				19778,   //0x4d42
				DWORD(54+rowsize*height),   
				0,
				0,
				54,
				40,
				width,
				height,
				1,
				24,   
				0,
				DWORD(rowsize*height),
				3780,   //3780
				3780,   //3780
				0,
				0				
			};
			//cout<<"writing into "<<filename<<"..."<<endl;
			ofstream f;
			f.open(filename,ios::out|ios::binary);
			f.write((char*)&h,sizeof(h));
			f.write((char*)term,rowsize*height);
			f.close();	
		}	
};

void cut(Image m)
{
	Image T[9]=Image(m.height/3,m.width/3);		
	int col[9]={2,2,2,1,1,1,0,0,0};
	int row[9]={0,1,2,0,1,2,0,1,2};
	char name[]="x.bmp";
	
	for(int i=0;i<9;i++)
	{
		for(int y=0,yy=m.height*col[i]/3;y<T[i].height,yy<m.height*(col[i]+1)/3;y++,yy++)
			for(int x=0,xx=m.rowsize*row[i]/3;x<T[i].rowsize,xx<m.rowsize*(row[i]+1)/3;x+=3,xx+=3)
			{
				T[i].term[y*T[i].rowsize+x]=m.term[yy*m.rowsize+xx];
				T[i].term[y*T[i].rowsize+x+1]=m.term[yy*m.rowsize+xx+1];
				T[i].term[y*T[i].rowsize+x+2]=m.term[yy*m.rowsize+xx+2];
			}
		name[0]=i+49;
		T[i].save(name);
	}
}

int main()
{
	Image input;
	input.load("face.bmp");
	cut(input);
	return 0;
}
