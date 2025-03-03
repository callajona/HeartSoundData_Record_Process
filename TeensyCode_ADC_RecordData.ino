/**************************************************************************
    Creator: Jon Calladine
       Date: 03/03/2025
**************************************************************************

  Code for logging microphone data.
  Uses onboard ADC to convert microphone signal to Digial signal for storage. 

  Button to activate recording
  LED to indicate recording in progress

**************************************************************************/

// Define Pin numbers
const int buttonPin = 34;  // button pin
const int ledPin = 29;    // LED pin 
const int analogIn = 0; // Analouge input pin (A0)

// Init Variables
int buttonState = 1;  // variable for reading button status
  // PUR used (state = 0 when button pressed)
float analogVal = 0; // Variable for recording analouge input

// Define sampling rate
float samplingRate = 2000; // Sampling rate in Hz
float sampleingPeriod = (1 / samplingRate); // period in s
float samplingDelay = (sampleingPeriod * 1000000); // Period in us as the sampling delay
int recordLength = 10; // How many seconds to record for
int noLoops = recordLength / sampleingPeriod; // Define the number of loops to get to desired record length

// Define ADC resolution
int resolution = 12; // Value for the bit-depth of the ADC - May not work for Teensy 4.1

void setup() {
  // initialise peripheralst
  pinMode(ledPin, OUTPUT); // LED as an output
  pinMode(buttonPin, INPUT); // Button as an Input

  // Set Baud Rate for Serial Monitor
  Serial.begin(115200); // Define Baud rate for 

  // Set ADC resolution
  analogReadResolution(resolution);

  /*
  // Display calculated values to the terminal
  Serial.print("Sampling Period: ");
  Serial.print(sampleingPeriod,4);
  Serial.print(", Sampling Delay: ");
  Serial.print(samplingDelay);
  Serial.print(", Recording Length: ");
  Serial.print(recordLength);
  Serial.print(", Number of Loops: ");
  Serial.println(noLoops);
  */
}

void loop() {
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  
  if (buttonState == LOW) {
    // Record 10s of Data
    // Toggle indicator LED high

    Serial.println("Voltage | Time"); // Header for data file

    digitalWrite(ledPin, HIGH); // Turn LED on

    // Collect Data for 10 seconds
    unsigned long startTime = millis();
    for (int i = 0; i < noLoops; i++) {
      analogVal = analogRead(0); // Read the analouge value

      Serial.print((analogVal / pow(2,resolution)) * 3.3,4); // Write voltage to terminal (4 decimal places)- 0 to 3.3V is the voltage range of ADC
      Serial.print(","); // For creating CSV
      Serial.println(i*sampleingPeriod,4); // Write time to terminal - "println" to create new line
      delayMicroseconds(samplingDelay); // Delay by one period 
    }
    unsigned long stopTime = millis();
    unsigned long ellapsedTime = (stopTime - startTime); // Ellapsed time in ms
    Serial.print("Ellapsed Time: ");
    Serial.println(ellapsedTime); 
  } 
  else {
    digitalWrite(ledPin, LOW); // Turn LED off
  }
}
