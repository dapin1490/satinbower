---
title: "Python 프로그래밍 및 데이터 분석 실무 (5)"
author: dapin1490
date: 2026-02-09 18:00:00 +09:00
categories: [HAE, 파이썬 데이터 분석]
tags: [현대오토에버, 모빌리티, 파이썬, 데이터 분석, 제조 데이터]
render_with_liquid: false
use_math: true
---

# 요약

- **통계 내기**
  - 데이터 로드·날짜 변환 : 생산·품질 CSV, `pd.to_datetime(production_date)` 등
  - 파생 컬럼 : 불량률 `defect_rate` (defect_quantity/actual_quantity*100)
  - 설비별 집계 : `groupby('equipment_id')['actual_quantity'].sum()`, `.mean()`, `sort_values()`
  - 다중 통계 한 번에 : `groupby(...).agg(['sum','mean','std','max','min','count'])`
  - 집계 결과 컬럼 개명 : `agg(목표생산=('target_quantity','sum'), ...)`
  - 다중 키 그룹 : `groupby(['equipment_id','product_code']).agg(...)`
- **시계열 분석**
  - 연·월 기준 집계 : `dt.to_period('M')`, `groupby('pr_date_YM')['actual_quantity'].sum()`
- **그룹과 피벗**
  - 교대조별 여러 컬럼 집계 : `groupby('shift')[[...]].agg([...]).T`
  - 피벗 테이블(설비×제품) : `pd.pivot_table(..., index='equipment_id', columns='product_code', values='actual_quantity', aggfunc='sum', fill_value=0)`
  - 피벗(여러 values) : `values=['actual_quantity','defect_quantity']`
  - 다중 인덱스 피벗 : `index=['shift','equipment_id']`, `index=['shift'], columns=['equipment_id','product_code']`
- **데이터 합치기 (concat / merge / join)**
  - concat으로 행 방향 결합 : 1월·2월 생산 데이터를 `pd.concat([df_1, df_2], ignore_index=True)`로 이어 붙이기
  - merge 기본 : `pd.merge(왼쪽, 오른쪽, on='키', how='left/right/inner/outer')`, 조인 방식별(LEFT/RIGHT/INNER/OUTER) 차이
  - 생산·설비·품질 데이터 통합 : `pd.merge(data_prd, data_eq, on='equipment_id', how='left')` 후 품질 집계(`q_sum`)를 다시 merge해 분석용 `comb` 뷰 생성
  - join 개념 소개 : 인덱스를 기준으로 두 DataFrame을 합치는 방식, SQL join과의 대응 관계 설명
- **집계 분석 인사이트** (해석·활용 관점)
  - **핵심 질문** : 어떤 설비가 가장 생산성 높은가? 야간 조 불량률이 더 높은가? 월별 생산 추이·병목·인기 제품은?
  - **설비·생산량** : 설비별 합계·평균 → **병목·고성능 설비** 파악, 생산 계획·가동률 기초. 표준편차 크면 **설비 안정성·고장 위험** 참고. 생산 많고 불량률 높은 설비 → **품질 개선 프로젝트** 후보.
  - **설비·제품·교대조** : 설비별 제품 생산 패턴 → **제품 특화·교체 빈도·스케줄링** 활용. 교대조별 설비 품질 → **주/야간 차이** 해석(야간만 나쁘면 조명·교육, 전 조 나쁘면 설비 자체), 인사고과·개선 우선순위에 반영.
  - **시계열** : 연·월·요일 기준 집계로 **추세·패턴·이상일** 파악, **월간 목표 달성** 여부 점검.
  - **빈도·비율** : **파레토(80:20)** 적용해 상위 원인부터 조치. 설비별 비중(50% 이상이면 고장 시 **생산 마비 리스크**)으로 투자·부하 분산 판단.
  - **품질·불량** : **합격률**로 전반 품질 수준 파악. **상위 2~3개 불량 유형** 우선 해결 시 효과 큼. 특정 불량코드 비중 크면 **해당 공정 집중 투자**로 큰 폭 개선 가능.
  - **교차표** : **pivot_table** → 합계·평균 등 **통계값**. **crosstab** → **빈도(건수)**. 행/열 **정규화**로 비율 비교·해석.
  - **Transform·이상치** : 그룹 통계를 **원본 행 수 유지**하며 붙이면 **평균 대비 편차·Z-score** 계산 가능. Z-score(3, 1.96, 2.58)로 **이상치·신뢰구간** 탐지.
  - **필터 전략** : **생산 건수 100건 미만** 설비 제외해 통계 신뢰도 확보. **평균 불량률 5% 이상** 그룹만 추려 **개선 우선** 대상 선정.
  - **멀티 소스 결합** : MES(생산실적)·QMS(품질)·설비 정보·IoT 센서 데이터를 merge로 한 화면에 모으면, **생산량은 많은데 불량률도 높은 설비**, **정비비용 대비 생산 기여도가 낮은 설비** 등 투자·개선 우선 순위를 바로 뽑아낼 수 있음.

