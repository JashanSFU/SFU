S4Parta = imread('Cup1.png');
S4Partb = imread('Cup2.png');
S3Parta = imread('Bunny1.png');
S3Partb = imread('Bunny2.png');
S2Parta = imread('KeyHolder1.png');
S2Partb = imread('keyHolder2.png');
S1Parta = imread('Wide1.png');
S1Partb = imread('Wide2.png');

S1Parta = im2double(S1Parta);
S1Partb = im2double(S1Partb);

S2Parta = im2double(S2Parta);
S2Partb = im2double(S2Partb);

S3Parta = im2double(S3Parta);
S3Partb = im2double(S3Partb);

S4Parta = im2double(S4Parta);
S4Partb = im2double(S4Partb);


S4Parta = imresize(S4Parta, [1170 750]);
S4Partb = imresize(S4Partb, [1170 750]);

S3Parta = imresize(S3Parta, [1170 750]);
S3Partb = imresize(S3Partb, [1170 750]);

S2Parta = imresize(S2Parta, [1170 750]);
S2Partb = imresize(S2Partb, [1170 750]);

S1Parta = imresize(S1Parta, [1170 750]);
S1Partb = imresize(S1Partb, [1170 750]);

imwrite(S1Parta,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-im1.png","png");
imwrite(S1Partb,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-im2.png","png");
imwrite(S2Parta,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-im1.png","png");
imwrite(S2Partb,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-im2.png","png");
imwrite(S3Parta,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S3-im1.png","png");
imwrite(S3Partb,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S3-im2.png","png");
imwrite(S4Parta,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S4-im1.png","png");
imwrite(S4Partb,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S4-im2.png","png");

S4Parta = rgb2gray(S4Parta);
S4Partb = rgb2gray(S4Partb);
 
S3Parta = rgb2gray(S3Parta);
S3Partb = rgb2gray(S3Partb);
 
S2Parta = rgb2gray(S2Parta);
S2Partb = rgb2gray(S2Partb);

S1Parta = rgb2gray(S1Parta);
S1Partb = rgb2gray(S1Partb);


%%
% Fast
tic
cornersS1Parta = my_fast_detector(S1Parta);
cornersS2Parta = my_fast_detector(S2Parta);
runTimeforFAST = toc;
imwrite(cornersS1Parta*20,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-fast.png","png");
imwrite(cornersS2Parta*20,"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-fast.png","png");
% cornersS1Parta = cornersS1Parta + S1Parta;
% cornersS2Parta = cornersS2Parta + S2Parta;
%%

%%
% FastR
tic
HarCornerS1Parta = harris_detection_measure(S1Parta, cornersS1Parta);
HarCornerS2Parta = harris_detection_measure(S2Parta, cornersS2Parta);
runTimeforFastr = toc;
HarCornerS1Parta = HarCornerS1Parta > 0.2;
HarCornerS2Parta = HarCornerS2Parta > 0.2;
imshow(HarCornerS1Parta);
imwrite((HarCornerS1Parta),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-fastR.png","png");
imwrite((HarCornerS2Parta),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-fastR.png","png");
HarCornerS1Parta = S1Parta + HarCornerS1Parta;
HarCornerS2Parta = S2Parta + HarCornerS2Parta;
%%
% 
% 
% 
% % Fast Feature Detection
%
%
%
%
cornerPointS1 = cornerPoints(getPoints(cornersS1Parta));
cornerPointS2 = cornerPoints(getPoints(cornersS2Parta));
[SURFS1Features, SURFS1Points] = extractFeatures(S1Parta, cornerPointS2);
[SURFS2Features, SURFS2Points] = extractFeatures(S2Parta, cornerPointS2);


SceneS1 = my_fast_detector(S1Partb);
SceneS1 = cornerPoints(getPoints(SceneS1));
[sceneS1Features, sceneS1Points] = extractFeatures(S1Partb,SceneS1);
SceneS2 = my_fast_detector(S2Partb);
SceneS2 = cornerPoints(getPoints(SceneS2));
[sceneS2Features, sceneS2Points] = extractFeatures(S2Partb,SceneS2);

SURFS1Pairs = matchFeatures(SURFS1Features, sceneS1Features);
resultForMatchingS1 = showMatchedFeatures(S1Parta, S1Partb, SURFS1Points(SURFS1Pairs(:, 1), :), ...
sceneS1Points(SURFS1Pairs(:, 2), :), 'montage');
saveas((resultForMatchingS1),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-fastMatch.png","png");

SURFS2Pairs = matchFeatures(SURFS2Features, sceneS2Features);
resultForMatchingS2 = showMatchedFeatures(S2Parta, S2Partb, SURFS2Points(SURFS2Pairs(:, 1), :), ...
sceneS2Points(SURFS2Pairs(:, 2), :), 'montage');
saveas((resultForMatchingS2),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-fastMatch.png","png");
%

%%
% FastR Feature Detection
%
FastR_pointsS1Parta = detectSURFFeatures(HarCornerS1Parta);
FastR_pointsS2Parta = detectSURFFeatures(HarCornerS2Parta);
[FastR_SURFS1Features, FastR_SURFS1Points] = extractFeatures(S1Parta, FastR_pointsS1Parta);
[FastR_SURFS2Features, FastR_SURFS2Points] = extractFeatures(S2Parta, FastR_pointsS2Parta);

FastR_SceneS1 = detectSURFFeatures(S1Partb);
[FastR_sceneS1Features, FastR_sceneS1Points] = extractFeatures(S1Partb,FastR_SceneS1);
FastR_SceneS2 = detectSURFFeatures(S2Partb);
[FastR_sceneS2Features, FastR_sceneS2Points] = extractFeatures(S2Partb,FastR_SceneS2);

FastR_SURFS1Pairs = matchFeatures(FastR_SURFS1Features, FastR_sceneS1Features);
FastR_resultForMatchingS1 = showMatchedFeatures(S1Parta, S1Partb, FastR_SURFS1Points(FastR_SURFS1Pairs(:, 1), :), ...
FastR_sceneS1Points(FastR_SURFS1Pairs(:, 2), :), 'montage');
saveas((FastR_resultForMatchingS1),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-fastRMatch.png","png");

FastR_SURFS2Pairs = matchFeatures(FastR_SURFS2Features, FastR_sceneS2Features);
FastR_resultForMatchingS2 = showMatchedFeatures(S2Parta, S2Partb, FastR_SURFS2Points(FastR_SURFS2Pairs(:, 1), :), ...
FastR_sceneS2Points(FastR_SURFS2Pairs(:, 2), :), 'montage');
saveas((FastR_resultForMatchingS2),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-fastRMatch.png","png");

%%
imwrite(getPanorama(imread('Wide1.png'), imread('Wide2.png')),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S1-panorama.png","png");
imwrite(getPanorama(imread('keyHolder1.png'), imread('KeyHolder2.png')),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S2-panorama.png","png");
imwrite(getPanorama(imread('Bunny1.png'), imread('Bunny2.png')),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S3-panorama.png","png");
imwrite(getPanorama(imread('Cup1.png'), imread('Cup2.png')),"./CMPT 361 HW2 - Jashanraj Singh Gosain_files/S4-panorama.png","png");
%%

function harcor = harris_detection_measure(image, FastDetected)
    sobel = [-1 0 1; -2 0 2 ; -1 0 1];
    gaus = fspecial('gaussian', 5, 1);
    dog = conv2(gaus, sobel);
    ix = imfilter(image,dog);
    iy = imfilter(image, dog');
    ix2g = imfilter(ix .* ix, gaus);
    iy2g = imfilter(iy .* iy, gaus);
    ixiyg = imfilter(ix .* iy , gaus);
    s = size(image);
    harcor = zeros(s);
%     s = size(FastDetected);
%     for i = 1: s(1)
%             x = FastDetected(i,1);
%             y = FastDetected(i,2);
%             harcor(y,x) = ix2g(y,x) * iy2g(y,x) - ixiyg(y,x) .* ixiyg(y,x) - 0.05 * (ix2g(y,x) + iy2g(y,x)) .^2;
%     end
    for x = 1 : s(1)
        for y = 1 : s(2)
            if FastDetected(x, y) ~= 0 
                harcor(x,y) = ix2g(x,y) * iy2g(x,y) - ixiyg(x,y) .* ixiyg(x,y) - 0.05 * (ix2g(x,y) + iy2g(x,y)) .^2;
            end
        end
    end
end

% Resource : https://youtu.be/Vqtf0iVUqHg 
function resultGrid = my_fast_detector(image_matrix)
pSize = size(image_matrix);
 blackScreen = zeros(pSize(1)+6,pSize(2)+6);
 blackScreen(4:pSize(1) + 3, 4:pSize(2) + 3) = image_matrix;
    p = zeros(pSize(1),pSize(2),16);
    p(:,:, 1) = abs(blackScreen(1:end-6,4:end-3) - blackScreen(4:end-3,4:end-3)); % I(x) - I(p) > thresh 
    p(:,:, 2) = abs(blackScreen(1:end-6,5:end-2) - blackScreen(4:end-3,4:end-3));
    p(:,:, 3) = abs(blackScreen(2:end-5,6:end-1) - blackScreen(4:end-3,4:end-3));
    p(:,:, 4) = abs(blackScreen(3:end-4,7:end) - blackScreen(4:end-3,4:end-3));
    p(:,:, 5) = abs(blackScreen(4:end-3,7:end) - blackScreen(4:end-3,4:end-3));
    p(:,:, 6) = abs(blackScreen(5:end-2,7:end) - blackScreen(4:end-3,4:end-3));
    p(:,:, 7) = abs(blackScreen(6:end-1,6:end-1) - blackScreen(4:end-3,4:end-3));
    p(:,:, 8) = abs(blackScreen(7:end,5:end-2) - blackScreen(4:end-3,4:end-3));
    p(:,:, 9) = abs(blackScreen(7:end,4:end-3) - blackScreen(4:end-3,4:end-3));
    p(:,:, 10) = abs(blackScreen(7:end,3:end-4) - blackScreen(4:end-3,4:end-3));
    p(:,:, 11) = abs(blackScreen(6:end-1,2:end-5) - blackScreen(4:end-3,4:end-3));
    p(:,:, 12) = abs(blackScreen(5:end-2,1:end-6) - blackScreen(4:end-3,4:end-3));
    p(:,:, 13) = abs(blackScreen(4:end-3,1:end-6) - blackScreen(4:end-3,4:end-3));
    p(:,:, 14) = abs(blackScreen(3:end-4,1:end-6) - blackScreen(4:end-3,4:end-3));
    p(:,:, 15) = abs(blackScreen(2:end-5,2:end-5) - blackScreen(4:end-3,4:end-3));
    p(:,:, 16) = abs(blackScreen(1:end-6,3:end-4) - blackScreen(4:end-3,4:end-3));
    p = p > 0.10;
    resultGrid = sum(p,3);
    resultGrid = resultGrid >= 12;
end

function [Points] = getPoints(gridMatrix)
cornerOfx = [];
cornerOfy = [];
pSize = size(gridMatrix);
    for i = 1: pSize(1)
        for j = 1: pSize(2)
            if gridMatrix(i,j) ~= 0
                cornerOfx = [cornerOfx ; j];
                cornerOfy = [cornerOfy ; i];
            end
        end 
    end
    Points=[cornerOfx,cornerOfy];    
end

% Resources :
% https://www.mathworks.com/help/vision/ug/feature-based-panoramic-image-stitching.html and https://youtu.be/DPkmphP53j4
function panorama = getPanorama(image1, image2)
    im1 = image1;
    im2 = image2;
    %%
    im1 = im2double(im1);
    im1_gray = rgb2gray(im1);
    
    im2 = im2double(im2);
    im2_gray = rgb2gray(im2);
    
    cornersParta = my_fast_detector(im1_gray);
    HarCornerParta = harris_detection_measure(im1_gray, cornersParta);
    HarCornerParta = HarCornerParta > 0.3; % 0.35
    HarCornerParta = im1_gray + HarCornerParta;
    
    FastR_pointsParta = detectSURFFeatures(HarCornerParta);
    [FastR_SURFFeatures, FastR_SURFPoints] = extractFeatures(HarCornerParta, FastR_pointsParta);

    FastR_Scene = detectSURFFeatures(im2_gray);
    [FastR_sceneFeatures, FastR_scenePoints] = extractFeatures(im2_gray,FastR_Scene);
    
    FastR_SURFPairs = matchFeatures(FastR_SURFFeatures, FastR_sceneFeatures);
    matchedPt1 = FastR_SURFPoints(FastR_SURFPairs(:,1), :);
    matchedPt2 = FastR_scenePoints(FastR_SURFPairs(:,2), :);
    
    %%
    n=2;
    tforms(2) = projective2d(eye(3));
    ImageSize = zeros(n, 2);
    tforms(n) = estimateGeometricTransform2D(matchedPt2, matchedPt1,...
                'projective', 'Confidence', 99.9,'MaxNumTrials', 2500, 'MaxDistance',40);
            
            % Compute T(n) * T(n-1) * ... * T(1)
    tforms(n).T = tforms(n).T * tforms(n-1).T;
    ImageSize(2,:) = size(im2_gray);
    %%

    for i = 1:numel(tforms)
            [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 ImageSize(i,2)], [1 ImageSize(i,1)]);
    end
    
    avgXLim = mean(xlim, 2);
    [~, idx] = sort(avgXLim);
    centerIdx = floor((numel(tforms)+1)/2);
    centerImageIdx = idx(centerIdx);

    Tinv = invert(tforms(centerImageIdx));
    for i = 1:numel(tforms)
        tforms(i).T = tforms(i).T * Tinv.T;
    end

    for i = 1:numel(tforms)           
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 ImageSize(i,2)], [1 ImageSize(i,1)]);
    end
    
    maxImageSize = max(ImageSize);
    
    xMin = min([1; xlim(:)]);
    xMax = max([maxImageSize(2); xlim(:)]);
    
    yMin = min([1; ylim(:)]);
    yMax = max([maxImageSize(1); ylim(:)]);
    
    width  = round(xMax - xMin);
    height = round(yMax - yMin);
    
    panorama = zeros([height width 3], 'like', im2);
    
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  
    
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView = imref2d([height width], xLimits, yLimits);
    
    %%
    warpedImage = imwarp(im1, tforms(1), 'OutputView', panoramaView);
    mask = imwarp(true(size(im1,1),size(im1,2)), tforms(1), 'OutputView', panoramaView);
    panorama = step(blender, panorama, warpedImage, mask);
    %%

    %%
    warpedImage = imwarp(im2, tforms(2), 'OutputView', panoramaView);
    mask = imwarp(true(size(im2,1),size(im2,2)), tforms(2), 'OutputView', panoramaView);
    panorama = step(blender, panorama, warpedImage, mask);
    %%
end

