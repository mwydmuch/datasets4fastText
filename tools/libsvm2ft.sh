#!/usr/bin/env bash

FILE="$1"
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

echo "CONVERTING $FILE TO FT FORMAT ..."

if [ ! -e fast_libsvm2ft ]; then
    g++ ${SCRIPT_DIR}/fast_libsvm2ft.cpp -std=c++11 -O3 -o ${SCRIPT_DIR}/fast_libsvm2ft
fi

${SCRIPT_DIR}/fast_libsvm2ft $FILE
if [ -e ${FILE}.ft ]; then
    mv ${FILE}.ft ${FILE}
fi
