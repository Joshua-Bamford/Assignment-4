PVector redPosition;
PVector redSpeed;
PVector redAcceleration;

class Player1 {
  
  Player1() {
    redPosition = new PVector(width/2, 700);
    redSpeed = new PVector(0, 0);
    redAcceleration = new PVector(0, 0);
  }
  
  void display() {
   
    
    redStone.resize(100, 100);
    image(redStone, redPosition.x-50, redPosition.y-50);  //draws the curling stone sprite according to the current position. -50 is because the image draw mode is CORNERS
  }
}
