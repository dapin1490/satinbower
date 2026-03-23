---
title: "머신 비전 프로젝트 1 - 주제 구체화 및 테스트 코드 작성"
author: dapin1490
date: 2026-03-23 16:43:00 +09:00
categories: [HAE, 프로젝트 - 머신 비전]
tags: [현대오토에버, 모빌리티, 머신 비전, 이미지 처리, openCV, 딥러닝, 파이토치, keras]
render_with_liquid: false
use_math: true
---

> gemini 자료를 인용한 내용이 포함됨
{: .prompt-info }

> table of contents
{: .prompt-tip }

- [오늘 한 일](#오늘-한-일)
- [1. 프로젝트 요약](#1-프로젝트-요약)
- [2. 모델 설계 방향 (README·docs 기준)](#2-모델-설계-방향-readmedocs-기준)
  - [2.1 아키텍처: 전이학습 CNN](#21-아키텍처-전이학습-cnn)
  - [2.2 Stage 1 (폰트 분류기) 구현 포인트](#22-stage-1-폰트-분류기-구현-포인트)
  - [2.3 Stage 2 (필기자 식별) 구현 포인트](#23-stage-2-필기자-식별-구현-포인트)
- [3. 데이터셋 준비](#3-데이터셋-준비)
  - [3.1 Stage 1 (폰트 분류)](#31-stage-1-폰트-분류)
  - [3.2 Stage 2 (필기자)](#32-stage-2-필기자)
- [4. 학습 파이프라인 (구현 시 권장 순서)](#4-학습-파이프라인-구현-시-권장-순서)
- [5. 정리: "어떤 모델을 어떻게 만들면 좋은지"](#5-정리-어떤-모델을-어떻게-만들면-좋은지)
- [6. 빠르게 성능을 확인할 수 있는 모델 추천](#6-빠르게-성능을-확인할-수-있는-모델-추천)
  - [1. 추천: ResNet18 (전이학습)](#1-추천-resnet18-전이학습)
  - [2. 더 빠르게만 돌리고 싶을 때: MobileNetV2](#2-더-빠르게만-돌리고-싶을-때-mobilenetv2)
  - [3. 정리](#3-정리)
- [테스트 코드 왜 만드나요](#테스트-코드-왜-만드나요)
  - [1. 평가 코드가 모델 학습과 분리될 수 있는 이유](#1-평가-코드가-모델-학습과-분리될-수-있는-이유)
  - [2. 왜 모델보다 평가 코드를 먼저 만드는가?](#2-왜-모델보다-평가-코드를-먼저-만드는가)
  - [3. 모델 없이 평가 코드를 검증하는 방법: 가짜 모델(Mocking)](#3-모델-없이-평가-코드를-검증하는-방법-가짜-모델mocking)
  - [4. 성능 평가의 필수 구성 요소](#4-성능-평가의-필수-구성-요소)
  - [참고문헌](#참고문헌)

## 오늘 한 일

- 테스트 코드 만들기
- 테스트 데이터셋 만들기
- 위의 두 사항을 수행하면서 전체 데이터셋도 만들었다

## 1. 프로젝트 요약

- Stage 1: 단어 이미지 → 8종 나눔손글씨 폰트 분류
- Stage 2: Stage 1 백본 활용 → 5명 필기자 식별
- 현재: 설계·테스트 코드·`DummyHandwritingModel`·전처리·TRDG 데이터 생성 구조 및 생성된 데이터는 있음. 모델만 만들면 되는 상태.

---

## 2. 모델 설계 방향 (README·docs 기준)

### 2.1 아키텍처: 전이학습 CNN

- Stage 1: ImageNet 등으로 미리 학습된 CNN을 백본으로 쓰고, 마지막 분류기만 8클래스로 교체해 학습.
- Stage 2: Stage 1에서 쓴 백본 + 특징 추출부는 고정하고, 말단 분류기만 5클래스(필기자)로 바꿔서 학습.

권장 백본 후보 (RTX 4050, 224×224 기준):

- ResNet18 / ResNet34: 파라미터 적고 속도·성능 균형 좋음.
- EfficientNet-B0: 같은 해상도에서 성능을 더 끌어올리고 싶을 때.
- MobileNetV2: 더 가볍게 가고 싶을 때.

`make_model.md`·`how_to_test.md`에 맞추려면:

- 입력: `(B, 3, 224, 224)` (또는 1채널로 가면 `(B, 1, 224, 224)`로 통일).
- 출력: `(B, num_classes)` logits (softmax는 테스트 코드에서 처리).
- `forward(x)`만 제대로 두면 `evaluate_model`과 그대로 연동 가능.

### 2.2 Stage 1 (폰트 분류기) 구현 포인트

1. 백본`torchvision.models`에서 ResNet18 등 불러온 뒤:
    - 마지막 FC를 제거하고,
    - `nn.AdaptiveAvgPool2d(1)` + `nn.Linear(feature_dim, 8)` 형태의 새 분류기만 붙이기.
2. 입력 채널
    - 문서상 1채널(흑백) 허용.
    - 1채널로 갈 경우:
        - `preprocess.py`에서 Grayscale 후 `(1,224,224)`로 맞추고,
        - 백본 첫 Conv 입력을 1채널로 바꾸거나, 1→3 복제 후 기존 3채널 백본 사용.
3. 정규화
    - README: 픽셀을 [0, 1]로 정규화 권장.
    - 현재 `preprocess.py`는 ImageNet 평균/분산으로 정규화되어 있음.
    - 전이학습 백본을 그대로 쓰면 ImageNet 정규화 유지; 직접 정규화를 바꾸면 `preprocess.py`만 수정하면 됨.
4. 파일 위치
    - `model/` 아래 새 파일 (예: `font_classifier_resnet.py`)에 `nn.Module` 클래스 정의.
    - `test/run_test.py`에서는 `from model.font_classifier_resnet import FontClassifierResNet` 식으로 불러와서 `model = FontClassifierResNet(num_classes=8)`만 넣으면 기존 테스트 파이프라인 그대로 사용 가능.

### 2.3 Stage 2 (필기자 식별) 구현 포인트

1. Stage 1 가중치 로드
    - Stage 1 모델에서 백본 + (필요 시) 일부 상위 레이어까지 로드.
2. 고정/미세조정
    - README: "가중치와 특징 추출 레이어를 유지한 채 말단 분류기만 교체하여 학습" → 백본은 `requires_grad=False`, 새 분류기(5클래스)만 학습.
3. 데이터
    - 인당 200장 이상 학습, 50장 이상 테스트.
    - 10문장 × 10회 작성 → 단어 단위 크롭 후 224×224로 리사이즈.
    - 전처리는 동일하게 `preprocess.get_train_transform()` / `get_test_transform()` 사용 가능 (필요 시 augmentation만 `get_train_transform()`에 추가).

---

## 3. 데이터셋 준비

### 3.1 Stage 1 (폰트 분류)

- 경로 구조
    - 학습: `.../data/train/<폰트폴더명>/`
    - 테스트: `.../data/test/<폰트폴더명>/`
    - `run_test.py`는 현재 `_root/data/test`를 참조하므로, 테스트 이미지는 `머신 비전 프로젝트/data/test/` 아래에 8개 폰트별 폴더로 두면 됨.
- 생성
    - TRDG로 폰트별 단어 이미지 생성.
    - 클래스당 학습 5,000장 이상(글자 수별 1,000장 등으로 나누면 좋음), 테스트 125장 이상.
    - README: 가로세로비 유지용 상하 패딩 + 랜덤 패딩 후 224×224로 리사이즈.
- 폴더명
    - `how_to_test.md`의 8개 폰트명(예: `NanumSoMiCe`, `NanumSangHaeCanMiCe` 등)과 완전 동일하게 두면 `ImageFolder`와 `dummy.py`의 `classes` 순서가 맞음.

### 3.2 Stage 2 (필기자)

- 팀원 5명이 정해진 10문장을 각 10번씩 작성 → 스캔/촬영 후 단어 단위 크롭 → 224×224, 인당 200장 이상(train), 50장 이상(test).
- 배경: 종이 질감 추가 가능, 과도한 투시 변환은 피하는 것이 좋음.

---

## 4. 학습 파이프라인 (구현 시 권장 순서)

1. 데이터 로더
    - `torchvision.datasets.ImageFolder` + `model.preprocess.get_train_transform()` / `get_test_transform()`.
    - (선택) README의 "데이터 로딩 속도 향상"을 위해 TFRecord 도입 시, 변환 스크립트와 `Dataset` 클래스를 한 번 더 두면 됨.
2. Stage 1 학습 스크립트 (예: `train_font.py`)
    - 옵티마이저: Adam or AdamW.
    - 스케줄러: OneCycleLR 또는 StepLR.
    - 에폭: 10~30 구간에서 early stopping 또는 검증 손실 기준으로 조절.
    - `get_train_transform()`에 RandomCrop, RandomRotation, ColorJitter 등 데이터 증강 추가 권장.
3. Stage 2 학습 스크립트
    - Stage 1 체크포인트에서 백본 로드 → 분류기만 5클래스로 교체 → 백본 freeze → 분류기만 학습.

---

## 5. 정리: "어떤 모델을 어떻게 만들면 좋은지"

| 항목        | 내용                                                                                                                                                                                                                                       |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 모델        | 전이학습 CNN (ResNet18/34 또는 EfficientNet-B0 등) + 커스텀 분류기. Stage 1: 8클래스, Stage 2: 5클래스.                                                                                                                                    |
| 만드는 방법 | ① `model/` 아래 새 파일에 `nn.Module` 정의 (입력 (B,3,224,224) → 출력 (B,num_classes) logits). ② `preprocess.py` 전처리 사용. ③ Stage 1 학습 스크립트로 폰트 데이터 학습 → ④ Stage 2에서는 백본 고정 + 말단만 교체해 필기자 데이터로 학습. |
| 테스트      | 기존 그대로: `run_test.py`에서 새 모델만 import 해서 `evaluate_model(model, dataset_path)` 호출. 데이터는 `data/train`, `data/test`를 ImageFolder 구조로만 맞추면 됨.                                                                      |

지금 상태에서는 데이터셋만 README/가이드대로 준비하고, 위 순서대로 Stage 1용 전이학습 모델 한 개를 `model/`에 추가한 뒤 `run_test.py`에서 연결하면, 현재 설계와 테스트 코드를 그대로 활용할 수 있습니다.

---

## 6. 빠르게 성능을 확인할 수 있는 모델 추천

현재 사양(RTX 4050, 32GB RAM)과 "빠른 시간 안에 성능 확인" 목표에 맞춰 한 가지를 우선 추천하고, 대안을 짧게 정리합니다.

### 1. 추천: ResNet18 (전이학습)

이유

- 학습 속도: 파라미터 약 11M, 224×224 배치로 RTX 4050에서 에폭당 1~2분 수준으로 빠르게 돌아감.
- 구현/사용이 쉬움: `torchvision.models.resnet18(weights=...)` 한 줄 + 마지막 FC만 8클래스로 교체하면 됨.
- 전이학습에 적합: ImageNet 사전학습으로 초기 수렴이 빨라서, 데이터가 5k/클래스 수준이어도 비교적 빠르게 성능이 나옴.
- 인터페이스 맞추기 쉬움: 입력 (B, 3, 224, 224) → 출력 (B, 8) logits로 맞추기만 하면 기존 `evaluate_model`/`run_test.py`와 그대로 연동 가능.

구성 예시 (개념)

- 백본: `resnet18(weights=ResNet18_Weights.IMAGENET1K_V1)`
- `resnet.fc` 제거 후 → `nn.Linear(512, 8)` 로 교체
- 옵티마이저: Adam or AdamW, 배치 크기 32~64, 에폭 10~15만으로도 1차 성능 확인 가능.

이 조합이 "현재 사양 안에서, 빠른 시간 내에 성능을 확인"하기에 가장 무난한 선택입니다.

### 2. 더 빠르게만 돌리고 싶을 때: MobileNetV2

- ResNet18보다 더 가볍고 에폭당 시간이 짧음.
- 정확도는 보통 ResNet18보다 조금 낮을 수 있어, "일단 파이프라인/속도 확인"용으로 쓰고, 본격 실험은 ResNet18로 하는 식으로 두 번째 후보로 두면 좋습니다.

### 3. 정리

- 우선 추천: ResNet18 + ImageNet 전이학습 + 마지막 FC만 8클래스
→ 현재 사양에서 빠르게 학습·평가하고 성능을 확인하기에 가장 적합합니다.
- 더 가볍게: MobileNetV2 (속도 우선일 때).
- ResNet18으로 한 번 돌려본 뒤, 필요하면 EfficientNet-B0 등으로 바꿔서 정확도만 비교하는 흐름을 추천합니다.

---

## 테스트 코드 왜 만드나요

머신러닝 프로젝트에서 평가 코드(Evaluation Code)는 학습된 모델의 실력을 측정하는 '채점기'입니다. 이 채점기는 모델이 완성되기 전에도 설계와 구현이 가능하며, 오히려 먼저 만드는 것이 권장됩니다.

### 1. 평가 코드가 모델 학습과 분리될 수 있는 이유

평가 코드는 모델의 내부 구조(알고리즘)를 보지 않습니다. 오직 모델이 내놓는 결과값의 형태(데이터 타입, 차원)와 실제 정답(Ground Truth)만 있으면 작동하기 때문입니다.

- 인터페이스(Interface) 중심 설계: 모델이 '0 또는 1'을 출력하기로 약속되어 있다면, 실제 모델이 없어도 임의의 '0 또는 1'을 넣어 채점 로직이 맞는지 확인할 수 있습니다 [1].
- 블랙박스 테스트: 평가 코드는 모델을 하나의 상자로 취급하며, 상자 안에서 어떤 일이 일어나는지 상관없이 출력값만 가지고 점수를 매깁니다.

### 2. 왜 모델보다 평가 코드를 먼저 만드는가?

1. 기준의 고정: 학습 결과에 따라 평가 지표를 유리하게 바꾸는 주관적 개입을 방지하고, 객관적인 목표(Target Metric)를 설정합니다.
2. 시간 및 자원 절약: 수 시간이 걸리는 모델 학습이 끝난 후 평가 코드의 버그(예: 오타, 수식 오류)를 발견하면 그 시간은 낭비됩니다. 학습 전 미리 검증된 평가 코드는 이러한 리스크를 제거합니다 [2].
3. 데이터 누수(Data Leakage) 차단: 평가에 사용할 데이터셋을 미리 격리하고 건드리지 않도록 강제함으로써 모델이 정답을 미리 학습하는 오류를 막습니다.

### 3. 모델 없이 평가 코드를 검증하는 방법: 가짜 모델(Mocking)

학습된 모델이 없어도 다음 단계를 통해 평가 코드를 실행할 수 있습니다.

1. 가짜 출력 생성: 모델이 출력할 것으로 예상되는 형태의 난수(Random numbers)를 생성합니다.
2. 평가 함수 실행: 생성한 난수와 실제 정답 데이터를 평가 함수(예: Accuracy 함수)에 입력합니다.
3. 정상 작동 확인: 에러 없이 결과값이 나오는지, 지표의 범위(0~1 사이 등)가 논리적으로 타당한지 확인합니다.

### 4. 성능 평가의 필수 구성 요소

| 요소                | 역할                                          | 준비 시점                 |
| ------------------- | --------------------------------------------- | ------------------------- |
| 테스트 데이터셋     | 모델이 한 번도 보지 못한 정답지               | 프로젝트 시작 직후 (격리) |
| 평가 지표 (Metrics) | 모델의 실력을 측정할 기준 (F1-score, RMSE 등) | 모델 설계 단계            |
| 평가 실행 스크립트  | 데이터를 입력받아 지표를 산출하는 코드        | 모델 학습 시작 전         |

---

### 참고문헌

1. Google Developers. (n.d.). *Testing and Debugging in Machine Learning*. Retrieved from https://developers.google.com/machine-learning/crash-course/production-ml-systems?hl=ko
2. Amershi, S., et al. (2019). *Software Engineering for Machine Learning: A Case Study*. IEEE Software. https://doi.org/10.1109/ICSE-SEIP.2019.00042
3. Scikit-learn. (n.d.). *Model evaluation: quantifying the quality of predictions*. Retrieved from https://scikit-learn.org/stable/modules/model_evaluation.html