#!/bin/bash



# Compile Writer
./build.sh

# Run Writer (if compiling was successful)
if [ $? -eq 0 ]; then

    echo
    echo "RUNNING Writer..."
    echo "================="
    echo
    
    ../writer
else
    echo
    echo 'Compilation Failed!'
    echo 'Cannot run Writer!'
fi