# GEEER
Code supporting the paper Graph-Embedding Empowered Entity Retrieval

This repository contains resources developed within the following paper:

```
Graph-Embedding Empowered Entity Retrieval, Emma Gerritse, Faegheh Hasibi and Arjen de Vries
```

This repository is structured in the following way:

- `Code/` : Contains the code for computing scores (entity_score.py), a notebook for the visualisation (Embedding_quality.ipynb), and two scripts for scoring (rankscore.sh and ranklib_to_trec.py)
- `Data/` : Contains the linked entities used and the wikipedia redirects used
- `Runs/` : Contains all the runs used in the paper

## Requirements
Running the code requires Python 3.

## Embeddings

If one simply wants to download the embeddings, they can be accessed:

[Wikipedia2vec embeddings with graph component](https://surfdrive.surf.nl/files/index.php/s/V2mc4zrcE46Ucvs/download), result of the following command:

```bash
wikipedia2vec train --min-entity-count 0 --disambi enwiki-20190701-pages-articles-multistream.xml.bz2 wikipedia2vec_trained 
```


and [Wikipedia2vec embeddings without graph component](https://surfdrive.surf.nl/files/index.php/s/OFipMGvn8zXAHqS/download)
, result of the following command:
```bash
wikipedia2vec train --min-entity-count 0 --disambi --no-link-graph enwiki-20190701-pages-articles-multistream.xml.bz2 wikipedia2vec_trained 
```

The embeddings can then be loaded in Python with Gensim:


```Python
import gensim
model = gensim.models.KeyedVectors.load(WKN-vectors.bin, mmap='r')
```


# Quickstart

To download all the auxilary files (Ranklib, DBpedia Entity V2 and the embeddings), please use the following command:

```bash
bash build.sh
```

To then reproduce the results, first make sure to install all the neccessary packages with:

```bash
pip install -r requirements.txt
```

And then run

```bash
bash Code/reproduce.sh
```

The results will be stored in the folder /Output

## Code for computing the embedding based score

To compute just the embedding based score, use the following function:

```bash
python Code/entity_score.py embeddingfile outputfile [pathtodbpedia]
```

```bash
python Code/entity_score.py src/WKN-vectors/WKN-vectors.bin output.txt src/DBpedia-Entity/runs/v2/bm25f-ca_v2.run
```

## Code for scoring with Ranklib

If you want to run Ranklib with 5 folds afterwards, use the following function:

```bash
python Code/entity_score_folds.py embeddingfile outputfolder outputfile [pathtodbpedia]
```

So for example

```bash
python Code/entity_score_folds.py src/WKN-vectors/WKN-vectors.bin Outputfolder output.txt src/DBpedia-Entity/runs/v2/bm25f-ca_v2.run
```

To do the coordinate ascent and ranking of these files, please run the following script with the Outputfolder from the previous line:

```bash
bash Code/train_ranklib.sh Outputfolder

bash Code/score_ranklib.sh Outputfolder
```

The first script will train Ranklib, and the second script will score according to Ranklib and will result in the ranking and the trec_eval scores of the ranking. 


## Cite

```
@inproceedings{Gerritse:2020:GEEER, 
   author =    {Gerritse, Emma and Hasibi, Faegheh and De Vries, Arjen},
   title =     {Graph-Embedding Empowered Entity Retrieval},
   booktitle={European Conference on Information Retrieval},
   series =    {ECIR '20},
   year =      {2020},
   publisher = {Springer},
} 
```

## Contact

If you have any questions, please contact Emma Gerritse at emma.gerritse@ru.nl
