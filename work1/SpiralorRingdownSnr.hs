module SpiralorRingdownSnr
       (snrInspiral
       )where

import DetectorSensitivity
import Detector
import Numeric.LinearAlgebra

 --- integratedInpiral:インスパイラルのSNRの被積分関数を定義
 -- 引数
 -- 使用する検出器 周波数
integratedInspiral :: Detector -> Vector Double -> Vector Double
integratedInspiral ifo fin = fin**(-7/3)/(ifonoisepsd ifo fin)



 --- snrInspiralPow2:インスパイラルの積分部分を定義
 --- 数値積分においては、単純な\sum dfを使用
 -- 引数
 -- 連星質量1[太陽質量] 連星太陽質量2[太陽質量] 使用する検出器 周波数cutoff下限[Hz] 数値積分刻み幅
snrInspiralPow2 :: Vector Double ->  Vector Double -> Detector ->  Vector Double -> Vector Double -> Vector Double
snrInspiralPow2 msol1 msol2 ifo flower df
    | flower <  0 =  error "lower frequency : Why did you insert a minus number?"
    | df <  0 =  error "df : Why did you insert a minus number?"
    | flower > fupp =  0
    | otherwise = (integratedInspiral ifo flower)*df + (snrInspiralPow2 msol1 msol2 ifo (flower +  df)  df)
  where fupp = 1/((6**(3/2)) *pi*(msol1 + msol2)*(1.989*(10**30))*(g/(c**3)))
            where c = 2.99*(10**8)
                  g = 6.67*(10**(-11))

 --- snrInspiral:インスパイラルのSNRを定義
 -- 引数
 -- 連星質量1[太陽質量] 連星質量2[太陽質量] 連星までの距離[Mpc] 使用する検出器 周波数cutoff下限[Hz] 数値積分刻み幅
snrInspiral :: Vector Double ->  Vector Double ->  Vector Double -> Detector ->  Vector Double -> Vector Double -> Vector Double
snrInspiral msol1 msol2 dmpc ifo flower df
    | msol1 <  0 =  error "mass 1: Why did you insert a minus number?"
    | msol2 <  0 =  error "mass 2 : Why did you insert a minus number?"
    | dmpc <  0 =  error "distance : Why did you insert a minus number?"
    | otherwise = (cons*(allmass**(5/6))*((5*symmass/6)**(1/2))/(d * pi**(2/3)))*((snrInspiralPow2 msol1 msol2 ifo flower df)**(1/2))
  where allmass = (msol1 + msol2)*1.989*(10**30)
        symmass = msol1*msol2/((msol1 + msol2)**2)
        d = dmpc*3.085677*(10**22)
        cons = c*((g/(c**3))**(5/6))
          where c = 2.99*(10**8)
                g = 6.67*(10**(-11))
