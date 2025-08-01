# TOL Object Interchange Stream (OIS) (`tol-master/tol/OIS/`)

## Overview

This directory contains the C++ implementation of the **TOL Object Interchange Stream (OIS)** system. OIS appears to be a custom serialization format and associated library designed for saving and loading TOL data structures (like matrices, time series, sets) to and from persistent storage.

## Code Functionality

- **Serialization/Deserialization:**
    - `oiscreator.cpp`, `tol_oiscreator.h`: Code for writing TOL objects into the OIS format.
    - `oisloader.cpp`, `tol_oisloader.h`: Code for reading TOL objects from the OIS format.
- **Storage Backends:**
    - `oisstream.cpp`, `tol_oisstream.h`: Base classes for handling OIS data streams.
    - `oisstream_dir.cpp`, `tol_oisstream_dir.h`: Implementation for storing OIS data as a collection of files within a directory.
    - `oisstream_zip.cpp`, `tol_oisstream_zip.h`: Implementation for storing OIS data within a ZIP archive.
- **Features:**
    - `oiscompress.cpp`: Support for data compression within the OIS format.
    - `oisindex.cpp`: Likely implements indexing mechanisms for efficient access to objects within large OIS files or archives.
    - `oisxml.cpp`: May provide tools for converting OIS data to/from XML or representing metadata as XML.
- **TOL Integration (`oisapitol.cpp`):** This crucial file likely implements the functions exposed within the TOL language itself (e.g., `SaveObject`, `LoadObject`) that utilize the OIS library.
- **Build System Integration (`CMakeLists.txt`, `Jamfile`, `Makefile.am`):** Ensures the OIS library is compiled and linked as part of the main TOL build.

## Purpose

The OIS system provides TOL with a robust mechanism for object persistence. It allows users to save the state of complex TOL variables or entire workspaces to files and load them back later. The support for different storage backends (directory, zip) and features like compression and indexing makes it flexible and potentially efficient.

## Appendix

- **Implementation Language:** C++.
- **Technology:** Custom serialization format, possibly ZIP library integration.
- **Build:** Compiled as part of the main `tol` library/executable. 
