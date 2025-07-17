
add_tol_sublibrary( bstat 
  ar.cpp  arma.cpp  linreg.cpp  logit.cpp  stat.cpp  test.cpp unitroot.cpp )
if( APPLE )
  target_include_directories( bstat PRIVATE 
    ${CLAPACK_INCLUDE_DIR} )
else()
  target_include_directories( bstat PRIVATE 
    ${TOL_CBLAS_INCLUDE_DIR} ${CLAPACK_INCLUDE_DIR} )
endif()

create_header_links( bstat )
  
