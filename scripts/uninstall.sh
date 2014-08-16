#!/bin/bash

# Check if root
SUDO=''
if [ $EUID -ne 0 ]; then
    SUDO='sudo'
fi

echo
echo "UNINSTALLING Writer..."
echo "======================"
echo

ERRORS=0

# Remove executable
echo 'Removing /usr/bin/writer'
$SUDO rm /usr/bin/writer
if [ $? -ne 0 ]; then
    ERRORS=$ERRORS + 1
fi

# Remove .desktop
echo 'Removing /usr/share/applications/writer.desktop'
$SUDO rm /usr/share/applications/writer.desktop
if [ $? -ne 0 ]; then
    ERRORS=$ERRORS + 1
fi



if [ $ERRORS -eq 0 ]; then
    echo
    echo 'Writer successfully uninstalled!'
    echo 'Please log out and back in again for the changes to take effect'
    exit 0
else
    echo
    echo 'Writer was NOT uninstalled successfully!'
    echo "$ERRORS errors occurred!"
    exit 1
fi
    
    
    
    
    
    
    