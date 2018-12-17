//declare N-elements array for reading image
PImage [] img = new PImage [9];

int width=300, height=199;
void setup()
{
  //white color background
  background(255);
  
  //the size of the canvas
  //957=300*3+57
  size(1000,199);
  
  //reading N images 
  for(int i=0;i<7;i++) img[i] = loadImage((i+1)+".png");
  img[7] = loadImage("lever.png"); 
  img[8] = loadImage("stop.png");
}

//array for three different reels
//y => the y position of an image
//acc_y => the speedup for scrolling down an image 
int y[]={0,0,0}, acc_y[]={0,0,0}, idx[]={0,0,0};
int stop_button=0;

void draw(){

  //image(an image, its x coordinate, its y coordinate)
  //the value of "x" increases from left to right
  //the value of "y" increases from top to bottom
  
  //load the lever & stop button to the canvas
  image(img[7],900,0); //lever
  image(img[8],921,154); //stop
  
  //3 reels (also you can design more deels)
  for(int i=0; i<3; i++)
  {
    //show two images on the canvas
    image(img[(idx[i])%7], i*width, y[i]);
    image(img[(idx[i]+1)%7], i*width, -height+y[i]);
    
    //scroll down with speeds
    y[i]+=acc_y[i];
    
    //if an image was moved to the bottom of the canvas
    if(y[i]>height)
    {
      //set the image to the initial position
      y[i]=0;   
      //prepare the next image
      idx[i]++; 
      //if the user press the stop button, then all the reels will reduce the speed
      if(stop_button==1 && acc_y[i]>0) acc_y[i]--; //a decreased value
    }
   }
   pressed();
}

void pressed()
{
   if(mousePressed && mouseButton == LEFT)
   {
     //pressed the lever => all the reels will spin in random speed 
     if(mouseX>900 && mouseX<957 && mouseY>0 && mouseY<50)
     {
       stop_button=0;
       println("pressed the lever\n");
       for(int i=0; i<3; i++) 
         acc_y[i]+=random(10); //random number
         //acc_y[i]+=1; //constant number
     }
     //pressed the stop button
     else if(mouseX>920 && mouseX<977 && mouseY>154 && mouseY<179)
     {
       println("pressed the stop button\n");
       stop_button = 1;
     }  
   }
}
