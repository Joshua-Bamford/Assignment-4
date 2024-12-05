

void setup() {
  size(1280, 1024);
  ellipseMode(CENTER);
  rectMode(CENTER);
}

void draw() {
  background(24, 74, 222);  //blue edges beside the ice
  noStroke();
  iceRink();
}

void iceRink() {
  fill(255);
  rect(width/2, 400, 1080, 3060);
  
}
