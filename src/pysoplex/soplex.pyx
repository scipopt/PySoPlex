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

cdef class PY_BOOLPARAM:
    # should lifting be used to reduce range of nonzero matrix coefficients?
    LIFTING = 0

    # should LP be transformed to equality form before a rational solve?
    EQTRANS = 1

    # should dual infeasibility be tested in order to try to return a dual solution even if primal infeasible?
    TESTDUALINF = 2

    # should a rational factorization be performed after iterative refinement?
    RATFAC = 3

    # should the decomposition based dual simplex be used to solve the LP? Setting this to true forces the solve mode to
    # SOLVEMODE_REAL and the basis representation to REPRESENTATION_ROW
    USEDECOMPDUALSIMPLEX = 4

    # should the degeneracy be computed for each basis?
    COMPUTEDEGEN = 5

    # should the dual of the complementary problem be used in the decomposition simplex?
    USECOMPDUAL = 6

    # should row and bound violations be computed explicitly in the update of reduced problem in the decomposition simplex
    EXPLICITVIOL = 7

    # should cycling solutions be accepted during iterative refinement?
    ACCEPTCYCLING = 8

    # apply rational reconstruction after each iterative refinement?
    RATREC = 9

    # round scaling factors for iterative refinement to powers of two?
    POWERSCALING = 10

    # continue iterative refinement with exact basic solution if not optimal?
    RATFACJUMP = 11

    # use bound flipping also for row representation?
    ROWBOUNDFLIPS = 12

    # use persistent scaling?
    PERSISTENTSCALING = 13

    # perturb the entire problem or only the relevant bounds of s single pivot?
    FULLPERTURBATION = 14

    # re-optimize the original problem to get a proof (ray) of infeasibility/unboundedness?
    ENSURERAY = 15

    # try to enforce that the optimal solution is a basic solution
    FORCEBASIC = 16

    # enable presolver SingletonCols in PaPILO?
    SIMPLIFIER_SINGLETONCOLS = 17

    # enable presolver ConstraintPropagation in PaPILO?
    SIMPLIFIER_CONSTRAINTPROPAGATION = 18

    # enable presolver ParallelRowDetection in PaPILO?
    SIMPLIFIER_PARALLELROWDETECTION = 19

    # enable presolver ParallelColDetection in PaPILO?
    SIMPLIFIER_PARALLELCOLDETECTION = 20

    # enable presolver SingletonStuffing in PaPILO?
    SIMPLIFIER_SINGLETONSTUFFING = 21

    # enable presolver DualFix in PaPILO?
    SIMPLIFIER_DUALFIX = 22

    # enable presolver FixContinuous in PaPILO?
    SIMPLIFIER_FIXCONTINUOUS = 23

    # enable presolver DominatedCols in PaPILO?
    SIMPLIFIER_DOMINATEDCOLS = 24

cdef class PY_INTPARAM:
    # objective sense
    OBJSENSE = 0

    # type of computational form i.e., column or row representation
    REPRESENTATION = 1

    # type of algorithm i.e., primal or dual
    ALGORITHM = 2

    # type of LU update
    FACTOR_UPDATE_TYPE = 3

    # maximum number of updates without fresh factorization
    FACTOR_UPDATE_MAX = 4

    # iteration limit (-1 if unlimited)
    ITERLIMIT = 5

    # refinement limit (-1 if unlimited)
    REFLIMIT = 6

    # stalling refinement limit (-1 if unlimited)
    STALLREFLIMIT = 7

    # display frequency
    DISPLAYFREQ = 8

    # verbosity level
    VERBOSITY = 9

    # type of simplifier
    SIMPLIFIER = 10

    # type of scaler
    SCALER = 11

    # type of starter used to create crash basis
    STARTER = 12

    # type of pricer
    PRICER = 13

    # type of ratio test
    RATIOTESTER = 14

    # mode for synchronizing real and rational LP
    SYNCMODE = 15

    # mode for reading LP files
    READMODE = 16

    # mode for iterative refinement strategy
    SOLVEMODE = 17

    # mode for a posteriori feasibility checks
    CHECKMODE = 18

    # type of timer
    TIMER = 19

    # mode for hyper sparse pricing
    HYPER_PRICING = 20

    # minimum number of stalling refinements since last pivot to trigger rational factorization
    RATFAC_MINSTALLS = 21

    # maximum number of conjugate gradient iterations in least square scaling
    LEASTSQ_MAXROUNDS = 22

    # mode for solution polishing
    SOLUTION_POLISHING = 23

    # the number of iterations before the decomposition simplex initialisation is terminated.
    DECOMP_ITERLIMIT = 24

    # the maximum number of rows that are added in each iteration of the decomposition based simplex
    DECOMP_MAXADDEDROWS = 25

    # the iteration frequency at which the decomposition solve output is displayed.
    DECOMP_DISPLAYFREQ = 26

    # the verbosity of the decomposition based simplex
    DECOMP_VERBOSITY = 27

    # print condition number during the solve
    PRINTBASISMETRIC = 28

    # type of timer for statistics
    STATTIMER = 29

