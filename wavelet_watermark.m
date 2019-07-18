clear all;
clc;
% read image
Image = imread('peppers.tif');

load key; %load key.mat file containing locations at which to embed
load watermark; %load watermark.mat file

% wavelet transform
[LL1,LH1,HL1,HH1]  = dwt2(double(Image),'haar','mode','per'); %First Decomp
[LL2,LH2,HL2,HH2]  = dwt2(double(LL1),'haar','mode','per'); %Second Decomp
[LL3,LH3,HL3,HH3]  = dwt2(double(LL2),'haar','mode','per'); %Third Decomp

% Transform images using function
LH3=transform(LH3,w,key);
HL3=transform(HL3,w,key);
HH3=transform(HH3,w,key);

% Inverse wavelet transform
Reconstructed_LL2 = idwt2(LL3,LH3,HL3,HH3,'haar','mode','per');
Reconstructed_LL1 = idwt2(Reconstructed_LL2,LH2,HL2,HH2,'haar','mode','per');
Reconstructed_Image = idwt2(Reconstructed_LL1,LH1,HL1,HH1,'haar','mode','per');

% Write image
imwrite(uint8(round(Reconstructed_Image)),'watermarked_image.tif');

function H3_transformed = transform(H3,w,key)
a = 10; % Watermark strength
for i=1:3000
    % Get locations from key
    row_number=key(i,1); column_number=key(i,2);
    
    % Get current coefficient
    coefficient=H3(row_number,column_number);
    
    % Coefficinet equation
    Q_coefficient_H3=coefficient+(a*w(i));
    
    % Place coefficient which hides watermark back in 3rd decomp
    H3(row_number,column_number)=Q_coefficient_H3; 
end
% Return transformation
H3_transformed=H3;
end