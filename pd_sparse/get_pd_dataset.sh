#!/usr/bin/env bash

DATASET_NAME="$1"
FILES_PREFIX="$2"

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

SED=sed
if [ $(uname -s) == Darwin ]; then
    SED=gsed
fi

function pd_dataset2ft {
    FILE="$1"
    bash ${SCRIPT_DIR}/../tools/libsvm2ft.sh $FILE
}

if [ ! -e $FILES_PREFIX ]; then
    echo "GETTING $FILES_PREFIX ..."
    make --file=${SCRIPT_DIR}/Makefile get dataset=$DATASET_NAME
    mv $DATASET_NAME $FILES_PREFIX
fi

if [ -e "./$FILES_PREFIX/${FILES_PREFIX}.train" ]; then
    echo "PROCESSING ${DATASET_NAME} ..."

    mv "./$FILES_PREFIX/${FILES_PREFIX}.train"  "./$FILES_PREFIX/${FILES_PREFIX}_train"
    pd_dataset2ft "./$FILES_PREFIX/${FILES_PREFIX}_train"

    mv "./$FILES_PREFIX/${FILES_PREFIX}.test"  "./$FILES_PREFIX/${FILES_PREFIX}_test"
    pd_dataset2ft "./$FILES_PREFIX/${FILES_PREFIX}_test"

    mv "./$FILES_PREFIX/${FILES_PREFIX}.heldout"  "./$FILES_PREFIX/${FILES_PREFIX}_heldout"
    pd_dataset2ft "./$FILES_PREFIX/${FILES_PREFIX}_heldout"
fi
