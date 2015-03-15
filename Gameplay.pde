
// main gameplay
void displayGameplay() {
  if (cam.available() == true) {
    displayFrame();
  }

  // time's up!
  if (prevMillis + timeToPose < millis()) {    
    // random feedback
    // (here so it doesn't change continuously)
    if (scorePercent < 10)                           feedback = bad[int(random(bad.length))];
    else if (scorePercent > 10 && scorePercent < 50) feedback = ok[int(random(ok.length))];
    else if (scorePercent > 10 && scorePercent < 90) feedback = good[int(random(good.length))];
    else                                             feedback = great[int(random(great.length))];
    
    // save the frame, if specified and above score threshold
    // saves to separate folders for each cat image
    if (saveFrames && scorePercent > saveFrameThreshold) {
      saveUnique(sketchPath("") + "CapturedFrames/" + target + "/", 8, "CatCapture", "_", ".jpg");
    }
    
    scoreScreen = true;
    prevMillis = millis();
  }
}


// update only when the camera has a new frame available
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
        pixels[i] = color(255, 0, 0);
        score -= 1;                        // lower score
        if (score < 0) score = 0;          // keep in usable range
      } else pixels[i] = color(255);    // otherwise white
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


