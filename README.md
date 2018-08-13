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

ghc -i../Alignment -i../AlignmentRepa ../AlignmentRepa/AlignmentForeign.o MUSH_engine5.hs -o MUSH_engine5.exe -rtsopts -O2

./MUSH_engine5.exe +RTS -s >MUSH_engine5.log 2>&1 &

tail -f MUSH_engine5.log
```

To experiment with the dataset in the interpreter,
```
cd ../Alignment
rm *.o *.hi

cd ../AlignmentRepa
rm *.o *.hi

gcc -fPIC -c AlignmentForeign.c -o AlignmentForeign.o -O3

cd ../MUSH

ghci -i../Alignment -i../AlignmentRepa ../AlignmentRepa/AlignmentForeign.o
```

```hs
:set -fobject-code
:l MUSHDev
```

```
rm MUSHDev.o

ghci -i../Alignment -i../AlignmentRepa ../AlignmentRepa/AlignmentForeign.o
```

```hs
:set +m
:l MUSHDev

mush <- ByteStringChar8.readFile "../MUSH/agaricus-lepiota.data"

let aa = llaa $ map (\ll -> (llss ll,1)) $ map (\ss -> (map (\(u,(v,uu)) -> (VarStr v,ValStr (fromJust (lookup u uu)))) (zip ss names))) $ map (\l -> filter (/=',') l) $ lines $ ByteStringChar8.unpack $ mush

let uu = sys aa

let vv = uvars uu

let vvl = Set.singleton (VarStr "edible")

let vvk = vv `Set.difference` vvl

let hh = aahr uu aa

let (wmax,lmax,xmax,omax,bmax,mmax,umax,pmax,fmax,mult,seed) = ((9*9*10), 8, (9*9*10), 20, (20*3), 3, (9*9*10), 1, 1, 1, 1)

Just (uu1,df1) <- decomperIO uu vv hh wmax lmax xmax omax bmax mmax umax pmax fmax mult seed

ByteString.writeFile ("df1.json") $ decompFudsPersistentsEncode $ decompFudsPersistent df1

systemsDecompFudsHistoryRepasAlignmentContentShuffleSummation_u mult seed uu1 df1 hh
```

