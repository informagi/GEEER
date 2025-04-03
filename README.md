# GEEER
This repository is structured in the following way:

- `Code/` : Contains the code for computing scores (entity_score.py), a notebook for the visualisation (Embedding_quality.ipynb), and two scripts for scoring (rankscore.sh and ranklib_to_trec.py). It is updated with two additional notebooks for ranking with the other graph embedding methods and ranking with different scenarios.
- `Data/` : Contains the linked entities used and the wikipedia redirects used, updated with more entity linking methods, and ground truth annotations 
- `Runs/` : Contains all the runs used in the paper, updated with additional runs for other methods

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
model = gensim.models.KeyedVectors.load("WKN-vectors.bin", mmap='r')
```

Other embeddings can be downloaded here: 

[RDF2Vec with pagelinks](https://surfdrive.surf.nl/files/index.php/s/KoQtCo9QW4lG4Mq/download)

[RDF2Vec without pagelinks](https://surfdrive.surf.nl/files/index.php/s/9YFKvrkBvXGrDIz/download)

[ComPlex with pagelinks](https://surfdrive.surf.nl/files/index.php/s/w0x9BKNXwTYN5rG/download) [KGE Graph files for ComPlex](https://surfdrive.surf.nl/files/index.php/s/vDGQbsws5iygLCo/download)

[ComPlex without pagelinks](https://surfdrive.surf.nl/files/index.php/s/RMyTvH0xdFxwvC6/download)  [KGE Graph files for ComPlex](https://surfdrive.surf.nl/files/index.php/s/9YFKvrkBvXGrDIz/download)

[Wikipedia2Vec 500D trained on 2015](https://surfdrive.surf.nl/files/index.php/s/iHZgEGP4tPXOeGE/download)

All these files need to be unzipped in the `/src` directory. 


# Quickstart

To download all the auxilary files (Ranklib, DBpedia Entity V2 and the embeddings), please use the following command:

```bash
bash build.sh
```

To then reproduce the results, first make sure to install all the neccessary packages with:

```bash
pip install -r requirements.txt
```

If you want to run the ranking with ComplEx, it is first neccessary to install KGE. They do not have a pip install, so please follow the installation guide on [their official Github](https://github.com/uma-pi1/kge) 

And then run

```bash
bash Code/reproduce.sh
```

The results will be stored in the folder /Output

## Code for computing the embedding based score with Wikipedia2vec

To compute just the embedding based score, use the following function:

```bash
python Code/entity_score.py embeddingfile outputfile [pathtodbpedia]
```

```bash
python Code/entity_score.py src/WKN-vectors/WKN-vectors.bin output.txt src/DBpedia-Entity/runs/v2/bm25f-ca_v2.run
```
## Code for computing the embedding based score with RDF2vec, Complex and old versions of Wikipedia2Vec

Open the Jupyter Notebook called `score_multiple-embeddings-types.ipynb` in the `Code` directory. 
In the first cell, please comment out the lines specifying the preferred version of embeddings and annotations, following the instructions written there.
Then simply run all cells to reproduce the experiment. 

## Code for computing the embedding based score with Scenario based annotations

Open the Jupyter Notebook called `score_multiple-embedding-types-with-scenarios.ipynb` in the `Code` directory. 
In the first cell, please comment out the lines specifying the preferred version of embeddings and annotations, following the instructions written there.
Then simply run all cells to reproduce the experiment. 


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
