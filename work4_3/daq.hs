import System.Environment
import System.IO
import Data.List
import InspiralRingdownSnrQuanta
import Control.Monad
import InspiralRingdownDistanceQuanta

snrInspiralCulculation :: Double -> Double -> Double -> FilePath -> IO()
snrInspiralCulculation msol1 msol2 dmpc ifo = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ snrInspiral msol1 msol2 dmpc ifolist2

snrInspiralCoreCulculation :: Double -> Double -> Double -> FilePath -> Double -> IO()
snrInspiralCoreCulculation msol1 msol2 dmpc ifo flower = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ snrInspiralCore msol1 msol2 dmpc ifolist2 flower

snrRingdownCulculation :: Double -> Double -> FilePath -> IO()
snrRingdownCulculation msol dmpc ifo = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ snrRingdown msol dmpc ifolist2

snrRingdownCoreCulculation :: Double -> Double -> Double -> Double -> Double -> FilePath -> Double -> Double -> IO()
snrRingdownCoreCulculation msol dmpc a epsil phi ifo fupp flower = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ snrRingdownCore msol dmpc a epsil phi ifolist2 fupp flower

distInspiralCulculation :: Double -> Double -> FilePath -> IO()
distInspiralCulculation msol1 msol2 ifo = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ distInspiral msol1 msol2 ifolist2

distInspiralCoreCulculation :: Double -> Double -> Double -> FilePath -> Double -> IO()
distInspiralCoreCulculation msol1 msol2 snr ifo flower = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ distInspiralCore msol1 msol2 snr ifolist2 flower

distRingdownCulculation :: Double -> FilePath -> IO()
distRingdownCulculation msol ifo = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ distRingdown msol ifolist2

distRingdownCoreCulculation :: Double -> Double -> Double -> Double -> Double -> FilePath -> Double -> Double -> IO()
distRingdownCoreCulculation msol snr a epsil phi ifo fupp flower = do
  contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
  let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
      ifolist = map (map read) num :: [[Double]] -- データをDoubleに変換
      ifolist2 = map tuplify2 ifolist -- データを[(Double,Double)]に変換
  print $ distRingdownCore msol snr a epsil phi ifolist2 fupp flower


tuplify2 ::  [a] ->  (a,a)
tuplify2 [x,y] = (x,y)
