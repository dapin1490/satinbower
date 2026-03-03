---
title: "Python 프로그래밍 및 데이터 분석 실무 (2)"
author: dapin1490
date: 2026-02-04 18:00:00 +09:00
categories: [HAE, 파이썬 데이터 분석]
tags: [현대오토에버, 모빌리티, 파이썬, 데이터 분석, 제조 데이터]
render_with_liquid: false
use_math: true
---

# 덤

- `conda env list` 하면 가상환경 목록 볼 수 있다~
- CRUD~ create~ read~ update~ delete~ 데이터베이스의 기본~

# 요약
- **자료구조 · list**
  - 생성·접근·수정 : `list()`, 인덱싱 `temp[3]` `temp[-1]`, 슬라이싱 `temp[2:5]`, 수정 `temp[5]=1000`
  - 멤버십 : `in` / `not in`
  - 요소 추가 : 결합 `+`, `append()`, `extend()`, `insert(i, x)`
  - 요소 제거 : `remove(값)`, `pop()` / `pop(인덱스)`, `del temp[0]`
  - 위치·길이·개수 : `index(값)`, `len()`, `count()`
  - 정렬 : `sort()` / `sort(reverse=True)`, `sorted()` / `sorted(..., reverse=True)`
  - 집계 : `min()` `max()` `sum()`, `any()` `all()`
  - 2차원 접근 : 2차원 리스트 `temp[2][2]`
- **tuple**
  - 불변성 : `temp[0]=2` → TypeError
  - 단일 요소 (7) vs (7,) : 타입 차이 (int vs tuple)
  - 언패킹 : 인덱싱·슬라이싱, `a, b, c, *_ = temp`
- **dict**
  - 키-값 조회 : 키-값 정의, 조회 `temp['id']`
  - 추가·삭제 : `temp['color']='red'`, `del temp['key']` / `pop('key')`
  - 키/값/쌍·비우기 : `keys()`, `values()`, `items()`, `clear()`
- **set**
  - 중복 제거·빈 set : 중복 자동 제거, 빈 set은 `set()` (`{}`는 dict)
  - 요소 추가·제거 : `add()`, `remove()`, `discard()` (없어도 에러 없음)
  - 집합 연산 : 교집합 `&`, 차집합 `-`, 합집합 `|`
- **combination**
  - list 수집 후 set으로 유일값 : list로 중복 허용 수집 후 `set()`으로 유일값 추출
- **제어문 · if**
  - 분기 : `if` / `elif` / `else`
- **for**
  - 반복문 : `for i in temp`, `for i in range(len(temp))`
  - 구간 생성 : `range(10)`, `range(1, 21, 2)` (시작, 끝, step)
- **for + if**
  - 반복 안 조건 분기 : (온도별 주의/정상)
  - 필터링 : 조건 만족하는 값만 리스트에 `append`
  - 중단 : `break` (ERROR STOP 시)
- **while**
  - 조건 반복 : `while 조건:` 예시 (예: `a % b == 0`일 때 나누기 반복)

# 자료구조

## list

- 문자열 슬라이싱과 리스트를 구분하세요

  ```python
  string = "23we4rftghvbn"
  print(string[3])
  print([])
  ```

- 리스트 만들고 써먹기

  ```python
  temp = [123, 12.67, 4567, 546.678, 56, 89.6745, 789]  # 뭔가 있는 리스트 만들기
  list()  # 리스트 함수 # iterable한 것을 넣어줘야 함 # 빈 리스트 생성됨
  print(temp[3])  # 리스트 인덱싱
  print(temp[-1])

  """ 출력
  546.678
  789
  """
  ```

- 요소 바꾸기

  ```python
  print(temp)
  temp[5] = 1000  # 리스트 수정
  print(temp)

  ''' 출력
  [123, 12.67, 4567, 546.678, 56, 89.6745, 789]
  [123, 12.67, 4567, 546.678, 56, 1000, 789]
  '''
  ```

- 리스트 밖에 있는 거 꺼내지 마세요 OutOfRangeError
- 여기 없으면 없는 거예요

  ```python
  temp = [1, 2, 3, 4, 5]
  6 in temp  # False
  3 not in temp  # False
  ```

- 리스트 합치기

  ```python
  temp1 = [1, 2, 3]
  temp2 = [4, 5, 6]
  temp = temp1 + temp2
  print(temp)

  # >>> [1, 2, 3, 4, 5, 6]
  ```

- 하나만 더 넣어줘

  ```python
  temp = [1, 2, 3]
  temp.append(4)
  print(temp)

  # >>> [1, 2, 3, 4]
  ```

