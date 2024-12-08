Player1 p1Stone;

PVector targetPosition;
PImage redStone;
PImage blueStone;
int potentialEnergy = 0;  //used as a counter in keyPressed to store how long the stick is held down
int resistance = 0;  //affects acceleration and therefore speed
boolean stoneFired = false;

void setup() {
  size(1280, 1024);
  ellipseMode(CENTER);
  rectMode(CORNER);
  redStone = loadImage("curling_stone_red.png");
  blueStone = loadImage("curling_stone_blue.png");
  targetPosition = new PVector(640, -1536);
  p1Stone = new Player1();  //just a test instance of the player object, move to conditional in draw once ready
}

void draw() {
  println(targetPosition.y, redPosition.y, redSpeed.y, redAcceleration.y, potentialEnergy);  //monitoring for movement fine-tuning
  noStroke();
  iceRink();
  fill(255, 0, 0);
  rect(1200, 500, 50, (potentialEnergy*5));  //slide power indicater on right side

  redAcceleration.y = redAcceleration.y - resistance;
  redSpeed.y += -(redAcceleration.y);
  redPosition.y = constrain(redPosition.y, 100, 900) + redSpeed.y;  //add current speed to the position value. position is constrained to within the screen's bounds but the speed value will still be in effect
  if (stoneFired == true && redSpeed.y == 0) {
    redAcceleration.y = 0;
    resistance = 0;
  }

  if (redPosition.y <= 100) {  //when the curling stone reaches beyond the constraints of its movement, the speed that it has carries over inversely into the target movement
    targetPosition.y = constrain(targetPosition.y, -2000, 900) - redSpeed.y;
  }
  p1Stone.display();  //here temporarily, must store inside conditional once two player is implemeted
  
}

void iceRink() {
  background(24, 74, 222);  //blue edges beside the ice

  fill(255);
  rect(100, -2036, 1080, 3060);  //this is the ice surface, its Y position moves while X remains constant

  fill(0, 102, 255);
  ellipse(targetPosition.x, targetPosition.y, 700, 700);
  fill(255);
  ellipse(targetPosition.x, targetPosition.y, 500, 500);
  fill(227, 32, 32);
  ellipse(targetPosition.x, targetPosition.y, 300, 300);  //the sample target
  fill(255);
  ellipse(targetPosition.x, targetPosition.y, 100, 100);
}

void keyPressed() {
  if (key == 's') {
    potentialEnergy++;  //as long as the key is pulled back, the slide power indicator will grow
  }
  
  if(key == 'a' && stoneFired == false) {  //player can move horizontal position of stone before firing
   redPosition.x -= 2;
  }
  if(key == 'd' && stoneFired == false) {
   redPosition.x += 2;
  }
}

void keyReleased() {
  if (key == 's' && potentialEnergy > 0) {
    redAcceleration.y = potentialEnergy;  //DO NOT DIVIDE POTENTIAL ENERGY BY ANYTHING, MAY CAUSE UNEXPECTED ACCELERATION
    potentialEnergy = 0;
    resistance = 1;
    stoneFired = true;
  }
}
