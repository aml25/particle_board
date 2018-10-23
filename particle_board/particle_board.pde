import deadpixel.keystone.*;


Keystone ks; //master keystone object
CornerPinSurface surface; //the canvas that gets mapped
PGraphics offscreen; //the canvas for drawing onto
PShape svg; //the edge detection vector to be mapped back onto the real world
ArrayList<VectorShape> shapes = new ArrayList<VectorShape>();

int prevMillis = 0; //used as an asynchronous timer
int duration = 1000; //milliseconds to wait for another thing to do
int shapeCounter = 0; //counts which shape we're at for scrolling through all shapes

void setup(){
  size(800,640, P3D); //must be P3D for Keystone library to work
  
  
  ks = new Keystone(this);
  
  offscreen = createGraphics(width,height);
  svg = offscreen.loadShape("outlines.svg"); //load the svg into the drawing canvas
  svg.disableStyle();
  
  surface = ks.createCornerPinSurface(int((svg.width * offscreen.height) / svg.height),height,20);
  
  //create objects for each shape (PShape)
  for(int i=0;i<svg.getChildCount();i++){
    if(svg.getChild(i).getChildCount() > 1){
      for(int u=0;u<svg.getChild(i).getChildCount();u++){
        
        shapes.add(new VectorShape(svg.getChild(i).getChild(u)));
      }  
    }
  }
  
}

void draw(){
  background(0);
  
  if(millis() - prevMillis > duration){
    prevMillis = millis();
    shapeCounter++;
    if(shapeCounter >= shapes.size()){
      shapeCounter = 0;
    }
    
    
  }
  
  PVector surfaceMouse = surface.getTransformedMouse(); //in case the mouse will be used

  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.background(0);
  
  //scale the svg so it fits in the window (look for a way to do this outside of the draw() function)
  float newWidth = (svg.width * offscreen.height) / svg.height;
  offscreen.scale(newWidth/svg.width,offscreen.height/svg.height); 
  
  
  //draw all the shapes as outlines
  //offscreen.strokeWeight(0.5);
  //offscreen.fill(0,0,0,0);
  //for(int i=0;i<shapes.size();i++){
  //  offscreen.stroke(255,255,255);
  //  offscreen.shape(shapes.get(i).getPath(),0,0);
  //}
  
  
  //only draw a filled shape for the one we're counting at
  offscreen.stroke(0,0,0,0);
  offscreen.fill(random(0,255),random(0,255),random(0,255));
  offscreen.shape(shapes.get(shapeCounter).getPath(),0,0);
  
  offscreen.endDraw();
  
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}
