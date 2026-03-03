---
title: "VibLow master 프로그램 기초 사용법"
author: dapin1490
date: 2026-01-28 18:10:00 +09:00
categories: [HAE, note]
tags: [진동, VibLow master, 진동 분석]
render_with_liquid: false
use_math: true
---

- 만약 오류가 나면서 실행이 안되면 관리자 권한으로 실행해보기
- 하드웨어 정보: <https://nada.co.kr/viblow-cxii-plus-2>
- 카탈로그: <https://nada.co.kr/wp-content/uploads/2025/03/NADA-VibLow7000-Catalog_KR_2025.pdf>  
    ![](/assets/img/category-HAE/260128-HAE-1-VibLow-master.png)
- 8개의 포트 자유 사용 가능
- 포터블 센서로 쓸 때는 센서 밑에 자석이 들어간 밑바닥을 끼워서 금속성 설비에 붙였다 뗐다 한다.
- 케이블은 돌려서 연결
- 이번 강의에 동원된 장비는 USB로 전원을 공급함. 노트북에서 장비로 그냥 USB 꽂으면 됨.
- 근데 데이터는 랜선으로 받음.
- 센서, 케이블, USB, 랜선 꽂으면 기본 세팅은 된거임

---

- 이제 프로그램 실행하기 (안되면 관리자 권한으로 실행)
- open factory  
    ![](/assets/img/category-HAE/260128-HAE-2-VibLow-master.png)  
- 공장 아무거나 추가

    <div style="column-count: 2"><img src="/assets/img/category-HAE/260128-HAE-3-VibLow-master.png"/><img src="/assets/img/category-HAE/260128-HAE-4-VibLow-master.png"/></div>

- 공장에 공정 추가

    <div style="column-count: 2"><img src="/assets/img/category-HAE/260128-HAE-5-VibLow-master.png"/><img src="/assets/img/category-HAE/260128-HAE-6-VibLow-master.png"/></div>

- 설비 추가

    <div style="column-count: 2"><img src="/assets/img/category-HAE/260128-HAE-7-VibLow-master.png"/><img src="/assets/img/category-HAE/260128-HAE-8-VibLow-master.png"/></div>

- 측정 포인트 추가

    <div style="column-count: 3">
        <img src="/assets/img/category-HAE/260128-HAE-9-VibLow-master.png"/>
        <img src="/assets/img/category-HAE/260128-HAE-10-VibLow-master.png"/>
        <img src="/assets/img/category-HAE/260128-HAE-11-VibLow-master.png"/>
    </div>

    이름 쓰고 추가 누르기

    ![](/assets/img/category-HAE/260128-HAE-12-VibLow-master.png)

- 채널 설정  
    ![](/assets/img/category-HAE/260128-HAE-13-VibLow-master.png)
- 채널 연결 확인 후 그래프 버튼 누르면 저렇게 나옴  
    ![](/assets/img/category-HAE/260128-HAE-14-VibLow-master.png)
- f1: 측정 시작
- f3: 측정 종료
- 원하는 그래프에 우클릭하면 스케일 조정 가능
- save 누른 후 측정하기. 하다 말고 esc 누르면 거기까지만 측정함  
    ![](/assets/img/category-HAE/260128-HAE-15-VibLow-master.png)  
- 센서 변환해서 보는 버튼  
    ![](/assets/img/category-HAE/260128-HAE-16-VibLow-master.png)  
    이거 가속도 받아서 속도로 변환해서 나온거임  
    ![](/assets/img/category-HAE/260128-HAE-17-VibLow-master.png)  
