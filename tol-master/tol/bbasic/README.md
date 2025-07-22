# TOL Basic Base Utilities (`tol-master/tol/bbasic/`)

## Overview

This directory contains a collection of fundamental C++ source files providing various utility functions, base data structure implementations, and core system interaction logic used throughout the TOL interpreter. It serves as a foundational layer for many other components.

## Code Functionality

The C++ code in this directory implements a diverse set of base functionalities:

*   **Core Object (`tol_bcore.h`, `cor.cpp`):** Defines the abstract base class `BCore`, likely the root for most TOL objects. It includes a static instance counter (`NCore`), pure virtual `Destroy()` and `IsListClass()` methods, and virtual methods (`IsAssigned`, `GetMemHandler`, `GetPageNum`, `GetSizeOf`) suggesting integration with a custom memory management system (like `bfsmem`). Provides `DESTROY` and `SAFE_DESTROY` macros for object lifetime management.
*   **Named Object (`tol_bobject.h`, `bobject.cpp`):** Defines `BObject` (inheriting `BAtom`, which likely provides reference counting) as a base for objects with a `BText name_`. Also defines `BObjectCRef` as a lightweight reference holder for searching.
*   **Real Number (`../bmath/mathobjects/tol_bdat.h`, `../bmath/mathobjects/dat.cpp`):** Defines the `BDat` class representing TOL's `Real` type. Wraps a `BReal` (float/double), using NaN for unknown values. Provides static constants (Pi, E, Inf, NaN), configurable formatting, comparison operators (handling NaN), overloaded math operators, and standard math functions (Log, Exp, Sin, etc.).
*   **Managed Text (`tol_btext.h`, `txt.cpp`, `txtalgeb.cpp`):** Defines the `BText` class, a core string type. Manages an internal character buffer (`buffer_`) with length and size tracking. Provides numerous constructors, overloaded operators (`+`, comparison, assignment, access `()`), extensive manipulation methods (padding, substring, find, replace, case conversion, compacting, wrapping, base64), static configuration (formats, language), I/O (`GetLine`, `BinRead/Write`), and integration with external utility functions (`ReadAllTokens`, `ReadAllCells`, `ReadFile`, etc.).
*   **Linked List (`tol_blist.h`, `lst.cpp`, `lstalgeb.cpp`, `lsttext.cpp`):** Defines the `BList` class (inheriting `BCore`), representing a LISP-style cons cell (`Car`/`Cdr`). Primarily manipulated via numerous external `Lst*` functions (e.g., `LstAppend`, `LstFind`, `LstLength`, `LstConcat`, `LstSort`, `LstDestroyAll`). Integrates with reference counting for `BAtom` elements. Provides `ForAll` iteration macros.
*   **Date/Time (`tol_bdate.h`, `dte.cpp`, `dtealgeb.cpp`):** Defines the `BDate` class for date/time representation (Year, Month, Day, Hour, Min, Sec) and the `BDateFormat` helper class for text conversion. `BDate` supports arithmetic (incrementing components, difference calculation based on continuous day indices), comparison operators, calendar functions (`WeekDay`, `EasterSunday`), and accessors. `BDateFormat` handles parsing/formatting based on format strings and locale.
*   **Dynamic Array (`tol_barray.h`):** Provides the `BArray<Any>` template class for dynamic arrays of arbitrary types. Manages memory (`Alloc/Realloc/DeleteBuffer`), provides element access (`[]`, `()`) with optional bounds checking, various `Add` methods (plain, sorted, unique), sorting (`Sort` via `qsort`), searching (`Find`, `FindSorted`), concatenation (`AutoConcat`, `operator |`), and serialization (`BinRead/Write`).
*   **Tree Structure (`tol_tree.h`, `tree.cpp`):** Defines the `Tree` class, a wrapper around `BList` to represent tree-like structures (likely syntax trees). Provides factory methods (`create`, `createMonary`, `createBinary`) and navigation helpers (`getNode`, `getBranch`, `getLeft/RightBranch`).
*   **Memory Management (`tol_bfsmem.h`, `bfsmem.cpp`):** Defines the `BFixedSizeMemoryBase` interface and helper macros (`DeclareClassNewDelete`, etc.) for integrating classes (like `BList`, potentially others derived from `BCore`) with a fixed-size memory pool allocator. This overrides `new` and `delete` for participating classes to use the pool manager, aiming to improve allocation performance.
*   **Hash Maps (`tol_hash_map.h`):** Provides an abstraction layer (via typedefs and helper templates) for using hash maps (Google dense/sparse or STL). Defines standard hashers and equality functors for common key types (int, C strings, double, pairs, `BUniKey`).
*   **System Interaction (`tol_bsys.h`, `sys.cpp`):** Provides the static `BSys` class offering wrappers for OS-level operations: environment variable access (`GetEnv`), process execution (`System`, `PExecQuiet`, platform-specific variants), file system operations (`MkDir`, `RmDir`, `Remove`, `Copy`, `TempNam`, `DirFiles`, `Unix2Dos`/`Dos2Unix`), interaction with external editors (`Edit`, `EditTable`, `EditChart`), printing (`Print`), session info (`SessionTime`, `SessionAvailMem`), and basic concurrency/timing (`SleepMilliSeconds`, `FOpenAndLock`).
*   **Directory Info (`tol_bdir.h`, `dir.cpp`):** Defines the `BDir` class to read and query directory contents (subdirs, files, sizes, times). Also includes many external path manipulation utilities (`GetFilePath`, `GetFileName`, `GetAbsolutePath`, `ReplaceSlash`, etc.).
*   **Query Files (`tol_bqfile.h`, `qfile.cpp`):** Defines `BQFile` (abstract base), `BQFixedFile`, and `BQSepFile` for reading structured text files (fixed-width or delimited). Defines `BQuery` (abstract base) and derived classes (`BCmpQuery`, `BNOT/AND/ORQuery`) for filtering records in these files.
*   **Output Management (`tol_bout.h`, `out.cpp`):** Defines the static `BOut` class to manage and route program output (errors, warnings, trace, info, standard) to different destinations (terminal, log file, external HCI callbacks) based on configurable flags.
*   **Option Parsing (`tol_bopt.h`, `opt.cpp`):** Defines `BArg` and `BOpt` classes for parsing and managing command-line arguments, including validation, default values, and help text generation.
*   **Templating (`tol_bseed.h`, `seed.cpp`):** Defines `BParam` and `BSeed` classes for basic text templating, replacing `<<$Name>>` placeholders in files or strings with parameter values.
*   **Profiling Timer (`tol_btimer.h`, `timer.cpp`):** Defines the `BTimer` class for measuring elapsed CPU time, including RAII support and macros (`InitTotalTime`, `SumPartialTime`) for accumulating times across function calls.
*   **Classification (`tol_classify.h`, `classify.cpp`):** Defines the `BClassifier` abstract base class for grouping elements based on user-defined relationships (equivalence, symmetric, etc.).
*   **Exception Handling (`tol_bexc.h`):** Defines a simple `BException` class (holding English/Spanish reason strings) for C++ exception handling.
*   **Utilities (`tol_butil.h`):** Contains various small inline utility functions (Min/Max, CharToBool, IsMultiple, Div/Mod) and comparison functors for sorting.
*   **Build System Integration:** `CMakeLists.txt`, `Jamfile`, and `Makefile.am` ensure these components are compiled and linked into the core TOL library.

## Purpose

`bbasic` provides essential low-level C++ building blocks required by higher-level parts of the TOL system, such as the parser, type implementations (`btol/`), and standard library functions (`stdlib/`). It encapsulates common operations related to memory, data structures, I/O, and system interfaces, promoting code reuse and modularity within the interpreter's C++ codebase.

## Appendix

- **Implementation Language:** C++.
- **Build:** Compiled as part of the main `tol` library/executable. 
