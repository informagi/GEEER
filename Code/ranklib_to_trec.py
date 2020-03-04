import pandas as pd

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("ranklib_input", type=str, help="Path to input of ranklib")
parser.add_argument("ranklib_output", type=str, help="Path to output of ranklib")
parser.add_argument("trec_output", type=str, help="Path to save")
args = parser.parse_args()

def printstring(query_id, tag, score, rank):
    returnstring = " ".join([query_id, "Q0", tag, str(rank), str(score), "EMBED"])
    return(returnstring)

print("Reading input")
ranklib_output = pd.read_csv(args.ranklib_output, sep='\t', names = ['query_id', 'number', 'score'])

ranklib_input = pd.read_csv(args.ranklib_input ,sep=' ', header=None)
ranklib_input = ranklib_input[[ranklib_input.columns[1],ranklib_input.columns[-1]]]
ranklib_input.columns = ['query_id', 'tag']
ranklib_input['query_id']=ranklib_input['query_id'].apply(lambda x: x[4:])

print("Joining input files")
ranklib_input['score'] = ranklib_output['score']

print("Sorting scores")
ranklib_input_sorted = ranklib_input.sort_values(['query_id','score'],ascending=[True, False])

ranklib_input_sorted['r'] = ranklib_input_sorted.groupby('query_id')['score'].rank(ascending=False)
ranklib_input_sorted['r'] = ranklib_input_sorted['r'].astype(int)

print("Writing away the results")
f = open(args.trec_output, 'w')
N = len(ranklib_input_sorted)
l = 50
m = (N/l)
idx = 0
for index,row in ranklib_input_sorted.iterrows():
    i = int(idx/m)
    percentage = (100 * idx) // N
    print('[' + '-'*i + ' '*(l-1-i)+ '] ' + str(percentage) +"%", flush = True, end ='\r')
    print(printstring(row['query_id'], row['tag'], row['score'], row['r']), file=f)
    idx += 1
f.close()
print("\n")
