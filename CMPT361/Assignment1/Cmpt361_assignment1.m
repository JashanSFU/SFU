HP = imread('brick3.png');
LP = imread('Village.png');

HP = im2double(HP);
LP = im2double(LP);

HP = imresize(HP, [500 500]);
LP = imresize(LP, [500 500]);

HP = rgb2gray(HP);
LP = rgb2gray(LP);
% imshow(HP);
% imshow(LP);
imwrite(HP,"./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP.png","png");
imwrite(LP,"./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP.png","png");
%
%
% 2nd part
%
%
low_freq_gray_LP = fft2(LP);
high_freq_gray_HP = fft2(HP); 
% imshow([fftshift(abs(high_freq_gray_HP)) fftshift(abs(low_freq_gray_LP))] / 50);
imwrite(fftshift(abs(high_freq_gray_HP))/50, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-freq.png","png");
imwrite(fftshift(abs(low_freq_gray_LP))/50, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-freq.png","png");
%
%
% 3rd part
%
%
gausKern = fspecial('gaussian',19, 2.5);
sob = [-1 0 1; -2 0 2; -1 0 1];
dog = conv2(gausKern, sob);
% surf(gausKern);
% surf(sob);
% surf(dog);
saveas(surf(gausKern), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/gaus-surf.png","png");
saveas(surf(dog), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/dog-surf.png","png");

HP_gaus = imfilter(HP, gausKern);
LP_gaus = imfilter(LP, gausKern);
% imshow([HP_gaus LP_gaus]);
imwrite(HP_gaus, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-filt.png","png");
imwrite(LP_gaus, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-filt.png","png");

HP_filt_freq = fft2(HP_gaus);
LP_filt_freq = fft2(LP_gaus);
% imshow([fftshift(abs(HP_filt_freq)) fftshift(abs(LP_filt_freq))]/7);
imwrite(fftshift(abs(HP_filt_freq))/7, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-filt-freq.png","png");
imwrite(fftshift(abs(LP_filt_freq))/7, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-filt-freq.png","png");
% 
%
dogfilt_fourier = fft2(dog,500, 500);
HP_dogfilt_freq = dogfilt_fourier .* high_freq_gray_HP;
LP_dogfilt_freq = dogfilt_fourier .* low_freq_gray_LP;
%imshow(fftshift(abs(HP_dogfilt_freq))/10);
% imshow(fftshift(abs(LP_dogfilt_freq))/10);
imwrite(fftshift(abs(HP_dogfilt_freq))/10, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-dogfilt-freq.png","png");
imwrite(fftshift(abs(LP_dogfilt_freq))/10, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-dogfilt-freq.png","png");
%
% 
HP_dogfilt = ifft2(HP_dogfilt_freq);
LP_dogfilt = ifft2(LP_dogfilt_freq);
% imshow([HP_dogfilt LP_dogfilt]);
% imshow(3*HP_dogfilt);
% imshow(3*LP_dogfilt);
imwrite(3*HP_dogfilt, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-dogfilt.png","png");
imwrite(3*LP_dogfilt, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-dogfilt.png","png");
%
%
% 4th part 
%
% 
HP_sub2 = HP(1:2:end, 1:2:end);
LP_sub2 = LP(1:2:end, 1:2:end);
HP_sub2_freq = fft2(HP_sub2);
LP_sub2_freq = fft2(LP_sub2);
% 
% imshow(HP_sub2);
% imshow(LP_sub2);
imwrite(HP_sub2, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub2.png","png");
imwrite(LP_sub2, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-sub2.png","png");
% imshow(fftshift(abs(HP_sub2_freq))/ 40);
% imshow(fftshift(abs(LP_sub2_freq))/40);
imwrite(fftshift(abs(HP_sub2_freq))/40, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub2-freq.png","png");
imwrite(fftshift(abs(LP_sub2_freq))/40, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-sub2-freq.png","png");
% 
HP_sub4 = HP(1:4:end, 1:4:end);
LP_sub4 = LP(1:4:end, 1:4:end);
HP_sub4_freq = fft2(HP_sub4);
LP_sub4_freq = fft2(LP_sub4);
% 
% imshow(HP_sub4);
% imshow(LP_sub4);
imwrite(HP_sub4, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub4.png","png");
imwrite(LP_sub4, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-sub4.png","png");
% imshow(fftshift(abs(HP_sub4_freq))/ 40);
% imshow(fftshift(abs(LP_sub4_freq))/40);
imwrite(fftshift(abs(HP_sub4_freq))/40, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub4-freq.png","png");
imwrite(fftshift(abs(LP_sub4_freq))/40, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-sub4-freq.png","png");
% 
%
HP_sub2_filter = imfilter(HP, fspecial('gaussian', 5, 1));
HP_sub2_aa = HP_sub2_filter(1:2:end, 1:2:end);
% imshow(HP_sub2_aa);
imwrite(HP_sub2_aa, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub2-aa.png","png");
HP_sub2_aa_freq = fft2(HP_sub2_aa);
% 
% imshow(fftshift(abs(HP_sub2_aa_freq))/100);
imwrite(fftshift(abs(HP_sub2_aa_freq))/100, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub2-aa-freq.png","png");
% 
HP_sub4_filter = imfilter(HP, fspecial('gaussian', 10, 1.5));
HP_sub4_aa = HP_sub4_filter(1:4:end, 1:4:end);
% imshow(HP_sub4_aa);
imwrite(HP_sub4_aa, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub4-aa.png","png");
HP_sub4_aa_freq = fft2(HP_sub4_aa);
% imshow(fftshift(abs(HP_sub4_aa_freq))/100);
imwrite(fftshift(abs(HP_sub4_aa_freq))/100, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-sub4-aa-freq.png","png");
%
%
% 5th part 
%
%
[cannyedge, thread] = edge(HP,'canny');
imwrite(cannyedge, "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-canny-optimal.png","png");
% imshow(cannyedge);  
% thread is (0.2125, 0.5312)
thread;
% imshow(edge(HP, 'canny', [0.1,0.5312]));  %  lowlow(gives missing edges)
% imshow(edge(HP, 'canny', [0.5,0.5312]));  %  highlow
% imshow(edge(HP, 'canny', [0.2125,0.213])); %lowhigh (winner)
% imshow(edge(HP, 'canny', [0.2125,0.8])); %highhigh
imwrite(edge(HP, 'canny', [0.1,0.5312]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-canny-lowlow.png","png");
imwrite(edge(HP, 'canny', [0.5,0.5312]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-canny-highlow.png","png");
imwrite(edge(HP, 'canny', [0.2125,0.213]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-canny-lowhigh.png","png");
imwrite(edge(HP, 'canny', [0.2125,0.8]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/HP-canny-highhigh.png","png");

%
% LP canny edge
%
[cannyedge, thread] = edge(LP,'canny');
thread; % thread is (0.0188, 0.0469)
imwrite(edge(LP, 'canny'), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-canny-optimal.png","png");
% imshow(cannyedge);
% imshow(edge(LP, 'canny', [0.008,0.0469]));  %  lowlow (gives missing edges)
% imshow(edge(LP, 'canny', [0.045,0.0469]));  %  highlow
% imshow(edge(LP, 'canny', [0.0188,0.03])); %lowhigh
% imshow(edge(LP, 'canny', [0.0188,0.065])); %highhigh (winner)
imwrite(edge(LP, 'canny', [0.008,0.0469]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-canny-lowlow.png","png");
imwrite(edge(LP, 'canny', [0.045,0.0469]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-canny-highlow.png","png");
imwrite(edge(LP, 'canny', [0.0188,0.03]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-canny-lowhigh.png","png");
imwrite(edge(LP, 'canny', [0.0188,0.065]), "./CMPT 361 HW1 - Jashanraj Singh and Gosain_files/LP-canny-highhigh.png","png");