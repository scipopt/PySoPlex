import pytest

from pysoplex import Soplex, INTPARAM, BOOLPARAM, REALPARAM, OBJSENSE, VERBOSITY

def test_test():
    # create solver instance
    s = Soplex()

    # read instance file, solve LP, and get objective value
    success = s.readInstanceFile("/scratch/opt/sbolusani/sw/PySoPlex/instances/egout_lp_version.mps")
    s.setBoolParam(BOOLPARAM.LIFTING, 1)
    s.setIntParam(INTPARAM.VERBOSITY, VERBOSITY.ERROR)
    s.optimize()
    obj_val = s.getObjValueReal()

    print("LP solved successfully with objective value = ", obj_val)

def test_test_again():
    # create solver instance
    s = Soplex()

    # read instance file again, solve LP, and get objective value
    success = s.readInstanceFile("/scratch/opt/sbolusani/sw/PySoPlex/instances/egout_lp_version.mps")
    s.setIntParam(INTPARAM.VERBOSITY, VERBOSITY.ERROR)
    s.setIntParam(INTPARAM.OBJSENSE, OBJSENSE.MINIMIZE)
    s.optimize()
    obj_val = s.getObjValueReal()

    print("LP solved again successfully with objective value = ", obj_val)

if __name__ == "__main__":
    test_test()
    test_test_again()
