# MUSH

This repository contains tests of the [AlignmentRepa repository](https://github.com/caiks/AlignmentRepa) using data from the [UCI Machine Learning Repository Mushroom Data Set](https://archive.ics.uci.edu/ml/datasets/mushroom). The AlignmentRepa repository is a fast Haskell implementation of some of the *practicable inducers* described in the paper *The Theory and Practice of Induction by Alignment* at http://greenlake.co.uk/. 

## Installation

The `MUSH` exectuables require the `AlignmentRepa` module which is in the [AlignmentRepa repository](https://github.com/caiks/AlignmentRepa). See the AlignmentRepa repository for installation instructions of the Haskell compiler and libraries.

Then download the zip files or use git to get the MUSH repository and the underlying Alignment and AlignmentRepa repositories -
```
cd
git clone https://github.com/caiks/Alignment.git
git clone https://github.com/caiks/AlignmentRepa.git
git clone https://github.com/caiks/MUSH.git
```

## Usage

```
cd ../Alignment
rm *.o *.hi

cd ../AlignmentRepa
rm *.o *.hi

gcc -fPIC -c AlignmentForeign.c -o AlignmentForeign.o -O3

cd ../MUSH

ghc -i../Alignment -i../AlignmentRepa ../AlignmentRepa/AlignmentForeign.o MUSH_engine2.hs -o MUSH_engine2.exe -rtsopts -O2

./MUSH_engine2.exe +RTS -s >MUSH_engine2.log 2>&1 &

tail -f MUSH_engine2.log

ghc -i../Alignment -i../AlignmentRepa ../AlignmentRepa/AlignmentForeign.o MUSH_engine3.hs -o MUSH_engine3.exe -rtsopts -O2

./MUSH_engine3.exe +RTS -s >MUSH_engine3.log 2>&1 &

tail -f MUSH_engine3.log

ghc -i../Alignment -i../AlignmentRepa ../AlignmentRepa/AlignmentForeign.o MUSH_engine4.hs -o MUSH_engine4.exe -rtsopts -O2

./MUSH_engine4.exe +RTS -s >MUSH_engine4.log 2>&1 &

tail -f MUSH_engine4.log
```
Note that the tests require around 2.2GB memory.

