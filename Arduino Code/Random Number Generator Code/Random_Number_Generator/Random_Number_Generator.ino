int i;
unsigned long b;
unsigned long a;
unsigned long a1;
unsigned long a2;
unsigned long a3;
unsigned long a4;
 
void setup() {
  Serial.begin(9600);

  Serial.println("Generate random numbers based off user input");
}

void loop() {
  
  Serial.println("Please enter a number: ");

  while (Serial.available() == 0) { //waits till there is an input
  }

  int user_Input = Serial.parseInt();
  
  Serial.println("Number Entered: ");
  Serial.println(user_Input);
  Serial.println("Generating numbers...");

//  Serial.println("Enter amount of numbers you want to generate: ");
//
//  while (Serial.available() == 0) { //waits till there is an input
//  }
//
//  int user_Input2 = Serial.parseInt();
//  
//  Serial.println("Number Entered: ");
//  Serial.println(user_Input2);
//  Serial.println("Generating numbers...");

  i = 1;
  b = 2;

  while(i < 15){
   b = b/5; 
   //Serial.println(user_Input);
   a = (user_Input + 536)+ b;
   //Serial.println(a);
   a1 = a * 5;
   //Serial.println(a1);
   a2 = a1 + 2;
   //Serial.println(a2);
   a3 = a2 - b+4;
   Serial.println(a3);
   b = a3;
   i += 1;
  }

  delay(1000);
  Serial.println(" ");
  Serial.println("__________________________________________");
  
}
