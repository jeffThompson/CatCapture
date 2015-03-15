
// intro screen
void displayIntro() {
  background(255, 0, 0);
  textAlign(CENTER);
  fill(0);
  noStroke();
  textFont(font, 72);
  text("MATCH THE CAT", width/2, height/2);
  
  textFont(font, 24);
  text("Move your body to match the shape of the cats!", width/2, height/2 + 60);
  
  // let us know the camera is loading
  if (!cameraLoaded) {
    textFont(font, 18);
    text("Loading camera...", width/2, height/2 + 140);
  }
  
  // when does start screen end?
  else {
    long timeLeft = ((prevMillis + timeToStart) - millis()) / 1000;
    textFont(font, 18);
    text("Starting in " + timeLeft + " seconds...", width/2, height/2 + 140);

    // time's up, start playing!
    if (prevMillis + timeToStart < millis()) {
      introScreen = false;
      prevMillis = millis();
    }
  }
}


