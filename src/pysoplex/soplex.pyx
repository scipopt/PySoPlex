##@file soplex.pyx
#@brief holding functions in python that reference the SoPlex public functions included in soplex.pxd
#TODO: add exceptions/errors when self._soplex is NULL
import sys
#import warnings

import cython
from libc.stdlib cimport malloc, free

# recommended SoPlex version; major version is required
MAJOR = 6
MINOR = 0
PATCH = 0

# for external user functions use def; for functions used only inside the interface (starting with _) use cdef
# todo: check whether this is currently done like this

if sys.version_info >= (3, 0):
    str_conversion = lambda x:bytes(x,'utf-8')
else:
    str_conversion = lambda x:x

PY_INTPARAM = {
    "OBJSENSE"              :  0,
    "REPRESENTATION"        :  1,
    "ALGORITHM"             :  2,
    "FACTOR_UPDATE_TYPE"    :  3,
    "FACTOR_UPDATE_MAX"     :  4,
    "ITERLIMIT"             :  5,
    "REFLIMIT"              :  6,
    "STALLREFLIMIT"         :  7,
    "DISPLAYFREQ"           :  8,
    "VERBOSITY"             :  9,
    "SIMPLIFIER"            :  10,
    "SCALER"                :  11,
    "STARTER"               :  12,
    "PRICER"                :  13,
    "RATIOTESTER"           :  14,
    "SYNCMODE"              :  15,
    "READMODE"              :  16,
    "SOLVEMODE"             :  17,
    "CHECKMODE"             :  18,
    "TIMER"                 :  19,
    "HYPER_PRICING"         :  20,
    "RATFAC_MINSTALLS"      :  21,
    "LEASTSQ_MAXROUNDS"     :  22,
    "SOLUTION_POLISHING"    :  23,
    "DECOMP_ITERLIMIT"      :  24,
    "DECOMP_MAXADDEDROWS"   :  25,
    "DECOMP_DISPLAYFREQ"    :  26,
    "DECOMP_VERBOSITY"      :  27,
    "PRINTBASISMETRIC"      :  28,
    "STATTIMER"             :  29,
    }

PY_STATUS = {
    "ERROR"          : -15, # an error occured.
    "NO_RATIOTESTER" : -14, # No ratiotester loaded
    "NO_PRICER"      : -13, # No pricer loaded
    "NO_SOLVER"      : -12, # No linear solver loaded
    "NOT_INIT"       : -11, # not initialised error
    "ABORT_EXDECOMP" : -10, # solve() aborted to exit decomposition simplex
    "ABORT_DECOMP"   : -9,  # solve() aborted due to commence decomposition simplex
    "ABORT_CYCLING"  : -8,  # solve() aborted due to detection of cycling.
    "ABORT_TIME"     : -7,  # solve() aborted due to time limit.
    "ABORT_ITER"     : -6,  # solve() aborted due to iteration limit.
    "ABORT_VALUE"    : -5,  # solve() aborted due to objective limit.
    "SINGULAR"       : -4,  # Basis is singular, numerical troubles?
    "NO_PROBLEM"     : -3,  # No Problem has been loaded.
    "REGULAR"        : -2,  # LP has a usable Basis (maybe LP is changed).
    "RUNNING"        : -1,  # algorithm is running
    "UNKNOWN"        :  0,  # nothing known on loaded problem.
    "OPTIMAL"        :  1,  # LP has been solved to optimality.
    "UNBOUNDED"      :  2,  # LP has been proven to be primal unbounded.
    "INFEASIBLE"     :  3,  # LP has been proven to be primal infeasible.
    "INForUNBD"      :  4,   # LP is primal infeasible or unbounded.
    "OPTIMAL_UNSCALED_VIOLATIONS" :  5,   # LP has beed solved to optimality but unscaled solution contains violations.
        }

