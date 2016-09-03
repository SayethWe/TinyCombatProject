int hexCountX = 8;
int hexCountY = 4;
color lakeColor = color(10,50,255);
color forestColor = color(10,127,10);
color mountainColor = color(75,75,75);
color archerColor = color(50,255,50);
color knightColor = color(255,50,50);
color mageColor = color(50,50,255);
int radius = 100;
boolean randomColorSelection = true;

Hexagon[][] hexGrid;
color hexFill;

void setup() {
  surface.setSize(int(((1.5*hexCountX) + 0.5)*radius),int((hexCountY+.5)*sqrt(3)*radius));
  println("Screen size: " + int(((1.5*hexCountX)+ 0.5)*radius) + "," + int((hexCountY+.5)*sqrt(3)*radius));
  smooth();
  frameRate(30);
  background(255);
  setupHexes();
}

void draw() {
  drawHexes();
}

void setupHexes() {
  hexGrid = new Hexagon[hexCountX][hexCountY];
  for (int hexX = 0; hexX < hexCountX; hexX++) {
    for (int hexY = 0; hexY < hexCountY; hexY++) {
      println("Hexagon HexX = " + hexX + ", HexY = " + hexY + " is being created.");
      if(randomColorSelection) {
        colorNextHex(); //select hex color randomly
        println("Randomly selecting Hex Color");
      }else {
        colorNextHex(hexX,hexY); //select color algorithmically
        println("Algorithmically selecting Hex Color");
      }
      if ((hexX % 2) == 0) {
        hexGrid[hexX][hexY] = new Hexagon(radius * ((1.5 * hexX) + 1), sqrt(3) * radius * (hexY + .5), radius, hexFill);
      } else {
        hexGrid[hexX][hexY] = new Hexagon(radius *((1.5 * hexX) + 1), sqrt(3) * radius * (hexY + 1), radius, hexFill);
      }
    }
  }
}

void colorNextHex() {
  //the random selection code
  println("color number " + int(random(0,3)) + " has been chosen.");
  switch(int(random(0,3))) {
    case 0 :
      hexFill = lakeColor;
      break;
    case 1:
      hexFill = forestColor;
      break;
    case 2:
      hexFill = mountainColor;
      break;
  }
}

void colorNextHex(int hexX, int hexY) {
  //the algorithm selection code (in QA)
  switch(hexY%3) {
    case 0 :
      if((hexX % 2) == 0) {
        hexFill = forestColor;
      } else {
        hexFill = lakeColor;
      }
      break;
    case 1:
      if((hexX % 2) == 0) {
        hexFill = mountainColor;
      } else {
        hexFill = forestColor;
      }
      break;
    case 2:
      if((hexX % 2) == 0) {
        hexFill = lakeColor;
      } else {
        hexFill = mountainColor;
      }
      break;
  }
}

void drawHexes() {
  for (int hexX = 0; hexX < hexCountX; hexX++ ) {     
    for (int hexY = 0; hexY < hexCountY; hexY++ ) {
      hexGrid[hexX][hexY].display();
    }
  }
}

class Hexagon {
  float x;
  float y;
  float angle = TWO_PI/6;
  int radius;
  color fillColor;
  
  Hexagon(float _x, float _y, int _radius, color _fillColor) {
    x = _x;
    y = _y;
    radius = _radius;
    fillColor = _fillColor;
    println("New Hex at " + x + "," + y + " of size " + radius);
  }

  void display() {
    beginShape();
    for (int vertex = 0; vertex < 6; vertex++) {
      vertex(x + radius * cos(angle * vertex), y + radius * sin(angle * vertex));
      //println("Vertex = " + vertex + " Courtesy " + this);
    }
    fill(fillColor);
    endShape(CLOSE);
  }
}