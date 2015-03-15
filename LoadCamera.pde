
// start camera connection
void loadCamera() {
  String[] cameras = Capture.list();
  if (cameras == null) {
    cam = new Capture(this, 1280, 720);
  }
  if (cameras.length == 0) {
    cameraError = true;
  }

  // list cameras (for setup and debugging)
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }
  cam = new Capture(this, cameras[0]);
  cam.start();
  
  // all set?
  cameraLoaded = true;
  prevMillis = millis();
}
