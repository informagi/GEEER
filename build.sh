#!/bin/sh

mkdir -p src

read -p "Do you wish to download embedding files, DBpedia entity collection and Ranklib (~ 6 Gb)? [Y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Downloading Ranklib
wget -O src/Ranklib.jar https://sourceforge.net/projects/lemur/files/lemur/RankLib-2.11/RankLib-2.11.jar/download


# Downloading DBpedia Entity
git clone https://github.com/iai-group/DBpedia-Entity src/DBpedia-Entity


# Downloading the embedding files
wget -O src/WKN_no_lg_vectors.tar.bz2 https://surfdrive.surf.nl/files/index.php/s/OFipMGvn8zXAHqS/download
tar -xvjf src/WKN_no_lg_vectors.tar.bz2 -C /src

wget -O src/WKN_vectors.tar.bz2 https://surfdrive.surf.nl/files/index.php/s/V2mc4zrcE46Ucvs/download
tar -xvjf src/WKN_vectors.tar.bz2 -C /src

