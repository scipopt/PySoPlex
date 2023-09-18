import pytest

from pysoplex import Soplex, INTPARAM, BOOLPARAM, REALPARAM, OBJSENSE, VERBOSITY

def test_read_and_optimize():
    # create solver instance
    s = Soplex()

    # read instance file, solve LP, and get objective value
    success = s.readInstanceFile("instances/egout_lp.mps")
    s.setBoolParam(BOOLPARAM.LIFTING, 1)
    s.setIntParam(INTPARAM.VERBOSITY, VERBOSITY.ERROR)
    s.optimize()
    obj_val = s.getObjValueReal()

    assert(abs(obj_val - 1.49588766e+02) <= 1e-6)

def test_read_and_optimize_again():
    # create solver instance
    s = Soplex()

    # read instance file again, solve LP, and get objective value
    success = s.readInstanceFile("instances/egout_lp.mps")
    s.setIntParam(INTPARAM.VERBOSITY, VERBOSITY.ERROR)
    s.setIntParam(INTPARAM.OBJSENSE, OBJSENSE.MINIMIZE)
    s.optimize()
    obj_val = s.getObjValueReal()

    assert(abs(obj_val - 1.49588766e+02) <= 1e-6)
