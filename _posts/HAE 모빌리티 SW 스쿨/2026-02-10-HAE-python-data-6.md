---
title: "Python 프로그래밍 및 데이터 분석 실무 (6)"
author: dapin1490
date: 2026-02-10 18:00:00 +09:00
categories: [HAE, 파이썬 데이터 분석]
tags: [현대오토에버, 모빌리티, 파이썬, 데이터 분석, 제조 데이터]
render_with_liquid: false
use_math: true
---

# 덤

- 덤: 예쁘게 결과 출력하기

  ```python
  result = comb.groupby('equipment_name').agg({
      'production_id': 'count',
      'actual_quantity': 'sum',
      '검사건수': 'sum',
      '불량건수': 'sum',
  })
  result.style.format({col: '{:,.0f}' for col in result.columns})

  # or
  eq_sum_style = {
      '생산건수': '{:,.0f}',
      '총생산량': '{:,.0f}',
      '총검사수': '{:,.0f}',
      '불량건수': '{:,.0f}',
      '불량률': '{:,.2f}',
  }

  eq_sum.style.format(eq_sum_style)
  ```

- 예쁘게 2 (HTML 출력 가능)

  ```python
  prd_sum = data_prd.groupby('equipment_id').agg({
      'production_id': 'count',
      'actual_quantity': 'sum',
      }).rename(columns={
          'production_id': '생산건수',
          'actual_quantity': '총생산량',
          })

  mt_sum = data_mt.groupby('equipment_id').agg({
      'maintenance_type': 'count',
      'cost': 'sum',
      'downtime_hours': 'sum',
      }).rename(columns={
          'maintenance_type': '정비건수',
          'cost': '총정비비용',
          'downtime_hours': '총정비시간',
          })

  from IPython.display import display, HTML

  html = f"""
  <div style="display: flex; gap: 20px; overflow-x: auto;">
    <div style="max-width: 50%; overflow-x: auto;">
      <strong>prd_sum</strong>
      {prd_sum.style.format('{:,.0f}').to_html()}
    </div>
    <div style="max-width: 50%; overflow-x: auto;">
      <strong>mt_sum</strong>
      {mt_sum.style.format('{:,.0f}').to_html()}
    </div>
  </div>
  """
  display(HTML(html))
  ```

