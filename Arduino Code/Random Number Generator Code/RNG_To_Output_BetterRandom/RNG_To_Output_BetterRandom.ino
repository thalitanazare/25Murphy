//This code requests a number from the user, then mathematically operates on the number until
//a desired "randomly" generated numbers have been reached. The first two digits of the numbers are
//taken and outputted by the arduino through a digital pwm pin.

int i;
unsigned long b;
unsigned long a;
unsigned long a1;
unsigned long a2;
unsigned long a3;

const int LIST_SIZE = 100; // Number of values to generate
unsigned long numberList[LIST_SIZE]; // Store generated numbers
float formattedList[LIST_SIZE]; // Store extracted first two digits with decimal point

const int outputPin = 9; // Digital output pin

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


  // Print generated numbers
  Serial.println("\nGenerated Numbers:");
  for (int j = 0; j < LIST_SIZE; j++) {
    Serial.println(numberList[j]);
  }

  // Print extracted first two digits with decimal point
  Serial.println("\nFormatted List (First 2 Digits with Decimal):");
  for (int j = 0; j < LIST_SIZE; j++) {
    Serial.println(formattedList[j], 2); // Print with 2 decimal places
  }

  Serial.println("\nOutputting values through pin 9...");
  
  // Output values through the digital pin
  for (int j = 0; j < LIST_SIZE; j++) {
    int pwmValue = formattedList[j] * 25.5; // Scale 0-10V to 0-255 for PWM
    Serial.println(pwmValue); //check in proper format for voltage output 
    analogWrite(outputPin, pwmValue); // Send PWM signal
    delay(1);  // Output for 1ms
    analogWrite(outputPin, 0); // Turn off
    delay(40); // Wait 40ms before next number
  }

  Serial.println("Output sequence complete.");
  
  delay(1000);
  Serial.println("__________________________________________");
}
