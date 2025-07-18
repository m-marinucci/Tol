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