# Mapping the SoPlex enums to a python classes
# This is required to return various values in the python code
"""
cdef class PY_BOOLPARAM:
    LIFTING                             =   LIFTING
    EQTRANS                             =   EQTRANS
    TESTDUALINF                         =   TESTDUALINF
    RATFAC                              =   RATFAC
    USEDECOMPDUALSIMPLEX                =   USEDECOMPDUALSIMPLEX
    COMPUTEDEGEN                        =   COMPUTEDEGEN
    USECOMPDUAL                         =   USECOMPDUAL
    EXPLICITVIOL                        =   EXPLICITVIOL
    ACCEPTCYCLING                       =   ACCEPTCYCLING
    RATREC                              =   RATREC
    POWERSCALING                        =   POWERSCALING
    RATFACJUMP                          =   RATFACJUMP
    ROWBOUNDFLIPS                       =   ROWBOUNDFLIPS
    PERSISTENTSCALING                   =   PERSISTENTSCALING
    FULLPERTURBATION                    =   FULLPERTURBATION
    ENSURERAY                           =   ENSURERAY
    FORCEBASIC                          =   FORCEBASIC
    SIMPLIFIER_SINGLETONCOLS            =   SIMPLIFIER_SINGLETONCOLS
    SIMPLIFIER_CONSTRAINTPROPAGATION    =   SIMPLIFIER_CONSTRAINTPROPAGATION
    SIMPLIFIER_PARALLELROWDETECTION     =   SIMPLIFIER_PARALLELROWDETECTION
    SIMPLIFIER_PARALLELCOLDETECTION     =   SIMPLIFIER_PARALLELCOLDETECTION
    SIMPLIFIER_SINGLETONSTUFFING        =   SIMPLIFIER_SINGLETONSTUFFING
    SIMPLIFIER_DUALFIX                  =   SIMPLIFIER_DUALFIX
    SIMPLIFIER_FIXCONTINUOUS            =   SIMPLIFIER_FIXCONTINUOUS
    SIMPLIFIER_DOMINATEDCOLS            =   SIMPLIFIER_DOMINATEDCOLS
"""

"""
cdef class PY_INTPARAM:
    PYOBJSENSE                =   OBJSENSE
    REPRESENTATION          =   REPRESENTATION
    ALGORITHM               =   ALGORITHM
    FACTOR_UPDATE_TYPE      =   FACTOR_UPDATE_TYPE
    FACTOR_UPDATE_MAX       =   FACTOR_UPDATE_MAX
    ITERLIMIT               =   ITERLIMIT
    REFLIMIT                =   REFLIMIT
    STALLREFLIMIT           =   STALLREFLIMIT
    DISPLAYFREQ             =   DISPLAYFREQ
    VERBOSITY               =   VERBOSITY
    SIMPLIFIER              =   SIMPLIFIER
    SCALER                  =   SCALER
    STARTER                 =   STARTER
    PRICER                  =   PRICER
    RATIOTESTER             =   RATIOTESTER
    SYNCMODE                =   SYNCMODE
    READMODE                =   READMODE
    SOLVEMODE               =   SOLVEMODE
    CHECKMODE               =   CHECKMODE
    TIMER                   =   TIMER
    HYPER_PRICING           =   HYPER_PRICING
    RATFAC_MINSTALLS        =   RATFAC_MINSTALLS
    LEASTSQ_MAXROUNDS       =   LEASTSQ_MAXROUNDS
    SOLUTION_POLISHING      =   SOLUTION_POLISHING
    DECOMP_ITERLIMIT        =   DECOMP_ITERLIMIT
    DECOMP_MAXADDEDROWS     =   DECOMP_MAXADDEDROWS
    DECOMP_DISPLAYFREQ      =   DECOMP_DISPLAYFREQ
    DECOMP_VERBOSITY        =   DECOMP_VERBOSITY
    PRINTBASISMETRIC        =   PRINTBASISMETRIC
    STATTIMER               =   STATTIMER
"""

