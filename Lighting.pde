import nub.core.*;
import nub.primitives.*;
import nub.processing.*;
import nub.core.constraint.*;

// Nub
Scene scene;
Node car;
Node carLights;
Node headLight1;
Node headLight2;
Node stopLight1;
Node stopLight2;
Node lamp1;
Node lamp1Lights;
Node bulb1;
Node lamp2;
Node lamp2Lights;
Node bulb2;
Node street;
Node trafficLight;
Node trafficLightLights;
Node topRedLight;
Node topYellowLight;
Node topGreenLight;
Node sideRedLight;
Node sideYellowLight;
Node sideGreenLight;

// Constraint
LocalConstraint constraint = new LocalConstraint();

// controls
boolean leftLampControl = true;
boolean rightLampControl = true;
int trafficLightColor = 1;
int headLightsControl = 1; // 0 -> Off ; 1 -> Lows ; 2 -> Highs
boolean stopLightsControl = true;

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

void setup() {
  size(1080, 720, P3D);  
  texlightShader = loadShader("pixlightxfrag.glsl", "pixlightxvert.glsl");

  scene = new Scene(this);
  scene.setRadius(800);
  scene.fit();

  constraint.setTranslationConstraint(AxisPlaneConstraint.Type.AXIS, new Vector(0,0,1));

  setupLights();
  setupModels();
  
}


void draw() {    
  colorMode(HSB, 360, 100, 100);
  background(0);
  ambientLight(0,0,10);
  scene.render();
}

void setupModels() {
  car = new Node(scene, loadShape("Car/Car.obj"));
  car.setPosition(carPosition);
  car.setPickingThreshold(0);
  car.setConstraint(constraint);

  lamp1 = new Node(scene, loadShape("Lamp/Lamp.obj"));
  lamp1.setPosition(lamp1Position);
  lamp1.setPickingThreshold(0);
  lamp1.setConstraint(constraint);

  lamp2 = new Node(scene, loadShape("Lamp/Lamp.obj"));
  lamp2.setPosition(lamp2Position);
  lamp2.setPickingThreshold(0);
  lamp2.setConstraint(constraint);

  trafficLight = new Node(scene, loadShape("TrafficLight/TrafficLight.obj"));
  trafficLight.setPosition(trafficLightPosition);
  trafficLight.setPickingThreshold(0);
  trafficLight.setConstraint(constraint);

  street = new Node(scene, loadShape("Street/Street.obj"));
  street.setPosition(sceneCenter);
}

