//grid size
int hexCountX = 8;
int hexCountY = 4;
int hexRadius = 100;
//terrain colors
color lake = color(60,100,255);
color forest = color(10,127,10);
color mountain = color(75,75,75);
//team colors
color teamOne = color(255,255,255);
color teamTwo = color(000,000,000);
//troops colors
color archer = color(50,255,50);
color knight = color(255,50,50);
color mage = color(50,50,255);
int troopRadius = 50;
//other magic numbers
boolean randomColorSelection = false;

Hexagon[][] hexGrid;
ArrayList<Troop> troops = new ArrayList<Troop>();
Troop selectedTroop;
Hexagon selectedGrid;
color hexFill;

void setup() {
  ellipseMode(RADIUS);
  surface.setSize(int(((1.5*hexCountX) + 0.5)*hexRadius),int((hexCountY+.5)*sqrt(3)*hexRadius));
  println("Screen size: " + int(((1.5*hexCountX)+ 0.5)*hexRadius) + "," + int((hexCountY+.5)*sqrt(3)*hexRadius));
  noStroke();
  frameRate(30);
  background(240,206,148);
  setupHexes();
  spawnTestTroops();
}

void draw() {
  drawHexes();
  drawTroops();
}

void keyPressed() { //QA code, also fun in random terrain mode.
  setupHexes();
}

void mousePressed() { //select something
  for(int hexX = 0; hexX < hexCountX; hexX++) {
    for(int hexY = 0; hexY < hexCountY; hexY++) {
      if(hexGrid[hexX][hexY].contains(mouseX,mouseY)) {
        selectedGrid = hexGrid[hexX][hexY];
        if (selectedGrid.getOccupant() != null) {
          selectedTroop = selectedGrid.getOccupant();
        }
      }
    }
  }
}

void spawnTestTroops() { //some checker code before troop placement is implemented
  spawnTroop(hexGrid[1][1],knight,teamOne);
  spawnTroop(hexGrid[1][0],archer,teamTwo);
  spawnTroop(hexGrid[2][1],mage,teamOne);
}

void setupHexes() {
  hexGrid = new Hexagon[hexCountX][hexCountY];
  for (int hexX = 0; hexX < hexCountX; hexX++) {
    for (int hexY = 0; hexY < hexCountY; hexY++) {
      println("Hexagon HexX = " + hexX + ", HexY = " + hexY + " is being created.");
        colorNextHex(hexX,hexY); //select color for the hexagons
      if ((hexX % 2) == 0) {
        hexGrid[hexX][hexY] = new Hexagon(hexRadius * ((1.5 * hexX) + 1), sqrt(3) * hexRadius * (hexY + .5), hexRadius, hexFill);
      } else {
        hexGrid[hexX][hexY] = new Hexagon(hexRadius *((1.5 * hexX) + 1), sqrt(3) * hexRadius * (hexY + 1), hexRadius, hexFill);
      }
    }
  }
}

void colorNextHex(int hexX, int hexY) {
  if(hexX + hexY == 0) {
    hexFill = teamOne;
  } else if (hexX + hexY == ((hexCountX + hexCountY) - 2)) {
    hexFill = teamTwo;
  } else if(randomColorSelection){  //generate by random
    println("Randomly selecting Hex Color");
    println("color number " + int(random(0,3)) + " has been chosen.");
    switch(int(random(0,3))) {
      case 0 :
        hexFill = lake;
        break;
      case 1:
        hexFill = forest;
        break;
      case 2:
        hexFill = mountain;
        break;
    } 
  } else { //generate by algorithm
    println("Algorithmically selecting Hex Color");
    switch(hexY%3) {
      case 0 :
        if((hexX % 2) == 0) {
          hexFill = forest;
        } else {
          hexFill = lake;
        }
        break;
      case 1:
        if((hexX % 2) == 0) {
          hexFill = mountain;
        } else {
          hexFill = forest;
        }
        break;
      case 2:
        if((hexX % 2) == 0) {
          hexFill = lake;
        } else {
          hexFill = mountain;
        }
        break;
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

void spawnTroop(Hexagon spawnLocation, color type, color team) {
  troops.add(new Troop(spawnLocation, troopRadius, type, team));
  spawnLocation.changeOccupant(troops.get(troops.size() - 1));
}

void drawTroops() {
  for (Troop thisTroop : troops) {
    thisTroop.display();
  }
}

boolean areAdjacent(Hexagon hexOne, Hexagon hexTwo) {
  if(dist(hexOne.getX(),hexOne.getY(),hexTwo.getX(),hexTwo.getY()) <= sqrt(3)*hexRadius) {
    return true;
  } else {
    return false;
  }
}

class Hexagon {
  float x, y;
  float angle = TWO_PI/6;
  int radius;
  color fillColor;
  Troop occupant;
  
  Hexagon(float _x, float _y, int _radius, color _fillColor) {
    x = _x;
    y = _y;
    radius = _radius;
    fillColor = _fillColor;
    println("New Hex at " + x + "," + y + " of size " + radius);
  }

  void display() {
    if(selectedGrid == this) {
      fill(127);
    } else {
      fill(fillColor);
    }
    beginShape();
    for (int vertex = 0; vertex < 6; vertex++) {
      vertex(x + radius * cos(angle * vertex), y + radius * sin(angle * vertex));
      //println("Vertex = " + vertex + " Courtesy " + this);
    }
    endShape(CLOSE);
  }
  
  void changeOccupant(Troop newOccupant) {
    occupant = newOccupant;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  color getType() {
    return fillColor;
  }
  
  Troop getOccupant() {
    return occupant;
  }
  
  boolean contains(float _x, float _y) {
    //hack code until I can look into more exact geometric methods.
    if(dist(x,y,_x,_y) <= (sqrt(3)/2) * radius) { //contained entirely in the hex, but misses the corners
      return true;
    } else {
      return false;
    }
  }
}

class Troop {
  int radius;
  color fillColor, teamColor;
  float x, y;
  Hexagon gridLocation;
  boolean selected;
  
  Troop(Hexagon _spawnLocation, int _radius, color _fillColor, color _teamColor) {
    gridLocation = _spawnLocation;
    radius = _radius;
    fillColor = _fillColor;
    teamColor = _teamColor;
  }
  
  void display() {
    x = gridLocation.getX();
    y = gridLocation.getY();
    fill(fillColor);
    if(selectedTroop == this) {
      //do something obvious to show selection
      fill(fillColor + color(127,127,127));
    }
    ellipse(x,y,radius,radius);
    fill(teamColor);
    //ellipse(x,y,radius/2,radius/2);
    beginShape();
    for(int vertex = 0; vertex < 3; vertex++) {
      vertex(x + (radius/2) * cos(PI/6 + vertex * TWO_PI/3), y + (radius/2) * sin(PI/6 + vertex * TWO_PI/3));
    }
    endShape(CLOSE);
  }
  
  void move(Hexagon moveTo) {
    if(dist(moveTo.getX(),moveTo.getY(),x,y) <= radius) {
      gridLocation = moveTo;
    }
  }
  
  Hexagon getLocation() {
    return gridLocation;
  }
  
  void toggleSelect() {
    selected = !selected;
  }
  
  color getType() {
    return fillColor;
  }
  
  color getTeam() {
    return teamColor;
  }
}