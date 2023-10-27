import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
int detectionTimer; // Timer for face detection
boolean faceDetected; // Flag indicating if a face is currently detected
int holdDuration = 3 * 60; // 3 seconds (assuming 60 frames per second)
float movementThreshold = 200; // Adjust the threshold based on your needs

// Variables to store the previous position of the face rectangle
float prevX, prevY, prevWidth, prevHeight;

// Variables for the enemy (red rectangle)
float enemyX, enemyY, enemySpeed;

void setup() {
  size(1920, 1080, P2D);
  video = new Capture(this, 1920, 1080);
  // set up OpenCV
  opencv = new OpenCV(this, 1920, 1080);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  detectionTimer = 0;
  faceDetected = false;
  prevX = prevY = prevWidth = prevHeight = 0;

  // Initialize enemy position and speed
  enemyX = random(width);
  enemyY = random(height);
  enemySpeed = 2; // Adjust the speed as needed
}

void draw() {
  opencv.loadImage(video);

  image(video, 0, 0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);

  // Detect faces from the video frame
  Rectangle[] faces = opencv.detect();

  // If no faces are detected, reset the timer
  if (faces.length == 0) {
    detectionTimer = 0;
    faceDetected = false;
  }

  // Draw a rect around each face
  for (int i = 0; i < faces.length; i++) {
    float x = faces[i].x;
    float y = faces[i].y;
    float width = faces[i].width;
    float height = faces[i].height;

    // Check if the movement of the face rectangle is below the threshold
    if (abs(x - prevX) < movementThreshold && abs(y - prevY) < movementThreshold &&
      abs(width - prevWidth) < movementThreshold && abs(height - prevHeight) < movementThreshold) {
      // Update the timer when the movement is below the threshold
      detectionTimer++;
    } else {
      // Reset the timer when the movement is above the threshold
      detectionTimer = 0;
    }

    // Draw a rect around each face centered on the face
    rectMode(CENTER);
    rect(x + width / 2, y + height / 2, width, height);

    // Update the previous position
    prevX = x;
    prevY = y;
    prevWidth = width;
    prevHeight = height;

    // Update the flag if a face is detected
    faceDetected = true;
  }

  // Draw the enemy (red rectangle)
  fill(255, 0, 0); // Red fill color
  rect(enemyX, enemyY, 50, 50); // Adjust the size as needed

  // Update the enemy position
  if (faceDetected) {
    // Follow the face
    float deltaX = prevX - enemyX;
    float deltaY = prevY - enemyY;
    float distance = dist(enemyX, enemyY, prevX, prevY);
    enemyX += (deltaX / distance) * enemySpeed;
    enemyY += (deltaY / distance) * enemySpeed;
  }

  // Display the counter on the screen in red
  fill(255, 0, 0); // Set the fill color to red
  textSize(24);
  text("Hold still: " + (holdDuration - detectionTimer) / 60 + " seconds", 20, 30);

  // If the center of the red rectangle is within the bounds of the face, end the game and print "You Lose"
  if (faceDetected && enemyX > prevX && enemyX < prevX + prevWidth && enemyY > prevY && enemyY < prevY + prevHeight) {
    println("You Lose");
    exit();
  }

  // If a face is continuously detected for the hold duration, close the sketch and print "You Win"
  if (faceDetected && detectionTimer >= holdDuration) {
    println("You Win");
    exit();
  }
}

void captureEvent(Capture c) {
  c.read();
}
