# Build Troubleshooting Report

This document summarizes the missing packages and inaccessible resources encountered while attempting to build TOL in this environment.

## Missing Packages

During the build attempts the following packages or tools were not found and caused the build to fail:

- **tolcon** – the TOL interpreter required for running the test suite. Without it `tol-master/tol_tests/run_all_tests.sh` fails immediately.
- **Autotools utilities** – commands like `aclocal` were missing when running `./bootstrap` in `tol-master/tol`. Installing `autoconf`, `automake` and `libtool` resolves this.
- **CMake variable `TOL_RUNTIME_DIR`** – the CMake build requires this variable to point to an existing TOL installation. Without a pre‑built runtime the configuration fails.
- **LAPACK development libraries** – the build process checks for LAPACK and fails if the library is unavailable. Installing `liblapack-dev` satisfies this check.

## Inaccessible Resources

The default package repository `packages.tol-project.org` is currently unreachable. Attempts to download the standard packages return `503 Service Unavailable`. These packages provide the Standard Library and Tcl/Tk integration used by many examples and tests.

## Workarounds Implemented

- `scripts/setup_build_env.sh` installs the required build dependencies, including LAPACK.
- `scripts/fetch_default_packages.sh` attempts to download the missing packages from the official site and falls back to the Internet Archive if they cannot be reached.

Despite these workarounds, the absence of the `tolcon` binary and missing package downloads still prevent the full test suite from running.

