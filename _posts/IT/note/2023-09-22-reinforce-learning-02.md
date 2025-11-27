---
title: "[강화학습] 2주 수업"
author: dapin1490
date: 2023-09-22 17:31:00 +09:00
categories: [IT, note]
tags: [지식, IT, 강화학습]
render_with_liquid: false
---

### tabel of contents
- [markov decision process](#markov-decision-process)
- [world와 에이전트](#world와-에이전트)
- [Partial Observation](#partial-observation)
- [Bandit](#bandit)
- [types of sequential decision process](#types-of-sequential-decision-process)
- [강화학습](#강화학습)
  - [model](#model)
  - [policy](#policy)
  - [value function](#value-function)
- [types of agents](#types-of-agents)
- [책 예제 3.3 recycling robot](#책-예제-33-recycling-robot)
- [다음 주](#다음-주)

## markov decision process
이번에 할 내용은 finite한 decision process.

* world와 에이전트의 관계, 책에서 다루는 몇 가지 수식
* 보상 시스템과 예제
* policy → 3주차에 이어서 배움

## world와 에이전트
에이전트와 월드는 서로가 서로에게 영향을 주며 닫힌 루프를 이룬다. 이를 식으로 나타내면 다음과 같다.

p(S', r &#124; s, a) = p<sub>r</sub>{S<sub>t</sub> = s', R<sub>t</sub> = r, S<sub>t-1</sub> = s, A<sub>t-1</sub> = a}

* `|`: conditional probability
* p(A &#124; B) = p(A ⋂ B) / p(B)
* `≐`: definition
* p: probability
* S': next step

지금 상태와 지금 하는 행동이라는 조건 하에 월드에서 리워드가 발생하고, 다음 상태가 정의된다. 위 식은 `다음 상태가 S'으로 정의되고 보상을 받을 확률`이 `현재 상태, 에이전트가 월드에 대해 한 행동에 대해, 월드가 에이전트에게 주는 리워드가 정해지고, 이로 인해 특정 상태가 결정될 확률`과 같다는 뜻이다. *<span class="grey">솔직히 무슨 말인지 잘 모르겠는데 일단은 그렇구나 함</span>*

에이전트가 하는 행동이 월드에 영향을 끼치고, 월드는 객관적인 관측값이 나타난다. 이에 의해 사용자가 정의한 보상이 주어진다. 이런 시스템 하에서 에이전트와 월드는 각각 자신의 상태를 갖는다. 여기서 월드의 상태는 잠깐 빼두고, 에이전트의 상태를 S<sub>t</sub>라고 하자. 과거부터 지금까지 쭉 있었던 S<sub>t</sub>가 history, h<sub>t</sub>로 정의되고, 이는 과거의 행동, 리워드, 관측값을 모두 포함한다. 정보량이 아주 많다는 뜻이다.

마르코프 가정은 과거의 모든 정보가 현재 상태에 다 녹아들어 있다는 가정을 한다.

p(S<sub>t+1</sub> &#124; S<sub>t</sub> a<sub>t</sub>) = p(S<sub>t+1</sub> &#124; h<sub>t</sub> a<sub>t</sub>)

위 식에서 좌변을 보면 현재 상태인 S<sub>t</sub>와 에이전트가 월드에 하는 행동인 a<sub>t</sub>가 있으면 월드는 관측값 o<sub>t</sub>와 보상 r<sub>t</sub>를 준다. 보상과 관측값은 다음 상태를 결정하기 위한 확률을 의미하게 된다.

우변을 보면 똑같이 에이전트와 월드가 있고, 에이전트가 월드에 행동을 할 건데, h<sub>t</sub>가 에이전트의 과거의 모든 정보를 갖는다. h<sub>t</sub>에는 행동, 보상, 관측값이 포함된다.

좌변과 우변이 같다는 말은 현재 상태인 S<sub>t</sub>에 과거의 모든 정보가 녹아있어야만 가능하다. 고로 S<sub>t</sub> = h<sub>t</sub>인 경우를 마르코프 가정이라고 한다.

하지만 현실적으로 사례를 따져보면 마르코프 가정은 성립하지 않는다. 유튜브 추천 동영상을 볼 때, 지금 보고 있는 영상이 다음 영상을 무조건적으로 결정하지 않는다. 건강 검진을 할 때, 지금의 혈압이 건강 상태를 무조건적으로 결정하지 않는다.

그러니 마르코프 가정(S<sub>t</sub> = h<sub>t</sub>)은 모든 것에 적용할 수는 없지만 매우 유용하다. 그리고 잘 하면 웬만한 건 다 마르코프 가정으로 만들 수 있다.

## Partial Observation
Partially observable Markov decision process(POMDP)

우리가 세상을 바라보면 세상은 관측값을 주는데, 에이전트는 세상에 대해 모든 정보를 가질 필요가 없다. 즉 에이전트는 세상을 부분적으로 관측한다(→ Partially observable).

에이전트의 상태는 정보를 일부만 갖고 있기 때문에 월드의 상태와 같기가 어렵다. 설명이 제대로 나오지는 않았는데 이 상황에서 S<sub>t</sub> = h<sub>t</sub>라고 믿기로 하는 걸 POMDP라고 하는 것 같다. 나중에 더 설명해 준댔음.

## Bandit
랜덤하게 고객에게 무언가를 추천하는 시스템이 있다고 치자. 고객이 온 순서는 필요한 정보가 아니다. 이처럼 이전에 무엇을 했는지 전혀 상관이 없는 시스템을 밴딧이라고 한다.

밴딧이 아닌 경우 sequential한 decision을 차근차근 만들어가고 이를 MDP라고 하는 것 같음.

## types of sequential decision process
봐야 할 것이 두 가지 있다.

* deterministic: 특정 상태가 있으면 어떤 행동을 할지 뻔한 것
* stochastic: 어떤 행동을 하게 될지 확률론적으로 접근하게 되는 것

예를 들어 주사위를 던져 내 행동을 결정하는 경우, 주사위의 눈에 따라 내 행동은 달라지고 각각 눈이 나올 확률이 존재한다. 이렇게 말하면 stochastic 같지만 결국 내 행동은 주사위 눈에 따라 정해져 있으므로 deterministic이라고 한다.

위 두 가지를 구분하는 것은 내가 어떤 행동을 충분히 모델링할 수 있는지 여부로 나뉜다. 주사위 눈에 따른 행동처럼 정해진 대로 구현이 가능하다면 deterministic, 사람이 인지할 수 없는 어떤 분포를 따라서 모델링하기 어렵고 확률에 의지해야만 한다면 stochastic이다.

## 강화학습
예를 들어 게 로봇을 바다에 던져서 해저 지형을 탐사한다고 치자. 이 로봇은 처음 낙하한 후 왼쪽 또는 오른쪽으로 갈 수 있다. 이 왼쪽/오른쪽으로 가는 것을 행동이라 한다. 행동에 따라 나타나는 결과(보석, 기름 등을 찾음)는 관측값, 그에 따른 성과(보석은 +10점, 기름은 +1점)가 보상이다.

월드는 1번 자리부터 7번 자리까지 있고, 로봇은 4번에서 시작한다. 1번에 기름, 7번에 보석이 있고 나머지는 아무것도 없다(즉각적인 보상이 없음).

강화학습은 model, policy, value function 세 가지로 구성된다.

### model
에이전트를 포함한 강화학습을 표현하는 방법

* Transition (dynamic) model: 행동에 대한 관측값으로 다음 상태를 예측함
* Reward model: 현재 상태와 행동으로 관측값을 받고, 리워드가 결정됨.

아까 말한 게 로봇 예시는 "잘못된 모델 예시"이다. 월드 상태는 아까와 똑같다. 주사위를 던져서 짝수가 나오면 오른쪽으로 가고 홀수가 나오면 왼쪽으로 간다고 하자. 1주차 강의자료 46페이지인데, 리워드가 전부 0인 게 문제다. 이거 아님.

### policy
보통 파이로 표시함. 에이전트가 어떻게 행동을 취할지를 의미함.

에이전트가 있고 월드가 있을 때 월드가 관측값과 보상을 주면 에이전트는 새로운 행동을 할 것이다. 에이전트 입장에서는 현재 상태로부터 다음 행동이 정해지는 것이다. 즉 경험이 행동이 된다는 말임.

게 로봇으로 예를 들어 항상 오른쪽으로 가게 만들었다고 치자. 이것이 이 로봇의 policy이고 이건 deterministic이다.

### value function
어떤 policy가 있을 때 이에 따라오는 가치를 구함. 책에서는 3.2, 3.3 참고하면 됨.

1주차 강의자료 49페이지 가운데 식 참고. E는 expected이고, r<sub>t</sub>는 현재의 보상이고, 나머지 r은 모두 미래의 보상이다. 현재 상태를 조건으로 지금부터 내가 얻을 수 있는 리워드를 다 합친 게 내 행동의 가치가 된다.

이 식에 감마가 있는데, 책에서는 이걸 discounting factor라고 한다. 이 값이 0이 되면 미래의 보상이 모두 0으로 날아가니 현재 보상만 남고, 이는 현재의 보상만 바라보고 살겠다는 뜻이 된다(근시안적인 모델이 됨). 감마가 1이 되면 미래 보상이 갈수록 커지기 때문에 미래 보상을 중시하게 된다. discounting factor는 0에서 1 사이로 정하는데, 0에 가까울수록 현재를 중시하고 1에 가까울수록 미래를 중시한다.

다시 게 로봇으로 돌아가서 discounting factor를 간단하게 0이라 놓고 보자. 각 상태마다 가치는 그 자리에 맞는 리워드로 계산하면 된다. 보석이 있는 곳은 10, 기름은 1, 나머지는 0으로.

## types of agents
* model-based: Explicit model. 외견상 모델.
* model-free: Explicit Value function and/or policy function. 외견상 가치 함수와 policy.

강의자료 52페이지는 강화학습을 구성하는 요소에 대해 유명한 자료이니 참고해보라.

## 책 예제 3.3 recycling robot
마르코프 의사 결정 과정(MDP)로 transition graph를 그리겠다.

빈 캔 줍는 로봇이 있는데, 캔을 탐색하여 줍고 다닐 수도 있고, 가만히 기다릴 수도 있다. 배터리가 없으면 충전해야 한다. 이 모델을 MDP로 그려보는 거다.

모델이 가질 수 있는 상태는 두 가지이다. 배터리가 높은 상태(high), 낮은 상태(low).

high 상태에서 캔을 탐색하기로 했다면 search라는 행동을 하는 것이고, 이 행동 후에 로봇의 상태는 high가 될 수도 있고 low가 될 수도 있다. 여기서 전자의 확률은 α, 후자는 1 - α이다.

low 상태에서 search를 한다면 이후 상태가 low일 확률은 β이고, 방전될 확률은 1 - β이다. 방전된 후에는 구조되고 high 상태로 충전되어 돌아온다.

직접 캔을 찾았을 때의 보상이 가만히 기다릴 때의 보상보다 크다.

high 상태에서 wait을 한다면 배터리는 떨어지지 않고 high 상태로 돌아간다. low 상태에서 wait한다면 low 상태로 돌아간다. 보상은 가만히 기다릴 때의 보상이 주어진다.

위 과정을 그래프로 그리면 됨.

## 다음 주
* policy evolution
