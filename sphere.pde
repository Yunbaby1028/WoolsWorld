class Sphere {
  // position of the sphere
  float x, y, z;
  int play;
  color c;
  
  int getLength() {
      return int(myMovie.duration() * myMovie.frameRate);
  }
  
  int getFrame() {    
      return ceil(myMovie.time() * 60) - 1;
  }
  
  //int newFrame = 0;
    
  Sphere( color c) {
    this.c = c;
  }
  
  // draw the sphere
  void draw() {
    
    image(myMovie, 0, 0, width, height);
    
    if(x < -50 && getFrame() < (getLength() - 1)){
      play = 1;
      myMovie.play();
    }
    else {
      play = -1;
      myMovie.play();
    }
    
    //if(getFrame() < 1) myMovie.play();
    
    float newSpeed = map(abs(y)/10, 0, 150, 0*play, 2*play);
    myMovie.speed(newSpeed);
    
    fill(255);
    println(x);
    println(y);
    println(z);
    text("Position X of Root: " + nfc(x, 2), 10, 30);
    text(getFrame() + " / " + (getLength() - 1), 10, 50);   
  }
    
  // update the position of the root node 
  // (this function will be plugged to OSC)   
  public void updateRoot(float x, float y, float z) {
    this.x = map(x, 0, 100, -width/2, width/2);
    this.y = map(y, -100, 100, -height/2, height/2);
    this.z = map(z, 0, 100, 0, depth);
  }
}