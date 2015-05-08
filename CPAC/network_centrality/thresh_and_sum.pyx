cimport numpy as np


###
# Just Threshold (Pofunur Eigenvector Centrality)
###

# Un-Weighted and Threshold
def thresh_binarize_float(np.ndarray[float, ndim=2] cmat, float thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = 1 * (cmat[i,j] > thresh)

def thresh_binarize_double(np.ndarray[double, ndim=2] cmat, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = 1 * (cmat[i,j] > thresh) 

# Weighted and Threshold
def thresh_weighted_float(np.ndarray[float, ndim=2] cmat, float thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = cmat[i,j] * (cmat[i,j] > thresh)

def thresh_weighted_double(np.ndarray[double, ndim=2] cmat, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = cmat[i,j] * (cmat[i,j] > thresh)

# Weighted and Transform and Threshold
def thresh_transform_weighted_float(np.ndarray[float, ndim=2] cmat, float thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = (1.0+cmat[i,j])/2.0 * (cmat[i,j] > thresh)

def thresh_transform_weighted_double(np.ndarray[double, ndim=2] cmat, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = (1.0+cmat[i,j])/2.0 * (cmat[i,j] > thresh)

# Weighted and Transform and no Threshold
def transform_weighted_float(np.ndarray[float, ndim=2] cmat):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = (1.0+cmat[i,j])/2.0

def transform_weighted_double(np.ndarray[double, ndim=2] cmat):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cmat[i,j] = (1.0+cmat[i,j])/2.0


###
# Threshold and Sum (Degree Centrality)
###

# Un-Weighted
def centrality_binarize_float(np.ndarray[float, ndim=2] cmat, np.ndarray[float, ndim=1] cent, float thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent[i] += 1.0*(cmat[i,j] > thresh)

def centrality_binarize_double(np.ndarray[double, ndim=2] cmat, np.ndarray[double, ndim=1] cent, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent[i] += 1.0*(cmat[i,j] > thresh)

# Weighted
def centrality_weighted_float(np.ndarray[float, ndim=2] cmat, np.ndarray[float, ndim=1] cent, float thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent[i] += cmat[i,j]*(cmat[i,j] > thresh)

def centrality_weighted_double(np.ndarray[double, ndim=2] cmat, np.ndarray[double, ndim=1] cent, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent[i] += cmat[i,j]*(cmat[i,j] > thresh)

# Both - Unweighted & Weighted
def centrality_both_float(np.ndarray[float, ndim=2] cmat, np.ndarray[float, ndim=1] cent_uwt, np.ndarray[float, ndim=1] cent_wt, float thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent_uwt[i] += cmat[i,j]*(cmat[i,j] > thresh)
            cent_wt[i]  += 1.0*(cmat[i,j] > thresh)

def centrality_both_double(np.ndarray[double, ndim=2] cmat, np.ndarray[double, ndim=1] cent_bin, np.ndarray[double, ndim=1] cent_wt, double thresh):
    cdef unsigned int i,j
    for i in xrange(cmat.shape[0]):
        for j in xrange(cmat.shape[1]):
            cent_bin[i] += cmat[i,j]*(cmat[i,j] > thresh)
            cent_wt[i]  += 1.0*(cmat[i,j] > thresh)

def cluster_coefficient(np.ndarray[float, ndim=2] cmat, np.ndarray[float, ndim=1] centCluster, float thresh):
    """ Global Cluster Coefficient
        To make this fucntion available the Cython code has to be compiled via
        ./setup.py build_ext --inplace    
    """
    cdef unsigned int i, j, k
    degree = np.zeros_like(cmat[0], dtype=cmat.dtype)
    for i in xrange(cmat.shape[0]):
        degree[i] = cmat[i].sum()
        for j in xrange(cmat.shape[1]):
            if (cmat[i, j] == 1):
                for k in xrange(cmat.shape[1]):
                    if ((cmat[i, k] == 1) and (cmat[j, k] == 1)):
                        if degree[i] > 1:
                            centCluster[i] += 1/(float(degree[i] * (degree[i] - 1.)))
                    