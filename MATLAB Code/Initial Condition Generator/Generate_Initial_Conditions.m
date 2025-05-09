% Generate Initial Conditions for 256 x 256 image encryption

% Input: Password as a string
password = input('Enter your password: ', 's');

% Validate input
if isempty(password)
    error('Password cannot be empty.');
end

if length(password) ~= 8 || ~all(isstrprop(password, 'digit'))
    error('Password must be exactly 8 digits.');
end

% Convert password to a numeric seed
seed = sum(double(password)); % Sum ASCII values of characters
rng(seed); % Seed the random number generator

% Generate 65,536 initial conditions between 1 and 5 volts
initial_conditions = 2 + 10 * rand(256*256, 1); % Shift range to [1, 5] (helps reduce divergence when switch value above current output)

% Reshape into a 256x256 matrix (if needed for easier image mapping)
initial_conditions_matrix = reshape(initial_conditions, [256, 256]);

% Display a small portion as an example
disp('Sample initial conditions:');
disp(initial_conditions_matrix(1:5, 1:5));

%%

% Generate .txt file with correct switching times 

% Define time step (97.88 ms)
time_step = 0.09788; 

% Calculate time vector
num_conditions = length(initial_conditions);
time = (0:num_conditions-1)' * time_step;

% Combine time and initial conditions for saving
data = [time, initial_conditions];

% Save to a text file
writematrix(data, 'initial_conditions.txt', 'Delimiter', 'tab');
