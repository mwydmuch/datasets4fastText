#!/usr/bin/env bash

DATASET_NAME="Mediamill"
FILES_PREFIX="mediamill"
DATASET_LINK="https://drive.google.com/uc?export=download&id=0B3lPMIHmG6vGY3B4TXRmZnZBTkk"

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
bash ${SCRIPT_DIR}/get_xml_dataset.sh $DATASET_NAME $FILES_PREFIX $DATASET_LINK
