
add_tol_sublibrary( bprdist multvar.cpp  prd.cpp slice_sampler.cpp )
if( APPLE )
  target_include_directories( bprdist PRIVATE 
    "${PROJECT_SOURCE_DIR}/contrib"
    "${PROJECT_SOURCE_DIR}/bmath/gsl_ext" 
    ${CLAPACK_INCLUDE_DIR} )
else()
  target_include_directories( bprdist PRIVATE 
    "${PROJECT_SOURCE_DIR}/contrib"
    "${PROJECT_SOURCE_DIR}/bmath/gsl_ext" 
    ${TOL_CBLAS_INCLUDE_DIR} ${CLAPACK_INCLUDE_DIR} )
endif()

create_header_links( bprdist )

  
