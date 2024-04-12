import processing.core.*;
import processing.video.*;

class Camera{
  
  PApplet parent;
  //video
  Capture video;
  
  // A variable for the color we are searching for.
  color trackColor = color(255,0,0); //red
  int threshold = 20;

  
  Camera(PApplet parent, int x, int y){ //how big is the camera?
    this.parent = parent;
    println(Capture.list());
    //FaceTime HD Camera USB Camera VID:1133 PID:2077 OBS Virtual Camera
    video = new Capture(parent, x, y, "USB Camera VID:1133 PID:2077");
    //video = new Capture(parent, Capture.list()[0], x, y);
    video.start();
  }
  
  void update(){
      if (video.available()){
        video.read();

      }

//     image(video, parent.width-100, parent.width-100);
     colorTrack();
    //tint(255, mouseY, mouseY);
    pushMatrix();
      scale(-1,1);
      image(video, -video.width, parent.height-video.height); //where is the camera?
    popMatrix();

}
  
  void mousePressed() {
  // Save color where the mouse is cliccked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}

void colorTrack(){
  video.loadPixels();
  //image(video, 0, 0);

  // XY coordinate of closest color
  float avgX = 0;
  float avgY = 0;
  
  int count = 0; 

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      
      // What is current color
      color currentColor = video.pixels[loc];
      
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      if (d < threshold) {
        avgX += x;
        avgY = y;
        count++;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) {
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(avgX, avgY, 16, 16);
  }
}


}
