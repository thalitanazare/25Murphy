clc; clear; close all;

%% Load LTSpice exported chaotic signal for encryption
filename_enc = 'chaotic_signal.txt'; % Replace with your file
%filename_enc = 'chaotic_rangeR1.txt';
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

%% Test 1: Randomness of chaotic_sequence_enc
fprintf('\nTesting randomness of chaotic_sequence_enc...\n');
testRandomness_NIST_ENT(chaotic_signal_enc, 'Chaotic Signal');

%% Load and Process Image
image_filename = 'test_image.jpg'; % Replace with your image file
original_img = imread(image_filename);
original_img = rgb2gray(original_img); % Convert to grayscale
original_img = imresize(original_img, [256, 256]); % Resize to 256x256

% Display original image
figure;
imshow(original_img);
title('Original Image');

% Convert image to 1D array
img_vector = original_img(:);

% Ensure chaotic sequence is the same length as image pixels
N_pixels = numel(img_vector);
chaotic_sequence_enc = chaotic_signal_enc(1:N_pixels); % Match pixel count

%% Permutation Process (Pixel Diffusion)
% Generate a permutation order based on the chaotic sequence
[~, perm_order] = sort(chaotic_sequence_enc); % Sorting chaotic signal for row permutation
permuted_img_vector = img_vector(perm_order); % Permute pixels

% Test 2: Randomness of permuted_img_vector
fprintf('\nTesting randomness of permuted_img_vector...\n');
testRandomness_NIST_ENT(permuted_img_vector, 'Permuted Image Vector');

%% Encrypt the Permuted Image
encrypted_vector = bitxor(permuted_img_vector, uint8(chaotic_sequence_enc)); 
encrypted_img = reshape(encrypted_vector, [256, 256]); % Reshape to 256x256

% Display encrypted image
figure;
imshow(encrypted_img);
title('Encrypted Image');

% Test 3: Randomness of encrypted_vector
fprintf('\nTesting randomness of encrypted_vector...\n');
testRandomness_NIST_ENT(encrypted_vector, 'Encrypted Vector');

% Test 4: Randomness of encrypted_img
fprintf('\nTesting randomness of encrypted_img...\n');
testRandomness_NIST_ENT(encrypted_img(:), 'Encrypted Image');

%% Save encrypted image
imwrite(encrypted_img, 'encrypted_image_256x256.png');

fprintf('Encryption completed successfully!\n');

%% ========== Now Load Separate Chaotic Signal for Decryption ==========

% Load LTSpice exported chaotic signal for decryption
%filename_dec = 'chaotic_rangeR2.txt'; % decryption chaotic signal file
filename_dec = 'chaotic_signal2.txt';
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
decrypted_img = reshape(decrypted_img_vector, [256, 256]);

% Display decrypted image
figure;
imshow(decrypted_img);
title('Decrypted Image');

%% Save decrypted image
imwrite(decrypted_img, 'decrypted_image_256x256.png');

fprintf('Decryption completed successfully!\n');
%% test 

% Compute the difference between original and decrypted images
difference = original_img - decrypted_img;

% Display the difference
figure;
imshow(difference, []);
title('Difference Between Original and Decrypted Image');

% Check if all values in the difference are zero
if all(difference(:) == 0)
    fprintf('The decryption is perfect: The difference image is blank.\n');
else
    fprintf('The decryption failed: The difference image is not blank.\n');
end

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