- 라인 수는 데이터의 해상도, 용량, 처리 속도와 관련이 있음  
    ![](/assets/img/category-HAE/260128-HAE-18-VibLow-master.png)  
    - 내가 보려는 주파수 구간이 0~3200인데 라인 수를 3200으로 설정하면 1Hz 단위로만 볼 수 있는 거임. 6400라인으로 설정하면 0.5Hz 단위로 볼 수 있게 됨. 데이터를 얼마나 자세히 볼 지 정할 수 있지만 자세히 보면 당연히 용량이 늘어나고 처리가 오래 걸리겠죠?
    - auto range는 다이나믹 range라고 해서, 제일 작은 신호와 제일 큰 신호를 모두 볼 수 있는 범위를 말함. 이걸 항상 켜두는 건 비효율적임. 원하는 관심 범위가 있는데 그걸 넘어서서 과하게 큰 범위를 표시하는 건 연산 자원도 비효율적이고 보기도 불편함.
    - 트리거 설정을 할 수가 있어요. 1번 채널을 트리거로 해두고 나머지 채널로 데이터 수집을 시켜요. 이렇게 하게 되면 외부의 동작과 연계해서 데이터를 받을 수 있어요. 트리거 발생 즉시 수집하는 방법(프리 트리거)이 있고, 지연시간을 주는 방법(포스트 트리거)이 있다. 이게 무슨 의미가 있느냐? 어떤 설비가 기동하기 시작할 때 발생하는 화이트노이즈성 충격을 스킵하고 안정된 설비 데이터만 받을 수 있다.
        - 프리 트리거는 이벤트 단위로 설정돼서 특정 상황의 이전 시점부터 미리 정보를 수집하는 데에 쓰이기도 한다
    - 주파수 범위와 라인 수의 상관관계
        - 3200Hz와 3200라인 → 1초에 한번 계산됨
        - 3200Hz와 12800라인 → 4초에 한번 계산됨
        - 뭔말알?

            $$\text{데이터 수집 시간(Time)} = \frac{\text{라인 수(Lines)}}{\text{주파수 범위}(F_{max})}$$

- 하드웨어 오프셋은 지금은 자동으로 되니까 굳이 설정할 필요 없다
- 워터폴은 트렌드 분석 목적
- 하모닉  
    ![](/assets/img/category-HAE/260128-HAE-19-VibLow-master.png)  
    - 하모닉은 n배수와 분수 조화 성분 표시하기 설정임. 여기서는 분수조화성분은 1/2만 되는데 강사님이 해보시니까 분수조화성분은 표시도 안된다고 하심.
    - 오버랩은  FFT 계산 시간을 줄이고 데이터의 연속성을 좀 더 살리기 위해 사용하는 것. 방금 계산한 데이터의 일부분을 재활용해서 다음 계산에 같이 쓴다. 어차피 윈도우 함수가 끄트머리를 눌러주기 때문에 데이터 상에 큰 문제를 일으키지 못한다.  
        이게 원래는 예전에 처리 속도에 한계가 있어서 오버랩 없이 처리하면 계산하는 시간 동안 신호가 비는 구간이 생겨서 그랬는데, 지금은 연산 능력이 충분히 좋아서 굳이 오버랩 안 써도 된다.
- 그래프 단축키  
    ![](/assets/img/category-HAE/260128-HAE-20-VibLow-master.png)  
- zooming: 데이터를 좀 더 자세하게 보는건데 최소한의 시간이 필요해서 일정 시간 이상 데이터를 받지 않으면 활성화되지 않음
- envelop  
    “주기적인 고주파 성분”에 모자를 씌워서 그것만 필터링함 → 기어 치손상이나 베어링 손상 보는 데 적합  
    그냥 주파수 그래프를 확인하는 것보다 훨씬 깔끔하게 나온다  
- 핸드폰 알람으로 진동 발생시키고 그 위에 센서를 얹어서 수집한 데이터.
    1. 센서가 아예 고정되지 않아 생기는 폰과 센서의 부딪힘에 의한 진동이 같이 측정되었을 거라 짐작됨
    2. 당연 핸드폰 자체의 진동수가 측정되었을 것
    3. 아래쪽 타임 도메인 그래프에서는 핸드폰의 진동 패턴을 볼 수 있다: 길게 - 짧게 - 짧게
    4. 위쪽 주파수 도메인 그래프에서는 160Hz 단위로 피크가 나온다. 160, 320, 480 등등…
    5. 타임도메인 마지막 부분에 보이는 불규칙하고 큰 진동은 센서가 폰에서 미끄러지길래 이참에 폰에다가 센서를 비벼본 것. 아마도 드륵드륵 하는 진동이 녹화되었을 거라 짐작됨.  
    ![](/assets/img/category-HAE/260128-HAE-21-VibLow-master.png)