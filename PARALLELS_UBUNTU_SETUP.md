# Parallels Ubuntu ARM64 Setup Guide for TOL Development

This guide provides step-by-step instructions for setting up an Ubuntu ARM64 virtual machine on Parallels Desktop for M-series Macs to build TOL for Linux.

## Prerequisites

- Parallels Desktop for Mac (version 18 or later recommended)
- M-series Mac (M1/M2/M3/M4) with at least 16GB RAM
- 60GB free disk space
- Active internet connection

## Step 1: Download Ubuntu ARM64

1. Download Ubuntu 22.04.4 LTS ARM64:
   - **Server (Recommended for development)**: [ubuntu-22.04.4-live-server-arm64.iso](https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.4-live-server-arm64.iso)
   - **Desktop (If you prefer GUI)**: [ubuntu-22.04.4-desktop-arm64.iso](https://cdimage.ubuntu.com/jammy/daily-live/current/jammy-desktop-arm64.iso)

2. Save the ISO file to your Downloads folder

## Step 2: Create Virtual Machine

1. **Open Parallels Desktop**

2. **Create New VM**:
   - Click the **+** button or **File → New**
   - Select **Install Windows or another OS from a DVD or image file**
   - Click **Continue**

3. **Select Installation Image**:
   - Click **Choose Manually**
   - Navigate to and select the Ubuntu ARM64 ISO
   - Click **Continue**

4. **Configure VM Settings**:
   - Name: `Ubuntu-TOL-Build`
   - Check **Customize settings before installation**
   - Click **Create**

5. **Optimize VM Configuration**:
   
   **Hardware Tab**:
   - **CPU & Memory**:
     - Processors: 4-6 cores
     - Memory: 6144-8192 MB (6-8 GB)
   
   - **Hard Disk**:
     - Size: 60 GB (expand if needed)
   
   - **Graphics**:
     - Memory: Automatic
     - Resolution: Best for Retina display
   
   - **Shared Folders**:
     - Click **+** to add
     - Folder: `/Users/numinate/PY_inference/Tol`
     - Name: `tol-source`
     - Permissions: Read & Write
     - Options: ✓ Share Mac folders with Linux
   
   **Options Tab**:
   - **Optimization**: Faster virtual machine
   - **Sharing**: Enable shared clipboard

6. **Start Installation**:
   - Click **Continue** to boot the VM
   - Follow Ubuntu installation wizard

## Step 3: Install Ubuntu

1. **Language**: English
2. **Keyboard**: Your preferred layout
3. **Installation Type**: Ubuntu Server (or Desktop)
4. **Network**: Use DHCP (automatic)
5. **Storage**: Use entire disk
6. **Profile Setup**:
   - Your name: `TOL Developer`
   - Server/Computer name: `tol-build-vm`
   - Username: `tol`
   - Password: (choose a secure password)
7. **SSH**: ✓ Install OpenSSH server
8. **Featured Server Snaps**: Skip (press Tab → Enter)

Wait for installation to complete and restart when prompted.

## Step 4: Initial System Configuration

After VM restarts and you log in:

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install Parallels Tools for better integration
# In Parallels menu: Actions → Install Parallels Tools
# Then in Ubuntu terminal:
sudo mkdir /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
sudo ./install

# Reboot for Parallels Tools to take effect
sudo reboot
```

## Step 5: Set Up Development Environment

After reboot:

```bash
# Install essential development tools
sudo apt install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    htop \
    cmake \
    pkg-config

# Create workspace
mkdir -p ~/workspace
cd ~/workspace

# Access shared folder (after Parallels Tools installation)
ln -s /media/psf/tol-source ~/tol-source

# Verify shared folder
ls -la ~/tol-source
```

## Step 6: Install TOL Dependencies

```bash
# Navigate to TOL source
cd ~/tol-source

# Make install script executable
chmod +x tol-master/scripts/install-deps-ubuntu.sh

# Run dependency installation
./tol-master/scripts/install-deps-ubuntu.sh

# Verify key dependencies
cmake --version
gcc --version
pkg-config --list-all | grep -E "gsl|blas|lapack|fftw"
```

## Step 7: Build TOL for Linux ARM64

```bash
# Create build directory
cd ~/tol-source
mkdir -p build-linux-arm64
cd build-linux-arm64

# Configure with CMake
cmake ../tol-master/tol \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-march=armv8-a+crc+crypto" \
    -DCMAKE_C_FLAGS="-march=armv8-a+crc+crypto" \
    -DENABLE_TESTING=ON \
    -DTOL_TESTS_ENABLE_PERFORMANCE=ON

# Build (using all available cores)
make -j$(nproc)

# Run tests
make test
```

## Step 8: Optimize Performance

### VM Performance Settings

1. **In Parallels Configuration**:
   - Hardware → CPU & Memory → Advanced → Enable "Adaptive Hypervisor"
   - Hardware → CPU & Memory → Advanced → Enable "Nested Virtualization"

2. **In Ubuntu**:
```bash
# Install CPU frequency utilities
sudo apt install -y cpufrequtils

# Set performance governor
echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils
sudo systemctl restart cpufrequtils

# Disable unnecessary services
sudo systemctl disable snapd
sudo systemctl disable cups-browsed
```

## Step 9: Development Workflow

### Option 1: SSH Access from Mac

```bash
# In Ubuntu, get IP address
ip addr show | grep "inet " | grep -v 127.0.0.1

# On Mac Terminal
ssh tol@<vm-ip-address>
```

### Option 2: VS Code Remote Development

1. On Mac:
   - Install VS Code
   - Install "Remote - SSH" extension
   - Add SSH config:
```bash
# ~/.ssh/config
Host ubuntu-tol
    HostName <vm-ip-address>
    User tol
    Port 22
```

2. In VS Code:
   - Command Palette → "Remote-SSH: Connect to Host"
   - Select `ubuntu-tol`

### Option 3: Direct Editing via Shared Folder

Edit files on Mac in `/Users/numinate/PY_inverence/Tol`, and they're instantly available in the VM at `/media/psf/tol-source`.

## Troubleshooting

### Shared Folders Not Visible
```bash
# Reinstall Parallels Tools
sudo mount /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
sudo ./install --reinstall
sudo reboot
```

### Build Errors
```bash
# Missing BLAS/LAPACK
sudo apt install --reinstall libblas-dev liblapack-dev libopenblas-dev
sudo ldconfig

# CMake version issues
# Download newer CMake for ARM64
wget https://github.com/Kitware/CMake/releases/download/v3.27.0/cmake-3.27.0-linux-aarch64.tar.gz
sudo tar -xzf cmake-3.27.0-linux-aarch64.tar.gz -C /opt
export PATH=/opt/cmake-3.27.0-linux-aarch64/bin:$PATH
```

### Performance Issues
- Increase VM RAM to 8GB
- Allocate more CPU cores
- Ensure Mac is plugged in (not on battery)
- Close unnecessary Mac applications

## Next Steps

1. Test the Linux ARM64 build of TOL
2. Create distribution packages (`.deb`, `.rpm`)
3. Set up automated builds with GitHub Actions
4. Cross-compile for x86_64 if needed

## Notes

- This VM runs ARM64 Linux natively (no emulation), providing excellent performance
- The shared folder feature allows seamless development between Mac and Linux
- All changes made in the shared folder are immediately visible in both systems
- Consider taking VM snapshots before major changes