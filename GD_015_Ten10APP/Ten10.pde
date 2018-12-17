PImage logo;
//for storing tile information
int [][] board = new int[7][8];
//define tile colors (also, you can select other colors)
color [] Color = {#FF0509, #FF8705, #FFE200, #65FF00, #00FFDF, #0041FF, #A500FF, #FF00C8, #FF0051, #808080};

//the size of the tile => tileSize
//for UI (user interface) design => offsetY
//the highest tile value => maxNum
int tileSize=60,offsetY=80,maxNum=-1;

void initial(){
  
  //initialize the tile information array
  for(int i=0;i<7;i++){
    for(int j=0;j<8;j++){
      board[i][j]=0;
    }
  }
  //inital the first two rows
  for(int i=0;i<7;i++) board[i][7]=int(random(4))+1;
  for(int i=0;i<7;i++) board[i][6]=int(random(4));
}

void setup(){
  //7*60+5, 8*60+5+80
  size(425,565);
  initial();
  
  textAlign(CENTER,CENTER);
  noStroke();
  
  logo=loadImage("logo.png");
  logo.resize(60,60);
}

void drawTile(int colorIndex, int tileX, int tileY, int num, int textX, int textY){
  
  //color depend on its tile number
  fill(Color[colorIndex]);
  //draw a square tile with some spacing between
  rect(tileX,tileY,tileSize-5,tileSize-5);      
  //show the tile number
  fill(255);
  textSize(50);
  text(""+num,textX,textY);
}

void draw(){
  
  background(255);
  image(logo,10,10);
  fill(192);
  rect(5,80,tileSize*7-5,tileSize*8);
  fill(0);
  textSize(30);
  
  //some rules shown in the background
  text("Your score is \n the highest value tile \n on the board. \n \n Now try to get 10!",width/2,height/2);
  
  //game over or win
  if(win() || gameOver()){
    stop=true;
    fill(192);
    rect(5,80,tileSize*7-5,tileSize*8);
    fill(255);
    textSize(50);
    if(win()) text(" Congratulation! \n You won!!!", width/2,height/2);
    if(gameOver())  text("Game Over!!!!!",width/2,height/2);
  } 
  
  //draw tiles
  if(!win() && !gameOver()){
    for(int i=0;i<7;i++){
      for(int j=0;j<8;j++){
        if(board[i][j]>0){
          drawTile(board[i][j]-1, i*tileSize+5, j*tileSize+5+offsetY, board[i][j], i*tileSize+tileSize/2, j*tileSize+tileSize/2+offsetY);
        }  
      }
    }  
  }
  
  //draw movingTile
  if(MoveNum!=-1 && MoveNum!=0){
    drawTile(MoveNum-1, mouseX, mouseY, MoveNum, mouseX+tileSize/2, mouseY+tileSize/2);
  }
  
  //time bar
  timeBar();
 
  //atomatically move up
  AllmoveUp();
  
  //show the highest value tile now
  findMax();
  //only when the highest value tile is not less than or euqal to 0
  if(maxNum>0){
    fill(0);
    textSize(30);
    text("high: ",315,30);
    drawTile(maxNum-1, width-70+5, 15+5, maxNum, width-70+tileSize/2, 15+tileSize/2);
  } 
}

//indicate if it is moving the tile now => MoveNum
//record the original position of the moving tile => (prevX,prevY)
int MoveNum=-1,prevX,prevY;
void mousePressed(){
  stop=true;
  int mX=int(mouseX/tileSize);
  int mY=int((mouseY-offsetY)/tileSize);
  //println(mX, mY, board[mX][mY]); //DEBUG
  if(mX>-1 && mX<7 && mY>-1 && mY<8 && !gameOver()){
    if(board[mX][mY]>0){
      //record the original position for recovery use
      prevX=mX;
      prevY=mY;
      //record the number on this tile
      MoveNum=board[mX][mY];
      //not to draw this tile
      board[mX][mY]=0;
    } 
  }
}

int tmp;
void mouseReleased(){
  stop=false;
  int nX=int(mouseX/tileSize);
  int nY=int((mouseY-offsetY)/tileSize);
  //prevent not to move out of range!!!!!!!!!!!!!!!!
  if(nX<0) nX=0;
  if(nX>6) nX=6;
  if(nY<0) nY=0;
  if(nY>7) nY=7;
  //println("#"+nX, nY, board[nX][nY]); //DEBUG
  
  if(MoveNum!=-1 && MoveNum!=0){
    //prevY>nY (bottomUp)
    //board[prevX][prevY>0?prevY-1:prevY]>0 ====> There is a block on the now block
    //nX!=prevX ====> two blocks are in different columns
    //(prevX<nX && board[prevX<6?prevX+1:prevX][prevY]>0) ====> move to right, and there is a block on its right side
    //(prevX>nX && board[prevX>0?prevX-1:prevX][prevY]>0) ====> move to left, and there is a block on its left side
    boolean notBottomUp=(prevY>nY && board[prevX][prevY>0?prevY-1:prevY]>0 && nX!=prevX && ((prevX<nX && board[prevX<6?prevX+1:prevX][prevY]>0) || (prevX>nX && board[prevX>0?prevX-1:prevX][prevY]>0)));
     
    //prevY<nY (topdown)
    //board[nX][nY>0?nY-1:nY]>0 ====> There is a block on the destination(dest, for short) block
    //nX!=prevX ====> two blocks are in different columns
    //(prevX<nX && board[nX>0?nX-1:nX][nY]>0) ====> move to right, and there is a block on dest's left side
    //(prevX>nX && board[nX<6?nX+1:nX][nY]>0) ====> move to left, and there is a block on dest's right side
    boolean notTopDown=(prevY<nY && board[nX][nY>0?nY-1:nY]>0 && nX!=prevX && ((prevX<nX && board[nX>0?nX-1:nX][nY]>0) || (prevX>nX && board[nX<6?nX+1:nX][nY]>0)));
    
    boolean notUp=(prevY>nY+1 && nX==prevX && board[prevX][prevY-1]>0);
    boolean notDown=(prevY<nY+1 && nX==prevX && board[nX][nY-1]>0);
    boolean notLeft=(prevX>nX+1 && nY==prevY && board[nX<6?nX+1:nX][nY]>0 && board[nX][nY>0?nY-1:nY]>0 && (board[prevX>0?prevX-1:prevX][prevY]>0 || board[prevX][prevY>0?prevY-1:prevY]>0));
    boolean notRight=(prevX<nX+1 && nY==prevY && board[nX>0?nX-1:nX][nY]>0 && board[nX][nY>0?nY-1:nY]>0 && (board[prevX<6?prevX+1:prevX][prevY]>0 || board[prevX][prevY>0?prevY-1:prevY]>0));
    
    
    if(MoveNum==board[nX][nY] && !(notBottomUp || notTopDown || notUp || notDown || notLeft || notRight)){//same number
   
      //addup number
      board[nX][nY]++;
      MoveNum=-1;
  
      //BottomUp case (if user move the lower one to the upper one) 
      // 5      5       0
      // 1  =>  2  ===> 5
      // 1      0       2
      // 3      3       3
      //TopDown case (if user move the upper one to the lower one) 
      // 5      5       0
      // 1      0       5
      // 1  =>  2  ===> 2
      // 3      3       3
      if(prevY>0){
        if(board[prevX][prevY]==0){
          for(int j=prevY;j>0;j--){
            tmp=board[prevX][j];
            board[prevX][j]=board[prevX][j-1];
            board[prevX][j-1]=tmp;
          }
        }
      }
    }
    
    //recovery
    else { 
      board[prevX][prevY]=MoveNum;
      MoveNum=-1;
    }
  }
}

//all blocks move up
int time=500,cnt=0;
boolean stop=false;
void AllmoveUp(){
  //if user pick up a block, then it won't move up 
  //if not do so, then there will be a bug. (for example as follows)
  //user pick up a block, and then all block move up => user release the block and this block will missing!!!!
  if(!stop) cnt+=2;
  //println(cnt); ///DEBUG
  
  if(cnt>time){
    cnt=0;
    for(int i=0;i<7;i++){
        for(int j=1;j<8;j++){
          board[i][j-1]=board[i][j];
        }
      }
      for(int i=0;i<7;i++){
        board[i][7]=int(random(4))+1;
      }
    }
}

//time bar
void timeBar(){
  fill(128);
  rect(90,55,(time-cnt)*0.5,15);
  fill(192);
  rect(90+(time-cnt)*0.5,55,cnt*0.5,15);
}

//find the highest value tile
void findMax(){
  for(int i=0;i<7;i++){
    for(int j=0;j<8;j++){
      if(board[i][j]>maxNum)  maxNum=board[i][j];
    }
  }
}

//check if game is over
boolean gameOver(){
  for(int i=0;i<7;i++)
    if(board[i][0]>0 && cnt>499){
      return true;
    }
  return false;
}

//check if user won
boolean win(){
  return maxNum>=10;
}
