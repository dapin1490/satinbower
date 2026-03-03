---
title: "Python 프로그래밍 및 데이터 분석 실무 (4)"
author: dapin1490
date: 2026-02-07 18:00:00 +09:00
categories: [HAE, 파이썬 데이터 분석]
tags: [현대오토에버, 모빌리티, 파이썬, 데이터 분석, 제조 데이터]
render_with_liquid: false
use_math: true
---

# 강의 자료

- 다운받아: https://github.com/macro0630/smart-practice

# 요약
- **판다스 파일 처리**
- 경로·파일 목록 : `os.path.exists()`, `os.listdir()`, `data_route`
- CSV 읽기·정보 : `pd.read_csv()`, `os.path.join()`, `info()`, `head().T`
- 결측값 지정 : `na_values=['\\N','NULL','']`
- **조건 필터**
- 단일·다중 조건 : `loc[조건]`, `&` `|`, 조건을 변수로 분리
- 유니크 값 확인 : `unique()`
- **필터 후 집계**
- 평균·비율 : 필터된 DataFrame에 `.mean()`, 불량률(mean/sum 기준)
- **데이터 처리(결측치)**
- 결측만 필터 : `.loc[lambda x: x['col'].notnull()]`
- 결측 채우기(고정값) : `fillna('N/A')`
- 결측 채우기(통계·시계열) : `fillna(평균)` / `fillna(중앙값)`, `ffill()`, `bfill()`, `interpolate(method='linear')`
- 결측 행 제거 : `dropna(subset=['col'])`, `dropna()`
- **중복**
- 중복 확인 : `duplicated()`, `duplicated(subset=['col'])`
- 중복 제거 : `drop_duplicates(subset=..., keep='first'/'last')`
- **날짜/시간**
- 변환 : `pd.to_datetime()`, `pd.to_numeric()`
- 추출 : `.dt.month`, `.dt.day`, `.dt.hour`, `.dt.day_name()` 등
- **구간 나누기**
- 직접 구간 : `pd.cut(열, bins=[...], labels=[...])`
- n등분 : `pd.qcut(열, q=4, labels=[...])`
- **전처리·데이터 품질 인사이트** (해석·활용 관점)
  - **결측** : 컬럼별 결측 비율을 보면 **어떤 컬럼을 보간/삭제할지** 우선순위를 정할 수 있음. 품질 평가·분석 신뢰도에 직결.
  - **결측 채우기** : 시계열은 **보간(interpolate)·ffill/bfill**로 흐름을 유지해 추이 분석 가능하게. 고정값(평균·중앙값)은 비시계열에.
  - **중복** : **작업지시서(work_order_no)** 등 키 기준 중복 제거 안 하면 **생산 건수·효율 지표가 왜곡**됨. keep='first'/'last'로 기준 통일.
  - **날짜·시간** : `to_datetime` 후 **연/월/일/요일** 추출하면 **추이·패턴·요일별 성과** 분석 가능.
  - **생산 효율 지표** : 목표 대비 실적·불량률 등 **지표를 정의**해 두면 설비별·기간별 비교·대시보드 기초가 됨.
  - **구간·등급·시간대** : **pd.cut·조건부 등급·시간대 분류**로 구간을 나누면 **구간별 건수·평균 불량률** 비교로 성과·리스크 구간 파악 가능.
  - **가동률** : **가동시간(RUNNING)**만 필터해 설비별 합계하면 **부하·병목 후보** 비교 가능.
  - **파이프라인** : 결측→날짜→파생 컬럼 순으로 **전처리 순서를 고정**하면 재현 가능하고, 품질 검사·효율 분석 전에 데이터 품질을 확보할 수 있음.

# 판다스 파일 처리

- 약간의 상수 처리 ← 계속 같은 폴더 쓸건데 뭐하러 매번 같은 경로를 붙여넣기함

  ```python
  data_route = '../강의자료/smart-practice/data'
  data_list = os.listdir(data_route)

  import os
  os.path.exists(data_route), len(data_list)
  ```

- 읽어

  ```python
  import pandas as pd

  data = pd.read_csv(os.path.join(data_route, data_list[0]))

  data.info()
  data.head().T  # 뒤집어야 예쁜 데이터도 있는거임
  data.tail().T
  ```

- 인덱스가 없잖아 붙여

  ```python
  print("=" * 40 + "\n(1) 바로 붙이기\n" + "=" * 40)
  data = pd.read_csv(os.path.join(data_route, data_list[0]), index_col=0)
  print(data.info(), "\n")

  print("=" * 40 + "\n(2) 읽고 나서 붙이기\n" + "=" * 40)
  data = pd.read_csv(os.path.join(data_route, data_list[0]))
  data.set_index('equipment_id', inplace=True)
  print(data.info())

  # 출력 생략
  ```

