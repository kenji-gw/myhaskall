import System.Environment
import System.IO
import Data.List
import SnrRingdown_tameshi_ver2
import Control.Monad

-- dataRead ::  [Double] ->  [Double] -> [Double] -> [Double] -> [Double] -> [FilePath] ->  [Double] -> [Double] -> IO()
-- dataRead msol dmpc a epsil phi ifo fupp flower = do
--    contents <- forM ifo readFile  -- FilePathのデータのポインタをcontentsに格納
--    let num = map lines contents
--        num2 = map (map words) num      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
--        ifolist = map (map (map read)) num2 :: [[[Double]]] -- データの型をDoubleに変換
--        ifolist2 = map (map tuplify2) ifolist
--    print $ snrRingdown msol dmpc a epsil phi ifolist2 fupp flower

dataRead :: Double ->  Double -> Double -> Double -> Double -> FilePath ->  Double -> Double -> IO()
dataRead msol dmpc a epsil phi ifo fupp flower = do
   contents <- readFile ifo  -- FilePathのデータのポインタをcontentsに格納
   let num =  map words $ lines contents      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
       ifolist = map (map read) num :: [[Double]] -- データの型をDoubleに変換
       ifolist2 = map tuplify2 ifolist
   print $ snrRingdown msol dmpc a epsil phi ifolist2 fupp flower


tuplify2 ::  [a] ->  (a,a)
tuplify2 [x,y] = (x,y)
