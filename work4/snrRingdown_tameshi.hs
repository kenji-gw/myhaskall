module SnrRingdown_tameshi
       (snrRingdown)where

import System.Environment
import System.IO
import Numeric.LinearAlgebra
import Data.List
import Data.Ord


 -- 光速の定義[m/s]
c :: Double
c  = 2.99*(10**8)

 -- 万有引力定数の定義[m^3 kg^-1 s^-2]
g :: Double
g = 6.67*(10**( - 11))

 -- 太陽質量[kg]
msolar :: Double
msolar = 1.989*(10**30)

 -- Mpc[m]
megapc :: Double
megapc = 3.085677*(10**22)


 --- snrRingdown:リングダウンのSNRを定義する際、引数をリストでも良いようにする
 -- 引数
 -- BH質量[太陽質量] BHまでの距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器 周波数cutoff上限[Hz] 周波数cutoff下限[Hz]
snrRingdown :: [Double] ->  [Double] -> [Double] -> [Double] -> [Double] -> [FilePath] ->  [Double] -> [Double] -> IO[()]
snrRingdown msol dmpc a epsil phi ifo fupp flower = sequence $ zipWith8' snrRingdownSingle msollist dmpclist alist epsillist philist ifolist fupplist flowerlist
  where lengthmsol = length msol
        lengthdmpc = length dmpc
        lengtha = length a
        lengthepsil = length epsil
        lengthphi = length phi
        lengthifo = length ifo
        lengthfupp = length fupp
        lengthflower = length flower
        maxlengthofparam = maximum [lengthmsol,lengthdmpc,lengtha,lengthepsil,lengthphi,lengthifo,lengthfupp,lengthflower] -- 引数のリストの長さの内最も長いものの長さを出力
        msollist = msol ++ (replicate (maxlengthofparam - (lengthmsol)) (last msol))
        dmpclist = dmpc ++ (replicate (maxlengthofparam - (lengthdmpc)) (last dmpc))
        alist = a ++ (replicate (maxlengthofparam - (lengtha)) (last a))
        epsillist = epsil ++ (replicate (maxlengthofparam - (lengthepsil)) (last epsil))
        philist = phi ++ (replicate (maxlengthofparam - (lengthphi)) (last phi))
        ifolist = ifo ++ (replicate (maxlengthofparam - (lengthifo)) (last ifo))
        fupplist = fupp ++ (replicate (maxlengthofparam - (lengthfupp)) (last fupp))
        flowerlist = flower ++ (replicate (maxlengthofparam - (lengthflower)) (last flower)) -- 引数のリストを、最も長いものと同等になるように増やす



 --- snrRingdownSingle:リングダウンのSNRを定義する際の入力データのエラーを出力する
 -- 引数
 -- BH質量[太陽質量] BHまでの距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器 周波数cutoff上限[Hz] 周波数cutoff下限[Hz]
snrRingdownSingle :: Double ->  Double ->  Double -> Double -> Double ->  FilePath ->  Double -> Double -> IO()
snrRingdownSingle msol dmpc a epsil phi ifo fupp flower
    | msol <  0 =  error "mass : Why did you insert a minus number?"
    | dmpc <  0 =  error "distance : Why did you insert a minus number?"
    | a <  0 =  error "Kerr parameter : Why did you insert a minus number?"
    | eps <  0 =  error " : Why did you insert a minus number?"
    | fupp <  0 =  error "upper frequency : Why did you insert a minus number?"
    | flower <  0 =  error "lower frequency : Why did you insert a minus number?"
    | otherwise = filestream msol dmpc a epsil phi ifo fupp flower

 --- filestream:周波数、パワースペクトルデータを整形し、SNRを求め、値をIOで返す。詳しくはプログラム中のコメントを参照
 -- 引数
 -- BH質量[太陽質量] BHまでの距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器 周波数cutoff上限[Hz] 周波数cutoff下限[Hz]
