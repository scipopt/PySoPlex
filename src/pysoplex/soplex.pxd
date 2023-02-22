##@file soplex.pxd
#@brief holding prototype of the SoPlex public functions to use them in PySoPlex

#cdef extern from "soplex.h" namespace "soplex":
    # SoPlex internal types
#    ctypedef enum IntParam:
#        OBJSENSE              =  0
#        REPRESENTATION        =  1
#        ALGORITHM             =  2
#        FACTOR_UPDATE_TYPE    =  3
#        FACTOR_UPDATE_MAX     =  4
#        ITERLIMIT             =  5
#        REFLIMIT              =  6
#        STALLREFLIMIT         =  7
#        DISPLAYFREQ           =  8
#        VERBOSITY             =  9
#        SIMPLIFIER            =  10
#        SCALER                =  11
#        STARTER               =  12
#        PRICER                =  13
#        RATIOTESTER           =  14
#        SYNCMODE              =  15
#        READMODE              =  16
#        SOLVEMODE             =  17
#        CHECKMODE             =  18
#        TIMER                 =  19
#        HYPER_PRICING         =  20
#        RATFAC_MINSTALLS      =  21
#        LEASTSQ_MAXROUNDS     =  22
#        SOLUTION_POLISHING    =  23
#        DECOMP_ITERLIMIT      =  24
#        DECOMP_MAXADDEDROWS   =  25
#        DECOMP_DISPLAYFREQ    =  26
#        DECOMP_VERBOSITY      =  27
#        PRINTBASISMETRIC      =  28
#        STATTIMER             =  29
#        INTPARAM_COUNT        =  30

#    ctypedef enum Status:
#        ERROR          = -15, # an error occured.
#        NO_RATIOTESTER = -14, # No ratiotester loaded
#        NO_PRICER      = -13, # No pricer loaded
#        NO_SOLVER      = -12, # No linear solver loaded
#        NOT_INIT       = -11, # not initialised error
#        ABORT_EXDECOMP = -10, # solve() aborted to exit decomposition simplex
#        ABORT_DECOMP   = -9,  # solve() aborted due to commence decomposition simplex
#        ABORT_CYCLING  = -8,  # solve() aborted due to detection of cycling.
#        ABORT_TIME     = -7,  # solve() aborted due to time limit.
#        ABORT_ITER     = -6,  # solve() aborted due to iteration limit.
#        ABORT_VALUE    = -5,  # solve() aborted due to objective limit.
#        SINGULAR       = -4,  # Basis is singular, numerical troubles?
#        NO_PROBLEM     = -3,  # No Problem has been loaded.
#        REGULAR        = -2,  # LP has a usable Basis (maybe LP is changed).
#        RUNNING        = -1,  # algorithm is running
#        UNKNOWN        =  0,  # nothing known on loaded problem.
#        OPTIMAL        =  1,  # LP has been solved to optimality.
#        UNBOUNDED      =  2,  # LP has been proven to be primal unbounded.
#        INFEASIBLE     =  3,  # LP has been proven to be primal infeasible.
#        INForUNBD      =  4,   # LP is primal infeasible or unbounded.
#        OPTIMAL_UNSCALED_VIOLATIONS =  5   # LP has beed solved to optimality but unscaled solution contains violations.

ctypedef enum OBJSENSE:
    OBJSENSE_MAXIMIZE  =  1
    OBJSENSE_MINIMIZE  =  -1

ctypedef enum REPRESENTATION:
    REPRESENTATION_AUTO   =  0
    REPRESENTATION_COLUMN =  1
    REPRESENTATION_ROW    =  2

ctypedef enum ALGORITHM:
    ALGORITHM_PRIMAL   =  0
    ALGORITHM_DUAL     =  1

ctypedef enum FACTOR_UPDATE_TYPE:
    FACTOR_UPDATE_TYPE_ETA   =  0
    FACTOR_UPDATE_TYPE_FT    =  1

ctypedef enum VERBOSITY:
    VERBOSITY_ERROR    =  0
    VERBOSITY_WARNING  =  1
    VERBOSITY_DEBUG    =  2
    VERBOSITY_NORMAL   =  3
    VERBOSITY_HIGH     =  4
    VERBOSITY_FULL     =  5

ctypedef enum SIMPLIFIER:
    SIMPLIFIER_OFF        =  0
    SIMPLIFIER_INTERNAL   =  3
    SIMPLIFIER_PAPILO     =  2
    SIMPLIFIER_AUTO       =  1

ctypedef enum SCALAR:
    SCALER_OFF         =  0
    SCALER_UNIEQUI     =  1
    SCALER_BIEQUI      =  2
    SCALER_GEO1        =  3
    SCALER_GEO8        =  4
    SCALER_LEASTSQ     =  5
    SCALER_GEOEQUI     =  6

