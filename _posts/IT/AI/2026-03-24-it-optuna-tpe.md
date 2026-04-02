---
title: "Optuna와 TPE, 메타-하이퍼파라미터"
author: dapin1490
date: 2026-03-24 09:46:00 +09:00
categories: [IT, AI]
tags: [지식, IT, 머신러닝, Optuna, TPE, 메타-하이퍼파라미터]
render_with_liquid: false
use_math: true
---

> 머신 비전 프로젝트 2 할 때 gemini한테 얻어낸 자료임. 그 프로젝트: <https://dapin1490.github.io/satinbower/posts/HAE-mvision-prj-6/>

> Gemini가 정리해준 내용 기반으로 글만 좀 조립했음
{: .prompt-info }

<details markdown="1"><summary>table of contents</summary>

- [Optuna 및 TPE의 정의와 원리](#optuna-및-tpe의-정의와-원리)
  - [1. Optuna의 주요 특징](#1-optuna의-주요-특징)
  - [2. TPE(Tree-structured Parzen Estimator)의 원리](#2-tpetree-structured-parzen-estimator의-원리)
  - [작동 메커니즘](#작동-메커니즘)
  - [3. 하이퍼파라미터 최적화에서의 역할](#3-하이퍼파라미터-최적화에서의-역할)
- [메타-하이퍼파라미터 관리의 원리](#메타-하이퍼파라미터-관리의-원리)
  - [1. 견고한 기본값(Robust Default Values)의 제공](#1-견고한-기본값robust-default-values의-제공)
  - [2. 하이퍼-하이퍼파라미터 최적화의 비효율성](#2-하이퍼-하이퍼파라미터-최적화의-비효율성)
  - [3. 작업자의 노하우가 개입되는 지점](#3-작업자의-노하우가-개입되는-지점)
- [요약](#요약)
- [참고문헌](#참고문헌)

</details>

## Optuna 및 TPE의 정의와 원리

Optuna는 하이퍼파라미터 최적화(Hyperparameter Optimization, HPO)를 자동화하기 위해 설계된 오픈 소스 소프트웨어 프레임워크입니다 [1]. TPE(Tree-structured Parzen Estimator)는 Optuna에서 최적의 하이퍼파라미터를 탐색할 때 사용하는 기본 알고리즘(Sampler) 중 하나로, 베이지안 최적화(Bayesian Optimization) 기법에 기반합니다 [2].

### 1. Optuna의 주요 특징

Optuna는 기존의 HPO 도구들과 차별화되는 다음과 같은 핵심 기능을 제공합니다 [1].

- Define-by-Run API: 사용자가 하이퍼파라미터의 탐색 범위를 코드 실행 시점에 동적으로 정의할 수 있게 합니다. 이는 복잡한 조건부 파라미터 구성을 용이하게 합니다.
- 효율적인 가지치기(Pruning): 학습 초기 단계에서 성과가 좋지 않은 시도(Trial)를 감지하여 즉시 중단시킴으로써 계산 자원을 절약합니다.
- 다양한 샘플링 전략: TPE 외에도 CMA-ES, 그리드 서치(Grid Search), 랜덤 서치(Random Search) 등 여러 알고리즘을 지원합니다.

### 2. TPE(Tree-structured Parzen Estimator)의 원리

TPE는 목적 함수(Objective Function)를 모델링하여 다음에 탐색할 유망한 하이퍼파라미터 조합을 결정하는 알고리즘입니다. 일반적인 베이지안 최적화가 가우시안 과정(Gaussian Process)을 사용하는 것과 달리, TPE는 커널 밀도 추정(Kernel Density Estimation, KDE)을 기반으로 합니다 [2].

### 작동 메커니즘

TPE는 이전의 탐색 결과들을 성능에 따라 두 개의 그룹으로 분리합니다.

1. 임계값 설정: 관측된 결과 중 상위 일정한 비율(예: 상위 20%)을 '우수한(Good)' 그룹으로, 나머지를 '나쁜(Bad)' 그룹으로 나눕니다.
2. 확률 밀도 모델링: 각 그룹의 하이퍼파라미터 분포를 별도의 확률 밀도 함수로 모델링합니다.
    - $l(x)$: 우수한 그룹의 파라미터 분포 밀도
    - $g(x)$: 나쁜 그룹의 파라미터 분포 밀도
3. 최적 파라미터 선택: TPE는 기대 개선량(Expected Improvement, EI)이 최대가 되는 지점을 찾습니다. 이는 수학적으로 다음의 비율을 최대화하는 것과 같습니다 [2].

    $$EI(x) = \frac{l(x)}{g(x)}$$

    즉, '나쁜' 그룹에 속할 확률은 낮으면서 '우수한' 그룹에 속할 확률이 가장 높은 파라미터 $x$를 다음 탐색 대상으로 선정합니다.


### 3. 하이퍼파라미터 최적화에서의 역할

룰베이스(Rule-based) AI의 경우, 규칙의 임계값(Threshold), 가중치, 또는 규칙 적용 우선순위 등이 하이퍼파라미터가 될 수 있습니다. TPE는 이러한 파라미터 공간을 무작위로 탐색하는 대신, 과거의 시도 결과를 바탕으로 성능을 개선할 가능성이 높은 영역을 집중적으로 탐색함으로써 최적의 규칙 조합을 더 빠르게 찾아냅니다 [1][2].

---

## 메타-하이퍼파라미터 관리의 원리

이 단락은 하이퍼파라미터 최적화(HPO) 도구 자체의 설정값인 메타-하이퍼파라미터(Meta-hyperparameters)에 관한 것입니다. 결론부터 제시하면, Optuna와 TPE 알고리즘 역시 내부 설정값이 존재하나, 대부분의 경우 작업자가 이를 추가로 최적화할 필요가 없도록 설계되어 있습니다.

### 1. 견고한 기본값(Robust Default Values)의 제공

TPE 알고리즘에는 우수한 그룹과 나쁜 그룹을 나누는 비율($\gamma$), 커널 밀도 추정에 사용되는 대역폭(Bandwidth) 등 내부 파라미터가 존재합니다. 그러나 Bergstra et al. (2011)의 연구에 따르면, TPE는 다양한 벤치마크 데이터셋에서 동일한 기본 설정값으로도 충분히 우수한 성능을 보임이 입증되었습니다 [2]. 따라서 일반적인 상황에서 작업자는 이 수치들을 수정하지 않습니다.

### 2. 하이퍼-하이퍼파라미터 최적화의 비효율성

이론적으로는 최적화 도구의 설정값을 또다시 최적화하는 '메타-최적화'가 가능합니다. 그러나 이는 다음과 같은 이유로 실무에서 거의 수행되지 않습니다 [3].

- 수익 체감의 법칙: 모델의 하이퍼파라미터를 최적화하여 얻는 성능 향상폭에 비해, 최적화 알고리즘 자체를 튜닝하여 얻는 추가 이득은 매우 미미합니다.
- 계산 비용 극대화: 최적화 도구를 튜닝하기 위해서는 수많은 최적화 과정을 반복해야 하므로, 투입되는 시간과 자원 대비 효율이 급격히 떨어집니다.

### 3. 작업자의 노하우가 개입되는 지점

작업자는 알고리즘의 내부 수치를 조정하는 대신, 다음과 같은 탐색 전략 정의에 집중합니다 [1].

- 탐색 범위(Search Space) 설정: 하이퍼파라미터의 범위를 너무 넓거나 좁지 않게 설정하는 것.
- 목적 함수(Objective Function) 설계: AI의 성능을 무엇으로 측정할지(예: 정확도, 실행 시간, 규칙의 간결성 등) 정의하는 것.
- 시도 횟수(Number of Trials) 결정: 시간 자원을 고려하여 몇 번의 실험을 수행할지 결정하는 것.

---

## 요약

Optuna와 TPE는 내부 파라미터가 결과에 미치는 민감도를 낮추도록 설계되었습니다. 작업자는 알고리즘 내부를 튜닝하는 '노하우'보다는, 최적화하려는 대상(규칙)의 탐색 범위를 적절히 설정하는 도메인 지식에 집중하게 됩니다.

---

## 참고문헌

1. Akiba, T., Sano, S., Yanase, T., Ohta, T., & Koyama, M. (2019). Optuna: A next-generation hyperparameter optimization framework. In *Proceedings of the 25th ACM SIGKDD international conference on knowledge discovery & data mining* (pp. 2623-2631). <https://doi.org/10.1145/3292500.3330701>
2. Bergstra, J., Bardenet, R., Bengio, Y., & Kégl, B. (2011). Algorithms for hyper-parameter optimization. *Advances in neural information processing systems*, 24. <https://papers.nips.cc/paper_files/paper/2011/hash/86e8f7ab32cfd12577bc2619bc635690-Abstract.html>
3. Hutter, F., Kotthoff, L., & Vanschoren, J. (Eds.). (2019). *Automated machine learning: methods, systems, challenges*. Springer Nature. <https://link.springer.com/book/10.1007/978-3-030-05318-5>