cdef class PY_REALPARAM:
    # primal feasibility tolerance
    FEASTOL = 0

    # dual feasibility tolerance
    OPTTOL = 1

    # general zero tolerance
    EPSILON_ZERO = 2

    # zero tolerance used in factorization
    EPSILON_FACTORIZATION = 3

    # zero tolerance used in update of the factorization
    EPSILON_UPDATE = 4

    # pivot zero tolerance used in factorization
    EPSILON_PIVOT = 5

    # infinity threshold
    INFTY = 6

    # time limit in seconds (INFTY if unlimited)
    TIMELIMIT = 7

    # lower limit on objective value
    OBJLIMIT_LOWER = 8

    # upper limit on objective value
    OBJLIMIT_UPPER = 9

    # working tolerance for feasibility in floating-point solver during iterative refinement
    FPFEASTOL = 10

    # working tolerance for optimality in floating-point solver during iterative refinement
    FPOPTTOL = 11

    # maximum increase of scaling factors between refinements
    MAXSCALEINCR = 12

    # lower threshold in lifting (nonzero matrix coefficients with smaller absolute value will be reformulated)
    LIFTMINVAL = 13

    # upper threshold in lifting (nonzero matrix coefficients with larger absolute value will be reformulated)
    LIFTMAXVAL = 14

    # sparse pricing threshold (\#violations < dimension * SPARSITY_THRESHOLD activates sparse pricing)
    SPARSITY_THRESHOLD = 15

    # threshold on number of rows vs. number of columns for switching from column to row representations in auto mode
    REPRESENTATION_SWITCH = 16

    # geometric frequency at which to apply rational reconstruction
    RATREC_FREQ = 17

    # minimal reduction (sum of removed rows/cols) to continue simplification
    MINRED = 18

    # refactor threshold for nonzeros in last factorized basis matrix compared to updated basis matrix
    REFAC_BASIS_NNZ = 19

    # refactor threshold for fill-in in current factor update compared to fill-in in last factorization
    REFAC_UPDATE_FILL = 20

    # refactor threshold for memory growth in factorization since last refactorization
    REFAC_MEM_FACTOR = 21

    # accuracy of conjugate gradient method in least squares scaling (higher value leads to more iterations)
    LEASTSQ_ACRCY = 22

    # objective offset
    OBJ_OFFSET = 23

    # minimal Markowitz threshold to control sparsity/stability in LU factorization
    MIN_MARKOWITZ = 24

    # minimal modification threshold to apply presolve reductions
    SIMPLIFIER_MODIFYROWFAC = 25