- 평균과 중앙값의 차이  
  평균(산술평균, Mean)과 중앙값(Median)의 핵심적인 차이는 데이터의 대푯값(Central Tendency)을 정의하는 기준과 이상치(Outlier)에 대한 민감도에 있습니다. 두 지표를 구분하는 이유는 데이터의 분포 형태에 따라 집단을 대표하는 정확도가 달라지기 때문입니다.
  1. 의미적 차이
    - 평균 (The Arithmetic Mean): 데이터의 양적 중심을 나타냅니다. 모든 관측값의 총합을 개수로 나누어 계산하므로, 데이터 집합 내의 모든 수치 정보가 결과에 반영됩니다. 물리적으로는 데이터 분포의 무게중심과 같습니다[1].
    - 중앙값 (The Median): 데이터의 위치적 중심을 나타냅니다. 데이터를 크기순으로 정렬했을 때 정중앙에 위치하는 값(50번째 백분위수)입니다. 값의 구체적인 크기보다는 순서(Rank)에 의존합니다[1].
  2. 구분의 필요성 (왜 따로 사용하는가)  
    두 지표를 구분해야 하는 주된 이유는 이상치(Outlier)에 의한 왜곡과 데이터 분포의 비대칭성(Skewness) 때문입니다.  
    - 이상치에 대한 민감도:
      - 평균은 극단적으로 크거나 작은 값(이상치)에 매우 민감합니다. 하나의 극단적인 값이 전체 평균을 크게 상승시키거나 하락시켜, 실제 대다수 데이터의 경향과 동떨어진 값을 나타낼 수 있습니다[2].
      - 중앙값은 '로버스트(Robust)'한 통계량으로, 극단적인 값의 존재 여부와 관계없이 데이터의 중심 위치를 유지합니다. 따라서 이상치가 포함된 데이터에서 '일반적인 수준'을 파악할 때 유용합니다[2].
    - 분포의 형태에 따른 적합성:
      - 대칭 분포 (예: 정규분포): 데이터가 중심을 기준으로 대칭일 경우 평균과 중앙값은 거의 일치합니다. 이 경우 수학적 조작이 용이한 평균을 주로 사용합니다.
      - 비대칭 분포 (예: 소득 분포): 데이터가 한쪽으로 치우친 경우(Skewed), 평균은 긴 꼬리(Tail) 쪽으로 끌려갑니다. 예를 들어, 국민 소득 통계에서 소수의 초고소득자가 평균 소득을 대폭 상승시키기 때문에, 실제 대다수 국민의 소득 수준을 설명하기 위해 중앙값을 사용합니다[3].

      ![mean vs median in skewed distribution 이미지](https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcTE--GPZlga-Uz4hwCd8RMiMEcIdPR3RqTHUXMUMwa3UjwPo_PAsvxVma2DuDNJo0OwWZybNEupIuEwuu9j4njNiL4hyYNw9cD8tceFuR5OILBCFzk)

  - 참고문헌  
    [1] Australian Bureau of Statistics. (n.d.). *Measures of Central Tendency*. Retrieved from https://www.abs.gov.au/statistics/understanding-statistics/statistical-terms-and-concepts/measures-central-tendency  
    [2] NIST/SEMATECH. (n.d.). *Measures of Location*. e-Handbook of Statistical Methods. Retrieved from https://www.itl.nist.gov/div898/handbook/eda/section3/eda351.htm  
    [3] OpenStax. (2018). *Introductory Statistics*. Rice University. Retrieved from https://openstax.org/books/introductory-business-statistics-2e/pages/2-3-measures-of-the-center-of-the-data

# 요약

- **merge 2 (데이터 결합 심화)**
  - 데이터 경로 설정 : `data_route`, `os.listdir()`, `os.path.join()`으로 smart-practice 데이터 로드
  - 전일(5일차)과 동일한 생산·품질·설비 데이터 재사용, merge 동작 복습
  - 다단계 merge로 분석용 결합 테이블(comb) 구성 (생산 + 설비 + 품질 집계)
- **고급 판다스**
  - 생산·품질·센서·설비운영·설비 데이터 로드 : `parse_dates` 옵션으로 날짜/시간 컬럼을 바로 datetime으로 읽기
  - 일별 생산 집계 테이블 : `groupby('production_date').agg(...)`로 생산건수·총생산량·총불량수·불량률(%) 계산
  - 센서 데이터 리샘플링 : 특정 설비(INJ-001) 센서 데이터를 시간 인덱스(`set_index('measurement_time')`)로 만든 뒤, `resample('D')` / `resample('ME')`로 일·월말 평균값 산출
  - 이동평균 : 일별 센서값 집계(`sen_001_day`)에 `rolling(window=7).mean()` 등으로 7일 이동평균 계산, 추세·경고선 관찰
  - 변화량·변화율 : `daily_prd.diff()`로 전일 대비 변화량, `daily_prd.pct_change()*100`으로 전일 대비 변화율(%) 계산
  - 상관계수 : 생산량·가동률·품질 지표 등으로 구성된 `data_oee`에 대해 `data_oee.corr()`로 변수 간 상관관계 분석