ctypedef enum STARTER:
    STARTER_OFF     =  0
    STARTER_WEIGHT  =  1
    STARTER_SUM     =  2
    STARTER_VECTOR  =  3

ctypedef enum PRICER:
    PRICER_AUTO        =  0
    PRICER_DANTZIG     =  1
    PRICER_PARMULT     =  2
    PRICER_DEVEX       =  3
    PRICER_QUICKSTEEP  =  4
    PRICER_STEEP       =  5

ctypedef enum RATIOTESTER:
    RATIOTESTER_TEXTBOOK        =  0
    RATIOTESTER_HARRIS          =  1
    RATIOTESTER_FAST            =  2
    RATIOTESTER_BOUNDFLIPPING   =  3

ctypedef enum SYNCMODE:
    SYNCMODE_ONLYREAL  =  0
    SYNCMODE_AUTO      =  1
    SYNCMODE_MANUAL    =  2

ctypedef enum READMODE:
    READMODE_REAL      =  0
    READMODE_RATIONAL  =  1

ctypedef enum SOLVEMODE:
    SOLVEMODE_REAL     =  0
    SOLVEMODE_AUTO     =  1
    SOLVEMODE_RATIONAL =  2

ctypedef enum CHECKMODE:
    CHECKMODE_REAL     =  0
    CHECKMODE_AUTO     =  1
    CHECKMODE_RATIONAL =  2

ctypedef enum TIMER:
    TIMER_OFF       =  0
    TIMER_CPU       =  1
    TIMER_WALLCLOCK =  2

ctypedef enum HYPER_PRICING:
    HYPER_PRICING_OFF  =  0
    HYPER_PRICING_AUTO =  1
    HYPER_PRICING_ON   =  2

ctypedef enum SOLUTION_POLISHING:
    POLISHING_OFF            =  0
    POLISHING_INTEGRALITY    =  1
    POLISHING_FRACTIONALITY  =  2


cdef extern from "soplex_interface.h":
    # SoPlex Methods
    # creates new SoPlex struct
    void* SoPlex_create()

    # frees SoPlex struct
    void SoPlex_free(void* soplex)

    # reads LP file in LP or MPS format according to READMODE parameter; returns true on
    # success
    int SoPlex_readInstanceFile(void* soplex, const char* filename)

    # reads basis information from filename and returns true on success
    int SoPlex_readBasisFile(void* soplex, const char* filename)

    # reads settings from filename and returns true on success
    int SoPlex_readSettingsFile(void* soplex, const char* filename)

    # clears the (floating point) LP
    void SoPlex_clearLPReal(void* soplex)

    # returns number of rows
    int SoPlex_numRows(void* soplex)

    # returns number of columns
    int SoPlex_numCols(void* soplex)

    # sets integer parameter value
    void SoPlex_setIntParam(void* soplex, int paramcode, int paramvalue)

    # returns value of integer parameter
    int SoPlex_getIntParam(void* soplex, int paramcode)

    # adds a single (floating point) column
    void SoPlex_addColReal(
              void* soplex,
              double* colentries,
              int colsize,
              int nnonzeros,
              double objval,
              double lb,
              double ub
              )

    # adds a single (floating point) column
    void SoPlex_addRowReal(
              void* soplex,
              double* rowentries,
              int rowsize,
              int nnonzeros,
              double lb,
              double ub
              )

    # gets primal solution
    void SoPlex_getPrimalReal(void* soplex, double* primal, int dim)

    # gets dual solution
    void SoPlex_getDualReal(void* soplex, double* dual, int dim)

    # optimizes the given LP
    int SoPlex_optimize(void* soplex)

    # changes objective function vector to obj
    void SoPlex_changeObjReal(void* soplex, double* obj, int dim)

    # changes left-hand side vector for constraints to lhs
    void SoPlex_changeLhsReal(void* soplex, double* lhs, int dim)

    # changes right-hand side vector for constraints to rhs
    void SoPlex_changeRhsReal(void* soplex, double* rhs, int dim)

    # returns the objective value if a primal solution is available
    double SoPlex_objValueReal(void* soplex)

    # changes vectors of column bounds to lb and ub
    void SoPlex_changeBoundsReal(void* soplex, double* lb, double* ub, int dim)

    # changes bounds of a column to lb and ub
    void SoPlex_changeVarBoundsReal(void* soplex, int colidx, double lb, double ub)

    # changes upper bound of column to ub
    void SoPlex_changeVarUpperReal(void* soplex, int colidx, double ub)

    # changes upper bound vector of columns to ub
    void SoPlex_getUpperReal(void* soplex, double* ub, int dim)

cdef class Soplex:
    cdef void* _soplex
