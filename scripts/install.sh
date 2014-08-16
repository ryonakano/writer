#!/bin/bash

# Check if root
SUDO=''
if [ $EUID -ne 0 ]; then
    SUDO='sudo'
fi



# Compile Writer
./build.sh

# Install Writer (if compiling was successful)
if [ $? -eq 0 ]; then
    ERRORS=0
    
    echo
    echo "INSTALLING Writer..."
    echo "===================="
    echo

    # Copy executable to bin
    echo 'Copying executable to: /usr/bin/writer'
    $SUDO cp ../writer /usr/bin/
    if [ $? -ne 0 ]; then
        ERRORS=$ERRORS + 1
    fi
    
    # copy .desktop to /usr/share/applications
    echo 'Copying .desktop file to: /usr/share/applications/writer.desktop'
    $SUDO cp ../data/writer.desktop /usr/share/applications/
    if [ $? -ne 0 ]; then
        ERRORS=$ERRORS + 1
    fi
    
    if [ $ERRORS -eq 0 ]; then
        echo
        echo 'Writer was installed successfully!'
        echo 'Please log out and back in again to make sure Writer is recognised by the system'
        echo 'Thanks for trying out Writer!'
        exit 0
    else
        echo
        echo "$ERRORS errors occurred!"
        echo 'Writer was NOT installed successfully!'
        exit 1
    fi
    
else
    echo
    echo 'Compilation Failed!'
    echo 'Cannot install Writer!'
    exit 1
fi