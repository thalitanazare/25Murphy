clc; clear; close all;
%%
% Load LTSpice exported chaotic signal for encryption
filename_enc = 'chaotic_signal.txt'; % Change this to your encryption chaotic signal file
data_enc = readmatrix(filename_enc);

% Extract time and chaotic signal values
time_enc = data_enc(:,1);   
chaotic_signal_enc = data_enc(:,2); 

% Normalize chaotic signal to range [0, 255]
chaotic_signal_enc = abs(chaotic_signal_enc); 
chaotic_signal_enc = mod(round(chaotic_signal_enc * 255 / max(chaotic_signal_enc)), 256); 

% Compute number of samples
num_samples = length(time_enc);

% Display results
fprintf('Number of samples in the chaotic signal: %d\n', num_samples);


% Plot the chaotic signal used for encryption
figure;
plot(time_enc, chaotic_signal_enc, 'r');
title('Chaotic Signal Used for Encryption');
xlabel('Time (s)');
ylabel('Normalized Chaotic Signal');
grid on;

%% Load and Process Image
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
chaotic_sequence_enc = chaotic_signal_enc(1:N_pixels); % Truncate to match pixel count

%% Encrypt the Image
encrypted_vector = bitxor(img_vector, uint8(chaotic_sequence_enc)); 
encrypted_img = reshape(encrypted_vector, [256, 256]); 

% Display encrypted image
figure;
imshow(encrypted_img);
title('Encrypted Image');

%% Save encrypted image
imwrite(encrypted_img, 'encrypted_image.png');

fprintf('Encryption completed successfully!\n');

%% ========== Now Load Separate Chaotic Signal for Decryption ==========

% Load LTSpice exported chaotic signal for decryption
filename_dec = 'chaotic_signal2.txt'; % Change this to your decryption chaotic signal file
data_dec = readmatrix(filename_dec);

% Extract chaotic signal values
chaotic_signal_dec = data_dec(:,2); 

% Normalize chaotic signal to range [0, 255]
chaotic_signal_dec = abs(chaotic_signal_dec); 
chaotic_signal_dec = mod(round(chaotic_signal_dec * 255 / max(chaotic_signal_dec)), 256); 

% Ensure chaotic sequence is the same length as encrypted image pixels
chaotic_sequence_dec = chaotic_signal_dec(1:N_pixels); 

%% Decrypt the Image
decrypted_vector = bitxor(encrypted_vector, uint8(chaotic_sequence_dec)); 
decrypted_img = reshape(decrypted_vector, [256, 256]); 

% Display decrypted image
figure;
imshow(decrypted_img);
title('Decrypted Image');

%% Save decrypted image
imwrite(decrypted_img, 'decrypted_image.png');

fprintf('Decryption completed successfully!\n');
