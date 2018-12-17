import java.util.ArrayList;

//arraylist with data tpye "p"
ArrayList<p>table=new ArrayList();

//define data type "p"
public class p
{
  int x;
  int y;
  int idx;
  int r;
  int g;
  int b;
}

PImage bg;
char [] alphabet=new char[52];

void setup()
{
  //the size of the canvas
  size(640,400);  
  
  //load the background image
  bg=loadImage("bg.bmp");
  
  //define the text set ('A'~'Z' and 'a'~'z') 
  for(int i=0;i<alphabet.length;i++)
  {
    if(i>=26)  alphabet[i]=char('a'+(i-26));
    else alphabet[i]=char('A'+i);
  }
}

//textSize
int ts=40;

//the position of the alphabet
int boxX=int(random(16))*ts,boxY=0;
int c=0;

//shot or not
boolean shoot=false;

//record # of the alphabet which is not shot in each column 
int [] cnt=new int[16];

//color
int cr=128,cg=128,cb=128;

void draw()
{
  //draw the background image on the canvas
  image(bg,0,0,640,400);
  
  //the dropoff speed
  boxY+=80;
  
  textSize(ts);
  
  //if the alphabet(s) is still not shot after reaching the bottom
  //then they will be stacked from the bottom
  if(boxY>360 && !shoot)
  {
    p point=new p();
 
    //record some information about the alphabet (posX, pos, idx,r, g, b)
    //update posY, so that the new alphabet can be stacked on the top of old one
    point.y=360-(cnt[boxX/ts])*ts; 
    point.x=boxX;
    point.idx=c;
    point.r=cr;
    point.g=cg;
    point.b=cb;
    table.add(point);
   
    //if # of the alphabet stacked in one column > 10
    //then game is over
    if(cnt[boxX/ts]>10)
    {
        exit();    
      //table.clear();
      //for(int i=0;i<cnt.length;i++)  cnt[i]=0;
      
    }  
    cnt[boxX/ts]++;
  }
  
  //if the alphabet reached the bottom OR the alphabet was shot
  //then we generate the new alphabet
  if(boxY>360 || shoot)
  {
    c=int(random(52));
    boxX=int(random(16))*ts;
    cr=int(random(1,256));
    cg=int(random(1,256));
    cb=int(random(1,256));
    boxY=0;
    shoot=false;
  }
  
  //draw the alphabet and its box
  fill(cr,cg,cb);
  rect(boxX,boxY,ts,ts);
  fill(0);  //black color
  text(alphabet[c],boxX+(ts-textWidth(alphabet[c]))/2,boxY+ts);
  
  //show the alphabet(s) which was not shot by user
  for(int i=0;i<table.size();i++)
  {
    char ch=alphabet[table.get(i).idx];
    int posX=table.get(i).x;
    int posY=table.get(i).y;
    int r=table.get(i).r;
    int g=table.get(i).g;
    int b=table.get(i).b;
    fill(r,g,b);
    rect(posX,posY,ts,ts);
    fill(0);
    text(ch,posX+(ts-textWidth(ch))/2,posY+ts);
  }   
}

//shot the alphabet
void keyPressed()
{
  if(key==alphabet[c])
    shoot=true;
}
