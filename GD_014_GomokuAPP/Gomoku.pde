void setup(){
  size(600,600);
}

//the offset between each two vertical/horizontal lines
int gap=60;

//all piceces on the board
int [][][] Allpiece = new int[11][11][2];
//                            ^   ^   ^
//                            |   |   |
//                            x   y  ([0]:B/W piece & [1]:index of the piece)


void draw(){ 

  background(#EDB807);
  
  //for black line use
  strokeWeight(2);
  stroke(0); 
  
  //draw the checkboard with 11 vertical and horizontal lines
  for(int i=0;i<11;i++){
      line(0,i*gap,width,i*gap); 
      line(i*gap,0,i*gap,height);
   } 
  
  //draw all the piecees
  for(int i=0;i<11;i++){
    for(int j=0;j<11;j++){
      //number the pieces in number order
      noStroke(); textAlign(CENTER,CENTER); textSize(30);
      //black piece (draw black piece with white number on)
      if(Allpiece[i][j][0]==1){ fill(0);  ellipse(i*gap,j*gap,gap-10,gap-10); fill(250); text(Allpiece[i][j][1],i*gap,j*gap);}
      //white piece (draw white piece with black number on)
      if(Allpiece[i][j][0]==2){ fill(250); ellipse(i*gap,j*gap,gap-10,gap-10); fill(0); text(Allpiece[i][j][1],i*gap,j*gap);}
    }
  }
  
  //prepare the next piece
  fill((pieceN%2)*250-10,(pieceN%2)*250-10,(pieceN%2)*250-10);
  ellipse(mouseX,mouseY,gap-10,gap-10);
  
  //gameOver
  if(gameOver){
    fill(255,0,0);
    textSize(180);
    if(winner==1){text(" Black \n won!!!!!",300,280);}
    if(winner==2){text(" White \n won!!!!!",300,280);}
    textSize(35);
    text("Press ENTER to restart.....",300,310);
  }
}

int pieceN=0;
int NowX,NowY,BW,winner;
boolean gameOver=false;

void mousePressed(){
  
  //according to the mouse position, find the nearest intersection on the checkerboard
  NowX=int((mouseX+gap/2)/gap);
  NowY=int((mouseY+gap/2)/gap);
  
  //BW => 0: no piece; 1: black piece; 2: white piece
  //"pieceN+1" is the total number of pieces on checkerboard now
  BW=pieceN%2+1;
  
  //if there is no other piece occupy on this intersection
  //then player can put the piece
  if(Allpiece[NowX][NowY][0]==0 && !gameOver){     
    Allpiece[NowX][NowY][0]=BW;  
    pieceN++;
    Allpiece[NowX][NowY][1]=pieceN;
    //someone won
    if(WhoWin()!=0){ gameOver=true; winner=WhoWin();}
   }
}

//0: no one won; 1: black won; 2: white won
int WhoWin(){
  int N=0;
  //vertice test (left side and right side)
  //left side
  for(int lx=NowX;lx>=0;lx--){ if(Allpiece[lx][NowY][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  //right side
  for(int rx=NowX;rx<11;rx++){ if(Allpiece[rx][NowY][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  if(N-1>=5)return BW; else N=0;
  
  //horizontal test (up side and down side)
  //up side
  for(int uy=NowY;uy>=0;uy--){ if(Allpiece[NowX][uy][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  //down side  
  for(int ly=NowY;ly<11;ly++){ if(Allpiece[NowX][ly][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  if(N-1>=5) return BW; else N=0;
  
  //diagnoal test (left-top side and right-bottom side)
  //left-top
  for(int dlx=NowX,dly=NowY; dlx>=0 && dly>=0; dlx--,dly--){ if(Allpiece[dlx][dly][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  //right-bottom
  for(int drx=NowX,dry=NowY; drx<11 && dry<11; drx++,dry++){ if(Allpiece[drx][dry][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  if(N-1>=5) return BW; else N=0;
  
  //vice-diagnoal test (right-top side and left-bottom side)
  //right-top
  for(int dlx=NowX,dly=NowY; dlx<11 && dly>=0; dlx++,dly--){ if(Allpiece[dlx][dly][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  //left-bottom
  for(int drx=NowX,dry=NowY; drx>=0 && dry<11; drx--,dry++){ if(Allpiece[drx][dry][0]==Allpiece[NowX][NowY][0]) N++; else break;}
  if(N-1>=5) return BW; else N=0;

  return 0;
}

void keyPressed(){
  //reset the checkerboard 
  if(key==ENTER){
    pieceN=0;
    gameOver=false;
    for(int i=0;i<11;i++)
      for(int j=0;j<11;j++)
        Allpiece[i][j][0]=0;
  }
}
