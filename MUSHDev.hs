module MUSHDev
where

import Data.List
import qualified Data.ByteString.Lazy as ByteString
import qualified Data.ByteString.Char8 as ByteStringChar8
import qualified Data.Set as Set
import qualified Data.Map as Map
import qualified Data.Vector as V
import qualified Data.Vector.Unboxed as UV
import qualified Data.Vector.Unboxed.Mutable as MV
import qualified Data.Array.Repa.Shape as RS
import qualified Data.Array.Repa as R
import qualified Data.Array.Repa.Repr.ByteString as RB
import qualified Data.Array.Repa.IO.BMP as RIOBMP
import GHC.Real
import System.Random
import qualified Codec.Compression.GZip as GZip
import Data.Word
import AlignmentUtil
import Alignment
import AlignmentSubstrate
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


import AlignmentUtil
import Alignment

pv x = represent x
sunion = pairStatesUnionLeft

ssll = statesList
llss = listsState

cart uu vv = fromJust $ systemsVarsCartesian uu vv
sysreg d n = fromJust $ systemRegular d n
syscart d n = fromJust $ let uu = sysreg d n in systemsVarsCartesian uu (systemsVars uu)
uunion = pairSystemsUnion
uvars = systemsVars
vol uu vv = fromJust $ systemsVarsVolume uu vv
uull = systemsList
umap uu ll = Map.fromList [(v,(v',Map.fromList (zip (Set.toList ww) (map ValInt [1..])))) | ((v,ww),v') <- zip (uull uu) ll]

ph x = represent x
aall = histogramsList
llaa ll = fromJust $ listsHistogram ll
aarr aa = map (\(ss,c) -> (ss,fromRational c)) (histogramsList aa) :: [(State,Double)]
unit qq = fromJust $ setStatesHistogramUnit qq
equiv = pairHistogramsEquivalent
add xx yy = fromJust $ pairHistogramsAdd xx yy
sub xx yy = fromJust $ pairHistogramsSubtract xx yy
mul = pairHistogramsMultiply
divide = pairHistogramsDivide
apply = setVarsSetVarsSetHistogramsHistogramsApply
leq = pairHistogramsLeq
size = histogramsSize
resize z aa = fromJust $ histogramsResize z aa
vars = histogramsVars
cdvars ll = Set.fromList $ map VarInt ll
states = histogramsStates
dim = histogramsDimension
card = histogramsCardinality
recip = histogramsReciprocal
red aa vv = setVarsHistogramsReduce vv aa
cdred aa ll = red aa $ Set.fromList $ map VarInt ll
scalar q = fromJust $ histogramScalar q
single ss c = fromJust $ histogramSingleton ss c
trim = histogramsTrim
ceil = histogramsCeiling
eff = histogramsEffective
ind = histogramsIndependent
empty = histogramEmpty
sys = histogramsSystemImplied 
regsing d n = fromJust $ histogramRegularUnitSingleton d n
regcart d n = fromJust $ histogramRegularCartesian d n
regdiag d n = fromJust $ histogramRegularUnitDiagonal d n
regcrown d n = fromJust $ histogramRegularUnitCrown d n
regplanar d n = fromJust $ histogramRegularUnitPlanar d n
regline d n = fromJust $ histogramRegularUnitLine d n
regaxial d n = fromJust $ histogramRegularUnitAxial d n
regpivot d n = fromJust $ histogramRegularUnitPivot d n
regantipivot d n = trim $ regcart d n `sub` regpivot d n
cdaa ll = llaa [(llss (map (\(i,j) -> (VarInt i, ValInt j)) (zip [1..] ss)),1) | ss <- ll]
frame f aa = fromJust $ histogramsMapVarsFrame aa (Map.fromList $ map (\(VarInt i) -> (VarInt i, VarInt (f i))) $ Set.toList $ vars aa)
regtranspose ll aa = frame (\ i -> toInteger (ll !! fromInteger (i-1))) aa
cdrefr = regtranspose
regpermute i ll aa = llaa [(llss [(VarInt k, if fromInteger k == i then ValInt (toInteger (ll !! fromInteger (j-1))) else ValInt j) | (VarInt k,ValInt j) <- ssll ss],c) | (ss,c) <- aall aa]
cdperm = regpermute
regcopy aa = frame (+ (dim aa)) aa
dot aa bb = llaa $ map (\((ss,q),(rr,p)) -> (sunion ss rr, q*p)) $ zip (aall aa) (cycle (aall bb)) 
runiform = histogramsRandomsUniform
raa aa n = [aa] ++ [runiform aa i | i <- [1..n]]
rreg d n i = let qq = [regsing d n, regcart d n, regdiag d n, regcrown d n, regplanar d n, regline d n, regaxial d n, regpivot d n]
                 pp = qq ++ map (\aa -> regcart d n `sub` aa) qq
             in concat (map (\aa -> raa aa i) pp)
rregz d n i z = [resize z aa | aa <- rreg d n i, z >= 0, size aa > 0]
perturb aa e = [aa `add` single ss e `sub` single tt e | (ss,c) <- aall (trim aa), (tt,d) <- aall (trim aa), tt /= ss, d >= e]

aahh aa = fromJust $ histogramsHistory aa
hhaa hh = historiesHistogram hh
hshuffle hh r = fromJust $ historiesShuffle hh r
ashuffle aa r = hhaa $ hshuffle (aahh aa) r
hvars = historiesSetVar
hred hh vv = setVarsHistoriesReduce vv hh

pt x = represent x
und = transformsUnderlying
der = transformsDerived
tvars = transformsVars
ttaa = transformsHistogram
tmul aa tt = transformsHistogramsApply tt aa
inv = Map.toList . transformsInverse
trans xx ww = fromJust $ histogramsSetVarsTransform xx ww
ttpp = transformsPartition
ttnn = transformsSetPartition

cdtt pp ll = trans (regtranspose pp (cdaa ll)) (Set.singleton (VarInt (last pp)))
treg d n = [let yy = frame (+n) (regcart i 1) in trans (dot (regcart d n) yy) (vars yy) | i <- [1..d^n]]
treg2 d n = [let yy = frame (+n) (regcart i 1) in trans (dot (regcart d n) yy) (vars yy) | i <- [2..d^n]]
treg2b d n b = [let yy = frame (+n) (regcart i 1) in trans (dot (regcart d n) yy) (vars yy) | i <- [2..b]]
tregm d n m = map (fftt. qqff) $ foldl (\qq pp -> [Set.insert tt ff | ff <- qq, tt <- pp]) [Set.empty] [map (\tt -> tframell tt [(n+1,n+k)]) (treg2 d n) | k <- [1 .. m]]
tregmb d n b m = map (fftt. qqff) $ foldl (\qq pp -> [Set.insert tt ff | ff <- qq, tt <- pp]) [Set.empty] [map (\tt -> tframell tt [(n+1,n+k)]) (treg2b d n b) | k <- [1 .. m]]

tframe f tt = fromJust $ transformsMapVarsFrame tt (Map.fromList $ map (\(VarInt i) -> (VarInt i, VarInt (f i))) $ Set.toList $ tvars tt)
tframell tt ll = fromJust $ transformsMapVarsFrame tt (Map.fromList $ map (\(i,j) -> (VarInt i, VarInt j)) ll)

conind aa tt = fromJust $ histogramsTransformsConverseIndependent aa tt
conact aa tt = fromJust $ histogramsTransformsConverseActual aa tt

qqff = fromJust . setTransformsFud
llff = qqff . Set.fromList
ttff = fromJust . setTransformsFud . Set.singleton

pf ff = represent ff
ffqq = fudsSetTransform
fvars = fudsVars
fder = fudsDerived
fund = fudsUnderlying
fhis = fudsSetHistogram
fftt = fudsTransform
funion ff gg = qqff (ffqq ff `Set.union` ffqq gg)
fapply aa ff = fudsHistogramsApply ff aa
fmul aa ff = fudsHistogramsMultiply ff aa
ffaa  = ttaa . fftt
layer ff = fudsSetVarsLayer ff (fder ff)
fsys = fudsSystemImplied
fmp ff ll = qqff (Set.map (\tt -> fromJust (transformsMapVarMapValsFrame tt (umap (fsys ff) ll))) (ffqq ff))
fmpi ff = fmp ff [VarInt i | i <- [1..]]

fregb d n b m = map qqff $ foldl (\qq pp -> [Set.insert tt ff | ff <- qq, tt <- pp]) [Set.empty] [map (\tt -> tframell tt [(n+1,n+k)]) (treg2b d n b) | k <- [1 .. m]]
fregbno d n b m = map qqff $ foldl (\qq pp -> [Set.insert tt ff | ff <- qq, tt <- pp]) [Set.empty] [map (\tt -> tframell tt ([(i,n*(k-1)+i) | i <- [1..n]] ++ [(n+1,n*m+k)])) (treg2b d n b) | k <- [1 .. m]]

zzdd zz = fromJust $ treePairStateTransformsDecomp zz
ddzz = decompsTreePairStateTransform
ddff = decompsFud
dund = decompsUnderlying
dmul aa dd = decompsHistogramsApply dd aa

zzdf zz = fromJust $ treePairStateFudsDecompFud zz
dfzz = decompFudsTreePairStateFud
dfdd df = fromJust $ decompFudsDecomp df
dfff = decompFudsFud
dfund = decompFudsUnderlying
dfapply aa df = decompFudsHistogramsApply df aa
dfmul aa df = decompFudsHistogramsMultiply df aa

aare aa = map (\(ss,c) -> (ss,fromRational c)) (histogramsList aa) :: [(State,Double)]
aaar uu aa = fromJust $ systemsHistogramsHistogramRepa uu aa
araa uu rr = fromJust $ systemsHistogramRepasHistogram uu rr
arred aa vv = setVarsHistogramRepasReduce vv aa

hhhr uu hh = fromJust $ systemsHistoriesHistoryRepa uu hh
hrhh uu hr = fromJust $ systemsHistoryRepasHistory_u uu hr
aahr uu aa = hhhr uu $ aahh aa
hrhx = historyRepasRed
hrred hh vv = setVarsHistoryRepasReduce 1 vv hh
hrev = eventsHistoryRepasHistoryRepaSelection
hrmult = systemsDecompFudsHistoryRepasMultiply
hrquery = systemsDecompFudsHistoryRepasHistoriesQuery
hrtest = systemsDecompFudsHistoryRepasHistoryRepasSetVariablesTest
hrvars = historyRepasSetVariable
hrsize = historyRepasSize
hralgn = systemsDecompFudsHistoryRepasAlignmentContentShuffleSummation_u
hralgntree = systemsDecompFudsHistoryRepasTreeAlignmentContentShuffleSummation_u

ent = histogramsEntropy 
lent aa ww vvl = ent (aa `red` (ww `Set.union` vvl)) - ent (aa `red` ww)
algn = histogramsAlignment
algnden aa = let v = fromIntegral (vol (sys aa) (vars aa)); n = fromIntegral (dim aa) in algn aa  / (v ** (1/n))


pd x = represent x

rp x = represent x
rj (Just x) = represent x
rj Nothing = "Nothing"

rpln ll = mapM_ (print . rp) ll

dp2 x = fromIntegral (truncate (100.0 * x)) / 100.0

decomperIO uu vv hh wmax lmax xmax omax bmax mmax umax pmax fmax mult seed =
      parametersSystemsHistoryRepasDecomperMaxRollByMExcludedSelfHighestFmaxIORepa 
        wmax lmax xmax omax bmax mmax umax pmax fmax mult seed uu vv hh

aamax aa = if size aa > 0 then (snd $ last $ sort [(c,ss) | (ss,c) <- aall aa]) else stateEmpty
amax aa = if size aa > 0 then (last $ sort $ snd $ unzip $ aall aa) else 0

names = map (\(_,v,uu) -> (v, map (\s -> let (u,k) = break (=='=') s in (head (tail k),u)) uu)) [(0,"edible",["edible=e", "poisonous=p"]),(1,"cap-shape",["bell=b","conical=c","convex=x","flat=f","knobbed=k","sunken=s"]),(2,"cap-surface",["fibrous=f","grooves=g","scaly=y","smooth=s"]),(3,"cap-color",["brown=n","buff=b","cinnamon=c","gray=g","green=r","pink=p","purple=u","red=e","white=w","yellow=y"]),(4,"bruises",["bruises=t","no=f"]),(5,"odor",["almond=a","anise=l","creosote=c","fishy=y","foul=f","musty=m","none=n","pungent=p","spicy=s"]),(6,"gill-attachment",["attached=a","descending=d","free=f","notched=n"]),(7,"gill-spacing",["close=c","crowded=w","distant=d"]),(8,"gill-size",["broad=b","narrow=n"]),(9,"gill-color",["black=k","brown=n","buff=b","chocolate=h","gray=g", "green=r","orange=o","pink=p","purple=u","red=e","white=w","yellow=y"]),(10,"stalk-shape",["enlarging=e","tapering=t"]),(11,"stalk-root",["bulbous=b","club=c","cup=u","equal=e","rhizomorphs=z","rooted=r","missing=?"]),(12,"stalk-surface-above-ring",["fibrous=f","scaly=y","silky=k","smooth=s"]),(13,"stalk-surface-below-ring",["fibrous=f","scaly=y","silky=k","smooth=s"]),(14,"stalk-color-above-ring",["brown=n","buff=b","cinnamon=c","gray=g","orange=o","pink=p","red=e","white=w","yellow=y"]),(15,"stalk-color-below-ring",["brown=n","buff=b","cinnamon=c","gray=g","orange=o", "pink=p","red=e","white=w","yellow=y"]),(16,"veil-type",["partial=p","universal=u"]),(17,"veil-color",["brown=n","orange=o","white=w","yellow=y"]),(18,"ring-number",["none=n","one=o","two=t"]),(19,"ring-type",["cobwebby=c","evanescent=e","flaring=f","large=l","none=n","pendant=p","sheathing=s","zone=z"]),(20,"spore-print-color",["black=k","brown=n","buff=b","chocolate=h", "green=r","orange=o","purple=u","white=w","yellow=y"]),(21,"population",["abundant=a","clustered=c","numerous=n","scattered=s","several=v","solitary=y"]),(22,"habitat",["grasses=g","leaves=l","meadows=m","paths=p","urban=u","waste=w","woods=d"])]