filestream :: Double -> Double -> Double -> Double -> Double -> FilePath -> Double -> Double -> IO()
filestream msol dmpc a epsil phi ifo fupp flower = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num = map words $ lines contents  -- データを[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..]という形に整形
      readnum = map (map read) num :: [[Double]] -- データの型をDoubleに変換
      readnumwithfrequencycut = updowncut readnum flower fupp -- データの周波数を必要な分だけ取り出す(詳しくはupdowncut関数を参照)
      numfreq = map head readnumwithfrequencycut -- 周波数データのみのリストを作成
      numnois = map last readnumwithfrequencycut -- パワースペクトルのみのリストを作成
      vectnumhead = fromList numfreq -- 周波数データをリストからVectorに変換
      nf = dim vectnumhead
      f1 = subVector 0 (nf - 1) vectnumhead
      f2 = subVector 1 (nf - 1) vectnumhead
      df = zipWith (-) (toList f2) (toList f1) -- 離散データ間の周波数刻み幅のリストを作成
      integratedRingdownwithparam fin noiseSpec= integratedRingdown msol a phi fin noiseSpec -- 周波数、パワースペクトル以外の変数を指定したintegratedRingdownを返す
      mapRingdownwithparam = zipWith (*) df (init (zipWith integratedRingdownwithparam numfreq numnois)) -- zipWithで離散データの周波数、パワースペクトルのリストをintegratedwithparamに適用し、リストを返す。更にそのリスト全てに対応する周波数刻み幅の重み付けをする
      snrRingdownPow2 = foldr (+) 0 mapRingdownwithparam -- 作成したリストを全て足し合わせる
      getsnrRingdown = snrRingdownculc msol dmpc a epsil snrRingdownPow2 -- SNRを計算する
  print getsnrRingdown -- IOで返す


 --- integratedRingdown:リングダウンのSNRの被積分関数を定義
 -- 引数
 -- BH質量[太陽質量] Kerr parameter 使用する検出器 検出器のノイズスペクトル
integratedRingdown :: Double -> Double -> Double -> Double -> Double -> Double
integratedRingdown msol a phi fin noiseSpec = ((cos(phi)**2)*((1/((fqnr/q)**2 + 4*(fin - fqnr)**2) + 1/((fqnr/q)**2 + 4*(fin + fqnr)**2))**2) + (sin(phi)**2)*((1/((fqnr/q)**2 + 4*(fin - fqnr)**2) -  1/((fqnr/q)**2 + 4*(fin + fqnr)**2))**2)) /noiseSpec
  where q = 2*(1 - a)**( - 9/20)
        fqnr = (1 - 0.63*(1 - a)**(3/10))/(2*pi*m)
        m = (g*msol*(msolar)/(c**(3)))


 --- snrRingdownculc:リングダウンのSNRを定義
 -- 引数
 -- BH質量[太陽質量] BHまでの距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器
snrRingdownculc :: Double -> Double -> Double -> Double -> Double -> Double
snrRingdownculc msol dmpc a epsil snrRingdownPow2 = ((((10*epsil*m*fqnr)/(q*pi*(1 + 7/(24*(q**2)))))**(1/2))*(snrRingdownPow2)**(1/2))/(pi*q*(d/c))
  where q = 2*(1 - a)**( - 9/20)
        fqnr = (1 - 0.63*(1 - a)**(3/10))/(2*pi*m)
        m = (g*msol*(msolar)/(c**(3)))
        d = dmpc*(megapc)


--- updownnonerrorcut:指定した周波数バンドのみのデータを使用するよう、周波数の上限、下限を引数に取りその分のデータのみを取得する
 -- 引数
 -- 検出器の周波数及びノイズパワースペクトルデータのリスト 周波数カットオフ下限 周波数カットオフ上限
updownnonerrorcut :: [[Double]] -> Double -> Double -> [[Double]]
updownnonerrorcut xs flower fupp
  | head (head xs) < flower = updownnonerrorcut (tail xs) flower fupp
  | head (last xs) > fupp = updownnonerrorcut (init xs) flower fupp
  | otherwise = xs


--- updowncut:updownnonerrrorcutのエラー出力;指定したカットオフよりも元データの周波数が足りなかった場合にエラーを出力する
 -- 引数
 -- 検出器の周波数及びノイズパワースペクトルデータのリスト 周波数カットオフ下限 周波数カットオフ上限
updowncut :: [[Double]] -> Double -> Double -> [[Double]]
updowncut xs flower fupp
  | head (head xs) >=  flower = error "The input lower frequency is lower than the lower frequency of the detector noise power spectrum data"
  | head (last xs) <=  fupp = error "The input upper frequency is larger than the upper frequency of the detector noise power spectrum data"
  | otherwise = updownnonerrorcut xs flower fupp


--- wipWith8':zipWithの8変数バーション
 -- 引数
 -- 八変数の関数 引数のリスト*8
zipWith8' :: (a -> b -> c -> d -> e -> f -> g -> h -> i) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [h] -> [i]
zipWith8' _ [] _ _ _ _ _ _ _ = []
zipWith8' _ _ [] _ _ _ _ _ _ = []
zipWith8' _ _ _ [] _ _ _ _ _ = []
zipWith8' _ _ _ _ [] _ _ _ _ = []
zipWith8' _ _ _ _ _ [] _ _ _ = []
zipWith8' _ _ _ _ _ _ [] _ _ = []
zipWith8' _ _ _ _ _ _ _ [] _ = []
zipWith8' _ _ _ _ _ _ _ _ [] = []
zipWith8' f (x:xs) (y:ys) (z:zs) (j:js) (k:ks) (l:ls) (m:ms) (n:ns) = f x y z j k l m n : zipWith8' f xs ys zs js ks ls ms ns
