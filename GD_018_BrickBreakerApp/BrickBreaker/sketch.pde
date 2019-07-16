//senor declaration
import ketai.sensors.*;
KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

//sensor event
void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

//image declaration
PImage logo;
//ball declaration
//Ball ball,ball2,ball3;
ArrayList<Ball>Balls=new ArrayList<Ball>();
//paddle declaration
Brick paddle;
//bricks declaration
ArrayList<Brick>Bricks=new ArrayList<Brick>();
//valid colors for brick
//color [] Color = {#000000,#FF0509, #FF8705, #FFE200, #65FF00, #00FFDF, #0041FF, #A500FF, #FF00C8, #FF0051, #808080};
color [] Color = {#00FFDF,#65FF00, #FFE200, #FF8705, #FF0509, #A500FF, #C0C0C0};
//maps for each level
int [][][] map={
//H
{{0,1,0,0,1,0},
 {0,1,0,0,1,0},
 {0,1,1,1,1,0},
 {0,1,0,0,1,0},
 {0,1,0,0,1,0}},
 
//b
{{0,2,0,0,0,0},
 {0,2,0,0,0,0},
 {0,2,2,2,0,0},
 {0,2,0,2,0,0},
 {0,2,2,2,0,0}},
 
//y
{{0,3,0,3,0,0},
 {0,3,0,3,0,0},
 {0,3,3,3,0,0},
 {0,0,0,3,0,0},
 {0,3,3,3,0,0}},

//A
{{0,0,4,4,0,0},
 {0,4,0,0,4,0},
 {0,4,4,4,4,0},
 {0,4,4,4,4,0},
 {0,4,0,0,4,0}},

//C
{{0,5,5,5,0,0},
 {5,0,0,0,5,0},
 {5,0,0,0,0,0},
 {5,0,0,0,5,0},
 {0,5,5,5,0,0}},

//A
{{0,0,1,1,0,0},
 {0,2,0,0,2,0},
 {0,3,3,3,3,0},
 {0,4,4,4,4,0},
 {0,5,0,0,5,0}},

//d
{{0,0,0,0,5,0},
 {0,0,0,0,4,0},
 {0,0,3,3,3,0},
 {0,0,2,0,2,0},
 {0,0,1,1,1,0}},
 
//E
{{0,1,1,1,1,0},
 {0,2,0,0,0,0},
 {0,3,3,3,3,0},
 {0,4,0,0,0,0},
 {0,5,5,5,5,0}},

//M
{{1,0,0,0,0,5},
 {2,6,0,0,3,6},
 {3,0,1,2,0,1},
 {4,0,0,0,0,2},
 {5,0,0,0,0,3}},

//I
{{0,1,2,3,4,0},
 {0,0,5,6,0,0},
 {0,0,1,2,0,0},
 {0,0,3,4,0,0},
 {0,5,6,1,2,0}},

//C
{{0,4,3,2,0,0},
 {5,0,0,0,1,0},
 {6,0,0,0,0,0},
 {1,0,0,0,5,0},
 {0,2,3,4,0,0}},
};

//paddle size & pos.
float paddleX,paddleY,paddleW,paddleH;
//brick rendering
float gap,BrickW,BrickH,offsetY;
float nbrow=5,nbcol=6;
//ball size
float ballRadius;
//score & level
int score=0,level=0;
//logo size
int logoSize=150;
//border size
int borderX,borderY,borderW,borderH;
//stroke size
int strokeSize=10;
//symbol border size
float symBorderX,symBorderY;
float symBorderW,symSide=75,symOffsetY=(logoSize-symSide)/2;
//pause symbol size
float pauX,pauY,pSide=50,triH=pSide*sqrt(3)/2;
float pauSymOffsetX,pauSymOffsetY;
//continue symbol size
float contX,contY,contSide=40,contSymOffset;
//flag initialization
boolean golink=false;
boolean pause=true;
boolean introMode=true;
boolean finished=false;

void setup(){
  //pasue symbol size setup
  pauX=width/5*4;
  pauY=width/15+symOffsetY;
  //symbol border size setup
  symBorderX=pauX-strokeSize;
  symBorderY=pauY-strokeSize;
  symBorderW=symSide+2*strokeSize;
  pauSymOffsetX=(symBorderW-triH)/2;
  pauSymOffsetY=(symBorderW-pSide)/2;
  
  //continue symbol size setup
  contX=width/5*4;
  contY=width/15+symOffsetY;
  contSymOffset=(symBorderW-contSide)/2;
  
  //logo setup
  logo=loadImage("logo.png");
  logo.resize(logoSize,logoSize);
  
  //sensor setup
  sensor = new KetaiSensor(this);
  sensor.start();
  
  //screen setup
  fullScreen(OPENGL);
  
  //ball & paddle setup
  ballRadius=width/40;
  Balls.add(new Ball(width/2,height/1.5,ballRadius,#ffffff));
  //ball=new Ball(width/2,height/1.5,width/40,#ffffff);
  //ball2=new Ball(width/2,height/1.5,width/40,#ff0000);
  //ball3=new Ball(width/2,height/1.5,width/40,#ff00ff);
  paddleX=width/2;
  paddleY=height-8*strokeSize;
  paddleW=width/2;
  paddleH=width/40;
  paddle=new Brick(paddleX,paddleY,paddleW,paddleH,7,false);
  
  //bricks setup
  gap=(width-8*strokeSize)/nbcol;
  offsetY=width/10+logoSize/15*25;
  BrickW=gap-5;
  BrickH=gap/2-5;
  for(int i=0;i<nbcol;i++){
    for(int j=0;j<nbrow;j++){
      if(map[level][j][i]>0)
        Bricks.add(new Brick(i*gap+(8*strokeSize)/2+5,j*gap/2+offsetY,BrickW,BrickH,map[level][j][i],true));
    } 
  }
  
  //border size setup
  borderX=2*strokeSize;
  borderY=width/15+logoSize/15*20;
  borderW=width-2*(2*strokeSize);
  borderH=height-width/15-logoSize/15*20-(2*strokeSize);
}

void contSymbol(){
  noFill();
  stroke(255,255,255);
  strokeWeight(strokeSize/2);
  rect(symBorderX,symBorderY,symBorderW,symBorderW);
  noStroke();
  
  fill(255,255,255);
  rect(symBorderX+contSymOffset,symBorderY+contSymOffset,contSide,contSide);
}

void pauseSymbol(){
  noFill();
  stroke(255,255,255);
  strokeWeight(strokeSize/2);
  rect(symBorderX,symBorderY,symBorderW,symBorderW);
  noStroke();
  
  fill(255,255,255);
  triangle(symBorderX+pauSymOffsetX,symBorderY+pauSymOffsetY,
  symBorderX+pauSymOffsetX,symBorderY+pSide+pauSymOffsetY,
  symBorderX+pauSymOffsetX+triH,symBorderY+pSide/2+pauSymOffsetY);
}

void updateScore(boolean reward){
  if(reward) score+=10;
  else score-=20;
}

void updateBricks(){
  for(int i=Bricks.size()-1;i>=0;i--){
    Brick brick=Bricks.get(i);
    brick.drawBrick();
    //detect all balls
    for(int j=0;j<Balls.size();j++){
      Ball ball=Balls.get(j);
      if(brick.CollideWithBall(ball)){
        brick.nbL--;
        ball.bR+=0.1; 
        updateScore(true);
      } 
    }
    //if(brick.CollideWithBall(ball)) brick.nbL--;
    //if(brick.CollideWithBall(ball2)) brick.nbL--;
    //if(brick.CollideWithBall(ball3)) brick.nbL--;
    if(brick.nbL<=0){
      Bricks.remove(brick);
    } 
  }
}

void levelUp(){
  ++level;
  Balls.add(new Ball(width/2,height/1.5,width/40,#ffffff));
  paddle.brW/=1.3;
  
  for(int i=0;i<nbcol;i++){
    for(int j=0;j<nbrow;j++){
      if(map[level][j][i]>0)
        Bricks.add(new Brick(i*gap+(8*strokeSize)/2+5,j*gap/2+offsetY,BrickW,BrickH,map[level][j][i],true));
    } 
  }
}

void drawAnimatedPaddle(){
  paddle.drawBrick();
  paddle.movePaddle();
  //move paddle by tilting the phone
  if(!pause || introMode)
    paddle.brX-=(accelerometerX*5);
    
  //detect all balls
  for(int i=0;i<Balls.size();i++){
    Ball ball=Balls.get(i);
    paddle.CollideWithBall(ball);
  }
  //paddle.CollideWithBall(ball);
  //paddle.CollideWithBall(ball2);
  //paddle.CollideWithBall(ball3);
}

void checkFinished(){
  if(level==10 && Bricks.size()==0){
    finished=true;
  }
}
String [] s={"Execllent","Good","Normal","Bad"};
int grade;
void showInfo(){
  textAlign(CENTER,CENTER);
  textSize(width/12);
  fill(255,255,255);
  
  if(introMode){
   text("Press upper right button \n to get started the game \n Try to tilt your phone \n See what happened!",width/2,height/3*2);
  }
 
  if(score<-10000) score=-9999;
  text("Lv "+(level+1)+"\n"+"Score "+score,width*21/40,width/6);
  
  if(finished){
    fill(255,255,255);
    textSize(width/8);
    if(score>=300) grade=0;
    else if(score>=200) grade=1;
    else if(score>=-400) grade=2;
    else grade=3;
    text("Grade: \n"+s[grade],width/2,height/2);
  }
}

void drawBorder(){
  noFill();
  stroke(255,255,255);
  strokeWeight(strokeSize);
  rect(borderX,borderY,borderW,borderH);
  noStroke();
}

void draw(){
  background(0);
  showInfo();
  drawBorder();

  //pause/continue button
  if(!pause) pauseSymbol();
  else contSymbol();
  
  //logo button
  image(logo,50,width/15);
  if(golink){
    golink=!golink;
    link("https://hbyacademic.github.io/HBY/projects/");
  }
  
  if(!finished){
    updateBricks();
    //draw all balls
    for(int i=0;i<Balls.size();i++){
      Ball ball=Balls.get(i);
      if(!introMode)
        ball.drawAnimatedBall();
    }
    //ball.drawAnimatedBall();
    //ball2.drawAnimatedBall();
    //ball3.drawAnimatedBall();
    drawAnimatedPaddle();  
  }
  
  //go to next level
  if(Bricks.size()==0){
    checkFinished();
    if(!finished){
      levelUp();
      for(int i=0;i<Balls.size();i++){
        Ball ball=Balls.get(i);
        ball.reset();
        pause=true;
      }
    }
    //ball.reset(); 
    //ball2.reset(); 
    //ball3.reset();
  }
}

void mousePressed(){
  //tap the link button
  if(mouseX>=50 && mouseX<=50+logoSize && mouseY>=width/15 && mouseY<=width/15+logoSize)
    golink=!golink;
  //tap the pause button
  else if(mouseX>=symBorderX && mouseX<=symBorderX+symBorderW && mouseY>=symBorderY && mouseY<=symBorderY+symBorderW){
     pause=!pause;
     introMode=false;
  }
}