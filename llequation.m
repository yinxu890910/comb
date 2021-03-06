% Solving Lugiato-Lefever equation using Split Step Fourier Method
function llequation()

global progress;
global c;
global hbar;
global pi;

global done;
global detuning_profile;
global sweep_speed;
global initial_conditions;
global modes_number;
global filename;

global coupling;
global fsr;
global d2;
global d3;
global linewidth;
global refr_index;
global nonlin_index;
global mode_volume; 
global pump_profile;
global reslist;

tic;

M = modes_number;
wp = reslist(round(modes_number/2)); % pumping frequency
kappa = linewidth*2*pi; % total cavity losses in Hz
n0 = refr_index; % refractive index
n2 = nonlin_index; % nonlinear refractive index in m^2 W^-1
Po = pump_profile(1); % input power in W
detuning_start = detuning_profile(1) ;% detuning in units of linewidth
detuning_end = detuning_profile(end);
% total_time/calc_step MUST BE INTEGER
calc_step = 80; % step in time domain in units of roundtrip time
total_time  = 5e6; % number of steps in time domain

% ------------------ Calculation of additional parameters ----------------

w0 = 2*pi*wp;
g = hbar*w0^2*c*n2/n0/n0/mode_volume; % nonlinear coupling coefficient
tr = 1/fsr; % roundtrip time in sec
d2_kappa = 2*pi*d2/kappa;
d3_kappa = 2*pi*d3/kappa/3;

N = total_time/calc_step;
% k = 1/calc_step;
% taxis = N*tr; % full time of propagation in time domain
% dt = 1/k*tr; % step in t (long time) domain
dt = calc_step*tr;
% t = 0:dt:(taxis); % time vector
alp = 0:1:N;
alp = detuning_start + alp * (detuning_end - detuning_start)/N;

q = -floor(modes_number/2):1:floor((modes_number-1)/2); % vector of modes
% fi = linspace(-pi,pi,M); % vector of angles

% ------------------- Normalization of LL eq -----------------------------

S = sqrt((8*coupling*g*Po)/(hbar*w0*kappa^2)); % norm. input power
% norm_pump = sqrt((8*coupling*g)/(h_cr*w0*kappa^2)); % coeficient for pump norm.
norm_t = 2/kappa; % const of norm: real time = norm_t*t
% norm_fi = sqrt(2*D2/kappa); % const of norm in s: real tau = Ntau*tau;
norm_E = sqrt(kappa/2/g); %const of norm for E in W^0.5: real E = E * NE

dt = dt/norm_t; % normalization of step for long time


% -------------------- Describing input field ----------------------------

h(1,1:M) = -1i*S;
hft0 = fftshift(fft(h));

noise_amp = sqrt(1/2/dt)/norm_E; % noise amplitude for single mode
noise = random('norm',0,noise_amp,1,M)+1i*random('norm',0,noise_amp,1,M);
hft = hft0 + noise;


if initial_conditions == 0
    display('using default')
    signal=random('norm', 0, noise_amp*sqrt(sqrt(M)), 1, M) + 1i*random('norm', 0, noise_amp*sqrt(sqrt(M)), 1, M);
else 
    signal=initial_conditions;
end

% -------------------- Simulation ----------------------------------------
done = 0;
E=zeros(floor(N/100),M);
for kk = 1:1:N
    
    DFT = (-1i+alp(kk)+d2_kappa*(q.^2)-d3_kappa*(q.^3));
    field_DFT = exp(-(1i*dt/2).*DFT);
    const_DFT = (hft./DFT).*(1-field_DFT);
    
    spectrum=fftshift(fft(signal));
    spectrum = const_DFT + field_DFT.*spectrum ;
    signal=ifft(ifftshift(spectrum));
    signal=exp(dt*1i*(abs(signal).^2)).*signal; % nonlinear operator of LLE
    spectrum =fftshift(fft(signal));
    spectrum = const_DFT + field_DFT.*spectrum ;
    signal=ifft(ifftshift(spectrum));
    if rem(kk,100)==0 
        E(floor(kk/100),:)=signal;
%         E=[E;signal];         
    end
    if mod(kk,N/100) == 0
        done = done + 1;
        set(progress,'String',[num2str(round(done)) ' %']);
        pause(.01);
    end
end

toc
% ugly way to store global params
a_coupling=coupling;
a_modes_number=modes_number;
a_fsr=fsr;
a_d2=d2;
a_d3=d3;
a_pump_profile=pump_profile;
a_linewidth=linewidth;
a_refr_index=refr_index;
a_nonlin_index=nonlin_index;
a_mode_volume=mode_volume;
a_sweep_speed=sweep_speed;
a_mode_list = reslist;
a_detuning_profile = detuning_profile;
a_initial_conditions = initial_conditions;

save([filename '.mat'])