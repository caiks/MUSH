{-# LANGUAGE OverloadedStrings, BangPatterns, ScopedTypeVariables #-}

import Control.Monad
import Control.Monad.ST
import Data.STRef
import Data.List
import qualified Data.Set as Set
import qualified Data.Map as Map
import qualified Data.Vector as V
import qualified Data.Vector.Unboxed as UV
import qualified Data.Vector.Unboxed.Mutable as MV
import qualified Data.Array.Repa as R
import qualified Data.Array.Repa.Shape as Shape
import qualified Data.ByteString.Lazy as ByteString
import qualified Data.ByteString.Char8 as ByteStringChar8
import qualified Codec.Compression.GZip as GZip
import Data.Array.Repa.Repr.ByteString
import Data.Array.Repa.IO.BMP
import Data.Word
import Data.Aeson hiding (Value)
import System.Random
import System.IO
import Data.Time
import System.Locale
import Text.Printf
import GHC.Real

import AlignmentUtil
import Alignment
import AlignmentSubstrate
import AlignmentDistribution
import AlignmentApprox
import AlignmentRandom
import AlignmentPracticable
import AlignmentPracticableIO
import AlignmentAeson
import AlignmentAesonPretty
import AlignmentRepaVShape
import AlignmentRepa
import AlignmentAesonRepa
import AlignmentRandomRepa
import AlignmentPracticableRepa
import AlignmentPracticableIORepa

main :: IO ()
main = 
  do
    printf ">>>\n"
    hFlush stdout

    (uu,hh) <- do
      mush <- ByteStringChar8.readFile "../MUSH/agaricus-lepiota.data"
      let aa = llaa $ map (\ll -> (llss ll,1)) $ map (\ss -> (map (\(u,(v,uu)) -> (VarStr v,ValStr (fromJust (lookup u uu)))) (zip ss names))) $ map (\l -> filter (/=',') l) $ lines $ ByteStringChar8.unpack $ mush
      let uu = sys aa
      return (uu, aahr uu aa)

    let vv = uvars uu
    let vvl = Set.singleton (VarStr "edible")
    let vvk = vv `Set.difference` vvl

    let model = "MUSH_model8" :: String
    let (wmax,lmax,xmax,omax,bmax,mmax,umax,pmax,fmax,mult,seed) = ((2^11), 1, (2^11), 40, (40*4), 4, (2^11), 3, 1, 6, 3)

    printf ">>> %s\n" $ model
    Just (uu',df) <- decomperIO uu vvk hh vvl wmax lmax xmax omax bmax mmax umax pmax fmax mult seed
    printf "<<< done %s\n" $ model
    hFlush stdout

    let (a,ad) = systemsDecompFudsHistoryRepasAlignmentContentShuffleSummation_u mult seed uu' df hh
    printf "alignment: %.2f\n" $ a
    printf "alignment density: %.2f\n" $ ad

    printf "<<< done\n"

  where 
    names = map (\(_,v,uu) -> (v, map (\s -> let (u,k) = break (=='=') s in (head (tail k),u)) uu)) [(0,"edible",["edible=e", "poisonous=p"]),(1,"cap-shape",["bell=b","conical=c","convex=x","flat=f","knobbed=k","sunken=s"]),(2,"cap-surface",["fibrous=f","grooves=g","scaly=y","smooth=s"]),(3,"cap-color",["brown=n","buff=b","cinnamon=c","gray=g","green=r","pink=p","purple=u","red=e","white=w","yellow=y"]),(4,"bruises",["bruises=t","no=f"]),(5,"odor",["almond=a","anise=l","creosote=c","fishy=y","foul=f","musty=m","none=n","pungent=p","spicy=s"]),(6,"gill-attachment",["attached=a","descending=d","free=f","notched=n"]),(7,"gill-spacing",["close=c","crowded=w","distant=d"]),(8,"gill-size",["broad=b","narrow=n"]),(9,"gill-color",["black=k","brown=n","buff=b","chocolate=h","gray=g", "green=r","orange=o","pink=p","purple=u","red=e","white=w","yellow=y"]),(10,"stalk-shape",["enlarging=e","tapering=t"]),(11,"stalk-root",["bulbous=b","club=c","cup=u","equal=e","rhizomorphs=z","rooted=r","missing=?"]),(12,"stalk-surface-above-ring",["fibrous=f","scaly=y","silky=k","smooth=s"]),(13,"stalk-surface-below-ring",["fibrous=f","scaly=y","silky=k","smooth=s"]),(14,"stalk-color-above-ring",["brown=n","buff=b","cinnamon=c","gray=g","orange=o","pink=p","red=e","white=w","yellow=y"]),(15,"stalk-color-below-ring",["brown=n","buff=b","cinnamon=c","gray=g","orange=o", "pink=p","red=e","white=w","yellow=y"]),(16,"veil-type",["partial=p","universal=u"]),(17,"veil-color",["brown=n","orange=o","white=w","yellow=y"]),(18,"ring-number",["none=n","one=o","two=t"]),(19,"ring-type",["cobwebby=c","evanescent=e","flaring=f","large=l","none=n","pendant=p","sheathing=s","zone=z"]),(20,"spore-print-color",["black=k","brown=n","buff=b","chocolate=h", "green=r","orange=o","purple=u","white=w","yellow=y"]),(21,"population",["abundant=a","clustered=c","numerous=n","scattered=s","several=v","solitary=y"]),(22,"habitat",["grasses=g","leaves=l","meadows=m","paths=p","urban=u","waste=w","woods=d"])]
    decomperIO uu vv hh ll wmax lmax xmax omax bmax mmax umax pmax fmax mult seed =
      parametersSystemsHistoryRepasDecomperMaxRollByMExcludedSelfHighestFmaxLabelMinEntropyIORepa 
        wmax lmax xmax omax bmax mmax umax pmax fmax mult seed uu vv hh ll 
    aahr uu aa = hhhr uu $ aahh aa 
    aahh aa = fromJust $ histogramsHistory aa
    hhhr uu hh = fromJust $ systemsHistoriesHistoryRepa uu hh
    araa uu rr = fromJust $ systemsHistogramRepasHistogram uu rr
    hrred hh vv = setVarsHistoryRepasReduce 1 vv hh
    red hh vv = setVarsHistoryRepasHistoryRepaReduced vv hh
    dfff = decompFudsFud
    fvars = fudsVars
    aamax aa = if size aa > 0 then (snd $ last $ sort [(c,ss) | (ss,c) <- aall aa]) else stateEmpty
    amax aa = if size aa > 0 then (last $ sort $ snd $ unzip $ aall aa) else 0
    aall = histogramsList
    llaa ll = fromJust $ listsHistogram ll
    size = histogramsSize
    llss = listsState
    uvars = systemsVars
    sys = histogramsSystemImplied 
    rpln ll = mapM_ (print . represent) ll

