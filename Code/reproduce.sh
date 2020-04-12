#!/bin/sh

python Code/entity_score_folds.py src/WKN-vectors/WKN-vectors.bin Outputfolder output.txt src/DBpedia-Entity/runs/v2/bm25f-ca_v2.run

bash Code/train_ranklib.sh Outputfolder

bash Code/score_ranklib.sh Outputfolder

