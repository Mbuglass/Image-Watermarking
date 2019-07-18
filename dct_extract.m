clear all;
clc;
Image=imread('watermarked_image_DCT.tif');

load key;
load watermark;

% DCT transform
DCTImage = dct2(Image);


if checkWatermark(DCTImage,w,key)
    disp("Found watermark in DCT");
else
    disp("No watermark found in DCT");
end

function watermarkFound = checkWatermark(DCTImage,w,key)
PDCT=zeros(3001,1);
c=1.7; % Shape parameter
for i=1:3000
    % Get locations from key
    row_number=key(i,1); column_number=key(i,2);
    
    % Get current coefficient
    coefficient_DCT=DCTImage(row_number,column_number);
    
    % Coefficinet equation
    PDCT(i+1) = sign(coefficient_DCT)*power(abs(coefficient_DCT),c-1)*w(i);
end
watermarkFound=sum(PDCT)>0;
end
