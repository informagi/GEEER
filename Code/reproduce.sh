#!/bin/sh

mkdir -p ../Outputfolder
python ./entity_score_folds.py src/WKN_vectors/WKN-vectors.bin output.txt ../Outputfolder

bash train_ranklib.sh ../Outputfolder

bash score_ranklib.sh ../Outputfolder

