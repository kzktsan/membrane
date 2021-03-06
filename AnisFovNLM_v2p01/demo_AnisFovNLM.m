%
%  Anisotropic Foveated Nonlocal Means denoising demo script  (ver 2.01, Oct. 9, 2014)
%  Author:  Alessandro Foi, Tampere University of Technology, Finland
% --------------------------------------------------------------------------------------
%
%  MAIN VARIABLES
%
%  y:               original image  (noise free), loaded from file
%  sigma :          standard deviation of the additive white Gaussian noise
%  z :              noisy image to be filtered
%  disableFov :     disables foveation when set to 1  (default 0)
%  selfMap :        enables self-map foveation operators when set to 1  (default 1)
%
%
%  This script demonstrates the use of the Anisotropic Foveated Nonlocal Means algorithm
%  implemented in the function  AnisFovNLM.m
%
%
%  REFERENCES:   (all available online at http://www.cs.tut.fi/~foi/)
%  [1] A. Foi and G. Boracchi, "Foveated self-similarity in nonlocal image filtering",
%  Proc. IS&T/SPIE EI2012 - Human Vision and Electronic Imaging XVII, 8291-32,
%  Burlingame (CA), USA, Jan. 2012.
%  [2] A. Foi and G. Boracchi, "Anisotropically Foveated Nonlocal Image Denoising",
%  Proc. IEEE Int. Conf. Image Process. (ICIP 2013), pp. 464-468, Melbourne, Australia, Sep. 2013.
%  [3] A. Foi and G. Boracchi, "Foveated nonlocal self-similarity", preprint, Oct. 2014.
%  


clear all;
% close all;

disableFov=1;   % fovation/windowing   default:  disableFov=0;
selfMap=1;      % self-map operators   default:  selfMap=1;



%% Original Image
y = double(imread('Man_fragment256.tif'));
%y = double(imread('membrane157949.jpg'));
y = y(1:65,1:65);  % crop input image
%y = y(1:65,1:65);


figure, imshow(y/255), title('original image - y');


%% Noisy Image.

sigma=20;                     % noise standard deviation
randn('seed',-1);             % pseudorandom noise seed  (seed -1 is used for Figures 13, 14, 15, and 22 of [3])
z=y+sigma*randn(size(y));     % generate noisy observation with additive white Gaussian noise


%% actual demo-code begins here
disp(' ');
PSNRin=10*log10(255^2/mean((y(:)-z(:)).^2));
textString=['PSNRin = ',num2str(PSNRin),' db'];

% Check for SSIM
exists_ssim_file=exist('ssim_index','file');    % SSIM function can be downloaded from https://ece.uwaterloo.ca/~z70wang/research/ssim/

if exists_ssim_file
    if size(z,3)==3
        [SSIMin SSIMmapIn] = ssim_index(rgb2gray(y), rgb2gray(z));
    else
        [SSIMin SSIMmapIn] = ssim_index(y, z);
    end
    textString=[textString,'  SSIMin = ',num2str(SSIMin)];
end
textString=[textString,'  (noise sigma = ',num2str(sigma), ')'];

disp(textString)
figure
imshow(z/255), title(['Noisy Image - z:  ',textString]);


%% Anistropic Foveated NL-means function (core of the demo)

% y_hat = AnisFovNLM(z,sigma,search_radius,U_radius,disableFov,selfMap,rho,theta,extraPadPSF);
y_hat = AnisFovNLM(z,sigma,[],[],disableFov,selfMap);   % by leaving search_radius and U_radius empty, their values are chosen automatically by the function, based on the value of sigma (the signal is assumed to be in the standard [0,255] range)



PSNRout=10*log10(255^2/mean((y(:)-y_hat(:)).^2));
textString=['PSNRout = ',num2str(PSNRout),' db'];

if exists_ssim_file
    if size(z,3)==3
        [SSIMout SSIMmapOut] = ssim_index(rgb2gray(y/255)*255, rgb2gray(y_hat/255)*255);
    else
        [SSIMout SSIMmapOut] = ssim_index(y, y_hat);
    end
    textString=[textString,'  SSIMfov = ',num2str(SSIMout)];
end

disp( textString )
figure
textString=['NL-means estimate: ', textString];
if ~disableFov
    textString=['Foveated ',textString];
end
imshow(y_hat/255), title(textString);

