
// use up/down arrow keys to adjust threshold
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      thresh += 1;
      if (thresh > 255) thresh = 255;
      println("Background threshold: " + thresh);
    }
    else if (keyCode == DOWN) {
      thresh -= 1;
      if (thresh < 0) thresh = 0;
      println("Background threshold: " + thresh);
    }
  }
}


