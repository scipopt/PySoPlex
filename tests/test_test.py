import pytest

from pysoplex import Soplex

def test_test():
    # create solver instance
    s = Soplex()

    # read instance file, solve LP, and get objective value
    success = s.readInstanceFile("/scratch/opt/sbolusani/sw/PySoPlex/instances/egout_lp_version.mps")
    s.solveLP()
    obj_val = s.getObjValue()

    print("LP solved successfully with objective value = ", obj_val)

if __name__ == "__main__":
    test_test()