- 좀 더 넣어줘

  ```python
  temp = [1, 2, 3]
  temp2 = [4, 5, 6]
  temp.extend(temp2)
  print(temp)

  # >>> [1, 2, 3, 4 , 5, 6]
  ```

- 할라피뇨 빼주세요

  ```python
  sub = ['양상추', '할라피뇨', '피클', '올리브']
  sub.remove('할라피뇨')
  print(sub)

  # >>> ['양상추', '피클', '올리브']
  ```

- 여기까지만 들어오실 수 있고요 이후로 마감입니다 재고소진~

  ```python
  temp = [1, 2, 3, 4, 5, 6]
  temp.pop()  # 6
  print(temp)

  # >>> [1, 2, 3, 4, 5]
  ```

- 너 밴

  ```python
  temp = [1, 2, 3, 4, 5, 6]
  temp.pop(3)  # 4
  print(temp)

  # >>> [1, 2, 3, 5, 6]
  ```

- 너 밴 2

  ```python
  temp = [1, 2, 3, 4, 5, 6]
  del temp[0]
  print(temp)

  # >>> [2, 3, 4, 5, 6]
  ```

- 어디?

  ```python
  temp = [1, 2, 3, 54, 6]
  print(temp.index(54))

  # >>> 3
  ```

- length

  ```python
  temp = [0] * 345
  print(len(temp))

  # >>> 345
  ```

- sort

  ```python
  import random

  temp = [random.randint(1, 100) for _ in range(10)]
  temp.sort()  # 오름차순
  temp.sort(reverse=True)  # 내림차순
  print(temp)  # 출력 생략
  ```

- don’t touch sort

  ```python
  import random

  temp = [random.randint(1, 100) for _ in range(10)]
  sorted(temp)  # 오름차순
  sorted(temp, reverse=True)  # 내림차순
  ```

- stat

  ```python
  import random

  temp = [random.randint(1, 100) for _ in range(100)]
  print(min(temp))
  print(max(temp))
  print(sum(temp))
  print(sum(temp) / len(temp))
  print(any(temp))  # 0이 아닌 게 있는지 # True
  print(all(temp))  # 전부 0이 아님 # True
  ```

- list in list

  ```python
  temp = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  print(temp[2][2])

  # >>> 9
  ```

- clear

  ```python
  temp.clear()
  print(temp)

  # >>> []
  ```


## tuple

```python
temp = (1, 2)
temp[0] = 2  # TypeError
```

- 선언에 주의

  ```python
  (7) == (7,)  # False
  print(type((7)))
  print(type((7,)))
  ```

- 언패킹

  ```python
  temp = (1, 2, 3, 4, 5)
  a, b, c, *_ = temp

  '''
  a = 1
  b = 2
  c = 3
  _ = [4, 5]
  '''
  ```


## dict

- define

  ```python
  temp = {
      'id': 'CNC001',
      'type': 'CNC',
      'temperature': 36.5,
      'is_active': True,
  }
  ```

- call

  ```python
  print(temp['id'])
  ```

- add

  ```python
  temp['color'] = 'red'
  print(temp)
  ```

- del

  ```python
  del temp['color']  # a.k.a temp.pop('color')
  print(temp)
  ```

- show me the dict

  ```python
  print(temp.keys())
  print(temp.values())
  print(temp.items())

  ''' 출력
  dict_keys(['id', 'type', 'temperature', 'is_active'])
  dict_values(['CNC001', 'CNC', 36.5, True])
  dict_items([('id', 'CNC001'), ('type', 'CNC'), ('temperature', 36.5), ('is_active', True)])
  '''
  ```

- clear

  ```python
  temp.clear()
  print(temp)

  # >>> {}
  ```


## set

- define

  ```python
  temp = {1, 2, 3, 34, 5, 56, 46, 47, 7, 6, 6, 6, 6, 6, 6, 6}
  print(temp)

  # >>> {1, 2, 3, 34, 5, 6, 7, 46, 47, 56}
  ```

- do not use empty {}

  ```python
  do_not_empty_set = {}
  print(type(do_not_empty_set))
  do_not_empty_set = set()
  print(type(do_not_empty_set))

  '''
  <class 'dict'>
  <class 'set'>
  '''
  ```

- CRUD

  ```python
  import random

  temp = {random.randint(1, 10) for _ in range(50)}
  temp.add(250)
  print(temp)
  temp.add(250)  # 중복 안 됨
  print(temp)
  temp.remove(10)
  print(temp)
  temp.discard(1000)  # 에러 안 남
  print(temp)
  print(f'len: {len(temp)}')

  '''
  {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 250}
  {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 250}
  {1, 2, 3, 4, 5, 6, 7, 8, 9, 250}
  {1, 2, 3, 4, 5, 6, 7, 8, 9, 250}
  len: 10
  '''
  ```

