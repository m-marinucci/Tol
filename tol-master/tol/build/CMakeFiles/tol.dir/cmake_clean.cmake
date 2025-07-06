file(REMOVE_RECURSE
  "libtol.pdb"
  "libtol.so"
)

# Per-language clean rules from dependency scanning.
foreach(lang C CXX)
  include(CMakeFiles/tol.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