# 통계 내기

데이터 준비하기

```python
import os
import numpy as np
import pandas as pd

data_route = '../강의자료/smart-practice/data'
data_list = os.listdir(data_route)

os.path.exists(data_route), len(data_list)
```

기본 import

```python
import pandas as pd

data_prd = pd.read_csv(os.path.join(data_route, data_list[4]))
data_q = pd.read_csv(os.path.join(data_route, data_list[6]), na_values=['\\N'])

data_q.info()
```

불량률 계산

```python
data_prd['defect_rate'] = np.round(data_prd['defect_quantity'] / data_prd['actual_quantity'] * 100)

data_prd.info()
```

설비 가동률 순위

```python
data_prd.groupby('equipment_id')['actual_quantity'].sum().sort_values(ascending=False)
data_prd.groupby('equipment_id')['actual_quantity'].mean().sort_values(ascending=False)
```

통계 좀 여러 개 보여줘라

```python
summa_prd = data_prd.groupby('equipment_id')['actual_quantity'].agg(['sum', 'mean', 'std', 'max', 'min', 'count']).sort_values(by='sum', ascending=False)

summa_prd
```

컬럼 개명

```python
summa_prd.rename(columns={'sum': '생산량', 'mean': '평균', 'std': '표준편차', 'max': '최대', 'min': '최소', 'count': '생산횟수'}, inplace=True)

summa_prd
```

세부 항목별 통계 그룹

```python
data_prd.groupby('equipment_id').agg({
    'target_quantity': ['sum', 'max', 'min', 'count'],
    'actual_quantity': ['sum', 'mean', 'std', 'max', 'min', 'count'],
    'good_quantity': ['sum', 'mean', 'std', 'max', 'min', 'count'],
    'defect_quantity': ['sum', 'mean', 'std', 'max', 'min', 'count']
    }).T
```

```python
data_prd.groupby('equipment_id')[[
    'target_quantity', 'actual_quantity', 'good_quantity', 'defect_quantity'
    ]].agg([
        'sum', 'mean', 'std', 'max', 'min', 'count'
        ]).T
```

```python
data_prd.groupby([
    'equipment_id', 'product_code'
    ])[[
        'target_quantity', 'actual_quantity', 'good_quantity', 'defect_quantity'
        ]].agg([
            'sum', 'mean', 'std', 'max', 'min', 'count'
            ]).T
```

```python
data_prd.groupby([
    'equipment_id', 'product_code'
    ]).agg(
        목표생산=('target_quantity', 'sum'),
        실제생산=('actual_quantity', 'sum'),
        양품생산=('good_quantity', 'sum'),
        불량생산=('defect_quantity', 'sum')
        )
```

# 시계열 분석

연월 데이터 확인하기

```python
data_prd['pr_date_YM'] = data_prd['production_date'].dt.to_period('M')

data_prd.groupby('pr_date_YM')['actual_quantity'].sum()
```

# 그룹과 피벗

교대조별 생산량

```python
data_prd.groupby('shift')[[
    'actual_quantity', 'cycle_time', 'defect_rate'
    ]].agg([
        'sum', 'mean', 'std', 'max', 'min', 'count'
        ]).T
```

설비별 생산량

```python
pd.pivot_table(data_prd, index='equipment_id', columns='product_code', values='actual_quantity', aggfunc='sum', fill_value=0)

pd.pivot_table(data_prd, index='equipment_id', columns='product_code', values=['actual_quantity', 'defect_quantity'], aggfunc='sum', fill_value=0)
```

교대조별 설비별 생산량

