---
title: "Python 프로그래밍 및 데이터 분석 실무 (1)"
author: dapin1490
date: 2026-02-03 18:00:00 +09:00
categories: [HAE, 파이썬 데이터 분석]
tags: [현대오토에버, 모빌리티, 파이썬, 데이터 분석, 제조 데이터]
render_with_liquid: false
use_math: true
---

# 덤

- 모르면 찾으세요 구글링하세요 document를 읽으세요
    - 예전엔 저게 정석인데 지금은 아니에요 LLM 시키세요^^ 종일 서치하면 안됩니다
    - 아 나 너무 맘에 안들어요 교차검증이 기본 아니냐고요
- 코드는 컴퓨터가 보는 거고요
    - 데이터는 님들 상사가 볼겁니다
    - 그럼 뭐다? 코드는 컴퓨터한테 맞게 써줘야 하고요 데이터는 사람한테 맞게 써줘야 합니다
- 강사님 크롬 좋아하심
- 데이터 분석은요 어떻게 작업을 하냐면요
    - 코드 짜놓고 실행하고 끝! 이거 아님
    - 컴퓨터랑 사람이랑 티키타카가 있어야 한다 채팅처럼 주고받고가 있어야 한다고요
    - 쭉 코드 써놓고 실행 짜잔 하고 데이터 분석했다 하면 사기입니다
    - 그렇게 해서 나온 인사이트를 그래프로 뽑아서 상부에 갖다주라는 거임
    - 주피터 쓰세요
- 프로그래밍 언어에서 쓰는 등호(1개)에는 “대입 연산자”라는 이름이 있어요 “는 기호”가 아닙니다 이름을 똑바로 부릅시다
- 변수명 한글로 짓지 마세요
    - 사실 아는데 오늘 너무 귀찮아서 한글명 썼음 양해받겠음

## 파이썬 되게 이상한 언어예요

```python
# 개발자 2명이 자리를 바꾸려면 의자는 3개가 필요하다
a = 5; b = 3
a, b = b, a
print(f"a: {a}, b: {b}")
# >>> a: 3, b: 5

# 정수 나누면 자동으로 float 됨
정수 = int(10)
정수 /= 2
print(type(정수))
# >>> <class 'float'>

# 리스트가 복제가 돼
lis = [0] * 10
print(lis)
# >>> [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

# 리스트 안에 반복문이 들어간다고요 <- 리스트 컴프리헨션 검색하세요
lis = [[0] * 5 for _ in range(5)]
print(lis)
# >>> [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]

# 자유로운 변수 정체성
this_was_string = "string"
print(type(this_was_string))
this_was_string = 42
print(type(this_was_string))
# >>> <class 'str'>
# >>> <class 'int'>

# 문자열은 사실 리스트입니다
text = "abcdefghijklmnopqrstuvwxyz"
for char in text:
    print(char, end="")
# >>> abcdefghijklmnopqrstuvwxyz

# 숫자가 길어서 읽기 불편하신가요?
money1 = 1_000_000_000
money2 = 1000000000
print(money1 == money2)
# >>> True

# 비교할 것이 많다고요? 한번에 쓰세요
print(1 < 2 < 3 < 4 < 5 < 6)
# >>> True
```

# 요약
- **가상환경 생성·활성화**: `conda create -n HAEpydata`, `conda activate`, `conda init bash`
- **변수와 자료형** ("파이썬 되게 이상한 언어예요") : 변수 스왑(`a, b = b, a`), 정수 나누기→float, 리스트 복제(`[0]*10`), 리스트 컴프리헨션(`[[0]*5 for _ in range(5)]`), 변수 타입 변경, 문자열 순회, 숫자 언더스코어(`1_000_000_000`), 연쇄 비교(`1 < 2 < 3`)
- **변수와 자료형** (실제 수업 내용) : 변수·타입 정리 · 한글 변수명, 문자열/따옴표, `type()`, 지수 표기(`314e-2`), `int()`/`float()` 변환(형변환)
- **연산자** : 산술 연산자 · `+` `-` `*` `/` `//`(몫) `%`(나머지) `**`(거듭제곱), 연산 우선순위(괄호)
- **문자열 처리**
	- 여러 줄 문자열 : `"""`
	- 인덱싱·슬라이싱 : `[0]` `[-1]` `[5:]` `[:5]` `[3:6]` `[::2]` `[::-1]`
	- 연결·반복 : `+`, `*`
	- 대소문자 변환 : `upper()` / `lower()`
	- 공백 제거 : `strip()`, `lstrip()`, `rstrip()`
	- 검색·개수·치환 : `find()`, `count()`, `replace()`, `replace(..., 3)`
	- 앞·뒤 일치 확인 : `startswith()`, `endswith()`
	- 분리·합치기 : `split()`, `join()`
	- 공백 여부 : `isspace()`
	- 포맷팅 : `%` 연산자, `format()`, f-string, `round()`
