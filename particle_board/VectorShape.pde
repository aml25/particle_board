class VectorShape{
  
  PShape path;
  
  VectorShape(PShape myPath){
    path = myPath;
  }
  
  PShape getPath(){
    return path;
  }
  
  //returns an int array [x,y]
  float[] getCenter(){
    float[] xy = new float[2];
    int vertexCount = path.getVertexCount();
    
    for(int i=0;i<vertexCount;i++){
      xy[0] += path.getVertexX(i);
      xy[1] += path.getVertexY(i);
    }
    
    xy[0] /= vertexCount;
    xy[1] /= vertexCount;
    
    return xy;
  }
  
}
