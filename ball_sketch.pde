/*"Balls" developed and written by Shirish Sarkar
  based off code written by Keith Peters
  */


int numberOf = 10;
int numBalls;
Ball[] balls = new Ball[numberOf];

//gradient background
int Y_AXIS = 1;
int X_AXIS = 2;
color b1, b2;


String input = "";
boolean begin = false;
boolean collision = false;
PFont font;

float grav = 0.05;
float spring = 0.03;
float friction = -0.91;

float outlineFactor = (.01);
//int size = 650;
//int widthratio = size * (16/9);

void setup() {

  //window size
  size(750, 750);
  frameRate(60);
  
  noStroke();
  //smooth();
  
  //background gradient, unused
  b1 = color(#8BF8CF);
  b2 = color(#FAFBBB);

  font = createFont("Helvetica", 40, true);
  if (numBalls > 0) {
    for (int i = 0; i < numberOf; i++) {
      float diameter = random(35, 95);
      //fill(random(255));
      balls[i] = new Ball(random(width % 2), random(height % 7), diameter, i, balls);
    }
  }
}

void draw() { 
  //setGradient(0, 0, width, height, b1, b2, X_AXIS);
  //background(#8BF8CF);
  
  noStroke();
  fill( 90, 225, 190, 200);
  rect(0, 0, width, height);

  strokeWeight(outlineFactor);
  if (begin == true) {
    //balls[numberOf] = mouseEllipse(mouseX, mouseY, 50 , 50);
    for (Ball ball : balls) {
      ball.collision();
      ball.movement();
      ball.display();
    }
  }
  fill(0);

  //  noStroke();
  //  fill(255, 0, 0);
  //  rectMode(CENTER);
  //  rect(0, 0, size, );
  //  noFill();

  fill(#FFFFEC);
  textFont(font, 22);
  text("PLEASE ENTER HOW MANY BALLS AND PRESS ENTER: " + input, (width/2), (height/3));
  text("BUT NOT MORE THAN: " + numberOf, (width/2), (height/2.72));
  textSize(12);
  text("(backspace to clear the canvas)", width/2, height/2.3);
  textAlign(CENTER);
  
  frame.setTitle(int(frameRate) + "fps");
  
}

class Ball {

  float x, y;
  float indDiameter;
  float velX = 0;
  float velY = 0;
  int whichBall;
  Ball[] otherBalls;

  Ball(float initX, float initY, float diameter, int id, Ball[] which) {

    x = initX;
    y = initY;
    indDiameter = diameter;
    whichBall = id;
    otherBalls = which;
  } 
  
  //ball shadow
  void ballShader (float ballX, float ballY, float diameter) {
    //fill(#98FB98);
    fill(#FF0222);
    ellipse(ballX, ballY, diameter, diameter);
  }
  
  //mouse ball
  void mouseBall (int x, int y, int px, int py) {
    strokeWeight(0);
    fill(#CADDEE);
    noStroke();
    //lights();
    translate( mouseX, mouseY );
    sphere(40);
  }

  void collision() throws ArrayIndexOutOfBoundsException {
    ;
    for (int i = whichBall; i < numBalls; i++) {
      //finding distance between all possible ball points
      float dx = otherBalls[i].x - x;
      float dy = otherBalls[i].y - y;

      float distance = sqrt(dx*dx + dy*dy);
      //float distance = sqrt(dx*mouseX + dy*mouseY);
      float minDist = otherBalls[i].indDiameter/2 + indDiameter/2;


      if (distance <= minDist) {
        collision = true;
        float angleOfRebound = atan2(dy, dx);
        float targetX = x + cos(angleOfRebound) * minDist;
        float targetY = y + sin(angleOfRebound) * minDist;
        float accX = (targetX - otherBalls[i].x) * spring;
        float accY = (targetY - otherBalls[i].y) * spring;
        velX -= accX;
        velY -= accY;
        otherBalls[i].velX += accX;
        otherBalls[i].velY += accY;
  
        //        //stroke(#FFFFFF);
        strokeWeight(2);
        //        //line(mouseX, mouseY, otherBalls[i].x, otherBalls[i].y);
        stroke(#000000);
        noFill();

        beginShape();
        vertex(mouseX, mouseY);
        bezierVertex(mouseX + velX, mouseY + (velY * grav), 
        otherBalls[i].x + velX, otherBalls[i].y + (velY * grav), 
        otherBalls[i].x, otherBalls[i].y);
        endShape();
        noStroke();

        ballShader(otherBalls[i].x, otherBalls[i].y, otherBalls[i].indDiameter);
        noFill();
      }
      
//      if (collision == true) {
//          fill(#000000);
//          ellipse(otherBalls[i].x , otherBalls[i].y , indDiameter, indDiameter);
//          collision = false;
//        }
      }
    }

  void mouseLine (Ball[] each, float vX, float vY) {
    //stroke(#FFFFFF);

    strokeWeight(.5);
    //line(mouseX, mouseY, otherBalls[i].x, otherBalls[i].y);
    noFill();
    stroke(255);
      
      //cross lines
      beginShape();
      vertex(0, 0);
      bezierVertex(-mouseX , -mouseY , 
      mouseX, mouseY, 
      width, 0);
      endShape();
      
      
      beginShape();
      vertex(0, height * .2);
      bezierVertex(-mouseX , -mouseY , 
      mouseX, mouseY, 
      width, height * .2);
      endShape();
      
      beginShape();
      vertex(0, height * .4);
      bezierVertex(mouseX , mouseY , 
      mouseX, mouseY, 
      width, height * .4);
      endShape();
      
      beginShape();
      vertex(0, height * .6);
      bezierVertex(mouseX , mouseY , 
      -mouseX, -mouseY, 
      width, height * .6);
      endShape();
      
      beginShape();
      vertex(0, height * .8);
      bezierVertex(mouseX , mouseY , 
      -mouseX, -mouseY, 
      width, height * .8);
      endShape();
      
      beginShape();
      vertex(0, height);
      bezierVertex(mouseX , mouseY , 
      -mouseX, -mouseY, 
      width, height);
      endShape();
      
    noStroke();
  }

  void movement() {
    velY += grav;
    y += velY;
    x += velX;

    if (x + indDiameter/2 >= width) {
      x = width - indDiameter/2;
      velX *= friction;
    } else if (x - indDiameter/2 <= 0) {
      x = indDiameter/2;
      velX *= friction;
    }
    if (y + indDiameter/2 >= height) {
      y = height - indDiameter/2;
      velY *= friction;
    } else if (y - indDiameter/2 <= 0) {
      y = indDiameter/2;
      velY *= friction;
    }
  }

  void display() {
    //fill(random(60, 255), 0, random(50, 150));
    //mouseLine(otherBalls, velX, velY);
    //fill(#FFF000);
    fill(#FFF020);
    ellipse(x, y, indDiameter, indDiameter); 
    //mouseBall(mouseX, mouseY, 20, 20);
  }
}

////mouse ball
// mouseEllipse (int x, int y, int px, int py){
//  strokeWeight(.55);
//  fill(#FFDDEE);
//  ellipse(x, y, px, py);


//keypress controls, ENTER + BACKSPACE
void keyPressed() {

  if (key == ENTER && int(input) > 0) {
    numBalls = int(input);
    begin = true;
    println(numBalls);
    setup();
    input = "";
    if (numBalls > numberOf) {
      //number of used vs. number of total in array
      noLoop();
      throw new ArrayIndexOutOfBoundsException("Now you fucked up!");
    }
  } else if (key != CODED && key > 31) {
    input = input + key;
  } else if (key == BACKSPACE) {
    background(0, 0, 0);
    textSize(50);
    color(0);
    text("CLEARING!! PRESS 'BACKSPACE' TO ENTER A NEW AMT: ", width/2, height/3 ); 
    input = "";
    numBalls = 0;
    begin = false;
    setup();
  } else {
    background(0, 0, 0);
    textSize(30);
    text("NOW YOU DONE IT! PRESS ENTER TO TRY AGAIN:", width/2, height/2);
    numBalls = 0;
    if (key == ENTER) {
      setup();
    } else {
      text("KEEP TRYING BUD.", width/2, height/2);
    }
  }
}

void mousePressed() {
  //noLoop();
}

void mouseReleased() {
  draw();
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  } 
}
