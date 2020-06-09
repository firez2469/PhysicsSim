float earthvX = 30290*pow(10, -9);//meters/second
float earthY = 1.470*pow(10, 11)*(1*pow(10, -9));//gigameters
color earthColor = color(0, 0, 255);

float marsY = 2.060*pow(10, 11)*(pow(10, -9));
float marsvX = 26500*pow(10, -9);
color marsColor = color(255, 0, 0);

float shipvX = 30290*pow(10, -9)+3350*pow(10, -9);
float shipY = 1.470*pow(10, 11)*(1*pow(10, -9));
float shipMass = 5*pow(10, 5)*(pow(10, -9));
color shipColor = color(0, 255, 0);

float minDistance = 1000000;
float angle = 90;
float multiplier = 1;
//one day = 86400 seconds
PhysicsObject earthObject = new PhysicsObject(0, earthY, 60, earthvX, 0, 86400/multiplier, false, earthColor);
PhysicsObject marsObject = new PhysicsObject(0, marsY, 6.39, marsvX, 0, 86400/multiplier, false, marsColor);
PhysicsObject shipObject = new PhysicsObject(0, shipY, shipMass, shipvX, 0, 86400/multiplier, false, shipColor);

Table table = new Table();

boolean runFullSim = false;

void setup() {
  size(600, 600);
  background(0);
  fill(255, 255, 0);
  ellipse(300, 300, 50, 50);
  if (runFullSim) {
    table.addColumn("Angle");
    table.addColumn("Closest Encounter");
    for (int angle = 0; angle<360; angle++) {
      TableRow newRow = table.addRow();
      float closestEncounter = runLoop(int(angle), true);
      newRow.setInt("Angle", angle);
      newRow.setFloat("Closest Encounter", closestEncounter);
      earthObject.reset();
      marsObject.reset();
      shipObject.reset();
    }
    saveTable(table, "data/unaccurateencounter.csv");
  }
}
float timer = 0;
FloatList distances = new FloatList();
float limit = 550*multiplier;
//float limit = 23;
void draw() {

  runLoopInDraw(40, true);
}
void runLoopInDraw(int angle1, boolean withLoop) {
  angle1 = int(angle1*1.6f*multiplier);
  if (timer==0) {
    for (int i =0; i<angle1; i++) {
      marsObject.updateTrajectory();
    }
  }
  if (timer<=limit&&withLoop) {
    earthObject.updateTrajectory();
    marsObject.updateTrajectory();
    shipObject.updateTrajectory();
    minDistance = dist(shipObject.returnPosition()[0], shipObject.returnPosition()[1],
    marsObject.returnPosition()[0], marsObject.returnPosition()[1]);
    distances.append(minDistance);
    timer++;
  }
  if (timer==limit) {
    print(distances.min()*pow(10, 9));
  }
}
float runLoop(int dayNum, boolean withLoop) {
  float timer = 0;
  dayNum = int(dayNum*1.6f*multiplier);
  FloatList distances = new FloatList();
  for (int i =0; i<dayNum; i++) {
    marsObject.updateTrajectory();
  }
  while (timer<=limit&&withLoop) {
    earthObject.updateTrajectory();
    marsObject.updateTrajectory();
    shipObject.updateTrajectory();
    minDistance = dist(shipObject.returnPosition()[0], shipObject.returnPosition()[1], marsObject.returnPosition()[0], marsObject.returnPosition()[1]);
    distances.append(minDistance);
    timer++;
  }
  print(distances.min()*pow(10, 9));
  return distances.min()*pow(10, 9);
}
int steps = 0;
void keyPressed() {
  if (key==' ') {
    earthObject.updateTrajectory();
    marsObject.updateTrajectory();
    shipObject.updateTrajectory();
    minDistance = dist(shipObject.returnPosition()[0], shipObject.returnPosition()[1], marsObject.returnPosition()[0], marsObject.returnPosition()[1]);
    steps+=1;
    println(steps);
  }
  if (key=='f') {
    //shipObject.addVelocity(3350*pow(10,-9));
  }
}
