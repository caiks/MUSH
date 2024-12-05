# MUSH

This repository contains tests of the [AlignmentRepa repository](https://github.com/caiks/AlignmentRepa) using data from the [UCI Machine Learning Repository Mushroom Data Set](https://archive.ics.uci.edu/ml/datasets/mushroom). The AlignmentRepa repository is a fast Haskell implementation of some of the *practicable inducers* described in the paper *The Theory and Practice of Induction by Alignment* at https://greenlake.co.uk/. 

## Documentation

There is an analysis of this dataset [here](https://greenlake.co.uk/pages/dataset_MUSH), with sections (a) [predicting edibility without modelling](https://greenlake.co.uk/pages/dataset_MUSH#Predicting_edibility_without_modelling), (b) [predicting odor without modelling](https://greenlake.co.uk/pages/dataset_MUSH#Predicting_odor_without_modelling), (c) [manual modelling of edibility](https://greenlake.co.uk/pages/dataset_MUSH#Manual_modelling_of_edibility) and (d) [induced modelling of edibility](https://greenlake.co.uk/pages/dataset_MUSH#Induced_modelling_of_edibility). 

## Installation

The `MUSH` executables require the `AlignmentRepa` module which is in the [AlignmentRepa repository](https://github.com/caiks/AlignmentRepa). The `AlignmentRepa` module requires the [Haskell platform](https://www.haskell.org/downloads#platform) to be installed. The project is managed using [stack](https://docs.haskellstack.org/en/stable/).

Download the zip files or use git to get the MUSH repository and the underlying Alignment and AlignmentRepa repositories -
```
cd
git clone https://github.com/caiks/Alignment.git
git clone https://github.com/caiks/AlignmentRepa.git
git clone https://github.com/caiks/MUSH.git

```
Then build with the following -
```
cd ~/MUSH
stack build --ghc-options -w

```
## Usage

The *practicable model induction* is described [here](https://greenlake.co.uk/pages/dataset_MUSH_model16).

`MUSH_engine16` runs on a Ubuntu 16.04 Pentium CPU G2030 @ 3.00GHz using 1784 MB total memory and takes 1166 seconds,

```
cd ~/MUSH
stack exec MUSH_engine16.exe +RTS -s >MUSH_engine16.log 2>&1 &

tail -f MUSH_engine16.log

```

To experiment with the dataset in the interpreter use `stack ghci` or `stack repl` for a run-eval-print loop (REPL) environment, 
```
cd ~/MUSH
stack ghci --ghci-options -w

```
Press return when prompted to choose the main executable. Load `MUSHDev` to import the modules and define various useful abbreviated functions,
```hs
:l MUSHDev

(uu,aa) <- mushIO

let vv = uvars uu
let vvl = Set.singleton (VarStr "edible")
let vvk = vv `minus` vvl
let hh = aahr uu aa

let (wmax,lmax,xmax,omax,bmax,mmax,umax,pmax,fmax,mult,seed) = ((9*9*10), 8, (9*9*10), 10, (10*3), 3, (9*9*10), 1, 3, 3, 5)

Just (uu1,df1) <- decomperIO uu vvk hh wmax lmax xmax omax bmax mmax umax pmax fmax mult seed

ByteString.writeFile ("df1.json") $ decompFudsPersistentsEncode $ decompFudsPersistent df1

summation mult seed uu1 df1 hh
(54409.95661501111,24589.66463393197)
```
If you wish to use compiled code rather than interpreted you may specify the following before loading `MUSHDev` -
```
:set -fobject-code

```
Note that some modules may become [unresolved](https://downloads.haskell.org/~ghc/7.10.3-rc1/users_guide/ghci-obj.html), for example,
```hs
rp $ Set.fromList [1,2,3]

<interactive>:9:1: Not in scope: ‘Set.fromList’
```
In this case, re-import the modules explicitly as defined in `MUSHDev`, for example,
```hs
import qualified Data.Set as Set
import qualified Data.Map as Map
import Alignment
import AlignmentRepa
import AlignmentDevRepa hiding (aahr)

rp $ Set.fromList [1,2,3]
"{1,2,3}"

rp $ fudEmpty
"{}"
```
