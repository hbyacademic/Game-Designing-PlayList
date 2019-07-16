class Brick{
  float brX;  //brickX  
  float brY;  //brickY
  float brW;  //brickWidth
  float brH;  //brickHeight
  color brC;  //brickColor
  int nbL;  //number of lives
  boolean shownNbL;  //shown the number of live or not

  Brick(float x,float y,float w,float h,int a,boolean shown){
    brX=x;  brY=y;  brW=w;  brH=h;  nbL=a;  shownNbL=shown;
  }
  
  void drawBrick(){ 
    if(nbL>0){
      fill(Color[nbL-1]);
      rect(brX,brY,brW,brH);
    }
    //fill(255);
    textAlign(CENTER,CENTER);
    textSize(width/20);
    if(shownNbL && nbL>0)  text(nbL,brX+brW/2,brY+brH/2);
  }
  
  boolean CollideWithBall(Ball b){
    if((b.bX+b.bR/2>brX) && (b.bX+b.bR/2<brX+brW) && (b.bY-b.bR>brY) && (b.bY-b.bR<brY+brH)){  //collide with the bottom of the brick
      b.sY=abs(b.sY);
      return true;  
    }
    else if((b.bX+b.bR/2>brX) && (b.bX+b.bR/2<brX+brW) && (b.bY+b.bR>brY) && (b.bY+b.bR<brY+brH)){  //collide the top of the brick
      b.sY=-abs(b.sY);
      return true;
    }
    if((b.bX+b.bR>brX) && (b.bX+b.bR<brX+brW) && (b.bY+b.bR/2>brY) && (b.bY-b.bR/2<brY+brH)){  //collide with thg left side of the brick
      b.sX=-abs(b.sX);
      return true;
    }
    else if((b.bX-b.bR>brX) && (b.bX-b.bR<brX+brW) && (b.bY+b.bR/2>brY) && (b.bY-b.bR/2<brY+brH)){  //collide with the right side of the brick
      b.sX=abs(b.sX);
      return true;
    } 
    return false; 
  }
  
  void movePaddle(){
    if(brX<5*strokeSize)  brX=5*strokeSize;
    else if(brX+brW>width-5*strokeSize)  brX=width-brW-5*strokeSize;
    if(brY<0)  brY=0;
    else if(brY+brH>height)  brY=height-brY;
  }
}