"""
cdef class PY_REALPARAM:
    FEASTOL                     =   FEASTOL
    OPTTOL                      =   OPTTOL
    EPSILON_ZERO                =   EPSILON_ZERO
    EPSILON_FACTORIZATION       =   EPSILON_FACTORIZATION
    EPSILON_UPDATE              =   EPSILON_UPDATE
    EPSILON_PIVOT               =   EPSILON_PIVOT
    INFTY                       =   INFTY
    TIMELIMIT                   =   TIMELIMIT
    OBJLIMIT_LOWER              =   OBJLIMIT_LOWER
    OBJLIMIT_UPPER              =   OBJLIMIT_UPPER
    FPFEASTOL                   =   FPFEASTOL
    FPOPTTOL                    =   FPOPTTOL
    MAXSCALEINCR                =   MAXSCALEINCR
    LIFTMINVAL                  =   LIFTMINVAL
    LIFTMAXVAL                  =   LIFTMAXVAL
    SPARSITY_THRESHOLD          =   SPARSITY_THRESHOLD
    REPRESENTATION_SWITCH       =   REPRESENTATION_SWITCH
    RATREC_FREQ                 =   RATREC_FREQ
    MINRED                      =   MINRED
    REFAC_BASIS_NNZ             =   REFAC_BASIS_NNZ
    REFAC_UPDATE_FILL           =   REFAC_UPDATE_FILL
    REFAC_MEM_FACTOR            =   REFAC_MEM_FACTOR
    LEASTSQ_ACRCY               =   LEASTSQ_ACRCY
    OBJ_OFFSET                  =   OBJ_OFFSET
    MIN_MARKOWITZ               =   MIN_MARKOWITZ
    SIMPLIFIER_MODIFYROWFAC     =   SIMPLIFIER_MODIFYROWFAC
"""

"""
cdef class PY_STATUS:
    ERROR                        =  ERROR
    NO_RATIOTESTER               =  NO_RATIOTESTER
    NO_PRICER                    =  NO_PRICER
    NO_SOLVER                    =  NO_SOLVER
    NOT_INIT                     =  NOT_INIT
    ABORT_EXDECOMP               =  ABORT_EXDECOMP
    ABORT_DECOMP                 =  ABORT_DECOMP
    ABORT_CYCLING                =  ABORT_CYCLING
    ABORT_TIME                   =  ABORT_TIME
    ABORT_ITER                   =  ABORT_ITER
    ABORT_VALUE                  =  ABORT_VALUE
    SINGULAR                     =  SINGULAR
    NO_PROBLEM                   =  NO_PROBLEM
    REGULAR                      =  REGULAR
    RUNNING                      =  RUNNING
    UNKNOWN                      =  UNKNOWN
    OPTIMAL                      =  OPTIMAL
    UNBOUNDED                    =  UNBOUNDED
    INFEASIBLE                   =  INFEASIBLE
    INForUNBD                    =  INForUNBD
    OPTIMAL_UNSCALED_VIOLATIONS  =  OPTIMAL_UNSCALED_VIOLATIONS
"""

cdef class PY_OBJSENSE:
    MAXIMIZE = OBJSENSE_MAXIMIZE
    MINIMIZE = OBJSENSE_MINIMIZE

cdef class PY_REPRESENTATION:
    AUTO    = REPRESENTATION_AUTO
    COLUMN  = REPRESENTATION_COLUMN
    ROW     = REPRESENTATION_ROW

cdef class PY_ALGORITHM:
    PRIMAL  = ALGORITHM_PRIMAL
    DUAL    = ALGORITHM_DUAL

cdef class PY_FACTORUPDATETYPE:
    ETA  = FACTOR_UPDATE_TYPE_ETA
    FT   = FACTOR_UPDATE_TYPE_FT

cdef class PY_VERBOSITY:
    ERROR   = VERBOSITY_ERROR
    WARNING = VERBOSITY_WARNING
    DEBUG   = VERBOSITY_DEBUG
    NORMAL  = VERBOSITY_NORMAL
    HIGH    = VERBOSITY_HIGH
    FULL    = VERBOSITY_FULL

cdef class PY_SIMPLIFIER:
    OFF        = SIMPLIFIER_OFF
    INTERNAL   = SIMPLIFIER_INTERNAL
    PAPILO     = SIMPLIFIER_PAPILO
    AUTO       = SIMPLIFIER_AUTO

cdef class PY_SCALAR:
    OFF     = SCALER_OFF
    UNIEQUI = SCALER_UNIEQUI
    BIEQUI  = SCALER_BIEQUI
    GE01    = SCALER_GEO1
    GE08    = SCALER_GEO8
    LEASTSQ = SCALER_LEASTSQ
    GEOEQUI = SCALER_GEOEQUI

