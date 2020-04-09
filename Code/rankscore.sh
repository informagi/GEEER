#!/bin/sh


FLDR=$1


mkdir -p $FLDR/RankLib

java -jar src/Ranklib.jar -train  $FLDR/Fold1/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold1/test.txt -save $FLDR/RankLib/model1
java -jar src/Ranklib.jar -train  $FLDR/Fold2/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold2/test.txt -save $FLDR/RankLib/model2
java -jar src/Ranklib.jar -train  $FLDR/Fold3/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold3/test.txt -save $FLDR/RankLib/model3
java -jar src/Ranklib.jar -train  $FLDR/Fold4/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold4/test.txt -save $FLDR/RankLib/model4
java -jar src/Ranklib.jar -train  $FLDR/Fold5/train.txt -ranker 4 -r 3 -metric2t NDCG@100 -test  $FLDR/Fold5/test.txt -save $FLDR/RankLib/model5


java -jar src/Ranklib.jar -rank  $FLDR/Fold1/test.txt -load $FLDR/RankLib/model1 -score $FLDR/RankLib/scores1.out
java -jar src/Ranklib.jar -rank  $FLDR/Fold2/test.txt -load $FLDR/RankLib/model2 -score $FLDR/RankLib/scores2.out
java -jar src/Ranklib.jar -rank  $FLDR/Fold3/test.txt -load $FLDR/RankLib/model3 -score $FLDR/RankLib/scores3.out
java -jar src/Ranklib.jar -rank  $FLDR/Fold4/test.txt -load $FLDR/RankLib/model4 -score $FLDR/RankLib/scores4.out
java -jar src/Ranklib.jar -rank  $FLDR/Fold5/test.txt -load $FLDR/RankLib/model5 -score $FLDR/RankLib/scores5.out

cat $FLDR/RankLib/scores1.out $FLDR/RankLib/scores2.out $FLDR/RankLib/scores3.out $FLDR/RankLib/scores4.out $FLDR/RankLib/scores5.out > $FLDR/RankLib/scores.out

mkdir -p  $FLDR/Total

cat  $FLDR/Fold1/test.txt  $FLDR/Fold2/test.txt  $FLDR/Fold3/test.txt  $FLDR/Fold4/test.txt  $FLDR/Fold5/test.txt >  $FLDR/Total/Totalentities.txt

python ./ranklib_to_trec.py  $FLDR/Total/Totalentities.txt RankLib-2.1/$FLDR/RankLib/scores.out RankLib-2.1/$FLDR/RankLib/embed.run
