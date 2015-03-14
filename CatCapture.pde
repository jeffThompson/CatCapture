
import processing.video.*;

/*
CAT CAPTURE
Jeff Thompson | 2015 | www.jeffreythompson.org

Match your body to the cat shapes, score points, be happy.

*/

float thresh =       110;
int numCats =        10;

long timeToPose =    12 * 1000;  // in ms
long timeToStart =   7 * 1000;
long timeForScore =  5 * 1000;

boolean introScreen = true;
boolean scoreScreen = false;

PImage[] cats;
int target;
Capture cam;
PFont font;
long prevMillis;
float scorePercent;


void setup() {
  size(1280, 720);

  // font
  font = loadFont("AvenirNext-Bold-72.vlw");
  textFont(font, 72);

  // load all cats, pick a random target
  cats = new PImage[numCats];
  for (int i=0; i<numCats; i++) {
    cats[i] = loadImage("Cats/" + i + ".jpg");
  }
  target = int(random(0, cats.length));

  // start camera connection
  String[] cameras = Capture.list();
  if (cameras == null) {
    cam = new Capture(this, 1280, 720);
  }
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }
  cam = new Capture(this, cameras[0]);
  cam.start();

  // set timer for start screen
  prevMillis = millis();
}

void draw() {
  // intro
  if (introScreen) {
    background(255, 0, 0);
    textAlign(CENTER);
    fill(0);
    noStroke();
    textFont(font, 72);
    text("MATCH THE CAT", width/2, height/2);

    // when does start screen end?
    long timeLeft = ((prevMillis + timeToStart) - millis()) / 1000;
    textFont(font, 24);
    text("Starting in " + timeLeft + " seconds...", width/2, height/2 + 80);

    // times up, start playing!
    if (prevMillis + timeToStart < millis()) {
      introScreen = false;
      prevMillis = millis();
    }
  }

  // score of previous round
  else if (scoreScreen) {
    background(255, 0, 0);
    textAlign(CENTER);
    fill(0);
    noStroke();
    
    // how did we do?
    textFont(font, 24);
    String feedback = "Meee-ow!";
    if (scorePercent < 10) feedback = "Hiss!";
    else if (scorePercent > 10 && scorePercent < 50) feedback = "[um, whatever]";
    else if (scorePercent > 50 && scorePercent < 80) feedback = "Purrrrr...";
    text(feedback, width/2, height/2 - 80);
    
    textFont(font, 72);
    text(nf(scorePercent, 0, 2) + "%", width/2, height/2);

    long timeLeft = ((prevMillis + timeToPose) - millis()) / 1000;  
    text("Next cat in " + timeLeft + " sec...", width/2, height/2 + 80);

    // time to play again?
    if (prevMillis + timeForScore < millis()) {
      prevMillis = millis();
      scoreScreen = false;
      
      // get harder, reset
      if (timeToPose >= 3000) timeToPose -= 1000;  // less 1-sec
      else timeToPose = 12 * 1000;
      
      // never the same cat twice
      int newTarget = int(random(0, cats.length));
      while (newTarget == target) {
        newTarget = int(random(0, cats.length));
      }
      target = newTarget;
    }
  }

  // regular gameplay
  else {
    if (cam.available() == true) {
      displayFrame();
    }
    
    // time's up!
    if (prevMillis + timeToPose < millis()) {
      scoreScreen = true;
      prevMillis = millis();
    }
  }
}


void displayFrame() {
  float score =    0;
  float maxScore = 0;
  
  // get frame from camera, flip horizontally
  cam.read();
  cam.loadPixels();
  PImage frame = createImage(cam.width, cam.height, RGB);
  frame.loadPixels();
  for (int x=0; x<cam.width; x++) {
    for (int y=0; y<cam.height; y++) {
      frame.pixels[y * cam.width + x] = cam.pixels[(cam.width - x - 1) + y*cam.width];
    }
  }
  frame.updatePixels();
  
  // draw the target cat
  image(cats[target], 0, 0, width, height);

  // capture!
  loadPixels();
  frame.loadPixels();
  for (int i=0; i<frame.pixels.length; i++) {
    float camR = frame.pixels[i] >> 16 & 0xFF;
    float targetR = pixels[i] >> 16 & 0xFF;

    if (targetR < 240) maxScore++;

    // if in shape (dark)
    if (targetR < 240) {
      if (camR < thresh) {    // dark areas = black, score up
        pixels[i] = color(0);
        score++;
      } else {
        // nothing (show original px)
      }
    }

    // not in shape (light)
    else {        
      if (camR < thresh) {                 // dark areas = red
        pixels[i] = color(255,0,0);
        score -= 1;                        // lower score
        if (score < 0) score = 0;          // keep in usable range
      }
      else pixels[i] = color(255);    // otherwise white
    }
  }
  updatePixels();

  // calculate the score 0 (bad) - 100 (good)
  // display
  scorePercent = ((score/maxScore) * 100);
  fill(0);
  noStroke();
  textAlign(LEFT);
  textFont(font, 72);
  text(nf(scorePercent, 0, 2) + "%", 40, 100);

  // time left to capture
  textFont(font, 36);
  long timeLeft = ((prevMillis + timeToPose) - millis()) / 1000;
  text(timeLeft + " sec left", 40, 150);
}

