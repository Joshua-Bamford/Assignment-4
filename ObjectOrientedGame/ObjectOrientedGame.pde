Player1[] p1Stone = new Player1[2];
Player2[] p2Stone = new Player2[2];

PVector targetPosition;
PImage redStone;
PImage blueStone;
PImage scoreboard;
int currentTurn = 1;  //player 1 always starts off first
int potentialEnergy = 0;  //used as a counter in keyPressed to store how long the stick is held down
int resistance = 0;  //affects acceleration and therefore speed
int player1Score = 0;  //increment scoreboard progress bar by this amount
int player2Score = 0;
int totalTurns = 0;
int GOcounter = 0;  //stands for Game Over counter. Increments every frame that the game over screen is active
boolean stoneFired = false;  //used for both players to prevent curling stone from firing again while moving
boolean secondShot1 = false;  //each player gets 2 shots. the second one can only be taken if this is true
boolean secondShot2 = false;
float p1DistanceFromTarget;  //is equal to the difference between the target position and the stone's position
float p2DistanceFromTarget;

void setup() {
  size(1280, 1024);
  ellipseMode(CENTER);
  rectMode(CORNER);
  redStone = loadImage("curling_stone_red.png");
  blueStone = loadImage("curling_stone_blue.png");
  scoreboard = loadImage("scoreboard.png");
  targetPosition = new PVector(640, -1536);  //this is the starting position for the target each round
}

void draw() {
  frameRate(60);
  println(GOcounter, currentTurn);
  iceRink();
  noStroke();
  fill(0);
  rect(1190, 490, 70, 200);
  fill(255, 0, 0);
  rect(1200, 500, 50, (potentialEnergy*10));  //slide power indicater on right side

  scoreboard.resize(360, 120);
  fill(255, 247, 0);
  rect(170, 20, player1Score, 80);  //Should resize the bar a certaina mount so that it fills a cell of the scoreboard each round
  rect(170, 80, player2Score, 80);
  image(scoreboard, 20, 20);  //scoreboard overlaid on score bars


  if (currentTurn == 1) {    //player 1's turn
    if (p1Stone[0] == null) {  //there is obviously no instance of a curling stone at the start, so a new one is created
      p1Stone[0] = new Player1();  //adds a new instance of the Player 1 stone
      targetPosition.set(640, -1536);
    } else if (secondShot1 == true) {  //once the first one has stopped and the second player has had a go, a second player 1 stone is created
      p1Stone[1] = new Player1();  //adds a new instance of the Player 1 stone
      targetPosition.set(640, -1536);
      secondShot1 = false;
    }


    redAcceleration.y = redAcceleration.y - resistance;  //every frame, the acceleration is slowed by the resistance acting upon it
    redSpeed.y += -(redAcceleration.y);  //add value of acceleration to speed every frame. Value is inverse so that it goes forwards rather than backwards
    redPosition.y = constrain(redPosition.y, 100, 900) + redSpeed.y;  //add current speed to the position value. position is constrained to within the screen's bounds but the speed value will still be in effect

    if (stoneFired == true && redSpeed.y == 0) {  //once the curling stone comes to a complete stop
      redAcceleration.y = 0;  //ensures that if the speed reaches 0, the curling stone stops rather than going to negative values and accelerating backwards
      resistance = 0;  //same as previous line, there is no longer resistance once stopped
      delay(3000);  //gives the player a chance to see exactly where it landed before switching turns
      currentTurn = 2;  //switches whose turn it is
      stoneFired = false;  //since player2 uses the same variable to determine wheter or not the curling stone has been fired
      secondShot1 = true;  //once player 2 has finished, this allows the next instance of a player 1 stone to be created
      totalTurns++;  //turns count up every shot until they reach allotted amount
      p1DistanceFromTarget = dist(targetPosition.x, targetPosition.y, redPosition.x, redPosition.y);  //once it comes to a stop, the distance is calculated from the centre of the target
      println(p1DistanceFromTarget);  //for troubleshooting distance detection
    }

    if (redPosition.y <= 100) {  //when the curling stone reaches beyond the constraints of its movement, the speed that it has carries over inversely into the target movement
      targetPosition.y = constrain(targetPosition.y, -2000, 900) - redSpeed.y;
    }

    p1Stone[0].display();
    if (p1Stone[1] != null) {
      p1Stone[1].display();
    }
    println(targetPosition.y, redPosition.y, redSpeed.y, redAcceleration.y, potentialEnergy);  //monitoring for movement fine-tuning
  }


//Player 2's turn. most comments from P1 apply the same
  if (currentTurn == 2) {
    if (p2Stone[0] == null) {
      p2Stone[0] = new Player2();  //adds a new instance of the Player 2 stone
      targetPosition.set(640, -1536);
    } else if (secondShot2 == true) {
      p2Stone[1] = new Player2();  //adds a new instance of the Player 2 stone
      targetPosition.set(640, -1536);
      secondShot2 = false;
    }


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
      totalTurns++;
      p2DistanceFromTarget = dist(targetPosition.x, targetPosition.y, bluePosition.x, bluePosition.y);
      println(p2DistanceFromTarget);
    }

    if (bluePosition.y <= 100) {  //when the curling stone reaches beyond the constraints of its movement, the speed that it has carries over inversely into the target movement
      targetPosition.y = constrain(targetPosition.y, -2000, 900) - blueSpeed.y;
    }

    p2Stone[0].display();
    if (p2Stone[1] != null) {
      p2Stone[1].display();
    }

    println(targetPosition.y, bluePosition.y, blueSpeed.y, blueAcceleration.y, potentialEnergy);  //monitoring for movement fine-tuning
  }

  if (totalTurns == 4) {  //once each player has had 2 turns, the game is ended
    currentTurn = 0;
  }

  if (currentTurn == 0) {
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
  textSize(200);
  textAlign(CENTER);

  if (p1DistanceFromTarget > p2DistanceFromTarget) {
    fill(240, 32, 32);
    rect(0, 0, 1280, 1024);
    fill(255);
    text("PLAYER 1 WINS", width/2, height/2);
  } else {
    fill(32, 32, 240);
    rect(0, 0, 1280, 1024);
    fill(255);
    text("PLAYER 2 WINS", width/2, height/2);
  }
  GOcounter++;  //every frame that gameOver cycles through, the counter counts up to 120
  if (GOcounter >= 120) {  //the counter SHOULD cause the game to be reset on the next cycle once it reaches 120 (or approximately 2 seconds considering the 60fps frame rate)
    currentTurn = 1;
    GOcounter = 0;
    p1Stone[0] = null;
    p1Stone[1] = null;
    p2Stone[0] = null;
    p2Stone[1] = null;
  }
}

