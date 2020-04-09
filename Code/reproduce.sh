#!/bin/sh

python Code/entity_score_folds.py src/WKN-vectors/WKN-vectors.bin Outputfolder output.txt

bash Code/train_ranklib.sh Outputfolder

bash Code/score_ranklib.sh Outputfolder

