#!/bin/sh


FLDR=$1

mkdir -p $FLDR/RankLib

java -jar RankLib-2.1-patched.jar -train  $FLDR/Fold1/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold1/test.txt -save $FLDR/RankLib/model1
java -jar RankLib-2.1-patched.jar -train  $FLDR/Fold2/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold2/test.txt -save $FLDR/RankLib/model2
java -jar RankLib-2.1-patched.jar -train  $FLDR/Fold3/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold3/test.txt -save $FLDR/RankLib/model3
java -jar RankLib-2.1-patched.jar -train  $FLDR/Fold4/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold4/test.txt -save $FLDR/RankLib/model4
java -jar RankLib-2.1-patched.jar -train  $FLDR/Fold5/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold5/test.txt -save $FLDR/RankLib/model5