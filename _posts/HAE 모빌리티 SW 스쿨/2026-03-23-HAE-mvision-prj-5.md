---
title: "머신 비전 프로젝트 2 - 기획"
author: dapin1490
date: 2026-03-23 18:11:00 +09:00
categories: [HAE, 프로젝트 - 머신 비전]
tags: [현대오토에버, 모빌리티, 머신 비전, 이미지 처리, openCV, 딥러닝, 파이토치, keras]
render_with_liquid: false
use_math: true
---

> table of contents
{: .prompt-tip }

- [조별 아이디어 선정](#조별-아이디어-선정)
  - [5조](#5조)
  - [6조](#6조)
  - [4조](#4조)
  - [2조](#2조)
  - [3조](#3조)
- [1조 아이디어 개요](#1조-아이디어-개요)
- [제조 도메인에서의 머신 비전 아이디어 탐색](#제조-도메인에서의-머신-비전-아이디어-탐색)
  - [문제 도메인별 분류](#문제-도메인별-분류)
    - [1. 표면 결함 탐지 (Surface Defect Detection)](#1-표면-결함-탐지-surface-defect-detection)
    - [2. 전자 부품 및 조립 검사 (Electronics \& Assembly Inspection)](#2-전자-부품-및-조립-검사-electronics--assembly-inspection)
    - [3. 작업자 안전 관리 (Industrial Safety)](#3-작업자-안전-관리-industrial-safety)
    - [4. 물류 및 재고 관리 (Logistics \& Inventory)](#4-물류-및-재고-관리-logistics--inventory)
  - [도메인별 검색어](#도메인별-검색어)
    - [1. 산업군 및 도메인별 검색어 (Industry-Specific)](#1-산업군-및-도메인별-검색어-industry-specific)
    - [2. 머신 비전 기술 태스크별 검색어 (Task-Specific)](#2-머신-비전-기술-태스크별-검색어-task-specific)
    - [3. 결함 및 물리적 특성별 검색어 (Defect-Specific)](#3-결함-및-물리적-특성별-검색어-defect-specific)
    - [4. 데이터 소스 및 플랫폼별 검색 키워드](#4-데이터-소스-및-플랫폼별-검색-키워드)
  - [공개 데이터셋](#공개-데이터셋)
    - [1. 표면 결함 탐지 데이터셋 (Surface Defect Detection)](#1-표면-결함-탐지-데이터셋-surface-defect-detection)
    - [2. 이상 탐지 및 범용 검사 데이터셋 (Anomaly Detection)](#2-이상-탐지-및-범용-검사-데이터셋-anomaly-detection)
    - [3. 전자 부품 및 안전 관리 데이터셋 (Electronics \& Safety)](#3-전자-부품-및-안전-관리-데이터셋-electronics--safety)

## 조별 아이디어 선정

### 5조

- RC카(AGV에 대응) 기반 프로젝트: 추적하거나 다양한 활용을 하는 것 → 주로 주행 관련
- CD 웨이퍼 불량 탐지 (반도체 웨이퍼에 대응됨)
    - 조명이나 환경적 요소에 따른 변수를 통제하고 정확하게 작동하는 시스템을 만들어보겠다
    - 아이디어는 좋은데 반도체 웨이퍼를 CD로 대체하는 건 돈이 너무 많이 든다. 그건 좀 그래 알루미늄 호일로 대체하는 거라도 해보세요. 실무적인 테크닉을 연습하는 게 중요한 거지 꼭 웨이퍼여야만 하는 건 아니에요.
- OCR LOT 분류: 대략 로트 트래킹 목적. 설비 번호와 시간 등을 인식해 역추적 가능하게 하는 것이 목표
    - 이거 비추천임 너무 쉽고 다르게 할 방법이 너무 없어.
- 전선 꼬임 분리: 전선 전문가라는 사람들이 있다. 이게 하나의 직업이 된 이유는 그만큼 어렵기 때문임. 머신비전으로 좀 쉽게 해보자. 이것저것 해볼게.
    - 이거 데이터 수급은 쉬우니 추천하긴 하는데 좀 되게 어려울 거임. 지금까지 배운 머신 비전의 영역에서 좀 벗어날 것임

### 6조

- 바이알 검사
    - 앰플 용액 품질 검사임. 이물질이 있거나 스크래치가 있거나 한 거 검사하기
    - 똑바로 밀봉했는지, 적당히 담았는지 등 검사
- 나사볼트 품질 검사
    - 나사가 똑바로 생산됐는지, 카운팅, 사이즈 확인
- 알약 품질 검사
    - 카운트, 불량, 포장 검사 등
    - 이거 아이디어는 괜찮은데 나사 볼트랑 결이 좀 비슷해보인다. 물건 구하기는 괜찮겠다.

### 4조

- 이미지 기반 제품 치수 측정
    - 공차 체크할 거임
    - 이거 3조 거잖아요 그것보다는 잘해야죠?
- CCTV 기반 위험 지역/행동 판단
    - 공장 내 흡연, 위험 구역 진입 등 탐지
    - 이거 저번에 5조가 한 거랑 뭐가 다르니? 이번엔 진짜 데이터 직접 수집해볼게요.
- 볼트 체결 양불 판정

### 2조

- 보호장구 착용 검사
    - 헬멧, 방진복 등 필수 장비가 똑바로 갖춰져 있는지
    - 이거 그 지난 번 5조랑 비슷한 주제임 참고하기
- 자동차 도장 모니터링
    - 도장 품질 검사 자동화
- 물류 자동화 모델
    - 물류 크기에 따른 적재, 목적지 분류, 적재 상태 감지 등 구체적인 계획은 없긴 한데 대충 그럼
    - 너무 광범위해서 범위 좁히기 필요 → 일단 지금은 크기나 라벨에 따른 분류 정도,, → 컨베이어 벨트 해보실래요? 자동 분류기 이런 거 있잖아. 안되면 말고.
    - 크기별로 물류 목적지 분류

### 3조

- 플라스틱(원자재) 불량 검출
- 옷핀, 클립 등 소품(완제품) 불량 검출
- 완성차 라이트터널 비전 검사(도장 검사)

## 1조 아이디어 개요

- 이름: 머신 비전 기반 지능형 돈사 통합 관리 시스템
- 주요 기술 요소: 돼지 detection 및 segmentation
- 개요: 축산 현장을 데이터 중심의 자동화 시스템으로 보조하기 위한 지능형 모니터링 솔루션
    - OBB 및 객체 탐지 및 분할 기술을 기반으로 통합된 시스템 내에서 다음의 기능을 제공함:
        - 실시간 개체 수 감지 및 모니터링: 돼지 객체 detection 기반 개체 수 카운트
            - 카메라 시야 내 돼지 객체를 전수 탐지하여 정확한 개체 수를 산출하고 유실 여부를 실시간 확인
            - 이 데이터를 기반으로 이하의 기능이 제공됨
                - 급이/급수 구역 점유율 분석
                - 군집도 기반 환경 온도 추정 및 경보 시스템
        - 급이/급수 점유율 평가
            - 목표: 사료 공급 체계 최적화
            - 급이/급수 구역 내 돼지 개체수 모니터링
            - 체류 경향 분석
            - 점유율이 평소보다 낮아지면 해당 돈사의 질병 발생 가능성 의심
        - 군집도 기반 환경 모니터링
            - 돈사 내 돼지 밀집도 수치화
            - 돼지들이 한 곳에 밀집되어있는 경우, 적정 온도보다 추운 것으로 판정하여 경보
        - 비접촉식 체중 추정
            - Top-View 카메라로 비접촉식 측정

<iframe src="https://drive.google.com/file/d/1UMvFF0svxg0KOe2mUs65XQ_87br-CINr/preview" width="100%" height="600px">
    <p>이 브라우저는 PDF를 지원하지 않습니다.</p>
</iframe>

---

> 아이디어 겸 공개 데이터셋 목록
>
> <https://docs.google.com/spreadsheets/d/1TCKhjBmUbCVqUO5quJY7u9K10ZXQkZIh0REg3RYWX88/preview>

## 제조 도메인에서의 머신 비전 아이디어 탐색

> gemini 자료를 인용한 내용이 포함됨
{: .prompt-info }

### 문제 도메인별 분류

#### 1. 표면 결함 탐지 (Surface Defect Detection)

제조 공정에서 제품의 외관상 결함(스크래치, 오염, 균열 등)을 식별하는 가장 전형적인 머신 비전 활용 분야입니다.

- 아이디어 1: 금속 부품 표면 결함 분류
    - 설명: 열연 강판이나 금속 부품 표면의 6가지 유형 결함을 자동 분류.
    - 데이터셋: NEU Surface Defect Database. 6가지 유형(Crazing, Inclusion, Patches, Pitted Surface, Rolled-in Scale, Scratches)의 1,800개 이미지를 포함함.
- 아이디어 2: 범용 제조 물체 이상 탐지 (Anomaly Detection)
    - 설명: 정상 데이터만을 학습하여 비정상(결함) 발생 시 이를 검출하는 비지도 학습 기반 시스템.
    - 데이터셋: MVTec AD (MVTec Anomaly Detection). 15개 카테고리의 물체에 대해 5,000개 이상의 고해상도 이미지를 제공하며, 70개 이상의 결함 유형이 포함됨.

#### 2. 전자 부품 및 조립 검사 (Electronics & Assembly Inspection)

정밀한 배선이나 부품의 실장 상태를 확인하는 공정입니다.

- 아이디어 3: PCB(인쇄 회로 기판) 결함 자동 검사
    - 설명: 회로 단락(Short), 단선(Open), 핀홀 등 PCB 생산 과정의 결함을 탐지.
    - 데이터셋: DeepPCB 데이터셋. 1,500개의 이미지 쌍(템플릿 및 결함 이미지)으로 구성되어 있으며 주석(Annotation)이 포함됨.

#### 3. 작업자 안전 관리 (Industrial Safety)

제조 현장의 안전 수칙 준수 여부를 모니터링합니다.

- 아이디어 4: 개인 보호구(PPE) 착용 여부 실시간 모니터링
    - 설명: 작업자가 헬멧, 안전조끼, 장갑 등을 적절히 착용했는지 실시간 확인.
    - 데이터셋: Kaggle Hard Hat Universe 또는 Worker Safety Pro Dataset. 수천 장의 산업 현장 작업자 이미지를 포함함.

#### 4. 물류 및 재고 관리 (Logistics & Inventory)

제품의 식별 및 분류 작업을 자동화합니다.

- 아이디어 5: 산업용 부품 분류 및 계수(Counting)
    - 설명: 컨베이어 벨트 위를 지나가는 서로 다른 종류의 볼트, 너트 등을 분류하고 개수를 파악.
    - 데이터셋: 3D Industrial Parts Dataset 또는 직접 촬영 데이터 활용 가능. (MVTec AD의 일부 카테고리 활용 권장).

### 도메인별 검색어

#### 1. 산업군 및 도메인별 검색어 (Industry-Specific)

특정 제조 분야의 데이터를 타겟팅할 때 사용합니다.

- 반도체/전자: `Semiconductor wafer defect dataset`, `PCB soldering inspection image`, `Microchip surface flaw`, `Electronic component classification`.
- 철강/금속: `Steel surface defect dataset`, `Metal casting anomaly detection`, `Hot-rolled strip defect`, `Aluminium surface inspection`.
- 에너지/태양광: `Solar panel EL(Electroluminescence) image dataset`, `Photovoltaic module defect`, `Wind turbine blade crack`.
- 식품/제약: `Fruit quality grading dataset`, `Pharmaceutical pill counting`, `Bottle fill level inspection`, `Food packaging defect`.
- 섬유/가죽: `Textile fabric flaw detection`, `Leather surface defect`, `Weaving defect dataset`.

#### 2. 머신 비전 기술 태스크별 검색어 (Task-Specific)

해결하고자 하는 기술적 방법론에 따라 검색 결과가 달라집니다.

- 이상 탐지: `Unsupervised anomaly detection manufacturing`, `One-class classification industrial dataset`, `Out-of-distribution detection machine vision`.
- 객체 검출 및 분할: `Industrial object detection dataset`, `Semantic segmentation manufacturing images`, `Instance segmentation for part counting`.
- 상태 모니터링: `Machine health monitoring vision`, `Tool wear condition dataset`, `Predictive maintenance vision-based`.

#### 3. 결함 및 물리적 특성별 검색어 (Defect-Specific)

구체적인 결함의 형태를 명시하여 검색의 정밀도를 높입니다.

- 표면 결함: `Surface scratch detection`, `Cracks and dents dataset`, `Pitting and corrosion images`, `Discoloration detection`.
- 조립/형상: `Missing component detection`, `Misalignment inspection dataset`, `Dimensional measurement machine vision`.

#### 4. 데이터 소스 및 플랫폼별 검색 키워드

데이터셋이 주로 등록되는 플랫폼 내에서 아래의 태그 조합을 활용합니다.

- Kaggle: `tag:"manufacturing"`, `tag:"computer vision"`, `industrial defect`.
- Papers with Code(Hugging Face의 Trending Papers로 이관됨): `Industrial Inspection`, `Surface Defect Detection`, `Anomaly Detection`.
- GitHub: `awesome-industrial-machine-vision`, `manufacturing-dataset-list`.
- Google Dataset Search: `site:edu "manufacturing defect"`, `site:gov "industrial vision dataset"`.

### 공개 데이터셋

제조 도메인의 머신 비전 프로젝트 수행을 위해 즉시 활용 가능한 주요 공개 데이터셋 8종을 조사하여 정리했습니다. 각 데이터셋은 데모 프로그램 구현을 위한 어노테이션(Annotation)이 포함되어 있으며, 대부분 Kaggle이나 공식 연구 웹사이트를 통해 접근 가능합니다.

#### 1. 표면 결함 탐지 데이터셋 (Surface Defect Detection)

| 데이터셋 명칭          | 대상 물체   | 주요 내용 및 특징                                                                       | 주요 출처                                                                                               |
| ---------------------- | ----------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Severstal Steel Defect | 평판 강판   | 4종의 강판 표면 결함 탐지 및 세그멘테이션 데이터. 18,000장 이상의 고해상도 이미지 포함. | [Kaggle](https://www.kaggle.com/c/severstal-steel-defect-detection)                                     |
| NEU-DET                | 열연 강판   | 6종의 전형적인 강판 결함(스크래치, 균열 등) 분류 및 위치 검출. 1,800장 구성.            | http://faculty.neu.edu.cn/songkechen/zh-CN/zhym/263269/list/index.htm                                   |
| KolektorSDD / SDD2     | 전기 정류자 | 산업용 정류자의 표면 결함 탐지를 위한 정밀한 픽셀 단위 마스크 제공.                     | [ViCoS Lab](https://www.vicos.si/resources/kolektorsdd/)                                                |
| Casting Product        | 펌프 임펠러 | 주조 공정에서 발생하는 제품의 양불 판정(Ok/Defect)을 위한 7,348장의 이미지.             | [Kaggle](https://www.kaggle.com/datasets/ravirajsinh45/real-life-industrial-dataset-of-casting-product) |

#### 2. 이상 탐지 및 범용 검사 데이터셋 (Anomaly Detection)

| 데이터셋 명칭 | 범주        | 주요 내용 및 특징                                                                                  | 주요 출처                                                              |
| ------------- | ----------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| MVTec AD      | 범용 제조물 | 15개 카테고리(질감 5종, 물체 10종)에 대한 5,000장 이상의 이미지. 산업용 이상 탐지의 표준 벤치마크. | [MVTec 공식](https://www.mvtec.com/company/research/datasets/mvtec-ad) |
| DAGM 2007     | 질감 표면   | 다양한 인공 질감 표면 내의 미세 결함 탐지. 10개 클래스, 약 10,000장 이상의 이미지.                 | https://conferences.mpi-inf.mpg.de/dagm/2007/prizes.html               |

#### 3. 전자 부품 및 안전 관리 데이터셋 (Electronics & Safety)

| 데이터셋 명칭 | 범주      | 주요 내용 및 특징                                                                    | 주요 출처                                                                   |
| ------------- | --------- | ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| DeepPCB       | PCB 회로  | 6종의 PCB 결함(단선, 단락 등) 검출을 위한 1,500개의 정렬된 이미지 쌍 제공.           | https://www.kaggle.com/datasets/liuxiaolong1/pcb-defect-detection-dataset   |
| SH17 (PPE)    | 작업 안전 | 17종의 개인 보호구(헬멧, 장갑, 고글 등) 착용 여부 판별을 위한 8,000장 이상의 이미지. | https://www.kaggle.com/datasets/mugheesahmad/sh17-dataset-for-ppe-detection |