- **비교 연산자** : 비교 연산 · `==` `!=` `>` `<` `>=` `<=`, 문자열 비교, 연쇄 비교
- **논리 연산자** : 논리 연산 · `and`, `or`, `not` · "데이터 골라서 보는" 조건 예시(딕셔너리 + 조건)
- **None** : None 타입 · `NoneType`, `None` 다루기

# 환경 세팅

1. 영어 사용자명으로 된 윈도우 계정 준비
2. 미니콘다 설치
3. 깃 설치
4. 가상환경 생성: `conda create -n {venv_name} python=3.10 numpy pandas matplotlib seaborn jupyter`
5. 노트북 생성: `jupyter notebook .` → 현재 디렉토리에 주피터 노트북 열기. 기본 브라우저로 실행됨.
    - 데이터 분석은 주피터 노트북 쓴다 하시지만 난 그냥 vscode ipynb 쓰겠음
6. 워크스페이스 골라서 들어가기: 뭐 지금은 문서 폴더 쓸거지만 나중에 깃 쓰시든가 하세요. 일단 문서 폴더에 새 폴더 하나 만들어서 쓰겠습니다 → 이제 윈도우 파일탐색기에 똑같이 찾아가보면 새로 만든 폴더가 있죠? 아이 신기해
7. 드디어 첫 ipynb 생성함 여기까지 2시간 걸림

# 변수와 자료형

- 셀 클릭 후 시프트 엔터 → 실행 후 아래 새 셀 생성 / 컨트롤 엔터 → 셀 실행만 함
- 개인 팁: 셀 마지막 줄에 오는 코드는 굳이 print 안붙여도 출력된다
- 쓰레기통 아이콘 누르면 셀 삭제되죠~
- 변수 선언하기

  ```python
  고등어 = 3_000
  단위 = 3
  총_가격 = 고등어 * 단위
  print(f"고등어 {단위}마리의 총 가격은 {총_가격}원 입니다.")
  ```

- 문자열 쓰기

  ```python
  이것은문자열이다 = "이것은 문자열이다"
  이것도문자열이다 = '작은따옴표를 써도 문자열이다'
  한글자도문자열이다 = 'ㅖ'
  한글자큰따옴표도문자열이다 = "ㅖ"

  print(str == type(이것은문자열이다) == type(이것도문자열이다) == type(한글자도문자열이다) == type(한글자큰따옴표도문자열이다))
  # >>> True
  ```

- 긴 숫자에 언더스코어

  ```python
  긴숫자엔언더스코어를쓰세요 = 1_000_000_000
  print(긴숫자엔언더스코어를쓰세요)
  # >>> 1000000000
  ```

- 과학적인 소수 표기법

  ```python
  소수표기법을익히세요 = 314e-2
  print(소수표기법을익히세요)
  # >>> 3.14
  ```


# 연산자

```python
# +
print(f"500 + 300 = {500 + 300}")
# -
print(f"500 - 300 = {500 - 300}")
# 곱셈
print(f"500 * 300 = {500 * 300}")
# 나눗셈
print(f"500 / 300 = {500 / 300}")
# 몫
print(f"500 // 300 = {500 // 300}")
# 나머지
print(f"500 % 300 = {500 % 300}")
# 거듭제곱
print(f"500 ** 3 = {500 ** 3}")

""" 출력
500 + 300 = 800
500 - 300 = 200
500 * 300 = 150000
500 / 300 = 1.6666666666666667
500 // 300 = 1
500 % 300 = 200
500 ** 3 = 125000000
"""
```

- 사칙연산 우선순위는 사람이 아는 것과 동일하게 적용된다

  ```python
  num = 3000
  print(f"(num - 500) * 3 = {(num - 500) * 3}")
  print(f"num * 3 - 500 = {num * 3 - 500}")
  print(f"num - 500 * 3 = {num - 500 * 3}")

  """ 출력
  (num - 500) * 3 = 7500
  num * 3 - 500 = 8500
  num - 500 * 3 = 1500
  """
  ```


# 데이터 타입

