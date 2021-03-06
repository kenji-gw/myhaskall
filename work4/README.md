snrRingdown_tamesi.hs  
=================

できること  
---------
インスパイラルとリングダウンのパラメータを代入すれば、テキストデータによる周波数、パワースペクトルデータからRingdownのSNRを出力してくれる  
なお、リストで引数を代入するとそれに対応したデータをリストの長さだけ返してくれる  

使い方
------
snrRingdown_tamesiをGHCiでロードした後、  
・リングダウン  
snrRingdown BH質量[太陽質量] BHまでの距離[Mpc] Kerr parameter 質量欠損比率 初期位相 使用する検出器のFilePath 周波数cutoff上限[Hz] 周波数cutoff下限[Hz]
の引数をそれぞれ代入  

例
```
*SnrRingdown_tameshi> snrRingdown [300] [8697] [0.9] [0.01] [0] ["kagraPsd.dat","advirgoPsd.dat","aligoPsd.dat"] [1000] [50]
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
8.665677132783424
6.004656039880023
7.964807524272288
[(),(),()]
```

プログラム説明(概要)  
--------------
このプログラムは多数の関数を使用しているので、どのような流れで全体が動作しているのかを記述する  
・snrRingdownにリストの引数を与える  
・snrRingdownでリストの長さを最も長いものに合うように調整し、snrRingdownSingleに8変数のzipWithを介して変数を渡す  
・snrRingdownSingleで引数に不正なデータはないか(引数に負のデータが含まれていないか)をチェックして、filestreamに8変数を渡す  
・filestreamでFilePath内のデータを[[Double]]型に変換し、[[周波数1,パワースペクトル1],[周波数2,パワースペクトル2]..]というデータ形式に整形。その後、周波数データ、パワースペクトルデータをリストとしてそれぞれnumfreq、numnoisに格納、さらに[周波数2-周波数1,周波数3-周波数2]といった離散データの周波数刻みをdfにリストとして格納する。  
・周波数、パワースペクトル以外の引数を与えたintegratedRingdown関数をintegratedRingdownwithparamとして定義する  
・zipWithでintegratedRingdownwithparamにzipWithで引数を与える。引数はnumfreq、numnoisを使用。作成されたデータに周波数刻みの重み付けをするため、zipWith (*) dfでリスト全体に対応する周波数刻み幅を作用させる。そのデータをmapRingdownwithparamに格納  
・作成されたmapRingdownwithparamのリスト成分を全て足しあわせて、snrRingdownPow2に格納  
・snrRingdownにこのデータと他引数を作用させ、SNRを出力し、getsnrRingdownに格納  
・getsnrRingdownをprint関数を使用してIO形式で返す  
・snrRingdownには、リストとしてIOデータが入っているものが帰ってくる。このままprintは出来ないので、sequenceを使用してデータをコンソール上に返す。  

プログラムの整合性
-----------------
以前作成したSNR計算のプログラムに同条件で計算をさせてみたところ、
```
*SpiralorRingdownSnr> snrRingdown 300 8697 0.9 0.01 0 KAGRA 1000 50 1
fromList [8.665677197362033]
*SpiralorRingdownSnr> snrRingdown 300 8697 0.9 0.01 0 VIRGO 1000 50 1
fromList [6.004656044019084]
*SpiralorRingdownSnr> snrRingdown 300 8697 0.9 0.01 0 LIGO 1000 50 1
fromList [7.964807513176917]
```
と、ほぼ同様のSNRを返したので、計算は間違っていないと思われる。
