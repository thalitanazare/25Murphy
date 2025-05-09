int i;
unsigned long b;
unsigned long a;
unsigned long a1;
unsigned long a2;
unsigned long a3;

const int LIST_SIZE = 250;
unsigned long numberList[LIST_SIZE];
float formattedList[LIST_SIZE];

const int outputPin = 9;
float timeStep = 0.03;

void setup() {
  Serial.begin(9600);
  pinMode(outputPin, OUTPUT);
  Serial.println("Generate random numbers based on user input");
}

void loop() {
  Serial.println("Please enter a number: ");

  while (Serial.available() == 0) {
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

    // More uniform randomness
    b = (b * 1103515245 + 12345) & 0xFFFFFFFF;
    a = ((user_Input * 7919) + (b * 65537)) % 100000;
    a1 = a * 5;
    a2 = a1 + 2;
    a3 = (a2 ^ b) + (a1 % 73);

    numberList[i] = a3;

    // Extract last two digits instead of first
    formattedList[i] = (a3 % 100) / 10.0;

    b = a3;
    i += 1;
  }

  Serial.println("\nTime (s) \t Voltage (V)");
  
  float currentTime = 0.0;
  
  for (int j = 0; j < LIST_SIZE; j++) {
    int pwmValue = map(formattedList[j] * 10, 0, 99, 0, 255);
    
    Serial.print(currentTime, 5);
    Serial.print("\t");
    Serial.println(formattedList[j], 8);
    
    analogWrite(outputPin, pwmValue);
    //delay(100);  // Allow proper voltage settling

    currentTime += timeStep;
  }

  Serial.println("Output sequence complete.");
  delay(1000);
  Serial.println("__________________________________________");

  Serial.println("Press ENTER to restart...");
  while (Serial.available() == 0) { 
  }  
  while (Serial.available() > 0) { 
    Serial.read();
  }
}
