import processing.serial.*;
Serial myPort;

String angle = "", distance = "", data = "";
int iAngle = 0, iDistance = 0;

float[] distanceArray = new float[181];  // Store distances for each angle

int sweepAngle = 0;
boolean sweepForward = true;

void setup() {
  size(1200, 700);
  smooth();
  myPort = new Serial(this, "COM5", 9600); // Update COM port as needed
  myPort.bufferUntil('.');
}

void draw() {
  fill(0, 40); // trail effect
  noStroke();
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31);
  drawRadar();
  drawSweepLine();
  drawDetectedDots();  // Draw objects as large segments
  drawText();
  updateSweepAngle();
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
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);

  for (float r : new float[]{0.9375, 0.73, 0.521, 0.313}) {
    arc(0, 0, width * r, width * r, PI, TWO_PI);
  }

  for (int a = 0; a <= 180; a += 30) {
    line(0, 0, -width / 2 * cos(radians(a)), -width / 2 * sin(radians(a)));
  }

  popMatrix();
}

void drawSweepLine() {
  pushMatrix();
  strokeWeight(2);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  line(0, 0, (height - height * 0.12) * cos(radians(sweepAngle)), -(height - height * 0.12) * sin(radians(sweepAngle)));
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
      float pixelDist = d * 10;  // scale distance for visualization
      float sectorWidth = 4;     // angular width of each segment
      float startAngle = radians(a - sectorWidth / 2);
      float endAngle = radians(a + sectorWidth / 2);
      float innerRadius = pixelDist - 10;
      float outerRadius = pixelDist + 10;

      fill(255, 0, 0, 180);  // semi-transparent red
      noStroke();
      beginShape();
      for (float angle = startAngle; angle <= endAngle; angle += radians(1)) {
        float x = outerRadius * cos(angle);
        float y = -outerRadius * sin(angle);
        vertex(x, y);
      }
      for (float angle = endAngle; angle >= startAngle; angle -= radians(1)) {
        float x = innerRadius * cos(angle);
        float y = -innerRadius * sin(angle);
        vertex(x, y);
      }
      endShape(CLOSE);

      // Optional: Draw distance text
      fill(255);
      textSize(12);
      textAlign(CENTER);
      float labelX = pixelDist * cos(radians(a));
      float labelY = -pixelDist * sin(radians(a));
      text(int(d) + "cm", labelX, labelY - 15);
    }
  }

  popMatrix();
}

void drawText() {
  pushMatrix();

  fill(0);
  noStroke();
  rect(0, height - height * 0.0648f, width, height);
  fill(98, 245, 31);
  textSize(25);
  text("10cm", width - width * 0.3854f, height - height * 0.0833f);
  text("20cm", width - width * 0.281f, height - height * 0.0833f);
  text("30cm", width - width * 0.177f, height - height * 0.0833f);
  text("40cm", width - width * 0.0729f, height - height * 0.0833f);

  textSize(40);
  text("N_Tech", width - width * 0.875f, height - height * 0.0277f);
  text("Angle: " + iAngle, width - width * 0.48f, height - height * 0.0277f);
  text("Distance: ", width - width * 0.26f, height - height * 0.0277f);

  if (iDistance <= 40) {
    text("        " + iDistance + " cm", width - width * 0.225f, height - height * 0.0277f);
  } else {
    text("Out of Range", width - width * 0.225f, height - height * 0.0277f);
  }

  textSize(25);
  fill(98, 245, 60);

  String[] angles = { "30", "60", "90", "120", "150" };
  int[] angleValues = { 30, 60, 90, 120, 150 };
  float[] rotations = { -60, -30, 0, 30, 60 };

  for (int i = 0; i < angles.length; i++) {
    resetMatrix();
    translate((width - width * 0.5f) + width / 2 * cos(radians(angleValues[i])),
              (height - height * 0.09f) - width / 2 * sin(radians(angleValues[i])));
    rotate(radians(-rotations[i]));
    text(angles[i], 0, 0);
  }

  popMatrix();
}
