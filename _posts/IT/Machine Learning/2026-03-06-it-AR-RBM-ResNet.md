---
title: "AR, RBM, ResNet"
author: dapin1490
date: 2026-03-06 12:49:00 +09:00
categories: [IT, Machine Learning]
tags: [지식, IT, 머신러닝]
render_with_liquid: false
use_math: true
---

> Gemini가 정리해준 내용 기반으로 글만 좀 조립했음
{: .prompt-info }

<details markdown="1"><summary>table of contents</summary>

- [1. 자기회귀 신경망 (AutoRegressive Network, AR)](#1-자기회귀-신경망-autoregressive-network-ar)
  - [1.1 기술적 정의 및 메커니즘](#11-기술적-정의-및-메커니즘)
    - [더 쉬운 설명](#더-쉬운-설명)
  - [1.2 성능 향상의 근거: 문맥 종속성(Contextual Dependency)](#12-성능-향상의-근거-문맥-종속성contextual-dependency)
  - [1.3 주요 모델 사례](#13-주요-모델-사례)
  - [1.4 장점 및 한계](#14-장점-및-한계)
- [2. 제한된 볼츠만 머신 (Restricted Boltzmann Machine, RBM)](#2-제한된-볼츠만-머신-restricted-boltzmann-machine-rbm)
  - [2.1 구조적 특징 및 제약](#21-구조적-특징-및-제약)
  - [2.2 확률적 특성 (Stochastic vs. Deterministic)](#22-확률적-특성-stochastic-vs-deterministic)
    - [더 쉬운 설명](#더-쉬운-설명-1)
  - [2.3 학습 알고리즘: Contrastive Divergence (CD)](#23-학습-알고리즘-contrastive-divergence-cd)
  - [2.4 주요 용도](#24-주요-용도)
  - [2.5 RBM은 인코딩+디코딩 → 특징 학습 생성형 모델](#25-rbm은-인코딩디코딩--특징-학습-생성형-모델)
    - [2.5.1. 인코딩과 디코딩의 반복 (Gibbs Sampling)](#251-인코딩과-디코딩의-반복-gibbs-sampling)
    - [2.5.2. 생성형 모델로서의 특성](#252-생성형-모델로서의-특성)
    - [2.5.3. 오토인코더(Autoencoder)와의 차이점](#253-오토인코더autoencoder와의-차이점)
- [3. AR과 RBM 비교](#3-ar과-rbm-비교)
- [4. ResNet과 잔차 학습 (Residual Learning)](#4-resnet과-잔차-학습-residual-learning)
  - [4.1 오차(Error)와 잔차(Residual)의 통계적 구분](#41-오차error와-잔차residual의-통계적-구분)
  - [4.2 잔차 학습의 원리](#42-잔차-학습의-원리)
  - [4.3 잔차 학습이 왜 성능을 향상하는가?](#43-잔차-학습이-왜-성능을-향상하는가)
- [5. 이전의 정보를 재활용하는 모델들의 차이](#5-이전의-정보를-재활용하는-모델들의-차이)
  - [5.1. 자기회귀 신경망 (AR): 문맥적 일관성 확보](#51-자기회귀-신경망-ar-문맥적-일관성-확보)
  - [5.2. RNN (Recurrent Neural Networks): 가변 길이 데이터의 상태 보존](#52-rnn-recurrent-neural-networks-가변-길이-데이터의-상태-보존)
  - [5.3. ResNet (Residual Networks): 최적화 경로의 단축](#53-resnet-residual-networks-최적화-경로의-단축)
  - [5.4 요약 비교](#54-요약-비교)
- [5. Keras 기반 구현 방법론](#5-keras-기반-구현-방법론)
  - [5.1 API 비교 및 선택 기준](#51-api-비교-및-선택-기준)
  - [5.2 ResNet 구현 핵심 코드 로직](#52-resnet-구현-핵심-코드-로직)
- [6. 결론](#6-결론)
- [참고문헌](#참고문헌)

</details>

## 1. 자기회귀 신경망 (AutoRegressive Network, AR)

자기회귀 신경망(AutoRegressive Network)은 통계학의 자기회귀(AutoRegressive, AR) 모델 개념을 인공신경망에 적용한 구조입니다. 핵심 원리는 과거의 자신의 데이터를 입력으로 사용하여 미래의 값을 예측하는 것입니다.

### 1.1 기술적 정의 및 메커니즘

자기회귀 네트워크는 결합 확률 분포(Joint Probability Distribution, 전체 확률 분포 $P(x)$)를 개별 요소들의 조건부 확률의 곱으로 분해하여 모델링합니다. $n$개의 변수 시퀀스에 대하여 다음과 같은 수식으로 표현됩니다 \[1].

$$P(x_1, x_2, \dots, x_n) = \prod_{i=1}^{n} P(x_i | x_1, \dots, x_{i-1})$$

이 구조에서 각 출력 $x_i$는 해당 시점 이전의 모든 관측값 $x_1, \dots, x_{i-1}$에 의존합니다. 시계열 데이터나 텍스트와 같이 순서가 있는 데이터를 처리하는 데 최적화되어 있습니다 \[1]. 일반적으로 정보의 흐름이 한 방향(과거에서 미래)으로만 진행되는 단방향성(Unidirectionality)을 갖습니다.

#### 더 쉬운 설명

코드 구현 관점에서 AR 모델은 재귀적인 데이터 생성 루프와 같습니다.

- 핵심 로직: $t$ 번째 값을 예측하기 위해 $t-1, t-2, \dots$ 시점의 데이터를 함수의 인자로 넣습니다.
- 코드 구조: `predict(x[0:t])`의 결과값이 다시 다음 루프의 입력인 `x[t+1]`이 되는 구조입니다 \[1].
- Transformer의 예: GPT 같은 모델이 텍스트를 생성할 때, 이전에 생성한 단어들을 다시 입력창(Context Window)에 밀어 넣어 다음 단어를 뽑아내는 과정이 전형적인 자기회귀 방식입니다 \[9].

### 1.2 성능 향상의 근거: 문맥 종속성(Contextual Dependency)

- 데이터 일관성: 독립적인 예측 모델과 달리, AR 구조는 이전 단계의 출력을 다음 단계의 입력 피처로 직접 사용하여 데이터 간의 복잡한 상관관계를 학습합니다 \[2].
- 활용 사례: GPT(Generative Pre-trained Transformer)와 같은 대규모 언어 모델은 이 원리를 사용하여 문맥적으로 자연스러운 문장을 생성합니다. 이는 코딩 관점에서 출력값이 다음 반복문의 입력값으로 할당되는 재귀적 구조를 가집니다.

### 1.3 주요 모델 사례

- RNN (Recurrent Neural Networks): 은닉 상태(Hidden State)를 통해 과거 정보를 전달하며 순차적으로 데이터를 처리합니다 \[1].
- PixelCNN / WaveNet: 이미지의 픽셀이나 오디오의 샘플을 하나씩 순차적으로 생성하는 자기회귀 모델입니다 \[8].
- Transformer (Decoder-only): GPT(Generative Pre-trained Transformer) 시리즈가 대표적이며, 이전 토큰들을 기반으로 다음 토큰을 예측하는 자기회귀 방식으로 텍스트를 생성합니다 \[9].

### 1.4 장점 및 한계

- 장점: 데이터 간의 복잡한 상관관계를 정밀하게 학습할 수 있으며, 고품질의 생성 결과를 도출합니다.
- 한계: 데이터를 하나씩 순차적으로 생성해야 하므로 병렬 처리가 어렵고 계산 시간이 오래 걸리는 추론 병목 현상이 발생합니다 \[2].

## 2. 제한된 볼츠만 머신 (Restricted Boltzmann Machine, RBM)

제한된 볼츠만 머신(RBM)은 입력 데이터의 확률 분포를 학습하는 에너지 기반의 생성적 확률 신경망입니다. '제한된'이라는 명칭은 동일 층 내 유닛 간의 연결을 허용하지 않는 구조적 제약에서 유래합니다 \[3]. 가시층(Visible Layer)과 은닉층(Hidden Layer) 사이의 관계를 확률적으로 모델링하는 방식입니다.

### 2.1 구조적 특징 및 제약

- 이분 그래프(Bipartite Graph): 유닛들이 가시층과 은닉층이라는 두 그룹으로 나뉘며, 동일 층 내의 유닛 간에는 연결이 존재하지 않습니다 \[3]. 이 제약 조건은 층간 연산을 행렬 곱셈으로 단순화하여 계산 효율성을 극대화합니다.
- 비지도 학습: 레이블이 없는 데이터로부터 특징(Feature)을 추출하거나 차원을 축소하는 데 사용됩니다.
- 에너지 기반 모델: 시스템의 상태를 에너지 함수 $E(v, h)$로 정의하고, 이 에너지를 최소화하는 방향으로 학습합니다. 가시 벡터 $v$와 은닉 벡터 $h$에 대한 에너지 함수는 다음과 같습니다 \[4].

$$E(v, h) = -\sum_{i} a_i v_i - \sum_{j} b_j h_j - \sum_{i,j} v_i w_{ij} h_j$$

$a_i, b_j$는 바이어스, $w_{ij}$는 가중치

### 2.2 확률적 특성 (Stochastic vs. Deterministic)

RBM은 결정론적인 오토인코더(Autoencoder)와 달리 확률론적으로 동작합니다.

- 샘플링(Sampling): 유닛의 활성화 상태(0 또는 1)는 조건부 확률 $P(h \mid v)$ 또는 $P(v \mid h)$에 의해 결정되며, 깁스 샘플링(Gibbs Sampling)을 통해 상태를 업데이트합니다.
- 생성 모델: 학습된 확률 분포 내에서 샘플링을 수행하므로, 동일한 입력을 주어도 매번 미세하게 다른 복원(Reconstruction) 결과를 도출할 수 있습니다 \[4].

#### 더 쉬운 설명

RBM은 입력 데이터($v$)가 들어왔을 때 이를 가장 잘 설명하는 핵심 특징($h$)을 찾아내고, 다시 그 특징으로부터 원래 데이터를 복원해보며 학습합니다.

- 구조적 제약(Restricted): 같은 층끼리는 통신하지 않습니다. 이는 계산을 단순화하여 행렬 연산(Matrix Multiplication) 한 번으로 층 간 이동을 가능하게 합니다 \[3].
- 에너지 기반 학습: 데이터가 모델의 '기준'에 부합할수록 낮은 에너지 값을 갖도록 가중치($W$)를 조정합니다.
- Contrastive Divergence (CD):
    1. 입력 $v$를 보고 특징 $h$를 추출합니다 (Forward).
    2. 특징 $h$를 보고 다시 입력 $v'$를 복원합니다 (Reconstruction).
    3. 원래의 $v$와 복원된 $v'$의 차이를 줄이는 방향으로 $W$를 업데이트합니다 \[4].

### 2.3 학습 알고리즘: Contrastive Divergence (CD)

RBM은 일반적인 역전파(Backpropagation) 대신 깁스 샘플링(Gibbs Sampling)을 기반으로 하는 Contrastive Divergence (CD) 알고리즘을 사용하여 가중치를 업데이트합니다. 이는 계산 복잡도를 획기적으로 낮추어 실용적인 학습을 가능하게 했습니다 \[4].

### 2.4 주요 용도

- 심층 신뢰 신경망(DBN)의 구축 블록: 여러 개의 RBM을 쌓아 올려 DBN을 형성하며, 이는 딥러닝 초기 단계에서 가중치 사전 훈련(Pre-training)에 핵심적인 역할을 수행했습니다 \[10].
- 추천 시스템: 넷플릭스 프라이즈(Netflix Prize)에서 협업 필터링 성능을 높이는 데 기여한 바 있습니다.
- 특징 추출 및 차원 축소: 데이터의 복잡한 비선형 구조를 하위 차원으로 투영합니다.

### 2.5 RBM은 인코딩+디코딩 → 특징 학습 생성형 모델

제한된 볼츠만 머신(RBM)은 입력 데이터를 은닉층으로 투영(Encoding)하고, 다시 은닉층에서 입력층으로 복원(Decoding)하는 과정을 통해 데이터의 잠재적 특징을 학습하는 생성형 확률 모델입니다 \[4].

구체적인 메커니즘은 다음과 같은 핵심 요소로 요약됩니다.

#### 2.5.1. 인코딩과 디코딩의 반복 (Gibbs Sampling)

RBM은 별도의 인코더나 디코더 네트워크를 두지 않고, 동일한 가중치 행렬 $W$를 전치(Transpose)하여 양방향으로 사용합니다.

- 인코딩 (Forward Pass): 입력 데이터 $v$가 주어졌을 때 은닉 유닛 $h$가 활성화될 확률 $P(h \mid v)$을 계산합니다. 이는 데이터의 압축된 특징을 추출하는 과정입니다 \[11].
- 디코딩 (Reconstruction Step): 추출된 특징 $h$를 바탕으로 다시 입력 데이터 $v'$가 생성될 확률 $P(v \mid h)$을 계산합니다. 이 과정이 '생성'에 해당합니다.

#### 2.5.2. 생성형 모델로서의 특성

RBM은 단순한 분류기가 아니라, 데이터의 결합 확률 분포 $P(v, h)$를 학습합니다. 학습이 완료된 RBM은 다음과 같은 생성적 작업을 수행할 수 있습니다.

- 데이터 복원: 손상되거나 누락된 입력 데이터가 들어왔을 때, 학습된 특징을 바탕으로 원래의 데이터를 추론하여 메웁니다 \[12].
- 새로운 샘플 생성: 은닉층에 임의의 값을 입력하고 디코딩 과정을 거치면, 학습한 데이터셋의 통계적 특성을 따르는 새로운 샘플을 생성할 수 있습니다.

#### 2.5.3. 오토인코더(Autoencoder)와의 차이점

개발자 관점에서 오토인코더와 유사해 보일 수 있으나, 결정적인 차이가 있습니다.

- 오토인코더: 결정론적(Deterministic) 모델입니다. 특정 입력에 대해 항상 고정된 출력을 내놓으며, 주로 역전파(Backpropagation)를 통해 학습합니다. 모델의 가중치가 고정되어 있다면, 동일한 입력에 대해 수학적으로 항상 동일한 결과값이 산출됩니다.
- RBM: 확률론적(Stochastic) 모델입니다. 유닛의 상태가 확률에 따라 0 또는 1로 결정되며, 에너지 함수를 최소화하는 방향으로 확률 분포를 근사합니다 \[4]\[1]. 동일한 데이터를 입력하더라도 샘플링 과정에서 발생하는 우연성 때문에 매번 미세하게 다른 결과가 출력될 수 있습니다.
    - RBM의 목적은 데이터가 존재하는 확률 공간(Probability Space) 자체를 학습하는 것입니다. 데이터의 분포를 학습했으므로, 학습된 분포 안에서 "일어날 법한" 다양한 형태를 생성해낼 수 있는 능력을 갖추게 됩니다.
    - 이러한 특성 덕분에 RBM은 노이즈 제거(Denoising)나 데이터 생성과 같은 확률적 추론이 필요한 작업에 더 강점을 보입니다.

## 3. AR과 RBM 비교

| 구분        | 자기회귀 신경망 (AR)             | 제한된 볼츠만 머신 (RBM)                |
| ----------- | -------------------------------- | --------------------------------------- |
| 주 목적     | 다음 순서의 값 예측 (Generation) | 데이터의 특징 추출 (Feature Extraction) |
| 데이터 흐름 | 과거 → 미래 (순차적)             | 가시층 ↔ 은닉층 (양방향/대칭)           |
| 주요 활용   | 언어 모델 (GPT), 시계열 예측     | 사전 학습 (Pre-training), 추천 시스템   |

## 4. ResNet과 잔차 학습 (Residual Learning)

ResNet은 층이 깊어짐에 따라 발생하는 최적화 난제를 지름길(Skip Connection)을 통해 해결한 모델.

### 4.1 오차(Error)와 잔차(Residual)의 통계적 구분

모델의 성능을 논할 때 두 용어는 엄격히 구분됩니다 \[5].

- 오차(Error): 모집단의 실제 회귀선과 관측값 사이의 차이. 이론적인 값 ($\epsilon$).
    - 오차는 모집단(Population)의 실제 회귀식과 관측값 사이의 차이입니다.
    - 기준 우리가 현실적으로 알 수 없는 '진리' 혹은 '이론적 모델'을 기준으로 합니다.
    - 성격: 모집단 전체를 대상으로 하며, 수식으로는 보통 $\epsilon$ (epsilon)으로 표기합니다.
    - 특징: 모집단의 모든 데이터를 알 수 없으므로, 현실에서는 오차의 정확한 값을 계산하는 것이 불가능합니다 \[14].
- 잔차(Residual): 표본 데이터를 통해 추정한 모델의 예측값과 실제값 사이의 차이 ($e = y - \hat{y}$). 딥러닝에서 최적화하는 대상은 실제로는 모두 잔차입니다.
    - 기준: 표본 데이터를 학습시켜 얻은 '예측 모델'을 기준으로 합니다.
    - 성격: 우리가 수집한 데이터를 바탕으로 직접 계산해낼 수 있는 실제 값입니다.
    - 특징: 딥러닝이나 머신러닝에서 손실 함수(Loss Function)를 계산할 때 사용하는 값이 바로 이 잔차입니다 \[5]\[15].
- 통상적으로 모델 개발 과정에서 계산하는 'loss'는 엄밀히 말하면 잔차입니다.

### 4.2 잔차 학습의 원리

ResNet은 출력 $H(x)$를 직접 학습하는 대신, 입력 $x$와 출력 사이의 차이인 $F(x) = H(x) - x$를 학습합니다.

- 식: $H(x) = F(x) + x$
- 이점: 층이 깊어져도 입력 정보 $x$가 그대로 전달되므로, 모델은 '새로 배워야 할 정보'인 잔차에만 집중할 수 있습니다. 또한 역전파 시 기울기(Gradient)가 가중치 연산을 거치지 않고 직접 입력층 쪽으로 흐를 수 있는 경로를 확보하여 기울기 소실 문제를 방지합니다 \[6].

### 4.3 잔차 학습이 왜 성능을 향상하는가?

- 학습의 난이도 하락: 아무것도 학습하지 않아도 되는 최악의 상황에서 모델은 $F(x)=0$으로만 만들면 됩니다. 이는 $H(x)=x$라는 항등 함수를 학습하는 것보다 훨씬 쉽습니다. 즉, 이전 층의 정보를 그대로 보존하기가 매우 유리해집니다 \[13].
- 기울기 전파의 최적화: 역전파 시 기울기가 $F(x)$를 거치지 않고도 $+x$라는 경로를 통해 입력층까지 직접 전달됩니다. 이는 깊은 망에서도 정보 손실 없이 학습이 가능하게 만듭니다 \[6]\[1].

## 5. 이전의 정보를 재활용하는 모델들의 차이

### 5.1. 자기회귀 신경망 (AR): 문맥적 일관성 확보

자기회귀 모델이 자신의 출력을 다시 입력으로 사용하는 이유는 데이터 간의 종속성(Dependency)을 모델링하기 위함입니다.

- 원리: $t$ 시점의 데이터를 생성할 때 $t-1$까지의 모든 정보를 참조함으로써, 전체 시퀀스의 확률 분포를 정확히 근사합니다 \[1].
- 성능 향상 이유: 단순히 독립적으로 데이터를 생성하는 모델과 달리, 앞뒤 문맥이 이어지는 일관성 있는 결과물을 만들 수 있습니다. 예를 들어, 문장 생성 시 앞 단어와 호응하는 적절한 다음 단어를 선택할 수 있게 됩니다 \[2].

### 5.2. RNN (Recurrent Neural Networks): 가변 길이 데이터의 상태 보존

RNN은 '은닉 상태(Hidden State)'라는 메모리 시스템을 통해 과거 정보를 현재로 전달합니다.

- 이전 모델과의 차이: 고정된 크기의 입력만 처리할 수 있었던 DNN(Deep Neural Network)과 달리, RNN은 입력의 길이에 상관없이 데이터를 처리할 수 있습니다.
- 성능 향상 이유: 시계열 데이터나 문장처럼 순서가 중요한 정보의 '맥락' 은닉 상태에 압축하여 전달함으로써, 현재 시점의 판단에 과거의 경험을 반영합니다 \[1].

### 5.3. ResNet (Residual Networks): 최적화 경로의 단축

ResNet의 핵심인 '잔차 연결(Skip Connection)'은 이전 층의 출력을 다음 층의 입력에 직접 더하는 방식입니다. 이는 앞선 모델들과 목적이 다릅니다.

- 이전 모델과의 차이: 층이 깊어질수록 기울기 소실(Vanishing Gradient) 문제로 학습이 되지 않던 기존의 Sequential 모델 한계를 극복했습니다 \[6].
- 성능 향상 이유:
    1. 지름길 제공: 입력 $x$를 출력에 직접 전달함으로써, 신경망이 학습해야 할 대상을 '전체'가 아닌 '입력과 출력의 차이(잔차)'로 한정하여 학습 난이도를 낮춥니다.
    2. 기울기 전파: 역전파 시 기울기가 소실되지 않고 입력층까지 원활하게 전달되어 매우 깊은 신경망(100층 이상)도 안정적으로 학습이 가능해졌습니다 \[6]\[13].

### 5.4 요약 비교

| 모델   | 재사용하는 대상  | 핵심 목적   | 성능 향상의 근거                               |
| ------ | ---------------- | ----------- | ---------------------------------------------- |
| AR     | 과거의 출력값    | 문맥 유지   | 데이터 간의 조건부 확률 관계를 학습함          |
| RNN    | 과거의 은닉 상태 | 순서 보존   | 가변적인 길이의 시퀀스 데이터를 처리함         |
| ResNet | 이전 층의 입력값 | 학습 안정화 | 깊은 층에서도 기울기 소실 없이 최적화가 가능함 |

## 5. Keras 기반 구현 방법론

딥러닝 프레임워크인 Keras에서 위 구조들을 구현할 때는 모델의 그래프 위상(Topology)에 맞는 API를 선택해야 합니다.

### 5.1 API 비교 및 선택 기준

1. Sequential API: 레이어를 단순히 순서대로 쌓는 구조. 분기나 합치기(Merge) 연산이 불가능하므로 ResNet 구현에는 부적합합니다.
2. Functional API: 레이어를 함수처럼 호출하여 변수에 할당합니다. `layers.Add()`를 통해 서로 다른 시점의 텐서를 합칠 수 있어 ResNet 구현에 필수적입니다 \[7].
3. Model Subclassing: `tf.keras.Model` 클래스를 상속받아 직접 `call()` 메서드를 정의합니다. 가장 높은 자유도를 가지며 복잡한 동적 연산을 처리할 때 사용합니다.

### 5.2 ResNet 구현 핵심 코드 로직

ResNet의 핵심은 초기 입력값을 변수에 저장했다가, 컨볼루션 연산이 끝난 후 다시 더해주는 것.

```python
x = layers.Conv2D(64, (3, 3), padding='same')(inputs)
shortcut = x  # 초기 입력값 보존
x = layers.Conv2D(64, (3, 3), padding='same')(x)
x = layers.Add()([x, shortcut])  # 잔차 연결 (F(x) + x)
```

## 6. 결론

자기회귀 신경망은 시퀀스의 선후 관계를, RBM은 데이터의 확률적 분포를, ResNet은 신호의 안정적 전파를 목적으로 설계되었습니다. 개발자 관점에서 이러한 모델들은 모두 '이전 단계의 유효한 정보'를 어떻게 현재의 연산에 효율적으로 결합할 것인가에 대한 서로 다른 해법을 제시하고 있습니다.

## 참고문헌

\[1] Goodfellow, I., Bengio, Y., & Courville, A. (2016). *Deep Learning*. MIT Press. [https://www.deeplearningbook.org](https://www.deeplearningbook.org)

\[2] Graves, A. (2013). Generating Sequences With Recurrent Neural Networks. *arXiv preprint arXiv:1308.0850*. [https://arxiv.org/abs/1308.0850](https://arxiv.org/abs/1308.0850)

\[3] Fischer, A., & Igel, C. (2012). An Introduction to Restricted Boltzmann Machines. *CIARP*, 14-36. [https://link.springer.com/chapter/10.1007/978-3-642-33275-3_2](https://link.springer.com/chapter/10.1007/978-3-642-33275-3_2)

\[4] Hinton, G. E. (2012). A Practical Guide to Training Restricted Boltzmann Machines. *Neural Networks: Tricks of the Trade*, 447-481. [https://link.springer.com/chapter/10.1007/978-3-642-35289-8_32](https://link.springer.com/chapter/10.1007/978-3-642-35289-8_32)

\[5] Weisberg, S. (2005). *Applied Linear Regression*. Wiley-Interscience. [https://onlinelibrary.wiley.com/doi/book/10.1002/0471704091](https://onlinelibrary.wiley.com/doi/book/10.1002/0471704091)

\[6] He, K., Zhang, X., Ren, S., & Sun, J. (2016). Deep Residual Learning for Image Recognition. *CVPR*, 770-778. [https://arxiv.org/abs/1512.03385](https://arxiv.org/abs/1512.03385)

\[7] TensorFlow Documentation. (2024). *The Keras Functional API*. [https://www.tensorflow.org/guide/keras/functional](https://www.tensorflow.org/guide/keras/functional)

\[8] van den Oord, A., Dieleman, S., Zen, H., Simonyan, K., Vinyals, O., Graves, A., Kalchbrenner, N., Senior, A., & Kavukcuoglu, K. (2016). WaveNet: A Generative Model for Raw Audio. _arXiv preprint arXiv:1609.03499_. [https://arxiv.org/abs/1609.03499](https://arxiv.org/abs/1609.03499)

\[9] Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention is All You Need. _Advances in Neural Information Processing Systems_, 30. [https://arxiv.org/abs/1706.03762](https://arxiv.org/abs/1706.03762)

\[10] Hinton, G. E., Osindero, S., & Teh, Y. W. (2006). A Fast Learning Algorithm for Deep Belief Nets. _Neural Computation_, 18(7), 1527-1554. [https://doi.org/10.1162/neco.2006.18.7.1527](https://doi.org/10.1162/neco.2006.18.7.1527)

\[11] Fischer, A., & Igel, C. (2014). Training restricted Boltzmann machines: An introduction. _Pattern Recognition_, 47(1), 25-39. [https://doi.org/10.1016/j.patcog.2013.05.025](https://doi.org/10.1016/j.patcog.2013.05.025)

\[12] Salakhutdinov, R., Mnih, A., & Hinton, G. (2007). Restricted Boltzmann machines for collaborative filtering. _Proceedings of the 24th international conference on Machine learning_, 791-798. [https://dl.acm.org/doi/10.1145/1273496.1273596](https://dl.acm.org/doi/10.1145/1273496.1273596)

\[13] Veit, A., Wilber, M. J., & Belongie, S. (2016). Residual Networks Behave Like Ensembles of Relatively Shallow Networks. _Advances in Neural Information Processing Systems_, 29. [https://arxiv.org/abs/1605.06431](https://arxiv.org/abs/1605.06431)

\[14] Montgomery, D. C., Peck, E. A., & Vining, G. G. (2012). _Introduction to Linear Regression Analysis_. John Wiley & Sons.

\[15] Cook, R. D., & Weisberg, S. (1982). _Residuals and Influence in Regression_. Chapman and Hall. [https://conservancy.umn.edu/handle/11299/37076](https://conservancy.umn.edu/handle/11299/37076)