- **고급 분석 인사이트** (해석·활용 관점)
  - **핵심 질문** : 어느 설비·일자·월이 "좋아지고 있는지/나빠지고 있는지", 어떤 요인이 OEE·불량률·정지 시간을 끌어올리는지, 어떤 설비가 **고장 위험·투자 우선**인지.
  - **멀티 테이블 결합 전략** : 생산·품질·설비·제품·정비·운영 데이터를 **fact + dimension**처럼 설계해서 merge하면, 한 테이블에서 **생산성·품질·정비 비용·가동시간**을 동시에 비교·시각화할 수 있음. 1:N 관계(생산↔검사)는 **선집계 후 merge**로 "1행=1생산건/1설비" 구조를 유지하는 것이 분석·대시보드에 유리.
  - **시간축·이동평균 활용** : 일별/월별 집계와 **7일·30일 이동평균**을 같이 보면, 일시적 급등·급락과 **구조적 추세 변화**를 구분 가능. 이동평균이 계속 상승하면 설비 노후·수요 증가·공정 부담 누적 등 **중장기 이슈**를 의심할 수 있음.
  - **변화량·변화율 모니터링** : `diff()`와 `pct_change()`는 "전일(전월) 대비"를 자동으로 보여주는 프리셋. **급격한 증가·감소일**만 필터링하면, 점검이 필요한 날·설비를 빠르게 좁힐 수 있음.
  - **센서 이상치·3-Sigma** : 3-Sigma 규칙으로 센서 이상치를 찾으면, **품질 문제 전 단계의 설비 이상 징후**를 포착할 수 있음. 이동평균 + 3-Sigma를 함께 쓰면 "추세적으로 나빠지면서도 통계적으로도 이탈한 구간"을 조기에 경고 가능.
  - **OEE·SPC·대시보드** : OEE는 설비별 성과를 한 숫자로 요약해 **비교·랭킹**에 좋고, SPC 관리도는 **공정이 통계적으로 안정적인지**를 판단하는 데 적합. 이를 종합 대시보드에 올리면, **라인/설비/기간별로 어디에 먼저 개입해야 할지** 한눈에 파악 가능.
  - **상관계수·고장 위험도 feature** : `corr()`로 어떤 센서·정비 지표가 불량률·정지시간과 상관이 큰지 먼저 보고, 그 지표들을 조합해 **고장 위험 스코어**를 만들면 예지보전 모델의 입력 변수 설계에 활용 가능(단, 상관관계 ≠ 인과관계이므로 도메인 검증 필요).

# merge 2

데이터 경로 설정

```python
import os
import numpy as np
import pandas as pd

data_route = '../강의자료/smart-practice/data'
data_list = os.listdir(data_route)
data_list = [os.path.join(data_route, data_list[i]) for i in range(len(data_list))]

os.path.exists(data_route), len(data_list), data_list[0]
```

어제 하던 데이터 똑같이 다시 가져오기

```python
data_q = pd.read_csv(data_list[6], na_values=['\\N'])
data_prd = pd.read_csv(data_list[4])
data_eq = pd.read_csv(data_list[0])

q_sum = data_q.groupby('production_id').agg({
    'inspection_id': 'count',
    'result': lambda x : (x == 'FAIL').sum(),
    'measurement_value': 'mean'
    })

step1 = pd.merge(data_prd, data_eq, on='equipment_id', how='left')
comb = pd.merge(step1, q_sum, on='production_id')

comb.rename(columns={
    'inspection_id': '검사건수',
    'result': '불량건수',
    'measurement_value': '평균측정값'
    }, inplace=True)

comb.T
```

사실 csv로 저장했었음

```python
comb = pd.read_csv(os.path.join('../data', '260209_comb.csv'))

comb.columns
```

## 설비별 생산효율 + 품질 문제 확인

불량률 추가

```python
comb['불량률'] = (comb['불량건수'] / comb['검사건수'] * 100).fillna(0)

len(comb.columns), comb.columns
```

그룹뷰 생성

```python
eq_sum = comb.groupby('equipment_name').agg({
    'production_id': 'count',
    'actual_quantity': 'sum',
    '검사건수': 'sum',
    '불량건수': 'sum',
    })

eq_sum.style.format('{:,.0f}')
```

컬럼 개명

```python
eq_sum.columns = ['생산건수', '총생산량', '총검사수', '불량건수']

eq_sum.style.format('{:,.0f}')
```

rate 하나 더 계산해서 넣을거임

