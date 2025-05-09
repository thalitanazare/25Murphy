# Test Signals

This folder contains the signal data used in the encryption and decryption processes. The data is divided into two categories based on its source: **Practical** and **Simulated**.

Each pair of signals corresponds to an encryption/decryption session, where one signal is used for encrypting an image and the other for decrypting it.

---

## 📁 Practical

These signals were recorded from **physical analogue chaotic circuits**. Each pair is linked to ensure consistency between encryption and decryption.

* `Test Signal 1` ⟷ `Test Signal 2`

  * **Test Signal 1** was used for encryption.
  * **Test Signal 2** was used for decryption.

* `Test Signal 3` ⟷ `Test Signal 4`

  * **Test Signal 3** was used for encryption.
  * **Test Signal 4** was used for decryption.

These files reflect the behaviour of the real-world hardware implementation of the chaotic system.

---

## 📁 Simulated

These signals were generated from **LTSpice simulations** of the chaotic circuit. They follow the same logic of pairing:

* `chaotic_signal` ⟷ `chaotic_signal2`
* `chaotic_signalR1` ⟷ `chaotic_signalR2`
* `chaotic_rangeR1` ⟷ `chaotic_rangeR2`
* `chaotic_signal1_256` ⟷ `chaotic_signal2_256`
* `a_0.83_1` ⟷ `a_0.83_2`

Each pair was generated under specific simulation conditions, and the naming convention typically reflects:

* Parameter variations (e.g., range or amplitude)
* Resolution (e.g., 256 for 256×256 image experiments)

These files provide a reproducible digital counterpart for validation, performance testing, and comparative analysis with real-world data.
