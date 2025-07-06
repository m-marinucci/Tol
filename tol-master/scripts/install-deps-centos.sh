#!/bin/bash
# TOL Dependencies Installation Script for CentOS/RHEL/Fedora
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

# Detect OS version
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    log_error "Cannot detect OS version."
    exit 1
fi

log_info "Detected OS: $OS $VER"

# Determine package manager and OS type
if command -v dnf &> /dev/null; then
    PKG_MGR="dnf"
    OS_TYPE="fedora"
elif command -v yum &> /dev/null; then
    PKG_MGR="yum"
    if [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]]; then
        OS_TYPE="centos"
    else
        OS_TYPE="rhel"
    fi
else
    log_error "Neither yum nor dnf found. This script is for CentOS/RHEL/Fedora systems."
    exit 1
fi

log_info "Using package manager: $PKG_MGR"
log_info "OS type: $OS_TYPE"

# Function to check if package is installed
is_package_installed() {
    rpm -q "$1" &> /dev/null
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
        sudo $PKG_MGR install -y "${to_install[@]}"
    fi
}

# Function to enable repositories
enable_repositories() {
    if [[ "$OS_TYPE" == "centos" ]]; then
        # Enable EPEL for CentOS
        if [[ "$VER" == "7" ]]; then
            log_info "Enabling EPEL repository for CentOS 7..."
            sudo yum install -y epel-release
            
            # Enable Software Collections for newer GCC
            log_info "Enabling Software Collections for newer GCC..."
            sudo yum install -y centos-release-scl
        elif [[ "$VER" == "8" ]]; then
            log_info "Enabling EPEL and PowerTools for CentOS 8..."
            sudo dnf install -y epel-release
            sudo dnf config-manager --set-enabled powertools
        fi
    elif [[ "$OS_TYPE" == "fedora" ]]; then
        log_info "Fedora repositories should be enabled by default"
    fi
}

# Main installation function
main() {
    log_info "Starting TOL dependencies installation for $OS..."
    
    # Enable necessary repositories
    enable_repositories
    
    # Update package database
    log_info "Updating package database..."
    sudo $PKG_MGR update -y
    
    # Install core build dependencies
    log_info "Installing core build dependencies..."
    if [[ "$OS_TYPE" == "centos" && "$VER" == "7" ]]; then
        core_packages=(
            cmake3
            gcc
            gcc-c++
            gcc-gfortran
            python3
            python3-pip
            git
            pkg-config
            autoconf
            automake
            libtool
            make
            devtoolset-9-gcc
            devtoolset-9-gcc-c++
        )
    else
        core_packages=(
            cmake
            gcc
            gcc-c++
            gcc-gfortran
            python3
            python3-pip
            git
            pkg-config
            autoconf
            automake
            libtool
            make
        )
    fi
    install_packages "${core_packages[@]}"
    
    # Create cmake symlink for CentOS 7
    if [[ "$OS_TYPE" == "centos" && "$VER" == "7" ]]; then
        if [[ ! -f /usr/bin/cmake ]]; then
            log_info "Creating cmake symlink..."
            sudo ln -sf /usr/bin/cmake3 /usr/bin/cmake
        fi
    fi
    
    # Install mathematical libraries
    log_info "Installing mathematical libraries..."
    math_packages=(
        gsl-devel
        lapack-devel
        blas-devel
        fftw-devel
        boost-devel
    )
    
    # Add openblas if available
    if [[ "$OS_TYPE" == "fedora" ]] || [[ "$OS_TYPE" == "centos" && "$VER" != "7" ]]; then
        math_packages+=(openblas-devel)
    fi
    
    install_packages "${math_packages[@]}"
    
    # Install database support (optional)
    log_info "Installing database support libraries..."
    db_packages=(
        mysql-devel
        postgresql-devel
        unixODBC-devel
        sqlite-devel
    )
    install_packages "${db_packages[@]}"
    
    # Install GUI support (optional)
    log_info "Installing GUI support libraries..."
    gui_packages=(
        tcl-devel
        tk-devel
        libX11-devel
        libXt-devel
    )
    
    # Add libXft if available
    if [[ "$OS_TYPE" == "fedora" ]] || [[ "$OS_TYPE" == "centos" && "$VER" != "7" ]]; then
        gui_packages+=(libXft-devel)
    fi
    
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
    if [[ "$OS_TYPE" == "centos" && "$VER" == "7" ]]; then
        cat > ~/.tol_env << 'EOF'
# TOL Environment Variables
export OPENBLAS_NUM_THREADS=$(nproc)
export OMP_NUM_THREADS=$(nproc)
export BLAS_NUM_THREADS=$(nproc)

# Enable newer GCC for CentOS 7
source /opt/rh/devtoolset-9/enable

# TOL paths (uncomment after installation)
# export TOL_HOME=/usr/local/tol
# export PATH=$TOL_HOME/bin:$PATH
# export LD_LIBRARY_PATH=$TOL_HOME/lib:$LD_LIBRARY_PATH
EOF
    else
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
    fi
    
    # Add to bashrc if not already present (ignore commented or whitespace-prefixed lines)
    if ! grep -E '^\s*source\s+~/.tol_env\s*$' ~/.bashrc | grep -vq '^\s*#'; then
        echo "source ~/.tol_env" >> ~/.bashrc
        log_info "Added TOL environment setup to ~/.bashrc"
    fi
    
    log_success "TOL dependencies installation completed successfully!"
    log_info "Next steps:"
    log_info "1. Source the environment: source ~/.bashrc"
    
    if [[ "$OS_TYPE" == "centos" && "$VER" == "7" ]]; then
        log_info "2. Enable newer GCC: scl enable devtoolset-9 bash"
        log_info "3. Clone TOL repository: git clone https://github.com/m-marinucci/Tol.git"
        log_info "4. Build TOL: cd Tol && mkdir build && cd build && cmake .. && make -j\$(nproc)"
    else
        log_info "2. Clone TOL repository: git clone https://github.com/m-marinucci/Tol.git"
        log_info "3. Build TOL: cd Tol && mkdir build && cd build && cmake .. && make -j\$(nproc)"
    fi
    
    log_info "5. Run tests: make test"
    
    # Optional: Display system information
    log_info "System information:"
    log_info "OS: $OS $VER"
    log_info "Architecture: $(uname -m)"
    log_info "CPU cores: $(nproc)"
    if command -v free >/dev/null 2>&1; then
        log_info "Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    elif [ -f /proc/meminfo ]; then
        log_info "Memory: $(awk '/^MemTotal:/ {printf \"%.2f GiB\", $2/1024/1024}' /proc/meminfo)"
    else
        log_warning "Could not determine memory: neither 'free' nor /proc/meminfo available"
    fi
    log_info "Disk space: $(df -h / | awk 'NR==2 {print $4}') available"
}

# Run main function
main "$@"
