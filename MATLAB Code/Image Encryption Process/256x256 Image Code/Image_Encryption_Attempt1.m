clc; clear; close all;
%%
% Load LTSpice exported chaotic signal
%filename = 'chaotic_signal.txt'; % Change this to your actual file name
filename = 'test.txt';

% Read the data (tab-delimited text file)
data = readmatrix(filename);

% Extract time and signal values
time = data(:,1);   % First column is time
signal = data(:,2); % Second column is the chaotic signal

% Compute number of samples
num_samples = length(time);

% Display results
fprintf('Number of samples in the chaotic signal: %d\n', num_samples);

% Plot the chaotic signal
figure;
plot(time, signal, 'b');
xlabel('Time (s)');
ylabel('Chaotic Signal');
title('Chaotic Signal from LTSpice');
grid on;

%% Step 1: Load Chaotic Signal from LTSpice
filename = 'chaotic_signal.txt'; % Change this to your LTSpice file
data = readmatrix(filename);

time = data(:,1);   % First column: time values
chaotic_signal = data(:,2); % Second column: chaotic values

% Normalize chaotic signal to range [0, 255]
chaotic_signal = abs(chaotic_signal); % Ensure positive values
chaotic_signal = mod(round(chaotic_signal * 255 / max(chaotic_signal)), 256); % Scale and mod

% Plot the chaotic signal
figure;
plot(time, chaotic_signal, 'r');
title('Chaotic Signal Used for Encryption');
xlabel('Time (s)');
ylabel('Normalized Chaotic Signal');
grid on;

%% Step 2: Load and Process Image
image_filename = 'test_image.jpg'; % Change this to your image file
original_img = imread(image_filename);
original_img = rgb2gray(original_img); % Convert to grayscale (if needed)
original_img = imresize(original_img, [256, 256]); % Resize to 256x256

% Display original image
figure;
imshow(original_img);
title('Original Image');

% Convert image to 1D array
img_vector = original_img(:);

% Ensure chaotic sequence is the same length as image pixels
N_pixels = numel(img_vector);
chaotic_sequence = chaotic_signal(1:N_pixels); % Truncate or use a longer signal

%% Step 3: Encrypt the Image
encrypted_vector = bitxor(img_vector, uint8(chaotic_sequence)); % XOR operation
encrypted_img = reshape(encrypted_vector, [256, 256]); % Reshape back to 2D

% Display encrypted image
figure;
imshow(encrypted_img);
title('Encrypted Image');

%% Step 4: Decrypt the Image
decrypted_vector = bitxor(encrypted_vector, uint8(chaotic_sequence)); % XOR again
decrypted_img = reshape(decrypted_vector, [256, 256]); % Reshape to original size

% Display decrypted image
figure;
imshow(decrypted_img);
title('Decrypted Image');

%% Save images
imwrite(encrypted_img, 'encrypted_image.png');
imwrite(decrypted_img, 'decrypted_image.png');

fprintf('Encryption and decryption completed successfully!\n');