```python
pd.pivot_table(data_prd, index=['shift', 'equipment_id'], columns='product_code', values='actual_quantity', aggfunc='sum', fill_value=0)

(pd.pivot_table(data_prd, index=['shift'], columns=['equipment_id', 'product_code'], values='actual_quantity', aggfunc='sum', fill_value=0)).round().T
```

여러 개 같이 보기

```python
(pd.pivot_table(data_prd, index=['shift'], columns=['equipment_id', 'product_code'], values=['actual_quantity', 'defect_rate'], aggfunc='mean', fill_value=0)).round(2).T
```

총계도 표시할 수 있어

```python
(pd.pivot_table(data_prd, index=['shift'], columns=['equipment_id', 'product_code'], values=['actual_quantity', 'defect_rate'], aggfunc='mean', fill_value=0, margins=True)).round(2).T
```

카운트 값을 비율로 보여줘

```python
data_prd['equipment_id'].value_counts(normalize=True)
```

합격률 계산하기

```python
data_q['result'].value_counts(normalize=True)
```

어떤 불량이 제일 많은가

```python
pd.concat([data_q['defect_code'].value_counts(), (data_q['defect_code'].value_counts(normalize=True)).round(2)], axis=1)
```

설비 제품 교차표

```python
pd.crosstab(data_prd['equipment_id'], data_prd['product_code'])

(pd.crosstab(data_prd['equipment_id'], data_prd['product_code'], normalize='columns', margins=True)).round(2)
(pd.crosstab(data_prd['equipment_id'], data_prd['product_code'], normalize='index', margins=True)).round(2)
```

그룹별 통계로 추가 통계 산출하기

```python
data_prd['actual_q_by_eqid_mean'] = data_prd.groupby('equipment_id')['actual_quantity'].transform('mean')

data_prd['actual_q_by_eqid_mean']
```

```python
data_prd['diff_by_mean'] = data_prd['actual_quantity'] - data_prd['actual_q_by_eqid_mean']

data_prd['diff_by_mean']
```

z-score 신뢰구간

```python
data_prd['act_q_std'] = data_prd.groupby('equipment_id')['actual_quantity'].transform('std')
data_prd['q_z_score'] = data_prd['diff_by_mean'] / data_prd['act_q_std']

data_prd.loc[data_prd['q_z_score'] > 3, ]  # 3 이상인 경우 이상치
```

생산 건수가 100 미만인 설비는 데이터에서 빼봐

```python
data_prd.groupby('equipment_id').filter(lambda x: len(x) >= 100)
```

평균 불량률이 5% 이상인 것만 보여줘봐

```python
data_prd.groupby('equipment_id').filter(lambda x: x['defect_rate'].mean() >= 5)
```

# merge

서로 다른 데이터프레임 합치기

```python
data_prd = pd.read_csv(os.path.join(data_route, data_list[4]))
data_q = pd.read_csv(os.path.join(data_route, data_list[6]), na_values=['\\N'])

pd.concat([data_prd, data_q], ignore_index=True)
```

합치기 예시 2: 겹치는 컬럼 있을 때 merge

```python
data_eq = pd.read_csv(os.path.join(data_route, data_list[0]))

pd.merge(data_prd, data_eq, on='equipment_id', how='left').T  # 한 번에 2개만 합칠 수 있음, 더 하려면 겹겹이 merge해야 함

# left: 왼쪽 데이터프레임 기준으로 합치기
# right: 오른쪽 데이터프레임 기준으로 합치기
# inner: 양쪽 데이터프레임에 모두 있는 데이터만 합치기
# outer: 양쪽 데이터프레임에 있는 모든 데이터를 합치기
```

merge로 데이터 뷰 생성하기

```python
data_q = pd.read_csv(os.path.join(data_route, data_list[6]), na_values=['\\N'])

q_sum = data_q.groupby('production_id').agg({
    'inspection_id': 'count',
    'result': lambda x : (x == 'FAIL').sum(),
    'measurement_value': 'mean'
    })

step1 = pd.merge(data_prd, data_eq, on='equipment_id', how='left')
comb = pd.merge(step1, q_sum, on='production_id')

comb.rename(columns={
    'inspection_id': '검사횟수',
    'result': '불량건수',
    'measurement_value': '평균측정값'
    }, inplace=True)

comb.T
```

오늘 데이터는 저장하고 재활용하겠다

```python
comb.to_csv(os.path.join('../data', '260209_comb.csv'), index=False)
```