```python
eq_sum['불량률'] = (eq_sum['불량건수'] / eq_sum['총검사수'] * 100).round(2)

eq_sum.style.format({
    '생산건수': '{:,.0f}',
    '총생산량': '{:,.0f}',
    '총검사수': '{:,.0f}',
    '불량건수': '{:,.0f}',
    '불량률': '{:,.2f}',
})
```

결과 확인

```python
eq_sum.sort_values(by='총생산량', ascending=False)
eq_sum.sort_values(by='불량률', ascending=False)
```

## 정비 비용 vs 생산 기여도

적절한 데이터 가져오기

```python
data_mt = pd.read_csv(data_list[9])

data_mt.columns
```

concat 전에 정리부터

```python
prd_sum = data_prd.groupby('equipment_id').agg({
    'production_id': 'count',
    'actual_quantity': 'sum',
    }).rename(columns={
        'production_id': '생산건수',
        'actual_quantity': '총생산량',
        })

mt_sum = data_mt.groupby('equipment_id').agg({
    'maintenance_type': 'count',
    'cost': 'sum',
    'downtime_hours': 'sum',
    }).rename(columns={
        'maintenance_type': '정비건수',
        'cost': '총정비비용',
        'downtime_hours': '총정비시간',
        })

prd_sum.style.format('{:,.0f}').to_html()
mt_sum.style.format('{:,.0f}').to_html()
```

조각조각 만든 걸 다 합쳐서 하나의 뷰로 만들거임

```python
data_eq2 = data_eq[['equipment_id', 'equipment_name', 'equipment_type']]
eq_ana = pd.merge(data_eq2, prd_sum, on='equipment_id')
eq_ana = pd.merge(eq_ana, mt_sum, on='equipment_id')

eq_ana_style = {
    '총정비비용': '{:,.2f}',
    '총생산량': '{:,.0f}',
    '총정비시간': '{:,.2f}',
}

eq_ana.style.format(eq_ana_style)
```

이제부터 분석하겠다 (ZeroDivisionError 주의) → 판다스는 분모가 0일 때 자동으로 무한대로 치환해서 표기함 → 해당 값은 0으로 대체하여 표기하는 게 보통임

```python
eq_ana['생산당_정비비용'] = (eq_ana['총정비비용'] / eq_ana['총생산량']).replace([np.inf, -np.inf], 0)

eq_ana_style['생산당_정비비용'] = '{:,.2f}'

eq_ana.style.format(eq_ana_style)
```

### ROI(투자 대비 비용, 가성비) 문제 설비 찾기: 생산 ↓, 정비비용 ↑ → 총생산량은 중앙값보다 작고 총정비비용은 중앙값보다 큰 것

값 한번 봐봐

```python
int(eq_ana['총생산량'].median()), (eq_ana['총정비비용'].median()).round(2)
```

걸러내기

```python
print(eq_ana['총생산량'] < eq_ana['총생산량'].median())
print(eq_ana['총정비비용'] > eq_ana['총정비비용'].median())
print((eq_ana['총생산량'] < eq_ana['총생산량'].median()) & (eq_ana['총정비비용'] > eq_ana['총정비비용'].median()))
```

# 고급 판다스

## 시계열 분석

날짜 포함해서 데이터 불러오기

```python
data_prd = pd.read_csv(data_list[4], encoding='utf-8-sig', parse_dates=['production_date', 'start_time', 'end_time'])

data_q = pd.read_csv(data_list[6], encoding='utf-8-sig', na_values=['\\N'])

data_sen = pd.read_csv(data_list[7], encoding='utf-8-sig', parse_dates=['measurement_time'])

data_op = pd.read_csv(data_list[5], encoding='utf-8-sig', parse_dates=['start_time', 'end_time'])

data_eq = pd.read_csv(data_list[0], encoding='utf-8-sig')

data_prd.columns
```

쓸 것만 골라내고 필요한 거 추가하기

```python
daily_prd = data_prd.groupby('production_date').agg({
    'production_id': 'count',
    'actual_quantity': 'sum',
    'defect_quantity': 'sum',
}).rename(columns={
    'production_id': '생산건수',
    'actual_quantity': '총생산량',
    'defect_quantity': '총불량수',
})

daily_prd['불량률'] = (daily_prd['총불량수'] / daily_prd['총생산량'] * 100).round(2)

daily_prd
```

