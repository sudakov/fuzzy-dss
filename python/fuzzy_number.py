import numpy as np
from pandas import DataFrame

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

    def prep_scale(self, other):
        scale = np.union1d(self.polyline[:,0], other.polyline[:,0])
        scale_add = []
        for x1, x2 in zip(scale[:-1],scale[1:]):
            ys1 = self.get_membership(x1)
            ys2 = self.get_membership(x2)
            yo1 = other.get_membership(x1)
            yo2 = other.get_membership(x2)
            if (ys1 > yo1 and ys2 < yo2) or (ys1 < yo1 and ys2 > yo2):
                a_s,b_s = self.get_ab( [x1,ys1], [x2,ys2] )
                a_o,b_o = self.get_ab( [x1,yo1], [x2,yo2] )
                scale_add.append(round((b_o-b_s)/(a_s-a_o),5))
        return np.union1d(scale,scale_add)

    def __eq__(self, other):
        scale = np.union1d(self.polyline[:,0], other.polyline[:,0])
        return 1.0 - max(abs(self.get_membership(x) - other.get_membership(x)) for x in scale)

    def __ge__(self, other):
        scale = self.prep_scale(other)
        mh = np.array(np.meshgrid(scale,scale)).T.reshape(-1,2)
        return max( min(self.get_membership(x[0]),other.get_membership(x[1]))
                    for x in mh if x[0] >= x[1] )

    def __le__(self, other):
        return other >= self

    def general_operation(self, other,operation):
        scale = self.prep_scale(other)
        mh = np.array(np.meshgrid(scale,scale)).T.reshape(-1,2)
        y = np.round(operation(mh[:,0],mh[:,1]),5)
        mu = [ min(self.get_membership(x[0]),other.get_membership(x[1]))
                    for x in mh ]
        df = DataFrame(dict(y=y, mu=mu))
        s = df.groupby('y')['mu'].max()
        a = self.polyline[0][0]
        b = self.polyline[-1][0]
        for yy in s.index:
            if yy == 0 and operation == np.divide:
                continue
            for s1 in np.linspace(a,b,1000):
                if s1 == 0 and operation == np.multiply:
                    continue
                s2 = {
                    np.multiply: yy / s1,
                    np.add: yy - s1,
                    np.subtract: s1 - yy,
                    np.divide: s1 / yy
                }[operation]
                m = min(self.get_membership(s1),other.get_membership(s2))
                if s[yy] < m:
                    s[yy] = m
        return FuzzyNumber(list(zip(s.index,s.values)))

    def __add__(self,other):
        return self.general_operation(other, np.add)

    def __sub__(self,other):
        return self.general_operation(other, np.subtract)

    def __mul__(self,other):
        return self.general_operation(other, np.multiply)

    def __truediv__(self,other):
        return self.general_operation(other, np.divide)

    def __repr__(self):
        spolyline = repr(self.polyline)
        spolyline = spolyline[spolyline.find('['):-1]
        return f"FuzzyNumber({spolyline})"

    def clip_membership( self, a ):
        b = self.polyline[:,1].reshape(-1,1)
        return FuzzyNumber(list(zip(self.polyline[:,0], np.min(np.insert(b,1,a,axis=1),axis=1))))

    def get_max_membership(self):
        return np.max(self.polyline[:,1])

    def logic_operation(self, other, operation):
        scale = self.prep_scale(other).reshape(-1,1)
        mus = np.apply_along_axis(self.get_membership, 1, scale)
        muo = np.apply_along_axis(other.get_membership, 1, scale)
        polyline = np.hstack((scale, operation(np.vstack((mus,muo)),axis=0).reshape(-1,1)))
        return FuzzyNumber(polyline)

    def __and__(self, other):
        return self.logic_operation(other, np.min)

    def __or__(self, other):
        return self.logic_operation(other, np.max)

    def defuzzification(self):
        a,b = self.get_ab(self.polyline[:-1].T, self.polyline[1:].T)
        s1 = np.sum(a * (self.polyline[1:,0]**3 - self.polyline[:-1,0]**3)/3.0 + \
             b * (self.polyline[1:,0]**2 - self.polyline[:-1,0]**2)/2.0)
        s2 =  np.sum(0.5 * (self.polyline[1:,0] - self.polyline[:-1,0]) * \
             (self.polyline[1:,1] + self.polyline[:-1,1]))
        return s1 / s2
