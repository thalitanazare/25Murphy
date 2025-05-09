clc; clear; close all;

%% ========== Load LTSpice Exported Chaotic Signal for Encryption ==========
filename_enc = 'chaotic_signal.txt';
%filename_enc = 'TestOutput.txt';
data_enc = readmatrix(filename_enc);

% Extract chaotic signal values
time_enc = data_enc(:,1);   
chaotic_signal_enc = data_enc(:,2); 

% **Filter chaotic signal in range [-1.5V, 1V]**
valid_indices = chaotic_signal_enc >= -1.5 & chaotic_signal_enc <= 1;
filtered_signal_enc = chaotic_signal_enc(valid_indices);
filtered_time_enc = time_enc(valid_indices);

% Ensure valid data is present
if isempty(filtered_signal_enc)
    error('No valid values in the chaotic signal after filtering. Adjust filter range.');
end

% Expected number of samples
expected_samples = 256 * 256; % 65,536

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
title('Filtered Chaotic Signal Used for Encryption');
xlabel('Time (s)');
ylabel('Normalized Chaotic Signal');
grid on;

%% ========== Load and Process Image ==========
image_filename = 'test_image.jpg';
original_img = imread(image_filename);
original_img = rgb2gray(original_img);
original_img = imresize(original_img, [256, 256]);

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
encrypted_img = reshape(encrypted_vector, [256, 256]); 

% **Save and display encrypted image**
imwrite(encrypted_img, 'encrypted_image_256x256.png');
figure;
imshow(encrypted_img);
title('Encrypted Image');

%% ========== Load Chaotic Signal for Decryption ==========
filename_dec = 'chaotic_signal2.txt';
%filename_enc = 'TestOutput2.txt';
data_dec = readmatrix(filename_dec);

% Extract chaotic signal values
chaotic_signal_dec = data_dec(:,2); 

% **Apply the same filtering range as encryption**
valid_indices_dec = chaotic_signal_dec >= -1.5 & chaotic_signal_dec <= 1;
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
decrypted_img = reshape(decrypted_img_vector, [256, 256]);

% **Save and display decrypted image**
imwrite(decrypted_img, 'decrypted_image_256x256.png');
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

%% ========== Testing Randomness of Chaotic Signal and Permutation Process ==========
% Test 1: Randomness of chaotic_sequence_enc
fprintf('\nTesting randomness of chaotic_sequence_enc...\n');
testRandomness_NIST_ENT(chaotic_sequence_enc, 'Chaotic Signal');

% Test 2: Randomness of permuted_img_vector
fprintf('\nTesting randomness of permuted_img_vector...\n');
testRandomness_NIST_ENT(permuted_img_vector, 'Permuted Image Vector');

% Test 3: Randomness of encrypted_vector
fprintf('\nTesting randomness of encrypted_vector...\n');
testRandomness_NIST_ENT(encrypted_vector, 'Encrypted Vector');

% Test 4: Randomness of encrypted_img
fprintf('\nTesting randomness of encrypted_img...\n');
testRandomness_NIST_ENT(encrypted_img(:), 'Encrypted Image');

%% ========== Simplified Randomness Tests ==========
function testRandomness_NIST_ENT(data, data_name)
    % Convert data to uint8 for consistency
    data = uint8(data(:));  

    % Test 1: Frequency Test (Proportion of 1s and 0s)
    binary_data = dec2bin(data, 8)'; % Convert data to binary (transposed for column-wise access)
    binary_sequence = binary_data(:) - '0'; % Flatten and convert chars to numbers
    prop_ones = sum(binary_sequence) / length(binary_sequence);
    fprintf('%s Frequency Test (Proportion of 1s): %.4f (Ideal: ~0.5)\n', data_name, prop_ones);

    % Test 2: Runs Test (Consecutive 1s and 0s)
    diff_binary = diff(binary_sequence);
    runs = sum(diff_binary ~= 0) + 1;
    expected_runs = 2 * length(binary_sequence) * prop_ones * (1 - prop_ones);
    
    % Avoid division errors when prop_ones is too small or large
    if expected_runs > 0
        runs_test_stat = abs(runs - expected_runs) / sqrt(expected_runs);
    else
        runs_test_stat = NaN; % Not computable in extreme cases
    end
    fprintf('%s Runs Test (Statistic): %.4f (Ideal: Close to 0)\n', data_name, runs_test_stat);

    % Test 3: Shannon Entropy
    prob_dist = histcounts(data, 0:256) / numel(data); % Probability distribution
    prob_dist = prob_dist(prob_dist > 0); % Remove zero probabilities
    entropy_value = -sum(prob_dist .* log2(prob_dist)); % Shannon entropy
    fprintf('%s Shannon Entropy: %.4f (Ideal: ~8 for random data)\n', data_name, entropy_value);

    % Test 4: Chi-Square Test
    observed_counts = histcounts(data, 0:256);
    expected_counts = numel(data) / 256; % Expected uniform distribution
    chi_square_stat = sum((observed_counts - expected_counts).^2 / expected_counts);
    fprintf('%s Chi-Square Test Statistic: %.4f (Ideal: Between 216 and 293)\n', data_name, chi_square_stat);
    
    % Test 5: Serial Correlation
    mean_data = mean(data);
    variance = sum((data - mean_data).^2);
    
    % Avoid division by zero
    if variance > 0
        serial_corr = sum((data(1:end-1) - mean_data) .* (data(2:end) - mean_data)) / variance;
    else
        serial_corr = NaN; % Not computable if variance is zero
    end
    fprintf('%s Serial Correlation Coefficient: %.4f (Ideal: Close to 0)\n', data_name, serial_corr);

    % Histogram (to visualize uniformity)
    figure;
    histogram(data, 256);
    title(['Histogram of ', data_name]);
    xlabel('Values');
    ylabel('Frequency');
end
