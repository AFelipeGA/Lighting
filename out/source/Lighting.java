import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import nub.core.*; 
import nub.primitives.*; 
import nub.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Lighting extends PApplet {





// Models
PShape carShape, lampShape, streetShape, trafficLightShape;

// Nub
Scene scene;
Node car;
Node headLight1;
Node headLight2;
Node stopLight1;
Node stopLight2;
Node lamp1;
Node bulb1;
Node lamp2;
Node bulb2;
Node street;
Node trafficLight;
Node topRedLight;
Node topYellowLight;
Node topGreenLight;
Node sideRedLight;
Node sideYellowLight;
Node sideGreenLight;

// controls
boolean leftLampControl = true;
boolean rightLampControl = true;
int trafficLightColor = 1;
boolean specular = true;
int headLightsControl = 1; // 0 -> Off ; 1 -> Lows ; 2 -> Highs
boolean stopLightsControl = true;
boolean axis = false;
boolean night = true;

// scene center
Vector sceneCenter = new Vector(0,0,0);

// car position
Vector carPosition = new Vector(sceneCenter.x(), sceneCenter.y()-10, sceneCenter.z());

// lamp 1 position
Vector lamp1Position = new Vector(sceneCenter.x()+350, sceneCenter.y()+50, sceneCenter.z()+600);

// lamp 2 position
Vector lamp2Position = new Vector(sceneCenter.x()-350, sceneCenter.y()+50, sceneCenter.z()+600);

// traffic light position
Vector trafficLightPosition = new Vector(sceneCenter.x()-250, sceneCenter.y()-350, sceneCenter.z()-600);

// shader
PShader texlightShader;

public void setup() {
    
  texlightShader = loadShader("pixlightxfrag.glsl", "pixlightxvert.glsl");

  scene = new Scene(this);
  scene.setRadius(1200);
  scene.fit();

  car = new Node(scene, loadShape("Car/Car.obj"));
  car.setPosition(carPosition);

  headLight1 = new Node(car);
  headLight1.setPosition(carPosition.add(90, -90, -365));

  headLight2 = new Node(car);
  headLight2.setPosition(carPosition.add(-90, -90, -365));

  stopLight1 = new Node(car);
  stopLight1.setPosition(carPosition.add(85, -90, 370));

  stopLight2 = new Node(car);
  stopLight2.setPosition(carPosition.add(-85, -90, 370));

  lamp1 = new Node(scene, loadShape("Lamp/Lamp.obj"));
  lamp1.setPosition(lamp1Position);

  lamp2 = new Node(scene, loadShape("Lamp/Lamp.obj"));
  lamp2.setPosition(lamp2Position);

  trafficLight = new Node(scene, loadShape("TrafficLight/TrafficLight.obj"));
  trafficLight.setPosition(trafficLightPosition);

  street = new Node(scene, loadShape("Street/Street.obj"));
  street.setPosition(sceneCenter);
}

public void draw() {    
  colorMode(HSB, 360, 100, 100);
  background(0);
  scene.render();
  if(axis) {
    scene.drawAxes();
  }
}

public void mouseDragged() {
  if (mouseButton == LEFT)
    scene.spin();
  else if (mouseButton == RIGHT)
    scene.translate();
  else
    scene.scale(mouseX - pmouseX);
}

public void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}

