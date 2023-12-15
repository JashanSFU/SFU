import numpy as np

def rectify_pair(K1, K2, R1, R2, t1, t2):
    c1 = -np.linalg.inv(K1 @ R1) @ (K1 @ t1.reshape(-1, 1))
    c2 = -np.linalg.inv(K2 @ R2) @ (K2 @ t2.reshape(-1, 1))
    
    r1 = (c1 - c2) / np.linalg.norm(c1 - c2).reshape(-1, 1) 
    
    r2 = np.cross(R1[2, :].flatten(),r1.flatten()).reshape(-1, 1)
    
    r3 = np.cross(r2.flatten(), r1.flatten()).reshape(-1, 1)
    R1n = np.hstack((r1, r2, r3)).T
    
    r1_b = (c1 - c2) / np.linalg.norm(c1 - c2)
    r2_b = np.cross( R2[2, :].flatten(), r1_b.flatten()).reshape(-1, 1)
    r3_b = np.cross(r2_b.flatten(), r1_b.flatten()).reshape(-1, 1)
    R2n = np.hstack((r1_b, r2_b,r3_b)).T
    R2n = np.vstack((r1.flatten(), np.cross(R2[2, :].flatten(), r1.flatten()), np.cross(r1.flatten(), np.cross(R2[2, :].flatten(), r1.flatten())))).T
    
    K1n = K2.copy()
    K2n = K2.copy()
    
    t1n = - R1n @ c1
    t2n = - R1n @ c2
    
    M1 = (K1n @ R1n) @ np.linalg.inv(K1)
    M2 = (K2n @ R1n) @ np.linalg.inv(K2)

    return M1, M2, K1n, K2n, R1n, R2n, t1n, t2n