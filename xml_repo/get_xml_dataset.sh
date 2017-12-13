#!/usr/bin/env bash

DATASET_NAME="$1"
FILES_PREFIX="$2"
DATASET_LINK="$3"

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

SED=sed
if [ $(uname -s) == Darwin ]; then
    SED=gsed
fi

function xml_dataset2ft {
    FILE="$1"

    # Extract metadata
    INFO=$(head -n 1 $FILE | grep -o "[0-9]\+")
    INFOARRAY=($INFO)
    echo ${INFOARRAY[0]} >> ${FILE}.examples
    echo ${INFOARRAY[1]} >> ${FILE}.features
    echo ${INFOARRAY[2]} >> ${FILE}.labels

    echo "${INFOARRAY[0]} EXAMPLES, ${INFOARRAY[1]} FEATURES, ${INFOARRAY[2]} LABELS"

    # Delete first line
    $SED -i "1d" $FILE

    bash ${SCRIPT_DIR}/../tools/libsvm2ft.sh $FILE
}


if [ ! -e ./$FILES_PREFIX ]; then
    echo "GETTING $FILES_PREFIX ($DATASET_NAME) ..."
    if [ ! -e "./$FILES_PREFIX.zip" ]; then
        echo "DOWNLOADING ${FILES_PREFIX}.zip ..."
        #wget $DATASET_LINK -P ./ -O "$FILES_PREFIX.zip"
        perl ${SCRIPT_DIR}/../tools/google_drive_download.pl $DATASET_LINK "$FILES_PREFIX.zip"
    fi

    echo "EXTRACTING $FILES_PREFIX ..."
    unzip -j -d "./$FILES_PREFIX" "./$FILES_PREFIX.zip"
fi

if [ -e "./$FILES_PREFIX/${FILES_PREFIX}_train.txt" ]; then
    # and "./$FILES_PREFIX/${FILES_PREFIX}_test.txt"

    echo "PROCESSING ${FILES_PREFIX} ..."

    mv  "./$FILES_PREFIX/${FILES_PREFIX}_train.txt"  "./$FILES_PREFIX/${FILES_PREFIX}_train"
    xml_dataset2ft "./$FILES_PREFIX/${FILES_PREFIX}_train"

    mv  "./$FILES_PREFIX/${FILES_PREFIX}_test.txt"  "./$FILES_PREFIX/${FILES_PREFIX}_test"
    xml_dataset2ft "./$FILES_PREFIX/${FILES_PREFIX}_test"

    # bash ${SCRIPT_DIR}/../tools/remap_dataset.sh "./$FILES_PREFIX/${FILES_PREFIX}_train" "./$FILES_PREFIX/${FILES_PREFIX}_test"
fi

if [ -e "./$FILES_PREFIX/${DATASET_NAME}_data.txt" ]; then

    echo "PROCESSING ${FILES_PREFIX} ..."

    mv "./$FILES_PREFIX/${DATASET_NAME}_data.txt" "./$FILES_PREFIX/${FILES_PREFIX}_data"
    mv "./$FILES_PREFIX/${FILES_PREFIX}_trSplit.txt" "./$FILES_PREFIX/${FILES_PREFIX}_trSplit"
    mv "./$FILES_PREFIX/${FILES_PREFIX}_tstSplit.txt" "./$FILES_PREFIX/${FILES_PREFIX}_tstSplit"
    xml_dataset2ft "./$FILES_PREFIX/${FILES_PREFIX}_data"

    # bash ${SCRIPT_DIR}/../tools/remap_dataset.sh "./$FILES_PREFIX/${FILES_PREFIX}_data"

    bash ${SCRIPT_DIR}/../tools/split_dataset.sh "./$FILES_PREFIX/${FILES_PREFIX}_data" "./$FILES_PREFIX/${FILES_PREFIX}_trSplit" "./$FILES_PREFIX/${FILES_PREFIX}_train"
    bash ${SCRIPT_DIR}/../tools/split_dataset.sh "./$FILES_PREFIX/${FILES_PREFIX}_data" "./$FILES_PREFIX/${FILES_PREFIX}_tstSplit" "./$FILES_PREFIX/${FILES_PREFIX}_test"

    # rm "./$FILES_PREFIX/${FILES_PREFIX}_trSplit"
    # rm "./$FILES_PREFIX/${FILES_PREFIX}_tstSplit"
    # rm "./$FILES_PREFIX/${FILES_PREFIX}_data"
fi

rm -f $FILES_PREFIX.zip
