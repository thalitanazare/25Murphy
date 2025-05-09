clc; clear; close all;

%% ========== Load LTSpice Exported Chaotic Signal for Encryption ==========
filename_enc = 'chaotic_signal.txt';
data_enc = readmatrix(filename_enc);

% Extract time and chaotic signal values
time_enc = data_enc(:,1);   
chaotic_signal_enc = data_enc(:,2); 

% **Filter chaotic signal in range [-1.5V, 1V]**
valid_indices = chaotic_signal_enc >= -1.5 & chaotic_signal_enc <= 1;
filtered_signal_enc = chaotic_signal_enc(valid_indices);
filtered_time_enc = time_enc(valid_indices);

% Ensure at least some valid data is present
if isempty(filtered_signal_enc)
    error('No valid values in the chaotic signal after filtering. Adjust filter range.');
end

% Expected number of samples
expected_samples = 256 * 256; % 65,536

% If too few samples, interpolate
if length(filtered_signal_enc) < expected_samples
    warning('Filtered chaotic signal has fewer values than required. Interpolating...');
    
    % Generate new sample positions
    interpolated_indices = linspace(1, length(filtered_signal_enc), expected_samples);
    
    % Interpolate signal
    filtered_signal_enc = interp1(1:length(filtered_signal_enc), filtered_signal_enc, interpolated_indices, 'linear');
    
    % Interpolate time values to match
    filtered_time_enc = interp1(1:length(filtered_time_enc), filtered_time_enc, interpolated_indices, 'linear');
end

% Ensure filtered signal is a column vector
filtered_signal_enc = filtered_signal_enc(:);

% Plot the chaotic signal with corrected lengths
figure;
plot(filtered_time_enc, filtered_signal_enc, 'r');
title('Filtered Chaotic Signal Used for Encryption');
xlabel('Time (s)');
ylabel('Normalized Chaotic Signal');
grid on;

%% ========== Load and Process Image ==========
image_filename = 'test_image.jpg';
original_img = imread(image_filename);
original_img = rgb2gray(original_img);
original_img = imresize(original_img, [256, 256]);

% **Display original image**
figure;
imshow(original_img);
title('Original Image');

% **Convert image to 1D column vector**
img_vector = original_img(:);
N_pixels = expected_samples; % 65,536

% **Ensure chaotic sequence has exactly 65,536 elements**
chaotic_sequence_enc = filtered_signal_enc(:); % Ensure it's a column vector

% **Generate a permutation order**
[~, perm_order] = sort(chaotic_sequence_enc);
permuted_img_vector = img_vector(perm_order); 

% **Encrypt the Permuted Image (Fix: Ensure uint8 Chaotic Sequence)**
encrypted_vector = bitxor(permuted_img_vector, uint8(mod(abs(chaotic_sequence_enc), 256)));

% **Ensure encrypted_vector is exactly 65,536 elements**
encrypted_vector = encrypted_vector(:); % Force column vector

% **Now reshape safely**
encrypted_img = reshape(encrypted_vector, [256, 256]); 

% **Display encrypted image**
figure;
imshow(encrypted_img);
title('Encrypted Image');

%% ========== Save Encrypted Image ==========
imwrite(encrypted_img, 'encrypted_image_256x256.png');
fprintf('Encryption completed successfully!\n');

%% ========== Load Separate Chaotic Signal for Decryption ==========
filename_dec = 'chaotic_signal2.txt';
data_dec = readmatrix(filename_dec);

% Extract chaotic signal values
chaotic_signal_dec = data_dec(:,2); 

% **Apply the same filtering range as encryption**
valid_indices_dec = chaotic_signal_dec >= -1.5 & chaotic_signal_dec <= 1;
filtered_signal_dec = chaotic_signal_dec(valid_indices_dec);

% **Ensure the same number of samples as encryption**
if length(filtered_signal_dec) < expected_samples
    warning('Filtered chaotic signal (decryption) has fewer values than required. Interpolating...');
    interpolated_indices = linspace(1, length(filtered_signal_dec), expected_samples);
    filtered_signal_dec = interp1(1:length(filtered_signal_dec), filtered_signal_dec, interpolated_indices, 'linear');
end

% **Ensure filtered signal is the same as encryption**
filtered_signal_dec = filtered_signal_dec(1:expected_samples);
filtered_signal_dec = filtered_signal_dec(:); % Force column vector

% **Normalize using the exact same formula**
filtered_signal_dec = abs(filtered_signal_dec);
filtered_signal_dec = mod(round(filtered_signal_dec * 255 / max(filtered_signal_dec)), 256);

%% ========== Decrypt the Image ==========
% **Reverse XOR**
decrypted_vector = bitxor(encrypted_vector, uint8(filtered_signal_dec)); 
decrypted_vector = decrypted_vector(:); % Force column vector

% **Recompute the Permutation Order (Ensuring It Matches Encryption)**
[~, perm_order_dec] = sort(filtered_signal_dec); % This should match encryption

% **Reverse the permutation using perm_order from encryption**
[~, reverse_perm_order] = sort(perm_order_dec); 
decrypted_img_vector = decrypted_vector(reverse_perm_order); 

% **Reshape back to image**
decrypted_img = reshape(decrypted_img_vector, [256, 256]);

% **Display decrypted image**
figure;
imshow(decrypted_img);
title('Decrypted Image');

%% ========== Save Decrypted Image ==========
imwrite(decrypted_img, 'decrypted_image_256x256.png');
fprintf('Decryption completed successfully!\n');

%% ========== Test Decryption Quality ==========
difference = original_img - decrypted_img;
figure;
imshow(difference, []);
title('Difference Between Original and Decrypted Image');

if all(difference(:) == 0)
    fprintf('Decryption is perfect: The difference image is blank.\n');
else
    fprintf('Decryption failed: The difference image is not blank.\n');
end
