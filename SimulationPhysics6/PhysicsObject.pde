public class PhysicsObject {
  //float scale1= pow(10,-15);


  float G = 6.67*pow(10, -15); //(Gm^3)/(Sg*s^2)    (Sg=sGrams)
  float deltaT =86400;  //seconds
  float planetX =0;
  //float planetY = 1.496*pow(10,11)*  (1.003*pow(10,-9));//distance between planet and sun meters
  float planetY = 1.495*pow(10, 11)*(1.000*pow(10, -9));
  float realSunX=0f; //kg
  float realSunY=0f;//kg
  float x = 300;
  float y = 450;
  float pX =300;
  float pY =450;
  boolean printData = false;
  //float sunMass =1.989*pow(10,30)*  pow(10,-23); //kg
  //float planetMass = 5.972*pow(10,24)*  pow(10,-23);//kg
  float sunMass = 2*pow(10, 7);
  float planetMass= 60;

  float planetVelocityX = 29780*pow(10, -9);//not -23

  //float planetVelocityX = 30000*pow(10,-4.62);
  float planetVelocityY;
  color lineColor = color(0,255,0);
  public float offSetX =300;
  public float offSetY =300;
  int counter = 0;
  float startVx;
  float startVy;
  float startX;
  float startY;
  
  PhysicsObject(float posX, float posY, float mass, float velocityX, float velocityY, 
  float deltaTime, boolean debuging,color linecolor) {
    planetX = posX;
    planetY = posY;
    planetMass = mass;
    planetVelocityX = velocityX;
    planetVelocityY = velocityY;
    deltaT=deltaTime;
    printData = debuging;
    lineColor = linecolor;
    startVx = velocityX;
    startVy = velocityY;
    startX = posX;
    startY = posY;
  }
  void updateTrajectory() {
    float distanceSunplanet = distance(realSunX, realSunY, planetX, planetY);
    if (printData)
      println(distanceSunplanet);
    float force = getForce(sunMass, planetMass, distanceSunplanet);

    float aSunplanet = acceleration(force, planetMass);


    float aplanetX = accelerationBreakup(realSunX, planetX, distanceSunplanet, aSunplanet);

    float aplanetY = accelerationBreakup(realSunY, planetY, distanceSunplanet, aSunplanet);

    planetVelocityX = velocity(planetVelocityX, aplanetX, deltaT);

    planetVelocityY = velocity(planetVelocityY, aplanetY, deltaT);

    planetX = position(planetVelocityX, planetX, deltaT);

    planetY = position(planetVelocityY, planetY, deltaT);

    x = planetX+offSetX;
    y = planetY+offSetY;
    //println(y);
    stroke(lineColor);
    //println(x);
    if(counter!=0){
    line(pX, pY, planetX+300, planetY+300);
    }
    counter+=1;
    pX = x;
    pY = y;
  }
  
  void addVelocity(float magnitude){
    float distanceSunplanet = distance(realSunX,realSunY,planetX,planetY);
    float addedvX = velocityBreakup(realSunX,planetX,distanceSunplanet,magnitude);
    float addedvY = velocityBreakup(realSunY,planetY,distanceSunplanet,magnitude);
    planetVelocityX +=addedvX;
    planetVelocityY +=addedvY;
    print(planetVelocityY);
  }
  float distance(float x1, float y1, float x2, float y2) {
    float x = abs(x2-x1);
    float y = abs(y2-y1);
    return sqrt(pow(x, 2)+pow(y, 2));
  }
  float getForce(float m1, float m2, float distance) {
    float a = (G*m1*m2)/(pow(distance, 2));
    return a;
  }
  float acceleration(float f, float m) {
    float a = f/m;
    return a;
  }

  float accelerationBreakup(float p1, float p2, float distance, float acceleration) {
    return acceleration*((p1-p2)/distance);
    // sunP-planetP
  }
  float velocityBreakup(float p1, float p2, float distance, float velocity){
    return velocity*((p1-p2)/distance);
  }
  float velocity(float vi, float acceleration, float deltaT) {
    return vi+(acceleration*deltaT);
  }
  float position(float velocity, float position, float deltaT) {
    return (velocity*deltaT)+position;
  }
  float[] returnPosition(){
    float[] coordinates = new float[2];
    coordinates[0] = x;
    coordinates [1] =y;
    return coordinates;
  }
  void reset(){
    planetX = startX;
    planetY = startY;
    planetVelocityX = startVx;
    planetVelocityY = startVy;
    pX = x;
    pY =y;
  }
}
