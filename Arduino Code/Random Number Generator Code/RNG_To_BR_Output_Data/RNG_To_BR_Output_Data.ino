// This code requests a number from the user, then mathematically operates on the number 
// until a desired "randomly" generated number has been reached. The first two digits 
// of the numbers are taken and outputted by the Arduino through a digital PWM pin.

int i;
unsigned long b;
unsigned long a;
unsigned long a1;
unsigned long a2;
unsigned long a3;

const int LIST_SIZE = 100; // Number of values to generate (100 = about 10 seconds)
unsigned long numberList[LIST_SIZE]; // Store generated numbers
float formattedList[LIST_SIZE]; // Store extracted first two digits with decimal point

const int outputPin = 9; // Digital output pin
float timeStep = 0.09788; // Time step between outputs in seconds

void setup() {
  Serial.begin(9600);
  pinMode(outputPin, OUTPUT); // Set output pin as an output
  Serial.println("Generate random numbers based on user input");
}

void loop() {
  Serial.println("Please enter a number: ");

  while (Serial.available() == 0) { // Wait for input
  }

  int user_Input = Serial.parseInt();
  
  Serial.println("Number Entered: ");
  Serial.println(user_Input);
  Serial.println("Generating numbers...");

  i = 0;
  b = 2;

  while (i < LIST_SIZE) {
    if (b > 9999) {
      b = b / 100;
    }

    // Nonlinear transformations for better randomness
    b = (b << 3) ^ (b >> 2) ^ (a3 & 0xF);
    a = ((user_Input * 7919) + (b * 65537)) % 100000;
    a1 = a * 5;
    a2 = a1 + 2;
    a3 = (a2 ^ b) + (a1 % 73); // More complex variation

    numberList[i] = a3; // Store number in list

    // Extract first two digits
    unsigned long temp = a3;
    while (temp >= 100) {
      temp /= 10;
    }
    formattedList[i] = temp / 10.0; // Convert to decimal format (e.g., 12 -> 1.2)

    b = a3;
    i += 1;
  }

  Serial.println("\nTime (s) \t Voltage (V)");
  
  // Output values through the digital pin with timestamps
  float currentTime = 0.0;
  
  for (int j = 0; j < LIST_SIZE; j++) {
    int pwmValue = formattedList[j] * 25.5; // Scale 0-10V to 0-255 for PWM
    
    // Print time and voltage in tab-separated format
    Serial.print(currentTime, 5); // Print time with 5 decimal places
    Serial.print("\t");
    Serial.println(formattedList[j], 8); // Print voltage with high precision
    
    analogWrite(outputPin, pwmValue); // Send PWM signal
    delay(40);  // Output for 39ms, make sure initial condition is read
    //not sure if it needs to be turned off inbetween changes yet
    //analogWrite(outputPin, 0); // Turn off
    //delay(1); // cut off between initial conditions? 

    currentTime += timeStep; // Increment time
  }

  Serial.println("Output sequence complete.");
  
  delay(1000);
  Serial.println("__________________________________________");

  // Wait for user to press ENTER before restarting
  Serial.println("Press ENTER to restart...");
  while (Serial.available() == 0) { 
  }  
  while (Serial.available() > 0) { 
    Serial.read(); // Clear buffer after pressing ENTER
  }
}
