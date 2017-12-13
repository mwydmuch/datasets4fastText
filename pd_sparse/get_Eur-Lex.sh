#!/usr/bin/env bash

DATASET_NAME="Eur-Lex"
FILES_PREFIX="eurlex"

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
bash ${SCRIPT_DIR}/get_pd_dataset.sh $DATASET_NAME $FILES_PREFIX
