import numpy as np
import cv2

def epipolarCorrespondence(im1, im2, F, pts1):
   
    pts1 = np.array(pts1).reshape(-1, 2)
    homogeneous_pts1 = np.hstack((pts1, np.ones((pts1.shape[0], 1)))).T

    epipolar_lines = F @ homogeneous_pts1
    epipolar_lines /= np.abs(epipolar_lines[1, :] + np.finfo(float).eps)  

    x1, y1 = np.round(pts1[0]).astype(int)
    patch1 = im1[y1 - 3:y1 + 4, x1 - 3:x1 + 4, :]

    search_range = np.clip([x1 - 10, x1 + 11], 0, im1.shape[1])

    min_distance = float('inf')
    best_match = [x1, y1]  
    
    for x2 in range(*search_range):
        y2 = int(epipolar_lines[0, 0] * x2 + epipolar_lines[2, 0])
        if 3 <= y2 < im2.shape[0] - 4:
            patch2 = im2[y2 - 3:y2 + 4, x2 - 3:x2 + 4]
            distance = np.sqrt(np.sum((patch2 - patch1) ** 2))

            if distance < min_distance:
                min_distance = distance
                best_match = [x2, y2]

    return np.array(best_match).reshape(1, -1)