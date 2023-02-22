from setuptools import setup, Extension
import os, platform, sys, re

#TODO: check for various options if they are relevant to SoPlex (e.g., TPI)

# look for environment variable that specifies path to SoPlex
soplexdir = os.environ.get("SOPLEX_DIR", "").strip('"').split("/lib")[0]

extra_compile_args = []
extra_link_args = []

# if SOPLEX_DIR is not set, we assume that SoPlex is installed globally
if not soplexdir:
    includedir = "."
    libdir = "."
    libname = "libsoplex" if platform.system() in ["Windows"] else "soplex"
    print("Assuming that SoPlex is installed globally, because SOPLEX_DIR is undefined.\n")

else:

    # check whether SoPlex is installed in the given directory
    if os.path.exists(os.path.join(soplexdir, "include")):
        includedir = os.path.abspath(os.path.join(soplexdir, "include"))
    else:
        print(f"SOPLEX_DIR={soplexdir} does not contain an include directory; searching for include files in src or ../src directory.")

        if os.path.exists(os.path.join(soplexdir, "src")):
            # SoPlex seems to be installed in-place; check whether it was built using make or cmake
            if os.path.exists(os.path.join(soplexdir, "src", "soplex")):
                # assume that SOPLEX_DIR pointed to the main source directory (make)
                includedir = os.path.abspath(os.path.join(soplexdir, "src"))
            else:
                # assume that SOPLEX_DIR pointed to a cmake build directory; try one level up (this is just a heuristic)
                if os.path.exists(os.path.join(soplexdir, "..", "src", "soplex")):
                    includedir = os.path.abspath(os.path.join(soplexdir, "..", "src"))
                else:
                    sys.exit(f"Could neither find src/soplex nor ../src/soplex directory in SOPLEX_DIR={soplexdir}. Consider installing SoPlex in a separate directory.")
        else:
            sys.exit(f"Could not find a src directory in SOPLEX_DIR={soplexdir}; maybe it points to a wrong directory.")

    # determine library
    if os.path.exists(os.path.join(soplexdir, "lib", "shared", "libsoplex.so")):
        # SoPlex seems to be created with make
        libdir = os.path.abspath(os.path.join(soplexdir, "lib", "shared"))
        libname = "soplex"
        extra_compile_args.append("-DNO_CONFIG_HEADER")
        # the following is a temporary hack to make it compile with SoPlex/make:
        extra_compile_args.append("-DTPI_NONE")  # if other TPIs are used, please modify
    else:
        # assume that SoPlex is installed on the system
        libdir = os.path.abspath(os.path.join(soplexdir, "lib"))
        libname = "libsoplex" if platform.system() in ["Windows"] else "soplexshared"

    print(f"Using include path {includedir}.")
    print(f"Using SoPlex library {libname} at {libdir}.\n")

# set runtime libraries
if platform.system() in ["Linux", "Darwin"]:
    extra_link_args.append(f"-Wl,-rpath,{libdir}")

# enable debug mode if requested
if "--debug" in sys.argv:
    extra_compile_args.append("-UNDEBUG")
    sys.argv.remove("--debug")

use_cython = True

packagedir = os.path.join("src", "pysoplex")

with open(os.path.join(packagedir, "__init__.py"), "r") as initfile:
    version = re.search(
        r'^__version__\s*=\s*[\'"]([^\'"]*)[\'"]', initfile.read(), re.MULTILINE
    ).group(1)

try:
    from Cython.Build import cythonize
except ImportError as err:
    # if cython is not found _and_ src/pysoplex/soplex.c does not exist then we cannot do anything.
    if not os.path.exists(os.path.join(packagedir, "soplex.c")):
        sys.exit("Cython is required.")
    use_cython = False

# if src/pysoplex/soplex.pyx does not exist then there is no need for using cython
if not os.path.exists(os.path.join(packagedir, "soplex.pyx")):
    use_cython = False

ext = ".pyx" if use_cython else ".c"

extensions = [
    Extension(
        "pysoplex.soplex",
        sources=[os.path.join(packagedir, f"soplex{ext}")],
        language='c++',
        include_dirs=[includedir],
        library_dirs=[libdir],
        libraries=[libname],
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
    )
]

if use_cython:
    extensions = cythonize(extensions, compiler_directives={"language_level": 3})

with open("README.md") as f:
    long_description = f.read()

setup(
    name="PySoPlex",
    version=version,
    description="Python interface and modeling environment for SoPlex",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/scipopt/PySoPlex",
    author="Zuse Institute Berlin",
    author_email="scip@zib.de",
    license="MIT",
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Science/Research",
        "Intended Audience :: Education",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Cython",
        "Topic :: Scientific/Engineering :: Mathematics",
    ],
    ext_modules=extensions,
    install_requires=["wheel"],
    packages=["pysoplex"],
    package_dir={"pysoplex": packagedir},
    package_data={"pysoplex": ["soplex.pyx", "soplex.pxd"]},
)
