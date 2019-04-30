# Sound Source Localization
Classical algorithms of sound source localization with beamforming, TDOA and high-resolution spectral estimation.

## Usage
```bash
matlab -nodesktop -nosplash –r matlabfile (name of .m)
```

## Algorithm Interpretation
* Beamforming: a spatial filtering method, is a signal processing technique used in sensor arrays for directional signal transmission or reception.
* MUSIC: Multiple Signal Classification
* ESPRIT: Estimation of Signal Parameters via Rotational Invariance Technique
* MVDR: Minimum Variance Distortionless Response
* GCC-PHAT: Generalized Cross Correlation - Phase Transform (TDOA estimation)
* SRP-PHAT: Steered Response Power - Phase Transform 

## Reference Paper
* Paper 1
  * **Title**: *Comparison of Direction of Arrival (DOA) Estimation Techniques for Closely Spaced Targets*
  * **Authors**: Nauman Anwar Baig and Mohammad Bilal Malik
  * **Published**: International journal of future computer and communication 2, no. 6 (2013): 654
* Paper 2
  * **Title**: [*Outdoor sound localization using a tetrahedral array*](https://projekter.aau.dk/projekter/files/281708108/Master_Thesis_Final.pdf)

## Results
### 1. Algorithm Summary
#### 1.1 Classical Beamforming
![](MUSIC+ESPRIT+MVDR+MinNorm+Beamforming/beamforming.png)

#### 1.2 Min-Norm
![](MUSIC+ESPRIT+MVDR+MinNorm+Beamforming/Min-Norm.png)

#### 1.3 MUSIC
![](MUSIC+ESPRIT+MVDR+MinNorm+Beamforming/MUSIC.png)

#### 1.4 MVDR
![](MUSIC+ESPRIT+MVDR+MinNorm+Beamforming/MVDR.png)


### 2. Beamforming
#### 2.1 microphone array
![](Beamforming/array.png)

#### 2.2 Two-dimensional map of localization result
![](Beamforming/2d.png)

#### 2.3 Three-dimensional map of localization result
![](Beamforming/3d.png)


### 3. MUSIC
#### 3.1 matlab_implement2 (**BEST**)
![](MUSIC_implement2/result.png)

#### 3.3 matlab_implement1
![](MUSIC_implement1/music-1.png)
![](MUSIC_implement1/music-2.png)


## Reference Book
* [Microphone Array Beamforming](http://www.labbookpages.co.uk/audio/beamforming.html)

## Reference Website
* [Matlab files for various types of beamforming](https://github.com/jorgengrythe/beamforming)
* [空间谱专题02：波束形成（Beamforming）](https://www.cnblogs.com/xingshansi/p/7410846.html)
* [空间谱专题10：MUSIC算法](https://www.cnblogs.com/xingshansi/p/7553746.html)
* [MUSIC算法分析和实现](https://blog.csdn.net/zhuguorong11/article/details/70209070)
* [MUSIC算法](https://blog.csdn.net/Wilder_ting/article/details/79122885)
* [子空间分析方法](http://www.cnblogs.com/xingshansi/p/7554200.html)
* [Lijiawei16/beamforming](https://github.com/Lijiawei16/beamforming)
* [msamsami/doa-estimation-music](https://github.com/msamsami/doa-estimation-music)
* [rkakshay/ssl](https://github.com/rkakshay/ssl)
* [阵列信号基础之1：MUSIC算法](https://blog.csdn.net/qq_23947237/article/details/82318222)
* [BSS Locate - A toolbox for source localization in stereo convolutive audio mixtures](http://bass-db.gforge.inria.fr/bss_locate/)