cdef class PY_STATUS:
    ERROR          = -15 # an error occured.
    NO_RATIOTESTER = -14 # No ratiotester loaded
    NO_PRICER      = -13 # No pricer loaded
    NO_SOLVER      = -12 # No linear solver loaded
    NOT_INIT       = -11 # not initialised error
    ABORT_EXDECOMP = -10 # solve() aborted to exit decomposition simplex
    ABORT_DECOMP   = -9  # solve() aborted due to commence decomposition simplex
    ABORT_CYCLING  = -8  # solve() aborted due to detection of cycling.
    ABORT_TIME     = -7  # solve() aborted due to time limit.
    ABORT_ITER     = -6  # solve() aborted due to iteration limit.
    ABORT_VALUE    = -5  # solve() aborted due to objective limit.
    SINGULAR       = -4  # Basis is singular, numerical troubles?
    NO_PROBLEM     = -3  # No Problem has been loaded.
    REGULAR        = -2  # LP has a usable Basis (maybe LP is changed).
    RUNNING        = -1  # algorithm is running
    UNKNOWN        =  0  # nothing known on loaded problem.
    OPTIMAL        =  1  # LP has been solved to optimality.
    UNBOUNDED      =  2  # LP has been proven to be primal unbounded.
    INFEASIBLE     =  3  # LP has been proven to be primal infeasible.
    INForUNBD      =  4   # LP is primal infeasible or unbounded.
    OPTIMAL_UNSCALED_VIOLATIONS =  5   # LP has beed solved to optimality but unscaled solution contains violations.

cdef class PY_OBJSENSE:
    MINIMIZE = -1
    MAXIMIZE = 1

cdef class PY_REPRESENTATION:
    AUTO    = 0
    COLUMN  = 1
    ROW     = 2

cdef class PY_ALGORITHM:
    PRIMAL  = 0
    DUAL    = 1

cdef class PY_FACTORUPDATETYPE:
    ETA  = 0
    FT   = 1

cdef class PY_VERBOSITY:
    ERROR   = 0
    WARNING = 1
    DEBUG   = 2
    NORMAL  = 3
    HIGH    = 4
    FULL    = 5

cdef class PY_SIMPLIFIER:
    OFF        = 0
    INTERNAL   = 3
    PAPILO     = 2
    AUTO       = 1

cdef class PY_SCALAR:
    OFF     = 0
    UNIEQUI = 1
    BIEQUI  = 2
    GE01    = 3
    GE08    = 4
    LEASTSQ = 5
    GEOEQUI = 6

cdef class PY_STARTER:
    OFF     = 0
    WEIGHT  = 1
    SUM     = 2
    VECTOR  = 3

cdef class PY_PRICER:
    AUTO       = 0
    DANTZIG    = 1
    PARMULT    = 2
    DEVEX      = 3
    QUICKSTEEP = 4
    STEEP      = 5

cdef class PY_RATIOTESTER:
    TEXTBOOK      = 0
    HARRIS        = 1
    FAST          = 2
    BOUNDFLIPPING = 3

cdef class PY_SYNCMODE:
    ONLYREAL   = 0
    AUTO       = 1
    MANUAL     = 2

cdef class PY_READMODE:
    REAL       = 0
    RATIONAL   = 1

cdef class PY_SOLVEMODE:
    REAL       = 0
    AUTO       = 1
    RATIONAL   = 2

cdef class PY_CHECKMODE:
    REAL       = 0
    AUTO       = 1
    RATIONAL   = 2

cdef class PY_TIMER:
    OFF        = 0
    CPU        = 1
    WALLCLOCK  = 2

cdef class PY_HYPERPRICING:
    OFF  = 0
    AUTO = 1
    ON   = 2

