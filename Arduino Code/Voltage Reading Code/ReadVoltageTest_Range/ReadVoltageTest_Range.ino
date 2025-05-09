const int analogPin = A0;  // Define the analog pin for voltage measurement
bool recording = false;
unsigned long startTime = 0;

void setup() {
    Serial.begin(115200); // Start serial communication at 115200 baud
}

void loop() {
    unsigned long currentTime = millis();  // Get current time in milliseconds
    int sensorValue = analogRead(analogPin);  // Read the analog input
    float voltage = sensorValue * (5.0 / 1023.0);  // Convert to voltage (assuming 5V reference)
    
    if (!recording && voltage >= 2.0) {
        recording = true;
        startTime = currentTime;
    }
    
    if (recording) {
        if (currentTime - startTime <= 900) {
            Serial.println(voltage);  // Send voltage to Serial Plotter
        } else {
            recording = false;  // Reset for next trigger
        }
    }
}
