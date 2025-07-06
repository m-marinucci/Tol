#!/bin/bash
# TOL Dependencies Installation Script for Ubuntu/Debian
# Version: 1.0.0
# Date: 2025-07-06
# Issue: NUM-12 - Linux Build Documentation & User Guides

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    log_error "sudo is required but not installed. Please install sudo first."
    exit 1
fi

# Detect Ubuntu/Debian version
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    log_error "Cannot detect OS version. This script is for Ubuntu/Debian systems."
    exit 1
fi

log_info "Detected OS: $OS $VER"

# Check if this is Ubuntu or Debian
if [[ "$OS" != *"Ubuntu"* ]] && [[ "$OS" != *"Debian"* ]]; then
    log_error "This script is designed for Ubuntu or Debian systems only."
    exit 1
fi

# Function to check if package is installed
is_package_installed() {
    dpkg -l "$1" &> /dev/null
}

# Function to install packages
install_packages() {
    local packages=("$@")
    local to_install=()
    
    for package in "${packages[@]}"; do
        if ! is_package_installed "$package"; then
            to_install+=("$package")
        else
            log_info "$package is already installed"
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing packages: ${to_install[*]}"
        sudo apt-get install -y "${to_install[@]}"
    fi
}

# Main installation function
main() {
    log_info "Starting TOL dependencies installation for Ubuntu/Debian..."
    
    # Update package database
    log_info "Updating package database..."
    sudo apt-get update
    
    # Install core build dependencies
    log_info "Installing core build dependencies..."
    core_packages=(
        cmake
        build-essential
        gcc
        g++
        gfortran
        python3
        python3-pip
        git
        pkg-config
        autoconf
        automake
        libtool
        make
    )
    install_packages "${core_packages[@]}"
    
    # Install mathematical libraries
    log_info "Installing mathematical libraries..."
    math_packages=(
        libgsl-dev
        liblapack-dev
        libblas-dev
        libopenblas-dev
        libfftw3-dev
        libboost-all-dev
        libeigen3-dev
    )
    install_packages "${math_packages[@]}"
    
    # Install database support (optional)
    log_info "Installing database support libraries..."
    db_packages=(
        libmysqlclient-dev
        libpq-dev
        unixodbc-dev
        libsqlite3-dev
    )
    install_packages "${db_packages[@]}"
    
    # Install GUI support (optional)
    log_info "Installing GUI support libraries..."
    gui_packages=(
        tcl-dev
        tk-dev
        libx11-dev
        libxt-dev
        libxft-dev
    )
    install_packages "${gui_packages[@]}"
    
    # Install development tools
    log_info "Installing development tools..."
    dev_packages=(
        bc
        unzip
        wget
        curl
        valgrind
        gdb
        strace
    )
    install_packages "${dev_packages[@]}"
    
    # Install Python packages
    log_info "Installing Python packages..."
    if command -v pip3 &> /dev/null; then
        pip3 install --user numpy scipy matplotlib
    else
        log_warning "pip3 not found, skipping Python packages"
    fi
    
    # Verify installation
    log_info "Verifying installation..."
    
    # Check core tools
    tools=(cmake gcc g++ python3 git)
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            version=$($tool --version | head -1)
            log_success "$tool: $version"
        else
            log_error "$tool: NOT FOUND"
        fi
    done
    
    # Check libraries using pkg-config
    libraries=(gsl blas lapack fftw3)
    for lib in "${libraries[@]}"; do
        if pkg-config --exists "$lib" 2>/dev/null; then
            version=$(pkg-config --modversion "$lib")
            log_success "$lib: $version"
        else
            log_warning "$lib: NOT FOUND or no pkg-config info"
        fi
    done
    
    # Set up environment variables
    log_info "Setting up environment variables..."
    
    # Create environment setup script
    cat > ~/.tol_env << 'EOF'
# TOL Environment Variables
export OPENBLAS_NUM_THREADS=$(nproc)
export OMP_NUM_THREADS=$(nproc)
export BLAS_NUM_THREADS=$(nproc)

# TOL paths (uncomment after installation)
# export TOL_HOME=/usr/local/tol
# export PATH=$TOL_HOME/bin:$PATH
# export LD_LIBRARY_PATH=$TOL_HOME/lib:$LD_LIBRARY_PATH
EOF
    
    # Add to bashrc if not already present
    if ! grep -q "source ~/.tol_env" ~/.bashrc; then
        echo "source ~/.tol_env" >> ~/.bashrc
        log_info "Added TOL environment setup to ~/.bashrc"
    fi
    
    log_success "TOL dependencies installation completed successfully!"
    log_info "Next steps:"
    log_info "1. Source the environment: source ~/.bashrc"
    log_info "2. Clone TOL repository: git clone https://github.com/m-marinucci/Tol.git"
    log_info "3. Build TOL: cd Tol && mkdir build && cd build && cmake .. && make -j\$(nproc)"
    log_info "4. Run tests: make test"
    
    # Optional: Display system information
    log_info "System information:"
    log_info "OS: $OS $VER"
    log_info "Architecture: $(uname -m)"
    log_info "CPU cores: $(nproc)"
    log_info "Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    log_info "Disk space: $(df -h / | awk 'NR==2 {print $4}') available"
}

# Run main function
main "$@"
