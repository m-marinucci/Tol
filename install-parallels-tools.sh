#!/bin/bash
# Install Parallels Tools on Ubuntu VM

echo "======================================"
echo "Parallels Tools Installation Guide"
echo "======================================"
echo ""
echo "Follow these steps:"
echo ""
echo "1. In Parallels Desktop menu bar:"
echo "   Actions → Install Parallels Tools"
echo ""
echo "2. A CD will be mounted in your Ubuntu VM"
echo ""
echo "3. Run this command in your Ubuntu VM:"
echo ""
echo "sudo apt update && sudo apt install -y gcc make"
echo ""
echo "# If CD doesn't auto-mount:"
echo "sudo mkdir -p /media/cdrom"
echo "sudo mount /dev/cdrom /media/cdrom"
echo ""
echo "# Install Parallels Tools:"
echo "cd /media/cdrom"
echo "sudo ./install"
echo ""
echo "# Follow the prompts and reboot when done"
echo "sudo reboot"
echo ""
echo "4. After reboot, verify installation:"
echo "   mount | grep prl_fs"
echo ""
echo "5. Your Mac's Tol folder will be available at:"
echo "   /media/psf/<folder-name>"

# Also create a check script for the VM
cat > check-parallels-tools.sh << 'EOF'
#!/bin/bash
# Run this on the Ubuntu VM to check Parallels Tools

echo "Checking Parallels Tools installation..."
echo ""

# Check if prl_fs is available
if mount | grep -q prl_fs; then
    echo "✓ Parallels Tools are installed"
    echo ""
    echo "Shared folders:"
    mount | grep prl_fs
    echo ""
    echo "Contents of /media/psf/:"
    ls -la /media/psf/ 2>/dev/null || echo "No shared folders found"
else
    echo "✗ Parallels Tools are NOT installed"
    echo ""
    echo "To install:"
    echo "1. In Parallels: Actions → Install Parallels Tools"
    echo "2. Run: sudo mount /dev/cdrom /media/cdrom"
    echo "3. Run: cd /media/cdrom && sudo ./install"
fi

# Check kernel modules
echo ""
echo "Parallels kernel modules:"
lsmod | grep prl || echo "No Parallels modules loaded"
EOF

echo ""
echo "Created check-parallels-tools.sh"
echo "Copy it to your VM and run it to verify installation"