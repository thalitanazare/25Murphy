const int analogPin = A0;  // Define the analog pin for voltage measurement
const int sampleInterval = 1; // Sampling time in milliseconds
bool recording = false;
unsigned long startTime = 0;
unsigned long lastSampleTime = 0;

void setup() {
    Serial.begin(115200); // Start serial communication at 115200 baud
}

void loop() {
    unsigned long currentTime = millis();  // Get current time in milliseconds
    
    if (currentTime - lastSampleTime >= sampleInterval) { // Ensure periodic sampling
        lastSampleTime = currentTime;
        int sensorValue = analogRead(analogPin);  // Read the analog input
        float voltage = sensorValue * (5.0 / 1023.0);  // Convert to voltage (assuming 5V reference)
        
        if (!recording && voltage >= 2.0) {
            recording = true;
            startTime = currentTime;  // Reset time to zero when trigger is detected
        }
        
        if (recording) {
            unsigned long elapsedTime = currentTime - startTime;
            if (elapsedTime <= 1600) {
                Serial.print(elapsedTime);
                Serial.print(",");
                Serial.println(voltage);  // Send elapsed time and voltage
            } else {
                recording = false;  // Reset for next trigger
            }
        }
    }
}
