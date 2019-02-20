PImage logo,button;
boolean once=false;
boolean reset=false;
boolean golink=false;
boolean pressed=false;
static int level=1;
//# of branches
int Branches[] = {0,4,4,4,4,4,5,6,6,6,6, 6,6,6,6,6,7,8,8,8,2};
//# of nodes
int num[] = {0,10,12,15,18,20,20,20,22,25,30,10,12,15,18,20,12,15,18,20,40};
//rotation speed
int speed[] = {1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,5};
CirSystem Cir;

class CirSystem{
  int R=width/5;  //radius of the middle circle
  int posx;   //x position of middle circle
  int posy;   //y position of middle circle
  int branches;  //# of the branches
  int level; //level
  boolean lock=false; //roate or not
  boolean LevelUpOnce=false; //level up once
  int amt;//number on the top node
  int radius; //radius of the three nodes
  /************************************
  >table[x][0]= 
    1,if there is a node at x degree. 
    0,otherwise
    
  >table[x][1]= number shown on nodes
  *************************************/
  int [][] table = new int [360][2];
 
  CirSystem(int x, int y, int b, int lv, int num, int r){
    posx=x;
    posy=y;
    branches=b;
    level=lv;
    amt=num; 
    radius=r;
    //initial branches
    for(int i=0;i<branches;i++)
      table[360/branches*i][0]=1;
  }

  /****************************
  draw the black middle circle
  with white level number
  ****************************/
  void DrawHead(){
    //black middle circle (i.e., head)
    fill(0);
    ellipse(posx,posy,R,R);
    
    //white level number
    fill(255);
    textSize(width/8);
    textAlign(CENTER,CENTER);
    String NumOnHead=str(level);
    text(NumOnHead,posx,posy);
  }
  
  /*****************************************
  draw black bodies with white index numbers
  which are connected to head
  Reset/link button dealing are involved.
  ******************************************/
  void DrawBody(){
    strokeWeight(4);
    
    //tap the reset button
    if(reset){
      once=false;
      Cir=new CirSystem(width/2,2*height/5,Branches[level],level,num[level],width/21);
      reset=false;
    }
    
    //tap the link button
    else if(golink){
      Cir.info();
    }
    
    //a tap except pressing link or reset button
    else if(pressed && Cir.getNum()>0){
      //If there exists at least one node 
      //from 264deg to 276deg,then lock it.
      //That is, one node is in collision with other node.
      //It's indicated that game is over.
      int tolerance=6;
      for(int j=270-tolerance;j<=270+tolerance;j++){
        if(table[j][0]==1){
          lock=true;
        }     
      }
      //If it is not locked,
      //then add a node with current index number
      //at 270 degree.
      if(!lock){
        //add a node
        table[270][0]=1;
        
        //current index number
        table[270][1]=Cir.getNum();    
      
}
    }
    
    //show the nodes connected to head
    for(int i=0;i<360;i++){
      if(table[i][0]==1){
        float angle=radians(i);
        fill(0);
        
        //offset is for not drawing the line segment into nodes
        //offset=(1/8R)
        //so,2R-(1/8R)=15R/8
        line(posx+R/2*cos(angle),posy-R/2*sin(angle),posx+15*R*cos(angle)/8,posy-15*R*sin(angle)/8);
        
        //radius of the node is: R/4
        ellipse(posx+2*R*cos(angle),posy-2*R*sin(angle),R/4,R/4);
 
        
        //label the nodes except initial nodes
        //with its index numbers
        if(table[i][1]>0){
          fill(255);
          textSize(width/32);
          String num=str(table[i][1]);
          text(num,posx+2*R*cos(angle),posy-2*R*sin(angle));
        }
      }
    }
    
    //In each level,there are several nodes (according to num[])
    //which are used to connect to head via user taps.
    //At most three nodes are shown in game. 
    //There are two cases which change the "amt" as follows.
    
    //1. game is over:
    //a node shown in red color is in collision with other node
    if(Cir.GameOver() && !once && !golink){ 
      once=true;
      amt--;  
    }
    
    //2. game is NOT over:
    //a node shown in black color is connected to the head
    else if(pressed && !Cir.GameOver()){ 
      //tap once!!!!
      pressed=false;
      if(amt>0) amt--; 
    }
    
    /*
If reset button was pressed,
    /then relaese it.*/
    if(golink){
      golink=false;
    }  
  }
  
