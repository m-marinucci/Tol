cmake_minimum_required( VERSION 2.8 )
project( ZipArchive )

# ZLIB configuration
find_package( ZLIB REQUIRED )
if( ZLIB_FOUND )
  message( "ZLIB_INCLUDE_DIRS = ${ZLIB_INCLUDE_DIRS}" )
  message( "ZLIB_LIBRARIES = ${ZLIB_LIBRARIES}" )
endif( )

find_package( BZip2 REQUIRED )

if( BZIP2_FOUND )
  message( "BZIP2_INCLUDE_DIR = ${BZIP2_INCLUDE_DIR}" )
  message( "BZIP2_LIBRARIES = ${BZIP2_LIBRARIES}" )
endif( )

if( UNIX )
  add_definitions( -D_ZIP_SYSTEM_LINUX )
endif( )

if( BUILD_SHARED_LIBS )
  add_definitions( -DZIP_BUILD_DLL -DZIP_HAS_DLL )
  set( LIB_TYPE SHARED )
else( BUILD_SHARED_LIBS )
  set( LIB_TYPE STATIC )
  set( CMAKE_POSITION_INDEPENDENT_CODE TRUE )
endif( BUILD_SHARED_LIBS )

set( ZipArchive_SRC
  ZipArchive/ZipArchive.cpp ZipArchive/ZipAutoBuffer.cpp ZipArchive/ZipCentralDir.cpp
  ZipArchive/ZipCompressor.cpp ZipArchive/BaseLibCompressor.cpp ZipArchive/Bzip2Compressor.cpp
  ZipArchive/DeflateCompressor.cpp ZipArchive/ZipCompatibility.cpp ZipArchive/ZipException.cpp
  ZipArchive/ZipFile_stl.cpp ZipArchive/ZipFileHeader.cpp ZipArchive/ZipMemFile.cpp
  ZipArchive/ZipPlatformComm.cpp ZipArchive/ZipStorage.cpp ZipArchive/ZipString.cpp
  ZipArchive/ZipExtraData.cpp ZipArchive/ZipExtraField.cpp ZipArchive/DirEnumerator.cpp
  ZipArchive/FileFilter.cpp ZipArchive/Wildcard.cpp ZipArchive/ZipCryptograph.cpp
  ZipArchive/ZipCrc32Cryptograph.cpp ZipArchive/Aes.cpp ZipArchive/Hmac.cpp
  ZipArchive/RandomPool.cpp ZipArchive/ZipAesCryptograph.cpp ZipArchive/Sha1.cpp
  ZipArchive/zlib/adler32.c ZipArchive/zlib/compress.c ZipArchive/zlib/crc32.c
  ZipArchive/zlib/uncompr.c ZipArchive/zlib/deflate.c ZipArchive/zlib/trees.c
  ZipArchive/zlib/zutil.c ZipArchive/zlib/inflate.c ZipArchive/zlib/infback.c
  ZipArchive/zlib/inftrees.c ZipArchive/zlib/inffast.c  )

if( WIN32 )
  set( ZipArchive_SRC  ${ZipArchive_SRC}
    ZipArchive/ZipPathComponent_win.cpp ZipArchive/ZipPlatform_win.cpp )
else( WIN32 )
  set( ZipArchive_SRC  ${ZipArchive_SRC}
    ZipArchive/ZipPathComponent_lnx.cpp ZipArchive/ZipPlatform_lnx.cpp )
endif( WIN32 )

include_directories( ZipArchive/zlib ${BZIP2_INCLUDE_DIR} )

add_library( ZipArchive ${LIB_TYPE} ${ZipArchive_SRC} )

target_link_libraries( ZipArchive ${BZIP2_LIBRARIES} )

install( TARGETS ZipArchive
  RUNTIME DESTINATION bin ARCHIVE DESTINATION lib LIBRARY DESTINATION bin )

file( GLOB ZipArchive_Headers RELATIVE  ${CMAKE_CURRENT_SOURCE_DIR}/ZipArchive *.h )
message("hola ${CMAKE_CURRENT_SOURCE_DIR}/ZipArchive" )
message( "ZipArchive_Headers = ${ZipArchive_Headers} " )

install( FILES  
    ZipArchive/Aes.h                  ZipArchive/ZipExport.h
    ZipArchive/BaseLibCompressor.h    ZipArchive/ZipExtraData.h
    ZipArchive/BitFlag.h              ZipArchive/ZipExtraField.h
    ZipArchive/BytesWriter.h          ZipArchive/ZipFile.h
    ZipArchive/Bzip2Compressor.h      ZipArchive/ZipFileHeader.h
    ZipArchive/DeflateCompressor.h    ZipArchive/ZipFileMapping.h
    ZipArchive/DirEnumerator.h        ZipArchive/ZipFileMapping_lnx.h
    ZipArchive/FileFilter.h           ZipArchive/ZipFileMapping_win.h
    ZipArchive/FileInfo.h             ZipArchive/ZipFile_mfc.h
    ZipArchive/Hmac.h                 ZipArchive/ZipFile_stl.h
    ZipArchive/RandomPool.h           ZipArchive/ZipFile_win.h
    ZipArchive/Sha1.h                 ZipArchive/ZipMemFile.h
    ZipArchive/Wildcard.h             ZipArchive/ZipMutex.h
    ZipArchive/ZipAbstractFile.h      ZipArchive/ZipMutex_lnx.h
    ZipArchive/ZipAesCryptograph.h    ZipArchive/ZipMutex_win.h
    ZipArchive/ZipArchive.h           ZipArchive/ZipPathComponent.h
    ZipArchive/ZipAutoBuffer.h        ZipArchive/ZipPlatform.h
    ZipArchive/ZipBaseException.h     ZipArchive/ZipSplitNamesHandler.h
    ZipArchive/ZipCallback.h          ZipArchive/ZipStorage.h
    ZipArchive/ZipCallbackProvider.h  ZipArchive/ZipString.h
    ZipArchive/ZipCentralDir.h        ZipArchive/ZipStringStoreSettings.h
    ZipArchive/ZipCollections.h       ZipArchive/ZipString_mfc.h
    ZipArchive/ZipCollections_mfc.h   ZipArchive/ZipString_stl.h
    ZipArchive/ZipCollections_stl.h   ZipArchive/_features.h
    ZipArchive/ZipCompatibility.h     ZipArchive/_platform.h
    ZipArchive/ZipCompressor.h        ZipArchive/resource.h
    ZipArchive/ZipCrc32Cryptograph.h  ZipArchive/std_mfc.h
    ZipArchive/ZipCryptograph.h       ZipArchive/std_stl.h
    ZipArchive/ZipException.h         ZipArchive/stdafx.h
  COMPONENT DEVEL DESTINATION include/ziparchive )
