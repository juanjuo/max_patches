//Juan Diego Mora //<>//
// Oct 29 2025
// Visualization for Drumset Piece

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ArrayList<Number> numArray;
int padding = 50;
int numPerRow = 10;
int numRows;

void setup() {
  fullScreen(2);
  background(0);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  textSize(100);
  PFont courier = createFont("courier-normal.ttf", 128);
  textFont(courier);


  numArray = new ArrayList<Number>();

  // start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device,
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("172.20.1.225", 12000);



  //make it so that all 30 possible numbers are already set up

  //int index = 0;
  //for (int x = padding; x < (width - padding); x = x + (width - padding) / numPerRow) {
  //  numArray[index] = new Number(x, (height/2) + 50, (int) random(1, 5), true);
  //  index++;
  //}
}

void draw() {
  background(0);
  for (Number n : numArray) {
    n.display();
  }
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage m) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: " + m.addrPattern());
  println(" typetag: " + m.typetag());

  println(m.arguments());

  if (m.checkAddrPattern("list")) {
    numArray.clear();
    numRows = m.arguments().length / numPerRow;
    for (int i = 0; i < m.arguments().length; i++) {
      Number n = new Number(calculateX(i), calculateY(i), m.get(i).intValue(), true);
      numArray.add(n);
    }
  }

  if (m.checkAddrPattern("int")) {
    int n = m.get(0).intValue();
    if (n != 0) {
      numArray.get(n - 1).turnOff();
    }
  }

  if (m.checkAddrPattern("reset")) {
    reset();
  }

  if (m.checkAddrPattern("failed")) {
    reset();
  }

  if (m.checkAddrPattern("completed")) {
    for (Number n : numArray) {
      n.active = true;
      n.shuffle = true;
    }
  }

  if (m.checkAddrPattern("end_shuffle")) {
    for (Number n : numArray) {
      n.shuffle = false;
    }
  }

  //for ( Object o : m.arguments()) {
  //  println( o.getClass().getSimpleName() + "\t" + o );
  //}
}

float calculateX(int index) {
  return padding + (index % numPerRow) * (width - padding) / numPerRow;
}

float calculateY(int index) {
  //int row = index
  //return (height / (numRows + 1));
  return padding + (int) ((index / numPerRow) + 1) * (height / (numRows + 1));
}

void reset() {
  for (Number n : numArray) {
    n.turnOn();
  }
}

void failed() {
  reset();
}