- 날짜를 왜 문자열로 처리하니

  ```python
  to_date = ['production_date', 'start_time', 'end_time', 'created_at', 'updated_at']

  data = pd.read_csv(os.path.join(data_route, data_list[4]), index_col=0, parse_dates=to_date)

  data.info()
  ```

- 컬럼 차별

  ```python
  to_read = ['equipment_id', 'product_code', 'production_date', 'actual_quantity', 'good_quantity', 'defect_quantity']

  data = pd.read_csv(os.path.join(data_route, data_list[4]), index_col=0, usecols=to_read)

  data.info()
  ```

- 데이터 타입 컨트롤프릭

  ```python
  types = {
      'equipment_id': 'category',
      'product_code': 'category',
      'work_order_no': 'category',
      'lot_no': 'category',
      'operator_id': 'category',
      'shift': 'category',
      }
  to_date = ['production_date', 'start_time', 'end_time', 'created_at', 'updated_at']

  data = pd.read_csv(os.path.join(data_route, data_list[4]), index_col=0, dtype=types, parse_dates=to_date)

  data.info()
  ```

- 다른 데이터 참조해서 필터링하기

  ```python
  data1 = pd.read_csv(os.path.join(data_route, data_list[0]))
  data2 = pd.read_csv(os.path.join(data_route, data_list[4]))

  # 조건 1개
  data2.loc[data2['equipment_id'] == data1.loc[0, 'equipment_id'], 'equipment_id':'production_date'].head(4).T

  # 조건 2개
  data2.loc[(data2['equipment_id'] == data1.loc[0, 'equipment_id']) & (data2['defect_quantity'] >= 5), 'equipment_id':'defect_quantity'].head(4).T

  # 조건 2개 예쁘게
  filter = (data2['equipment_id'] == data1.loc[0, 'equipment_id']) & (data2['defect_quantity'] >= 5)
  data2.loc[filter, 'equipment_id':'defect_quantity'].head(4).T

  # 조건 2개 예쁘게 2
  filter = (data2['actual_quantity'] >= 100) | (data2['defect_quantity'] >= 5)
  data2.loc[filter, 'equipment_id':'defect_quantity'].head(4).T
  ```

- 유니크 확인

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[6]))

  print(data['result'].unique())
  ```

- 사칙연산

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data_filtered = data.loc[(data['equipment_id'] == 'INJ-001') & (data['defect_quantity'] >= 5)]

  print(data_filtered.shape)
  print(f'mean actual_quantity: {data_filtered["actual_quantity"].mean():.1f}')
  print(f'mean defect rate(cal by mean): {data_filtered["defect_quantity"].mean() / data_filtered["actual_quantity"].mean():.1%}')
  print(f'mean defect rate(cal by sum): {data_filtered["defect_quantity"].sum() / data_filtered["actual_quantity"].sum():.1%}')

  '''
  (236, 17)
  mean actual_quantity: 109.5
  mean defect rate(cal by mean): 11.3%
  mean defect rate(cal by sum): 11.3%
  '''
  ```


# 문제 풀어보세요

[macro0630/smart-practice/실습/01_pandas_basic_practice.ipynb](https://github.com/macro0630/smart-practice/blob/main/%EC%8B%A4%EC%8A%B5/01_pandas_basic_practice.ipynb)

# 데이터 처리

- 이것은 해로운 값이다

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[6]), na_values=['\n', '\\N', 'NULL', 'null', ''])  # 지정한 값을 nan으로 바꿈

  data.info()
  ```

- 해로운 값은 편식하겠다

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[6]), na_values=['\n', '\\N', 'NULL', 'null', '']).loc[lambda x: x['defect_code'].notnull()]

  data.info(), data['defect_code'].value_counts()
  ```

