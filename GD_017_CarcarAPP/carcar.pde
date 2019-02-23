class Car{
  float posx; //x pos of the car
  float posy; //y pos of the car
  float Wdir; //wheel direction
  float Cdir; //car direction
  float carW; //height of the car
  float carH; //height of the car
  
  Car(float carW, float carH){
    Wdir=PI/2;
    Cdir=PI/2;
    posx=width/2;
    posy=height/2;
    this.carW=carW;
    this.carH=carH;
  }
  
  void control(){
    backward=false;
    forward=false;
    
    //turn left 
    if(mousePressed && mouseX>=0 && mouseX<=height/5 && mouseY>=height-height/5 && mouseY<height){
      Wdir+=PI/180;
      //steering wheels can be turned to left
      //at most "tolerance" degrees
      if(Wdir>PI/2+tolerance){
        Wdir=PI/2+tolerance;
      }
    }
    
    //turn right
    else if(mousePressed && mouseX>=height/5 && mouseX<=2*height/5 && mouseY>=height-height/5 && mouseY<height){
      Wdir-=PI/180;
      //steering wheels can be turned to left
      //at most "tolerance" degrees
      if(Wdir<PI/2-tolerance){
        Wdir=PI/2-tolerance;
      }
    }
    
    //forward
    else if(mousePressed && mouseX>=width-2*height/5 && mouseX<=width-height/5 && mouseY>=height-height/5 && mouseY<height){
      posx+=2*cos(Cdir+(Wdir-PI/2));
      posy-=2*sin(Cdir+(Wdir-PI/2));
      Cdir+=(Wdir-PI/2)/100;
      forward=true;
    }   
    
    //backward
    else if(mousePressed && mouseX>=width-height/5 && mouseX<width && mouseY>=height-height/5 && mouseY<height){
      posx-=2*cos(Cdir+(Wdir-PI/2));
      posy+=2*sin(Cdir+(Wdir-PI/2));
      Cdir-=(Wdir-PI/2)/100;
      backward=true;
    }
    
    //reset
    else if(mousePressed && mouseX>=width-3*height/5 && mouseX<=width-2*height/5 && mouseY>=height-height/5 && mouseY<height){
      reset();
    }
    
    //golink
    else if(mousePressed && mouseX>=2*height/5 && mouseX<=3*height/5 && mouseY>=height-height/5 && mouseY<height){
      link("https://hbyacademic.github.io/HBY-academic/");
    }
  }
  
  void reset(){
    posx=width/2;
    posy=height/2;
    Cdir=PI/2;
    Wdir=PI/2;
  }
  
  void showLevel(){
    fill(0);
    textSize(height/8);
    if(level==8) level=7;
    text("Lv "+(level+1),width/2,height-height/5/2);
    if(finished)
      text("Finished \n All \n Levels",width/2,(height-height/5)/2);
  }
  
  void drawCar(){
    pushMatrix();
      fill(255);
      //view the car pos as the origin
      translate(posx,posy);
      //rotate the car according to car direction
      rotate(-(Cdir-PI/2));
      //draw car
      rect(0,0,carW,carH);
      //steering wheels
      drawWheel(-carW/2,-carH/4,true);
      drawWheel(carW/2,-carH/4,true); 
      //rear wheels
      drawWheel(-carW/2,carH/4,false);
      drawWheel(carW/2,carH/4,false);
      
      //headlights
      if(forward){
        fill(0,255,0);
        ellipse(-carW/2,-carH/2,carW/8,carW/8);
        ellipse(carW/2,-carH/2,carW/8,carW/8);
      }
      
      //backup lights
      if(backward){
        fill(255,0,0);
        ellipse(-carW/2,carH/2,carW/8,carW/8);
        ellipse(carW/2,carH/2,carW/8,carW/8);
      }              
    popMatrix();
  }
  
  void drawWheel(float x, float y,boolean IsFrontWheel){
    pushMatrix();
      fill(0);
      translate(x,y);
      //only steering wheels can be turned
      //rotate wheels according to wheel direction
      if(IsFrontWheel) rotate(-(Wdir-PI/2));
      rect(0,0,carW/4,carH/4);
    popMatrix();
  }
 
  //check if the point (x,y) is inside the rectangle 
  //where its upper left point is (ulX,ulY) and lower right point is (brX,brY)
  // --------
  // | *    |
  // |      |
  // --------  <- means the point "*" is inside the rectangle
  boolean isInside(float x, float y, float ulX, float ulY, float brX, float brY) {
    return (x >= ulX && x <= brX && y >= ulY && y <= brY);
  }
  
  //for bounded: check if the car is in collision with the borders
  //for level up: check if whole car is fully parked in the parking space
  boolean levelUpOrBounded(float x,float y,float w, float h, boolean bounded){
    float deg=Cdir-PI/2;
    //1,UM: upper middle
    //2,UMU: upper corner point of upper middle
    //3,UMB: lower corner point of upper middle
    //4,BM: bottom middle
    //5,UMU: upper corner point of bottom middle
    //6,UMB: lower corner point of bottom middle
    // 2---1---3
    // |       |
    // |       |
    // 5---4---6
    PVector UM,UMB,UMU,BM,BMB,BMU;
    if(deg>0){
      //UM=(UMU+UMB)/2
      UM=new PVector(posx-carH/2*sin(deg),posy-carH/2*cos(deg));
      UMB=new PVector(UM.x-carW/2*cos(deg),UM.y+carW/2*sin(deg));
      UMU=new PVector(UM.x+carW/2*cos(deg),UM.y-carW/2*sin(deg));
      
      //BM=(BMU+BMB)/2
      BM=new PVector(posx+carH/2*sin(deg),posy+carH/2*cos(deg));
      BMB=new PVector(BM.x-carW/2*cos(deg),BM.y+carW/2*sin(deg));
      BMU=new PVector(BM.x+carW/2*cos(deg),BM.y-carW/2*sin(deg));
    }
    
    else{
      deg*=-1;
      //UM=(UMU+UMB)/2
      UM=new PVector(posx+carH/2*sin(deg),posy-carH/2*cos(deg));
      UMB=new PVector(UM.x+carW/2*cos(deg),UM.y+carW/2*sin(deg));
      UMU=new PVector(UM.x-carW/2*cos(deg),UM.y-carW/2*sin(deg));
      
      //BM=(BMU+BMB)/2
      BM=new PVector(posx-carH/2*sin(deg),posy+carH/2*cos(deg));
      BMB=new PVector(BM.x+carW/2*cos(deg),BM.y+carW/2*sin(deg));
      BMU=new PVector(BM.x-carW/2*cos(deg),BM.y-carW/2*sin(deg));
    }
    
    //OR operation
    if(bounded){
      return isInside(UMB.x, UMB.y, x-w/2, y-h/2, x+w/2, y+h/2) ||
             isInside(UMU.x, UMU.y, x-w/2, y-h/2, x+w/2, y+h/2) ||
             isInside(BMB.x, BMB.y, x-w/2, y-h/2, x+w/2, y+h/2) ||
             isInside(BMU.x, BMU.y, x-w/2, y-h/2, x+w/2, y+h/2);

    }
    
    //AND operation
    else{
      return isInside(UMB.x, UMB.y, x-w/2, y-h/2, x+w/2, y+h/2) &&
             isInside(UMU.x, UMU.y, x-w/2, y-h/2, x+w/2, y+h/2) &&
             isInside(BMB.x, BMB.y, x-w/2, y-h/2, x+w/2, y+h/2) &&
             isInside(BMU.x, BMU.y, x-w/2, y-h/2, x+w/2, y+h/2);
    }
  }
}

