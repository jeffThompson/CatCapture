
// screen to display score
void displayScore() {
  background(255, 0, 0);
  textAlign(CENTER);
  fill(0);
  noStroke();

  // how did we do?
  textFont(font, 36);
  String feedback = "Meee-ow!";
  if (scorePercent < 10) feedback = "Hiss!";
  else if (scorePercent > 10 && scorePercent < 50) feedback = "[um, whatever]";
  else if (scorePercent > 50 && scorePercent < 80) feedback = "Purrrrr...";
  text(feedback, width/2, height/2 - 120);

  textFont(font, 130);
  text(nf(scorePercent, 0, 2) + "%", width/2, height/2);

  long timeLeft = ((prevMillis + timeToPose) - millis()) / 1000;
  if (timeLeft < 0) timeLeft = 0;                                  // a hack :(
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

