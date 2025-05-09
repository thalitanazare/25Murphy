const int analogPin1 = A0;  // First analog pin
const int analogPin2 = A1;  // Second analog pin

void setup() {
    Serial.begin(115200); // Start serial communication at 115200 baud
}

void loop() {
    unsigned long currentTime = millis();  // Get current time in milliseconds
    int sensorValue1 = analogRead(analogPin1);  // Read first analog input
    int sensorValue2 = analogRead(analogPin2);  // Read second analog input
    
    float voltage1 = sensorValue1 * (5.0 / 1023.0);  // Convert first reading to voltage
    float voltage2 = sensorValue2 * (5.0 / 1023.0);  // Convert second reading to voltage
    
    //Serial.print(currentTime);
    //Serial.print(",");
    Serial.print(voltage1);
    Serial.print(",");
    Serial.println(voltage2);  // Send time and both voltage values
    
    delay(10);  // Small delay for stable plotting
}
