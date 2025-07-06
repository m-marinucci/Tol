# Install script for directory: /mnt/persist/workspace/tol-master/tol/btol

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/augment-agent/tol-install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDEVELOPMENTx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/tol" TYPE FILE FILES
    "/mnt/persist/workspace/tol-master/tol/btol/tol_bsparse.h"
    "/mnt/persist/workspace/tol-master/tol/btol/tol_delay_init.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/mnt/persist/workspace/tol-master/tol/build/btol/bdb/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/bgrammar/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/bgsl/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/bmodel/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/bmonte/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/code_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/complex_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/date_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/matrix_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/vmatrix_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/polynomial_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/ratio_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/real_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/serie_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/set_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/text_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/timeset_type/cmake_install.cmake")
  include("/mnt/persist/workspace/tol-master/tol/build/btol/polmat_type/cmake_install.cmake")

endif()

