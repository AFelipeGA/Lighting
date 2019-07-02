PShape car;
PShape light;
PShape floor = new PShape();

// scene center :
int scene_XValue = 0; 
int scene_YValue = 0; 
int scene_ZValue = 0; 

// camera
float camHeight = -200;    // height above the Scene
float Radius = 1200;  // radius for camera 
float angle = 0;

//mouse
float previous = 0; 

PShader texlightShader;

void setup() {
  size(1080, 720, P3D);  
  car = loadShape("Pony_cartoon.obj");
  light = loadShape("Light.obj");
  texlightShader = loadShader("pixlightxfrag.glsl", "pixlightxvert.glsl");
}

void draw() {    
  background(0);
  pushStyle();
  stroke(255, 0, 0);
  line(-1000, 0, 0, 1000, 0, 0);
  stroke(0, 255, 0);
  line(0, -1000, 0, 0, 1000, 0);
  stroke(0, 0, 255);
  line(0, 0, -1000, 0, 0, 1000);
  popStyle();
  CheckCameraMouse ();
  paintScene();

  
}

void paintScene() {  
  //shader(texlightShader);
  ambientLight(128, 128, 128);
  pointLight(0, 0, 255, scene_XValue, scene_YValue, scene_ZValue+1000);

  pushMatrix();
  rotateY(PI);
  translate(scene_XValue , scene_YValue, scene_ZValue + 1000);
  scale(-0.2);
  shape(light);
  popMatrix();

  
  //ambientLight(255, 255, 255);  

  pushMatrix();  
  
  translate(scene_XValue, scene_YValue, scene_ZValue);
  scale(-1);
  shape(car);  
  popMatrix();

  //resetShader();
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  Radius+=e*20;
  if (Radius < 0) {
    Radius=0;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP ) {
      camHeight-=50;
    }
    else if (keyCode == DOWN ) {
      camHeight+=50;
    }
  }
}

void mouseDragged(MouseEvent e) {
  if(e.getX()>previous){
    angle += PI/64;
  }
  else if(e.getX()<previous) {
    angle -= PI/64;
  }
  previous = e.getX();
}

void CheckCameraMouse () {

  PVector camPos = new PVector();
  camPos.x = Radius*sin(angle) + scene_XValue;
  camPos.y = camHeight;
  camPos.z = Radius*cos(angle) + scene_ZValue;
  
  camera (
  camPos.x, camPos.y, camPos.z,
  scene_XValue, scene_YValue + camHeight, scene_ZValue,
  0.0, 1.0, 0.0);
}