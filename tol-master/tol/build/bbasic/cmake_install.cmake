# Install script for directory: /mnt/persist/workspace/tol-master/tol/bbasic

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
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_barray.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_batom.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bcore.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bdate.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bdir.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bexc.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bfsmem.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_blist.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bobject.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bopt.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bout.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bqfile.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bseed.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_bsys.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_btext.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_btimer.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_butil.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_classify.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_hash_map.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_list.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_memhandler.h"
    "/mnt/persist/workspace/tol-master/tol/bbasic/tol_tree.h"
    )
endif()

