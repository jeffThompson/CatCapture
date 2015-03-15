
// screen to display score
void displayScore() {
  background(255, 0, 0);
  textAlign(CENTER);
  fill(0);
  noStroke();

  // give random feedback words
  // (chosen when going from play to score screen)
  textFont(font, 36);
  text(feedback, width/2, height/2 - 140);

  // show score itself
  textFont(font, 130);
  text(nf(scorePercent, 0, 2) + "%", width/2, height/2);

  // how much time until we start again?
  long timeLeft = ((prevMillis + timeForScore) - millis()) / 1000;
  textFont(font, 24);
  text("Next cat in " + timeLeft + " sec...", width/2, height/2 + 140);

  // time to play again?
  if (prevMillis + timeForScore < millis()) {
    prevMillis = millis();
    scoreScreen = false;

    // get harder, reset
    // less 1-sec each time
    if (timeToPose >= 3000) timeToPose -= 1000;
    else timeToPose = 12 * 1000;

    // never the same cat twice
    int newTarget = int(random(0, cats.length));
    while (newTarget == target) {
      newTarget = int(random(0, cats.length));
    }
    target = newTarget;
  }
}