- 집합 연산

  ```python
  temp1 = {random.randint(1, 50) for _ in range(15)}
  temp2 = {random.randint(1, 50) for _ in range(15)}
  print(temp1)
  print(temp2)
  print(f'교집합: {temp1 & temp2}')
  print(f'차집합: {temp1 - temp2}')
  print(f'합집합: {temp1 | temp2}')

  '''
  {32, 35, 4, 38, 7, 40, 43, 45, 47, 48, 50, 26, 31}
  {3, 35, 5, 37, 7, 8, 36, 44, 46, 15, 16, 17, 50, 21, 29}
  교집합: {50, 35, 7}
  차집합: {32, 4, 38, 40, 43, 45, 47, 48, 26, 31}
  합집합: {3, 4, 5, 7, 8, 15, 16, 17, 21, 26, 29, 31, 32, 35, 36, 37, 38, 40, 43, 44, 45, 46, 47, 48, 50}
  '''
  ```


# 조합 활용

```python
import random

total = []  # list: duplication OK
for _ in range(10):
  total.append(random.randint(1, 5))
print(total)

net = set(total)  # no duplication
print(net)

'''
[1, 5, 1, 1, 1, 4, 3, 1, 4, 5]
{1, 3, 4, 5}
'''
```

# 문제 풀어보세요

https://github.com/macro0630/smart-practice/blob/main/02_practice.md

# if

- 최소한의 조건문

  ```python
  import random

  temp = random.randint(180, 200)

  if temp > 190:
      print("온도가 높습니다.")
  print(f'온도는 {temp}도 입니다.')
  ```

- 좀 더 조건문

  ```python
  import random

  temp = random.randint(1, 3)

  if temp <= 1:
      print("상태 1")
  elif temp <= 2:
      print("상태 2")
  else:
      print("상태 3")
  ```


# for

- 리스트를 꺼내 쓰는 for

  ```python
  temp = [chr(i) for i in range(65, 65+10)]

  for i in temp:
      print(i, end=", ")
  ```

- 인덱스만 쓰는 for

  ```python
  temp = [chr(i) for i in range(65, 65+10)]

  for i in range(len(temp)):
      print(i, temp[i], sep=": ")
  ```


# for if

- for 안에 if

  ```python
  import random

  temp = [random.randint(180, 200) for _ in range(20)]

  for i in temp:
      print(i, end=": ")
      if i > 190:
          print("주의")
      else:
          print("정상")
  ```

- 반복문을 위한 range 생성

  ```python
  lis = range(10)
  print(list(lis))

  lis = range(1, 20+1, 2)
  print(list(lis))

  ''' 출력
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
  '''
  ```

- 골라담기

  ```python
  import random

  random_floats = [round(random.random() + random.randint(0, 10), 2) for _ in range(10)]

  print(random_floats)

  lis = []

  for i in random_floats:
      if i <= 5:
          lis.append(i)

  print(lis)

  ''' 출력
  [3.19, 5.05, 2.78, 8.58, 8.49, 1.72, 8.76, 4.07, 2.38, 1.14]
  [3.19, 2.78, 1.72, 4.07, 2.38, 1.14]
  '''
  ```

- 긴급탈출

  ```python
  from random import randint as rint

  temp = [bool(rint(0, 4)) for _ in range(10)]
  temp[0] = True
  temp[-1] = False

  print(temp, '\n')

  for i in range(len(temp)):
      if not temp[i]:
          print(f'{i}: ERROR STOP')
          break
      print(f'{i}: CONTINUE')

  ''' 출력
  [True, True, True, True, False, True, False, True, True, False]

  0: CONTINUE
  1: CONTINUE
  2: CONTINUE
  3: CONTINUE
  4: ERROR STOP
  '''
  ```


# while

- 만족하지 않으면 못나가는 방

  ```python
  a = 2 ** 5 * 7 ** 3 * 11 ** 2
  b = 2
  cnt = 0

  print(f'init: {a}')

  while a % b == 0:
      a //= b
      cnt += 1

  print(f'end: {a}, how many 2s: {cnt}')

  '''
  init: 1328096
  end: 41503, how many 2s: 5
  '''
  ```


# 문제 풀어보세요 (for)

https://github.com/macro0630/smart-practice/blob/main/03_practice.txt