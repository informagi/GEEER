#!/bin/sh

echo 
python ./entity_score_folds.py srs/WKN-vectors.bin srs/bm25f-ca_v2.run output.txt Outputfolder

bash train_ranklib.sh Outputfolder

bash score_ranklib.sh Outputfolder

