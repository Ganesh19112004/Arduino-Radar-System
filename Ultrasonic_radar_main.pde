import processing.serial.*;
Serial myPort;

String angle = "", distance = "", data = "";
int iAngle = 0, iDistance = 0;

float[] distanceArray = new float[181];
float[] distanceHistory = new float[500]; // for small graph below

int sweepAngle = 0;
boolean sweepForward = true;

void setup() {
  size(1200, 700);
  smooth();
  myPort = new Serial(this, "COM5", 9600); // Update COM port
  myPort.bufferUntil('.');
}

void draw() {
  // semi-transparent background for fading trail effect
  fill(0, 40);
  noStroke();
  rect(0, 0, width, height - height * 0.065);

  drawRadarGrid();
  drawSweepLine();
  drawDetectedDots();
  drawTextPanel();
  updateSweepAngle();
  drawDistanceHistory();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = trim(data);
    if (data.endsWith(".")) data = data.substring(0, data.length() - 1);

    int index = data.indexOf(",");
    if (index > 0) {
      angle = data.substring(0, index);
      distance = data.substring(index + 1);
      iAngle = constrain(int(angle), 0, 180);
      iDistance = int(distance);

      if (iDistance > 0 && iDistance <= 40) {
        distanceArray[iAngle] = iDistance;
      } else {
        distanceArray[iAngle] = 0;
      }

      // Save distance history for graph
      for (int i = distanceHistory.length - 1; i > 0; i--) {
        distanceHistory[i] = distanceHistory[i - 1];
      }
      distanceHistory[0] = iDistance;
    }
  }
}

void drawRadarGrid() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(1.5);
  stroke(98, 245, 31);

  // Distance arcs
  for (float r : new float[]{0.9375, 0.73, 0.521, 0.313}) {
    arc(0, 0, width * r, width * r, PI, TWO_PI);
  }

  // Angle lines
  for (int a = 0; a <= 180; a += 15) {
    line(0, 0, -width / 2 * cos(radians(a)), -width / 2 * sin(radians(a)));
  }

  popMatrix();
}

void drawSweepLine() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(2);
  stroke(0, 255, 0);
  line(0, 0, (height - height * 0.12) * cos(radians(sweepAngle)),
       -(height - height * 0.12) * sin(radians(sweepAngle)));
  popMatrix();
}

void updateSweepAngle() {
  if (sweepForward) {
    sweepAngle++;
    if (sweepAngle >= 180) sweepForward = false;
  } else {
    sweepAngle--;
    if (sweepAngle <= 0) sweepForward = true;
  }
}

void drawDetectedDots() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);

  for (int a = 0; a <= 180; a++) {
    float d = distanceArray[a];
    if (d > 0) {
      float pixelDist = d * 10;
      color c;
      if (d < 15) c = color(255, 0, 0, 200);
      else if (d < 30) c = color(255, 255, 0, 200);
      else c = color(0, 255, 0, 180);

      fill(c);
      noStroke();

      float x = pixelDist * cos(radians(a));
      float y = -pixelDist * sin(radians(a));
      ellipse(x, y, 10, 10);
    }
  }
  popMatrix();
}

void drawTextPanel() {
  pushMatrix();
  fill(0);
  noStroke();
  rect(0, height - height * 0.0648f, width, height);
  fill(98, 245, 31);
  textSize(25);
  textAlign(LEFT);
  text("10cm", width - width * 0.3854f, height - height * 0.0833f);
  text("20cm", width - width * 0.281f, height - height * 0.0833f);
  text("30cm", width - width * 0.177f, height - height * 0.0833f);
  text("40cm", width - width * 0.0729f, height - height * 0.0833f);

  textSize(38);
  fill(0, 255, 0);
  text("N_Tech Radar", width * 0.02, height - height * 0.02);

  textSize(28);
  fill(255);
  text("Angle: " + iAngle + "°", width / 2 - 100, height - height * 0.02);
  text("Distance: " + (iDistance <= 40 ? iDistance + " cm" : "Out of Range"), width / 2 + 100, height - height * 0.02);

  popMatrix();
}

void drawDistanceHistory() {
  // Small graph at bottom showing recent distance variation
  pushMatrix();
  stroke(0, 255, 0);
  noFill();
  translate(50, height - 100);
  beginShape();
  for (int i = 0; i < distanceHistory.length; i++) {
    float y = map(distanceHistory[i], 0, 40, 80, 0);
    vertex(i, y);
  }
  endShape();
  fill(255);
  textSize(14);
  text("Distance History (cm)", 0, -10);
  popMatrix();
}
