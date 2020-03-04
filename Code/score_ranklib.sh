#!/bin/sh


FLDR=$1

java -jar RankLib-2.1-patched.jar -rank  $FLDR/Fold1/test.txt -load $FLDR/RankLib/model1 -score $FLDR/RankLib/scores1.out
java -jar RankLib-2.1-patched.jar -rank  $FLDR/Fold2/test.txt -load $FLDR/RankLib/model2 -score $FLDR/RankLib/scores2.out
java -jar RankLib-2.1-patched.jar -rank  $FLDR/Fold3/test.txt -load $FLDR/RankLib/model3 -score $FLDR/RankLib/scores3.out
java -jar RankLib-2.1-patched.jar -rank  $FLDR/Fold4/test.txt -load $FLDR/RankLib/model4 -score $FLDR/RankLib/scores4.out
java -jar RankLib-2.1-patched.jar -rank  $FLDR/Fold5/test.txt -load $FLDR/RankLib/model5 -score $FLDR/RankLib/scores5.out

cat $FLDR/RankLib/scores1.out $FLDR/RankLib/scores2.out $FLDR/RankLib/scores3.out $FLDR/RankLib/scores4.out $FLDR/RankLib/scores5.out > $FLDR/RankLib/scores.out

mkdir -p  $FLDR/Total

cat  $FLDR/Fold1/test.txt  $FLDR/Fold2/test.txt  $FLDR/Fold3/test.txt  $FLDR/Fold4/test.txt  $FLDR/Fold5/test.txt >  $FLDR/Total/Totalentities.txt

python ./ranklib_to_trec.py  $FLDR/Total/Totalentities.txt $FLDR/RankLib/scores.out $FLDR/trec_input/embed.run
