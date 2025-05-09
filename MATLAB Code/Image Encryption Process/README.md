# MATLAB Code

This directory contains all MATLAB scripts developed and used for the image encryption process, encryption testing, and initial condition generation from physical chaotic signals.

The content is divided into two main subfolders:

---

## 📁 Image Encryption Process

This section includes all MATLAB code developed to perform encryption and decryption of images using chaotic signals. The code is structured according to image resolution.

---

### 🔹 `128x128 Image Code`

Contains four versions of the encryption process tailored for 128×128 pixel images.

* `Image_encryption`
  Performs encryption using the raw chaotic signal directly.

* `Encryption_Testing_FilteredSignal_NIST_ENT`
  Filters the chaotic signal before applying encryption. Also includes tools for entropy and randomness evaluation via NIST and ENT metrics.

* `Encryption_Testing_FilteredSignal_NIST_ENT_Quantisation`
  Extends the above by quantising the filtered signal before encryption, improving bit-level uniformity.

---

### 🔹 `256x256 Image Code`

Contains five versions of the encryption process tailored for 256×256 images, including standardised testing.

* `Image_encryption_AttemptX` (where X = 1 to 4, etc.)
  Represents different development stages of image encryption using raw signals. Each attempt contains minor or major changes to the encryption algorithm.

* `Encryption_Testing_FilteredSignal_NIST_ENT`
  Similar to the 128×128 version but adapted for higher resolution, this version includes signal filtering before encryption and standard randomness testing (NIST/ENT).

---

## 📁 Initial Condition Generator

This subfolder contains a single MATLAB script used to initialise the encryption algorithm with a user-defined password.

### `Generate_Initial_Conditions.m`

**Purpose**:
Generates a 256×256 matrix of initial conditions (values between 1V and 5V) derived from a numeric password. These conditions are essential to seed the chaotic process that underpins encryption.

**Features**:

* Takes an 8-digit password as input.
* Converts the password to a numeric seed for random number generation.
* Produces initial conditions and corresponding switching times.
* Saves the result as a tab-delimited `.txt` file (`initial_conditions.txt`) with time-voltage pairs, based on a 97.88 ms timestep.