- `type()`을 쓰면 변수의 타입을 알 수 있다. `type()` 자체는 함수다.
- 형 변환

  ```python
  사실숫자임 = "50"
  print(type(사실숫자임))
  사실숫자임 = int(사실숫자임)
  print(type(사실숫자임))

  """ 출력
  <class 'str'>
  <class 'int'>
  """
  ```

- 타입 똑바로 보고 연산하세요

  ```python
  문자열 = "123" * 3
  print(문자열)
  숫자 = 123 * 3
  print(숫자)

  """ 출력
  123123123
  369
  """
  ```

- 형 변환 연산 종합

  ```python
  숫자 = "123"
  print(type(숫자))
  print(숫자 * 3)

  숫자 = float(숫자)
  print(type(숫자))
  print(숫자 * 3)

  """ 출력
  <class 'str'>
  123123123
  <class 'float'>
  369.0
  """
  ```


# 문자열 처리

- 긴 문자열 쓰기

  ```python
  긴문자열쓰기 = """계절이 지나가는 하늘에는
  가을로 가득 차 있습니다.

  나는 아무 걱정도 없이
  가을 속의 별들을 다 헤일 듯합니다."""
  ```

- 인덱싱

  ```python
  text = "0123456789"
  print(f"text[0]\t\t{text[0]}")
  print(f"text[-1]\t{text[-1]}")
  print(f"text[5:]\t{text[5:]}")
  print(f"text[:5]\t{text[:5]}")
  print(f"text[3:6]\t{text[3:6]}")
  print(f"text[::2]\t{text[::2]}")
  print(f"text[1::2]\t{text[1::2]}")
  print(f"text[::-1]\t{text[::-1]}")
  print(f"text[-3:-1]\t{text[-3:-1]}")

  """출력
  text[0]     0
  text[-1]    9
  text[5:]    56789
  text[:5]    01234
  text[3:6]   345
  text[::2]   02468
  text[1::2]  13579
  text[::-1]  9876543210
  text[-3:-1] 78
  """
  ```

- 반복하기

  ```python
  seper = "*"
  print(seper * 10)

  """
  **********
  """
  ```

- 대소문자

  ```python
  text = "AbCdeFghIjklMNopQRsTuvWxyz"
  print(text)
  print(text.upper())
  print(text.lower())

  """ 출력
  AbCdeFghIjklMNopQRsTuvWxyz
  ABCDEFGHIJKLMNOPQRSTUVWXYZ
  abcdefghijklmnopqrstuvwxyz
  """
  ```

- 앞뒤 공백 지우기

  ```python
  text_to_strip = "   Hello, World!   "
  print(f"original: '{text_to_strip}'")
  print(f"stripped: '{text_to_strip.strip()}'")
  print(f"left stripped: '{text_to_strip.lstrip()}'")
  print(f"right stripped: '{text_to_strip.rstrip()}'")

  """ 출력
  original: '   Hello, World!   '
  stripped: 'Hello, World!'
  left stripped: 'Hello, World!   '
  right stripped: '   Hello, World!'
  """
  ```

