##@file soplex.pxd
#@brief holding prototype of the SoPlex public functions to use them in PySoPlex

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

    # sets boolean parameter value
    void SoPlex_setBoolParam(void* soplex, int paramcode, int paramvalue)

    # sets integer parameter value
    void SoPlex_setIntParam(void* soplex, int paramcode, int paramvalue)

    # sets real parameter value
    void SoPlex_setRealParam(void* soplex, int paramcode, double paramvalue)

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
