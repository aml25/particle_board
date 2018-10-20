import deadpixel.keystone.*;


Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;
PShape svg;

void setup(){
  size(800,640, P3D);
  
  
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(width,height,20);
  offscreen = createGraphics(width,height);
  svg = offscreen.loadShape("outlines.svg");
  svg.disableStyle();
}

void draw(){
  //println(svg.width);
  background(0);
  
  
  PVector surfaceMouse = surface.getTransformedMouse();

  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.background(0);
  

  
  float newWidth = (svg.width * offscreen.height) / svg.height;
  //offscreen.shape(svg,0,0, newWidth, offscreen.height);
  
    offscreen.scale(newWidth/svg.width,offscreen.height/svg.height);
  
  
  //shape(svg,mouseX,mouseY, newWidth, height);
  
  for(int i=0;i<svg.getChildCount();i++){
    //offscreen.shape(svg.getChild(i),0,0);
    //println("child: " + i + ": " + svg.getChild(i).getChildCount());
    if(svg.getChild(i).getChildCount() > 1){
      for(int u=0;u<svg.getChild(i).getChildCount();u++){
        if(u >= random(0,svg.getChild(i).getChildCount())){
          PShape path = svg.getChild(i).getChild(u);
         
          
          //offscreen.pushMatrix();
          
          //offscreen.translate(mouseX-(newWidth/2),mouseY-(offscreen.height/2));
          offscreen.fill(random(0,255),random(0,255),random(0,255));
          //translate(-path.getVertexX(0), - path.getVertexY(0));
          offscreen.shape(path,0,0);
          
         // offscreen.popMatrix();
        }
      }  
    }
  }
  
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
