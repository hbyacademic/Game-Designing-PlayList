/////////////////////////
///// block related /////
/////////////////////////

//# block in each row/col
//including one label block
final int num=7+1;

//block size
float blockSize;

//block offset X,Y
float blockOfstX,blockOfstY;

//block trigger
boolean [][] trig = new boolean [num][num];
//cross trigger
boolean [][] trigCrs = new boolean [num][num];

//labels
int [] X= new int [num];
int [] Y= new int [num];

//copied labels for reset use
int [] cpX= new int [num];
int [] cpY= new int [num];

/////////////////////////
///// time related //////
/////////////////////////

//time bar offset
int timeBarOfst;

//total time for one live
float time;

//elapsed time
float elapsedTime=0;

/////////////////////////
///// button related ////
/////////////////////////

//for link & reset buttons (functional button)
//functional button size
int FuncBtnSize;

//functional button offset X, Y
float FuncBtnOfstX, FuncBtnOfstY;

//for pause/start button 
//border position X, position Y, width
float symBorderX,symBorderY,symBorderW;

//pause button
//inner triangle side (width), triangle height
float pSide,triH;

//horizontal dist. between border and inner triangle
float pauSymOfstX;

//vertical dist. between border and inner triangle
float pauSymOfstY;

//start button
//inner width, dist. between border and inner square
float contSide,contSymOfst;

//for loading images
PImage button,logo,life;

//button status
boolean golink=false, reset=false;
boolean pause=true, levelUpOnce=false;
boolean cross=false;

/////////////////////////
///// score related /////
/////////////////////////

//level position X,Y
float LvPosX, LvPosY;

//current level
int level=0;

//currnet lives
int LIVE=5;

void setup(){
  fullScreen();
  strokeWeight(4);
  
  //functional-button-related settings
  FuncBtnSize=width/5;
  FuncBtnOfstX=width/15;
  FuncBtnOfstY=width/10;
  
  //button-border-related settings
  symBorderW=FuncBtnSize/1.5;
  symBorderX=width/2-symBorderW/2;
  symBorderY=height-2*symBorderW;
  
  //inner-button-related settings
  triH=width/18;//same as contSide
  pSide=triH*2/sqrt(3);
  pauSymOfstX=(symBorderW-triH)/2;
  pauSymOfstY=(symBorderW-pSide)/2;
  contSide=width/18;
  contSymOfst=(symBorderW-contSide)/2;
  
  //load & resize images 
  button=loadImage("button.png");
  logo=loadImage("logo.png"); 
  life=loadImage("heart.jpeg");
  button.resize(FuncBtnSize,FuncBtnSize);
  logo.resize(FuncBtnSize,FuncBtnSize);
  life.resize(FuncBtnSize/3,FuncBtnSize/3);
  
  //block-related settings
  blockSize=width*1.0/(num+1);
  blockOfstX=(width-blockSize*num)/2;
  blockOfstY=(height-blockSize*num)/2+FuncBtnSize/3;
  
  //time bar setting
  timeBarOfst=width/15;
  time=width-2*timeBarOfst;
  
  //level rending position settings
  LvPosX=width/2;
  LvPosY=width/5;
  
  //button/cross trigger initialization
  for(int i=0;i<num;i++){
    for(int j=0;j<num;j++){
      trig[i][j]=false;
      trigCrs[i][j]=false;
    }
  }
  
  //initial labels
  for(int i=0;i<num;i++){
    cpX[i]=cpY[i]=i;
    X[i]=Y[i]=i;
  }
}

void mouseDragged(){
  levelUpOnce=true;
  if(!pause){
    trigBlocks();
  }
}

