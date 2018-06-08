import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
Movie myMovie;
int posy = 480;
int unit = 40;
int count;
PImage burbu;
Module[] mods;


class Module {
  int xOffset;
  int yOffset;
  float x, y;
  int unit;
  int xDirection = 5;
  int yDirection = -10;
  float speed; 
  
  // Contructor
  Module(int xOffsetTemp, int yOffsetTemp, int xTemp, int yTemp, float speedTemp, int tempUnit) {
    xOffset = xOffsetTemp;
    yOffset = yOffsetTemp;
    x = xTemp;
    y = yTemp;
    speed = speedTemp;
    unit = tempUnit;
  }
  
  // Custom method for updating the variables
  void update() {
    x = x + (speed * xDirection);
    if (x >= unit || x <= 0) {
      xDirection *= 1;
      x = 0 + (1 * xDirection);
      y = 10 + (1 * yDirection);
    }
    if (y >= unit || y <= 0) {
      yDirection *= -1;
      y = y + (1 * yDirection);
    }
  }
  
  // Custom method for drawing the object
  void display() {
    //noFill();
    //stroke(0,0,255);
    
    image(burbu,xOffset + x, yOffset + y, 20, 20);
  }
}


void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
 myMovie = new Movie(this, "azul.mp4");
myMovie.loop();
  video.start();
  
  int wideCount = width / unit;
  int highCount = height / unit;
  count = wideCount * highCount;
  mods = new Module[count];
  burbu = loadImage("burbuj.png");

  int index = 0;
  for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {
      mods[index++] = new Module(x*unit, y*unit, unit/2, unit/2, random(0.05, 0.8), unit);
    }
  }
  
}



void draw() {
  
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );
tint(255, 100);
  image(myMovie,0,0);
  noFill();
  noStroke();
  //strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    if(faces[i].x < 200){
     
    }
    for (Module mod : mods) {
    mod.update();
    mod.display();
  }
  }
}

//void burbujas(){
   
//noFill();
//stroke(0);
//ellipse(100,100,10,10);
//posy-=10;
//}

void captureEvent(Capture c) {
  c.read();
}

void movieEvent(Movie m) {
  m.read();
}