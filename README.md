Note: pipeline not completely done yet, but code should be functional

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


## Usage


To download all the auxilary files (Ranklib, Trec_eval and the embeddings), please use the following command:

```bash
make
```

Then to run the code to compute the embedding based scores, please run

```python
python Code/entity_score.py embeddingfile outputfile outputfolder
```

So for example

```python
python Code/entity_score.py srs/WKN-vectors.bin output.txt Outputfolder
```

To do the coordinate ascent and ranking of these files, please run the following script with the Outputfolder from the previous line:

```bash
Code/rankscore.sh Outputfolder
```

This will result in the ranking and the trec_eval scores of the ranking. 


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
