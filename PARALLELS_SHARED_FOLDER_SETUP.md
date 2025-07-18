# Parallels Shared Folder Setup for TOL Development

This guide helps you set up shared folders between macOS and Ubuntu VM for seamless TOL development.

## Step 1: Enable Shared Folders in Parallels

1. **Stop your Ubuntu VM** (if running)

2. **Open Parallels Configuration**:
   - Select your Ubuntu VM
   - Click Configuration (⚙️ icon)
   - Go to "Options" tab → "Sharing"

3. **Add Shared Folder**:
   - Click the "+" button
   - Select `/Users/numinate/PY_inverence/Tol`
   - Name: `tol-source` (or keep default)
   - Options:
     - ✅ Read & Write
     - ✅ Mount automatically
     - ❌ Read-only (unchecked)

4. **Start the VM**

## Step 2: Install Parallels Tools (if not already installed)

In the Ubuntu VM:

```bash
# If Parallels Tools CD appears, mount it
# Or from Parallels menu: Actions → Install Parallels Tools

# Install required packages
sudo apt update
sudo apt install -y gcc make

# Mount Parallels Tools CD (if not auto-mounted)
sudo mount /dev/cdrom /media/cdrom

# Install Parallels Tools
cd /media/cdrom
sudo ./install

# Reboot
sudo reboot
```

## Step 3: Access Shared Folder in Ubuntu

After reboot, the shared folder should be available at:

```bash
# Default Parallels shared folder location
/media/psf/tol-source

# Or sometimes at
/mnt/psf/tol-source

# Verify it's mounted
ls -la /media/psf/
```

## Step 4: Create Convenient Symlink

```bash
# Create a symlink in home directory
ln -s /media/psf/tol-source ~/tol-shared

# Verify
ls -la ~/tol-shared/
```

## Step 5: Configure Build Environment

Create a build script that uses the shared folder:

```bash
cat > ~/build-tol-shared.sh << 'EOF'
#!/bin/bash
# Build TOL in shared directory

cd ~/tol-shared/build-linux-arm64

# Clean if requested
if [ "$1" = "clean" ]; then
    rm -rf *
fi

# Configure
cmake ../tol-master/tol \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DCMAKE_C_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DBLA_VENDOR=OpenBLAS \
    -DENABLE_TESTING=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

# Build
make -j$(nproc)

# Test
if [ -f tolcon ]; then
    echo "Build successful!"
    ./tolcon -c 'WriteLn("Shared folder build works!")'
fi
EOF

chmod +x ~/build-tol-shared.sh
```

## Step 6: Build in Shared Directory

```bash
# Navigate to shared build directory
cd ~/tol-shared/build-linux-arm64

# Run build
~/build-tol-shared.sh
```

## Benefits of This Setup

1. **No Syncing**: Changes appear immediately on both Mac and Linux
2. **Single Source**: Edit on Mac, build on Linux, debug on either
3. **IDE Integration**: Use your Mac IDE while building on Linux
4. **Version Control**: Git operations from Mac work normally

## Troubleshooting

### Shared Folder Not Visible

1. Check Parallels Tools are installed:
   ```bash
   mount | grep prl_fs
   ```

2. Manually mount if needed:
   ```bash
   sudo mount -t prl_fs tol-source /media/psf/tol-source
   ```

### Permission Issues

If you get permission errors:

```bash
# Check permissions
ls -la /media/psf/tol-source

# You may need to build with your Mac user's permissions
# Parallels usually handles this automatically
```

### Performance

Shared folders can be slower than native filesystem. For best performance:
- Use native filesystem for intermediate build files
- Only share source and final binaries

## Alternative: Selective Sharing

For better performance, share only source, not build:

```bash
# Build in VM's local filesystem
mkdir ~/tol-build-local
cd ~/tol-build-local

# Configure pointing to shared source
cmake /media/psf/tol-source/tol-master/tol [options]

# Build locally
make -j$(nproc)

# Copy only final binaries to shared
cp tolcon /media/psf/tol-source/build-linux-arm64/
```