  /******************************
  rotate the middle circle (head) 
  by updating node information
  ******************************/
  void UpdateBody(){
    LevelUpOnce=false;
    for(int i=0;i<360;i++){
      //rotation speed
      int s=speed[level];
      if(table[i][0]==1 && (!lock || reset)){
         //node degree update
         table[i][0]=0;   
         table[(i+=s)%360][0]=1;
         
         //node number update
         table[i%360][1]=
table[i-s][1];
         table[i-s][1]=0;
      }
    }
  } 
  
  /*****************
  whether win or not
  ******************/
  boolean win(){
    if(Cir.getNum()==0 && !lock)
      return true;
    return false;
  }
 
 
  
  /***************************
  draw a red node 
  in collision with other node.
  ****************************/
  void IsGameOver(){ 
    if(GameOver()){
      fill(255,0,0); 
      //position of nodes:2R
      //radius of nodes=(R/4)
      //position of node boundaries:2R+(R/4)=9R/4
      //offset is for getting touch with other node (collision)
      //offset=(width/50)
      //so,(9R/4)-(width/50)
      int rr=9*R/4-width/50;
      stroke(255,0,0);
      ellipse(width/2+rr*cos(radians(270)),2*height/5-rr*sin(radians(270)),width/21,width/21);
      fill(255);
      textSize(width/32);
      
      //+1, because "amt" minus 1 in if statement (void DrawBody)
      String NumOnNode=str(Cir.getNum()+1);
      text(NumOnNode,width/2+rr*cos(radians(270)),2*height/5-rr*sin(radians(270)));
      stroke(0);
    }
  }
  
  /*******************************
  the embedded link in link button
  ********************************/  
  void info(){
    link("https://hbyacademic.github.io/HBY-academic/");    
  }
  
  /*******************
  whether game is over 
  ********************/
  boolean GameOver(){
    return lock==true;
  }
  
  /*********************
  the current game level
  **********************/
  int getLevel(){
    return level;
  }
  
  /*******
  level up
  ********/
  void LevelUp(){
    //level up once!!!
    if(win() && !LevelUpOnce){
      //finish all levels
      if(level==20){
        noLoop();
      }
      //go to the next level
      else{
        level++;
        Cir=new CirSystem(width/2,2*height/5,Branches[level],level,num[level],width/21);
        LevelUpOnce=true;
      }
    }
  }
  
  /**************************
  show the first three nodes 
  **************************/
  void show(){  
    textSize(width/32);
    textAlign(CENTER,CENTER);
    for(int i=0;i<3;i++){
      fill(0);
      //show at most three nodes
      if(amt-(2-i)>0){
        ellipse(width/2,height-260-(radius+10)*(i+1),radius,radius);
        fill(255);
        String NumOnNode=str(amt-(2-i));
        text(NumOnNode,width/2,height-260-(radius+10)*(i+1)); 
      }
    }
   
  }
  
  /************************
  get # of nodes which are
  not connected to head yet
  *************************/
  int getNum(){
    return amt;
  }
}

void setup(){
  fullScreen(OPENGL);
  Cir=new CirSystem(width/2,2*height/5,Branches[level],level,num[level],width/21);
  button=loadImage("button.png");
  logo=loadImage("logo.png");
  button.resize(150,150);
  logo.resize(150,150);
}

void draw(){
  background(192);
  image(button,width-200,width/10);
  image(logo,50,width/10);
  Title(); 
  Cir.DrawHead();
  Cir.DrawBody();
  Cir.UpdateBody();
  Cir.show();
  Cir.IsGameOver();
  Cir.LevelUp();
}

void Title(){
  textSize(width/10);
  fill(0);
  String lv=str(Cir.getLevel());
  text("Lv "+lv,width/2,width/5);
  text("Tap the screen \n shot the dots",width/2,height-width/5);
}

void mousePressed(){
  //tap the link button
  if(mouseX>=50 && mouseX<=200 && mouseY>=width/20 && mouseY<=width/20+200)
    golink=true;
  //tap the reset button  
  else if(mouseX>=width-200 && mouseX<=width-50 && mouseY>=width/20 && mouseY<=width/20+150)
    reset=true;
  else
    pressed=true;
}

void mouseReleased(){
  pressed=false;
}
