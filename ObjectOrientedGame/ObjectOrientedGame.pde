Player1[] p1Stone = new Player1[2];
Player2[] p2Stone = new Player2[2];

PVector targetPosition;
PImage redStone;
PImage blueStone;
PImage scoreboard;
PImage p1Turn;
PImage p2Turn;
int currentTurn = 1;  //player 1 always starts off first
int potentialEnergy = 0;  //used as a counter in keyPressed to store how long the stick is held down
int resistance = 0;  //affects acceleration and therefore speed
boolean stoneFired = false;
boolean secondShot1 = false;
boolean secondShot2 = false;

void setup() {
  size(1280, 1024);
  ellipseMode(CENTER);
  rectMode(CORNER);
  redStone = loadImage("curling_stone_red.png");
  blueStone = loadImage("curling_stone_blue.png");
  scoreboard = loadImage("scoreboard.png");
  p1Turn = loadImage("p1_turn.png");
  p2Turn = loadImage("p2_turn.png");
  targetPosition = new PVector(640, -1536);
}

void draw() {
  frameRate(60);
  noStroke();
  iceRink();
  fill(255, 0, 0);
  rect(1200, 500, 50, (potentialEnergy*5));  //slide power indicater on right side

  scoreboard.resize(360, 120);
  image(scoreboard, 20, 20);

  if (currentTurn == 1) {    //player 1's turn
   if(p1Stone[0] == null) {
     p1Stone[0] = new Player1();  //adds a new instance of the Player 1 stone
     targetPosition.set(640, -1536);
   }
   else if(secondShot1 == true) {
      p1Stone[1] = new Player1();  //adds a new instance of the Player 1 stone
     targetPosition.set(640, -1536);
     secondShot1 = false;
   }
    
    fill(240, 32, 32);        //this block is for the top right indicator for how many shots were taken
    rect(1080, 20, 180, 120);
    p1Turn.resize(180, 120);
    image(p1Turn, 1080, 20);
    if(secondShot1 == true) {
      fill(255, 247, 0);
      ellipse(1090, 100, 50, 50);
    }
    
    redAcceleration.y = redAcceleration.y - resistance;
    redSpeed.y += -(redAcceleration.y);  //add value of acceleration to speed every frame. Value is inverse so that it goes forwards rather than backwards
    redPosition.y = constrain(redPosition.y, 100, 900) + redSpeed.y;  //add current speed to the position value. position is constrained to within the screen's bounds but the speed value will still be in effect

    if (stoneFired == true && redSpeed.y == 0) {
      redAcceleration.y = 0;  //ensures that if the speed reaches 0, the curling stone stops rather than going to negative values and accelerating backwards
      resistance = 0;
      delay(3000);  //gives the player a chance to see exactly where it landed before switching turns
      currentTurn = 2;
      stoneFired = false;
      secondShot1 = true;
    }

    if (redPosition.y <= 100) {  //when the curling stone reaches beyond the constraints of its movement, the speed that it has carries over inversely into the target movement
      targetPosition.y = constrain(targetPosition.y, -2000, 900) - redSpeed.y;
    }
    
 p1Stone[0].display();
 if(p1Stone[1] != null) {
    p1Stone[1].display();
 }
     println(targetPosition.y, redPosition.y, redSpeed.y, redAcceleration.y, potentialEnergy);  //monitoring for movement fine-tuning
  }
  
  
  
  if (currentTurn == 2) {    //player 2's turn
   if(p2Stone[0] == null) {
         p2Stone[0] = new Player2();  //adds a new instance of the Player 1 stone
     targetPosition.set(640, -1536);
   }
   else if(secondShot2 == true) {
      p2Stone[1] = new Player2();  //adds a new instance of the Player 1 stone
     targetPosition.set(640, -1536);
     secondShot2 = false;
   }
    
    fill(32, 32, 240);        //this block is for the top right indicator for how many shots were taken
    rect(1080, 20, 180, 120);
    p2Turn.resize(180, 120);
    image(p2Turn, 1080, 20);
    
    blueAcceleration.y = blueAcceleration.y - resistance;
    blueSpeed.y += -(blueAcceleration.y);  //add value of acceleration to speed every frame. Value is inverse so that it goes forwards rather than backwards
    bluePosition.y = constrain(bluePosition.y, 100, 900) + blueSpeed.y;  //add current speed to the position value. position is constrained to within the screen's bounds but the speed value will still be in effect

    if (stoneFired == true && blueSpeed.y == 0) {
      blueAcceleration.y = 0;  //ensures that if the speed reaches 0, the curling stone stops rather than going to negative values and accelerating backwards
      resistance = 0;
      delay(3000);  //gives the player a chance to see exactly where it landed before switching turns
      currentTurn = 1;
      stoneFired = false;
      secondShot2 = true;
    }

    if (bluePosition.y <= 100) {  //when the curling stone reaches beyond the constraints of its movement, the speed that it has carries over inversely into the target movement
      targetPosition.y = constrain(targetPosition.y, -2000, 900) - blueSpeed.y;
    }
    
     p2Stone[0].display();
 if(p2Stone[1] != null) {
    p2Stone[1].display();
 }
 
     println(targetPosition.y, bluePosition.y, blueSpeed.y, blueAcceleration.y, potentialEnergy);  //monitoring for movement fine-tuning
  }
  
  if(secondShot1 == true && secondShot2 == true) {
    println("game over");
    gameOver();
  }
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

void gameOver() {
  frameRate(1);
  float p1DistanceFromTarget = dist(targetPosition.x, targetPosition.y, redPosition.x, redPosition.y);
  float p2DistanceFromTarget = dist(targetPosition.x, targetPosition.y, bluePosition.x, bluePosition.y);
  textSize(200);
  textAlign(CENTER);
  
  if(p1DistanceFromTarget > p2DistanceFromTarget) {
    fill(240, 32, 32); 
    rect(0, 0, 1280, 1024);
    text("PLAYER 1 WINS", width/2, height/2);
  }
    if(p1DistanceFromTarget < p2DistanceFromTarget) {
    fill(32, 32, 240); 
    rect(0, 0, 1280, 1024);
    text("PLAYER 2 WINS", width/2, height/2);
  }
}

void keyPressed() {
  if (key == 's'&& stoneFired == false) {
    potentialEnergy++;  //as long as the key is pulled back, the slide power indicator will grow
  }

  if (key == 'a' && stoneFired == false) {  //player can move horizontal position of stone before firing
   if(currentTurn == 1) {
   redPosition.x -= 2; }
   
   if(currentTurn == 2) {
   bluePosition.x -= 2; }
   
  }
  if (key == 'd' && stoneFired == false) {
       if(currentTurn == 1) {
   redPosition.x += 2; }
   
   if(currentTurn == 2) {
   bluePosition.x += 2; }
  }
}

void keyReleased() {
  if (key == 's' && potentialEnergy > 0) {
    if(currentTurn == 1) {
    redAcceleration.y = potentialEnergy; }  //DO NOT DIVIDE POTENTIAL ENERGY BY ANYTHING, MAY CAUSE UNEXPECTED ACCELERATION
    if(currentTurn == 2) {
    blueAcceleration.y = potentialEnergy; }
    
    potentialEnergy = 0;
    resistance = 1;
    stoneFired = true;
  }
}
