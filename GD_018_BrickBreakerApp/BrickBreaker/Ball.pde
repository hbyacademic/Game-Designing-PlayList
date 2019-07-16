class Ball{
  float bX;  //ballX
  float bY;  //ballY
  float bR;  //ballRadius
  float sX=-5; //speedX
  float sY=random(10+level,10+level+2);  //speedY
  color bC;  //ballColor
  
  Ball(float x,float y,float r,color c){
    bX=x;  bY=y;  bR=r;  bC=c;
  }
  
  void drawBall(){
    fill(bC);
    noStroke();
    ellipse(bX,bY,bR*2,bR*2);
  }
  
  void update(){
    bX+=sX;  bY+=sY;
  }
  
  void reset(){
    bX=width/2; bY=height/1.5;
    sX=-5;  
    sY=random(10+level,10+level+2);
  }
  
  void resetSize(){
    bR=ballRadius;
  }
  
  boolean CollideWithWall(){
    if(bX<bR+3*strokeSize){  //left border
      sX=abs(sX);
    }
    else if(bX>width-bR-3*strokeSize){  //right border
      sX=-abs(sX);
    }
    else if(bY<bR+borderY+strokeSize){  //top border
      sY=abs(sY);
    }
    else if(bY>height-bR){  //bottom border
      sY=-abs(sY);
      return true;
    }
    return false;
  }
  
  void drawAnimatedBall(){
    if(!pause) update();
    drawBall();
    if(CollideWithWall()){
      updateScore(false);
      reset();
      resetSize();
    }
  }
}