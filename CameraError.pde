
// problem opening the camera?
void displayCameraError() {
  background(255, 0, 0);
  textAlign(CENTER);
  fill(0);
  noStroke();
  textFont(font, 72);
  text("ERROR: NO CAMERA FOUND", width/2, height/2);
  textFont(font, 24);
  text("Sorry!", width/2, height/2 + 80);
}
