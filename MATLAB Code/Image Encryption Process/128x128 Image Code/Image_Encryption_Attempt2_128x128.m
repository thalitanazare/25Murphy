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
image_filename = 'test_image_128x128.jpg'; % Change this to your image file
original_img = imread(image_filename);
original_img = rgb2gray(original_img); % Convert to grayscale (if needed)
original_img = imresize(original_img, [128, 128]); % Resize to 128x128

% Display original image
figure;
imshow(original_img);
title('Original Image');

% Convert image to 1D array
img_vector = original_img(:);

% Ensure chaotic sequence is the same length as image pixels
N_pixels = numel(img_vector);
chaotic_sequence_enc = chaotic_signal_enc(1:N_pixels); % Truncate to match pixel count

%% Permutation Process (Pixel Diffusion)
% Generate a permutation order based on the chaotic sequence
[~, perm_order] = sort(chaotic_sequence_enc); % Sorting chaotic signal for row permutation
permuted_img = original_img(perm_order); % Permute pixels

% Encrypt the Permuted Image
encrypted_vector = bitxor(permuted_img(:), uint8(chaotic_sequence_enc)); 
encrypted_img = reshape(encrypted_vector, [128, 128]); % Reshape to 128x128

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
% Reverse the XOR operation
decrypted_vector = bitxor(encrypted_vector, uint8(chaotic_sequence_dec)); 

% Reverse the permutation
[~, reverse_perm_order] = sort(perm_order); % Correct reverse permutation order
decrypted_img_vector = decrypted_vector(reverse_perm_order); % Undo permutation

% Reshape to 2D image
decrypted_img = reshape(decrypted_img_vector, [128, 128]);

% Display decrypted image
figure;
imshow(decrypted_img);
title('Decrypted Image');

%% Save decrypted image
imwrite(decrypted_img, 'decrypted_image.png');

fprintf('Decryption completed successfully!\n');