cdef class PY_STARTER:
    OFF     = STARTER_OFF
    WEIGHT  = STARTER_WEIGHT
    SUM     = STARTER_SUM
    VECTOR  = STARTER_VECTOR

cdef class PY_PRICER:
    AUTO       = PRICER_AUTO
    DANTZIG    = PRICER_DANTZIG
    PARMULT    = PRICER_PARMULT
    DEVEX      = PRICER_DEVEX
    QUICKSTEEP = PRICER_QUICKSTEEP
    STEEP      = PRICER_STEEP

cdef class PY_RATIOTESTER:
    TEXTBOOK      = RATIOTESTER_TEXTBOOK
    HARRIS        = RATIOTESTER_HARRIS
    FAST          = RATIOTESTER_FAST
    BOUNDFLIPPING = RATIOTESTER_BOUNDFLIPPING

cdef class PY_SYNCMODE:
    ONLYREAL   = SYNCMODE_ONLYREAL
    AUTO       = SYNCMODE_AUTO
    MANUAL     = SYNCMODE_MANUAL

cdef class PY_READMODE:
    REAL       = READMODE_REAL
    RATIONAL   = READMODE_RATIONAL

cdef class PY_SOLVEMODE:
    REAL       = SOLVEMODE_REAL
    AUTO       = SOLVEMODE_AUTO
    RATIONAL   = SOLVEMODE_RATIONAL

cdef class PY_CHECKMODE:
    REAL       = CHECKMODE_REAL
    AUTO       = CHECKMODE_AUTO
    RATIONAL   = CHECKMODE_RATIONAL

cdef class PY_TIMER:
    OFF        = TIMER_OFF
    CPU        = TIMER_CPU
    WALLCLOCK  = TIMER_WALLCLOCK

cdef class PY_HYPERPRICING:
    OFF  = HYPER_PRICING_OFF
    AUTO = HYPER_PRICING_AUTO
    ON   = HYPER_PRICING_ON

cdef class PY_SOLUTIONPOLISHING:
    OFF           = POLISHING_OFF
    INTEGRALITY   = POLISHING_INTEGRALITY
    FRACTIONALITY = POLISHING_FRACTIONALITY

cdef class Soplex:
    """Base class for SoPlex functions """

    def __init__(self):
        """
        :param problemName: name of the problem (default 'lp')
        """
#        if self.version() < MAJOR:
#            raise Exception("linked SoPlex is not compatible to this version of PySoPlex - use at least version", MAJOR)
#        if self.version() < MAJOR + MINOR/10.0 + PATCH/100.0:
#            warnings.warn("linked SoPlex {} is not recommended for this version of PySoPlex - use version {}.{}.{}".format(self.version(), MAJOR, MINOR, PATCH))

        self._soplex = SoPlex_create()
#        self._bestSol = <Solution> sourceModel._bestSol
#        n = str_conversion(problemName)

    def __dealloc__(self):
        # call C function directly, because we can no longer call this object's methods, according to
        # http://docs.cython.org/src/reference/extension_types.html#finalization-dealloc
        if self._soplex is not NULL:
           SoPlex_free(self._soplex)

    def readInstanceFile(self, fileName):
        if self._soplex is not NULL:
            return SoPlex_readInstanceFile(self._soplex, str_conversion(fileName))

    def readBasisFile(self, fileName):
        if self._soplex is not NULL:
            return SoPlex_readBasisFile(self._soplex, str_conversion(fileName))

    def readSettingsFile(self, fileName):
        if self._soplex is not NULL:
            return SoPlex_readSettingsFile(self._soplex, str_conversion(fileName))

    def clearLPReal(self):
        if self._soplex is not NULL:
            SoPlex_clearLPReal(self._soplex)

    def getNRows(self):
        if self._soplex is not NULL:
            return SoPlex_numRows(self._soplex)

    def getNCols(self):
        if self._soplex is not NULL:
            return SoPlex_numCols(self._soplex)