Car car;
PImage u,d,l,r,logo,button;
float tolerance=PI/6; //max degree turn of steering wheels
static int level=0; //current level
boolean backward=false;
boolean forward=false;
boolean finished=false;

void setup(){
  fullScreen();
  orientation(LANDSCAPE);
  rectMode(CENTER);
  textAlign(CENTER);
  car= new Car(height/10*1.5,height/4*1.5);
  u=loadImage("up.png");
  d=loadImage("down.png");
  l=loadImage("left.png");
  r=loadImage("right.png");
  button=loadImage("button.png");
  logo=loadImage("logo.png");
  
  u.resize(height/5,height/5);
  d.resize(height/5,height/5);
  l.resize(height/5,height/5);
  r.resize(height/5,height/5);
  button.resize(height/5,height/5);
  logo.resize(height/5,height/5);
}

//float w=width,h=height; //width & height of fullscreen
//float [] X={h/4,w-h/4}; //x coord. of parking spaces 
//float [] Y={h/10,3*h/10,5*h/10,7*h/10}; //y coord. of parking spaces
//float W=h/2-10; //width of parking spaces
//float H=h/5; //height of parking spaces

void draw(){
  background(129);
  drawParkingSpace(level);
  loadArrowKey();
  
  if(!finished){
    car.control();
    car.drawCar();
  }
  //for level up
  //if(car.levelUpOrBounded(X[level>3?1:0],Y[level%4],W,H,false)){
  if(car.levelUpOrBounded(level>3?(width-height/4):(height/4),(2*(level%4)+1)*height/10,height/2-10,height/5,false)){
    level++;
    if(level==8) finished=true;
    car.reset();
  }
  
  //for border collision detection
  if(car.levelUpOrBounded(width/2,0,width,10,true) ||
     car.levelUpOrBounded(width/2,height-height/5,1280,10,true) ||
     car.levelUpOrBounded(0,height/2,10,height,true) ||
     car.levelUpOrBounded(width-1,height/2,10,height,true)
  ){
    car.reset();
  }
  car.showLevel();
}

void drawParkingSpace(int level){
  //all parking spaces
  noFill();
  strokeWeight(4);
  stroke(255);
  for(int i=0;i<8;i++)
    //rect(X[i>3?1:0],Y[i%4],W,H);
    rect(i>3?(width-height/4):(height/4),(2*(i%4)+1)*height/10,height/2-10,height/5); 
  
  //highlight the current parking space 
  stroke(255,255,0);
  strokeWeight(8);
  //rect(X[level>3?1:0],Y[level%4],W,H);
  rect(level>3?(width-height/4):(height/4),(2*(level%4)+1)*height/10,height/2-10,height/5);
  noStroke();
  
  //with the word "P" inside
  fill(255,255,0);
  textSize(height/5);
  textAlign(CENTER,CENTER);
  //text("P",X[level>3?1:0],Y[level%4]);
  text("P",level>3?(width-height/4):(height/4),(2*(level%4)+1)*height/10);
} 

void loadArrowKey(){
  //button control panel
  fill(191);
  rect(width/2,height-height/10,width-4*height/5,height/5);
  
  //control buttons
  image(l,0,height-height/5);
  image(r,height/5,height-height/5);
  image(logo,2*height/5,height-height/5);
  image(d,width-height/5,height-height/5);
  image(u,width-2*height/5,height-height/5);
  image(button,width-3*height/5,height-height/5);
}