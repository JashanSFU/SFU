import numpy as np
import cv2

def get_disparity(image1, image2, max_disparity, window_size):
    
    image1 = image1.astype(np.float64)
    image2 = image2.astype(np.float64)

    disparity_map = np.zeros_like(image1)
    min_disparity_cost = np.full_like(image1, np.inf)

    averaging_mask = np.ones((window_size, window_size))

    for disparity in range(max_disparity + 1):
        translated_image2 = np.roll(image2, disparity, axis=1)
        translated_image2[:, :disparity] = 255

        squared_diff = cv2.filter2D((image1 - translated_image2) ** 2, -1, averaging_mask, borderType=cv2.BORDER_CONSTANT)

        update_mask = squared_diff < min_disparity_cost
        disparity_map[update_mask] = disparity
        min_disparity_cost = np.minimum(min_disparity_cost, squared_diff)

    return disparity_map