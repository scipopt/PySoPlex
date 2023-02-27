__version__ = '1.0.0'

# required for Python 3.8 on Windows
import os
if hasattr(os, 'add_dll_directory'):
    if os.getenv('SOPLEX_DIR'):
        os.add_dll_directory(os.path.join(os.getenv('SOPLEX_DIR').strip('"').split("/lib")[0], 'bin'))

# export user-relevant objects:
from pysoplex.soplex      import Soplex
from pysoplex.soplex      import PY_BOOLPARAM           as BOOLPARAM
from pysoplex.soplex      import PY_INTPARAM            as INTPARAM
from pysoplex.soplex      import PY_REALPARAM           as REALPARAM
from pysoplex.soplex      import PY_STATUS              as STATUS
from pysoplex.soplex      import PY_OBJSENSE            as OBJSENSE
from pysoplex.soplex      import PY_REPRESENTATION      as REPRESENTATION
from pysoplex.soplex      import PY_ALGORITHM           as ALGORITHM
from pysoplex.soplex      import PY_FACTORUPDATETYPE    as FACTORUPDATETYPE
from pysoplex.soplex      import PY_VERBOSITY           as VERBOSITY
from pysoplex.soplex      import PY_SIMPLIFIER          as SIMPLIFIER
from pysoplex.soplex      import PY_SCALAR              as SCALAR
from pysoplex.soplex      import PY_STARTER             as STARTER
from pysoplex.soplex      import PY_PRICER              as PRICER
from pysoplex.soplex      import PY_RATIOTESTER         as RATIOTESTER
from pysoplex.soplex      import PY_SYNCMODE            as SYNCMODE
from pysoplex.soplex      import PY_READMODE            as READMODE
from pysoplex.soplex      import PY_SOLVEMODE           as SOLVEMODE
from pysoplex.soplex      import PY_CHECKMODE           as CHECKMODE
from pysoplex.soplex      import PY_TIMER               as TIMER
from pysoplex.soplex      import PY_HYPERPRICING        as HYPERPRICING
from pysoplex.soplex      import PY_SOLUTIONPOLISHING   as SOLUTIONPOLISHING
