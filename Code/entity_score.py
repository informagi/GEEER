import gensim
import pandas as pd
from scipy import spatial
import numpy as np
import json
import os

import argparse
parser = argparse.ArgumentParser()

parser.add_argument("embedding", type=str, help="Path to embedding file")
parser.add_argument("score_output", type=str, help="Path to output of ranklib")
parser.add_argument("dbpedia_input", nargs = '?', default = "src/DBpedia-Entity/runs/v2/bm25f-ca_v2.run",  type=str, help="Path to dbpedia file to rerank")

args = parser.parse_args()

path_to_dbpedia = "src/DBpedia-Entity/"


def entity_converter(word, reverse = False, nospace = True):
    # Input: an entity string in dbpedia format
    # Output: string in wikipedia2vec format or readible format
    # Getting entities in the right format
    if reverse:
        word = word.replace("<dbpedia:", "")
        word = word.replace(">", "")
        if nospace:
            return word
        else:
            word = word.replace("_", " ")
            return word
    else:
        word = word.replace("<dbpedia:", "ENTITY/")
        word = word.replace(">", "")
        return word

def entity_lookup(tag, model, tagme = False):
    # Input: entity string
    # Output: True wikipedia2vec format
    # Looking up the embedding of entities, returning [] when entity not in corpus
    if tagme:
        tag = tag
    elif tag in redirect_dict:
        tag = redirect_dict[tag]
    else:
        tag = entity_converter(tag)
    if tag in model.vocab:
        return model[tag]
    else:
        return []

def ranking_feature(query, entity, dist = "cosine", conf = True):
    # Input: a query-entity pair to score, a distance function and if we want to use confidence scores
    # Output: query-entity based score

    # getting all the linked entities to the query
    a_ent = pd.DataFrame(confidence.loc[confidence['query_id'] == query])

    if len(a_ent)== 0:
        # if no linked queries, return 0
        return 0
    else:
        total = 0
        for index, row in a_ent.iterrows():
            #score = row['confidence']
            #score = row['score']
            ent1 = entity_lookup(entity, model)
            ent2 = entity_lookup(row['tag'], model, tagme = True)
            #ent2 = entity_lookup(row['entity'])
            if len(ent1) == 0 or len(ent2) == 0:
                continue
            else:
                if dist == 'fjaccard':
                    dist = 1-np.minimum(ent1,ent2).sum()/np.maximum(ent1,ent2).sum()
                else:
                    dist = 1 - spatial.distance.cosine(ent1, ent2)
                if conf:
                    score = row['confidence']
                    total += score*dist
                else:
                    total += dist
        return total


def to_print_format(queries, filepath):
    # input: A list of queries of which we want the results
    # output: Ranklib ready format of results
    f = open(filepath, "w")
    for q in queries:
        entities = new_df.loc[(new_df['query_id'] == q)]
        for index, row in entities.iterrows():
            printstring = str(int(row['rel'])) + ' qid:' + row['query_id'] + " 1:" + str(row['embedding_score']) + " 2:" + str(row['fsdm_score']) + " # " + row['tag']
            #printstring = str(int(row['rel'])) + ' qid:' + row['query_id'] + " 1:" + str(row['embedding_score']) + " 2:" + str(row['fsdm_score']) + " 3:" + str(row['query_score']) + " # " + row['tag']
            #printformat.append(printstring)
            print(printstring, file = f)
    f.close()

# Loading the file to rerank
# Note, if an error is given here when loading a different file to rerank, try changing the seperator to '\t'
#rerank_path = path_to_dbpedia + 'runs/v2/bm25f-ca_v2.run'
rerank_path = args.dbpedia_input
rerank =  pd.read_csv(rerank_path, sep='\s+', names = ['query_id', 'x1', 'tag', 'rang', 'fsdm_score', 'x2'])

# Loading linked entities
confidence = pd.read_csv("Data/linked_tagme.csv")

# Loading auxilary files
qrels_path = path_to_dbpedia + 'collection/v2/qrels-v2.txt'
qrels = pd.read_csv(qrels_path, sep='\t',names = ['query_id', '', 'tag', 'rel'])
queries_path = path_to_dbpedia + 'collection/v2/queries-v2.txt'
queries = pd.read_csv(queries_path, sep='\t',names = ['query_id', 'query'])

# Loading previously computed redirects
df = pd.read_csv('Data/wikipedia_redirect.csv')

# Loading the model with a Gensim keyedvector
model = gensim.models.KeyedVectors.load(args.embedding, mmap='r')

redirect_dict = {}
for index, tags in df.iterrows():
    redirect_dict[tags['original']] = tags['redirect']


# Merging the qrels and rerank for scoring
new_df = pd.merge(qrels[['query_id','tag','rel']], rerank[['query_id','tag','fsdm_score']],  how='right', left_on=['query_id','tag'], right_on = ['query_id','tag'])
new_df = new_df.fillna(value = 0)
new_df['rel'].isna().sum()

# Scoring everything (might take a while)
test_x = []

f = open(args.score_output, 'w')
N = len(new_df)
l = 50
m = (N/l)
print("Ranking entities:")
for index, row in new_df.iterrows():
    i = int(index/m)
    percentage = (100 * index) // N
    print('[' + '-'*i + ' '*(l-1-i)+ '] ' + str(percentage) +"%", flush = True, end ='\r')

    query_based_score = ranking_feature(row['query_id'],row['tag'], conf = True)
    test_x.append(query_based_score)
    print(" ".join([row['query_id'], row['tag'], str(query_based_score)] ), file=f)

new_df['embedding_score'] = test_x
print("\n")