void keyPressed() {
  if (key == 's'&& stoneFired == false) {    //a new stone can only be fired if the previous one has stopped
    potentialEnergy = constrain(potentialEnergy, 0, 90) + 1;  //as long as the key is held, the slide power indicator will grow
  }

  if (key == 'a' && stoneFired == false) {  //player can move horizontal position of stone before firing
    if (currentTurn == 1) {  //checks which player is moving left or right
      redPosition.x -= 2;
    }

    if (currentTurn == 2) {
      bluePosition.x -= 2;
    }
  }
  if (key == 'd' && stoneFired == false) {
    if (currentTurn == 1) {
      redPosition.x += 2;
    }

    if (currentTurn == 2) {
      bluePosition.x += 2;
    }
  }
}

void keyReleased() {
  if (key == 's' && potentialEnergy > 0) {  //only can fire if there is potentialEnergy. since potential energy is only gained from the press, it does not trigger after firing
    if (currentTurn == 1) {
      redAcceleration.y = potentialEnergy;  //matches the acceleration with the potential energy, thus setting it for the next
    }  //DO NOT DIVIDE POTENTIAL ENERGY BY ANYTHING, MAY CAUSE UNEXPECTED BACKWARDS ACCELERATION
    if (currentTurn == 2) {
      blueAcceleration.y = potentialEnergy;
    }

    potentialEnergy = 0;
    resistance = 1;
    stoneFired = true;  //set to true so that the firing command cannot trigger multiple times while the stone is moving
  }
}