cdef class PY_SOLUTIONPOLISHING:
    OFF           = 0
    INTEGRALITY   = 1
    FRACTIONALITY = 2

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

    def writeInstanceReal(self, fileName):
        if self._soplex is not NULL:
            SoPlex_writeFileReal(self._soplex, str_conversion(fileName))

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

    def setBoolParam(self, paramName, paramSetting):
        if self._soplex is not NULL:
            SoPlex_setBoolParam(self._soplex, paramName, paramSetting)

    def setIntParam(self, paramName, paramSetting):
        if self._soplex is not NULL:
            SoPlex_setIntParam(self._soplex, paramName, paramSetting)

    def setRealParam(self, paramName, paramSetting):
        if self._soplex is not NULL:
            SoPlex_setRealParam(self._soplex, paramName, paramSetting)

    def getIntParam(self, paramName):
        if self._soplex is not NULL:
            return SoPlex_getIntParam(self._soplex, paramName)

    def addColReal(self, coeffs, size, nnz, objval, lb, ub):
        if self._soplex is not NULL:
            _coeffs = <double*> malloc(size * sizeof(double))

            for i in range(len(coeffs)):
                _coeffs[i] = coeffs[i]

            SoPlex_addColReal(self._soplex, _coeffs, size, nnz, objval, lb, ub)

            free(_coeffs)

    def removeColReal(self, colid):
        if self._soplex is not NULL:
            SoPlex_removeColReal(self._soplex, colid)

    def addRowReal(self, coeffs, size, nnz, lb, ub):
        if self._soplex is not NULL:
            _coeffs = <double*> malloc(size * sizeof(double));

            for i in range(len(coeffs)):
                _coeffs[i] = coeffs[i]

            SoPlex_addRowReal(self._soplex, _coeffs, size, nnz, lb, ub)

            free(_coeffs)

    def removeRowReal(self, rowid):
        if self._soplex is not NULL:
            SoPlex_removeRowReal(self._soplex, rowid)

    def getPrimalSolutionReal(self):
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

    def getDualSolutionReal(self):
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

    def getReducedCostReal(self):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _rc = <double*> malloc(_ncols * sizeof(double))

            SoPlex_getRedCostReal(self._soplex, _rc, _ncols)

            rc = [0.0]*_ncols
            for i in range(_ncols):
                rc[i] = _rc[i]

            free(_rc)
            return rc

    def optimize(self):
        if self._soplex is not NULL:
            return SoPlex_optimize(self._soplex)

    def getStatus(self):
        if self._soplex is not NULL:
            return SoPlex_getStatus(self._soplex)

    def getSolvingTime(self):
        if self._soplex is not NULL:
            return SoPlex_getSolvingTime(self._soplex)

    def getNIterations(self):
        if self._soplex is not NULL:
            return SoPlex_getNumIterations(self._soplex)

    def changeObjVectorReal(self, coeffs):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _coeffs = <double*> malloc(_ncols * sizeof(double))

            for i in range(_ncols):
                _coeffs[i] = coeffs[i]

            SoPlex_changeObjReal(self._soplex, _coeffs, _ncols)

            free(_coeffs)

    def changeLHSReal(self, lhs):
        #TODO: need to pass dim and assert if dim==_nrows?
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            _lhs = <double*> malloc(_nrows * sizeof(double))

            for i in range(_nrows):
                _lhs[i] = lhs[i]

            SoPlex_changeLhsReal(self._soplex, _lhs, _nrows)

            free(_lhs)

    def changeRowLHSReal(self, rowid, lhs):
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            assert(0 <= rowid <= _nrows-1)

            SoPlex_changeRowLhsReal(self._soplex, rowid, lhs)

    def changeRHSReal(self, rhs):
        #TODO: need to pass dim and assert if dim==_nrows?
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            _rhs = <double*> malloc(_nrows * sizeof(double))

            for i in range(_nrows):
                _rhs[i] = rhs[i]

            SoPlex_changeRhsReal(self._soplex, _rhs, _nrows)

            free(_rhs)

    def changeRowRHSReal(self, rowid, rhs):
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            assert(0 <= rowid <= _nrows-1)

            SoPlex_changeRowRhsReal(self._soplex, rowid, rhs)

    def changeRangeReal(self, lhs, rhs):
        #TODO: need to pass dim and assert if dim==_nrows?
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            _lhs = <double*> malloc(_nrows * sizeof(double))
            _rhs = <double*> malloc(_nrows * sizeof(double))

            for i in range(_nrows):
                _lhs[i] = lhs[i]
                _rhs[i] = rhs[i]

            SoPlex_changeRangeReal(self._soplex, _lhs, _rhs, _nrows)
            free(_rhs)
            free(_lhs)

    def changeRowRangeReal(self, rowid, lhs, rhs):
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            assert(0 <= rowid <= _nrows-1)

            SoPlex_changeRowRangeReal(self._soplex, rowid, lhs, rhs)

    def getObjValueReal(self):
        if self._soplex is not NULL:
            return SoPlex_objValueReal(self._soplex)

    def changeBoundsReal(self, lb, ub):
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

    def changeColBoundsReal(self, colid, lb, ub):
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            assert(0 <= colid <= _ncols-1)

            SoPlex_changeVarBoundsReal(self._soplex, colid, lb, ub)

    def changeLBsReal(self, lb):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _lb = <double*> malloc(_ncols * sizeof(double))

            for i in range(_ncols):
                _lb[i] = lb[i]

            SoPlex_changeLowerReal(self._soplex, _lb, _ncols)

            free(_lb)

    def changeColLBReal(self, colid, lb):
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            assert(0 <= colid <= _ncols-1)

            SoPlex_changeVarLowerReal(self._soplex, colid, lb)

    def getColLBsReal(self):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _lb = <double*> malloc(_ncols * sizeof(double))

            SoPlex_getLowerReal(self._soplex, _lb, _ncols)

            lb = [0.0]*_ncols
            for i in range(_ncols):
                lb[i] = _lb[i]

            free(_lb)
            return lb

    def changeUBsReal(self, ub):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _ub = <double*> malloc(_ncols * sizeof(double))

            for i in range(_ncols):
                _ub[i] = ub[i]

            SoPlex_changeUpperReal(self._soplex, _ub, _ncols)

            free(_ub)

    def changeColUBReal(self, colid, ub):
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            assert(0 <= colid <= _ncols-1)

            SoPlex_changeVarUpperReal(self._soplex, colid, ub)

    def getColUBsReal(self):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _ub = <double*> malloc(_ncols * sizeof(double))

            SoPlex_getUpperReal(self._soplex, _ub, _ncols)

            ub = [0.0]*_ncols
            for i in range(_ncols):
                ub[i] = _ub[i]

            free(_ub)
            return ub

    def getObjVectorReal(self):
        #TODO: need to pass dim and assert if dim==_ncols?
        if self._soplex is not NULL:
            _ncols = self.getNCols()
            _obj = <double*> malloc(_ncols * sizeof(double))

            SoPlex_getObjReal(self._soplex, _obj, _ncols)

            obj = [0.0]*_ncols
            for i in range(_ncols):
                obj[i] = _obj[i]

            free(_obj)
            return obj

    def getRowRangeReal(self, rowid):
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            assert(0 <= rowid <= _nrows-1)
            _lhs = <double*> malloc(1 * sizeof(double))
            _rhs = <double*> malloc(1 * sizeof(double))

            SoPlex_getRowBoundsReal(self._soplex, rowid, _lhs, _rhs)

            lhs = _lhs[0]
            rhs = _rhs[0]

            free(_lhs)
            free(_rhs)
            return (lhs, rhs)

    def getRowVectorReal(self, rowid):
        if self._soplex is not NULL:
            _nrows = self.getNRows()
            assert(0 <= rowid <= _nrows-1)
            _coefs = <double*> malloc(_nrows * sizeof(double))
            _inds = <long*> malloc(_nrows * sizeof(long))
            _nnz = <int*> malloc(1 * sizeof(int))

            SoPlex_getRowVectorReal(self._soplex, rowid, _nnz, _inds, _coefs)

            nnz = _nnz[0]
            coefs = [0.0]*nnz
            inds = [-1]*nnz
            for i in range(nnz):
                coefs[i] = _coefs[i]
                inds[i] = _inds[i]

            free(_nnz)
            free(_inds)
            free(_coefs)
            return (nnz, inds, coefs)
