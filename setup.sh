#!/bin/bash

sources=$(dirname $(readlink -f $0))

for file in $sources/.*; do
    if [ -f "$file" ]; then
        bname=$(basename $file)
        ln -i -s $file ~/$bname
        unset bname
    fi
done
unset file

mkdir -p ~/.bashrc.d/
for file in $sources/.bashrc.d/*; do
    if [ -f "$file" ]; then
        bname=$(basename $file)
        ln -i -s $file ~/.bashrc.d/$bname
        unset bname
    fi
done
unset file

unset sources
echo "All done???"
