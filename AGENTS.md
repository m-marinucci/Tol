# AGENT Instructions for Tol Repository

This repository is a direct import of the legacy TOL project (`tol-master`) with a few helper scripts in `scripts/` and documentation resources.

## General Guidelines
- Avoid modifying the contents of `tol-master` unless the task specifically requires it. That directory mirrors upstream sources.
- Use clear commit messages describing the change.
- Summarize changes and test results in PR descriptions.

## Testing
When code is modified, run the following checks and include their results in the PR:

1. **Python checks** (required when editing any Python files):
   ```bash
   python3 -m py_compile scripts/identify_pure_tol_files.py
   python3 scripts/identify_pure_tol_files.py > /dev/null
   ```
2. **TOL test suite** (best effort):
   ```bash
   tol-master/tol_tests/run_all_tests.sh
   ```
   This script needs the TOL toolchain (`tolcon`) which is typically missing in this environment. Run it anyway and report the outcome; if it fails due to missing dependencies, mention that in the PR.

These commands should be executed from the repository root.

## Code Safety Guidelines

When modifying C/C++ code in this repository:

1. **Always check memory allocation results**:
   ```cpp
   char *ptr = (char *) malloc(size);
   if (ptr == NULL) {
       // Handle allocation failure gracefully
       return;
   }
   ```

2. **Use defensive programming practices**:
   - Validate all pointer parameters before use
   - Check return values from system calls
   - Handle edge cases (empty strings, zero-length allocations, etc.)
   - Free allocated memory when no longer needed

3. **Follow secure coding standards**:
   - Never use unsafe string functions (strcpy, strcat) without bounds checking
   - Prefer `strncpy`, `strncat`, or safer alternatives when available
     - **Warning:** `strncpy` may not null-terminate the destination buffer if the source string is too long. Always ensure the destination is null-terminated after using `strncpy`, or consider using `snprintf` as a safer alternative for string copying and concatenation.
   - Initialize all variables before use
   - Avoid buffer overflows by validating sizes

4. **Error handling**:
   - Fail gracefully rather than crash
   - Log errors when appropriate logging mechanisms exist
   - Clean up resources on error paths