- 문자열 찾기, 갯수세기, 바꾸기

  ```python
  text = "계절이 지나가는 하늘에는 가을로 가득 차 있습니다.  나는 아무 걱정도 없이 가을 속의 별들을 다 헤일 듯합니다.  가슴속에 하나둘 새겨지는 별을 이제 다 못 헤는 것은 쉬이 아침이 오는 까닭이요, 내일 밤이 남은 까닭이요, 아직 나의 청춘이 다하지 않은 까닭입니다.  별 하나에 추억과 별 하나에 사랑과 별 하나에 쓸쓸함과 별 하나에 동경과 별 하나에 시와 별 하나에 어머니, 어머니,  어머님, 나는 별 하나에 아름다운 말 한마디씩 불러 봅니다. 소학교 때 책상을 같이 했던 아이들의 이름과, 패, 경, 옥, 이런 이국 소녀들의 이름과, 벌써 아기 어머니 된 계집애들의 이름과, 가난한 이웃 사람들의 이름과, 비둘기, 강아지, 토끼, 노새, 노루, '프랑시스 잠', '라이너 마리아 릴케' 이런 시인의 이름을 불러 봅니다.  이네들은 너무나 멀리 있습니다. 별이 아스라이 멀듯이.  어머님, 그리고 당신은 멀리 북간도에 계십니다.  나는 무엇인지 그리워 이 많은 별빛이 내린 언덕 위에 내 이름자를 써 보고 흙으로 덮어 버리었습니다.  딴은 밤을 새워 우는 벌레는 부끄러운 이름을 슬퍼하는 까닭입니다.  그러나 겨울이 지나고 나의 별에도 봄이 오면 무덤 위에 파란 잔디가 피어나듯이 내 이름자 묻힌 언덕 위에도 자랑처럼 풀이 무성할 거외다."

  print(f"- find '가을': {text.find('가을')}")  # >>> 14
  print(f"- count '별': {text.count('별')}")  # >>> 12
  print(f"- replace '별' with '⭐': {text.replace('별', '⭐')}")
  print(f"- replace '별' with '⭐' 3개만: {text.replace('별', '⭐', 3)}")

  """ 출력
  - find '가을': 14
  - count '별': 12
  - replace '별' with '⭐': 계절이 지나가는 하늘에는 가을로 가득 차 있습니다.  나는 아무 걱정도 없이 가을 속의 ⭐들을 다 헤일 듯합니다.  가슴속에 하나둘 새겨지는 ⭐을 이제 다 못 헤는 것은 쉬이 아침이 오는 까닭이요, 내일 밤이 남은 까닭이요, 아직 나의 청춘이 다하지 않은 까닭입니다.  ⭐ 하나에 추억과 ⭐ 하나에 사랑과 ⭐ 하나에 쓸쓸함과 ⭐ 하나에 동경과 ⭐ 하나에 시와 ⭐ 하나에 어머니, 어머니,  어머님, 나는 ⭐ 하나에 아름다운 말 한마디씩 불러 봅니다. 소학교 때 책상을 같이 했던 아이들의 이름과, 패, 경, 옥, 이런 이국 소녀들의 이름과, 벌써 아기 어머니 된 계집애들의 이름과, 가난한 이웃 사람들의 이름과, 비둘기, 강아지, 토끼, 노새, 노루, '프랑시스 잠', '라이너 마리아 릴케' 이런 시인의 이름을 불러 봅니다.  이네들은 너무나 멀리 있습니다. ⭐이 아스라이 멀듯이.  어머님, 그리고 당신은 멀리 북간도에 계십니다.  나는 무엇인지 그리워 이 많은 ⭐빛이 내린 언덕 위에 내 이름자를 써 보고 흙으로 덮어 버리었습니다.  딴은 밤을 새워 우는 벌레는 부끄러운 이름을 슬퍼하는 까닭입니다.  그러나 겨울이 지나고 나의 ⭐에도 봄이 오면 무덤 위에 파란 잔디가 피어나듯이 내 이름자 묻힌 언덕 위에도 자랑처럼 풀이 무성할 거외다.
  - replace '별' with '🌠' 3개만: 계절이 지나가는 하늘에는 가을로 가득 차 있습니다.  나는 아무 걱정도 없이 가을 속의 🌠들을 다 헤일 듯합니다.  가슴속에 하나둘 새겨지는 🌠을 이제 다 못 헤는 것은 쉬이 아침이 오는 까닭이요, 내일 밤이 남은 까닭이요, 아직 나의 청춘이 다하지 않은 까닭입니다.  🌠 하나에 추억과 별 하나에 사랑과 별 하나에 쓸쓸함과 별 하나에 동경과 별 하나에 시와 별 하나에 어머니, 어머니,  어머님, 나는 별 하나에 아름다운 말 한마디씩 불러 봅니다. 소학교 때 책상을 같이 했던 아이들의 이름과, 패, 경, 옥, 이런 이국 소녀들의 이름과, 벌써 아기 어머니 된 계집애들의 이름과, 가난한 이웃 사람들의 이름과, 비둘기, 강아지, 토끼, 노새, 노루, '프랑시스 잠', '라이너 마리아 릴케' 이런 시인의 이름을 불러 봅니다.  이네들은 너무나 멀리 있습니다. 별이 아스라이 멀듯이.  어머님, 그리고 당신은 멀리 북간도에 계십니다.  나는 무엇인지 그리워 이 많은 별빛이 내린 언덕 위에 내 이름자를 써 보고 흙으로 덮어 버리었습니다.  딴은 밤을 새워 우는 벌레는 부끄러운 이름을 슬퍼하는 까닭입니다.  그러나 겨울이 지나고 나의 별에도 봄이 오면 무덤 위에 파란 잔디가 피어나듯이 내 이름자 묻힌 언덕 위에도 자랑처럼 풀이 무성할 거외다.
  """
  ```

