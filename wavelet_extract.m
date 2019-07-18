clear all;
clc;
Image=imread('watermarked_image.tif');

load key;
load watermark;

% wavelet transform
[LL1,LH1,HL1,HH1] = dwt2(double(Image),'haar','mode','per'); %First Decomp
[LL2,LH2,HL2,HH2] = dwt2(double(LL1),'haar','mode','per'); %Second Decomp
[LL3,LH3,HL3,HH3] = dwt2(double(LL2),'haar','mode','per'); %Third Decomp

% Output whether watermark has been found in each sub-band
if checkWatermark(LH3,w,key)
    disp("Found watermark in LH3");
else
    disp("No watermark found in LH3");
end
if checkWatermark(HL3,w,key)
    disp("Found watermark in HL3");
else
    disp("No watermark found in HL3");
end
if checkWatermark(HH3,w,key)
    disp("Found watermark in LH3");
else
    disp("No watermark found in HH3");
end

function watermarkFound = checkWatermark(H3,w,key)
PH3=zeros(3001,1);
c=1.7; % Shape parameter
for i=1:3000
    % Get locations from key
    row_number=key(i,1); column_number=key(i,2);
    
    % Get current coefficient
    coefficient_H3=H3(row_number,column_number);
    
    % Coefficinet equation
    PH3(i+1) = sign(coefficient_H3)*power(abs(coefficient_H3),c-1)*w(i);
end
watermarkFound=sum(PH3)>0;
end
