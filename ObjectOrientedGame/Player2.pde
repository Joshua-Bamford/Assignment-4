PVector bluePosition;
PVector blueSpeed;
PVector blueAcceleration;

class Player2 {
  
  Player2() {
    bluePosition = new PVector(width/2, 700);
    blueSpeed = new PVector(0, 0);
    blueAcceleration = new PVector(0, 0);
  }
  
  void display() {
   
    
    blueStone.resize(100, 100);
    image(blueStone, bluePosition.x-50, bluePosition.y-50);  //draws the curling stone sprite according to the current position. -50 is because the image draw mode is CORNERS
  }
}
