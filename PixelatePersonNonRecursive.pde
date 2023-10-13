import processing.video.*;

int offsetVals[]  = { 10, 20, 40, 80, 120, 240};
int posVals[] = {213, 171, 129, 87, 45, 3};
Capture cam;
PGraphics bright, black;

int offset = 10;
int posVal = 213;
int state = 0;
float choice = 0;
int ypos;
boolean runPixelate = false;

int cMillis, pMillis;

int photoCounter;

PFont myFont;

void setup() {
  size(720, 720);
  bright = createGraphics(720, 720);
  black = createGraphics(720, 720);

  cam = new Capture(this, 720, 720); //width and height * offset = pgraphics w x h

  pMillis = 0;
  photoCounter = 0;
  myFont = createFont("ComicSansMS", 32);
  textFont(myFont);
}

void draw() {
  background(0);
  cMillis = millis();
  if (runPixelate) {
    pixelate();
  }

  imageMode(CORNER);
  switch(state) {
  case 0:
    textBox();
    textSize(45);
    textAlign(CENTER, CENTER);
    text("The 'Organization' has provided this cloud station to ensure you're protected no mater what the future holds! When you're ready please look at the camera and press the upload dome to create a version of you that can live on in the cloud!", 40, 40, 660, 660);
    break;
  case 1:
    image(cam, 0, 0);
    break;
  case 2:
    image(cam, 0, 0);
    textBox();
    textSize(45);
    textAlign(CENTER, CENTER);
    text("Digital capture complete..... We will now begin compressing your data for upload.", 40, 40, 660, 660);
    break;
  case 3:
    videoToGraphics();
    image(bright, 0, 0); //this never will be drawn in final piece
    offset = offsetVals[0];
    filter(POSTERIZE, posVals[0]);
    break;
  case 4:
    videoToGraphics();
    image(bright, 0, 0); //this never will be drawn in final piece
    offset = offsetVals[1];
    filter(POSTERIZE, posVals[1]);
    break;
  case 5:
    videoToGraphics();
    image(bright, 0, 0); //this never will be drawn in final piece
    offset = offsetVals[2];
    filter(POSTERIZE, posVals[2]);
    break;
  case 6:
    videoToGraphics();
    image(bright, 0, 0); //this never will be drawn in final piece
    offset = offsetVals[3];
    filter(POSTERIZE, posVals[3]);
    save("images/"+photoCounter+".jpg");
    break;
  case 7:
    image(bright, 0, 0); //this never will be drawn in final piece
    textBox();
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Compression complete we will now upload your digital data to the cloud.", 40, 40, 660, 660);
    break;
  case 8:
    //videoToGraphics();
    pushMatrix();
    translate(0, ypos);
    image(bright, 0, 0); //this never will be drawn in final piece
    popMatrix();
    break;
  case 9:
    image(black, 0, 0);
    textBox();
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Thank you for trusting us with your digital self!  We hope you enjoyed the experience. Please make sure to leave a five star review and to like and subscribe.", 40, 40, 660, 660);
    break;
  default:
  }
}

//replace with arduino command
void mousePressed() {
  photoCounter++;
  cam.start();
  delay(100);
  if (cam.available()) {
    cam.read();
  }
  cam.stop();

  runPixelate = true;
  offset = offsetVals[0];
  posVal =  posVals[0];
  ypos = 0;
  pMillis = cMillis;
}


//runs the pixelate sequence
void pixelate() {
  if (cMillis - pMillis > 1500) {
    state = 1;
  }
  if (cMillis - pMillis > 3000) {
    state = 2;
  }
  if (cMillis - pMillis > 8000) {
    state = 3;
  }
  if (cMillis - pMillis > 9000) {
    state = 4;
  }
  if (cMillis - pMillis > 10000) {
    state = 5;
  }
  if (cMillis - pMillis > 11000) {
    state = 6;
  }
  if (cMillis - pMillis > 12000) {
    state = 7;
  }
  if (cMillis - pMillis > 17000) {
    ypos -= 2;
    state = 8;
  }
  if (cMillis - pMillis > 24000) {
    state = 9;
  }
  if (cMillis - pMillis > 39000) {
    state = 0;
    runPixelate = false;
  }
}



//converts raw video to a pgraphics just use this to get the color
void videoToGraphics() {
  bright.beginDraw();
  for (int x = 0; x < 1280; x+=offset) {
    for (int y = 0; y < 720; y+=offset) {
      color c = cam.get(x, y);

      bright.pushMatrix();
      bright.noStroke();
      bright.fill(c);
      bright.rectMode(CORNER);
      bright.rect(x, y, (x+offset), (y+offset));
      bright.popMatrix();
    }
  }
  bright.endDraw();
}

void textBox() {
  pushStyle();
  fill(50, 50);
  rectMode(CORNER);
  rect(20, 20, 680, 680);
  popStyle();
}


void typer() {
}
