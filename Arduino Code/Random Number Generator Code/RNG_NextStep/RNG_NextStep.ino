int i;
unsigned long b;
unsigned long a;
unsigned long a1;
unsigned long a2;
unsigned long a3;
unsigned long a4;

const int LIST_SIZE = 15; // Number of values to generate
unsigned long numberList[LIST_SIZE]; // Store generated numbers
float formattedList[LIST_SIZE]; // Store extracted first two digits with decimal point

void setup() {
  Serial.begin(9600);
  Serial.println("Generate random numbers based off user input");
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
    if (b > 9999){
      b = b/100;
    }
    else;
    b = b / 5; 
    a = (user_Input + 536) + b;
    a1 = a * 5;
    a2 = a1 + 2;
    a3 = a2 - b + 4;
    
    numberList[i] = a3; // Store number in list
    
    // Extract first two digits
    unsigned long temp = a3;
    while (temp >= 100) {
      temp /= 10; // Get first two digits
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

  delay(1000);
  Serial.println(" ");
  Serial.println("__________________________________________");
}
