clc; clear; close all;

%% ========== Load LTSpice Exported Chaotic Signal for Encryption ==========
filename_enc = 'TestOutput3.txt';
data_enc = readmatrix(filename_enc);

% Extract chaotic signal values
time_enc = data_enc(:,1);   
chaotic_signal_enc = data_enc(:,2);

% === Round chaotic signal to nearest 0.1 ===
chaotic_signal_enc = round(chaotic_signal_enc * 10) / 10;

% **Filter chaotic signal in range [-1.3V, 2.5V]**
valid_indices = chaotic_signal_enc >= -1.3 & chaotic_signal_enc <= 2.5;
filtered_signal_enc = chaotic_signal_enc(valid_indices);
filtered_time_enc = time_enc(valid_indices);

% Ensure valid data is present
if isempty(filtered_signal_enc)
    error('No valid values in the chaotic signal after filtering. Adjust filter range.');
end

% Expected number of samples
expected_samples = 128 * 128; % 16,384

% **Trim excess samples if needed**
if length(filtered_signal_enc) > expected_samples
    filtered_signal_enc = filtered_signal_enc(1:expected_samples);
    filtered_time_enc = filtered_time_enc(1:expected_samples);
elseif length(filtered_signal_enc) < expected_samples
    error('Filtered chaotic signal has fewer values than required. Adjust the signal length.');
end

% Ensure filtered signal is a column vector
filtered_signal_enc = filtered_signal_enc(:);

% **Fix normalization factor to ensure consistency**
max_value = max(filtered_signal_enc);

% **Normalize chaotic signal**
chaotic_sequence_enc = abs(filtered_signal_enc);
chaotic_sequence_enc = mod(round(chaotic_sequence_enc * 255 / max_value), 256);
chaotic_sequence_enc = uint8(chaotic_sequence_enc);

% Display the filtered chaotic signal
figure;
plot(filtered_time_enc, filtered_signal_enc, 'r');
title('Filtered & Quantised Chaotic Signal Used for Encryption');
xlabel('Time (s)');
ylabel('Quantised Chaotic Signal');
grid on;

%% ========== Load and Process Image ==========
image_filename = 'test_image_128x128.jpg';
original_img = imread(image_filename);
original_img = rgb2gray(original_img);
original_img = imresize(original_img, [128, 128]);

% Display original image
figure;
imshow(original_img);
title('Original Image');

% **Convert image to 1D column vector**
img_vector = original_img(:);

% **Generate a permutation order**
[~, perm_order] = sort(chaotic_sequence_enc);
permuted_img_vector = img_vector(perm_order); 

% **Encrypt the Permuted Image**
encrypted_vector = bitxor(permuted_img_vector, chaotic_sequence_enc);

% **Reshape encrypted vector into image format**
encrypted_img = reshape(encrypted_vector, [128, 128]); 

% **Save and display encrypted image**
imwrite(encrypted_img, 'encrypted_image_128x128.png');
figure;
imshow(encrypted_img);
title('Encrypted Image');

%% ========== Load Chaotic Signal for Decryption ==========
filename_dec = 'TestOutput4.txt';
data_dec = readmatrix(filename_dec);

% Extract chaotic signal values
chaotic_signal_dec = data_dec(:,2);

% === Round chaotic signal to nearest 0.1 ===
chaotic_signal_dec = round(chaotic_signal_dec * 10) / 10;

% **Apply the same filtering range as encryption**
valid_indices_dec = chaotic_signal_dec >= -1.3 & chaotic_signal_dec <= 2.5;
filtered_signal_dec = chaotic_signal_dec(valid_indices_dec);

% **Ensure the same number of samples as encryption**
if length(filtered_signal_dec) > expected_samples
    filtered_signal_dec = filtered_signal_dec(1:expected_samples);
elseif length(filtered_signal_dec) < expected_samples
    error('Filtered chaotic signal for decryption has fewer values than required. Adjust the signal length.');
end

% Ensure filtered signal is a column vector
filtered_signal_dec = filtered_signal_dec(:);

% **Use the same max value from encryption**
chaotic_sequence_dec = abs(filtered_signal_dec);
chaotic_sequence_dec = mod(round(chaotic_sequence_dec * 255 / max_value), 256);
chaotic_sequence_dec = uint8(chaotic_sequence_dec);

%% ========== Decrypt the Image ==========
% **Reverse XOR**
decrypted_vector = bitxor(encrypted_vector, chaotic_sequence_dec);

% **Recompute the Permutation Order**
[~, perm_order_dec] = sort(chaotic_sequence_dec);

% **Reverse the permutation using perm_order from encryption**
[~, reverse_perm_order] = sort(perm_order);  
decrypted_img_vector = decrypted_vector(reverse_perm_order); 

% **Reshape back to image**
decrypted_img = reshape(decrypted_img_vector, [128, 128]);

% **Save and display decrypted image**
imwrite(decrypted_img, 'decrypted_image_128x128.png');
figure;
imshow(decrypted_img);
title('Decrypted Image');

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

%% ========== Plot Encrypted vs Decryption Signal Comparison ==========
figure;
plot(filtered_time_enc, filtered_signal_enc, 'r');
hold on;
plot(filtered_time_enc, filtered_signal_dec, 'b');
legend('Encryption Signal', 'Decryption Signal');
title('Comparison of Quantised Signals');
xlabel('Time (s)');
ylabel('Signal Value');
grid on;
