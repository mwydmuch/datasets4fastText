#!/usr/bin/env bash

DATASET_NAME="LSHTC1"
FILES_PREFIX="lshtc1"

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
bash ${SCRIPT_DIR}/get_pd_dataset.sh $DATASET_NAME $FILES_PREFIX
