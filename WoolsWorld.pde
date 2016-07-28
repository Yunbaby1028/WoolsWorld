
  ///////////////////////////////////////////////
  //                                           //
  //               Wool`s World                //
  //                                           //
  ///////////////////////////////////////////////

// Connecting to the Captury using osc-proxy.pd

import netP5.*;
import oscP5.*;
import processing.video.*;

OscP5 osc;
NetAddress remote;
Movie myMovie;

int localport = 12000;
int remoteport = 1065;
boolean debug = true;

// objects in space
Sphere sphere1;

String skeleton1 = "LS";//same skeleton name
String bone1 = "Root";

// depth of the screen
int depth;

void setup() {
  size(1920, 1080);
  frameRate(60);
  background(0);
  myMovie = new Movie(this, "Chinese Knot_Final.mov");

  //fullScreen(P3D);
  
  // create a sphere object
  sphere1 = new Sphere(1);
 
  depth = width;
  
  // connect via OSC
  osc = new OscP5(this, localport);
  remote = new NetAddress("kosmos.medien.uni-weimar.de", remoteport);
  setPort(localport);

  // pass position of Asha's root bone to the first sphere object
  plugBone(sphere1, skeleton1, bone1);
  
  // subscribe to OSC
  refreshSubscriptions();
}


// update the subscriptions to make sure they don't expire
void refreshSubscriptions() {
  subscribeBone(skeleton1, bone1);
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  // draw the sphere
  sphere1.draw();
  
  // refresh subscription every second or so
  if (frameCount % 10 == 0) {
    refreshSubscriptions();
  }
}


// capture all OSC events
void oscEvent(OscMessage msg) {
  if(debug) {
    print("### received an osc message.");
    print(" addrpattern: "+msg.addrPattern());
    println(" typetag: "+msg.typetag());
  }
}


// plug a specific bone
void plugBone(Object target, String skeleton, String bone) {
  String path =  "/" + skeleton + "/blender/" + bone + "/vector";
  osc.plug(target, "update" + bone, path);
}


// let the captury know which port is our local port
void setPort(int port) {
  OscMessage msg = new OscMessage("/configure/port");
  msg.add(port); 
  osc.send(msg, remote);
}


// subscribe to a specific bone
void subscribeBone(String skeletonId, String bone) {
  OscMessage msg = new OscMessage("/subscribe/" + skeletonId + "/blender/" + bone + "/vector");
  msg.add(50.0);
  msg.add(0.0);
  msg.add(100.0);
  osc.send(msg, remote);
}