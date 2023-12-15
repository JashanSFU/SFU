import numpy as np

def triangulate(P1, pts1, P2, pts2):
    
    num = pts1.shape[0]
    pts3d = np.zeros((num, 3))

    for i in range(num):
            x1, y1 = pts1[i]
            x2, y2 = pts2[i]
            
            Row1 = y1 * P1[2, :] - P1[1, :]
            Row2 = P1[0, :] - x1 * P1[2, :]
            Row3 =  y2 * P2[2, :] - P2[1, :]
            Row4 = P2[0, :] - x2 * P2[2, :]
            A = np.array([Row1,Row2,Row3,Row4])

            _, _, Vt = np.linalg.svd(A)
            V = Vt[-1]

            pts3d[i, :] = V[:3] / V[3]

    return pts3d