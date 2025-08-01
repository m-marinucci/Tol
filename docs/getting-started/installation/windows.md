# Windows Installation Guide

This guide provides detailed instructions for installing TOL on Windows using various toolchains and methods.

## Table of Contents

- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
- [Visual Studio](#visual-studio)
- [MinGW-w64](#mingw-w64)
- [WSL2 (Recommended)](#wsl2)
- [Building from Source](#building-from-source)
- [Troubleshooting](#troubleshooting)
- [Environment Setup](#environment-setup)

## System Requirements

### Supported Versions

| Windows Version | Architecture | Status | Notes |
|-----------------|--------------|---------|-------|
| Windows 11 | x64 | ✅ Fully Supported | Recommended |
| Windows 10 (1909+) | x64 | ✅ Fully Supported | Version 1909 or later |
| Windows 10 (older) | x64 | ⚠️ Limited Support | May require updates |
| Windows Server 2019+ | x64 | ✅ Fully Supported | |
| Windows Server 2016 | x64 | ⚠️ Limited Support | |
| Windows 8.1 | x64 | ❌ Not Supported | |
| 32-bit Windows | x86 | ❌ Not Supported | |

### Hardware Requirements

- **Processor**: 64-bit x86 processor (Intel or AMD)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 3GB free space (including tools)
- **Graphics**: Not required for core TOL

## Installation Methods

### Quick Comparison

| Method | Pros | Cons | Best For |
|--------|------|------|----------|
| **WSL2** | Full Linux compatibility, Easy setup | Slight performance overhead | Most users |
| **Visual Studio** | Native Windows, Best debugging | Large installation | Windows developers |
| **MinGW-w64** | Lightweight, GCC compatible | Complex setup | Advanced users |
| **Docker** | Isolated environment | Requires Docker Desktop | Testing/CI |

## Visual Studio

### Prerequisites

1. **Download Visual Studio 2019/2022**
   - [Visual Studio Community](https://visualstudio.microsoft.com/downloads/)
   - Choose "Desktop development with C++" workload

2. **Install vcpkg** (Package Manager)
   ```powershell
   # Clone vcpkg
   git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
   cd C:\vcpkg
   
   # Bootstrap vcpkg
   .\bootstrap-vcpkg.bat
   
   # Integrate with Visual Studio
   .\vcpkg integrate install
   ```

3. **Install Dependencies**
   ```powershell
   # Install required libraries
   .\vcpkg install gsl:x64-windows
   .\vcpkg install fftw3:x64-windows
   .\vcpkg install lapack:x64-windows
   .\vcpkg install bzip2:x64-windows
   .\vcpkg install boost:x64-windows
   
   # Optional libraries
   .\vcpkg install suitesparse:x64-windows
   ```

### Building with Visual Studio

#### Using Visual Studio IDE

1. Clone TOL repository:
   ```powershell
   git clone https://github.com/m-marinucci/Tol.git
   cd Tol\tol-master\tol
   ```

2. Generate Visual Studio solution:
   ```powershell
   mkdir build
   cd build
   cmake .. -G "Visual Studio 16 2019" -A x64 `
            -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake
   ```

3. Open `TOL.sln` in Visual Studio
4. Select "Release" configuration
5. Build → Build Solution (Ctrl+Shift+B)

#### Using Command Line

```powershell
# Open Developer Command Prompt for VS 2019/2022
# From Start Menu → Visual Studio 2019/2022 → Developer Command Prompt

# Navigate to TOL directory
cd C:\path\to\Tol\tol-master\tol
mkdir build
cd build

# Configure
cmake .. -G "Visual Studio 16 2019" -A x64 ^
         -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake

# Build
cmake --build . --config Release --parallel

# Test
Release\tolcon.exe -c "WriteLn(\"TOL on Windows!\");"
```

### Visual Studio Code Integration

```json
// .vscode/settings.json
{
    "cmake.configureSettings": {
        "CMAKE_TOOLCHAIN_FILE": "C:/vcpkg/scripts/buildsystems/vcpkg.cmake"
    },
    "cmake.generator": "Visual Studio 16 2019",
    "cmake.platform": "x64",
    "cmake.buildDirectory": "${workspaceFolder}/build-vscode"
}
```

## MinGW-w64

### Installation

1. **Download MinGW-w64**
   - [MSYS2](https://www.msys2.org/) (Recommended)
   - Or [MinGW-w64 standalone](http://mingw-w64.org/doku.php/download)

2. **Using MSYS2**
   ```bash
   # Update package database
   pacman -Syu
   
   # Install MinGW-w64 toolchain
   pacman -S mingw-w64-x86_64-toolchain
   
   # Install dependencies
   pacman -S mingw-w64-x86_64-cmake \
             mingw-w64-x86_64-gsl \
             mingw-w64-x86_64-fftw \
             mingw-w64-x86_64-lapack \
             mingw-w64-x86_64-boost
   ```

### Building with MinGW-w64

```bash
# Open MSYS2 MinGW 64-bit terminal
# Navigate to TOL directory
cd /c/path/to/Tol/tol-master/tol

# Create build directory
mkdir build-mingw && cd build-mingw

# Configure
cmake .. -G "MinGW Makefiles" \
         -DCMAKE_BUILD_TYPE=Release

# Build
mingw32-make -j$(nproc)

# Test
./tolcon.exe -c 'WriteLn("TOL with MinGW!");'
```

### MinGW-specific Build Script

The TOL repository includes a MinGW build script:

```cmd
cd tol-master\building\MinGW
build.bat
```

## WSL2

Windows Subsystem for Linux 2 provides the best Linux compatibility on Windows.

### Prerequisites

1. **Enable WSL2**
   ```powershell
   # Run as Administrator
   wsl --install
   
   # Restart computer when prompted
   ```

2. **Install Ubuntu**
   ```powershell
   # Install Ubuntu 22.04
   wsl --install -d Ubuntu-22.04
   
   # Set as default
   wsl --set-default Ubuntu-22.04
   ```

3. **Update WSL2 kernel**
   ```powershell
   wsl --update
   ```

### Building in WSL2

```bash
# Inside WSL2 Ubuntu terminal
# Update packages
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y build-essential cmake git \
    libgsl-dev libfftw3-dev libblas-dev \
    liblapack-dev libbz2-dev libboost-all-dev

# Clone and build
git clone https://github.com/m-marinucci/Tol.git
cd Tol/tol-master/tol
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# Test
./tolcon -c 'WriteLn("TOL in WSL2!");'
```

### WSL2 Integration Tips

```powershell
# Access WSL files from Windows
\\wsl$\Ubuntu-22.04\home\username\Tol

# Run TOL from Windows
wsl ./tolcon script.tol

# Create Windows shortcut
wsl /home/username/Tol/build/tolcon
```

## Building from Source

### General Build Steps

1. **Clone Repository**
   ```cmd
   git clone https://github.com/m-marinucci/Tol.git
   cd Tol
   ```

2. **Install Dependencies**
   - Visual Studio: Use vcpkg
   - MinGW: Use MSYS2 pacman
   - WSL2: Use apt

3. **Configure Build**
   ```cmd
   cd tol-master\tol
   mkdir build
   cd build
   cmake .. [options]
   ```

4. **Build**
   ```cmd
   cmake --build . --config Release
   ```

### CMake Options for Windows

```powershell
# Specify generator
cmake .. -G "Visual Studio 16 2019"    # VS 2019
cmake .. -G "Visual Studio 17 2022"    # VS 2022
cmake .. -G "MinGW Makefiles"          # MinGW
cmake .. -G "Ninja"                    # Ninja

# Architecture
cmake .. -A x64                        # 64-bit
cmake .. -A Win32                      # 32-bit (unsupported)

# Build type (VS uses --config instead)
cmake .. -DCMAKE_BUILD_TYPE=Release    # MinGW/Ninja
cmake --build . --config Release       # Visual Studio

# Custom paths
cmake .. -DGSL_ROOT_DIR=C:\libs\gsl
cmake .. -DCMAKE_PREFIX_PATH=C:\libs
```

## Troubleshooting

### Common Issues

#### 1. Missing DLLs

**Error**: `The code execution cannot proceed because XXX.dll was not found`

**Solution**:
```powershell
# Add library paths to PATH
$env:Path += ";C:\vcpkg\installed\x64-windows\bin"
$env:Path += ";C:\path\to\tol\build\Release"

# Or copy DLLs to executable directory
copy C:\vcpkg\installed\x64-windows\bin\*.dll Release\
```

#### 2. CMake Cannot Find Libraries

**Error**: `Could NOT find GSL (missing: GSL_LIBRARY GSL_INCLUDE_DIR)`

**Solution**:
```powershell
# Specify vcpkg toolchain
cmake .. -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake

# Or manually specify paths
cmake .. -DGSL_ROOT_DIR=C:\vcpkg\installed\x64-windows
```

#### 3. Long Path Issues

**Error**: `The filename or extension is too long`

**Solution**:
```powershell
# Enable long paths in Windows (requires restart)
# Run as Administrator
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
                 -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

# Or use shorter build path
cd C:\
git clone https://github.com/m-marinucci/Tol.git T
cd T\tol-master\tol
```

#### 4. Antivirus Interference

**Problem**: Build is very slow or files disappear

**Solution**:
- Add build directory to antivirus exclusions
- Temporarily disable real-time scanning during build
- Use Windows Defender exclusions:
  ```powershell
  Add-MpPreference -ExclusionPath "C:\path\to\Tol"
  ```

#### 5. Permission Issues

**Error**: `Access is denied`

**Solution**:
```powershell
# Take ownership of directory
takeown /f "C:\path\to\Tol" /r /d y

# Grant full permissions
icacls "C:\path\to\Tol" /grant "%USERNAME%:F" /t
```

### Windows-Specific Build Issues

#### Visual Studio Version Conflicts

```powershell
# List available VS installations
"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -all

# Specify exact version
cmake .. -G "Visual Studio 16 2019" -T v142
```

#### Debug vs Release Confusion

```powershell
# Visual Studio defaults to Debug
# Always specify configuration:
cmake --build . --config Release

# Check which configuration was built
dir /s *.exe
```

## Environment Setup

### System Environment Variables

1. Open System Properties → Advanced → Environment Variables

2. Add to PATH:
   ```
   C:\path\to\tol\build\Release
   C:\vcpkg\installed\x64-windows\bin
   ```

3. Create TOL_HOME:
   ```
   TOL_HOME = C:\path\to\tol
   ```

### PowerShell Profile

Add to `$PROFILE`:

```powershell
# TOL environment
$env:TOL_HOME = "C:\path\to\tol"
$env:Path = "$env:TOL_HOME\build\Release;$env:Path"

# Alias for convenience
function tol { & "$env:TOL_HOME\build\Release\tolcon.exe" $args }
```

### Command Prompt Setup

Create `tol_env.bat`:

```batch
@echo off
set TOL_HOME=C:\path\to\tol
set PATH=%TOL_HOME%\build\Release;%PATH%
echo TOL environment loaded.
```

## Creating Windows Installer

### Using NSIS

```nsis
; tol-installer.nsi
!include "MUI2.nsh"

Name "TOL 3.0"
OutFile "tol-3.0-win64.exe"
InstallDir "$PROGRAMFILES64\TOL"

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

Section "TOL"
  SetOutPath "$INSTDIR"
  File /r "build\Release\*.*"
  File /r "packages\*.*"
  
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
  ; Add to PATH
  ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR"
SectionEnd
```

### Using MSI (WiX Toolset)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
  <Product Id="*" Name="TOL" Version="3.0.0" 
           Manufacturer="TOL Project" Language="1033">
    <Package InstallerVersion="200" Compressed="yes" />
    <Directory Id="TARGETDIR" Name="SourceDir">
      <Directory Id="ProgramFiles64Folder">
        <Directory Id="INSTALLFOLDER" Name="TOL" />
      </Directory>
    </Directory>
  </Product>
</Wix>
```

## Verification

After installation:

```powershell
# Check installation
where tolcon
tolcon --version

# Basic test
tolcon -c "WriteLn('TOL version: ' + Version());"

# Windows-specific test
tolcon -c "WriteLn('Running on: ' + OSName() + ' ' + OSVersion());"

# Performance test
tolcon -c "Matrix A = RandomMatrix(1000, 1000); Time start = Now(); MatrixInv(A); WriteLn('Time: ' + Text(Now() - start));"
```

## Integration with Windows Tools

### Visual Studio Code

Install the TOL extension (if available) or configure manually:

```json
// settings.json
{
    "files.associations": {
        "*.tol": "tol"
    },
    "terminal.integrated.defaultProfile.windows": "Command Prompt"
}
```

### Windows Terminal

Add TOL profile to `settings.json`:

```json
{
    "profiles": {
        "list": [
            {
                "guid": "{...}",
                "name": "TOL",
                "commandline": "cmd.exe /k C:\\path\\to\\tol_env.bat",
                "icon": "C:\\path\\to\\tol.ico"
            }
        ]
    }
}
```

## See Also

- [Main Installation Guide](README.md)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Visual Studio Documentation](https://docs.microsoft.com/en-us/visualstudio/)
- [vcpkg Documentation](https://vcpkg.io/)