import processing.core.*;
import processing.video.*;

class Camera {
  PApplet parent;
  Capture video;
  
  // A variable for the color we are searching for.
  color trackColor = color(255,0,0); // Red
  int threshold = 20;
  
  // Constructor for camera
  // x and y define the size of the camera display
  Camera(PApplet parent, int x, int y) { 
    this.parent = parent;
    println(Capture.list());
    // FaceTime HD Camera USB Camera VID:1133 PID:2077 OBS Virtual Camera
    video = new Capture(parent, x, y, "USB Camera VID:1133 PID:2077");
    video.start();
  }
  
  void update(){
    if (video.available()) {
      video.read();
    }
    colorTrack();

    pushMatrix();
    scale(-1,1);
    image(video, video.width, parent.height-video.height); // Where is the camera
    popMatrix();
  }
  
  // Save color where the mouse is clicked in trackColor variable
  void mousePressed() {
    int loc = mouseX + mouseY*video.width;
    trackColor = video.pixels[loc];
  }

  void colorTrack(){
    video.loadPixels();

    // X and Y coordinates of closest color
    float avgX = 0;
    float avgY = 0;
    
    int count = 0; 

    // Begin loop to walk through every pixel
    for (int x = 0; x < video.width; x++ ) {
      for (int y = 0; y < video.height; y++ ) {
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

    // We only consider the color is found if its color distance is less than 10. 
    if (count > 0) {
      avgX /= count;
      avgY /= count;

      // Draw a small circle at the tracked pixel
      fill(trackColor);
      strokeWeight(4.0);
      stroke(0);
      ellipse(avgX, avgY, 16, 16);
    }
  }
}
