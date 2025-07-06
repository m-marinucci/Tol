# Install script for directory: /mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
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

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa-build/libZipArchive.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDEVELx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/ziparchive" TYPE FILE FILES
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/Aes.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipExport.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/BaseLibCompressor.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipExtraData.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/BitFlag.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipExtraField.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/BytesWriter.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFile.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/Bzip2Compressor.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFileHeader.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/DeflateCompressor.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFileMapping.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/DirEnumerator.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFileMapping_lnx.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/FileFilter.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFileMapping_win.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/FileInfo.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFile_mfc.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/Hmac.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFile_stl.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/RandomPool.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipFile_win.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/Sha1.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipMemFile.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/Wildcard.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipMutex.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipAbstractFile.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipMutex_lnx.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipAesCryptograph.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipMutex_win.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipArchive.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipPathComponent.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipAutoBuffer.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipPlatform.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipBaseException.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipSplitNamesHandler.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCallback.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipStorage.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCallbackProvider.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipString.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCentralDir.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipStringStoreSettings.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCollections.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipString_mfc.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCollections_mfc.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipString_stl.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCollections_stl.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/_features.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCompatibility.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/_platform.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCompressor.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/resource.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCrc32Cryptograph.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/std_mfc.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipCryptograph.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/std_stl.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/ZipException.h"
    "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa/ZipArchive/stdafx.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/mnt/persist/workspace/tol-master/tol/build/contrib/ZipArchive/prj_zipa-prefix/src/prj_zipa-build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
