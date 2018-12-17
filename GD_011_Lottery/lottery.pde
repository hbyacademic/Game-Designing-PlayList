PImage lottery,num,jackpot;

void setup()
{  
  //white background
  background(255); 
  
  //the size of the canvas
  size(960,640);
  
  //load images
  lottery=loadImage("lottery.bmp");
  num=loadImage("your.png");  
  jackpot=loadImage("jackpot.png");
}

void draw()
{
  image(lottery,0,0);
}

void mouseDragged()
{
  //load all the pixels of each input image into corresponding array xxx.pixels[]
  lottery.loadPixels();
  jackpot.loadPixels();
  num.loadPixels();

  //the region when user scratched off the lottery ticket
  int offset=5;
  
  //jackpot numbers (upper left point (x,y)=(10,520); lower right point (x,y)=(459,594))
  if(mouseY>=520 && mouseY<595 && mouseX>=10 && mouseX<460)
  {
    for(int dx=-offset;dx<=offset;dx++)
      for(int dy=-offset;dy<=offset;dy++)
      {
        //not to consider the pixel(s) which is out of range
        if(mouseX+dx<10 || mouseX+dx>=460 || mouseY+dy<520 || mouseY+dy>=595) continue;
        //copy the "jackpot.png" to "lottery.bmp"
        lottery.pixels[(mouseY+dy)*lottery.width+(mouseX+dx)]=jackpot.pixels[(mouseY-520+dy)*jackpot.width+(mouseX-10+dx)];
      }
  }
  
  //your numbers (upper left point (x,y)=(500,520); lower right point (x,y)=(949,594))
  if(mouseY>=520 && mouseY<595 && mouseX>=500 && mouseX<950)
  {
    for(int dx=-offset;dx<=offset;dx++)
      for(int dy=-offset;dy<=offset;dy++)
      {
        //not to consider the pixel(s) which is out of range
        if(mouseX+dx<500 || mouseX+dx>=950 || mouseY+dy<520 || mouseY+dy>=595) continue;
        //copy the "num.png" to "lottery.bmp"
        lottery.pixels[(mouseY+dy)*lottery.width+(mouseX+dx)]=num.pixels[(mouseY-520+dy)*num.width+(mouseX-500+dx)];
      }
  }

  //update the pixels of lottery
  lottery.updatePixels(); 
}
