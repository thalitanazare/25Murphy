# 256x256 Image Code

This folder contains MATLAB scripts used to encrypt and decrypt **256×256 grayscale images** using chaotic signals. The folder includes both experimental encryption attempts and standardised testing procedures. The scripts are split into two categories:

---

## 🔹 Main Scripts

These five files implement different versions of chaotic image encryption using raw or filtered signals.

### 📄 `Image_Encryption_Attempt1.m`

* **Basic implementation** using a chaotic signal directly.
* Applies XOR encryption without any permutation or filtering.
* Simplest demonstration of chaotic-based image encryption and decryption.

---

### 📄 `Image_Encryption_Attempt2.m`

* **Improved version** with permutation and XOR stages.
* Uses the chaotic sequence to both shuffle pixels and encrypt them.
* Suitable for reproducible encryption experiments.

---

### 📄 `Image_Encryption_Attempt2_256x256.m`

* A refined version for **256×256 images**.
* Emphasises proper resizing, permutation logic, and encryption consistency.
* Ensures decryption process fully reverses the operations applied.

---

### 📄 `Image_Encryption_Attempt2_256x256_Filtered.m`

* Incorporates **filtering** of the chaotic signal in a defined voltage range (e.g., \[-1.5V, 1V]).
* Uses **interpolation** if signal length is insufficient.
* Enhances encryption robustness and addresses hardware-induced noise.

---

### 📄 `Image_Encryption_Attempt2_256x256_Filtered2.m`

* Similar to the previous version but with **strict trimming** instead of interpolation.
* Ensures perfect match of encryption/decryption samples.
* Focuses on experimental repeatability.

---

## 📁 Encryption Testing

This subfolder contains two scripts designed to test the randomness and quality of encrypted images using **NIST** and **ENT**-inspired metrics.

### 📄 `Encryption_Testing_NIST_ENT.m`

* Encrypts and decrypts using the **raw chaotic signal**.
* Evaluates randomness via:

  * Bit frequency
  * Runs test
  * Shannon entropy
  * Chi-square distribution
  * Serial correlation
* Includes visual outputs and histograms for analysis.

---

### 📄 `Encryption_Testing_FilteredSignal_NIST_ENT.m`

* Encrypts and decrypts using a **filtered chaotic signal**.
* Same statistical analysis pipeline as the raw version.
* Useful for comparing the effect of signal conditioning on encryption quality.
