import System.Environment
import System.IO
import Data.List
import SnrRingdown_tameshi_ver2
import Control.Monad

dataRead ::  [Double] ->  [Double] -> [Double] -> [Double] -> [Double] -> [FilePath] ->  [Double] -> [Double] -> IO()
dataRead msol dmpc a epsil phi ifo fupp flower = do
   contents <- forM ifo readFile  -- FilePathのデータのポインタをcontentsに格納
   let num = map lines contents
       num2 = map (map words) num      -- データを[[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..],..]という形に整形
       ifolist = map (map (map read)) num2 :: [[[Double]]] -- データの型をDoubleに変換
   print $ snrRingdown msol dmpc a epsil phi ifolist fupp flower