void setupLights() {
  carLights = new Node(scene);
  carLights.setPosition(carPosition);

  headLight1 = new Node(carLights){
    @Override
    public void graphics(PGraphics pg) {
      lightSpecular(0, 0, 40);
      switch(headLightsControl){
        case 0:
          // do nothing
          break;
        case 1: // LOWS
          stroke(33, 12, 100);
          sphere(10);
          spotLight(33, 12, 100, 0, 0, 0, 0, 1, -1, PI/2, 1);
          break;
        case 2: // HIGHS
          stroke(33, 12, 100);
          sphere(10);
          spotLight(33, 12, 100, 0, 0, 0, 0, 0, -1, PI, 1);
          break;
      }
    }
  };
  headLight1.setPosition(Vector.add(carPosition, new Vector(90, -90, -365)));

  headLight2 = new Node(carLights){
    @Override
      public void graphics(PGraphics pg) {
        lightSpecular(0, 0, 40);
        switch(headLightsControl){
          case 0:
            // do nothing
            break;
          case 1: // LOWS
            stroke(33, 12, 100);
            sphere(10);
            spotLight(33, 12, 100, 0, 0, 0, 0, 1, -1, PI/2, 1);
            break;
          case 2: // HIGHS
            stroke(33, 12, 100);
            sphere(10);
            spotLight(33, 12, 100, 0, 0, 0, 0, 0, -1, PI, 1);
            break;
        }
      }
  };
  headLight2.setPosition(Vector.add(carPosition, new Vector(-90, -90, -365)));

  stopLight1 = new Node(carLights){
    @Override
    public void graphics(PGraphics pg) {
      lightSpecular(0, 100, 50);
      if(stopLightsControl) {
        stroke(0, 100, 100);
        sphere(10);
        spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 1);
      }
    }
  };
  stopLight1.setPosition(Vector.add(carPosition, new Vector(85, -90, 370)));

  stopLight2 = new Node(carLights){
    @Override
    public void graphics(PGraphics pg) {
      if(stopLightsControl) {
        lightSpecular(0, 100, 50);
        stroke(0, 100, 100);
        sphere(10);
        spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 1);
      }
    }
  };
  stopLight2.setPosition(Vector.add(carPosition, new Vector(-85, -90, 370)));

  lamp1Lights = new Node(scene);
  lamp1Lights.setPosition(lamp1Position);

  bulb1 = new Node(lamp1Lights){
    @Override
    public void graphics(PGraphics pg) {
      lightSpecular(0, 0, 50);
      if(rightLampControl) {
        stroke(0, 0, 20);
        sphere(10);
        pointLight(31, 33, 50, 0, 0, 0);
      }
    }
  };
  bulb1.setPosition(Vector.add(lamp1Position, new Vector(0, -350, 0)));

  /*bulb2 = new Node(lamp2){
    @Override
    public void graphics(PGraphics pg) {
      lightSpecular(0, 0, 50);
      if(leftLampControl) {
        stroke(0, 0, 20);
        sphere(10);
        pointLight(31, 33, 50, 0, 0, 0);
      }
    }
  };
  bulb2.setPosition(Vector.add(lamp2Position, new Vector(0, -350, 0)));
  */

  trafficLightLights = new Node(scene);
  trafficLightLights.setPosition(trafficLightPosition);

  topRedLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 1) {
        lightSpecular(0, 100, 50);
        stroke(0, 100, 100);
        sphere(5);
        spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      }
    }
  };
  topRedLight.setPosition(Vector.add(trafficLightPosition, new Vector(220, -100, -25)));

  sideRedLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 1) {
        lightSpecular(0, 100, 50);
        stroke(0, 100, 100);
        sphere(5);
        spotLight(0, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      }
    }
  };
  sideRedLight.setPosition(Vector.add(trafficLightPosition, new Vector(-100, +130, +50)));

  topYellowLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 2) {
        lightSpecular(60,100,50);
        stroke(60,100,100);
        sphere(5);
        spotLight(60, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      }
    }
  };
  topYellowLight.setPosition(Vector.add(trafficLightPosition, new Vector(220, -80, -25)));

  sideYellowLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 2) {
        lightSpecular(60,100,50);
        stroke(60,100,100);
        sphere(5);
        spotLight(60, 100, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      }
    }
  };
  sideYellowLight.setPosition(Vector.add(trafficLightPosition, new Vector(-100, +150, +50)));

  topGreenLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 3) {
        lightSpecular(120,120,50);
        stroke(120,120,100);
        sphere(5);
        spotLight(120, 120, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      }
    }
  };
  topGreenLight.setPosition(Vector.add(trafficLightPosition, new Vector(220, -60, -25)));

  sideGreenLight = new Node(trafficLightLights){
    @Override
    public void graphics(PGraphics pg) {
      if(trafficLightColor == 3) {
        lightSpecular(120,120,50);
        stroke(120,120,100);
        sphere(5);
        spotLight(120, 120, 100, 0, 0, 0, 0, 1, 1, PI/2, 0.5);
      }
    }
  };
  sideGreenLight.setPosition(Vector.add(trafficLightPosition, new Vector(-100, +170, +50)));
}

void mouseMoved() {
  scene.cast();
}

void mouseClicked() {
  if(mouseButton == LEFT && scene.trackedNode() != null){
    if(scene.trackedNode().equals(car)){
      headLightsControl = headLightsControl == 2 ? 0 : headLightsControl + 1;
      if(headLightsControl>0){
        stopLightsControl = true;
      } else {
        stopLightsControl = false;
      }
    }
    else if(scene.trackedNode().equals(lamp1)){
      rightLampControl = !rightLampControl;
    }
    else if(scene.trackedNode().equals(lamp2)){
      leftLampControl = !leftLampControl;
    }
    else if(scene.trackedNode().equals(trafficLight)){
      trafficLightColor = trafficLightColor == 3 ? 0 : trafficLightColor + 1;
    }
  }

  if(mouseButton == RIGHT){}
  else if(scene.trackedNode() != null){
    if(scene.trackedNode().equals(car)){
      car.rotate(0,1,0,PI);
      carLights.rotate(0,1,0,PI);
    }
  }
}

void mouseDragged() {
  if (mouseButton == LEFT && scene.trackedNode() == null){
    scene.spin();
  }
  else if (mouseButton == RIGHT){
    scene.translate();
  }
  else{
    if(scene.trackedNode() == null){
      scene.scale(mouseX - pmouseX);
    }
  }
}

void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}