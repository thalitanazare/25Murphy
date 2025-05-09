# Random Number Generator Code

This folder contains all versions of the Arduino code developed to generate random numbers from physical chaotic circuits. Each file represents an iteration or variation of the approach used.

### File Descriptions

* **`Random_Number_Generator.ino`**
  Initial version of the chaotic random number generator implementation.

* **`RNG_NextStep.ino`**
  Experimental version exploring the next iteration step logic for improved randomness extraction.

* **`RNG_To_BR_Output_Data.ino`**
  Exports the generated random data to the circuit's output switch (labelled "BR").

* **`RNG_To_BR_Output_Data2.ino`**
  Slightly modified version of the above, likely with parameter or timing adjustments.

* **`RNG_To_BR_Output_Data3.ino`**
  Third iteration in the output-exporting sequence, testing refinements in data capture or timing.

* **`RNG_To_BR_Output_Data4.ino`**
  Fourth and more stable version for exporting data to the output switch. Considered one of the main versions used.

* **`RNG_To_BR_Output_Data4_TwoCircuits.ino`**
  Modified version of `Data4` designed to operate with **two chaotic circuits** running simultaneously.

* **`RNG_To_Output.ino`**
  A simpler version that focuses only on exporting generated numbers to the digital output.

* **`RNG_To_Output_BetterRandom.ino`**
  Enhanced version of the above with improved randomness extraction techniques.