void mousePressed(){
  levelUpOnce=true;
  if(!pause){
    trigBlocks();
  }
  
  //tap the link button
  if(mouseX>=FuncBtnOfstX && 
     mouseX<=FuncBtnOfstX+FuncBtnSize && 
     mouseY>=FuncBtnOfstY && 
     mouseY<=FuncBtnOfstX+FuncBtnSize){
     golink=true;
  }
  
  //tap the reset button  
  if(mouseX>=width-FuncBtnOfstX-FuncBtnSize && 
          mouseX<=width-FuncBtnOfstX && 
          mouseY>=FuncBtnOfstY && 
          mouseY<=FuncBtnOfstX+FuncBtnSize){
     reset=true;
  }
  
  //tap the pause button
  if(mouseX>=symBorderX+symBorderW && 
          mouseX<=symBorderX+2*symBorderW && 
          mouseY>=symBorderY && 
          mouseY<=symBorderY+symBorderW){
     pause=!pause;   
  }
  
  //tap the cross button
  if(mouseX>=symBorderX-symBorderW && 
          mouseX<=symBorderX && 
          mouseY>=symBorderY && 
          mouseY<=symBorderY+symBorderW){
     cross=!cross;   
  }
}

//main function
void draw(){
  background(255); //white
  
  drawBlocks();
  drawBorder();
  showLabels();
  showFuncBtn();
  showLife();
  showCrsBtn();
  
  //pause/start button trigger
  if(!pause) showContBtn();
  else showPsBtn();
  
  //link button trigger
  if(golink){
     info();
     golink=false;
  }
  
  //reset button trigger
  if(reset){
    //restart the game
    if(LIVE==0){
      LIVE=5;
      level=0;
    } 
    //current level reset    
    rst();
    reset=false;
  }
  
  //elapsed time visualization
  showTimeBar();
  if(!pause) elapsedTime+=0.5;// elapsedTime+=10;  
  if(elapsedTime>=time){
     elapsedTime%=time;
     --LIVE;
  }
  
  //check if user passes the current level
  if(passOrNot() && levelUpOnce){
    ++level;
    levelUpOnce=false;  
    genNextLevel();
    pause=true;
  }
  
  //game over
  if(LIVE==0){
    pause=true;
    elapsedTime=0;
    showFinalLevel();
  } 
}

//show the final level
void showFinalLevel(){
  textSize(width/10);
  fill(0);
  String lv=str(level);
  text("Lv "+lv,LvPosX,LvPosY);
}

//check if pass the current level
boolean passOrNot(){
  for(int i=1;i<num;i++){
    if(cpX[i]!=0)
      return false;
    if(cpY[i]!=0)
      return false;
  }
  return true;
}

//show the current life
void showLife(){
  if(LIVE>0)
    image(life,width/2-FuncBtnSize/3/2-FuncBtnSize/3,FuncBtnOfstY+(FuncBtnSize-2*FuncBtnSize/3)/2);
  if(LIVE>1)
    image(life,width/2-FuncBtnSize/3/2,FuncBtnOfstY+(FuncBtnSize-2*FuncBtnSize/3)/2);
  if(LIVE>2)
    image(life,width/2-FuncBtnSize/3/2+FuncBtnSize/3,FuncBtnOfstY+(FuncBtnSize-2*FuncBtnSize/3)/2);
  if(LIVE>3)
    image(life,width/2-FuncBtnSize/3,FuncBtnOfstY+(FuncBtnSize-2*FuncBtnSize/3)/2+FuncBtnSize/3);
  if(LIVE>4)
    image(life,width/2,FuncBtnOfstY+(FuncBtnSize-2*FuncBtnSize/3)/2+FuncBtnSize/3);
}

//link info
void info(){
  link("https://hbyacademic.github.io/HBY/projects/");    
}

//reset the current level
void rst(){
  for(int i=0;i<num;i++){
    cpX[i]=X[i];
    cpY[i]=Y[i];
  }
  
  //trigger initialization
  for(int i=0;i<num;i++){
    for(int j=0;j<num;j++){
      trig[i][j]=false;
      trigCrs[i][j]=false;
    }
  }
}

