const int analogPin = A0;  // Define the analog pin for voltage measurement

void setup() {
    Serial.begin(115200); // Start serial communication at 115200 baud
}

void loop() {
  unsigned long currentTime = millis();  // Get current time in milliseconds
  int sensorValue = analogRead(analogPin);  // Read the analog input
  float voltage = sensorValue * (5.0 / 1023.0);  // Convert to voltage (assuming 5V reference)
    
  //Serial.print(currentTime);
  //Serial.print(",");
  Serial.println(voltage);  // Send voltage to Serial Plotter
  //delay(10);  // Small delay for stable plotting
  
}