- 문자열 접두사와 접미사 확인

  ```python
  file_name = "data_20230630.csv"
  print(file_name.startswith("data_"))
  print(file_name.endswith(".csv"))

  """ 출력
  True
  True
  """
  ```

- 문자열 분리

  ```python
  print(text.split())
  print(text.split(","))

  # 출력 생략
  ```

- 문자열 분리 응용

  ```python
  temp = "ArithmeticError, ValueError,IndexError, KeyError,NameError"
  temp_lis = temp.replace(", ", ",").split(",")
  print(temp_lis)

  # >>> ['ArithmeticError', 'ValueError', 'IndexError', 'KeyError', 'NameError']
  ```

- 문자열 붙이기

  ```python
  temp = ", ".join(temp_lis)
  print(temp)

  # >>> ArithmeticError, ValueError, IndexError, KeyError, NameError
  ```

- 이거 공백이에요?

  ```python
  print("     ".isspace())
  print("   .  ".isspace())

  # >>> True
  # >>> False
  ```

- 문자열 포맷팅

  ```python
  name = "thisisname"
  num = 234567.34589

  # (1)
  print("name: %s, num: %.2f" % (name, num))

  # (2)
  print("name: {}, num: {:.2f}".format(name, num))

  # (3)
  print(f"name: {name}, num: {num:.2f}")

  # (4)
  print(f"name: {name}, num: {round(num * 10 / 10, 2)}")

  # 모든 출력은 다음과 같이 동일
  # >>> name: thisisname, num: 234567.35
  ```


# 문제 풀어보세요

> https://github.com/macro0630/smart-practice/blob/main/01_practice.md

# 비교 연산자

- 기본적인 비교 연산자들

  ```python
  print(f"5 == 5\t{5 == 5}")
  print(f"5 != 3\t{5 != 3}")
  print(f"10 > 7\t{10 > 7}")
  print(f"4 < 2\t{4 < 2}")
  print(f"6 >= 6\t{6 >= 6}")
  print(f"3 <= 1\t{3 <= 1}")

  """ 출력
  5 == 5  True
  5 != 3  True
  10 > 7  True
  4 < 2   False
  6 >= 6  True
  3 <= 1  False
  """
  ```

  ```python
  lj = 20
  print("'a' == 'a'".ljust(lj), f"{'a' == 'a'}")
  print("'abc' != 'ABC'".ljust(lj), f"{'abc' != 'ABC'}")
  print("'apple' > 'banana'".ljust(lj), f"{'apple' > 'banana'}")
  print("'cat' < 'dog'".ljust(lj), f"{'cat' < 'dog'}")
  print("'hello' >= 'hello'".ljust(lj), f"{'hello' >= 'hello'}")
  print("'world' <= 'word'".ljust(lj), f"{'world' <= 'word'}")

  """ 출력
  'a' == 'a'           True
  'abc' != 'ABC'       True
  'apple' > 'banana'   False
  'cat' < 'dog'        True
  'hello' >= 'hello'   True
  'world' <= 'word'    False
  """
  ```

- 복합 논리 연산

  ```python
  human_1 = {
      'name': 'Alice',
      'age': 30,
      'city': 'Seoul',
      'married': True,
      'gender': 'female',
      'child': None,
      'spend_per_month': 1500000
  }

  print(human_1['age'] > 33 and human_1['city'] == 'Seoul' and human_1['married'] and human_1['gender'] == 'female')  # False
  ```

- 기본 논리 연산

  ```python
  print(f"T and T: {True and True}")
  print(f"T and F: {True and False}")
  print(f"F and T: {False and True}")
  print(f"F and F: {False and False}")
  print()
  print(f"T or T: {True or True}")
  print(f"T or F: {True or False}")
  print(f"F or T: {False or True}")
  print(f"F or F: {False or False}")

  """ 출력
  T and T: True
  T and F: False
  F and T: False
  F and F: False

  T or T: True
  T or F: True
  F or T: True
  F or F: False
  """
  ```

- 좀 더 단순한 복합 논리 연산

  ```python
  print(f"T and T and T: {True and True and True}")
  print(f"T and T and F: {True and True and False}")
  print(f"T and F or T: {True and False or True}")
  print(f"F or F and T: {False or False and True}")
  print(f"not T: {not True}")

  """ 출력
  T and T and T: True
  T and T and F: False
  T and F or T: True
  F or F and T: False
  not T: False
  """
  ```

# None은 None이다

```python
print(type(None))
# >>> <class 'NoneType'>
```