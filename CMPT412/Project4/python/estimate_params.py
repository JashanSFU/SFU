import numpy as np
from scipy.linalg import svd, qr


def estimate_params(P):
    _, _, V = svd(P)
    c = V[-1, :3] / V[-1, 3] 
    A = P[:, :3]
    A_prime = np.flipud(A)

    Q, R = qr(A_prime.T)
   
    Q = np.flipud(Q.T)
    R = np.fliplr(np.flipud(R.T))
    
    
    K = R
    T = np.diag(np.sign(np.diag(K)))
    K = np.dot(K,T)
    
    R = np.dot(T,Q)
    
    if np.linalg.det(R) < 0:
        R =  -R    
    
    t = -R @ c.reshape(-1, 1) 
    
    return K, R, t