/*void drawScene() {  
  shader(texlightShader);
  drawLights();

  pushMatrix();
  translate(lamp1_X , lamp1_Y, lamp1_Z);
  shape(lamp_1);
  popMatrix();

  pushMatrix();
  translate(lamp2_X , lamp2_Y, lamp2_Z);
  shape(lamp_2);
  popMatrix();

  pushMatrix();  
  translate(scene_X, scene_Y, scene_Z);
  shape(street);  
  popMatrix();

  pushMatrix();  
  shininess(0.2);
  specular(0, 0, 100);
  translate(car_X, car_Y, car_Z);
  shape(car);
  popMatrix();

  resetShader();
  pushMatrix();
  translate(tlight_X , tlight_Y, tlight_Z);
  shape(trafficLight);
  popMatrix();

  //resetShader();
}*/
/*
void drawLights() {
  if(night){
    ambientLight(0, 0, 10);
  } else {
    ambientLight(0, 0, 80);
  }

  if(specular){
    lightSpecular(0, 0, 40);
  }

  if(rightLampControl) {
    pushMatrix();
    translate(lamp1_X , lamp1_Y-350, lamp1_Z);
    stroke(0, 0, 20);
    sphere(10);
    pointLight(31, 33, 50, 0, 0, 0);
    popMatrix();
  }

  if(leftLampControl) {
    pushMatrix();
    translate(lamp2_X , lamp2_Y-350, lamp2_Z);
    stroke(0, 0, 20);
    sphere(10);
    pointLight(31, 33, 100, 0, 0, 0);
    popMatrix();
  }

  switch(headLightsControl){
    case 0:
      // do nothing
      break;
    case 1: // LOWS
      pushMatrix();
      translate(car_X + 90 , car_Y-90, car_Z-365);
      stroke(33, 12, 100);
      sphere(10);
      spotLight(33, 12, 100, 0, 0, 0, 0, 1, -1, PI/2, 1);
      popMatrix();

      pushMatrix();
      translate(car_X - 90 , car_Y-90, car_Z-365);
      stroke(33, 12, 100);
      sphere(10);
      spotLight(33, 12, 100, 0, 0, 0, 0, 1, -1, PI/2, 1);
      popMatrix();

      break;
    case 2: // HIGHS
      pushMatrix();
      translate(car_X + 90 , car_Y-90, car_Z-365);
      stroke(33, 12, 100);
      sphere(10);
      spotLight(33, 12, 100, 0, 0, 0, 0, 0, -1, PI, 1);
      popMatrix();

      pushMatrix();
      translate(car_X - 90 , car_Y-90, car_Z-365);
      stroke(33, 12, 100);
      sphere(10);
      spotLight(33, 12, 100, 0, 0, 0, 0, 0, -1, PI, 1);
      popMatrix();
      
      break;
  }

  if(specular){
    lightSpecular(0,100,50);
  }

  if(stopLightsControl) {
    pushMatrix();
    translate(car_X + 85 , car_Y-90, car_Z+370);
    stroke(0, 100, 100);
    sphere(10);
    spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 1);
    popMatrix();

    pushMatrix();
    translate(car_X - 85 , car_Y-90, car_Z+370);
    stroke(0, 100, 100);
    sphere(10);
    spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 1);
    popMatrix();
  }

  switch (trafficLightColor) {
    case 1: //red
      if(specular){
        lightSpecular(0, 100, 50);
      }
      // TOP
      pushMatrix();
      translate(tlight_X + 220, tlight_Y-100, tlight_Z-25);
      stroke(0, 100, 100);
      sphere(5);
      spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      popMatrix();
      // SIDE
      pushMatrix();
      translate(tlight_X - 100, tlight_Y+130, tlight_Z+50);
      stroke(0, 100, 100);
      sphere(5);
      spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      popMatrix();
      break;
    case 2: //yellow
      if(specular){
        lightSpecular(60,100,50);
      }
      // TOP
      pushMatrix();
      translate(tlight_X + 220, tlight_Y-80, tlight_Z-25);
      stroke(60,100,100);
      sphere(5);
      spotLight(60,100,100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      popMatrix();
      //SIDE
      pushMatrix();
      translate(tlight_X - 100, tlight_Y+150, tlight_Z+50);
      stroke(60,100,100);
      sphere(5);
      spotLight(60,100,100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      popMatrix();
      break;
    case 3: //green
      if(specular){
        lightSpecular(120, 120, 50);
      }
      //TOP
      pushMatrix();
      translate(tlight_X + 220, tlight_Y-60, tlight_Z-25);
      stroke(120, 120, 100);
      sphere(5);
      spotLight(120, 120, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      popMatrix();
      //SIDE
      pushMatrix();
      translate(tlight_X - 100, tlight_Y+170, tlight_Z+50);
      stroke(120, 120, 100);
      sphere(5);
      spotLight(120, 120, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      popMatrix();
      break;
  }
}*/
public void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      leftLampControl = !leftLampControl;
    }
    else if (keyCode == RIGHT) {
      rightLampControl = !rightLampControl;
    }
  }
  else if(key == 's'){
    specular = !specular;
  }
  else if(key == 't'){
    trafficLightColor = trafficLightColor == 0 ? 1 : 0;
  }
  else if(key == 'f'){
    println("headLightsControl: "+headLightsControl);
    headLightsControl = headLightsControl == 2 ? 0 : headLightsControl + 1;
  }
  else if(key == 'b'){
    println("stopLightsControl: "+stopLightsControl);
    stopLightsControl = !stopLightsControl;
  }
  else if(key == ' ') {
    trafficLightColor = trafficLightColor == 3 ? 1 : trafficLightColor + 1;
  }
  else if(key == 'x') {
    axis = !axis;
  }
  else if(key == 'n') {
    night = !night;
  }
  
}

public void drawAxis() {
  pushStyle();
  stroke(0, 100, 100);
  line(0, 0, 0, 1000, 0, 0);
  stroke(240, 100, 100);
  line(0, 0, 0, 0, 1000, 0);
  stroke(120, 120, 100);
  line(0, 0, 0, 0, 0, 1000);
  popStyle();
}
  public void settings() {  size(1080, 720, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Lighting" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
