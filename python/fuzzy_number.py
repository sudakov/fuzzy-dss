import numpy as np

class FuzzyNumber:
    def __init__(self, polyline):
        self.polyline = np.array(polyline, np.float64)

    @staticmethod
    def get_ab( point1, point2 ):
        a = (point2[1]-point1[1])/(point2[0]-point1[0])
        b = point1[1] - a * point1[0]
        return a,b

    def get_membership(self, x):
        if x <= self.polyline[0,0]:
            return self.polyline[0,1]

        if x >= self.polyline[-1,0]:
            return self.polyline[-1,1]

        inds = np.where(self.polyline[:,0] == x)

        if len(inds)>0 and inds[0].size > 0:
            return self.polyline[inds[0][-1],1]

        inds = np.where((self.polyline[:-1,0] < x) & (self.polyline[1:,0] > x) )

        if len(inds)==0 or inds[0].size == 0:
            raise ValueError("Can not find point")

        a,b = self.get_ab( self.polyline[inds[0][0]], self.polyline[inds[0][0]+1] )
        return (a * x + b)
