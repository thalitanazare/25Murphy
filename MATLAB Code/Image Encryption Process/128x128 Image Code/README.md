# 128x128 Image Code

This folder contains MATLAB scripts developed to encrypt and decrypt grayscale images of size **128×128** pixels using chaotic signals. Different versions of the code test various approaches, such as direct encryption, filtering, and quantisation of the chaotic signal.

---

### 📄 `Image_Encryption_Attempt2_128x128.m`

* **Description**: Basic implementation of image encryption using the raw chaotic signal.
* **Approach**:

  * Loads a chaotic signal and normalises it to the range \[0, 255].
  * Uses the signal to generate a permutation of the image pixels.
  * Applies bitwise XOR between permuted image and chaotic sequence.
  * Performs decryption using a second chaotic signal, applying reverse XOR and inverse permutation.
* **Use case**: Proof of concept for chaotic encryption with minimal signal preprocessing.

---

### 📄 `Encryption_Testing_FilteredSignal_NIST_ENT_128x128.m`

* **Description**: Adds **signal filtering** before encryption for noise reduction and improved entropy.
* **Approach**:

  * Filters the chaotic signal to a valid voltage range (e.g., -1.5V to 2.5V).
  * Normalises the filtered signal and converts it to integers \[0, 255].
  * Encrypts and decrypts a 128×128 image as in previous versions.
  * Includes quality assessment and plots difference images for validation.
* **Use case**: Enhances encryption consistency by excluding out-of-band signal artefacts.

---

### 📄 `Encryption_Testing_FilteredSignal_NIST_ENT_128x128_Quantised.m`

* **Description**: Builds on the previous version by **quantising** the chaotic signal after filtering.
* **Approach**:

  * Applies discrete quantisation (e.g., to 0.1V steps) after filtering.
  * Improves uniformity of the signal used in encryption.
  * Maintains compatibility with NIST/ENT testing protocols.
* **Use case**: Useful when signal precision must be constrained or digitalised for hardware implementation.

---

### 📄 `Encryption_Testing_FilteredSignal_NIST_ENT_128x128_Quantised_2.m`

* **Description**: A refined version of the previous script with stricter input validation and signal trimming.
* **Approach**:

  * Adjusts quantisation, filtering, and normalisation for robustness.
  * Enforces strict equality in the number of chaotic samples for both encryption and decryption.
  * Adds improved plotting for debugging and side-by-side signal analysis.
* **Use case**: More robust and controlled experimental setup for reproducible encryption studies.

