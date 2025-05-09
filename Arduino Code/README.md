# Arduino Code

This folder contains all Arduino code developed for the project. It is divided into two main sections:

---

## `Random Number Generator Code`

This subfolder includes all versions of the Arduino code used to implement the chaotic random number generator.

* Files with `"To_Output"` in the name also export the generated numbers to a digital output (switch) on the physical circuit.
* The file containing `"TwoCircuits"` was used in tests where two chaotic circuits were operated simultaneously.

---

## `Voltage Reading Code`

This subfolder includes all Arduino scripts used to read voltage signals from the chaotic circuit.

* The file `"ReadVoltageTest"` reads all output voltages from the circuit continuously.
* Files with `"Range"` in the name only begin voltage readings after the first spike is injected into the circuit.
* The file containing `"TwoCircuits"` was used in experiments involving simultaneous monitoring of two chaotic circuits.

