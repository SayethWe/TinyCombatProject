int hexCountX = 8;
int hexCountY = 4;
Hexagon[][] hexGrid;

int radius = 100;
int fillColor = 127;

void setup() {
  surface.setSize(int(((1.5*hexCountX) + 0.5)*radius),int((hexCountY+.5)*sqrt(3)*radius));
  println("size: " + int(((1.5*hexCountX)+ 0.5)*radius) + "," + int((hexCountY+.5)*sqrt(3)*radius));
  //size(750,750);
  smooth();
  frameRate(30);
  background(255);
  setupHexes();
  fill(128);
  //frame.setResizeable(true);
  //frame.setSize(int(12.5*radius),int(4.5*sqrt(3)*radius));
}

void draw() {
  drawHexes();
}

void setupHexes() {
  hexGrid = new Hexagon[hexCountX][hexCountY];
  for (int hexX = 0; hexX < hexCountX; hexX++) {
    for (int hexY = 0; hexY < hexCountY; hexY++) {
      if ((hexX % 2) == 0) {
        hexGrid[hexX][hexY] = new Hexagon(radius * ((1.5 * hexX) + 1), sqrt(3) * radius * (hexY + .5), radius);
      } else {
        hexGrid[hexX][hexY] = new Hexagon(radius *((1.5 * hexX) + 1), sqrt(3) * radius * (hexY + 1), radius);
      }
      println("HexX = " + hexX + ", HexY = " + hexY);
    }
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
  Hexagon(float _x, float _y, int _radius) {
    x = _x;
    y = _y;
    radius = _radius;
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