//show time bar
void showTimeBar(){
  stroke(0);
  rectMode(CORNER);
  fill(0,255,255,32);
  if(elapsedTime!=0){
     rect(timeBarOfst,
     2*FuncBtnOfstY+FuncBtnSize,
     (time-elapsedTime),
     FuncBtnSize/6,
     7,0,0,7);
     
     fill(255,255,255);
     rect(timeBarOfst+(time-elapsedTime),
     2*FuncBtnOfstY+FuncBtnSize,
     elapsedTime,
     FuncBtnSize/6,
     0,7,7,0); 
  }
  
  else{
    rect(timeBarOfst,
     2*FuncBtnOfstY+FuncBtnSize,
     (time-elapsedTime),
     FuncBtnSize/6,
     7,7,7,7); 
  }
}

//show functional buttons
void showFuncBtn(){
  image(button,width-FuncBtnSize-FuncBtnOfstX,FuncBtnOfstY);
  image(logo,FuncBtnOfstX,FuncBtnOfstY);
}

//show cross button
void showCrsBtn(){
  ellipseMode(CORNER);
  fill(255,255,255,128); //white
  stroke(0,0,0,16); //black
  ellipse(symBorderX-symBorderW,symBorderY,symBorderW,symBorderW);
  
  if(cross){
    textSize(width/20);
    fill(0,0,0,128);
    text("cross",symBorderX-symBorderW/2,symBorderY-symBorderW/3);
    
    stroke(255,0,0,64);
    strokeWeight(16);
    line(symBorderX+contSymOfst-symBorderW,
    symBorderY+contSymOfst,
    symBorderX+contSide+contSymOfst-symBorderW,
    symBorderY+contSide+contSymOfst);
    
    line(symBorderX+contSide+contSymOfst-symBorderW,
    symBorderY+contSymOfst,
    symBorderX+contSymOfst-symBorderW,
    symBorderY+contSide+contSymOfst);
  }
  
  else{
    textSize(width/20);
    fill(0,0,0,128);
    text("fill",symBorderX-symBorderW/2,symBorderY-symBorderW/3);
    
    noStroke();
    fill(#708090,128);
    rect(symBorderX+contSymOfst-symBorderW,symBorderY+contSymOfst,contSide,contSide,7);
  }
  strokeWeight(4);
}

//show start button
void showContBtn(){
  textSize(width/20);
  fill(0,0,0,128);
  text("start",symBorderX+3*symBorderW/2,symBorderY-symBorderW/3);
  
  ellipseMode(CORNER);
  fill(255,255,255,128); //white
  stroke(0,0,0,16); //black
  ellipse(symBorderX+symBorderW,symBorderY,symBorderW,symBorderW);
  
  rectMode(CORNER);
  noStroke();
  fill(0,255,0,64);
  rect(symBorderX+contSymOfst+symBorderW,symBorderY+contSymOfst,contSide,contSide,7);
}

//show pause button
void showPsBtn(){
  textSize(width/20);
  fill(0,0,0,128);
  text("pause",symBorderX+3*symBorderW/2,symBorderY-symBorderW/3);
  
  ellipseMode(CORNER);
  fill(255,255,255,128);
  stroke(0,0,0,16);
  ellipse(symBorderX+symBorderW,symBorderY,symBorderW,symBorderW);
  
  rectMode(CORNER);
  noStroke();
  fill(0,255,0,64);
  triangle(symBorderX+2*symBorderW-pauSymOfstX-triH,
  symBorderY+symBorderW/2-pSide/2,
  symBorderX+2*symBorderW-pauSymOfstX-triH,
  symBorderY+symBorderW/2+pSide/2,
  symBorderX+2*symBorderW-pauSymOfstX,
  symBorderY+symBorderW/2);
}

//generate the next new level
void genNextLevel(){
  
  rst();
  
  //initial random labels
  if(level>4){
     for(int i=0;i<num;i++){
       X[i]=Y[i]=int(random(2,num-1)); 
     }
  }
  
  //inside-out algorithm
  //shuffle initial labels
  int tmp;
  for(int i=1;i<num;i++){
    int j=int(random(1,i+1));
    tmp=X[i];
    X[i]=X[j];
    X[j]=tmp;
  }
  
  for(int i=1;i<num;i++){
    int j=int(random(1,i+1));
    tmp=Y[i];
    Y[i]=Y[j];
    Y[j]=tmp;
  }
  
  for(int i=0;i<num;i++){
    cpX[i]=X[i];
    cpY[i]=Y[i]; 
  }
}

//shows current labels 
void showLabels(){
  fill(0);
  textSize(blockSize/2);
  textAlign(CENTER,CENTER);
  
  //render labels
  for(int i=1;i<num;i++){
    //horizontal
    text(cpX[i],
    blockOfstX+i*blockSize+blockSize/2,
    blockOfstY+blockSize/2);
      
    //vertical
    text(cpY[i],
    blockOfstX+blockSize/2,
    blockOfstY+i*blockSize+blockSize/2);
  }
}

//trigger blocks
void trigBlocks(){
  int i=int((mouseX-blockOfstX)/blockSize);
  int j=int((mouseY-blockOfstY)/blockSize);
  
  //valid trigger from 1st block ~ (num-1)th block
  if(i>=1 && i<num && j>=1 && j<num){  
    
    //if it has not been triggered
    if(!trig[i][j] && !trigCrs[i][j]){
      if(!cross){
        cpX[i]--;
        cpY[j]--;
        trig[i][j]=true;
      }
      else{
        trigCrs[i][j]=true;
      }
    }
  }
}  

//draw blocks
void drawBlocks(){
  rectMode(CENTER);
  for(int i=0;i<num;i++){
    for(int j=0;j<num;j++){
      float b=blockSize;
      float r=0;
      
      ////////////////
      //label blocks//
      ////////////////
      if(i<1 || j<1){
        if(i==0 && j==0){
          continue;
        }
      
        else{
          noStroke();
          fill(0,0,255,32); //blue
          b=blockSize-20;
          //for smoother corner rectangle
          r=7;
          
          //horizontal label blocks
          if(i<1){
            if(cpY[j]==0){
              fill(255,255,255); //white
            }
            else if(cpY[j]<0){
              fill(255,0,0,32); //red
            }
          }
      
          //vertical label blocks
          if(j<1){
            if(cpX[i]==0){
              fill(255,255,255);
            }
            else if(cpX[i]<0){
              fill(255,0,0,32);
            }
          }   
        }    
      }
      
      ////////////////
      //other blocks//
      ////////////////
      //if the block has not been triggered
      else if(!trig[i][j] && !trigCrs[i][j]){
        stroke(128,128,128,128);
        fill(255,255,255);
      }
      
      //if the block has been triggered
      else{
        if(trig[i][j] && !trigCrs[i][j]){
          stroke(128,128,128,255);
          fill(#708090,128);
        }
        else if(!trig[i][j] && trigCrs[i][j]){
          drawCrsPtn(i,j);
          stroke(128,128,128,128);
        }
      }
      
      rect(blockOfstX+i*blockSize+blockSize/2,
      blockOfstY+j*blockSize+blockSize/2,
      b,
      b,
      r);
    }
  }
}

//draw black border
void drawBorder(){
  rectMode(CORNER);
  stroke(0);
  noFill();
  rect(blockOfstX+blockSize,
  blockOfstY+blockSize,
  blockSize*(num-1),
  blockSize*(num-1));
}

//draw cross pattern
void drawCrsPtn(int i,int j){
  strokeWeight(16);
  noFill();
  stroke(255,0,0,64);
  //leftmost X,Y
  float lmX=blockOfstX+i*blockSize+(blockSize-contSide)/2;
  float lmY=blockOfstY+j*blockSize+(blockSize-contSide)/2;
      
  line(lmX,
  lmY,
  lmX+contSide,
  lmY+contSide);
  
  line(lmX+contSide,
  lmY,
  lmX,
  lmY+contSide);
  strokeWeight(4);
}