- 빈 칸을 채우시오

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[6]), na_values=['\n', '\\N', 'NULL', 'null', ''])

  data['notes'] = data['notes'].fillna('N/A')

  data['notes'].value_counts()
  ```

- 빈 칸을 타당하게 채우시오 (← 하기 위해 일부러 몇 개 지움)

  ```python
  import numpy as np

  data = pd.read_csv(os.path.join(data_route, data_list[7]))
  data = data.loc[data['equipment_id'] == 'INJ-001']

  # 일부러 빈 자리 내기
  data.loc[10:15, 'temperature'] = np.nan
  data.loc[20:25, 'temperature'] = np.nan
  print(f'before fillna: {data.loc[:, "temperature"].isna().sum()} nan')

  # 평균으로 채울거임
  data.fillna({'temperature': data.loc[:, 'temperature'].mean()}, inplace=True)
  # 중앙값으로 채울거임
  data.fillna({'temperature': data.loc[:, 'temperature'].median()}, inplace=True)
  # 시계열 앞에 있는 거 베끼기
  data.ffill(inplace=True)
  # 시계열 뒤에 있는 거 베끼기
  data.bfill(inplace=True)

  print(f'after fillna: {data.loc[:, "temperature"].isna().sum()} nan')
  ```

- 안먹어 버려

  ```python
  import numpy as np

  data = pd.read_csv(os.path.join(data_route, data_list[7]))

  # 일부러 빈 자리 내기
  data.loc[10:15, 'temperature'] = np.nan
  data.loc[20:25, 'temperature'] = np.nan
  print(f'before fillna: {data.isna().sum()} nan')

  # 특정 컬럼만 버려
  data.dropna(subset=['temperature'], inplace=True)
  # 다 버려
  data.dropna(inplace=True)

  print(f'after fillna: {data.isna().sum()} nan')
  ```

- 중복 금지

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  # 전체 중복
  print(f'all duplicated: {data.duplicated().sum()}')
  # 일부 중복
  print(f'work_order_no duplicated before: {data.duplicated(subset=['work_order_no']).sum()}')  # 작업지시서

  # 중복 제거
  data.drop_duplicates(subset=['work_order_no'], inplace=True)
  '''
  # 첫 행만 유지
  data.drop_duplicates(subset=['work_order_no'], keep='first', inplace=True)
  # 마지막 행만 유지
  data.drop_duplicates(subset=['work_order_no'], keep='last', inplace=True)
  # 중복 다 삭제
  data.drop_duplicates(subset=['work_order_no'], inplace=True)
  '''

  # 중복 제거 확인
  print(f'work_order_no duplicated after: {data.duplicated(subset=['work_order_no']).sum()}')  # 작업지시서
  ```

- 바꿔줘

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data.info()

  data['production_id'] = pd.to_numeric(data['production_id'])
  data['production_date'] = pd.to_datetime(data['production_date'])

  data.info()
  ```

- 날짜 골라먹기

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data['production_date'] = pd.to_datetime(data['production_date'])

  # 유형별 날짜 보기
  data['production_date'].dt.month.value_counts()
  data['production_date'].dt.day.value_counts()
  data['production_date'].dt.hour.value_counts()
  data['production_date'].dt.minute.value_counts()
  data['production_date'].dt.second.value_counts()
  data['production_date'].dt.microsecond.value_counts()
  data['production_date'].dt.day_name().value_counts()
  ```

- 새 컬럼에 날짜 쓰기

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data['production_date'] = pd.to_datetime(data['production_date'])
  data['요일'] = data['production_date'].dt.day_name()

  data.loc[:, 'updated_at':].head().T
  ```

- 시간차 계산, 시간 단위 환산

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data['start_time'] = pd.to_datetime(data['start_time'])
  data['end_time'] = pd.to_datetime(data['end_time'])

  data['lead_time'] = data['end_time'] - data['start_time']
  data['lead_time_seconds'] = data['lead_time'].dt.total_seconds()
  data['lead_time_minutes'] = data['lead_time'].dt.total_seconds() / 60
  data['lead_time_hours'] = data['lead_time'].dt.total_seconds() / 3600

  data.loc[:, 'updated_at':].head().T
  ```

- 조건부 컬럼 생성

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data['defect_rate'] = data['defect_quantity'] / data['actual_quantity']
  data['defect_rate_percent'] = data['defect_rate'] * 100

  data['defect_rate_class'] = np.where(data['defect_rate_percent'] < 5, 'high', 'low')

  data.loc[:, 'updated_at':].head().T
  ```

- 더 자세한 조건 컬럼 생성

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data['defect_rate'] = data['defect_quantity'] / data['actual_quantity']
  data['defect_rate_percent'] = data['defect_rate'] * 100

  data['defect_rate_class'] = np.select([data['defect_rate_percent'] < 1, data['defect_rate_percent'] < 3, data['defect_rate_percent'] < 5], ['S', 'A', 'B'], default='C')

  data.loc[:, 'updated_at':].head().T
  ```

- 넘파이 말고 판다스를 쓰세요

  ```python
  def grade_me(x):
      if x < 1:
          return 'S'
      elif x < 3:
          return 'A'
      elif x < 5:
          return 'B'
      else:
          return 'C'

  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  data['defect_rate'] = data['defect_quantity'] / data['actual_quantity']
  data['defect_rate_percent'] = data['defect_rate'] * 100

  data['defect_rate_class'] = data['defect_rate_percent'].apply(grade_me)

  data.loc[:, 'updated_at':].head().T
  ```

- 카테고리화

  ```python
  data = pd.read_csv(os.path.join(data_route, data_list[4]))

  # 직접 기준 컷
  data['actual_quantity_class'] = pd.cut(data['actual_quantity'], bins=[0, 50, 100, 150, 200], labels=['소', '중', '대', '초대'])
  # n등분 컷
  data['actual_quantity_class'] = pd.qcut(data['actual_quantity'], q=4, labels=['소', '중', '대', '초대'])

  data.loc[:, 'updated_at':].head().T
  ```