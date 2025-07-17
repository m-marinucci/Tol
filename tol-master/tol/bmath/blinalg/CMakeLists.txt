
add_tol_sublibrary( blinalg
  divconq.cpp  matimp.cpp svdsep.cpp tol_lapack.cpp
  linalg.cpp mfastpro.cpp tol_blas.cpp )
  
if( APPLE )
  target_include_directories( blinalg PRIVATE 
    ${CLAPACK_INCLUDE_DIR} )
else()
  target_include_directories( blinalg PRIVATE 
    ${TOL_CBLAS_INCLUDE_DIR} ${CLAPACK_INCLUDE_DIR} )
endif()

create_header_links( blinalg )
