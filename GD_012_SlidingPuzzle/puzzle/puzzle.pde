PImage [] img = new PImage[12];
import java.util.Collections;
ArrayList<Integer>rand = new ArrayList<Integer>();

int row[]={0,1,2,0,1,2,0,1,2};
int col[]={0,0,0,1,1,1,2,2,2};
int step=0,white,start,init;
boolean lock=false, play=false;

void setup()
{
  background(128);  
  size(960,630);
  
  //load images
  for(int i=0;i<9;i++)  
    img[i]=loadImage((i+1)+".bmp");
  img[9]=loadImage("new.png");
  img[10]=loadImage("play.png");
  img[11]=loadImage("exit.png");
  
  
  
  /**/
  Collections.swap(rand,0,3);
}

void draw()
{
  //cover with a color rectangle, so that it can refresh the texts on screen
  noStroke();
  fill(128);
  rect(0,0,960,630);
   
  //text
  PFont font;
  font = createFont("Calibri", 64);
  textFont(font);
  fill(0);
  text(" 3x3 Sliding Puzzle Game ",150, 100);
  text("Moves: "+step,150,550);
  
  //check if it's solved
  int j;
  boolean solved=false;
  for(j=0;j<9;j++)
  {
    if(rand.get(j)!=j) break;
  }
  if(j>8) solved=true;
  
  if(solved && play)
  {
    //so that any subpuzzle cannot be moved UP/DOWN/LEFT/RIGHT
    lock=true;
    println("solved");
  }
  
  //if game starts & it is not solved, then time starts now
  if(play && !solved)
    start=millis();

  //convert millisecond into second/minute/hour
  int second=((start-init)/1000)%60;  //l000 millisec = 1 sec 
  int minute=((start-init)/(1000*60))%60; //1000*60 millisec = 1 min
  int hour=((start-init)/(1000*60*60))%24; //1000*60*60 millisec = 1 hour
  text("Time: "+hour+":"+minute+":"+second,500,550);

  //show all the subpuzzles (9 subpuzzles)
  int Swidth=width/6, Sheight=height/6;
  for(int i=0;i<9;i++)
    image(img[rand.get(i)],row[i]*Swidth+240,col[i]*Sheight+150,Swidth-8,Sheight-8);
 
  //find the position of white subpuzzle(whose index=0)
  for(int i=0;i<9;i++)
    if(rand.get(i)==0) white=i;
  
  image(img[9],750,205);   //NEW button
  image(img[10],750,275);  //PLAY button
  image(img[11],750,345);  //EXIT button
}

void keyPressed()
{
  int idx=0;
  boolean flag=false;
  
  /****UP****/    /***DOWN***/
  //x12    312    //312    x12
  //345 => x45    //x45 => 345
  //678    678    //678    678 
  
  /***LEFT***/    /***RIGHT**/
  //312    312    //312    312
  //4x5 => 45x    //45x => 4x5
  //678    678    //678    678
  
  if(key==CODED){
    //count the steps taken
    if(play) step++;
    
    if(keyCode==UP && (!lock)){
      //some cases where none of the subpuzzles cannot be move up
      if(white==6 || white==7 || white==8){ step--; flag=true;}
      idx=(flag)?white:white+3;
    }
   
    else if(keyCode==DOWN && (!lock)){
      //some cases where none of the subpuzzles cannot be move down
      if(white==0 || white==1 || white==2){ step--; flag=true;}
      idx=(flag)?white:white-3;
    }
    else if(keyCode==LEFT && (!lock)){
      //some cases where none of the subpuzzles cannot be move left
      if(white==2 || white==5 || white==8){ step--; flag=true;}
      idx=(flag)?white:white+1;
    }
    else if(keyCode==RIGHT && (!lock)){
      //some cases where none of the subpuzzles cannot be move right
      if(white==0 || white==3 || white==6){step--; flag=true;}
      idx=(flag)?white:white-1; 
    }
    
    //swap the white subpuzzle with the chosen subpuzzle
    Collections.swap(rand,white,idx);   
  }
}

void mousePressed()
{
  int inversion=0; 
  if(mouseButton==LEFT){
    
    //count the time that has passed until mouse is Pressed
    init=millis();
    
    //press the NEW button
    if(mouseX>=750 && mouseX<850 && mouseY>=205 && mouseY<260){
      
      //always show the time "0:0:0" in NEW mode
      init=start;
      lock=false;
      play=false;
      
      do{
        //shuffle
        Collections.shuffle(rand);
        
        //find the # of inversions
        for(int i=0;i<9;i++)
          for(int j=i+1;j<9;j++){
            if(rand.get(i)>rand.get(j))  inversion++;
         }
        //check if solvable
      }while(inversion%2==1); 
      println("pressed NEW button");
    }
   
    //press the PLAY button
    if(mouseX>=750 && mouseX<850 && mouseY>=275 && mouseY<330){
      //reset the step when game starts
      step=0;
      play=true;
      println("pressed PLAY button");
    }
    
    //press the EXIT button
    if(mouseX>=750 && mouseX<850 && mouseY>=345 && mouseY<400){
      play=false;
      println("pressed EXIT button");
      exit();
    } 
  }
}