#    def setRational(self):
#        if self._soplex is not NULL:
#            SoPlex_setRational(self._soplex)

    def setIntParam(self, paramName, paramSetting):
        if self._soplex is not NULL and paramName in PY_INTPARAM:
            SoPlex_setIntParam(self._soplex, PY_INTPARAM[paramName], paramSetting)

    def getIntParam(self, paramName):
        if self._soplex is not NULL:
            return SoPlex_getIntParam(self._soplex, paramName)

    def addColReal(self, coeffs, size, nnz, objval, lb, ub):
        if self._soplex is not NULL:
            _coeffs = <double*> malloc(nnz * sizeof(double))

            for i in range(len(coeffs)):
                _coeffs[i] = coeffs[i]

            SoPlex_addColReal(self._soplex, _coeffs, size, nnz, objval, lb, ub)

            free(_coeffs)

    def addRowReal(self, coeffs, size, nnz, lb, ub):
        if self._soplex is not NULL:
            _coeffs = <double*> malloc(nnz * sizeof(double));

            for i in range(len(coeffs)):
                _coeffs[i] = coeffs[i]

            SoPlex_addRowReal(self._soplex, _coeffs, size, nnz, lb, ub)

            free(_coeffs)

    def getPrimalSolution(self):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _primsol = <double*> malloc(_ncols * sizeof(double))

            SoPlex_getPrimalReal(self._soplex, _primsol, _ncols)

            primsol = [0.0]*_ncols
            for i in range(_ncols):
                primsol[i] = _primsol[i]

            free(_primsol)
            return primsol

    def getDualSolution(self):
        #TODO: need to pass dim and assert if dim==_nrows?
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            _dualsol = <double*> malloc(_nrows * sizeof(double))

            SoPlex_getDualReal(self._soplex, _dualsol, _nrows)

            dualsol = [0.0]*_nrows
            for i in range(_nrows):
                dualsol[i] = _dualsol[i]

            free(_dualsol)
            return dualsol

    def solveLP(self):
        if self._soplex is not NULL:
            return SoPlex_optimize(self._soplex)

    def changeObjVector(self, coeffs):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _coeffs = <double*> malloc(_ncols * sizeof(double))

            for i in range(_ncols):
                _coeffs[i] = coeffs[i]

            SoPlex_changeObjReal(self._soplex, _coeffs, _ncols)

            free(_coeffs)

    def changeLHS(self, coeffs):
        #TODO: need to pass dim and assert if dim==_nrows?
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            _coeffs = <double*> malloc(_nrows * sizeof(double))

            for i in range(_nrows):
                _coeffs[i] = coeffs[i]

            SoPlex_changeLhsReal(self._soplex, _coeffs, _nrows)

            free(_coeffs)

    def changeRHS(self, coeffs):
        #TODO: need to pass dim and assert if dim==_nrows?
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            _coeffs = <double*> malloc(_nrows * sizeof(double))

            for i in range(_nrows):
                _coeffs[i] = coeffs[i]

            SoPlex_changeRhsReal(self._soplex, _coeffs, _nrows)

            free(_coeffs)

    def getObjValue(self):
        if self._soplex is not NULL:
            return SoPlex_objValueReal(self._soplex)

    def changeColBounds(self, lb, ub):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _lb = <double*> malloc(_ncols * sizeof(double))
            _ub = <double*> malloc(_ncols * sizeof(double))

            for i in range(_ncols):
                _lb[i] = lb[i]
                _ub[i] = ub[i]

            SoPlex_changeBoundsReal(self._soplex, _lb, _ub, _ncols)

            free(_ub)
            free(_lb)

    def changeColBound(self, colid, lb, ub):
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            assert(0 <= colid <= _ncols)

            SoPlex_changeVarBoundsReal(self._soplex, colid, lb, ub)

    def changeColUB(self, colid, ub):
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            assert(0 <= colid <= _ncols)

            SoPlex_changeVarUpperReal(self._soplex, colid, ub)

    def getColUBs(self):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _ub = <double*> malloc(_ncols * sizeof(double))

            SoPlex_getUpperReal(self._soplex, _ub, _ncols)

            ub = [0.0]*_ncols
            for i in range(_ncols):
                ub[i] = _ub[i]

            return ub