리샘플링을 할 거야

```python
sen_inj001 = data_sen.loc[data_sen['equipment_id'] == 'INJ-001', ].sort_values(by='measurement_time').reset_index(drop=True)

# 리샘플링할 때는 무조건 시간이 인덱스가 되어 있어야 함
sen_inj001.set_index('measurement_time', inplace=True)

# 일별 평균 샘플값 계산
sen_inj001['temperature'].resample('D').mean()  # day
sen_inj001[['temperature', 'pressure']].resample('ME').mean()  # month end
sen_inj001[['temperature', 'pressure', 'vibration', 'current', 'voltage', 'rpm']].resample('D').mean()  # day
```

이렇게도 resample 할 수 있어

```python
sen_all = data_sen.groupby('measurement_time')[['temperature', 'pressure', 'vibration', 'current', 'voltage', 'rpm']].mean()

sen_all.resample('D').mean()
```

생산효율 = 생산수량 / 목표수량

```python
def set_prd_eff_grade(x):
    if x > 90:
        return '우수'
    elif x > 80:
        return '양호'
    else:
        return '부족'

data_prd['생산효율'] = (data_prd['actual_quantity'] / data_prd['target_quantity'] * 100).round(2)
data_prd['생산효율_등급'] = data_prd['생산효율'].apply(set_prd_eff_grade)

data_prd[['생산효율', '생산효율_등급']]
```

## 이동평균

- 센서 데이터에는 노이즈가 많아서 추세 파악이 힘들다.
- 노이즈 제거나 이상패턴 감지가 쉽다.
- 예
  - 진동센서 7일 이동평균이 상승 → 베어링 교체
  - 온도 30일 이동평균이 상승 → 냉각 시스템 점검
  - 측정값 이동평균이 상한선 접근 → 사전 경고를 해줄수 있다
  - 생산량 이동평균으로 수요 예측
  - 계절성 패턴 파악 가능

---

센서 데이터로 이동평균

```python
sen_001_day = sen_inj001.resample('D')['temperature'].mean()
sen_001_day.rolling(window=3).mean()  # window: 이동평균 기간
```

## 변화율 계산

넘파이식 변화량 계산 == 전일 대비 변화량 프리셋: diff, 비율로 봐도 된다

```python
# shift(n): n일 대비 변화량, -1로 쓰면 다음날 대비 변화량
(daily_prd - daily_prd.shift(1)).head().to_html()
# 전일 대비 변화량 프리셋: diff
daily_prd.diff().head().to_html()
# 변화량을 비율로 보여줘
(daily_prd.pct_change() * 100).round(2).head().to_html()
```

## 이상치 탐지

IQR, z-score, 3-sigma: 검색하면 나오니까 생략

## OEE 계산

$$\text{OEE} = \text{가동률} \times \text{성능률} \times \text{수율}$$
$$= \frac{\text{실제 가동시간}}{\text{계획 가동시간}} \times \frac{\text{실제 생산량} \times \text{이상 사이클타임}}{\text{실제 가동시간}} \times \frac{\text{양품량}}{\text{총생산량}}$$

- 가동률 낮다 → 설비 점검: 고장, 정지 감소
- 성능률 낮다 → 이상 사이클타임 줄이기: 속도 개선, 교체 시간 단축
- 수율 낮다 → 품질 개선, 재작업 감소
- 벤치마킹: 좋은 설비 따라해
- 이달의 우수공장 선정: 보고 따라하라고
- OEE
  - 85% 이상: 셰계적 우수공장
  - 70~84%: 양호
  - 60~69%: 보통, 개선 과제 도출
  - 60% 미만: 개선 필요, 긴급 조치

---

상관계수를 볼거야

```python
data_oee = data_prd[['target_quantity', 'actual_quantity', 'cycle_time', '생산효율']]

data_oee.corr().style.format('{:,.2f}')
```