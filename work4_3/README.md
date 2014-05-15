snrInspiralRingdown.hs,distInspiralRingdown,hs
=================

できること  
---------
インスパイラル、リングダウンのパラメータを代入すれば、離散データによる周波数、パワースペクトルデータからRingdownのSNRを出力してくれる  
実行には離散データを何らかの形で[(周波数,パワースペクトル)]の型に直す必要がある  

使い方
------
daq.hs(ここでは、テキストデータにある離散データを読み込み、[(周波数,パワースペクトル)]に直して関数に値を渡すIOを定義している)をGHCiでロードした後、  
-distInspiralCore  
distInspiralCoreCulculation 連星質量1[太陽質量] 連星質量2[太陽質量] SNR 使用する検出器 周波数cutoff下限[Hz]  
-distInspiral  
distInspiral 連星質量1[太陽質量] 連星質量2[太陽質量] SNR 使用する検出器  
-distRingdownCore  
distRingdownCoreCulculation BH質量[太陽質量] SNR Kerr parameter 質量欠損比率 初期位相 使用する検出器 周波数cutoff上限[Hz] 周波数cutoff下限[Hz]    
-distRingdown  
distRingdown BH質量[太陽質量] SNR Kerr parameter 質量欠損比率 初期位相 使用する検出器  
-snrInspiralCore  
snrInspiralCoreCulculation 連星質量1[太陽質量] 連星質量2[太陽質量] 距離[Mpc] 使用する検出器 周波数cutoff下限[Hz]  
-snrInspiral  
snrInspiral 連星質量1[太陽質量] 連星質量2[太陽質量] 距離[Mpc] 使用する検出器  
-snrRingdownCore  
snrRingdownCoreCulculation BH質量[太陽質量] 距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器 周波数cutoff上限[Hz] 周波数cutoff下限[Hz]    
-snrRingdown  
distRingdown BH質量[太陽質量] 距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器  

例
```
*Main> distRingdowPrelude> :l daq.hs
[1 of 3] Compiling InspiralRingdownDistanceQuanta ( InspiralRingdownDistanceQuanta.hs, interpreted )
[2 of 3] Compiling InspiralRingdownSnrQuanta ( InspiralRingdownSnrQuanta.hs, interpreted )
[3 of 3] Compiling Main             ( daq.hs, interpreted )
Ok, modules loaded: InspiralRingdownSnrQuanta, InspiralRingdownDistanceQuanta, Main.
*Main> snrInspiralCulculation 1.4 1.4 280 "kagraPsd.dat"
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
8.23304118549503
*Main> snrInspiralCoreCulculation 1.4 1.4 280 "kagraPsd.dat" 10
8.23304118549503
*Main> snrRingdownCulculation 300 15840 "kagraPsd.dat"
8.00018224854012
*Main> snrRingdownCoreCulculation 300 15840 0.98 0.03 0.0 "kagraPsd.dat" 2048 10
8.00018224854012
*Main> distInspiralCulculation 1.4 1.4 "kagraPsd.dat"
288.156441492326
*Main> distInspiralCoreCulculation 1.4 1.4 8 "kagraPsd.dat" 10
288.156441492326
*Main> distRingdownCulculation 300 "kagraPsd.dat"
15840.358769466673
*Main> distRingdownCoreCulculation 300 8 0.98 0.03 0.0 "kagraPsd.dat" 2048 10
15840.360852109441
```
