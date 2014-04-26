SpiralRingdownSnr
=================

できること  
---------
インスパイラルとリングダウンのパラメータを代入すれば、SNRを出力してくれる  

使い方
------
SpiralorRingdownSnrをGHCiでロードした後、  
・インスパイラル  
snrInspiral 連星質量1[太陽質量] 連星質量2[太陽質量] 連星までの距離[Mpc] 使用する検出器 周波数cut\|
off下限[Hz] 数値積分刻み幅  
の引数をそれぞれ代入  

例
```
Prelude> :l SpiralorRingdownSnr.hs
[1 of 3] Compiling Detector         ( Detector.hs, interpreted )
[2 of 3] Compiling DetectorSensitivity ( DetectorSensitivity.hs, interpreted )
[3 of 3] Compiling SpiralorRingdownSnr ( SpiralorRingdownSnr.hs, interpreted )
Ok, modules loaded: SpiralorRingdownSnr, DetectorSensitivity, Detector.
*SpiralorRingdownSnr> snrInspiral 1.4 1.4 280 KAGRA 30 0.05
Loading package array-0.4.0.1 ... linking ... done.
Loading package deepseq-1.3.0.1 ... linking ... done.
Loading package primitive-0.5.0.1 ... linking ... done.
Loading package vector-0.10.0.1 ... linking ... done.
Loading package bytestring-0.10.0.2 ... linking ... done.
Loading package containers-0.5.0.0 ... linking ... done.
Loading package binary-0.5.1.1 ... linking ... done.
Loading package filepath-1.3.0.1 ... linking ... done.
Loading package old-locale-1.0.0.5 ... linking ... done.
Loading package time-1.4.0.1 ... linking ... done.
Loading package unix-2.6.0.1 ... linking ... done.
Loading package directory-1.2.0.1 ... linking ... done.
Loading package process-1.1.0.2 ... linking ... done.
Loading package random-1.0.1.1 ... linking ... done.
Loading package storable-complex-0.2.1 ... linking ... done.
Loading package hmatrix-0.15.2.1 ... linking ... done.
fromList [8.168393032812842] 
```
・リングダウン  
snrRingdown BH質量[太陽質量] BHまでの距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器 周波数cutoff上限[Hz] 周波数cutoff下限[Hz] 数値積分刻み幅  
の引数をそれぞれ代入  

例
```
Prelude> :l SpiralorRingdownSnr
[1 of 3] Compiling Detector         ( Detector.hs, interpreted )
[2 of 3] Compiling DetectorSensitivity ( DetectorSensitivity.hs, interpreted )
[3 of 3] Compiling SpiralorRingdownSnr ( SpiralorRingdownSnr.hs, interpreted )
Ok, modules loaded: SpiralorRingdownSnr, DetectorSensitivity, Detector.
*SpiralorRingdownSnr> snrRingdown 300 8697 0.9 0.01 0 KAGRA 4048 10 0.05
Loading package array-0.4.0.1 ... linking ... done.
Loading package deepseq-1.3.0.1 ... linking ... done.
Loading package primitive-0.5.0.1 ... linking ... done.
Loading package vector-0.10.0.1 ... linking ... done.
Loading package bytestring-0.10.0.2 ... linking ... done.
Loading package containers-0.5.0.0 ... linking ... done.
Loading package binary-0.5.1.1 ... linking ... done.
Loading package filepath-1.3.0.1 ... linking ... done.
Loading package old-locale-1.0.0.5 ... linking ... done.
Loading package time-1.4.0.1 ... linking ... done.
Loading package unix-2.6.0.1 ... linking ... done.
Loading package directory-1.2.0.1 ... linking ... done.
Loading package process-1.1.0.2 ... linking ... done.
Loading package random-1.0.1.1 ... linking ... done.
Loading package storable-complex-0.2.1 ... linking ... done.
Loading package hmatrix-0.15.2.1 ... linking ... done.
fromList [8.667669341182771]
```

HasKALモジュールとの変更点
--------------------------
・Detector.hs  
module HasKAL.DetectorUtils.Detector -> Detector  
  
・DetectorSensitivity.hs  
変更前  
module HasKAL.SpectrumUtils.DetectorSensitivity  
  (ifonoisepsd  
  ) where  
  
import Numeric.LinearAlgebra  
import HasKAL.DetectorUtils.Detector  
  
変更後  
module DetectorSensitivity  
       (ifonoisepsd  
       , aligoPsd  
       , kagraPsd  
       , advirgoPsd  
       ) where  
import Numeric.LinearAlgebra  
import Detector  
  
.cabalコンパイルがうまく行かなかったため、全て自分のワークスペースディレクトリの上で作業を行った。  
そのため、module、import設定をワークスペース上で使えるように書きなおした。  
  
プログラム説明  
--------------
(以下で、~はInspiralもしくはRingdownを表す文字という意味で用いる)  
  
1.integrate~  
被積分関数をここで定義  
2.snr~Pow2  
単純な\sum dfを用いて被積分関数を数値積分する  
3.snr~  
2で積分したもののルートを取り、残りのパラメータを代入してSNRを出力する  
  
その他のプログラムの詳細は、SpiralorRingdownSnr.hsにコメントを付けておいたので、それを確認して下さい。  
