
import processing.video.*;

/*
CAT CAPTURE
 Jeff Thompson | 2015 | www.jeffreythompson.org
 
 Match your body to the cat shapes, score points, be happy.
 
 SETUP:
 +  Have your camera face a white background with no clutter
 +  Your body should appear as a dark silhouette
 +  Use the up/down arrow keys to adjust the contrast if necessary
 
 TO DO:
 +   Why does the frame blank when the camera loads?
 
 */

float thresh =             110;        // ignore white background
boolean saveFrames =       true;       // save frames of people trying?
float saveFrameThreshold = 20;         // at what % score to save frames?

long timeToPose =    12 * 1000;  // time before pose is captured, in ms
long timeToStart =   7 * 1000;   // (note 7 really shows up closer to 5 sec)
long timeForScore =  7 * 1000;

boolean introScreen =  true;     // start on intro screen
boolean scoreScreen =  false;

boolean cameraError =  false;    // did we have a problem loading the camera?
boolean cameraLoaded = false;

String[] bad =   { "Hiss!", "Boo...", "[ gato turds ]", "Bad kitty!", "[ scratching up the couch ]", "[ hairball ]" };
String[] ok =    { "[ um, whatever ]", "[ unhappily swishing tail ]", "Just ok." };
String[] good =  { "Prrr...", "Pretty good!", "Good little kitty." };
String[] great = { "Mee-ow!", "Excellent!", "[ can opener sound ]" };

PImage[] cats;        // array of cat images
int target;           // which one to display?
Capture cam;          // webcam
PFont font;           // score, instructions, etc
long prevMillis;      // keep track of time
float scorePercent;   // how did we do?
String feedback;      // randomized feedback text


void setup() {
  size(1280, 720);
  frame.setTitle("Cat Capture");
  font = loadFont("AvenirNext-Bold-144.vlw");

  // get a list of all cat files
  // load into array, pick a random target
  String[] catFiles = new File(sketchPath("") + "Cats").list();
  cats = new PImage[catFiles.length];
  for (int i=0; i<catFiles.length; i++) {
    cats[i] = loadImage(sketchPath("") + "Cats/" + catFiles[i]);
  }
  target = int(random(0, cats.length));
}


void draw() {

  // problems with the camera? display an error
  if (cameraError) {
    displayCameraError();
  }

  // otherwise, show game
  else {
    if (introScreen) {
      displayIntro();
      if (!cameraLoaded && frameCount > 1) loadCamera();
    } 
    else if (scoreScreen) {
      displayScore();
    }
    else {
      displayGameplay();
    }
  }
}


