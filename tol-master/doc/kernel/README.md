# TOL Kernel Documentation (`tol-master/doc/kernel/`)

## Overview

This directory contains documentation focusing on the internal implementation details of the **TOL interpreter core (kernel)**. It provides insights into the design and functionality of key low-level components.

## Contents

Documentation is organized into subdirectories corresponding to specific kernel modules:

- **`MemoryHandlers/`:** Contains documentation related to the kernel's memory management strategies, custom allocators, or object lifetime handling.
- **`OIS/`:** Documentation for the **Object Input/Output Stream** system (implemented in `tol/OIS/`), which likely handles serialization/deserialization of TOL objects.
- **`Time/`:** Documentation concerning the representation and manipulation of time and date values within TOL, potentially related to the `libtai` library integration (`tol/tai/`).
- **`matrix/`:** Documentation specific to the internal implementation of TOL's matrix data types and associated linear algebra operations (likely related to code in `tol/bmath/` and `tol/btol/matrix_type/`).

(The specific file formats within these directories are not listed here but could include text files, diagrams, design documents, etc.)

## Purpose

This directory provides technical documentation primarily intended for developers working on the TOL interpreter kernel itself. It helps understand the internal architecture and implementation of fundamental components.

## Appendix

- **Target Audience:** TOL core developers.
- **Content:** Technical design documents, implementation notes. 
