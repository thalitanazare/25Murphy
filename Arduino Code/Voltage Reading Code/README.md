# Voltage Reading Code

This folder contains various versions of Arduino code used to read and monitor voltage outputs from the physical chaotic circuit. These readings are essential for observing circuit behaviour, detecting spikes, and triggering encryption or data collection events.

---

### File Descriptions

* **`ReadVoltageTest.ino`**
  Continuously reads the voltage from a single analog pin (`A0`) and prints the measured value to the serial monitor.

  * Sampling is done as fast as possible (optionally configurable delay).
  * Voltage is calculated assuming a 5V reference using:

    ```cpp
    float voltage = sensorValue * (5.0 / 1023.0);
    ```
  * Designed for basic real-time monitoring and serial plotting.

---

* **`ReadVoltageTest_Range.ino`**
  Extends the basic version by adding a trigger mechanism:

  * Only begins reading voltage **after** detecting a spike or threshold condition.
  * Allows focused measurement of transient activity.
  * Useful in experiments requiring synchronisation with a circuit event.

---

* **`ReadVoltageTest_RangeTime.ino`**
  Builds upon `Range` version by incorporating timing logic:

  * Begins reading after a threshold spike.
  * Additionally, it restricts the duration of data collection using `millis()` timing.
  * Designed for time-bound experiments or fixed-duration data capture windows.

---

* **`ReadVoltageTest_RangeTimeAttempt2.ino`**
  Second attempt at improving the `RangeTime` logic:

  * Likely includes refinements to spike detection or timing control.
  * Improved reliability in initiating and stopping the reading cycle.
  * Aimed at cleaner and more consistent signal capture sessions.

---

* **`ReadVoltageTest_TwoCircuits.ino`**
  Extends voltage reading to handle **two chaotic circuits** simultaneously.

  * Reads from two analog pins (e.g., `A0` and `A1`).
  * Outputs dual voltage readings for comparative analysis or dual-circuit experiments.
  * Synchronised logging or visualisation of both signals.

